import { licenseStatusDtoFromRow } from './license-status.helper';

describe('licenseStatusDtoFromRow', () => {
  it('marks expired when past expires_at', () => {
    const now = new Date('2030-01-01T00:00:00.000Z');
    const dto = licenseStatusDtoFromRow(
      {
        statusStored: 'trial_active',
        expiresAt: new Date('2020-01-01T00:00:00.000Z'),
      },
      now,
    );
    expect(dto.status).toBe('expired');
    expect(dto.server_now).toBe(now.toISOString());
  });

  it('keeps trial_active before expiry', () => {
    const now = new Date('2026-01-01T00:00:00.000Z');
    const dto = licenseStatusDtoFromRow(
      {
        statusStored: 'trial_active',
        expiresAt: new Date('2099-01-01T00:00:00.000Z'),
      },
      now,
    );
    expect(dto.status).toBe('trial_active');
  });
});
