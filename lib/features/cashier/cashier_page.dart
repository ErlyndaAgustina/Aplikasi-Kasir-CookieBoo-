import 'package:flutter/material.dart';
import 'package:project_5_aplikasi_kasir_cookiesboo/features/cashier/widgets/struk.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../cashier/widgets/cashier_header.dart';
import '../cashier/widgets/customer_info_card.dart';
import '../cashier/widgets/cashier_produk.dart';
import '../cashier/widgets/cashier_cart.dart';
import '../cashier/models/cart_item.dart';

class CashierPage extends StatefulWidget {
  final VoidCallback onMenuTap;

  const CashierPage({super.key, required this.onMenuTap});

  @override
  State<CashierPage> createState() => _CashierPageState();
}

class _CashierPageState extends State<CashierPage> {
  final _supabase = Supabase.instance.client;
  List<CartItem> items = [];
  Map<String, int> productStocks = {}; // Menyimpan stok produk berdasarkan nama

  String paymentMethod = "cash";
  double discountRate = 0.0;
  String customerName = "-";
  String? customerMembership;
  String? selectedMemberId;
  int paidAmount = 0;
  int changeAmount = 0;

  @override
  void initState() {
    super.initState();
    _loadProductStocks();
    _subscribeToStockChanges();
  }

  Future<void> _loadProductStocks() async {
    try {
      final response = await _supabase
          .from('produk')
          .select('nama_produk, stok');

      setState(() {
        productStocks = {
          for (var item in response)
            item['nama_produk'] as String:
                int.tryParse(item['stok']?.toString() ?? '0') ?? 0,
        };

        // 🔥 SINKRONKAN CART ITEMS
        items = items.map((item) {
          final updatedStock = productStocks[item.name] ?? 0;
          return CartItem(
            name: item.name,
            quantity: item.quantity,
            priceDisplay: item.priceDisplay,
            priceValue: item.priceValue,
            availableStock: updatedStock,
          );
        }).toList();
      });
    } catch (e) {
      debugPrint('Error loading product stocks: $e');
    }
  }

