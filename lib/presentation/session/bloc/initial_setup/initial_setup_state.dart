part of 'initial_setup_bloc.dart';

abstract class InitialSetupState extends Equatable {
  const InitialSetupState();

  @override
  List<Object?> get props => [];
}

class InitialSetupInitial extends InitialSetupState {
  const InitialSetupInitial();
}

class InitialSetupLoading extends InitialSetupState {
  const InitialSetupLoading();
}

class InitialSetupSuccess extends InitialSetupState {
  const InitialSetupSuccess();
}

class InitialSetupError extends InitialSetupState {
  final String message;

  const InitialSetupError(this.message);

  @override
  List<Object?> get props => [message];
}
