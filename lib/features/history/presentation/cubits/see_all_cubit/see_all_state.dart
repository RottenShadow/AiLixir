part of 'see_all_cubit.dart';

enum SeeAllStatus { initial, loading, loaded, loadingMore }

@immutable
class SeeAllState<T> {
  final SeeAllStatus status;
  final List<T> items;
  final int page;
  final bool hasMore;

  const SeeAllState({
    this.status = SeeAllStatus.initial,
    this.items = const [],
    this.page = 0,
    this.hasMore = true,
  });

  SeeAllState<T> copyWith({
    SeeAllStatus? status,
    List<T>? items,
    int? page,
    bool? hasMore,
  }) {
    return SeeAllState<T>(
      status: status ?? this.status,
      items: items ?? this.items,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
