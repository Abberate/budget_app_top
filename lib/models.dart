class Models {
  final String name;
  final String amount;

  Models({required this.name, required this.amount});

  factory Models.fromJson(Map<String, dynamic> json) {
    return Models(name: json["name"], amount: json["amount"]);
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "amount": amount,
      };
}
