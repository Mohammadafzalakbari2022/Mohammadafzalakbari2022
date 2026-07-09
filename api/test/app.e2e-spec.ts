import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';
import { randomUUID } from 'crypto';
import request from 'supertest';
import { AppModule } from './../src/app.module';

jest.setTimeout(30_000);

/** Required on `POST /shop/create` since shop contact fields were added. */
const e2eShopRegistrationContact = {
  contact_whatsapp: '93700123456',
  contact_address: 'Kabul, Test District, Shop Street 1',
  contact_email: 'owner@example.com',
};

describe('AppController (e2e)', () => {
  let app: INestApplication;

  beforeEach(async () => {
    const prisma = new PrismaClient();
    await prisma.$executeRawUnsafe('TRUNCATE TABLE "shops" CASCADE');
    await prisma.$executeRawUnsafe(
      'TRUNCATE TABLE "subscription_payment_claims", "password_reset_requests", "shop_push_tokens", "admin_audit_logs", "activation_codes"',
    );
    await prisma.$executeRawUnsafe(
      'TRUNCATE TABLE "subscription_billing_config"',
    );
    await prisma.$disconnect();

    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    await app.init();
  });

  afterEach(async () => {
    await app.close();
  });

  it('/ (GET)', () => {
    return request(app.getHttpServer())
      .get('/')
      .expect(200)
      .expect('Hello World!');
  });

  it('/health (GET)', () => {
    return request(app.getHttpServer())
      .get('/health')
      .expect(200)
      .expect((res) => {
        expect(res.body).toMatchObject({ status: 'ok', service: 'pride-api' });
      });
  });

  it('/catalog/public (GET) 200 without auth', () => {
    return request(app.getHttpServer())
      .get('/catalog/public')
      .expect(200)
      .expect((res) => {
        expect(res.body).toMatchObject({
          schema_version: 1,
          items: [],
          catalog_sharing_default: true,
        });
      });
  });

  it('/license/status (GET) 401 without token', () => {
    return request(app.getHttpServer()).get('/license/status').expect(401);
  });

  it('/auth/login (POST) 200 with dev seed', () => {
    return request(app.getHttpServer())
      .post('/auth/login')
      .send({ username: 'owner', password: 'changeme', shop_id: 'dev' })
      .expect(200)
      .expect((res) => {
        expect(typeof res.body.access_token).toBe('string');
        expect(res.body.user.shop_id).toBe('dev');
        expect(res.body.license_snapshot.status).toBe('trial_active');
      });
  });

  it('/license/status (GET) 200 with JWT after login', async () => {
    const login = await request(app.getHttpServer())
      .post('/auth/login')
      .send({ username: 'owner', password: 'changeme', shop_id: 'dev' })
      .expect(200);
    const token = login.body.access_token as string;
    return request(app.getHttpServer())
      .get('/license/status')
      .set('Authorization', `Bearer ${token}`)
      .expect(200)
      .expect((res) => {
        const b = res.body;
        expect(b.status).toBe('trial_active');
        expect(typeof b.expires_at).toBe('string');
        expect(typeof b.server_now).toBe('string');
        expect(typeof b.last_successful_check_at).toBe('string');
        expect(b.last_successful_check_at).toBe(b.server_now);
      });
  });

  it('/license/redeem (POST) 200 with JWT', async () => {
    const login = await request(app.getHttpServer())
      .post('/auth/login')
      .send({ username: 'owner', password: 'changeme', shop_id: 'dev' })
      .expect(200);
    const token = login.body.access_token as string;
    return request(app.getHttpServer())
      .post('/license/redeem')
      .set('Authorization', `Bearer ${token}`)
      .send({ code: 'pilot-2026' })
      .expect(200)
      .expect((res) => {
        expect(res.body.status).toBe('active');
        expect(typeof res.body.expires_at).toBe('string');
      });
  });

  it('/license/redeem (POST) 400 empty code', async () => {
    const login = await request(app.getHttpServer())
      .post('/auth/login')
      .send({ username: 'owner', password: 'changeme', shop_id: 'dev' })
      .expect(200);
    const token = login.body.access_token as string;
    return request(app.getHttpServer())
      .post('/license/redeem')
      .set('Authorization', `Bearer ${token}`)
      .send({ code: '   ' })
      .expect(400);
  });

  it('/auth/login (POST) 401 bad password', () => {
    return request(app.getHttpServer())
      .post('/auth/login')
      .send({ username: 'owner', password: 'wrong', shop_id: 'dev' })
      .expect(401);
  });

  it('/shop/join (POST) matches login for dev seed', () => {
    return request(app.getHttpServer())
      .post('/shop/join')
      .send({ username: 'owner', password: 'changeme', shop_id: 'dev' })
      .expect(200)
      .expect((res) => {
        expect(typeof res.body.access_token).toBe('string');
        expect(res.body.user.shop_id).toBe('dev');
        expect(res.body.access_token.split('.')).toHaveLength(3);
      });
  });

  it('/shop/users (GET) 403 for POST/DELETE when not owner', async () => {
    const created = await request(app.getHttpServer())
      .post('/shop/create')
      .send({
        shop_name: 'Member Shop',
        owner_username: 'memowner',
        owner_password: 'memownerpass',
        ...e2eShopRegistrationContact,
      })
      .expect(200);
    const ownerToken = created.body.access_token as string;
    await request(app.getHttpServer())
      .post('/shop/users')
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ username: 'staff1', password: 'staff1pass' })
      .expect(201);
    const staffLogin = await request(app.getHttpServer())
      .post('/auth/login')
      .send({
        shop_id: created.body.user.shop_id,
        username: 'staff1',
        password: 'staff1pass',
      })
      .expect(200);
    const staffToken = staffLogin.body.access_token as string;
    await request(app.getHttpServer())
      .get('/shop/users')
      .set('Authorization', `Bearer ${staffToken}`)
      .expect(200)
      .expect((res) => {
        expect(res.body.length).toBeGreaterThanOrEqual(2);
      });
    await request(app.getHttpServer())
      .post('/shop/users')
      .set('Authorization', `Bearer ${staffToken}`)
      .send({ username: 'staff2', password: 'staff2pass' })
      .expect(403);
    await request(app.getHttpServer())
      .delete(`/shop/users/${created.body.user.id}`)
      .set('Authorization', `Bearer ${staffToken}`)
      .expect(403);
  });

  it('/auth/change-password (POST) updates password', async () => {
    const created = await request(app.getHttpServer())
      .post('/shop/create')
      .send({
        shop_name: 'Pwd Shop',
        owner_username: 'pwdowner',
        owner_password: 'oldpass1234',
        ...e2eShopRegistrationContact,
      })
      .expect(200);
    const token = created.body.access_token as string;
    const shopId = created.body.user.shop_id as string;
    await request(app.getHttpServer())
      .post('/auth/change-password')
      .set('Authorization', `Bearer ${token}`)
      .send({ current_password: 'oldpass1234', new_password: 'newpass5678' })
      .expect(200);
    await request(app.getHttpServer())
      .post('/auth/login')
      .send({
        shop_id: shopId,
        username: 'pwdowner',
        password: 'oldpass1234',
      })
      .expect(401);
    await request(app.getHttpServer())
      .post('/auth/login')
      .send({
        shop_id: shopId,
        username: 'pwdowner',
        password: 'newpass5678',
      })
      .expect(200);
  });

  it('/shop/create (POST) requires contact_whatsapp and contact_address', async () => {
    await request(app.getHttpServer())
      .post('/shop/create')
      .send({
        shop_name: 'No Contact',
        owner_username: 'ncowner',
        owner_password: 'ncownerpass',
      })
      .expect(400);
  });

  it('/shop/create (POST) returns JWT and /shop/users lists owner', async () => {
    const created = await request(app.getHttpServer())
      .post('/shop/create')
      .send({
        shop_name: 'E2E Tailor',
        owner_username: 'e2eowner',
        owner_password: 'e2eownerpass',
        ...e2eShopRegistrationContact,
      })
      .expect(200);
    const token = created.body.access_token as string;
    expect(token.split('.')).toHaveLength(3);
    return request(app.getHttpServer())
      .get('/shop/users')
      .set('Authorization', `Bearer ${token}`)
      .expect(200)
      .expect((res) => {
        expect(Array.isArray(res.body)).toBe(true);
        expect(res.body).toEqual(
          expect.arrayContaining([
            expect.objectContaining({
              username: 'e2eowner',
              is_shop_owner: true,
            }),
          ]),
        );
      });
  });

  it('/admin/me (GET) 401 without token', () => {
    return request(app.getHttpServer()).get('/admin/me').expect(401);
  });

  it('/admin/me (GET) 200 is_developer false for dev seed token', async () => {
    const login = await request(app.getHttpServer())
      .post('/auth/login')
      .send({ username: 'owner', password: 'changeme', shop_id: 'dev' })
      .expect(200);
    const token = login.body.access_token as string;
    return request(app.getHttpServer())
      .get('/admin/me')
      .set('Authorization', `Bearer ${token}`)
      .expect(200)
      .expect((res) => {
        expect(res.body).toEqual({ is_developer: false });
      });
  });

  it('/admin/audit-log (GET) 401 without token', () => {
    return request(app.getHttpServer()).get('/admin/audit-log').expect(401);
  });

  it('/admin/audit-log (GET) 403 for non-developer JWT', async () => {
    const login = await request(app.getHttpServer())
      .post('/auth/login')
      .send({ username: 'owner', password: 'changeme', shop_id: 'dev' })
      .expect(200);
    const token = login.body.access_token as string;
    return request(app.getHttpServer())
      .get('/admin/audit-log')
      .set('Authorization', `Bearer ${token}`)
      .expect(403);
  });

  it('/sync/push (POST) 401 without token', () => {
    return request(app.getHttpServer())
      .post('/sync/push')
      .send({ mutations: [] })
      .expect(401);
  });

  it('/sync/push (POST) 200 empty mutations with JWT', async () => {
    const login = await request(app.getHttpServer())
      .post('/auth/login')
      .send({ username: 'owner', password: 'changeme', shop_id: 'dev' })
      .expect(200);
    const token = login.body.access_token as string;
    return request(app.getHttpServer())
      .post('/sync/push')
      .set('Authorization', `Bearer ${token}`)
      .send({ mutations: [] })
      .expect(200)
      .expect((res) => {
        expect(res.body.results).toEqual([]);
        expect(typeof res.body.server_now).toBe('string');
        expect(typeof res.body.next_cursor).toBe('string');
      });
  });

  it('/sync/push (POST) 400 when mutations missing', async () => {
    const login = await request(app.getHttpServer())
      .post('/auth/login')
      .send({ username: 'owner', password: 'changeme', shop_id: 'dev' })
      .expect(200);
    const token = login.body.access_token as string;
    return request(app.getHttpServer())
      .post('/sync/push')
      .set('Authorization', `Bearer ${token}`)
      .send({})
      .expect(400);
  });

  it('/sync/pull (GET) 200 with JWT', async () => {
    const login = await request(app.getHttpServer())
      .post('/auth/login')
      .send({ username: 'owner', password: 'changeme', shop_id: 'dev' })
      .expect(200);
    const token = login.body.access_token as string;
    return request(app.getHttpServer())
      .get('/sync/pull')
      .set('Authorization', `Bearer ${token}`)
      .expect(200)
      .expect((res) => {
        expect(res.body.changes).toEqual([]);
        expect(typeof res.body.server_now).toBe('string');
        expect(typeof res.body.next_cursor).toBe('string');
        expect(res.body.next_cursor).toBe('0');
      });
  });

  it('/sync/push then pull returns persisted mutation', async () => {
    const login = await request(app.getHttpServer())
      .post('/auth/login')
      .send({ username: 'owner', password: 'changeme', shop_id: 'dev' })
      .expect(200);
    const token = login.body.access_token as string;
    const iso = new Date().toISOString();
    const push = await request(app.getHttpServer())
      .post('/sync/push')
      .set('Authorization', `Bearer ${token}`)
      .send({
        mutations: [
          {
            internal_id: 'order-e2e-1',
            entity_type: 'order',
            operation: 'upsert',
            client_updated_at: iso,
            data: { title: 'E2E' },
          },
        ],
      })
      .expect(200);
    expect(push.body.next_cursor).toBe('1');
    const pull = await request(app.getHttpServer())
      .get('/sync/pull?cursor=0')
      .set('Authorization', `Bearer ${token}`)
      .expect(200);
    expect(pull.body.changes).toHaveLength(1);
    expect(pull.body.changes[0]).toMatchObject({
      internal_id: 'order-e2e-1',
      entity_type: 'order',
      operation: 'upsert',
      data: { title: 'E2E' },
    });
    expect(pull.body.next_cursor).toBe('1');
  });

  it('/sync/pull (GET) 400 bad cursor', async () => {
    const login = await request(app.getHttpServer())
      .post('/auth/login')
      .send({ username: 'owner', password: 'changeme', shop_id: 'dev' })
      .expect(200);
    const token = login.body.access_token as string;
    return request(app.getHttpServer())
      .get('/sync/pull?cursor=xyz')
      .set('Authorization', `Bearer ${token}`)
      .expect(400);
  });

  it('/auth/password-reset-request (POST) 200', () => {
    return request(app.getHttpServer())
      .post('/auth/password-reset-request')
      .send({ shop_id: 'dev', username: 'owner' })
      .expect(200)
      .expect((res) => {
        expect(res.body).toMatchObject({ ok: true });
      });
  });

  it('/devices/push-token (POST) 401 without token', () => {
    return request(app.getHttpServer())
      .post('/devices/push-token')
      .send({ token: 'x', platform: 'android' })
      .expect(401);
  });

  it('/devices/push-token (POST) 200 with JWT', async () => {
    const login = await request(app.getHttpServer())
      .post('/auth/login')
      .send({ username: 'owner', password: 'changeme', shop_id: 'dev' })
      .expect(200);
    const token = login.body.access_token as string;
    return request(app.getHttpServer())
      .post('/devices/push-token')
      .set('Authorization', `Bearer ${token}`)
      .send({ token: 'fcm-e2e-token', platform: 'android' })
      .expect(200)
      .expect((res) => {
        expect(res.body).toMatchObject({ ok: true });
      });
  });

  it('/admin/shops (GET) 403 for non-developer JWT', async () => {
    const login = await request(app.getHttpServer())
      .post('/auth/login')
      .send({ username: 'owner', password: 'changeme', shop_id: 'dev' })
      .expect(200);
    const token = login.body.access_token as string;
    return request(app.getHttpServer())
      .get('/admin/shops')
      .set('Authorization', `Bearer ${token}`)
      .expect(403);
  });

  it('direct admin set-password without pending request', async () => {
    const prisma = new PrismaClient();
    try {
      const login = await request(app.getHttpServer())
        .post('/auth/login')
        .send({ username: 'owner', password: 'changeme', shop_id: 'dev' })
        .expect(200);
      const token = login.body.access_token as string;
      const owner = await prisma.shopUser.findFirstOrThrow({
        where: { shopId: 'dev', username: 'owner', deletedAt: null },
      });
      const prev = process.env.PRIDE_DEVELOPER_IDS;
      process.env.PRIDE_DEVELOPER_IDS = owner.id;
      try {
        await request(app.getHttpServer())
          .post(`/admin/shops/dev/users/${owner.id}/set-password`)
          .set('Authorization', `Bearer ${token}`)
          .send({ new_password: 'support-reset-99' })
          .expect(200)
          .expect((res) => {
            expect(res.body.ok).toBe(true);
            expect(res.body.username).toBe('owner');
          });

        await request(app.getHttpServer())
          .post('/auth/login')
          .send({
            username: 'owner',
            password: 'support-reset-99',
            shop_id: 'dev',
          })
          .expect(200);

        await request(app.getHttpServer())
          .post(`/admin/shops/dev/users/${owner.id}/set-password`)
          .set('Authorization', `Bearer ${token}`)
          .send({ new_password: 'changeme' })
          .expect(200);
      } finally {
        process.env.PRIDE_DEVELOPER_IDS = prev;
      }
    } finally {
      await prisma.$disconnect();
    }
  });

  it('/admin/password-reset-requests (GET) 403 for non-developer JWT', async () => {
    const login = await request(app.getHttpServer())
      .post('/auth/login')
      .send({ username: 'owner', password: 'changeme', shop_id: 'dev' })
      .expect(200);
    const token = login.body.access_token as string;
    return request(app.getHttpServer())
      .get('/admin/password-reset-requests')
      .set('Authorization', `Bearer ${token}`)
      .expect(403);
  });

  it('/license/redeem (POST) 400 unknown code', async () => {
    const login = await request(app.getHttpServer())
      .post('/auth/login')
      .send({ username: 'owner', password: 'changeme', shop_id: 'dev' })
      .expect(200);
    const token = login.body.access_token as string;
    return request(app.getHttpServer())
      .post('/license/redeem')
      .set('Authorization', `Bearer ${token}`)
      .send({ code: 'not-a-valid-pride-code' })
      .expect(400);
  });

  it('/license/redeem (POST) 200 with DB activation code', async () => {
    const prisma = new PrismaClient();
    try {
      const login = await request(app.getHttpServer())
        .post('/auth/login')
        .send({ username: 'owner', password: 'changeme', shop_id: 'dev' })
        .expect(200);
      const token = login.body.access_token as string;
      await prisma.activationCode.create({
        data: {
          id: randomUUID(),
          code: 'E2E-AC-STATIC',
          status: 'active',
          maxUses: 1,
          usesCount: 0,
          planDays: 30,
        },
      });
      return request(app.getHttpServer())
        .post('/license/redeem')
        .set('Authorization', `Bearer ${token}`)
        .send({ code: 'E2E-AC-STATIC' })
        .expect(200)
        .expect((res) => {
          expect(res.body.status).toBe('active');
        });
    } finally {
      await prisma.$disconnect();
    }
  });

  it('/admin/stats (GET) 403 for non-developer JWT', async () => {
    const login = await request(app.getHttpServer())
      .post('/auth/login')
      .send({ username: 'owner', password: 'changeme', shop_id: 'dev' })
      .expect(200);
    const token = login.body.access_token as string;
    return request(app.getHttpServer())
      .get('/admin/stats')
      .set('Authorization', `Bearer ${token}`)
      .expect(403);
  });

  it('/admin/stats (GET) 200 for developer JWT', async () => {
    const prisma = new PrismaClient();
    try {
      const login = await request(app.getHttpServer())
        .post('/auth/login')
        .send({ username: 'owner', password: 'changeme', shop_id: 'dev' })
        .expect(200);
      const token = login.body.access_token as string;
      const owner = await prisma.shopUser.findFirstOrThrow({
        where: { shopId: 'dev', username: 'owner', deletedAt: null },
      });
      const prev = process.env.PRIDE_DEVELOPER_IDS;
      process.env.PRIDE_DEVELOPER_IDS = owner.id;
      try {
        await request(app.getHttpServer())
          .get('/admin/stats')
          .set('Authorization', `Bearer ${token}`)
          .expect(200)
          .expect((res) => {
            expect(typeof res.body.shop_count).toBe('number');
            expect(res.body.shop_count).toBeGreaterThanOrEqual(1);
          });
      } finally {
        process.env.PRIDE_DEVELOPER_IDS = prev;
      }
    } finally {
      await prisma.$disconnect();
    }
  });

  it('/admin/activation-codes (POST) 200 creates code for developer', async () => {
    const prisma = new PrismaClient();
    try {
      const login = await request(app.getHttpServer())
        .post('/auth/login')
        .send({ username: 'owner', password: 'changeme', shop_id: 'dev' })
        .expect(200);
      const token = login.body.access_token as string;
      const owner = await prisma.shopUser.findFirstOrThrow({
        where: { shopId: 'dev', username: 'owner', deletedAt: null },
      });
      const prev = process.env.PRIDE_DEVELOPER_IDS;
      process.env.PRIDE_DEVELOPER_IDS = owner.id;
      try {
        const res = await request(app.getHttpServer())
          .post('/admin/activation-codes')
          .set('Authorization', `Bearer ${token}`)
          .send({ plan_days: 90, max_uses: 2 })
          .expect(200);
        expect(typeof res.body.code).toBe('string');
        expect(res.body.code).toMatch(/^PRIDE-/);
      } finally {
        process.env.PRIDE_DEVELOPER_IDS = prev;
      }
    } finally {
      await prisma.$disconnect();
    }
  });

  it('/license/billing-info (GET) 404 when unpublished', async () => {
    const login = await request(app.getHttpServer())
      .post('/auth/login')
      .send({ username: 'owner', password: 'changeme', shop_id: 'dev' })
      .expect(200);
    const token = login.body.access_token as string;
    return request(app.getHttpServer())
      .get('/license/billing-info')
      .set('Authorization', `Bearer ${token}`)
      .expect(404);
  });

  it('/admin/billing-info (GET) returns defaults when config row missing', async () => {
    const prisma = new PrismaClient();
    try {
      await prisma.$executeRawUnsafe(
        'TRUNCATE TABLE "subscription_billing_config"',
      );
      const login = await request(app.getHttpServer())
        .post('/auth/login')
        .send({ username: 'owner', password: 'changeme', shop_id: 'dev' })
        .expect(200);
      const token = login.body.access_token as string;
      const owner = await prisma.shopUser.findFirstOrThrow({
        where: { shopId: 'dev', username: 'owner', deletedAt: null },
      });
      const prev = process.env.PRIDE_DEVELOPER_IDS;
      process.env.PRIDE_DEVELOPER_IDS = owner.id;
      try {
        await request(app.getHttpServer())
          .get('/admin/billing-info')
          .set('Authorization', `Bearer ${token}`)
          .expect(200)
          .expect((res) => {
            expect(res.body.is_published).toBe(false);
            expect(res.body.schema_version).toBe(2);
          });
      } finally {
        process.env.PRIDE_DEVELOPER_IDS = prev;
      }
    } finally {
      await prisma.$disconnect();
    }
  });

  it('/admin/billing-info (POST) 403 for non-developer JWT', async () => {
    const login = await request(app.getHttpServer())
      .post('/auth/login')
      .send({ username: 'owner', password: 'changeme', shop_id: 'dev' })
      .expect(200);
    const token = login.body.access_token as string;
    return request(app.getHttpServer())
      .post('/admin/billing-info')
      .set('Authorization', `Bearer ${token}`)
      .send({ is_published: true })
      .expect(403);
  });

  it('billing publish, claim submit, and approve flow', async () => {
    const prisma = new PrismaClient();
    try {
      const login = await request(app.getHttpServer())
        .post('/auth/login')
        .send({ username: 'owner', password: 'changeme', shop_id: 'dev' })
        .expect(200);
      const token = login.body.access_token as string;
      const owner = await prisma.shopUser.findFirstOrThrow({
        where: { shopId: 'dev', username: 'owner', deletedAt: null },
      });
      const prev = process.env.PRIDE_DEVELOPER_IDS;
      process.env.PRIDE_DEVELOPER_IDS = owner.id;
      try {
        const tinyPng = Buffer.from([
          0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a,
        ]);
        await request(app.getHttpServer())
          .post('/admin/billing-info')
          .set('Authorization', `Bearer ${token}`)
          .send({
            is_published: true,
            settings_image_base64: tinyPng.toString('base64'),
            settings_image_mime_type: 'image/png',
          })
          .expect(200)
          .expect((res) => {
            expect(res.body.schema_version).toBe(2);
            expect(res.body.has_settings_image).toBe(true);
          });

        await request(app.getHttpServer())
          .get('/license/billing-info')
          .set('Authorization', `Bearer ${token}`)
          .expect(200)
          .expect((res) => {
            expect(res.body.is_published).toBe(true);
            expect(res.body.schema_version).toBe(2);
            expect(res.body.has_settings_image).toBe(true);
          });

        const claim = await request(app.getHttpServer())
          .post('/license/payment-claims')
          .set('Authorization', `Bearer ${token}`)
          .send({
            plan_tier: 'one_year',
            transaction_id: 'HP-E2E-001',
          })
          .expect(200);
        expect(claim.body.status).toBe('pending');

        const approved = await request(app.getHttpServer())
          .post(`/admin/payment-claims/${claim.body.id}/approve`)
          .set('Authorization', `Bearer ${token}`)
          .send({ auto_create_code: true })
          .expect(200);
        expect(approved.body.status).toBe('approved');
        expect(typeof approved.body.activation_code).toBe('string');
      } finally {
        process.env.PRIDE_DEVELOPER_IDS = prev;
      }
    } finally {
      await prisma.$disconnect();
    }
  });

  it('/license/payment-claims (POST) 403 for non-owner', async () => {
    const prisma = new PrismaClient();
    try {
      const owner = await prisma.shopUser.findFirstOrThrow({
        where: { shopId: 'dev', username: 'owner', deletedAt: null },
      });
      await prisma.subscriptionBillingConfig.upsert({
        where: { id: 'default' },
        create: {
          id: 'default',
          isPublished: true,
          paymentSteps: {},
          activationDeliverySteps: {},
          cashPaymentNote: {},
          price1YearAfn: 100,
        },
        update: { isPublished: true, price1YearAfn: 100 },
      });
      const staffId = randomUUID();
      await prisma.shopUser.create({
        data: {
          id: staffId,
          shopId: 'dev',
          username: 'staff_e2e',
          passwordHash: owner.passwordHash,
          isShopOwner: false,
        },
      });
      const login = await request(app.getHttpServer())
        .post('/auth/login')
        .send({ username: 'staff_e2e', password: 'changeme', shop_id: 'dev' })
        .expect(200);
      const token = login.body.access_token as string;
      await request(app.getHttpServer())
        .post('/license/payment-claims')
        .set('Authorization', `Bearer ${token}`)
        .send({ plan_tier: 'one_year', transaction_id: 'HP-STAFF-001' })
        .expect(403);
    } finally {
      await prisma.$disconnect();
    }
  });

  it('/admin/audit-log (GET) 200 returns rows for developer', async () => {
    const prisma = new PrismaClient();
    try {
      const login = await request(app.getHttpServer())
        .post('/auth/login')
        .send({ username: 'owner', password: 'changeme', shop_id: 'dev' })
        .expect(200);
      const token = login.body.access_token as string;
      const owner = await prisma.shopUser.findFirstOrThrow({
        where: { shopId: 'dev', username: 'owner', deletedAt: null },
      });
      const prev = process.env.PRIDE_DEVELOPER_IDS;
      process.env.PRIDE_DEVELOPER_IDS = owner.id;
      try {
        await request(app.getHttpServer())
          .post('/admin/activation-codes')
          .set('Authorization', `Bearer ${token}`)
          .send({ plan_days: 14, max_uses: 1 })
          .expect(200);

        await request(app.getHttpServer())
          .get('/admin/audit-log')
          .set('Authorization', `Bearer ${token}`)
          .expect(200)
          .expect((res) => {
            expect(res.body.schema_version).toBe(2);
            expect(Array.isArray(res.body.rows)).toBe(true);
            expect(res.body.rows.length).toBeGreaterThanOrEqual(1);
            expect(res.body.rows[0].action).toBeDefined();
          });
      } finally {
        process.env.PRIDE_DEVELOPER_IDS = prev;
      }
    } finally {
      await prisma.$disconnect();
    }
  });
});
