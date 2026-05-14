import { UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { Test } from '@nestjs/testing';

import { LicenseService } from '../license/license.service';
import type { UserRow } from '../shop/shop-registry.service';
import { ShopRegistryService } from '../shop/shop-registry.service';
import { AuthService } from './auth.service';
import { LoginResponseFactory } from './login-response.factory';

describe('AuthService', () => {
  const sampleUser: UserRow = {
    id: 'u1',
    shop_id: 'dev',
    username: 'owner',
    password_hash: Buffer.alloc(32),
    is_shop_owner: true,
    deleted_at: null,
  };

  async function createService(
    registry: Pick<ShopRegistryService, 'verifyLogin'>,
  ) {
    const license = {
      recordTrialStartIfNeeded: jest.fn().mockResolvedValue(undefined),
      getStatusForShop: jest.fn().mockResolvedValue({
        status: 'trial_active',
        expires_at: '2099-01-01T00:00:00.000Z',
        server_now: '2026-01-01T00:00:00.000Z',
        last_successful_check_at: '2026-01-01T00:00:00.000Z',
      }),
    };
    const jwt = {
      signAsync: jest.fn().mockResolvedValue('jwt-test'),
    };
    const loginFactory = new LoginResponseFactory(
      jwt as unknown as JwtService,
      license as unknown as LicenseService,
    );
    const moduleRef = await Test.createTestingModule({
      providers: [
        AuthService,
        { provide: ShopRegistryService, useValue: registry },
        { provide: LoginResponseFactory, useValue: loginFactory },
      ],
    }).compile();
    return moduleRef.get(AuthService);
  }

  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('logs in when registry returns a user', async () => {
    const registry = {
      verifyLogin: jest.fn().mockResolvedValue(sampleUser),
    };
    const service = await createService(registry);
    const res = await service.login({
      username: 'owner',
      password: 'changeme',
      shop_id: 'dev',
    });
    expect(res.access_token).toBe('jwt-test');
    expect(registry.verifyLogin).toHaveBeenCalled();
  });

  it('rejects wrong password', async () => {
    const registry = {
      verifyLogin: jest.fn().mockResolvedValue(null),
    };
    const service = await createService(registry);
    await expect(
      service.login({ username: 'owner', password: 'wrong', shop_id: 'dev' }),
    ).rejects.toThrow(UnauthorizedException);
  });
});
