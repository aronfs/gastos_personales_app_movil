// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get titleSplash => 'Cost-Expenses';

  @override
  String get descriptionSplash => 'Your Money, Your Control, and Your Financial Freedom';

  @override
  String get titleSignIn => 'Welcome Back';

  @override
  String get descriptionSignIn => 'Sign In to continue';

  @override
  String get labelemail => 'Email';

  @override
  String get labelpassword => 'Password';

  @override
  String get labelforgotpassword => 'Forgot Password?';

  @override
  String get btnsignin => 'Sign In';

  @override
  String get labeldontaccount => 'Don\'t have an account?';

  @override
  String get btnsignup => 'Sign Up';

  @override
  String get hintEmail => 'Your@email.com';

  @override
  String get hintPassword => '*******';

  @override
  String get titleSignUp => 'Create Account';

  @override
  String get labelName => 'Name';

  @override
  String get hintName => 'Your Name';

  @override
  String get labelConfirmPassword => 'Confirm Password';

  @override
  String get descriptionPolities => 'Register accept to the terms and Conditions of privacy';

  @override
  String get greeting => 'Hello';

  @override
  String get balance => 'Balance';

  @override
  String get incost => 'in';

  @override
  String get enough => 'enough';

  @override
  String get saving => 'Save';

  @override
  String get goal => 'Goal';

  @override
  String get signInWithBiometric => 'Sign in with fingerprint';

  @override
  String get fingerprintNotRegisteredTitle => 'Register fingerprint';

  @override
  String get fingerprintNotRegisteredMessage => 'No fingerprints registered on this device. Go to Settings > Security and register a fingerprint to use this feature.';

  @override
  String get cancel => 'Cancel';

  @override
  String get goToSettings => 'Go to Settings';

  @override
  String get enableFingerprintTitle => 'Enable fingerprint?';

  @override
  String get enableFingerprintMessage => 'You can use your fingerprint to log in faster without a password.';

  @override
  String get notNow => 'Not now';

  @override
  String get enable => 'Enable';

  @override
  String get fingerprintActivated => 'Fingerprint activated successfully';

  @override
  String get enterYourName => 'Enter your name';

  @override
  String get enterYourLastName => 'Enter your last name';

  @override
  String get enterValidEmail => 'Enter a valid email';

  @override
  String get enterPassword => 'Enter a password';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get passwordsDontMatch => 'Passwords don\'t match';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get signIn => 'Sign In';

  @override
  String get lastName => 'Last Name';

  @override
  String get hintLastName => 'Your last name';

  @override
  String get navDashboard => 'Home';

  @override
  String get navMovements => 'Movements';

  @override
  String get navReports => 'Reports';

  @override
  String get navProfile => 'Profile';

  @override
  String get searchMovement => 'Search movement...';

  @override
  String get retry => 'Retry';

  @override
  String get noMovements => 'No movements';

  @override
  String movementCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count movements',
      one: '1 movement',
    );
    return '$_temp0';
  }

  @override
  String get editExpense => 'Edit expense';

  @override
  String get newExpense => 'New expense';

  @override
  String get expenseAmount => 'Amount';

  @override
  String get searchExpense => 'Search expense...';

  @override
  String get noExpenses => 'No expenses registered';

  @override
  String get deleteExpense => 'Delete expense';

  @override
  String deleteExpenseConfirm(Object description) {
    return 'Delete \"$description\"?';
  }

  @override
  String get delete => 'Delete';

  @override
  String get categorySection => 'CATEGORY';

  @override
  String get selectCategory => 'Select';

  @override
  String get loadingCategories => 'Loading categories...';

  @override
  String get noCategoriesAvailable => 'No categories available';

  @override
  String get date => 'Date';

  @override
  String get description => 'Description';

  @override
  String get hintDescriptionExpense => 'E.g: Lunch at restaurant';

  @override
  String get hintAmount => '0.00';

  @override
  String get attachReceipt => 'Attach receipt';

  @override
  String get savingDots => 'Saving...';

  @override
  String get updateExpense => 'Update expense';

  @override
  String get saveExpense => 'Save expense';

  @override
  String get deleteExpenseAction => 'Delete expense';

  @override
  String get enterValidAmount => 'Enter a valid amount';

  @override
  String get selectCategoryError => 'Select a category';

  @override
  String get enterDescription => 'Enter a description';

  @override
  String get editIncome => 'Edit income';

  @override
  String get newIncome => 'New income';

  @override
  String get incomeLabel => 'Income';

  @override
  String get incomeSource => 'SOURCE';

  @override
  String get loadingSources => 'Loading sources...';

  @override
  String get selectSource => 'Select';

  @override
  String get noSourcesAvailable => 'No sources available';

  @override
  String get hintDescriptionIncome => 'E.g: Product sale';

  @override
  String get updateIncome => 'Update income';

  @override
  String get saveIncome => 'Register income';

  @override
  String get deleteIncomeAction => 'Delete income';

  @override
  String get selectSourceError => 'Select a source';

  @override
  String get enterDescriptionIncome => 'Enter a description';

  @override
  String get incomesMonth => 'Monthly income';

  @override
  String get incomePageTitle => 'Income';

  @override
  String get deleteIncomeTitle => 'Delete income';

  @override
  String deleteIncomeConfirm(Object description) {
    return 'Delete \"$description\"?';
  }

  @override
  String get noIncomes => 'No incomes registered';

  @override
  String get categoriesTitle => 'Categories';

  @override
  String get categoryCreateSuccess => 'Category created successfully.';

  @override
  String get categoryUpdateSuccess => 'Category updated successfully.';

  @override
  String get deleteCategory => 'Delete category';

  @override
  String deleteCategoryConfirm(Object name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get noCategories => 'No categories';

  @override
  String get newCategory => 'New category';

  @override
  String get editCategory => 'Edit category';

  @override
  String get categoryName => 'Name';

  @override
  String get categoryNameRequired => 'Name is required';

  @override
  String get iconLabel => 'ICON';

  @override
  String get colorLabel => 'COLOR';

  @override
  String get categoryType => 'Type';

  @override
  String get expenseType => 'Expense';

  @override
  String get incomeType => 'Income';

  @override
  String get createCategory => 'Create category';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get deleteImage => 'Delete image';

  @override
  String get lightTheme => 'Light theme';

  @override
  String get darkTheme => 'Dark theme';

  @override
  String get logout => 'Log out';

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String get deleteProfileImageTitle => 'Delete profile image';

  @override
  String get deleteProfileImageMessage => 'Are you sure you want to delete your profile photo?';

  @override
  String get retryLabel => 'Retry';

  @override
  String get appearance => 'Appearance';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get language => 'Language';

  @override
  String get preferences => 'Preferences';

  @override
  String get currency => 'Currency';

  @override
  String get pushNotifications => 'Push notifications';

  @override
  String get weeklyEmailSummary => 'Weekly summary\nby email';

  @override
  String get languagePickerTitle => 'Language';

  @override
  String get currencyPickerTitle => 'Currency';

  @override
  String get securityTitle => 'Security';

  @override
  String get accountSection => 'Account';

  @override
  String get changePassword => 'Change password';

  @override
  String get biometricAccess => 'Biometric access';

  @override
  String get sms2FA => 'SMS 2FA';

  @override
  String get activeSessions => 'Active sessions';

  @override
  String get currentSession => 'Current';

  @override
  String get closeAllSessions => 'Close all sessions';

  @override
  String get closeAllSessionsTitle => 'Close all sessions';

  @override
  String get closeAllSessionsMessage => 'All active sessions will be closed, including the current one. You will need to log in again.';

  @override
  String get closeAll => 'Close all';

  @override
  String get sessionsClosed => 'Sessions closed successfully';

  @override
  String get changePasswordTitle => 'Change password';

  @override
  String get currentPassword => 'Current password';

  @override
  String get newPassword => 'New password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get savePassword => 'Save password';

  @override
  String get passwordUpdated => 'Password updated successfully';

  @override
  String get enterCurrentPassword => 'Enter your current password';

  @override
  String get enterNewPassword => 'Enter a new password';

  @override
  String get newPasswordMinLength => 'New password must be at least 6 characters';

  @override
  String get passwordsDoNotMatch => 'Passwords don\'t match';

  @override
  String get settings => 'Settings';

  @override
  String get firstname => 'First name';

  @override
  String get firstnameRequired => 'First name is required';

  @override
  String get firstnameMin => 'Minimum 2 characters';

  @override
  String get firstnameMax => 'Maximum 100 characters';

  @override
  String get lastname => 'Last name';

  @override
  String get lastnameRequired => 'Last name is required';

  @override
  String get lastnameMin => 'Minimum 2 characters';

  @override
  String get lastnameMax => 'Maximum 100 characters';

  @override
  String get saveChangesButton => 'Save changes';

  @override
  String get editProfileTitle => 'Edit profile';

  @override
  String get newProduct => 'New product';

  @override
  String get productName => 'Name';

  @override
  String get productDescription => 'Description';

  @override
  String get hintProductName => 'E.g. Rice';

  @override
  String get hintProductDescription => 'E.g. Brown rice 1kg';

  @override
  String get unitPriceLabel => 'UNIT PRICE';

  @override
  String get categoryLabel => 'CATEGORY';

  @override
  String get productPreviewName => 'Name';

  @override
  String get productPreviewDescription => 'Description';

  @override
  String get createProduct => 'Create product';

  @override
  String get creatingDots => 'Creating...';

  @override
  String get selectCategoryProduct => 'Select category';

  @override
  String get loadingDots => 'Loading...';

  @override
  String get noCategoriesError => 'No categories available or could not be loaded';

  @override
  String get selectCategoryProductError => 'Select a category';

  @override
  String get enterNameError => 'Enter a name';

  @override
  String get enterValidPriceError => 'Enter a valid price';

  @override
  String get supermarketExpense => 'Supermarket expense';

  @override
  String get remainingBudget => 'Remaining budget';

  @override
  String get totalCart => 'Cart total:';

  @override
  String get supermarketCategory => 'Category';

  @override
  String get supermarketDescription => 'Description';

  @override
  String get hintSupermarketDescription => 'Supermaxi purchase';

  @override
  String get products => 'Products';

  @override
  String get addProduct => '+ Add';

  @override
  String get emptyCartMessage => 'Press \"+ Add\" to add products';

  @override
  String get save => 'Save';

  @override
  String get enterDescriptionSupermarket => 'Enter a description';

  @override
  String get selectCategorySupermarket => 'Select category';

  @override
  String get scanReceipt => 'Scan Receipt';

  @override
  String get noCameraDetected => 'No camera detected';

  @override
  String get cameraError => 'Error initializing camera';

  @override
  String get capturingImage => 'Capturing image...';

  @override
  String get selectingImage => 'Selecting image...';

  @override
  String get processingOcr => 'Processing OCR...';

  @override
  String get analyzingReceipt => 'Analyzing receipt...';

  @override
  String get detectingTotal => 'Detecting total...';

  @override
  String get imageProcessingError => 'Error processing image';

  @override
  String get captureError => 'Error capturing image';

  @override
  String get takePhotoHint => 'Take a photo of the receipt';

  @override
  String get receiptListTitle => 'Scan Receipts';

  @override
  String get clearList => 'Clear list';

  @override
  String get clearListTitle => 'Clear list';

  @override
  String get clearListConfirm => 'Delete all scanned receipts?';

  @override
  String get clear => 'Clear';

  @override
  String get noReceipts => 'No scanned receipts';

  @override
  String get noReceiptsHint => 'Scan or select a receipt\nto get started';

  @override
  String get totalAccumulated => 'TOTAL ACCUMULATED';

  @override
  String get scanButton => 'Scan';

  @override
  String get registerExpense => 'Register expense';

  @override
  String get scannedReceipt => 'Scanned receipt';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusNeedsReview => 'Needs review';

  @override
  String get statusProcessing => 'Processing';

  @override
  String get statusError => 'Error';

  @override
  String get tapToReview => 'Tap to review';

  @override
  String get productSaved => 'Product saved successfully.';

  @override
  String get confirmDataTitle => 'Confirm data';

  @override
  String get confirmDataMessage => 'Review the data detected by the scanner.';

  @override
  String get productNameLabel => 'Product name';

  @override
  String get presentationLabel => 'Presentation';

  @override
  String get priceLabel => 'Price';

  @override
  String get saveProduct => 'Save product';

  @override
  String get rescan => 'Rescan';

  @override
  String get enterName => 'Enter a name';

  @override
  String get detectedByOcr => 'Detected by OCR';

  @override
  String get reviewReceipt => 'Review receipt';

  @override
  String get detectedTotal => 'Detected total';

  @override
  String get enterTotal => 'Enter the total';

  @override
  String get enterValidTotal => 'Enter a valid amount';

  @override
  String get detectedText => 'DETECTED TEXT';

  @override
  String get noTextDetected => 'No text detected';

  @override
  String get confirmReceipt => 'Confirm receipt';

  @override
  String get reviewReceiptCancel => 'Cancel';

  @override
  String get notificationSettings => 'Notifications';

  @override
  String get channelsSection => 'Channels';

  @override
  String get pushChannel => 'Push';

  @override
  String get pushSubtitle => 'Device notifications';

  @override
  String get emailChannel => 'Email';

  @override
  String get emailSubtitle => 'Email notifications';

  @override
  String get smsChannel => 'SMS';

  @override
  String get smsSubtitle => 'Text message notifications';

  @override
  String get alertsSection => 'Alerts';

  @override
  String get paymentReminders => 'Payment reminders';

  @override
  String get paymentRemindersSubtitle => 'Before the due date';

  @override
  String get weeklySummaryTitle => 'Weekly summary';

  @override
  String get weeklySummarySubtitle => 'You\'ll receive a summary every Monday';

  @override
  String get welcomeTitle => 'Welcome!';

  @override
  String get welcomeMessage => 'It looks like you don\'t have any categories yet. Let\'s create some basic ones so you can start recording your income and expenses.';

  @override
  String get willCreateCategories => 'The following categories will be created:';

  @override
  String get salary => 'Salary';

  @override
  String get food => 'Food';

  @override
  String get transport => 'Transport';

  @override
  String get createInitialCategories => 'Create initial categories';

  @override
  String get initialCategoriesCreated => 'Initial categories created successfully.';

  @override
  String get quickActions => 'Quick actions';

  @override
  String get quickActionsHeading => 'What would you like to do?';

  @override
  String get registerIncome => 'Register an income';

  @override
  String get recordExpense => 'Record an expense';

  @override
  String get supermarketPurchase => 'Supermarket purchase';

  @override
  String get addProductAction => 'Add a product';

  @override
  String get scanProduct => 'Scan product';

  @override
  String get readBarcode => 'Read barcode';

  @override
  String get scanReceipts => 'Scan receipts';

  @override
  String get ocrReceipts => 'OCR for receipts';

  @override
  String get all => 'All';

  @override
  String get selectProduct => 'Select product';

  @override
  String get addProductTitle => 'Add product';

  @override
  String get searchProducts => 'Search products...';

  @override
  String movementCountLabel(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 's',
      one: '',
    );
    return '$count movement$_temp0';
  }

  @override
  String get selectLanguage => 'Select language';

  @override
  String get incomeReports => 'Income';

  @override
  String get expenseReports => 'Expenses';

  @override
  String get balanceReports => 'Balance';

  @override
  String transactionsCount(Object count, Object month) {
    return '$count transactions in $month';
  }

  @override
  String get categoriesHeader => 'Categories';

  @override
  String get manageButton => 'Manage';

  @override
  String get periodWeek => 'Week';

  @override
  String get periodMonth => 'Month';

  @override
  String get periodYear => 'Year';

  @override
  String get monthlySummary => 'Monthly summary';

  @override
  String get balanceLabel => 'Balance';

  @override
  String incomePercentage(Object percentage) {
    return '$percentage% of income spent';
  }

  @override
  String reportCardTransactions(Object count, Object month) {
    return '$count transactions in $month';
  }

  @override
  String get spanish => 'Spanish';

  @override
  String get english => 'English';
}
