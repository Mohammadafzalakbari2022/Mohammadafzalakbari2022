/// Local shop profile (plan-15) until multi-shop API exists.
class ShopProfile {
  const ShopProfile({
    required this.name,
    this.address,
    this.phone,
    this.notes,
  });

  final String name;
  final String? address;
  final String? phone;
  final String? notes;

  ShopProfile copyWith({
    String? name,
    String? address,
    String? phone,
    String? notes,
  }) {
    return ShopProfile(
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      notes: notes ?? this.notes,
    );
  }
}
