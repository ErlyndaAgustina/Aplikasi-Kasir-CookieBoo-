class CartItem {
  final String name;
  final int quantity;
  final String priceDisplay;
  final int priceValue;
  final int? availableStock;

  CartItem({
    required this.name,
    required this.quantity,
    required this.priceDisplay,
    required this.priceValue,
    this.availableStock,
  });

  // 🔥 INI KUNCI SEMUANYA
  int get total => priceValue * quantity;
}
