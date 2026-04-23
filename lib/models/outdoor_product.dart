class OutdoorProduct {
  OutdoorProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.location,
    required this.pricePerDay,
    required this.imageUrl,
    this.available = true,
  });

  final String id;
  final String name;
  final String category;
  final String location;
  final int pricePerDay;
  final String imageUrl;
  final bool available;
}
