class TransactionByDateDto {
  String date;
  int totalCategories;
  String sortBy;
  double totalExpendature;
  List<Category> categories;
  TransactionByDateDto(
      {this.date = '',
      this.totalCategories = 0,
      this.sortBy = '',
      this.totalExpendature = 0,
      this.categories = const []});

  // Factory constructor to create an instance from JSON
  factory TransactionByDateDto.fromJson(Map<String, dynamic> json) {
    return TransactionByDateDto(
      date: json['date'] ?? "",
      totalCategories: json['totalCategories'] ?? 0,
      sortBy: json['sortBy'] ?? "",
      totalExpendature: json['totalExpendature'] ?? 0,
      categories: (json['categories'] as List<dynamic>?)
              ?.map((categoryJson) => Category.fromJson(categoryJson))
              .toList() ??
          [],
    );
  }

  @override
  String toString() {
    return 'TransactionByDateDto(date: $date, totalCategories: $totalCategories, sortBy: $sortBy, totalExpendature: $totalExpendature, categories: $categories)';
  }
}

class Category {
  String name;
  double totalAmount;
  List<Transaction> transactions;

  Category(
      {this.name = "", this.totalAmount = 0.0, List<Transaction>? transactions})
      : transactions = transactions ?? [];

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['category'] ?? '',
      totalAmount: (json['totalExpendature'] ?? 0.0).toDouble(),
      transactions: (json['transactions'] as List<dynamic>?)
              ?.map((e) => Transaction.fromJson(e))
              .toList() ??
          [],
    );
  }
  @override
  String toString() {
    return 'Category(name: $name, totalAmount: $totalAmount, transactions: $transactions)';
  }
}

class Transaction {
  double amount;
  String time;
  String description;
  List<Tag> tags;
  Transaction(
      {this.amount = 0,
      this.time = '',
      this.description = '',
      this.tags = const []});
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      amount: (json['amount'] ?? 0.0).toDouble(),
      time: json['time'] ?? '',
      description: json['description'] ?? '',
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => Tag.fromJson(e))
              .toList() ??
          [],
    );
  }
  @override
  String toString() {
    return 'Transaction(amount: $amount, time: $time, description: $description, tags: $tags)';
  }
}

class Tag {
  int id;
  String name;
  Tag({this.id = 0, this.name = ''});
  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Tag(id: $id, name: $name)';
  }
}
