import { execSync } from 'node:child_process';
import { join } from 'node:path';

export default async function globalSetup(): Promise<void> {
  const url =
    process.env.DATABASE_URL ??
    'postgresql://pride:pride@127.0.0.1:5433/pride_api';
  process.env.DATABASE_URL = url;
  execSync('npx prisma migrate deploy', {
    cwd: join(__dirname, '..'),
    stdio: 'inherit',
    env: { ...process.env, DATABASE_URL: url },
  });
}
