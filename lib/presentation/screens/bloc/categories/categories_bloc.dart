import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_personales/layers/categories/domain/entity/category.dart';
import 'package:gastos_personales/layers/categories/domain/usecase/create_category.dart';
import 'package:gastos_personales/layers/categories/domain/usecase/delete_category.dart';
import 'package:gastos_personales/layers/categories/domain/usecase/get_categories.dart';
import 'package:gastos_personales/layers/categories/domain/usecase/update_category.dart';

part 'categories_event.dart';
part 'categories_state.dart';

List<Category> _extractCategories(CategoriesState state) {
  if (state is CategoriesLoaded) return state.categories;
  if (state is CategoriesUpdating) return state.categories;
  if (state is CategoriesUpdateSuccess) return state.categories;
  return [];
}

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final GetCategories _getCategories;
  final CreateCategory _createCategory;
  final UpdateCategory _updateCategory;
  final DeleteCategory _deleteCategory;

  CategoriesBloc(
    this._getCategories,
    this._createCategory,
    this._updateCategory,
    this._deleteCategory,
  ) : super(const CategoriesInitial()) {
    on<CategoriesFetchRequested>(_onFetch);
    on<CategoriesCreateRequested>(_onCreate);
    on<CategoriesUpdateRequested>(_onUpdate);
    on<CategoriesDeleteRequested>(_onDelete);
  }

  Future<void> _onFetch(
    CategoriesFetchRequested event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(const CategoriesLoading());
    try {
      final categories = await _getCategories();
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(CategoriesError(_parseError(e)));
    }
  }

  Future<void> _onCreate(
    CategoriesCreateRequested event,
    Emitter<CategoriesState> emit,
  ) async {
    final current = _extractCategories(state);
    try {
      final created = await _createCategory(
        name: event.name,
        icon: event.icon,
        color: event.color,
        type: event.type,
      );
      emit(CategoriesLoaded([...current, created]));
    } catch (e) {
      emit(CategoriesError(_parseError(e)));
    }
  }

  Future<void> _onUpdate(
    CategoriesUpdateRequested event,
    Emitter<CategoriesState> emit,
  ) async {
    final current = _extractCategories(state);
    emit(CategoriesUpdating(current));
    try {
      final updated = await _updateCategory(
        id: event.id,
        name: event.name,
        icon: event.icon,
        color: event.color,
      );
      final list = current
          .map((c) => c.id == updated.id ? updated : c)
          .toList();
      emit(CategoriesUpdateSuccess(list));
    } catch (e) {
      emit(CategoriesError(_parseError(e)));
    }
  }

  Future<void> _onDelete(
    CategoriesDeleteRequested event,
    Emitter<CategoriesState> emit,
  ) async {
    final current = _extractCategories(state);
    try {
      await _deleteCategory(event.id);
      emit(
        CategoriesLoaded(
          current.where((c) => c.id != event.id).toList(),
        ),
      );
    } catch (e) {
      emit(CategoriesError(_parseError(e)));
    }
  }

  String _parseError(Object e) {
    final msg = e.toString();
    if (msg.contains('401') || msg.contains('Unauthorized') || msg.contains('Sesión expirada')) {
      return 'Sesión expirada. Inicia sesión de nuevo.';
    }
    if (msg.contains('SocketException') || msg.contains('Connection') || msg.contains('Sin conexión')) {
      return 'Sin conexión a internet.';
    }
    return msg.contains('No se pudo') || msg.contains('Error del servidor') || msg.contains('Solicitud inválida') || msg.contains('no existe')
        ? msg
        : 'No se pudieron procesar las categorías. Intenta de nuevo.';
  }
}
