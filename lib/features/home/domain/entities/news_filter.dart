/// Represents a single news-feed filter tab.
class NewsFilter {
  final String label;
  final String id;

  const NewsFilter({required this.id, required this.label});

  static const List<NewsFilter> all = [
    NewsFilter(id: 'all', label: 'All Insights'),
    NewsFilter(id: 'ai', label: 'AI Breakthroughs'),
    NewsFilter(id: 'clinical', label: 'Clinical Results'),
    NewsFilter(id: 'pharma', label: 'Pharma M&A'),
    NewsFilter(id: 'genomics', label: 'Genomics'),
    NewsFilter(id: 'saved', label: 'Bookmarks'),
  ];
}
