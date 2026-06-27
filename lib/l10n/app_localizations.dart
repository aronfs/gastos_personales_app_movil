import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @titleSplash.
  ///
  /// In en, this message translates to:
  /// **'Cost-Expenses'**
  String get titleSplash;

  /// No description provided for @descriptionSplash.
  ///
  /// In en, this message translates to:
  /// **'Your Money, Your Control, and Your Financial Freedom'**
  String get descriptionSplash;

  /// No description provided for @titleSignIn.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get titleSignIn;

  /// No description provided for @descriptionSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In to continue'**
  String get descriptionSignIn;

  /// No description provided for @labelemail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get labelemail;

  /// No description provided for @labelpassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get labelpassword;

  /// No description provided for @labelforgotpassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get labelforgotpassword;

  /// No description provided for @btnsignin.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get btnsignin;

  /// No description provided for @labeldontaccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get labeldontaccount;

  /// No description provided for @btnsignup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get btnsignup;

  /// No description provided for @hintEmail.
  ///
  /// In en, this message translates to:
  /// **'Your@email.com'**
  String get hintEmail;

  /// No description provided for @hintPassword.
  ///
  /// In en, this message translates to:
  /// **'*******'**
  String get hintPassword;

  /// No description provided for @titleSignUp.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get titleSignUp;

  /// No description provided for @labelName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get labelName;

  /// No description provided for @hintName.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get hintName;

  /// No description provided for @labelConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get labelConfirmPassword;

  /// No description provided for @descriptionPolities.
  ///
  /// In en, this message translates to:
  /// **'Register accept to the terms and Conditions of privacy'**
  String get descriptionPolities;

  /// No description provided for @greeting.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get greeting;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @incost.
  ///
  /// In en, this message translates to:
  /// **'in'**
  String get incost;

  /// No description provided for @enough.
  ///
  /// In en, this message translates to:
  /// **'enough'**
  String get enough;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saving;

  /// No description provided for @goal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get goal;

  /// No description provided for @signInWithBiometric.
  ///
  /// In en, this message translates to:
  /// **'Sign in with fingerprint'**
  String get signInWithBiometric;

  /// No description provided for @fingerprintNotRegisteredTitle.
  ///
  /// In en, this message translates to:
  /// **'Register fingerprint'**
  String get fingerprintNotRegisteredTitle;

  /// No description provided for @fingerprintNotRegisteredMessage.
  ///
  /// In en, this message translates to:
  /// **'No fingerprints registered on this device. Go to Settings > Security and register a fingerprint to use this feature.'**
  String get fingerprintNotRegisteredMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @goToSettings.
  ///
  /// In en, this message translates to:
  /// **'Go to Settings'**
  String get goToSettings;

  /// No description provided for @enableFingerprintTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable fingerprint?'**
  String get enableFingerprintTitle;

  /// No description provided for @enableFingerprintMessage.
  ///
  /// In en, this message translates to:
  /// **'You can use your fingerprint to log in faster without a password.'**
  String get enableFingerprintMessage;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @enable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enable;

  /// No description provided for @fingerprintActivated.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint activated successfully'**
  String get fingerprintActivated;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @enterYourLastName.
  ///
  /// In en, this message translates to:
  /// **'Enter your last name'**
  String get enterYourLastName;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get enterValidEmail;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter a password'**
  String get enterPassword;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @passwordsDontMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match'**
  String get passwordsDontMatch;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastName;

  /// No description provided for @hintLastName.
  ///
  /// In en, this message translates to:
  /// **'Your last name'**
  String get hintLastName;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navDashboard;

  /// No description provided for @navMovements.
  ///
  /// In en, this message translates to:
  /// **'Movements'**
  String get navMovements;

  /// No description provided for @navReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get navReports;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @searchMovement.
  ///
  /// In en, this message translates to:
  /// **'Search movement...'**
  String get searchMovement;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noMovements.
  ///
  /// In en, this message translates to:
  /// **'No movements'**
  String get noMovements;

  /// No description provided for @movementCount.
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{1 movement} other{{count} movements}}'**
  String movementCount(num count);

  /// No description provided for @editExpense.
  ///
  /// In en, this message translates to:
  /// **'Edit expense'**
  String get editExpense;

  /// No description provided for @newExpense.
  ///
  /// In en, this message translates to:
  /// **'New expense'**
  String get newExpense;

  /// No description provided for @expenseAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get expenseAmount;

  /// No description provided for @searchExpense.
  ///
  /// In en, this message translates to:
  /// **'Search expense...'**
  String get searchExpense;

  /// No description provided for @noExpenses.
  ///
  /// In en, this message translates to:
  /// **'No expenses registered'**
  String get noExpenses;

  /// No description provided for @deleteExpense.
  ///
  /// In en, this message translates to:
  /// **'Delete expense'**
  String get deleteExpense;

  /// No description provided for @deleteExpenseConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{description}\"?'**
  String deleteExpenseConfirm(Object description);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @categorySection.
  ///
  /// In en, this message translates to:
  /// **'CATEGORY'**
  String get categorySection;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get selectCategory;

  /// No description provided for @loadingCategories.
  ///
  /// In en, this message translates to:
  /// **'Loading categories...'**
  String get loadingCategories;

  /// No description provided for @noCategoriesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No categories available'**
  String get noCategoriesAvailable;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @hintDescriptionExpense.
  ///
  /// In en, this message translates to:
  /// **'E.g: Lunch at restaurant'**
  String get hintDescriptionExpense;

  /// No description provided for @hintAmount.
  ///
  /// In en, this message translates to:
  /// **'0.00'**
  String get hintAmount;

  /// No description provided for @attachReceipt.
  ///
  /// In en, this message translates to:
  /// **'Attach receipt'**
  String get attachReceipt;

  /// No description provided for @savingDots.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get savingDots;

  /// No description provided for @updateExpense.
  ///
  /// In en, this message translates to:
  /// **'Update expense'**
  String get updateExpense;

  /// No description provided for @saveExpense.
  ///
  /// In en, this message translates to:
  /// **'Save expense'**
  String get saveExpense;

  /// No description provided for @deleteExpenseAction.
  ///
  /// In en, this message translates to:
  /// **'Delete expense'**
  String get deleteExpenseAction;

  /// No description provided for @enterValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get enterValidAmount;

  /// No description provided for @selectCategoryError.
  ///
  /// In en, this message translates to:
  /// **'Select a category'**
  String get selectCategoryError;

  /// No description provided for @enterDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter a description'**
  String get enterDescription;

  /// No description provided for @editIncome.
  ///
  /// In en, this message translates to:
  /// **'Edit income'**
  String get editIncome;

  /// No description provided for @newIncome.
  ///
  /// In en, this message translates to:
  /// **'New income'**
  String get newIncome;

  /// No description provided for @incomeLabel.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get incomeLabel;

  /// No description provided for @incomeSource.
  ///
  /// In en, this message translates to:
  /// **'SOURCE'**
  String get incomeSource;

  /// No description provided for @loadingSources.
  ///
  /// In en, this message translates to:
  /// **'Loading sources...'**
  String get loadingSources;

  /// No description provided for @selectSource.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get selectSource;

  /// No description provided for @noSourcesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No sources available'**
  String get noSourcesAvailable;

  /// No description provided for @hintDescriptionIncome.
  ///
  /// In en, this message translates to:
  /// **'E.g: Product sale'**
  String get hintDescriptionIncome;

  /// No description provided for @updateIncome.
  ///
  /// In en, this message translates to:
  /// **'Update income'**
  String get updateIncome;

  /// No description provided for @saveIncome.
  ///
  /// In en, this message translates to:
  /// **'Register income'**
  String get saveIncome;

  /// No description provided for @deleteIncomeAction.
  ///
  /// In en, this message translates to:
  /// **'Delete income'**
  String get deleteIncomeAction;

  /// No description provided for @selectSourceError.
  ///
  /// In en, this message translates to:
  /// **'Select a source'**
  String get selectSourceError;

  /// No description provided for @enterDescriptionIncome.
  ///
  /// In en, this message translates to:
  /// **'Enter a description'**
  String get enterDescriptionIncome;

  /// No description provided for @incomesMonth.
  ///
  /// In en, this message translates to:
  /// **'Monthly income'**
  String get incomesMonth;

  /// No description provided for @incomePageTitle.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get incomePageTitle;

  /// No description provided for @deleteIncomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete income'**
  String get deleteIncomeTitle;

  /// No description provided for @deleteIncomeConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{description}\"?'**
  String deleteIncomeConfirm(Object description);

  /// No description provided for @noIncomes.
  ///
  /// In en, this message translates to:
  /// **'No incomes registered'**
  String get noIncomes;

  /// No description provided for @categoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesTitle;

  /// No description provided for @categoryCreateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Category created successfully.'**
  String get categoryCreateSuccess;

  /// No description provided for @categoryUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Category updated successfully.'**
  String get categoryUpdateSuccess;

  /// No description provided for @deleteCategory.
  ///
  /// In en, this message translates to:
  /// **'Delete category'**
  String get deleteCategory;

  /// No description provided for @deleteCategoryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String deleteCategoryConfirm(Object name);

  /// No description provided for @noCategories.
  ///
  /// In en, this message translates to:
  /// **'No categories'**
  String get noCategories;

  /// No description provided for @newCategory.
  ///
  /// In en, this message translates to:
  /// **'New category'**
  String get newCategory;

  /// No description provided for @editCategory.
  ///
  /// In en, this message translates to:
  /// **'Edit category'**
  String get editCategory;

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get categoryName;

  /// No description provided for @categoryNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get categoryNameRequired;

  /// No description provided for @iconLabel.
  ///
  /// In en, this message translates to:
  /// **'ICON'**
  String get iconLabel;

  /// No description provided for @colorLabel.
  ///
  /// In en, this message translates to:
  /// **'COLOR'**
  String get colorLabel;

  /// No description provided for @categoryType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get categoryType;

  /// No description provided for @expenseType.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expenseType;

  /// No description provided for @incomeType.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get incomeType;

  /// No description provided for @createCategory.
  ///
  /// In en, this message translates to:
  /// **'Create category'**
  String get createCategory;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @deleteImage.
  ///
  /// In en, this message translates to:
  /// **'Delete image'**
  String get deleteImage;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light theme'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark theme'**
  String get darkTheme;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @deleteProfileImageTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete profile image'**
  String get deleteProfileImageTitle;

  /// No description provided for @deleteProfileImageMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your profile photo?'**
  String get deleteProfileImageMessage;

  /// No description provided for @retryLabel.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryLabel;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push notifications'**
  String get pushNotifications;

  /// No description provided for @weeklyEmailSummary.
  ///
  /// In en, this message translates to:
  /// **'Weekly summary\nby email'**
  String get weeklyEmailSummary;

  /// No description provided for @languagePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languagePickerTitle;

  /// No description provided for @currencyPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currencyPickerTitle;

  /// No description provided for @securityTitle.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get securityTitle;

  /// No description provided for @accountSection.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSection;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePassword;

  /// No description provided for @biometricAccess.
  ///
  /// In en, this message translates to:
  /// **'Biometric access'**
  String get biometricAccess;

  /// No description provided for @sms2FA.
  ///
  /// In en, this message translates to:
  /// **'SMS 2FA'**
  String get sms2FA;

  /// No description provided for @activeSessions.
  ///
  /// In en, this message translates to:
  /// **'Active sessions'**
  String get activeSessions;

  /// No description provided for @currentSession.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get currentSession;

  /// No description provided for @closeAllSessions.
  ///
  /// In en, this message translates to:
  /// **'Close all sessions'**
  String get closeAllSessions;

  /// No description provided for @closeAllSessionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Close all sessions'**
  String get closeAllSessionsTitle;

  /// No description provided for @closeAllSessionsMessage.
  ///
  /// In en, this message translates to:
  /// **'All active sessions will be closed, including the current one. You will need to log in again.'**
  String get closeAllSessionsMessage;

  /// No description provided for @closeAll.
  ///
  /// In en, this message translates to:
  /// **'Close all'**
  String get closeAll;

  /// No description provided for @sessionsClosed.
  ///
  /// In en, this message translates to:
  /// **'Sessions closed successfully'**
  String get sessionsClosed;

  /// No description provided for @changePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePasswordTitle;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @savePassword.
  ///
  /// In en, this message translates to:
  /// **'Save password'**
  String get savePassword;

  /// No description provided for @passwordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully'**
  String get passwordUpdated;

  /// No description provided for @enterCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password'**
  String get enterCurrentPassword;

  /// No description provided for @enterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter a new password'**
  String get enterNewPassword;

  /// No description provided for @newPasswordMinLength.
  ///
  /// In en, this message translates to:
  /// **'New password must be at least 6 characters'**
  String get newPasswordMinLength;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match'**
  String get passwordsDoNotMatch;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @firstname.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstname;

  /// No description provided for @firstnameRequired.
  ///
  /// In en, this message translates to:
  /// **'First name is required'**
  String get firstnameRequired;

  /// No description provided for @firstnameMin.
  ///
  /// In en, this message translates to:
  /// **'Minimum 2 characters'**
  String get firstnameMin;

  /// No description provided for @firstnameMax.
  ///
  /// In en, this message translates to:
  /// **'Maximum 100 characters'**
  String get firstnameMax;

  /// No description provided for @lastname.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastname;

  /// No description provided for @lastnameRequired.
  ///
  /// In en, this message translates to:
  /// **'Last name is required'**
  String get lastnameRequired;

  /// No description provided for @lastnameMin.
  ///
  /// In en, this message translates to:
  /// **'Minimum 2 characters'**
  String get lastnameMin;

  /// No description provided for @lastnameMax.
  ///
  /// In en, this message translates to:
  /// **'Maximum 100 characters'**
  String get lastnameMax;

  /// No description provided for @saveChangesButton.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChangesButton;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfileTitle;

  /// No description provided for @newProduct.
  ///
  /// In en, this message translates to:
  /// **'New product'**
  String get newProduct;

  /// No description provided for @productName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get productName;

  /// No description provided for @productDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get productDescription;

  /// No description provided for @hintProductName.
  ///
  /// In en, this message translates to:
  /// **'E.g. Rice'**
  String get hintProductName;

  /// No description provided for @hintProductDescription.
  ///
  /// In en, this message translates to:
  /// **'E.g. Brown rice 1kg'**
  String get hintProductDescription;

  /// No description provided for @unitPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'UNIT PRICE'**
  String get unitPriceLabel;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'CATEGORY'**
  String get categoryLabel;

  /// No description provided for @productPreviewName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get productPreviewName;

  /// No description provided for @productPreviewDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get productPreviewDescription;

  /// No description provided for @createProduct.
  ///
  /// In en, this message translates to:
  /// **'Create product'**
  String get createProduct;

  /// No description provided for @creatingDots.
  ///
  /// In en, this message translates to:
  /// **'Creating...'**
  String get creatingDots;

  /// No description provided for @selectCategoryProduct.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get selectCategoryProduct;

  /// No description provided for @loadingDots.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loadingDots;

  /// No description provided for @noCategoriesError.
  ///
  /// In en, this message translates to:
  /// **'No categories available or could not be loaded'**
  String get noCategoriesError;

  /// No description provided for @selectCategoryProductError.
  ///
  /// In en, this message translates to:
  /// **'Select a category'**
  String get selectCategoryProductError;

  /// No description provided for @enterNameError.
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get enterNameError;

  /// No description provided for @enterValidPriceError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid price'**
  String get enterValidPriceError;

  /// No description provided for @supermarketExpense.
  ///
  /// In en, this message translates to:
  /// **'Supermarket expense'**
  String get supermarketExpense;

  /// No description provided for @remainingBudget.
  ///
  /// In en, this message translates to:
  /// **'Remaining budget'**
  String get remainingBudget;

  /// No description provided for @totalCart.
  ///
  /// In en, this message translates to:
  /// **'Cart total:'**
  String get totalCart;

  /// No description provided for @supermarketCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get supermarketCategory;

  /// No description provided for @supermarketDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get supermarketDescription;

  /// No description provided for @hintSupermarketDescription.
  ///
  /// In en, this message translates to:
  /// **'Supermaxi purchase'**
  String get hintSupermarketDescription;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @addProduct.
  ///
  /// In en, this message translates to:
  /// **'+ Add'**
  String get addProduct;

  /// No description provided for @emptyCartMessage.
  ///
  /// In en, this message translates to:
  /// **'Press \"+ Add\" to add products'**
  String get emptyCartMessage;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @enterDescriptionSupermarket.
  ///
  /// In en, this message translates to:
  /// **'Enter a description'**
  String get enterDescriptionSupermarket;

  /// No description provided for @selectCategorySupermarket.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get selectCategorySupermarket;

  /// No description provided for @scanReceipt.
  ///
  /// In en, this message translates to:
  /// **'Scan Receipt'**
  String get scanReceipt;

  /// No description provided for @noCameraDetected.
  ///
  /// In en, this message translates to:
  /// **'No camera detected'**
  String get noCameraDetected;

  /// No description provided for @cameraError.
  ///
  /// In en, this message translates to:
  /// **'Error initializing camera'**
  String get cameraError;

  /// No description provided for @capturingImage.
  ///
  /// In en, this message translates to:
  /// **'Capturing image...'**
  String get capturingImage;

  /// No description provided for @selectingImage.
  ///
  /// In en, this message translates to:
  /// **'Selecting image...'**
  String get selectingImage;

  /// No description provided for @processingOcr.
  ///
  /// In en, this message translates to:
  /// **'Processing OCR...'**
  String get processingOcr;

  /// No description provided for @analyzingReceipt.
  ///
  /// In en, this message translates to:
  /// **'Analyzing receipt...'**
  String get analyzingReceipt;

  /// No description provided for @detectingTotal.
  ///
  /// In en, this message translates to:
  /// **'Detecting total...'**
  String get detectingTotal;

  /// No description provided for @imageProcessingError.
  ///
  /// In en, this message translates to:
  /// **'Error processing image'**
  String get imageProcessingError;

  /// No description provided for @captureError.
  ///
  /// In en, this message translates to:
  /// **'Error capturing image'**
  String get captureError;

  /// No description provided for @takePhotoHint.
  ///
  /// In en, this message translates to:
  /// **'Take a photo of the receipt'**
  String get takePhotoHint;

  /// No description provided for @receiptListTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Receipts'**
  String get receiptListTitle;

  /// No description provided for @clearList.
  ///
  /// In en, this message translates to:
  /// **'Clear list'**
  String get clearList;

  /// No description provided for @clearListTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear list'**
  String get clearListTitle;

  /// No description provided for @clearListConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete all scanned receipts?'**
  String get clearListConfirm;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @noReceipts.
  ///
  /// In en, this message translates to:
  /// **'No scanned receipts'**
  String get noReceipts;

  /// No description provided for @noReceiptsHint.
  ///
  /// In en, this message translates to:
  /// **'Scan or select a receipt\nto get started'**
  String get noReceiptsHint;

  /// No description provided for @totalAccumulated.
  ///
  /// In en, this message translates to:
  /// **'TOTAL ACCUMULATED'**
  String get totalAccumulated;

  /// No description provided for @scanButton.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scanButton;

  /// No description provided for @registerExpense.
  ///
  /// In en, this message translates to:
  /// **'Register expense'**
  String get registerExpense;

  /// No description provided for @scannedReceipt.
  ///
  /// In en, this message translates to:
  /// **'Scanned receipt'**
  String get scannedReceipt;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @statusNeedsReview.
  ///
  /// In en, this message translates to:
  /// **'Needs review'**
  String get statusNeedsReview;

  /// No description provided for @statusProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get statusProcessing;

  /// No description provided for @statusError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get statusError;

  /// No description provided for @tapToReview.
  ///
  /// In en, this message translates to:
  /// **'Tap to review'**
  String get tapToReview;

  /// No description provided for @productSaved.
  ///
  /// In en, this message translates to:
  /// **'Product saved successfully.'**
  String get productSaved;

  /// No description provided for @confirmDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm data'**
  String get confirmDataTitle;

  /// No description provided for @confirmDataMessage.
  ///
  /// In en, this message translates to:
  /// **'Review the data detected by the scanner.'**
  String get confirmDataMessage;

  /// No description provided for @productNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Product name'**
  String get productNameLabel;

  /// No description provided for @presentationLabel.
  ///
  /// In en, this message translates to:
  /// **'Presentation'**
  String get presentationLabel;

  /// No description provided for @priceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get priceLabel;

  /// No description provided for @saveProduct.
  ///
  /// In en, this message translates to:
  /// **'Save product'**
  String get saveProduct;

  /// No description provided for @rescan.
  ///
  /// In en, this message translates to:
  /// **'Rescan'**
  String get rescan;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get enterName;

  /// No description provided for @detectedByOcr.
  ///
  /// In en, this message translates to:
  /// **'Detected by OCR'**
  String get detectedByOcr;

  /// No description provided for @reviewReceipt.
  ///
  /// In en, this message translates to:
  /// **'Review receipt'**
  String get reviewReceipt;

  /// No description provided for @detectedTotal.
  ///
  /// In en, this message translates to:
  /// **'Detected total'**
  String get detectedTotal;

  /// No description provided for @enterTotal.
  ///
  /// In en, this message translates to:
  /// **'Enter the total'**
  String get enterTotal;

  /// No description provided for @enterValidTotal.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get enterValidTotal;

  /// No description provided for @detectedText.
  ///
  /// In en, this message translates to:
  /// **'DETECTED TEXT'**
  String get detectedText;

  /// No description provided for @noTextDetected.
  ///
  /// In en, this message translates to:
  /// **'No text detected'**
  String get noTextDetected;

  /// No description provided for @confirmReceipt.
  ///
  /// In en, this message translates to:
  /// **'Confirm receipt'**
  String get confirmReceipt;

  /// No description provided for @reviewReceiptCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get reviewReceiptCancel;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationSettings;

  /// No description provided for @channelsSection.
  ///
  /// In en, this message translates to:
  /// **'Channels'**
  String get channelsSection;

  /// No description provided for @pushChannel.
  ///
  /// In en, this message translates to:
  /// **'Push'**
  String get pushChannel;

  /// No description provided for @pushSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Device notifications'**
  String get pushSubtitle;

  /// No description provided for @emailChannel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailChannel;

  /// No description provided for @emailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Email notifications'**
  String get emailSubtitle;

  /// No description provided for @smsChannel.
  ///
  /// In en, this message translates to:
  /// **'SMS'**
  String get smsChannel;

  /// No description provided for @smsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Text message notifications'**
  String get smsSubtitle;

  /// No description provided for @alertsSection.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get alertsSection;

  /// No description provided for @paymentReminders.
  ///
  /// In en, this message translates to:
  /// **'Payment reminders'**
  String get paymentReminders;

  /// No description provided for @paymentRemindersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Before the due date'**
  String get paymentRemindersSubtitle;

  /// No description provided for @weeklySummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly summary'**
  String get weeklySummaryTitle;

  /// No description provided for @weeklySummarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'You\'ll receive a summary every Monday'**
  String get weeklySummarySubtitle;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcomeTitle;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'It looks like you don\'t have any categories yet. Let\'s create some basic ones so you can start recording your income and expenses.'**
  String get welcomeMessage;

  /// No description provided for @willCreateCategories.
  ///
  /// In en, this message translates to:
  /// **'The following categories will be created:'**
  String get willCreateCategories;

  /// No description provided for @salary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get salary;

  /// No description provided for @food.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get food;

  /// No description provided for @transport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get transport;

  /// No description provided for @createInitialCategories.
  ///
  /// In en, this message translates to:
  /// **'Create initial categories'**
  String get createInitialCategories;

  /// No description provided for @initialCategoriesCreated.
  ///
  /// In en, this message translates to:
  /// **'Initial categories created successfully.'**
  String get initialCategoriesCreated;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get quickActions;

  /// No description provided for @quickActionsHeading.
  ///
  /// In en, this message translates to:
  /// **'What would you like to do?'**
  String get quickActionsHeading;

  /// No description provided for @registerIncome.
  ///
  /// In en, this message translates to:
  /// **'Register an income'**
  String get registerIncome;

  /// No description provided for @recordExpense.
  ///
  /// In en, this message translates to:
  /// **'Record an expense'**
  String get recordExpense;

  /// No description provided for @supermarketPurchase.
  ///
  /// In en, this message translates to:
  /// **'Supermarket purchase'**
  String get supermarketPurchase;

  /// No description provided for @addProductAction.
  ///
  /// In en, this message translates to:
  /// **'Add a product'**
  String get addProductAction;

  /// No description provided for @scanProduct.
  ///
  /// In en, this message translates to:
  /// **'Scan product'**
  String get scanProduct;

  /// No description provided for @readBarcode.
  ///
  /// In en, this message translates to:
  /// **'Read barcode'**
  String get readBarcode;

  /// No description provided for @scanReceipts.
  ///
  /// In en, this message translates to:
  /// **'Scan receipts'**
  String get scanReceipts;

  /// No description provided for @ocrReceipts.
  ///
  /// In en, this message translates to:
  /// **'OCR for receipts'**
  String get ocrReceipts;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @selectProduct.
  ///
  /// In en, this message translates to:
  /// **'Select product'**
  String get selectProduct;

  /// No description provided for @addProductTitle.
  ///
  /// In en, this message translates to:
  /// **'Add product'**
  String get addProductTitle;

  /// No description provided for @searchProducts.
  ///
  /// In en, this message translates to:
  /// **'Search products...'**
  String get searchProducts;

  /// No description provided for @movementCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} movement{count,plural, =1{} other{s}}'**
  String movementCountLabel(num count);

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get selectLanguage;

  /// No description provided for @incomeReports.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get incomeReports;

  /// No description provided for @expenseReports.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenseReports;

  /// No description provided for @balanceReports.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balanceReports;

  /// No description provided for @transactionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} transactions in {month}'**
  String transactionsCount(Object count, Object month);

  /// No description provided for @categoriesHeader.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesHeader;

  /// No description provided for @manageButton.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manageButton;

  /// No description provided for @periodWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get periodWeek;

  /// No description provided for @periodMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get periodMonth;

  /// No description provided for @periodYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get periodYear;

  /// No description provided for @monthlySummary.
  ///
  /// In en, this message translates to:
  /// **'Monthly summary'**
  String get monthlySummary;

  /// No description provided for @balanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balanceLabel;

  /// No description provided for @incomePercentage.
  ///
  /// In en, this message translates to:
  /// **'{percentage}% of income spent'**
  String incomePercentage(Object percentage);

  /// No description provided for @reportCardTransactions.
  ///
  /// In en, this message translates to:
  /// **'{count} transactions in {month}'**
  String reportCardTransactions(Object count, Object month);

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @confirmDeleteImage.
  ///
  /// In en, this message translates to:
  /// **'Remove photo?'**
  String get confirmDeleteImage;

  /// No description provided for @confirmDeleteImageHint.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone'**
  String get confirmDeleteImageHint;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get confirmLogout;

  /// No description provided for @confirmLogoutHint.
  ///
  /// In en, this message translates to:
  /// **'You will be redirected to the login screen'**
  String get confirmLogoutHint;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @dangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger zone'**
  String get dangerZone;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal info'**
  String get personalInfo;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstName;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
