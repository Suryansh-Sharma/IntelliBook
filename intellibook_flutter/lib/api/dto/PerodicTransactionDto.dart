class PerodicTransactionDto {
  String topic;
  String fromDate;
  String toDate;
  String sortBy;
  int pageSize;
  int pageNo;
  List<TransactionDto> transactions;
  int totalData;
  int totalPages;

  PerodicTransactionDto(
      {this.topic = '',
      this.fromDate = '',
      this.toDate = '',
      this.sortBy = '',
      this.pageSize = 0,
      this.pageNo = 0,
      List<TransactionDto>? transactions,
      this.totalData = 0,
      this.totalPages = 0})
      : transactions = transactions ?? [];
  @override
  String toString() {
    return 'ResponseDto(topic: $topic, fromDate: $fromDate, toDate: $toDate, sortBy: $sortBy, pageSize: $pageSize, pageNo: $pageNo, transactions: $transactions, totalData: $totalData, totalPages: $totalPages)';
  }

  factory PerodicTransactionDto.fromJson(Map<String, dynamic> map) {
    return PerodicTransactionDto(
        topic: map['topic'],
        fromDate: map['fromDate'],
        toDate: map['toDate'],
        sortBy: map['sortBy'],
        pageSize: map['pageSize'] as int,
        pageNo: map['pageNo'] as int,
        transactions: (map['transactions'] as List)
            .map((item) => TransactionDto.fromJson(item))
            .toList(),
        totalData: map['totalData'],
        totalPages: map['totalPages']);
  }
}

class TransactionDto {
  int id;
  double amount;
  String time;
  String description;

  TransactionDto(
      {this.id = 0, this.amount = 0.0, this.time = "", this.description = ""});

  factory TransactionDto.fromJson(Map<String, dynamic> map) {
    return TransactionDto(
        id: map['id'],
        amount: map['amount'],
        time: map['time'],
        description: map['description']);
  }

  @override
  String toString() {
    return 'TransactionDto(id: $id, amount: $amount, time: $time, description: $description)';
  }
}
