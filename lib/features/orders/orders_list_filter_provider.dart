import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'orders_list_filter.dart';

final ordersListFilterProvider =
    StateProvider<OrdersListFilter>((ref) => const OrdersListFilter());
