enum SORT_DIRE { ASC, DESC }

enum TransactionType { INCOME, EXPENSE }

class SearchResdto {
  final String query;
  final int pageSize;
  final int pageNo;
  final SORT_DIRE sortDire;
  final String sortBy;
  final String sortValue;
  List<Category> categories;
  List<Tag> tags;
  List<Transaction> transactions;
  final int totalData;
  final int totalPages;

  // Constructor with default values
  SearchResdto({
    this.query = "",
    this.pageSize = 0,
    this.pageNo = 0,
    this.sortDire = SORT_DIRE.ASC,
    this.sortBy = "",
    this.totalData = 0,
    this.totalPages = 0,
    List<Category>? categories,
    List<Tag>? tags,
    List<Transaction>? transactions,
  })  : categories = categories ?? [],
        tags = tags ?? [],
        transactions = transactions ?? [],
        sortValue = "$sortBy: ${sortDire.toString().split('.').last}";

  // Factory constructor to create an instance from JSON
  factory SearchResdto.fromJson(Map<String, dynamic> json) {
    return SearchResdto(
      query: json['query'] ?? "",
      pageSize: json['pageSize'] ?? 0,
      pageNo: json['pageNo'] ?? 0,
      sortDire: SORT_DIRE.values.firstWhere(
          (e) => e.toString() == 'SORT_DIRE.${json['sortDire']}',
          orElse: () => SORT_DIRE.ASC),
      sortBy: json['sortBy'] ?? "",
      totalData: json['totalData'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      categories: (json['categories'] as List<dynamic>?)
              ?.map((categoryJson) => Category.fromJson(categoryJson))
              .toList() ??
          [],
      tags: (json['tags'] as List<dynamic>?)
              ?.map((tagJson) => Tag.fromJson(tagJson))
              .toList() ??
          [],
      transactions: (json['transactions'] as List<dynamic>?)
              ?.map((transactionJson) => Transaction.fromJson(transactionJson))
              .toList() ??
          [],
    );
  }

  @override
  String toString() {
    return 'SearchResdto(query: $query, pageSize: $pageSize, pageNo: $pageNo, sortDire: $sortDire, sortBy: $sortBy, totalData: $totalData, totalPages: $totalPages, categories: $categories, tags: $tags, transactions: $transactions)';
  }
}

class Category {
  int id;
  String name;

  Category({this.id = 0, this.name = ""});

  // Factory constructor to create an instance from JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
    );
  }

  @override
  String toString() {
    return 'Category(id: $id, name: $name)';
  }
}

class Tag {
  int id;
  String name;

  Tag({this.id = 0, this.name = ""});

  // Factory constructor to create an instance from JSON
  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
    );
  }
  @override
  String toString() {
    return 'Tag(id: $id, name: $name)';
  }
}

class Transaction {
  int id;
  double amount;
  TransactionType type;
  String instant;
  String description;

  Transaction({
    this.id = 0,
    this.amount = 0,
    this.type = TransactionType.INCOME,
    this.instant = "",
    this.description = "",
  });

  // Factory constructor to create an instance from JSON
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? 0,
      amount: (json['amount'] ?? 0).toDouble(),
      type: TransactionType.values.firstWhere(
          (e) => e.toString() == 'TransactionType.${json['type']}',
          orElse: () => TransactionType.INCOME),
      instant: json['instant'] ?? "",
      description: json['description'] ?? "",
    );
  }

  @override
  String toString() {
    return 'Transaction(id: $id, amount: $amount, type: $type, instant: $instant, description: $description)';
  }
}
