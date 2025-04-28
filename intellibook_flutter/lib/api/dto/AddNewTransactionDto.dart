class Addnewtransactiondto {
  int categoryId;
  List<String> tags;
  String description;
  TRANSACTION_TYPE transactionType;
  double amount;
  String date;
  String time;

  Addnewtransactiondto({
    this.categoryId = 0,
    this.tags = const [],
    this.description = "",
    this.transactionType = TRANSACTION_TYPE.EXPENSE,
    this.amount = 0.0,
    this.date = "",
    this.time = "",
  });
}

enum TRANSACTION_TYPE {
  INCOME,
  EXPENSE,
  TRANSFER,
}
