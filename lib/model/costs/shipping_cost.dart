class ShippingCost {
  final String service;
  final String description;
  final List<CostDetail> cost;

  ShippingCost({
    required this.service,
    required this.description,
    required this.cost,
  });

  factory ShippingCost.fromJson(Map<String, dynamic> json) {
    return ShippingCost(
      service: json['service'],
      description: json['description'],
      cost: (json['cost'] as List).map((e) => CostDetail.fromJson(e)).toList(),
    );
  }
}

class CostDetail {
  final int value;
  final String etd;

  CostDetail({
    required this.value,
    required this.etd,
  });

  factory CostDetail.fromJson(Map<String, dynamic> json) {
    return CostDetail(
      value: json['value'],
      etd: json['etd'],
    );
  }
}