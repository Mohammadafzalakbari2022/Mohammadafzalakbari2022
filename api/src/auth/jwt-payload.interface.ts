/** JWT access payload (`plan-04` shop-scoped session). */
export interface PrideAccessPayload {
  sub: string;
  shop_id: string;
  username: string;
  is_shop_owner: boolean;
}
