// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get titleSplash => 'Gastos-Personales';

  @override
  String get descriptionSplash => 'Tu Dinero, Tu Control, y Tu Libertad Financiera';

  @override
  String get titleSignIn => 'Bienvenido de vuelta';

  @override
  String get descriptionSignIn => 'Ingresa para continuar';

  @override
  String get labelemail => 'Email';

  @override
  String get labelpassword => 'Contraseña';

  @override
  String get labelforgotpassword => '¿Olvidaste tu contraseña?';

  @override
  String get btnsignin => 'Iniciar Sesión';

  @override
  String get labeldontaccount => '¿No tienes una cuenta?';

  @override
  String get btnsignup => 'Registrarse';

  @override
  String get hintEmail => 'Tu@correo.com';

  @override
  String get hintPassword => '*******';

  @override
  String get titleSignUp => 'Crear Cuenta';

  @override
  String get labelName => 'Nombre';

  @override
  String get hintName => 'Tu nombre';

  @override
  String get labelConfirmPassword => 'Confirmar Contraseña';

  @override
  String get descriptionPolities => 'Al registrarte aceptas los términos y condiciones de privacidad';

  @override
  String get greeting => 'Hola';

  @override
  String get balance => 'Balance Total';

  @override
  String get incost => 'ingresos';

  @override
  String get enough => 'gastos';

  @override
  String get saving => 'Ahorro';

  @override
  String get goal => 'Meta';

  @override
  String get signInWithBiometric => 'Entrar con huella';

  @override
  String get fingerprintNotRegisteredTitle => 'Registrar huella digital';

  @override
  String get fingerprintNotRegisteredMessage => 'No hay huellas registradas en el dispositivo. Ve a Ajustes > Seguridad y registra una huella para usar esta función.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get goToSettings => 'Ir a Ajustes';

  @override
  String get enableFingerprintTitle => '¿Activar huella digital?';

  @override
  String get enableFingerprintMessage => 'Puedes usar tu huella digital para iniciar sesión más rápido sin contraseña.';

  @override
  String get notNow => 'Ahora no';

  @override
  String get enable => 'Activar';

  @override
  String get fingerprintActivated => 'Huella digital activada correctamente';

  @override
  String get enterYourName => 'Ingresa tu nombre';

  @override
  String get enterYourLastName => 'Ingresa tu apellido';

  @override
  String get enterValidEmail => 'Ingresa un email válido';

  @override
  String get enterPassword => 'Ingresa una contraseña';

  @override
  String get passwordMinLength => 'La contraseña debe tener al menos 6 caracteres';

  @override
  String get passwordsDontMatch => 'Las contraseñas no coinciden';

  @override
  String get alreadyHaveAccount => '¿Ya tienes cuenta? ';

  @override
  String get signIn => 'Inicia sesión';

  @override
  String get lastName => 'Apellido';

  @override
  String get hintLastName => 'Tu apellido';

  @override
  String get navDashboard => 'Inicio';

  @override
  String get navMovements => 'Movimientos';

  @override
  String get navReports => 'Reportes';

  @override
  String get navProfile => 'Perfil';

  @override
  String get searchMovement => 'Buscar movimiento...';

  @override
  String get retry => 'Reintentar';

  @override
  String get noMovements => 'Sin movimientos';

  @override
  String movementCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count movimientos',
      one: '1 movimiento',
    );
    return '$_temp0';
  }

  @override
  String get editExpense => 'Editar gasto';

  @override
  String get newExpense => 'Nuevo gasto';

  @override
  String get expenseAmount => 'Monto';

  @override
  String get searchExpense => 'Buscar gasto...';

  @override
  String get noExpenses => 'Sin gastos registrados';

  @override
  String get deleteExpense => 'Eliminar gasto';

  @override
  String deleteExpenseConfirm(Object description) {
    return '¿Eliminar \"$description\"?';
  }

  @override
  String get delete => 'Eliminar';

  @override
  String get categorySection => 'CATEGORÍA';

  @override
  String get selectCategory => 'Seleccionar';

  @override
  String get loadingCategories => 'Cargando categorías...';

  @override
  String get noCategoriesAvailable => 'No hay categorías disponibles';

  @override
  String get date => 'Fecha';

  @override
  String get description => 'Descripción';

  @override
  String get hintDescriptionExpense => 'Ej: Almuerzo en restaurante';

  @override
  String get hintAmount => '0.00';

  @override
  String get attachReceipt => 'Adjuntar comprobante';

  @override
  String get savingDots => 'Guardando...';

  @override
  String get updateExpense => 'Actualizar gasto';

  @override
  String get saveExpense => 'Guardar gasto';

  @override
  String get deleteExpenseAction => 'Eliminar gasto';

  @override
  String get enterValidAmount => 'Ingresa un monto válido';

  @override
  String get selectCategoryError => 'Selecciona una categoría';

  @override
  String get enterDescription => 'Ingresa una descripción';

  @override
  String get editIncome => 'Editar ingreso';

  @override
  String get newIncome => 'Nuevo ingreso';

  @override
  String get incomeLabel => 'Ingreso';

  @override
  String get incomeSource => 'FUENTE';

  @override
  String get loadingSources => 'Cargando fuentes...';

  @override
  String get selectSource => 'Seleccionar';

  @override
  String get noSourcesAvailable => 'No hay fuentes disponibles';

  @override
  String get hintDescriptionIncome => 'Ej: Venta de producto';

  @override
  String get updateIncome => 'Actualizar ingreso';

  @override
  String get saveIncome => 'Registrar ingreso';

  @override
  String get deleteIncomeAction => 'Eliminar ingreso';

  @override
  String get selectSourceError => 'Selecciona una fuente';

  @override
  String get enterDescriptionIncome => 'Ingresa una descripción';

  @override
  String get incomesMonth => 'Ingresos del mes';

  @override
  String get incomePageTitle => 'Ingresos';

  @override
  String get deleteIncomeTitle => 'Eliminar ingreso';

  @override
  String deleteIncomeConfirm(Object description) {
    return '¿Eliminar \"$description\"?';
  }

  @override
  String get noIncomes => 'Sin ingresos registrados';

  @override
  String get categoriesTitle => 'Categorías';

  @override
  String get categoryCreateSuccess => 'Categoría creada correctamente.';

  @override
  String get categoryUpdateSuccess => 'Categoría actualizada correctamente.';

  @override
  String get deleteCategory => 'Eliminar categoría';

  @override
  String deleteCategoryConfirm(Object name) {
    return '¿Eliminar \"$name\"?';
  }

  @override
  String get noCategories => 'No hay categorías';

  @override
  String get newCategory => 'Nueva categoría';

  @override
  String get editCategory => 'Editar categoría';

  @override
  String get categoryName => 'Nombre';

  @override
  String get categoryNameRequired => 'El nombre es obligatorio';

  @override
  String get iconLabel => 'ICONO';

  @override
  String get colorLabel => 'COLOR';

  @override
  String get categoryType => 'Tipo';

  @override
  String get expenseType => 'Gasto';

  @override
  String get incomeType => 'Ingreso';

  @override
  String get createCategory => 'Crear categoría';

  @override
  String get saveChanges => 'Guardar Cambios';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get deleteImage => 'Eliminar imagen';

  @override
  String get lightTheme => 'Tema claro';

  @override
  String get darkTheme => 'Tema oscuro';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get active => 'Activo';

  @override
  String get inactive => 'Inactivo';

  @override
  String get deleteProfileImageTitle => 'Eliminar foto de perfil';

  @override
  String get deleteProfileImageMessage => '¿Estás seguro de eliminar tu foto de perfil?';

  @override
  String get retryLabel => 'Reintentar';

  @override
  String get appearance => 'Apariencia';

  @override
  String get darkMode => 'Tema oscuro';

  @override
  String get language => 'Idioma';

  @override
  String get preferences => 'Preferencias';

  @override
  String get currency => 'Moneda';

  @override
  String get pushNotifications => 'Notificaciones push';

  @override
  String get weeklyEmailSummary => 'Resumen semanal\npor email';

  @override
  String get languagePickerTitle => 'Idioma';

  @override
  String get currencyPickerTitle => 'Moneda';

  @override
  String get securityTitle => 'Seguridad';

  @override
  String get accountSection => 'Cuenta';

  @override
  String get changePassword => 'Cambiar contraseña';

  @override
  String get biometricAccess => 'Acceso biométrico';

  @override
  String get sms2FA => '2FA por SMS';

  @override
  String get activeSessions => 'Sesiones activas';

  @override
  String get currentSession => 'Actual';

  @override
  String get closeAllSessions => 'Cerrar todas las sesiones';

  @override
  String get closeAllSessionsTitle => 'Cerrar todas las sesiones';

  @override
  String get closeAllSessionsMessage => 'Se cerrarán todas las sesiones activas, incluyendo la actual. Deberás iniciar sesión nuevamente.';

  @override
  String get closeAll => 'Cerrar todo';

  @override
  String get sessionsClosed => 'Sesiones cerradas correctamente';

  @override
  String get changePasswordTitle => 'Cambiar contraseña';

  @override
  String get currentPassword => 'Contraseña actual';

  @override
  String get newPassword => 'Nueva contraseña';

  @override
  String get confirmPassword => 'Confirmar contraseña';

  @override
  String get savePassword => 'Guardar contraseña';

  @override
  String get passwordUpdated => 'Contraseña actualizada correctamente';

  @override
  String get enterCurrentPassword => 'Ingresa tu contraseña actual';

  @override
  String get enterNewPassword => 'Ingresa una nueva contraseña';

  @override
  String get newPasswordMinLength => 'La nueva contraseña debe tener al menos 6 caracteres';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get settings => 'Configuración';

  @override
  String get firstname => 'Nombre';

  @override
  String get firstnameRequired => 'El nombre es obligatorio';

  @override
  String get firstnameMin => 'Mínimo 2 caracteres';

  @override
  String get firstnameMax => 'Máximo 100 caracteres';

  @override
  String get lastname => 'Apellido';

  @override
  String get lastnameRequired => 'El apellido es obligatorio';

  @override
  String get lastnameMin => 'Mínimo 2 caracteres';

  @override
  String get lastnameMax => 'Máximo 100 caracteres';

  @override
  String get saveChangesButton => 'Guardar cambios';

  @override
  String get editProfileTitle => 'Editar perfil';

  @override
  String get newProduct => 'Nuevo producto';

  @override
  String get productName => 'Nombre';

  @override
  String get productDescription => 'Descripción';

  @override
  String get hintProductName => 'Ej. Arroz';

  @override
  String get hintProductDescription => 'Ej. Arroz integral 1kg';

  @override
  String get unitPriceLabel => 'PRECIO UNITARIO';

  @override
  String get categoryLabel => 'CATEGORÍA';

  @override
  String get productPreviewName => 'Nombre';

  @override
  String get productPreviewDescription => 'Descripción';

  @override
  String get createProduct => 'Crear producto';

  @override
  String get creatingDots => 'Creando...';

  @override
  String get selectCategoryProduct => 'Seleccionar';

  @override
  String get loadingDots => 'Cargando...';

  @override
  String get noCategoriesError => 'No hay categorías disponibles o no se cargaron correctamente';

  @override
  String get selectCategoryProductError => 'Selecciona una categoría';

  @override
  String get enterNameError => 'Ingresa un nombre';

  @override
  String get enterValidPriceError => 'Ingresa un precio válido';

  @override
  String get supermarketExpense => 'Gasto supermercado';

  @override
  String get remainingBudget => 'Cupo restante';

  @override
  String get totalCart => 'Total carrito:';

  @override
  String get supermarketCategory => 'Categoría';

  @override
  String get supermarketDescription => 'Descripción';

  @override
  String get hintSupermarketDescription => 'Compra Supermaxi';

  @override
  String get products => 'Productos';

  @override
  String get addProduct => '+ Agregar';

  @override
  String get emptyCartMessage => 'Presiona \"+ Agregar\" para añadir productos';

  @override
  String get save => 'Guardar';

  @override
  String get enterDescriptionSupermarket => 'Ingresa una descripción';

  @override
  String get selectCategorySupermarket => 'Seleccionar categoría';

  @override
  String get scanReceipt => 'Escanear Factura';

  @override
  String get noCameraDetected => 'No se detectó la cámara';

  @override
  String get cameraError => 'Error al iniciar la cámara';

  @override
  String get capturingImage => 'Capturando imagen...';

  @override
  String get selectingImage => 'Seleccionando imagen...';

  @override
  String get processingOcr => 'Procesando OCR...';

  @override
  String get analyzingReceipt => 'Analizando factura...';

  @override
  String get detectingTotal => 'Detectando total...';

  @override
  String get imageProcessingError => 'Error al procesar la imagen';

  @override
  String get captureError => 'Error al capturar la imagen';

  @override
  String get takePhotoHint => 'Toma una foto de la factura';

  @override
  String get receiptListTitle => 'Escanear Facturas';

  @override
  String get clearList => 'Limpiar lista';

  @override
  String get clearListTitle => 'Limpiar lista';

  @override
  String get clearListConfirm => '¿Eliminar todas las facturas escaneadas?';

  @override
  String get clear => 'Limpiar';

  @override
  String get noReceipts => 'No hay facturas escaneadas';

  @override
  String get noReceiptsHint => 'Escanea o selecciona una factura\npara comenzar';

  @override
  String get totalAccumulated => 'TOTAL ACUMULADO';

  @override
  String get scanButton => 'Escanear';

  @override
  String get registerExpense => 'Registrar gasto';

  @override
  String get scannedReceipt => 'Factura escaneada';

  @override
  String get statusCompleted => 'Completado';

  @override
  String get statusNeedsReview => 'Requiere revisión';

  @override
  String get statusProcessing => 'Procesando';

  @override
  String get statusError => 'Error';

  @override
  String get tapToReview => 'Toca para revisar';

  @override
  String get productSaved => 'Producto guardado correctamente.';

  @override
  String get confirmDataTitle => 'Confirmar datos';

  @override
  String get confirmDataMessage => 'Revisa los datos detectados por el escáner.';

  @override
  String get productNameLabel => 'Nombre del producto';

  @override
  String get presentationLabel => 'Presentación';

  @override
  String get priceLabel => 'Precio';

  @override
  String get saveProduct => 'Guardar producto';

  @override
  String get rescan => 'Volver a escanear';

  @override
  String get enterName => 'Ingresa un nombre';

  @override
  String get detectedByOcr => 'Detectado por OCR';

  @override
  String get reviewReceipt => 'Revisar factura';

  @override
  String get detectedTotal => 'Total detectado';

  @override
  String get enterTotal => 'Ingresa el total';

  @override
  String get enterValidTotal => 'Ingresa un monto válido';

  @override
  String get detectedText => 'TEXTO DETECTADO';

  @override
  String get noTextDetected => 'Sin texto detectado';

  @override
  String get confirmReceipt => 'Confirmar factura';

  @override
  String get reviewReceiptCancel => 'Cancelar';

  @override
  String get notificationSettings => 'Notificaciones';

  @override
  String get channelsSection => 'Canales';

  @override
  String get pushChannel => 'Push';

  @override
  String get pushSubtitle => 'Notificaciones en el dispositivo';

  @override
  String get emailChannel => 'Email';

  @override
  String get emailSubtitle => 'Notificaciones al correo';

  @override
  String get smsChannel => 'SMS';

  @override
  String get smsSubtitle => 'Notificaciones por mensaje de texto';

  @override
  String get alertsSection => 'Alertas';

  @override
  String get paymentReminders => 'Recordatorios de pago';

  @override
  String get paymentRemindersSubtitle => 'Antes de la fecha de vencimiento';

  @override
  String get weeklySummaryTitle => 'Resumen semanal';

  @override
  String get weeklySummarySubtitle => 'Cada lunes recibirás un resumen';

  @override
  String get welcomeTitle => '¡Bienvenido!';

  @override
  String get welcomeMessage => 'Parece que todavía no tienes categorías. Vamos a crear unas básicas para que puedas comenzar a registrar tus ingresos y gastos.';

  @override
  String get willCreateCategories => 'Se crearán las siguientes categorías:';

  @override
  String get salary => 'Salario';

  @override
  String get food => 'Alimentación';

  @override
  String get transport => 'Transporte';

  @override
  String get createInitialCategories => 'Crear categorías iniciales';

  @override
  String get initialCategoriesCreated => 'Categorías iniciales creadas correctamente.';

  @override
  String get quickActions => 'Acciones rápidas';

  @override
  String get quickActionsHeading => '¿Qué deseas hacer?';

  @override
  String get registerIncome => 'Registrar un ingreso';

  @override
  String get recordExpense => 'Registrar un gasto';

  @override
  String get supermarketPurchase => 'Compra en supermercado';

  @override
  String get addProductAction => 'Agregar un producto';

  @override
  String get scanProduct => 'Escanear producto';

  @override
  String get readBarcode => 'Leer código de barras';

  @override
  String get scanReceipts => 'Escanear facturas';

  @override
  String get ocrReceipts => 'OCR para facturas';

  @override
  String get all => 'Todos';

  @override
  String get selectProduct => 'Seleccionar Categoría';

  @override
  String get addProductTitle => 'Agregar producto';

  @override
  String get searchProducts => 'Buscar productos...';

  @override
  String movementCountLabel(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 's',
      one: '',
    );
    return '$count movimiento$_temp0';
  }

  @override
  String get selectLanguage => 'Seleccionar idioma';

  @override
  String get incomeReports => 'Ingresos';

  @override
  String get expenseReports => 'Gastos';

  @override
  String get balanceReports => 'Balance';

  @override
  String transactionsCount(Object count, Object month) {
    return '$count transacciones en $month';
  }

  @override
  String get categoriesHeader => 'Categorías';

  @override
  String get manageButton => 'Gestionar';

  @override
  String get periodWeek => 'Semana';

  @override
  String get periodMonth => 'Mes';

  @override
  String get periodYear => 'Año';

  @override
  String get monthlySummary => 'Resumen del mes';

  @override
  String get balanceLabel => 'Balance';

  @override
  String incomePercentage(Object percentage) {
    return '$percentage% de tus ingresos gastados';
  }

  @override
  String reportCardTransactions(Object count, Object month) {
    return '$count transacciones en $month';
  }

  @override
  String get spanish => 'Español';

  @override
  String get english => 'English';

  @override
  String get camera => 'Cámara';

  @override
  String get gallery => 'Galería';

  @override
  String get confirmDeleteImage => '¿Eliminar foto?';

  @override
  String get confirmDeleteImageHint => 'Esta acción no se puede deshacer';

  @override
  String get confirm => 'Confirmar';

  @override
  String get confirmLogout => '¿Cerrar sesión?';

  @override
  String get confirmLogoutHint => 'Serás redirigido a la pantalla de inicio';

  @override
  String get account => 'Cuenta';

  @override
  String get dangerZone => 'Zona de peligro';

  @override
  String get personalInfo => 'Información personal';

  @override
  String get firstName => 'Nombre';
}
