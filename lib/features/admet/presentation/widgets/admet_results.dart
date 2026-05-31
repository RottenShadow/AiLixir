import 'package:ailixir/features/admet/domain/entities/admet_prediction_entity.dart';
import 'package:ailixir/features/admet/presentation/cubits/admet_cubit.dart';
import 'package:ailixir/features/admet/presentation/widgets/admet_compound_card.dart';
import 'package:ailixir/features/admet/presentation/widgets/admet_error_banner.dart';
import 'package:ailixir/features/admet/presentation/widgets/admet_sort_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum SortField {
  absorption('Absorption'),
  distribution('Distribution'),
  metabolism('Metabolism'),
  excretion('Excretion'),
  toxicity('Toxicity');

  final String label;
  const SortField(this.label);
}

class AdmetResults extends StatefulWidget {
  const AdmetResults({super.key});

  @override
  State<AdmetResults> createState() => _AdmetResultsState();
}

class _AdmetResultsState extends State<AdmetResults> {
  SortField _sortField = SortField.absorption;
  bool _sortAscending = true;

  List<AdmetPredictionEntity> _sorted(List<AdmetPredictionEntity> data) {
    final sorted = List<AdmetPredictionEntity>.from(data);
    sorted.sort((a, b) {
      final aVal = _value(a);
      final bVal = _value(b);
      return _sortAscending ? aVal.compareTo(bVal) : bVal.compareTo(aVal);
    });
    return sorted;
  }

  double _value(AdmetPredictionEntity entity) {
    switch (_sortField) {
      case SortField.absorption:
        return entity.absorption;
      case SortField.distribution:
        return entity.distribution;
      case SortField.metabolism:
        return entity.metabolism;
      case SortField.excretion:
        return entity.excretion;
      case SortField.toxicity:
        return entity.toxicity;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdmetCubit, AdmetState>(
      builder: (context, state) {
        return switch (state) {
          AdmetSuccess(:final response) => _AdmetResultList(
            predictions: _sorted(response.data),
            sortField: _sortField,
            sortAscending: _sortAscending,
            count: response.data.length,
            onSortChanged: (field) {
              setState(() {
                if (_sortField == field) {
                  _sortAscending = !_sortAscending;
                } else {
                  _sortField = field;
                  _sortAscending = true;
                }
              });
            },
          ),
          AdmetError(:final message) => AdmetErrorBanner(message: message),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}

class _AdmetResultList extends StatelessWidget {
  final List<AdmetPredictionEntity> predictions;
  final SortField sortField;
  final bool sortAscending;
  final int count;
  final ValueChanged<SortField> onSortChanged;

  const _AdmetResultList({
    required this.predictions,
    required this.sortField,
    required this.sortAscending,
    required this.count,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        AdmetSortBar(
          sortField: sortField,
          sortAscending: sortAscending,
          onSortChanged: onSortChanged,
          count: count,
        ),
        SizedBox(height: 16.h),
        ...List.generate(predictions.length, (i) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: AdmetCompoundCard(
              index: i + 1,
              prediction: predictions[i],
            ),
          );
        }),
      ],
    );
  }
}
