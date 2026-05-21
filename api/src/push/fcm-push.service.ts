import { Injectable, Logger, OnModuleInit } from '@nestjs/common';
import * as admin from 'firebase-admin';

/**
 * Firebase Cloud Messaging via service account JSON (`plan-22`).
 *
 * Set `FIREBASE_SERVICE_ACCOUNT_JSON` to the full JSON of a Firebase service account
 * (same as GOOGLE_APPLICATION_CREDENTIALS file content). If unset, push is disabled.
 */
@Injectable()
export class FcmPushService implements OnModuleInit {
  private readonly log = new Logger(FcmPushService.name);

  private ready = false;

  onModuleInit(): void {
    const raw = process.env.FIREBASE_SERVICE_ACCOUNT_JSON?.trim();
    if (!raw) {
      this.log.log(
        'FCM: FIREBASE_SERVICE_ACCOUNT_JSON not set (optional) — push delivery disabled.',
      );
      return;
    }
    try {
      const cred = JSON.parse(raw) as admin.ServiceAccount;
      if (!admin.apps.length) {
        admin.initializeApp({ credential: admin.credential.cert(cred) });
      }
      this.ready = true;
      this.log.log('FCM: Firebase Admin initialised.');
    } catch (e) {
      this.log.error(`FCM: invalid FIREBASE_SERVICE_ACCOUNT_JSON: ${String(e)}`);
    }
  }

  isConfigured(): boolean {
    return this.ready;
  }

  async sendMulticast(
    tokens: string[],
    title: string,
    body: string,
    data?: Record<string, string>,
  ): Promise<{ successCount: number; failureCount: number }> {
    if (!this.ready || tokens.length === 0) {
      return { successCount: 0, failureCount: 0 };
    }
    const messaging = admin.messaging();
    let successCount = 0;
    let failureCount = 0;
    for (let i = 0; i < tokens.length; i += 500) {
      const slice = tokens.slice(i, i + 500);
      const resp = await messaging.sendEachForMulticast({
        tokens: slice,
        notification: { title, body },
        data: data ?? {},
        android: { priority: 'high' },
      });
      successCount += resp.successCount;
      failureCount += resp.failureCount;
    }
    return { successCount, failureCount };
  }
}
