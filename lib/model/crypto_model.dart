class Crypto {
  String id, name, marketCapUsd, symbol;
  double priceUsd, changePercent24Hr;
  int rank;

  Crypto({
    required this.id,
    required this.name,
    required this.symbol,
    required this.marketCapUsd,
    required this.changePercent24Hr,
    required this.priceUsd,
    required this.rank,
  });

  factory Crypto.fromJson(Map<String, dynamic> json) {
    return Crypto(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
      marketCapUsd: json['marketCapUsd'],
      changePercent24Hr: double.parse(json['changePercent24Hr']),
      priceUsd: double.parse(json['priceUsd']),
      rank: int.parse(json['rank']),
    );
  }
}
