import 'package:gastos_personales/layers/categories/domain/repository/categories_repository.dart';
import 'package:gastos_personales/layers/dashboard/domain/usecase/get_dashboard.dart';

class CheckInitialSetupRequired {
  final CategoriesRepository _categoriesRepository;
  final GetDashboard _getDashboard;

  CheckInitialSetupRequired(this._categoriesRepository, this._getDashboard);

  Future<bool> call() async {
    final categories = await _categoriesRepository.getCategories();
    if (categories.isNotEmpty) {
      return false;
    }
    final summary = await _getDashboard();
    return summary.totalIncome == 0 &&
        summary.totalExpense == 0 &&
        summary.currentBalance == 0;
  }
}