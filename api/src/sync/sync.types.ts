/** Allowed `entity_type` on sync mutations (`plan-04` v1 scaffold). */
export const SYNC_ENTITY_TYPES = [
  'order',
  'customer',
  'payment',
  'notification',
  'measurement_type',
  'measurement_profile',
  'catalog_item',
  'task',
  'style_name',
  'style_part',
  'style_figure',
  'style_figure_text_option',
  'style_figure_size_option',
  'style_figure_preset',
  'fabric_name',
  'fabric_color',
  'shop_rent',
  'shop_rent_payment',
  'shop_expense',
] as const;

export type SyncEntityType = (typeof SYNC_ENTITY_TYPES)[number];

export type SyncOperation = 'upsert' | 'delete';

export type SyncPushResultStatus = 'accepted' | 'conflict' | 'rejected';

export interface SyncMutationInput {
  internal_id: string;
  entity_type: string;
  operation: string;
  client_updated_at: string;
  /** Present for `upsert`; omitted for `delete`. */
  data?: Record<string, unknown>;
}

export interface SyncPushRequestBody {
  mutations: SyncMutationInput[];
}

export interface SyncPushResultRow {
  internal_id: string;
  status: SyncPushResultStatus;
  message: string | null;
}

export interface SyncPushResponseBody {
  server_now: string;
  results: SyncPushResultRow[];
  next_cursor: string;
}

export interface SyncChangeRow {
  internal_id: string;
  entity_type: SyncEntityType;
  operation: SyncOperation;
  server_updated_at: string;
  data: Record<string, unknown>;
}

export interface SyncPullResponseBody {
  server_now: string;
  changes: SyncChangeRow[];
  next_cursor: string;
}
