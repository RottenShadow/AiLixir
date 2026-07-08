typedef PaginatedData<T> = PaginatedDataWithExtra<T, dynamic>;

class PaginatedDataWithExtra<T, E> {
  final List<T> results;
  final PaginationModel pagination;
  final E? extra;

  PaginatedDataWithExtra({
    required this.results,
    required this.pagination,
    this.extra,
  });

  factory PaginatedDataWithExtra.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT, {
    E Function(Map<String, dynamic>)? fromJsonExtra,
    String resultsKey = 'results',
  }) {
    return PaginatedDataWithExtra<T, E>(
      results:
          (json[resultsKey] as List<dynamic>?)
              ?.map((e) => fromJsonT(e as Map<String, dynamic>))
              .toList() ??
          [],
      pagination: PaginationModel.fromJson(json['pagination'] ?? {}),
      extra: fromJsonExtra != null ? fromJsonExtra(json) : null,
    );
  }
}

class PaginationModel {
  final int currentPage;
  final int totalPages;
  final int totalResults;
  final bool hasNextPage;
  final bool hasPrevPage;

  PaginationModel({
    required this.currentPage,
    required this.totalPages,
    required this.totalResults,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      totalResults: json['totalResults'] ?? 0,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPrevPage: json['hasPrevPage'] ?? false,
    );
  }
}