  void _subscribeToStockChanges() {
    _supabase
        .channel('produk_stock_realtime')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'produk',
          callback: (payload) {
            _loadProductStocks();
          },
        )
        .subscribe();
  }

  @override
  void dispose() {
    _supabase.removeChannel(_supabase.channel('produk_stock_realtime'));
    super.dispose();
  }

  void _updateDiscountRate(double value) {
    setState(() {
      discountRate = value.clamp(0.0, 1.0);
    });
  }

  int _parsePrice(String priceText) {
    final clean = priceText
        .replaceAll("Rp", "")
        .replaceAll(".", "")
        .replaceAll(" ", "")
        .trim();
    return int.tryParse(clean) ?? 0;
  }

  void _handleAddToCart(Map<String, String> product) {
    final name = product["name"] ?? "";
    final priceDisplay = product["price"] ?? "Rp 0";
    final priceValue = _parsePrice(priceDisplay);
    final availableStock = productStocks[name] ?? 0;

    if (name.isEmpty || priceValue <= 0) return;

    // Cek apakah stok tersedia
    if (availableStock <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Stok $name habis'),
          backgroundColor: const Color.fromRGBO(212, 24, 61, 1),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      final index = items.indexWhere((item) => item.name == name);

      if (index == -1) {
        // Tambah item baru
        items.add(
          CartItem(
            name: name,
            quantity: 1,
            priceDisplay: priceDisplay,
            priceValue: priceValue,
            availableStock: availableStock,
          ),
        );
      } else {
        // Item sudah ada, cek apakah masih bisa tambah
        final existingItem = items[index];
        if (existingItem.quantity < availableStock) {
          items[index] = CartItem(
            name: existingItem.name,
            quantity: existingItem.quantity + 1,
            priceDisplay: existingItem.priceDisplay,
            priceValue: existingItem.priceValue,
            availableStock: availableStock,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Stok $name tidak mencukupi'),
              backgroundColor: const Color.fromRGBO(245, 158, 11, 1),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    });
  }

  void _onPaidAmountChanged(int value, int total) {
    setState(() {
      paidAmount = value;
      changeAmount = value - total;
    });
  }

  void _onIncrease(int index) {
    setState(() {
      final item = items[index];
      final availableStock = productStocks[item.name] ?? 0;

      if (item.quantity < availableStock) {
        items[index] = CartItem(
          name: item.name,
          quantity: item.quantity + 1,
          priceDisplay: item.priceDisplay,
          priceValue: item.priceValue,
          availableStock: availableStock,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Stok ${item.name} maksimal ${availableStock} Box'),
            backgroundColor: const Color.fromRGBO(245, 158, 11, 1),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }

  void _onDecrease(int index) {
    setState(() {
      final item = items[index];
      final availableStock = productStocks[item.name] ?? 0;

      if (item.quantity > 1) {
        items[index] = CartItem(
          name: item.name,
          quantity: item.quantity - 1,
          priceDisplay: item.priceDisplay,
          priceValue: item.priceValue,
          availableStock: availableStock,
        );
      } else {
        items.removeAt(index);
      }
    });
  }

  void _onDelete(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  void _onSelectPayment(String method) {
    setState(() {
      paymentMethod = method;
    });
  }

  Future<void> _onConfirm() async {
    if (items.isEmpty) return;

    final user = _supabase.auth.currentUser;
    if (user == null) return;

    String? pelangganId;

    // 1️⃣ NON-MEMBER → insert pelanggan
    if (selectedMemberId == null && customerName != "-") {
      final pelangganRes = await _supabase
          .from('pelanggan')
          .insert({'nama': customerName, 'membership': 'non_member'})
          .select('id')
          .single();

      pelangganId = pelangganRes['id'];
    }
    // 2️⃣ MEMBER → pakai ID existing
    else {
      pelangganId = selectedMemberId;
    }

    // 3️⃣ Hitung transaksi
    final subtotal = items.fold<num>(
      0,
      (sum, item) => sum + (item.priceValue * item.quantity),
    );
    final diskon = subtotal * discountRate;
    final pajak = (subtotal - diskon) * 0.10;
    final total = subtotal - diskon + pajak;

    final noTransaksi = "INV-${DateTime.now().millisecondsSinceEpoch}";

    // 4️⃣ Insert transaksi
    final transaksi = await _supabase
        .from('transaksi')
        .insert({
          'no_transaksi': noTransaksi,
          'pelanggan_id': pelangganId,
          'kasir_id': user.id,
          'subtotal': subtotal,
          'diskon': diskon,
          'pajak': pajak,
          'total_pembayaran': total,
          'metode_pembayaran': paymentMethod == 'cash' ? 'cash' : 'non_tunai',
        })
        .select('id')
        .single();

    final transaksiId = transaksi['id'];

    // 5️⃣ Insert detail transaksi
    for (final item in items) {
      await _supabase.from('transaksi_detail').insert({
        'transaksi_id': transaksiId,
        'nama_produk': item.name,
        'jumlah': item.quantity,
        'harga_satuan': item.priceValue,
      });
    }

    // 6️⃣ Baru tampilkan struk
    showPaymentReceipt(
      context,
      items: items,
      discountRate: discountRate,
      paymentMethod: paymentMethod,
      customerName: customerName,
      customerMembership: selectedMemberId == null ? null : 'member',
      paidAmount: paidAmount,
      changeAmount: changeAmount,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(246, 231, 212, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CashierHeader(onMenuTap: widget.onMenuTap),

              const SizedBox(height: 18),

              CustomerInfoCard(
                onDiscountChanged: _updateDiscountRate,
                onCustomerNameChanged: (name) {
                  setState(() => customerName = name);
                },
                onMembershipChanged: (memberId) {
                  setState(() => selectedMemberId = memberId);
                },
              ),

              const SizedBox(height: 18),

              CashierProduk(onAddToCart: _handleAddToCart),

              const SizedBox(height: 18),

              CashierCart(
                items: List<CartItem>.from(items),
                onIncrease: _onIncrease,
                onDecrease: _onDecrease,
                onDelete: _onDelete,
                paymentMethod: paymentMethod,
                onSelectPayment: _onSelectPayment,
                onConfirm: _onConfirm,
                discountRate: discountRate,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
