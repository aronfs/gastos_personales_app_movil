part of 'categories_bloc.dart';

abstract class CategoriesEvent extends Equatable {
  const CategoriesEvent();

  @override
  List<Object?> get props => [];
}

class CategoriesFetchRequested extends CategoriesEvent {
  const CategoriesFetchRequested();
}

class CategoriesCreateRequested extends CategoriesEvent {
  final String name;
  final String icon;
  final String color;
  final CategoryType type;

  const CategoriesCreateRequested({
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
  });

  @override
  List<Object?> get props => [name, icon, color, type];
}

class CategoriesUpdateRequested extends CategoriesEvent {
  final String id;
  final String? name;
  final String? icon;
  final String? color;

  const CategoriesUpdateRequested({
    required this.id,
    this.name,
    this.icon,
    this.color,
  });

  @override
  List<Object?> get props => [id, name, icon, color];
}

class CategoriesDeleteRequested extends CategoriesEvent {
  final String id;

  const CategoriesDeleteRequested(this.id);

  @override
  List<Object?> get props => [id];
}
