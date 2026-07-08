part of 'md_cubit.dart';

enum MdSubmitStatus { idle, submitting, submitted, failure }

class MdState {
  final MdSubmitStatus submitStatus;
  final MdSimulationEntity config;
  final String? submittedJobId;
  final String? errorMessage;

  const MdState({
    this.submitStatus = MdSubmitStatus.idle,
    required this.config,
    this.submittedJobId,
    this.errorMessage,
  });

  MdState copyWith({
    MdSubmitStatus? submitStatus,
    MdSimulationEntity? config,
    String? submittedJobId,
    String? errorMessage,
  }) {
    return MdState(
      submitStatus: submitStatus ?? this.submitStatus,
      config: config ?? this.config,
      submittedJobId: submittedJobId ?? this.submittedJobId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
