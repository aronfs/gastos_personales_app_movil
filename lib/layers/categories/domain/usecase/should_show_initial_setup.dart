import 'package:gastos_personales/layers/dashboard/domain/usecase/get_dashboard.dart';

class ShouldShowInitialSetup {
  final GetDashboard _getDashboard;

  ShouldShowInitialSetup(this._getDashboard);

  Future<bool> call() async {
    final summary = await _getDashboard();
    return summary.totalIncome == 0 &&
        summary.totalExpense == 0 &&
        summary.currentBalance == 0;
  }
}
