import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/outdoor_product.dart';

class CartPage extends StatefulWidget {
  const CartPage({
    super.key,
    required this.cartItems,
    required this.rentalStart,
    required this.rentalEnd,
    required this.onRemoveItem,
    required this.onChangeQuantity,
  });

  final List<OutdoorProduct> cartItems;
  final DateTime rentalStart;
  final DateTime rentalEnd;
  final ValueChanged<String> onRemoveItem;
  final void Function(String productId, int delta) onChangeQuantity;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final TextEditingController _registrationController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _ktpPhoto;
  XFile? _selfiePhoto;
  bool _agreementChecked = false;
  String _selectedIdentity = 'KTP (Kartu Tanda Penduduk)';
  String _selectedPayment = 'Midtrans Gateway';
  late DateTime _selectedCheckInDate;
  late DateTime _selectedCheckOutDate;

  bool get _isNikValid => _registrationController.text.trim().length == 16;
  bool get _hasKtpPhoto => _ktpPhoto != null;
  bool get _hasSelfiePhoto => _selfiePhoto != null;
  bool get _canFinalizeOrder =>
      _isNikValid && _hasKtpPhoto && _hasSelfiePhoto && _agreementChecked;

  @override
  void initState() {
    super.initState();
    _selectedCheckInDate = widget.rentalStart;
    _selectedCheckOutDate = widget.rentalEnd;
  }

