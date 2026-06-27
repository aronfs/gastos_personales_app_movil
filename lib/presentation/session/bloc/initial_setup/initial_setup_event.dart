part of 'initial_setup_bloc.dart';

abstract class InitialSetupEvent extends Equatable {
  const InitialSetupEvent();

  @override
  List<Object?> get props => [];
}

class InitialSetupRequested extends InitialSetupEvent {
  const InitialSetupRequested();
}
