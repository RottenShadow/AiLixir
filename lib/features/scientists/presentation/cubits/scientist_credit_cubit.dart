import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'scientist_credit_state.dart';

class ScientistCreditCubit extends Cubit<ScientistCreditState> {
  ScientistCreditCubit() : super(ScientistCreditInitial());
}
