import 'package:gastos_personales/util/env.dart';

class ApiEndpoints {
  static final String baseUrl = Env.baseUrl;

  
  static final String login = '$baseUrl/auth/login';
  static final String register = '$baseUrl/auth/register';

  static final String dashboardSummary = '$baseUrl/dashboard';
  static final String movements = '$baseUrl/movements';

  //incomes
  static final String incomes = '$baseUrl/incomes';

  //expenses
  static final String expenses = '$baseUrl/expenses';

  //categories
  static final String categories = '$baseUrl/categories';

  //settings
  static final String settings = '$baseUrl/settings';

  //supermarket
  static final String product = '$baseUrl/products'; //Only POST
  static final String expensesSupermarket = '$baseUrl/expenses/supermarket'; //Only Post

  //Reportes
  static final String reportsMonth = '$baseUrl/reports/monthly';
  static final String reportsYear = '$baseUrl/reports/yearly';
  static final String reportsCategories = '$baseUrl/reports/categories';

  //Auth
  static final String authRefresh = '$baseUrl/auth/refresh';

  //Profile
  static final String profile = '$baseUrl/profile';
  static final String profileDeactivate = '$baseUrl/profile/deactivate';
  static final String profileImage = '$baseUrl/profile-image';
  static final String profileImageFile = '$baseUrl/profile-image/file';
}
