class FilterData {
  final String periode;
  final String tipeFilter;
  final String produk;
  final String membership;

  const FilterData({
    this.periode = "Harian",
    this.tipeFilter = "Semua Data",
    this.produk = "Semua Produk",
    this.membership = "Semua Membership",
  });

  FilterData copyWith({
    String? periode,
    String? tipeFilter,
    String? produk,
    String? membership,
  }) {
    return FilterData(
      periode: periode ?? this.periode,
      tipeFilter: tipeFilter ?? this.tipeFilter,
      produk: produk ?? this.produk,
      membership: membership ?? this.membership,
    );
  }
}
