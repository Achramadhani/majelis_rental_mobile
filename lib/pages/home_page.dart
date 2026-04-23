import 'package:flutter/material.dart';

import '../models/outdoor_product.dart';
import '../models/registered_user.dart';
import '../widgets/bottom_navbar.dart';
import 'cart_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.currentUser,
    required this.onLogout,
  });

  final RegisteredUser currentUser;
  final VoidCallback onLogout;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = 'Semua';
  String _searchQuery = '';

  final List<String> _categories = const [
    'Semua',
    'Tenda',
    'Tas',
    'Pakaian',
    'Sepatu',
  ];

  final List<String> _categoryCards = const [
    'Tenda',
    'Tas',
    'Pakaian',
    'Sepatu',
  ];

  int _selectedNavIndex = 0;

  final List<OutdoorProduct> _products = [
    OutdoorProduct(
      id: '1',
      name: 'Summit V2 Ultralight',
      category: 'Tenda',
      location: 'Tenda Ultralight',
      pricePerDay: 120000,
      imageUrl:
          'https://images.unsplash.com/photo-1478131143081-80f7f84ca84d?auto=format&fit=crop&w=1000&q=80',
    ),
    OutdoorProduct(
      id: '2',
      name: 'Osprey Atmos 65',
      category: 'Tas',
      location: 'Tas Carrier',
      pricePerDay: 85000,
      imageUrl:
          'https://images.unsplash.com/photo-1622560480605-d83c853bc5c3?auto=format&fit=crop&w=1000&q=80',
    ),
    OutdoorProduct(
      id: '3',
      name: 'Lowa Renegade Mid',
      category: 'Sepatu',
      location: 'Sepatu Hiking',
      pricePerDay: 95000,
      imageUrl:
          'https://images.unsplash.com/photo-1520639888713-7851133b1ed0?auto=format&fit=crop&w=1000&q=80',
    ),
    OutdoorProduct(
      id: '4',
      name: 'Jetboil Flash System',
      category: 'Alat Masak',
      location: 'Alat Masak',
      pricePerDay: 45000,
      imageUrl:
          'https://images.unsplash.com/photo-1618397746666-63405ce5d015?auto=format&fit=crop&w=1000&q=80',
      available: false,
    ),
    OutdoorProduct(
      id: '5',
      name: 'BioLite SolarPanel 5+',
      category: 'Alat Masak',
      location: 'Power',
      pricePerDay: 30000,
      imageUrl:
          'https://images.unsplash.com/photo-1509391366360-2e959784a276?auto=format&fit=crop&w=1000&q=80',
      available: true,
    ),
    OutdoorProduct(
      id: '6',
      name: 'Petzl Swift RL 900',
      category: 'Pakaian',
      location: 'Headlamp',
      pricePerDay: 25000,
      imageUrl:
          'https://images.unsplash.com/photo-1621905251189-08b45249ff8c?auto=format&fit=crop&w=1000&q=80',
      available: true,
    ),
  ];

  late final Set<String> _favoriteIds;
  final List<OutdoorProduct> _cartItems = [];
  DateTime _rentalStart = DateTime.now();
  DateTime _rentalEnd = DateTime.now().add(const Duration(days: 3));
  String _selectedPaymentMethod = 'Midtrans Gateway';
  bool _agreementChecked = false;

  @override
  void initState() {
    super.initState();
    _favoriteIds = <String>{'2'};
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onNavItemSelected(int index) {
    setState(() {
      _selectedNavIndex = index;
    });
  }

  Widget _buildCurrentPage(
    List<OutdoorProduct> filtered,
    List<OutdoorProduct> newest,
  ) {
    switch (_selectedNavIndex) {
      case 1:
        return _buildInventoryPage(filtered);
      case 2:
        return _buildHistoryPage();
      case 3:
        return _buildSettingsPage();
      case 0:
      default:
        return _buildPageContent(filtered, newest);
    }
  }

  Widget _buildInventoryPage(List<OutdoorProduct> filtered) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Inventory',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF2D1D16),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Lihat semua barang open trip yang tersedia.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF7B655D),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          _buildGearSection(filtered),
        ],
      ),
    );
  }

  Widget _buildHistoryPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Riwayat',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF2D1D16),
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Belum ada riwayat sewa. Semua pesanan Anda akan muncul di sini setelah selesai.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF7B655D),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF2D1D16),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE8E0D8)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Profil Akun',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                Text('Nama: ${widget.currentUser.fullName}'),
                const SizedBox(height: 6),
                Text('Email: ${widget.currentUser.email}'),
                const SizedBox(height: 6),
                Text('Telepon: ${widget.currentUser.phone}'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: widget.onLogout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5A3B31),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Logout'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _products.where((product) {
      final categoryMatch =
          _selectedCategory == 'Semua' || product.category == _selectedCategory;
      final query = _searchQuery.trim().toLowerCase();
      final textMatch =
          query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query) ||
          product.location.toLowerCase().contains(query);
      return categoryMatch && textMatch;
    }).toList();

    final popular = filtered.take(4).toList();
    final newest = filtered.skip(filtered.length > 4 ? 4 : 0).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F3F1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewPadding.bottom + 100,
          ),
          child: _buildCurrentPage(filtered, newest),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: _buildFloatingCartButton(),
      bottomNavigationBar: SafeArea(
        top: false,
        child: BottomNavbar(
          currentIndex: _selectedNavIndex,
          onTap: _onNavItemSelected,
        ),
      ),
    );
  }

  Widget _buildPageContent(
    List<OutdoorProduct> filtered,
    List<OutdoorProduct> newest,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTopBar(),
        const SizedBox(height: 18),
        _buildHeroSection(),
        const SizedBox(height: 18),
        _buildCategorySection(),
        const SizedBox(height: 18),
        _buildHeadingSection(),
        const SizedBox(height: 16),
        _buildGearSection(filtered),
      ],
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF382B22),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF7B655D),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeadingSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'DATABASE AKTIF',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF7C665C),
              letterSpacing: 1.6,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'DAFTAR GEAR',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: Color(0xFF2D1D16),
            ),
          ),
          SizedBox(height: 6),
          Text(
            'UNIT STANDAR INDUSTRI TERKALIBRASI',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF7B655D),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF7F2),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE4D8D0)),
              ),
              child: const Text(
                'Urutkan',
                style: TextStyle(
                  color: Color(0xFF7B655D),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF3D2721),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Text(
              'Peringkat Popularitas',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGearSection(List<OutdoorProduct> products) {
    if (products.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: _buildEmptyState(),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 18,
          childAspectRatio: 0.58,
        ),
        itemBuilder: (context, index) {
          return _buildSmallProductCard(products[index]);
        },
      ),
    );
  }

  Widget _buildGearCard(OutdoorProduct product) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
            child: SizedBox(
              height: 190,
              width: double.infinity,
              child: Stack(
                children: [
                  Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  Positioned(
                    left: 12,
                    top: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        product.category.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name.toUpperCase(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF2D1D16),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rp ${_formatRupiah(product.pricePerDay)} / hari',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4C392E),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${product.location} • ${product.category}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7B655D),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _buildFeatureTag('Ringan'),
                    const SizedBox(width: 8),
                    _buildFeatureTag('Terbaru'),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _addToCart(product),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3D2721),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'MASUKKAN KE KERANJANG',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => _showProductDetails(product),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE5D9D1)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'LIHAT DETAIL',
                      style: TextStyle(
                        color: Color(0xFF4C392E),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F0EC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          color: Color(0xFF7B655D),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    String number,
    String title,
    String subtitle, {
    String? actionLabel,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: const Color(0xFF3D2721),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2D1D16),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF7B655D),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: () {
              _showHomeMessage('Fitur edit koleksi sedang dikembangkan.');
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF3D2721),
            ),
            child: Text(
              actionLabel,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
      ],
    );
  }

  Widget _buildTimelineCard(int durationDays) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildCheckDateCard(
                  label: 'CHECK-IN',
                  date: _formatShortDate(_rentalStart),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCheckDateCard(
                  label: 'CHECK-OUT',
                  date: _formatShortDate(_rentalEnd),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              const Icon(Icons.schedule, size: 18, color: Color(0xFF7B655D)),
              const SizedBox(width: 8),
              const Text(
                'Durasi Petualangan',
                style: TextStyle(fontSize: 12, color: Color(0xFF7B655D)),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4E9E3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '$durationDays HARI',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF4D2F24),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckDateCard({required String label, required String date}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F3EE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF7B655D),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 18,
                color: Color(0xFF4D2F24),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  date,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF2D1D16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<MapEntry<OutdoorProduct, int>> _groupedCartItems() {
    final grouped = <String, MapEntry<OutdoorProduct, int>>{};
    for (final item in _cartItems) {
      final current = grouped[item.id];
      if (current == null) {
        grouped[item.id] = MapEntry(item, 1);
      } else {
        grouped[item.id] = MapEntry(current.key, current.value + 1);
      }
    }
    return grouped.values.toList();
  }

  Widget _buildSelectedGearList(List<MapEntry<OutdoorProduct, int>> items) {
    return Column(
      children: items.map((entry) => _buildSelectedGearItem(entry)).toList(),
    );
  }

  Widget _buildSelectedGearItem(MapEntry<OutdoorProduct, int> entry) {
    final product = entry.key;
    final quantity = entry.value;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE7E1DC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              product.imageUrl,
              width: 96,
              height: 96,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SKU: ${product.id.toUpperCase()}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF7B655D),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF2D1D16),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${product.location} • ${product.category}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7B655D),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Color(0xFFDE9C5E)),
                    const SizedBox(width: 6),
                    const Text(
                      '4.1',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF4D2F24),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Per hari',
                      style: TextStyle(fontSize: 12, color: Color(0xFF7B655D)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildQuantityControl(product.id, quantity),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Rp',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF7B655D),
                          ),
                        ),
                        Text(
                          _formatRupiah(product.pricePerDay * quantity),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF2D1D16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          IconButton(
            onPressed: () => _removeFromCart(product.id),
            icon: const Icon(
              Icons.delete_outline,
              size: 22,
              color: Color(0xFF7B655D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityControl(String productId, int quantity) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F3EE),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: quantity > 1
                ? () => _changeCartQuantity(productId, -1)
                : null,
            icon: const Icon(Icons.remove, size: 18),
            color: quantity > 1
                ? const Color(0xFF3D2721)
                : const Color(0xFFB3A699),
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '$quantity',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          IconButton(
            onPressed: () => _changeCartQuantity(productId, 1),
            icon: const Icon(Icons.add, size: 18),
            color: const Color(0xFF3D2721),
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  void _changeCartQuantity(String productId, int delta) {
    setState(() {
      if (delta > 0) {
        final product = _products.firstWhere((item) => item.id == productId);
        _cartItems.add(product);
      } else {
        final index = _cartItems.indexWhere((item) => item.id == productId);
        if (index != -1) {
          _cartItems.removeAt(index);
        }
      }
    });
  }

  Widget _buildVerificationSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE7E1DC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputFieldLabel('Jenis Identitas'),
          const SizedBox(height: 8),
          _buildReadonlyField('KTP / IdentityCard'),
          const SizedBox(height: 14),
          _buildInputFieldLabel('Nomor Registrasi'),
          const SizedBox(height: 8),
          _buildReadonlyField('3207************'),
          const SizedBox(height: 16),
          _buildDocumentUploadCard(),
        ],
      ),
    );
  }

  Widget _buildDocumentUploadCard() {
    return GestureDetector(
      onTap: () {
        _showHomeMessage('Fitur unggah dokumen akan tersedia segera.');
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 28),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F3EE),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE4D8D0)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.cloud_upload_outlined,
              size: 28,
              color: Color(0xFF7B655D),
            ),
            SizedBox(height: 10),
            Text(
              'UNGGAH DOKUMEN VERIFIKASI',
              style: TextStyle(
                color: Color(0xFF3D2721),
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Format dukungan: JPG, PNG, PDF (Maks. 5MB)',
              style: TextStyle(fontSize: 12, color: Color(0xFF7B655D)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillingSummarySection({
    required int durationDays,
    required int rentalUnitCost,
    required int subtotalRental,
    required int insuranceCost,
    required int discount,
    required int totalCost,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE7E1DC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'RINCIAN PERHITUNGAN',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF7B655D),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow(
            'Biaya sewa/unit',
            'Rp ${_formatRupiah(rentalUnitCost)}',
          ),
          const SizedBox(height: 10),
          _buildSummaryRow('Durasi kontrak', '$durationDays Hari'),
          const SizedBox(height: 10),
          _buildSummaryRow(
            'Subtotal sewa',
            'Rp ${_formatRupiah(subtotalRental)}',
          ),
          const SizedBox(height: 10),
          _buildSummaryRow(
            'Asuransi proteksi gear',
            'Rp ${_formatRupiah(insuranceCost)}',
          ),
          const SizedBox(height: 10),
          _buildSummaryRow(
            'Potongan member (tier)',
            '-Rp ${_formatRupiah(discount)}',
          ),
          const Divider(height: 30, thickness: 1.1, color: Color(0xFFE4D8D0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TOTAL AKHIR',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2D1D16),
                ),
              ),
              Text(
                'Rp ${_formatRupiah(totalCost)}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2D1D16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Inclusive of all taxes',
            style: TextStyle(fontSize: 11, color: Color(0xFF7B655D)),
          ),
        ],
      ),
    );
  }

  Widget _buildFinalizeOrderButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _cartItems.isEmpty
            ? null
            : () {
                _showHomeMessage('Finalisasi pesanan berhasil diajukan.');
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3D2721),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: const Text(
          'FINALISASI PESANAN',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildEmptyCartNotice() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F3EE),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE4D8D0)),
      ),
      child: const Text(
        'Keranjang masih kosong. Tambahkan gear dari beranda untuk melihat ringkasannya di sini.',
        style: TextStyle(color: Color(0xFF7B655D), height: 1.5),
      ),
    );
  }

  Widget _buildDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Periode Penyewaan',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2D1D16),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildDateCard('Mulai', _formatShortDate(_rentalStart)),
            const SizedBox(width: 12),
            _buildDateCard('Selesai', _formatShortDate(_rentalEnd)),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F3EE),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE4D8D0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Durasi',
                      style: TextStyle(fontSize: 12, color: Color(0xFF7B655D)),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${_rentalEnd.difference(_rentalStart).inDays + 1} hari',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF2D1D16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F3EE),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE4D8D0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Color(0xFF7B655D)),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2D1D16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartInventorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Inventaris Gear',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF2D1D16),
          ),
        ),
        const SizedBox(height: 12),
        if (_cartItems.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F3EE),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE4D8D0)),
            ),
            child: const Text(
              'Keranjang kosong. Tambahkan gear untuk mulai melakukan konfigurasi.',
              style: TextStyle(color: Color(0xFF7B655D), height: 1.5),
            ),
          )
        else
          Column(
            children: _cartItems
                .map(
                  (product) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildCartItem(product),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }

  Widget _buildIdentitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Identitas & Jaminan',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF2D1D16),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInputFieldLabel('Jenis Identitas'),
                  _buildReadonlyField('KTP / SIM'),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInputFieldLabel('Nomor Identitas'),
                  _buildReadonlyField('3207 1234 5678 9012'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildInputFieldLabel('Alamat Pengiriman'),
        _buildReadonlyField('Jl. Pangeran Antasari No. 45, Bandung'),
      ],
    );
  }

  Widget _buildPaymentMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Metode Pembayaran',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF2D1D16),
          ),
        ),
        const SizedBox(height: 12),
        _buildPaymentOption(
          'Midtrans Gateway',
          'VA, Kartu Kredit, QRIS',
          _selectedPaymentMethod == 'Midtrans Gateway',
        ),
        const SizedBox(height: 12),
        _buildPaymentOption(
          'Tunai (COD)',
          'Bayar di Basecamp',
          _selectedPaymentMethod == 'Tunai (COD)',
        ),
      ],
    );
  }

  Widget _buildPaymentOption(String title, String subtitle, bool selected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = title;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF3D2721) : const Color(0xFFF7F3EE),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? const Color(0xFF3D2721) : const Color(0xFFE4D8D0),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: selected ? Colors.white : const Color(0xFF2D1D16),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: selected
                          ? Colors.white70
                          : const Color(0xFF7B655D),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? Colors.white : const Color(0xFF7B655D),
                  width: 1.8,
                ),
                color: selected ? Colors.white : Colors.transparent,
              ),
              child: selected
                  ? const Center(
                      child: Icon(
                        Icons.check,
                        size: 14,
                        color: Color(0xFF3D2721),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContractSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: _agreementChecked,
              onChanged: (value) {
                setState(() {
                  _agreementChecked = value ?? false;
                });
              },
            ),
            const Expanded(
              child: Text(
                'Saya menyetujui syarat dan ketentuan penyewaan gear sesuai kontrak.',
                style: TextStyle(color: Color(0xFF7B655D), height: 1.4),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F3EE),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE4D8D0)),
          ),
          child: const Text(
            'Dengan menyetujui, Anda menerima semua syarat sewa, tanggung jawab peralatan, dan proses pengembalian sesuai kebijakan kami.',
            style: TextStyle(color: Color(0xFF7B655D), height: 1.4),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _cartItems.isEmpty || !_agreementChecked
            ? null
            : () {
                _showHomeMessage('Pesanan Anda sedang diproses.');
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3D2721),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: const Text(
          'KONFIRMASI PENYEWAAN',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildInputFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 12,
        color: Color(0xFF7B655D),
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildReadonlyField(String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F3EE),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE4D8D0)),
      ),
      child: Text(value, style: const TextStyle(color: Color(0xFF2D1D16))),
    );
  }

  String _formatShortDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Widget _buildCartItem(OutdoorProduct product) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8E0D8)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              product.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D1D16),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rp ${_formatRupiah(product.pricePerDay)}/hari',
                  style: const TextStyle(color: Color(0xFF7B655D)),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _removeFromCart(product.id),
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: Color(0xFF7B655D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingCartButton() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => CartPage(
                  cartItems: _cartItems,
                  rentalStart: _rentalStart,
                  rentalEnd: _rentalEnd,
                  onRemoveItem: (id) => _removeFromCart(id),
                  onChangeQuantity: (id, delta) =>
                      _changeCartQuantity(id, delta),
                ),
              ),
            );
          },
          tooltip: 'Buka keranjang',
          backgroundColor: const Color(0xFF5A3B31),
          child: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
        ),
        if (_cartItems.isNotEmpty)
          Positioned(
            right: 0,
            top: -4,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xFFD14424),
                shape: BoxShape.circle,
              ),
              child: Text(
                '${_cartItems.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildOrderSidebar() {
    final subtotal = _cartItems.fold<int>(
      0,
      (sum, product) => sum + product.pricePerDay,
    );
    final serviceFee = subtotal * 5 ~/ 100;
    final total = subtotal + serviceFee;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFFBF8F4),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE1D7CE)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ringkasan Pesanan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2D1D16),
                ),
              ),
              const SizedBox(height: 14),
              _buildSummaryRow('Item', '${_cartItems.length}'),
              const SizedBox(height: 12),
              _buildSummaryRow(
                'Durasi',
                '${_rentalEnd.difference(_rentalStart).inDays + 1} hari',
              ),
              const SizedBox(height: 12),
              _buildSummaryRow('Subtotal', 'Rp ${_formatRupiah(subtotal)}'),
              const SizedBox(height: 12),
              _buildSummaryRow(
                'Biaya layanan',
                'Rp ${_formatRupiah(serviceFee)}',
              ),
              const Divider(
                height: 32,
                thickness: 1.2,
                color: Color(0xFFE4D8D0),
              ),
              _buildSummaryRow(
                'Total',
                'Rp ${_formatRupiah(total)}',
                bold: true,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _cartItems.isEmpty || !_agreementChecked
                      ? null
                      : () {
                          _showHomeMessage('Pesanan Anda sedang diproses.');
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3D2721),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'KONFIRMASI PENYEWAAN',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: const Color(0xFF7B655D),
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            color: const Color(0xFF2D1D16),
            fontWeight: bold ? FontWeight.w900 : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'MAJELIS RENTAL',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                color: Color(0xFF3D1F18),
              ),
            ),
          ),
          InkWell(
            onTap: _showNotifications,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF4E9E3),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.notifications_none,
                color: Color(0xFF4D2F24),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: _showProfileActionSheet,
            borderRadius: BorderRadius.circular(14),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xFF4D2F24),
              child: Text(
                _initials(widget.currentUser.fullName),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.14),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              SizedBox(
                height: 260,
                width: double.infinity,
                child: Image.network(
                  'https://images.unsplash.com/photo-1446776811953-b23d57bd21aa?auto=format&fit=crop&w=1200&q=80',
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                height: 260,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.14),
                      Colors.black.withOpacity(0.75),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 24,
                right: 24,
                top: 28,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'EKSPLORASI TANPA BATAS.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        height: 1.05,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Peralatan outdoor premium untuk petualangan Alpinis modern Anda.',
                      style: TextStyle(
                        color: Color(0xFFEADCCF),
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Color(0xFF7B655D)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value;
                                });
                              },
                              decoration: const InputDecoration(
                                hintText: 'Cari alat, brand...',
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: _onSearchPressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5A3B31),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                            child: const Text(
                              'CARI',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Transform.translate(
      offset: const Offset(0, -18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF3EFED),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(20),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 8),
              const Icon(Icons.search, color: Color(0xFF73645E)),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Cari alat, brand, atau jenis',
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              SizedBox(
                height: 38,
                child: ElevatedButton(
                  onPressed: _onSearchPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5A3B31),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  child: const Text(
                    'CARI',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'NAVIGASI',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF7C665C),
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'KATEGORI',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2D1D16),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              TextButton(
                onPressed: _onViewAllCategories,
                child: const Text(
                  'LIHAT SEMUA',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7B655D),
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _categoryCards.map((category) {
              final selected = _selectedCategory == category;
              return Expanded(
                child: GestureDetector(
                  onTap: () => _onSelectCategory(category),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFF5A3B31)
                          : const Color(0xFFF7F2EC),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFF6F4C3C)
                                : const Color(0xFFFAF7F2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            _iconByCategory(category),
                            color: selected
                                ? Colors.white
                                : const Color(0xFF5A3B31),
                            size: 22,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          category.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            color: selected
                                ? Colors.white
                                : const Color(0xFF5A3B31),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularSection(List<OutdoorProduct> products) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Koleksi Terpopuler',
            style: TextStyle(fontSize: 23 / 1.5, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          if (products.isEmpty)
            _buildEmptyState()
          else
            GridView.builder(
              itemCount: products.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.68,
              ),
              itemBuilder: (context, index) {
                return _buildProductCard(products[index]);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildPromoSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E1A19), Color(0xFF111111)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFD3A688),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'PENAWARAN TERBATAS',
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1,
                  color: Color(0xFF1B0F0B),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'PAKET RIDGE ELITE',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 38 / 1.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Lengkapi petualangan Anda dengan satu\nset peralatan kasta tertinggi.',
              style: TextStyle(color: Color(0xFFE7D8D1), height: 1.4),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF272322),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rp\n450rb',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34 / 1.5,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                      Text(
                        'PER 3 HARI',
                        style: TextStyle(
                          color: Color(0xFF9E8E87),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _onTakePromo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF5F2EF),
                        foregroundColor: const Color(0xFF1A1412),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: const Text(
                        'AMBIL\nPROMO',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1521459467264-802e2ef3141f?auto=format&fit=crop&w=1200&q=80',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewestSection(List<OutdoorProduct> products) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'BARU TERSEDIA',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                ),
              ),
              const Spacer(),
              _circleIconButton(Icons.chevron_left, _onPreviousNewest),
              const SizedBox(width: 6),
              _circleIconButton(Icons.chevron_right, _onNextNewest),
            ],
          ),
          const SizedBox(height: 12),
          if (products.isEmpty)
            _buildEmptyState()
          else
            SizedBox(
              height: 280,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return _buildSmallProductCard(product);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductCard(OutdoorProduct product) {
    final favorite = _favoriteIds.contains(product.id);
    return GestureDetector(
      onTap: () => _showProductDetails(product),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF2EEEB),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5DDDA)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    image: DecorationImage(
                      image: NetworkImage(product.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  right: 6,
                  top: 6,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (favorite) {
                          _favoriteIds.remove(product.id);
                        } else {
                          _favoriteIds.add(product.id);
                        }
                      });
                    },
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.white.withAlpha(230),
                      child: Icon(
                        favorite ? Icons.favorite : Icons.favorite_border,
                        size: 16,
                        color: const Color(0xFF67463A),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              product.location.toUpperCase(),
              style: const TextStyle(
                fontSize: 9,
                color: Color(0xFF8F8079),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF241A17),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Rp ${_formatRupiah(product.pricePerDay)}/malam',
              style: const TextStyle(fontSize: 12, color: Color(0xFF7B6B64)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallProductCard(OutdoorProduct product) {
    final isFavourite = _favoriteIds.contains(product.id);
    final statusLabel = product.available ? 'TERSEDIA' : 'PENUH';
    final statusColor = product.available
        ? Colors.black.withOpacity(0.65)
        : const Color(0xFFD14424);
    return GestureDetector(
      onTap: () => _showProductDetails(product),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              child: SizedBox(
                height: 150,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(product.imageUrl, fit: BoxFit.cover),
                    Positioned(
                      left: 12,
                      top: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          statusLabel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 12,
                      top: 12,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isFavourite) {
                              _favoriteIds.remove(product.id);
                            } else {
                              _favoriteIds.add(product.id);
                            }
                          });
                        },
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.white.withOpacity(0.92),
                          child: Icon(
                            isFavourite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: const Color(0xFF4D2F24),
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2D1D16),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Rp ${_formatRupiah(product.pricePerDay)} / HARI',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF4C392E),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: product.available
                            ? () => _quickAddToCart(product)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: product.available
                              ? const Color(0xFF5A3B31)
                              : const Color(0xFFB5A39B),
                          foregroundColor: Colors.white,
                          disabledForegroundColor: const Color(0xFF7B655D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          product.available ? 'SEWA' : 'PENUH',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton(
                        onPressed: product.available
                            ? () => _addToCart(product)
                            : null,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF5A3B31)),
                          foregroundColor: const Color(0xFF5A3B31),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'KERANJANG',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE8E4),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Text(
        'Produk tidak ditemukan untuk filter saat ini.',
        style: TextStyle(color: Color(0xFF7E706A)),
      ),
    );
  }

  Widget _circleIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: const Color(0xFFE9E2DE),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFDED2CC)),
        ),
        child: Icon(icon, size: 15, color: const Color(0xFF8D7B74)),
      ),
    );
  }

  void _showProductDetails(OutdoorProduct product) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: const Color(0xFFF8F5F3),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 4),
              Text('${product.category} • ${product.location}'),
              const SizedBox(height: 10),
              Text(
                'Harga sewa Rp ${_formatRupiah(product.pricePerDay)} per hari.',
                style: const TextStyle(color: Color(0xFF5F4E48)),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Tutup'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _addToCart(product);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5A3B31),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('MASUKKAN KE KERANJANG'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showProfileActionSheet() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: const Color(0xFFF8F5F3),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.currentUser.fullName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 2),
                Text(widget.currentUser.email),
                const SizedBox(height: 14),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.logout_rounded,
                    color: Color(0xFF7D3E35),
                  ),
                  title: const Text('Logout'),
                  onTap: () {
                    Navigator.pop(context);
                    widget.onLogout();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _iconByCategory(String category) {
    switch (category) {
      case 'Tenda':
        return Icons.terrain_outlined;
      case 'Tas':
        return Icons.shopping_bag_outlined;
      case 'Pakaian':
        return Icons.checkroom_outlined;
      case 'Sepatu':
        return Icons.hiking_outlined;
      default:
        return Icons.outdoor_grill_outlined;
    }
  }

  String _formatRupiah(int value) {
    final raw = value.toString();
    final result = StringBuffer();
    for (var i = 0; i < raw.length; i++) {
      final position = raw.length - i;
      result.write(raw[i]);
      if (position > 1 && position % 3 == 1) {
        result.write('.');
      }
    }
    return result.toString();
  }

  String _initials(String name) {
    final words = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();
    if (words.isEmpty) {
      return 'U';
    }
    if (words.length == 1) {
      return words.first.substring(0, 1).toUpperCase();
    }
    return (words[0][0] + words[1][0]).toUpperCase();
  }

  void _openHelpCenter() {
    Navigator.pop(context);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: const Color(0xFFF8F5F3),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Help Center',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
                SizedBox(height: 12),
                Text(
                  'Butuh bantuan? Hubungi support atau baca FAQ untuk solusi cepat.',
                  style: TextStyle(fontSize: 14, color: Color(0xFF7B655D)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openSettings() {
    Navigator.pop(context);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: const Color(0xFFF8F5F3),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Settings',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
                SizedBox(height: 12),
                Text(
                  'Sesuaikan notifikasi, bahasa, dan preferensi tampilan Anda.',
                  style: TextStyle(fontSize: 14, color: Color(0xFF7B655D)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showNotifications() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: const Color(0xFFF8F5F3),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Notifikasi',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
                SizedBox(height: 12),
                Text(
                  'Tidak ada notifikasi baru saat ini.',
                  style: TextStyle(fontSize: 14, color: Color(0xFF7B655D)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onSearchPressed() {
    FocusScope.of(context).unfocus();
    final query = _searchQuery.trim();
    _showHomeMessage(
      'Menampilkan hasil untuk "${query.isEmpty ? 'semua' : query}"',
    );
  }

  void _onViewAllCategories() {
    setState(() {
      _selectedCategory = 'Semua';
    });
    _showHomeMessage('Menampilkan semua kategori.');
  }

  void _onSelectCategory(String category) {
    setState(() {
      _selectedCategory = _selectedCategory == category ? 'Semua' : category;
    });
    _showHomeMessage(
      _selectedCategory == 'Semua'
          ? 'Filter kategori direset ke Semua.'
          : 'Kategori $category dipilih.',
    );
  }

  void _onTakePromo() {
    _showHomeMessage('Promo ridge elite berhasil ditambahkan ke pesanan.');
  }

  void _onPreviousNewest() {
    _showHomeMessage('Geser produk sebelumnya.');
  }

  void _onNextNewest() {
    _showHomeMessage('Geser produk berikutnya.');
  }

  void _quickAddToCart(OutdoorProduct product) {
    setState(() {
      _cartItems.add(product);
    });
    _showHomeMessage('${product.name} berhasil ditambahkan ke keranjang.');
  }

  void _addToCart(OutdoorProduct product) {
    _quickAddToCart(product);
  }

  void _removeFromCart(String productId) {
    setState(() {
      _cartItems.removeWhere((item) => item.id == productId);
    });
    _showHomeMessage('Produk dihapus dari keranjang.');
  }

  void _showHomeMessage(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: const Color(0xFF5A3B31),
          duration: const Duration(milliseconds: 1400),
        ),
      );
  }
}
