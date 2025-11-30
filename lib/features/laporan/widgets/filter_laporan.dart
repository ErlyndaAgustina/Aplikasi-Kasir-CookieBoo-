import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef FilterAppliedCallback = void Function(FilterData filter);

class FilterData {
  final String periode;
  final DateTime? dariTanggal;
  final DateTime? sampaiTanggal;
  final String? tipeFilter;
  final String? produk;
  final String? pelangganMembership;

  FilterData({
    required this.periode,
    this.dariTanggal,
    this.sampaiTanggal,
    this.tipeFilter,
    this.produk,
    this.pelangganMembership,
  });

  @override
  String toString() {
    return 'FilterData(periode: $periode, dari: $dariTanggal, sampai: $sampaiTanggal, tipeFilter: $tipeFilter, produk: $produk, pelangganMembership: $pelangganMembership)';
  }
}

const double _kFieldHeight = 50.0;
const double _kBorderRadius = 12.0;
const Color _kCardBg = Colors.white;
const Color _kAccent = Color(0xFFD49E57);
const Color _kLabelColor = Color(0xFF444444);

class FilterLaporanCard extends StatefulWidget {
  final FilterAppliedCallback onFilterApplied;
  final FilterData? initialFilter;

  const FilterLaporanCard({
    super.key,
    required this.onFilterApplied,
    this.initialFilter,
  });

  @override
  State<FilterLaporanCard> createState() => _FilterLaporanCardState();
}

class _FilterLaporanCardState extends State<FilterLaporanCard> {
  String? _selectedPeriode;
  DateTime? _dariTanggal;
  DateTime? _sampaiTanggal;

  String? _selectedTipeFilter;
  String? _selectedProduk;
  String? _selectedPelangganMembership;

  final List<String> daftarPeriode = [
    "Harian (Hari Ini)",
    "Mingguan",
    "Bulanan",
    "Custom",
  ];

  final List<String> daftarTipeFilter = [
    "Semua Data",
    "Produk",
    "Pelanggan",
    "Membership",
  ];

  final List<String> daftarProduk = [
    "Monster Cookies",
    "Choco Chip Cookies",
    "Matcha Lotus",
    "Red Velvet Cookies",
  ];

  final List<String> daftarPelangganMembership = ["Platinum", "Gold", "Silver"];

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.initialFilter != null) {
      final f = widget.initialFilter!;
      _selectedPeriode = f.periode;
      _dariTanggal = f.dariTanggal;
      _sampaiTanggal = f.sampaiTanggal;
      _selectedTipeFilter = f.tipeFilter;
      _selectedProduk = f.produk;
      _selectedPelangganMembership = f.pelangganMembership;
    } else {
      _selectedPeriode = "Harian (Hari Ini)";
      final today = DateTime.now();
      _dariTanggal = today;
      _sampaiTanggal = today;
    }
  }

  Future<void> _pilihTanggal(BuildContext context, bool isDari) async {
    final initial = isDari
        ? (_dariTanggal ?? DateTime.now())
        : (_sampaiTanggal ?? DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: _kAccent,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isDari) {
          _dariTanggal = picked;
          if (_sampaiTanggal != null && _sampaiTanggal!.isBefore(picked)) {
            _sampaiTanggal = picked;
          }
        } else {
          _sampaiTanggal = picked;
          if (_dariTanggal != null && _dariTanggal!.isAfter(picked)) {
            _dariTanggal = picked;
          }
        }
      });
    }
  }

  void _terapkanFilter() {
    final periode = _selectedPeriode ?? "Semua Data";
    final data = FilterData(
      periode: periode,
      dariTanggal: _dariTanggal,
      sampaiTanggal: _sampaiTanggal,
      tipeFilter: _selectedTipeFilter,
      produk: _selectedProduk,
      pelangganMembership: _selectedPelangganMembership,
    );
    widget.onFilterApplied(data);
  }

  InputDecoration _inputDecoration({String? hint, bool lightBg = false}) {
    return InputDecoration(
      hintText: hint,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      filled: true,
      fillColor: lightBg ? const Color(0xFFF8F1E4) : Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_kBorderRadius),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_kBorderRadius),
        borderSide: BorderSide(color: _kAccent, width: 1.5),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: _kLabelColor,
        ),
      ),
    );
  }

  Widget _buildDropdownNullable({
    required String? value,
    required List<String> items,
    required String hint,
    required ValueChanged<String?> onChanged,
    bool lightBackground = false,
  }) {
    return SizedBox(
      height: _kFieldHeight,
      child: DropdownButtonFormField<String>(
        value: items.contains(value) ? value : null,
        isExpanded: true,
        decoration: _inputDecoration(hint: hint, lightBg: lightBackground),
        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
        items: items.map((it) {
          return DropdownMenuItem<String>(
            value: it,
            child: Text(it, overflow: TextOverflow.ellipsis),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDateBox({
    required DateTime? date,
    required String hint,
    VoidCallback? onTap,
  }) {
    final text = date != null ? DateFormat('dd/MM/yyyy').format(date) : hint;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(_kBorderRadius),
      child: Container(
        height: _kFieldHeight,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(_kBorderRadius),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  color: date != null ? Colors.black87 : Colors.grey.shade600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.calendar_month, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: _kCardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.filter_list, color: _kLabelColor),
                const SizedBox(width: 8),
                Text(
                  "Filter Laporan",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: _kLabelColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            _label("Periode Laporan"),
            _buildDropdownNullable(
              value: _selectedPeriode,
              items: daftarPeriode,
              hint: "Pilih Periode",
              onChanged: (val) {
                setState(() {
                  _selectedPeriode = val;
                  if (val == "Harian (Hari Ini)") {
                    final t = DateTime.now();
                    _dariTanggal = t;
                    _sampaiTanggal = t;
                  } else if (val == "Custom") {
                    _dariTanggal = null;
                    _sampaiTanggal = null;
                  }
                });
              },
            ),

            const SizedBox(height: 12),

            if (_selectedPeriode != "Harian (Hari Ini)") ...[
              Row(
                children: [
                  Expanded(child: _label("Dari Tanggal")),
                  const SizedBox(width: 8),
                  Expanded(child: _label("Sampai Tanggal")),
                ],
              ),

              Row(
                children: [
                  Expanded(
                    child: _buildDateBox(
                      date: _dariTanggal,
                      hint: "Dari",
                      onTap: () => _pilihTanggal(context, true),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildDateBox(
                      date: _sampaiTanggal,
                      hint: "Sampai",
                      onTap: () => _pilihTanggal(context, false),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
            ],

            _label("Tipe Filter"),
            _buildDropdownNullable(
              value: _selectedTipeFilter,
              items: daftarTipeFilter,
              hint: "Pilih Tipe Filter",
              onChanged: (val) => setState(() => _selectedTipeFilter = val),
            ),

            const SizedBox(height: 12),

            _label("Pilih Produk"),
            _buildDropdownNullable(
              value: _selectedProduk,
              items: daftarProduk,
              hint: "Pilih Produk (opsional)",
              lightBackground: true,
              onChanged: (val) => setState(() => _selectedProduk = val),
            ),

            const SizedBox(height: 12),

            _label("Pilih Pelanggan Membership"),
            _buildDropdownNullable(
              value: _selectedPelangganMembership,
              items: daftarPelangganMembership,
              hint: "Pilih Membership (opsional)",
              onChanged: (val) =>
                  setState(() => _selectedPelangganMembership = val),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: _terapkanFilter,
                child: const Text(
                  "Terapkan Filter",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
