class MonthlyTransactionReportDto {
  final String title;
  String fromDate;
  String toDate;
  final double totalTransactionAmount;
  final int totalTransactions;
  final String mostFrequentMonth;
  final String highestPaidMonth;
  List<MonthlySummary>? monthlySummary;

  MonthlyTransactionReportDto({
    this.title = '',
    this.fromDate = '',
    this.toDate = '',
    this.totalTransactionAmount = 0.0,
    this.totalTransactions = 0,
    this.mostFrequentMonth = '',
    this.highestPaidMonth = '',
    List<MonthlySummary>? monthlySummary, // Nullable in parameter
  }) : monthlySummary = monthlySummary ?? []; // Default to an empty list

  factory MonthlyTransactionReportDto.fromJson(Map<String, dynamic> json) {
    return MonthlyTransactionReportDto(
      title: json['title'],
      fromDate: json['fromDate'],
      toDate: json['toDate'],
      totalTransactionAmount:
          (json['totalTransactionAmount'] as num).toDouble(),
      totalTransactions: json['totalTransactions'],
      mostFrequentMonth: json['mostFrequentMonth'],
      highestPaidMonth: json['highestPaidMonth'],
      monthlySummary: (json['monthlySummary'] as List)
          .map((item) => MonthlySummary.fromJson(item))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'MonthlyTransactionReport(title: $title, formDate: $fromDate, toDate: $toDate, totalTransactionAmount: $totalTransactionAmount, mostFrequentMonth: $mostFrequentMonth, highestPaidMonth: $highestPaidMonth, monthlySummary: $monthlySummary )';
  }
}

class MonthlySummary {
  final String name;
  final double amount;

  MonthlySummary({this.name = '', this.amount = 0.0});

  // Factory constructor to create an instance from a JSON map
  factory MonthlySummary.fromJson(Map<String, dynamic> json) {
    return MonthlySummary(
      name: json['name'],
      amount: json['amount'],
    );
  }

  @override
  String toString() {
    return 'MonthlySummary(month: $name, ammount: $amount)';
  }
}
