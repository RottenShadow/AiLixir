/// Represents a single news-feed filter tab.
class NewsFilter {
  final String label;
  final String id;

  const NewsFilter({required this.id, required this.label});

  static const List<NewsFilter> all = [
    NewsFilter(id: 'all', label: 'Your News'),
    NewsFilter(id: 'saved', label: 'Bookmarks'),
  ];
}