  @override
  void dispose() {
    _registrationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groupedItems = _groupCartItems();
    final durationDays =
        _selectedCheckOutDate.difference(_selectedCheckInDate).inDays + 1;
    final rentalUnitCost = groupedItems.fold<int>(
      0,
      (sum, entry) => sum + entry.key.pricePerDay * entry.value,
    );
    final subtotalRental = rentalUnitCost * durationDays;
    const insuranceCost = 15000;
    const memberDiscount = 20000;
    final totalCost = subtotalRental + insuranceCost - memberDiscount;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F3F1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF2D1D16),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Keranjang',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Color(0xFF2D1D16),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                _buildTimelineSection(durationDays),
                const SizedBox(height: 24),
                _buildSectionHeader(
                  '01',
                  'INVENTARIS GEAR',
                  'Daftar gear yang sudah Anda pilih.',
                ),
                const SizedBox(height: 16),
                groupedItems.isEmpty
                    ? _buildEmptyCartNotice()
                    : _buildSelectedGearList(groupedItems),
                const SizedBox(height: 24),
                _buildSectionHeader(
                  '02',
                  'IDENTITAS & JAMINAN',
                  'Pastikan data identitas valid sebelum melanjutkan.',
                ),
                const SizedBox(height: 16),
                _buildVerificationSection(),
                const SizedBox(height: 8),
                if (!_canFinalizeOrder)
                  const Text(
                    'Pastikan Anda telah mengunggah foto KTP, selfie memegang KTP, mengisi NIK 16 digit, dan menyetujui kontrak sebelum finalisasi.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF7B655D),
                      height: 1.5,
                    ),
                  ),
                const SizedBox(height: 16),
                _buildSectionHeader(
                  '03',
                  'PERJANJIAN E-KONTRAK',
                  'Setujui syarat dan ketentuan digital.',
                ),
                const SizedBox(height: 16),
                _buildContractSection(),
                const SizedBox(height: 24),
                _buildSectionHeader(
                  '04',
                  'METODE PEMBAYARAN',
                  'Pilih metode pembayaran yang tersedia.',
                ),
                const SizedBox(height: 16),
                _buildPaymentMethodSection(),
                const SizedBox(height: 24),
                _buildBillingSummarySection(
                  durationDays: durationDays,
                  rentalUnitCost: rentalUnitCost,
                  subtotalRental: subtotalRental,
                  insuranceCost: insuranceCost,
                  discount: memberDiscount,
                  totalCost: totalCost,
                ),
                const SizedBox(height: 20),
                _buildFinalizeOrderButton(groupedItems.isEmpty),
                const SizedBox(height: 12),
                const Text(
                  'Dengan menekan tombol di atas, Anda menyetujui perjanjian pembayaran dan syarat layanan.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7B655D),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<MapEntry<OutdoorProduct, int>> _groupCartItems() {
    final grouped = <String, MapEntry<OutdoorProduct, int>>{};
    for (final product in widget.cartItems) {
      if (grouped.containsKey(product.id)) {
        final existing = grouped[product.id]!;
        grouped[product.id] = MapEntry(existing.key, existing.value + 1);
      } else {
        grouped[product.id] = MapEntry(product, 1);
      }
    }
    return grouped.values.toList();
  }

  Widget _buildTimelineSection(int durationDays) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Timeline Petualangan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2D1D16),
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Cek tanggal keberangkatan dan pengembalian agar rencana perjalanan tetap aman.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF7B655D),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildDateCard(
                  'CHECK-IN',
                  _formatShortDate(_selectedCheckInDate),
                  onTap: () => _selectRentalDate(isCheckIn: true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDateCard(
                  'CHECK-OUT',
                  _formatShortDate(_selectedCheckOutDate),
                  onTap: () => _selectRentalDate(isCheckIn: false),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateCard(String label, String date, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F1EF),
          borderRadius: BorderRadius.circular(18),
          border: onTap != null
              ? Border.all(color: const Color(0xFFE8E0D8))
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Color(0xFF7B655D),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF2D1D16),
                  ),
                ),
                if (onTap != null)
                  const Icon(
                    Icons.calendar_today,
                    size: 18,
                    color: Color(0xFF7B655D),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectRentalDate({required bool isCheckIn}) async {
    final initialDate = isCheckIn
        ? _selectedCheckInDate
        : _selectedCheckOutDate;
    final firstDate = isCheckIn ? DateTime.now() : _selectedCheckInDate;
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF5A3B31),
              onPrimary: Colors.white,
              onSurface: const Color(0xFF2D1D16),
            ),
            dialogBackgroundColor: const Color(0xFFF6F3F1),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;

    setState(() {
      if (isCheckIn) {
        _selectedCheckInDate = pickedDate;
        if (_selectedCheckOutDate.isBefore(pickedDate)) {
          _selectedCheckOutDate = pickedDate.add(const Duration(days: 1));
        }
      } else {
        _selectedCheckOutDate = pickedDate;
        if (_selectedCheckOutDate.isBefore(_selectedCheckInDate)) {
          _selectedCheckInDate = _selectedCheckOutDate;
        }
      }
    });
  }

  Widget _buildSectionHeader(String number, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFFBF3EC),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            number,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: Color(0xFF9C6C4C),
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
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2D1D16),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF7B655D),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCartNotice() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8E0D8)),
      ),
      child: const Text(
        'Keranjang kosong. Tambahkan gear untuk mulai membuat pesanan.',
        style: TextStyle(fontSize: 14, color: Color(0xFF7B655D), height: 1.5),
      ),
    );
  }

  Widget _buildSelectedGearList(List<MapEntry<OutdoorProduct, int>> items) {
    return Column(children: items.map(_buildGearItem).toList());
  }

  Widget _buildGearItem(MapEntry<OutdoorProduct, int> entry) {
    final product = entry.key;
    final quantity = entry.value;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8E0D8)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              product.imageUrl,
              width: 84,
              height: 84,
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
                const SizedBox(height: 6),
                Text(
                  'Rp ${_formatRupiah(product.pricePerDay)} / hari',
                  style: const TextStyle(color: Color(0xFF7B655D)),
                ),
                const SizedBox(height: 8),
                Text(
                  product.category,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7B655D),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  _buildQuantityButton(
                    icon: Icons.remove,
                    onTap: () {
                      widget.onChangeQuantity(product.id, -1);
                      setState(() {});
                    },
                    enabled: quantity > 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      quantity.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D1D16),
                      ),
                    ),
                  ),
                  _buildQuantityButton(
                    icon: Icons.add,
                    onTap: () {
                      widget.onChangeQuantity(product.id, 1);
                      setState(() {});
                    },
                  ),
                ],
              ),
              const SizedBox(height: 6),
              IconButton(
                onPressed: () {
                  widget.onRemoveItem(product.id);
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Produk dihapus dari keranjang.'),
                      duration: Duration(milliseconds: 1300),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Color(0xFF7B655D),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: enabled ? const Color(0xFF5A3B31) : const Color(0xFFE8E0D8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 18, color: Colors.white),
      ),
    );
  }

  Widget _buildVerificationSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8E0D8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            value: _selectedIdentity,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              filled: true,
              fillColor: const Color(0xFFF4F1EF),
            ),
            items: const [
              DropdownMenuItem(
                value: 'KTP (Kartu Tanda Penduduk)',
                child: Text('KTP (Kartu Tanda Penduduk)'),
              ),
              DropdownMenuItem(value: 'SIM', child: Text('SIM')),
              DropdownMenuItem(value: 'Paspor', child: Text('Paspor')),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedIdentity = value;
                });
              }
            },
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _registrationController,
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Masukkan 16 digit NIK',
              errorText: _registrationController.text.isEmpty
                  ? null
                  : _isNikValid
                  ? null
                  : 'NIK harus 16 digit',
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 18,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              filled: true,
              fillColor: const Color(0xFFF4F1EF),
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: _pickKtpImage,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5A3B31),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            ),
            icon: const Icon(Icons.camera_alt_outlined),
            label: Text(
              _hasKtpPhoto ? 'Foto KTP Terunggah' : 'Unggah Foto KTP',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 12),
          if (_hasKtpPhoto)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F1EF),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE8E0D8)),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(_ktpPhoto!.path),
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _ktpPhoto!.name,
                      style: const TextStyle(color: Color(0xFF7B655D)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          if (!_hasKtpPhoto)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'Foto KTP harus diunggah untuk melanjutkan.',
                style: TextStyle(color: Color(0xFFD43F3A), fontSize: 12),
              ),
            ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: _pickSelfieImage,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5A3B31),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            ),
            icon: const Icon(Icons.camera_alt_outlined),
            label: Text(
              _hasSelfiePhoto
                  ? 'Selfie KTP Terunggah'
                  : 'Unggah Selfie dengan KTP',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 12),
          if (_hasSelfiePhoto)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F1EF),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE8E0D8)),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(_selfiePhoto!.path),
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _selfiePhoto!.name,
                      style: const TextStyle(color: Color(0xFF7B655D)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          if (!_hasSelfiePhoto)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'Selfie dengan KTP harus diunggah untuk melanjutkan.',
                style: TextStyle(color: Color(0xFFD43F3A), fontSize: 12),
              ),
            ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F1EF),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE8E0D8)),
            ),
            child: Row(
              children: const [
                Icon(Icons.upload_file, color: Color(0xFF7B655D)),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Unggah Dokumen Verifikasi\nFormat JPG, PNG, atau PDF (Maks. 5MB)',
                    style: TextStyle(color: Color(0xFF7B655D)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContractSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8E0D8)),
      ),
      child: Column(
        children: [
          const Text(
            'Penyewa bertanggung jawab penuh atas segala kerusakan atau kehilangan peralatan yang disewa selama periode petualangan berlangsung. Kerusakan yang disebabkan oleh kelalaian pengguna akan dikenakan biaya perbaikan tambahan.',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF7B655D),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Checkbox(
                value: _agreementChecked,
                onChanged: (value) {
                  setState(() {
                    _agreementChecked = value ?? false;
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                activeColor: const Color(0xFF5A3B31),
              ),
              const Expanded(
                child: Text(
                  'Saya telah membaca dan menyetujui seluruh butir pakta integritas dan perjanjian digital di atas.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7B655D),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
          if (!_agreementChecked)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'Persetujuan e-kontrak diperlukan untuk melanjutkan finalisasi.',
                style: TextStyle(color: Color(0xFFD43F3A), fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Column(
      children: [
        _buildPaymentOption('Midtrans Gateway', 'VA, Kartu Kredit, QRIS'),
        const SizedBox(height: 12),
        _buildPaymentOption('Tunai (COD)', 'Bayar di Basecamp'),
      ],
    );
  }

  Widget _buildPaymentOption(String title, String description) {
    final selected = _selectedPayment == title;
    return GestureDetector(
      onTap: () => setState(() => _selectedPayment = title),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF4E9E3) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? const Color(0xFFB37D63) : const Color(0xFFE8E0D8),
          ),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: title,
              groupValue: _selectedPayment,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedPayment = value);
                }
              },
              activeColor: const Color(0xFF5A3B31),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D1D16),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF7B655D),
                    ),
                  ),
                ],
              ),
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8E0D8)),
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            'Base Price (${widget.cartItems.length} item)',
            'Rp ${_formatRupiah(rentalUnitCost)}',
          ),
          const SizedBox(height: 10),
          _buildSummaryRow('Durasi Petualangan', 'x $durationDays Hari'),
          const Divider(color: Color(0xFFE8E0D8), height: 28),
          _buildSummaryRow(
            'Subtotal Sewa',
            'Rp ${_formatRupiah(subtotalRental)}',
          ),
          const SizedBox(height: 10),
          _buildSummaryRow(
            'Asuransi Gear (SafeCamp)',
            'Rp ${_formatRupiah(insuranceCost)}',
          ),
          const SizedBox(height: 10),
          _buildSummaryRow(
            'Member Discount',
            '- Rp ${_formatRupiah(discount)}',
            valueColor: const Color(0xFF207A4A),
          ),
          const Divider(color: Color(0xFFE8E0D8), height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TOTAL AKHIR',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2D1D16),
                ),
              ),
              Text(
                'Rp ${_formatRupiah(totalCost)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2D1D16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'INCL. TAX',
              style: TextStyle(fontSize: 10, color: Color(0xFF7B655D)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    Color valueColor = const Color(0xFF2D1D16),
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Color(0xFF7B655D)),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildFinalizeOrderButton(bool disabled) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: disabled || !_canFinalizeOrder
            ? null
            : () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Finalisasi pesanan berhasil. Lanjutkan ke pembayaran.',
                    ),
                  ),
                );
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5A3B31),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: const Text(
          'Finalisasi Pesanan',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Future<void> _pickKtpImage() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1600,
      imageQuality: 80,
    );

    if (pickedFile == null) return;

    setState(() {
      _ktpPhoto = pickedFile;
    });
  }

  Future<void> _pickSelfieImage() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1600,
      imageQuality: 80,
    );

    if (pickedFile == null) return;

    setState(() {
      _selfiePhoto = pickedFile;
    });
  }

  String _formatShortDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatRupiah(int value) {
    final formatted = value.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+)'),
      (match) => '${match[1]}.',
    );
    return formatted;
  }
}
