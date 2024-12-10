class ShippingCost {
  final String service;
  final String description;
  final List<CostDetail> cost;

  ShippingCost({
    required this.service,
    required this.description,
    required this.cost,
  });
}

class CostDetail {
  final int value;
  final String? etd;
  final String? note;

  CostDetail({
    required this.value,
    this.etd,
    this.note,
  });

  factory CostDetail.fromJson(Map<String, dynamic> json) {
    return CostDetail(
      value: json['value'],
      etd: json['etd']?.toString(),
      note: json['note'],
    );
  }
}