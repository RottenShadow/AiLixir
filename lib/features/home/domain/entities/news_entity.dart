import 'package:flutter/material.dart';

/// A pure-UI entity representing a single news article card in the home feed.
class NewsEntity {
  final int id;
  final String tag;
  final Color tagColor;
  final String timeAgo;
  final String title;
  final String body;
  final String primaryAction;
  final IconData icon;
  bool bookmarked;

  /// The filter category IDs this news item belongs to.
  final List<String> categories;

  NewsEntity({
    required this.id,
    required this.tag,
    required this.tagColor,
    required this.timeAgo,
    required this.title,
    required this.body,
    required this.primaryAction,
    required this.icon,
    this.bookmarked = false,
    this.categories = const ['all'],
  });

  NewsEntity.fromJson({
    required Map<String, dynamic> json,
    bool bookmarked = false,
  }) : this(
         id: json["id"],
         tag: "news",
         tagColor: Color(0xFF22C55E),
         timeAgo: json["published_at"],
         icon: Icons.science,
         title: json["title"],
         body: json["summary"],
         bookmarked: bookmarked,
         primaryAction: "Read More",
       );

  static List<NewsEntity> getTestData = [
    NewsEntity(
      id: 1,
      tag: 'Genomics',
      tagColor: Color(0xFF22C55E),
      timeAgo: '2h ago',
      title: 'AlphaFold-3: A New Era in Protein Interaction Prediction',
      body:
          "DeepMind's latest iteration expands prediction capabilities to all life's molecules, enabling researchers to model interactions between proteins.",
      primaryAction: 'Read Analysis',
      icon: Icons.biotech,
      categories: ['all', 'genomics', 'ai'],
    ),
    NewsEntity(
      id: 2,
      tag: 'Clinical Trials',
      tagColor: Color(0xFF3B82F6),
      timeAgo: '5h ago',
      title: "Biogen Announces Q3 Breakthrough in Alzheimer's Pipeline",
      body:
          'Phase II clinical trials show a 30 % reduction in amyloid plaques using a new AI-driven therapeutic lead identified during the 2023 molecular screening phase.',
      primaryAction: 'Full Report',
      icon: Icons.science,
      categories: ['all', 'clinical'],
    ),
    NewsEntity(
      id: 3,
      tag: 'Pharma M&A',
      tagColor: Color(0xFFF59E0B),
      timeAgo: '8h ago',
      title: 'Pfizer Acquires Oncobiologics for \$2.1 B',
      body:
          'The deal accelerates Pfizer\'s biosimilar pipeline, adding eight late-stage molecules targeting HER2 and VEGF pathways across solid-tumour indications.',
      primaryAction: 'Deal Details',
      icon: Icons.account_balance,
      categories: ['all', 'pharma'],
    ),
    NewsEntity(
      id: 4,
      tag: 'AI Breakthroughs',
      tagColor: Color(0xFFA855F7),
      timeAgo: '11h ago',
      title: 'Large Language Models Accelerate Drug-Target Binding Predictions',
      body:
          'Researchers at MIT trained a transformer model on 40 M small-molecule interactions, achieving state-of-the-art accuracy on the DUD-E benchmark dataset.',
      primaryAction: 'Research Paper',
      icon: Icons.memory,
      categories: ['all', 'ai'],
    ),
  ];
}
