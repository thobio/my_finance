class SlabLine {
  const SlabLine({
    required this.from,
    this.to,
    required this.rate,
    required this.taxableInSlab,
    required this.taxForSlab,
  });

  final int from;          // rupees
  final int? to;           // rupees; null = unbounded
  final double rate;
  final int taxableInSlab; // rupees
  final int taxForSlab;    // rupees
}
