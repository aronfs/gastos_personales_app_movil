import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_personales/layers/categories/domain/usecase/setup_initial_categories.dart';

part 'initial_setup_event.dart';
part 'initial_setup_state.dart';

class InitialSetupBloc extends Bloc<InitialSetupEvent, InitialSetupState> {
  final SetupInitialCategories _setupInitialCategories;

  InitialSetupBloc(this._setupInitialCategories)
      : super(const InitialSetupInitial()) {
    on<InitialSetupRequested>(_onSetup);
  }

  Future<void> _onSetup(
    InitialSetupRequested event,
    Emitter<InitialSetupState> emit,
  ) async {
    emit(const InitialSetupLoading());
    try {
      await _setupInitialCategories();
      emit(const InitialSetupSuccess());
    } catch (e) {
      emit(InitialSetupError(_parseError(e)));
    }
  }

  String _parseError(Object e) {
    final msg = e.toString();
    if (msg.contains('401') ||
        msg.contains('Unauthorized') ||
        msg.contains('Sesión expirada')) {
      return 'Sesión expirada. Inicia sesión de nuevo.';
    }
    if (msg.contains('SocketException') ||
        msg.contains('Connection') ||
        msg.contains('Sin conexión')) {
      return 'Sin conexión a internet.';
    }
    return msg.contains('No se pudo') ||
            msg.contains('Error del servidor') ||
            msg.contains('Solicitud inválida') ||
            msg.contains('no existe')
        ? msg
        : 'No se pudieron crear las categorías. Intenta de nuevo.';
  }
}
