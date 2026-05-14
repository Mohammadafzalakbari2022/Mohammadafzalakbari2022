import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';
import * as request from 'supertest';
import { AppModule } from './../src/app.module';

jest.setTimeout(30_000);

describe('AppController (e2e)', () => {
  let app: INestApplication;

  beforeEach(async () => {
    const prisma = new PrismaClient();
    await prisma.$executeRawUnsafe('TRUNCATE TABLE "shops" CASCADE');
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

  it('/shop/create (POST) returns JWT and /shop/users lists owner', async () => {
    const created = await request(app.getHttpServer())
      .post('/shop/create')
      .send({
        shop_name: 'E2E Tailor',
        owner_username: 'e2eowner',
        owner_password: 'e2eownerpass',
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
});
