import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> isAvailable() async {
    try {
      await _ensureBiometricReady();
      return true;
    } on BiometricException catch (e) {
      debugPrint('Biometría no disponible: ${e.code} ${e.message}');
      return false;
    } catch (e) {
      debugPrint('Error checking biometric availability: $e');
      return false;
    }
  }

  Future<bool> authenticate() async {
    await _ensureBiometricReady();

    try {
      final result = await _auth.authenticate(
        localizedReason: 'Coloca tu huella para iniciar sesión',
        biometricOnly: true,
        persistAcrossBackgrounding: true,
        sensitiveTransaction: true,
      );
      debugPrint('Resultado autenticación: $result');
      if (!result) {
        throw BiometricException.cancelled();
      }
      return true;
    } on PlatformException catch (e) {
      debugPrint('PlatformException: ${e.code} ${e.message}');
      throw _mapError(e.code);
    } on LocalAuthException catch (e) {
      debugPrint('LocalAuthException: ${e.code.name} ${e.description}');
      throw _mapLocalAuthError(e);
    } catch (e) {
      debugPrint('Unexpected auth error: $e');
      throw BiometricException('Error inesperado: ${e.toString()}', 'Unknown');
    }
  }

  Future<bool> authenticateForEnable() async {
    await _ensureBiometricReady();

    try {
      final result = await _auth.authenticate(
        localizedReason: 'Confirma tu identidad para activar la huella',
        biometricOnly: true,
        persistAcrossBackgrounding: true,
        sensitiveTransaction: true,
      );
      if (!result) {
        throw BiometricException.cancelled();
      }
      return true;
    } on PlatformException catch (e) {
      debugPrint('PlatformException: ${e.code} ${e.message}');
      throw _mapError(e.code);
    } on LocalAuthException catch (e) {
      debugPrint('LocalAuthException: ${e.code.name} ${e.description}');
      throw _mapLocalAuthError(e);
    } catch (e) {
      debugPrint('Unexpected auth error: $e');
      throw BiometricException('Error inesperado: ${e.toString()}', 'Unknown');
    }
  }

  Future<void> _ensureBiometricReady() async {
    try {
      final supported = await _auth.isDeviceSupported();
      final canCheck = await _auth.canCheckBiometrics;
      final enrolled = await _auth.getAvailableBiometrics();

      debugPrint('Dispositivo soportado: $supported');
      debugPrint('Biometría disponible: $canCheck');
      debugPrint('Biometrías registradas: $enrolled');

      if (!supported || !canCheck) {
        throw BiometricException.notAvailable();
      }
      if (enrolled.isEmpty) {
        throw BiometricException.notEnrolled();
      }
    } on BiometricException {
      rethrow;
    } on LocalAuthException catch (e) {
      throw _mapLocalAuthError(e);
    } on PlatformException catch (e) {
      throw _mapError(e.code);
    }
  }

  BiometricException _mapLocalAuthError(LocalAuthException e) {
    switch (e.code) {
      case LocalAuthExceptionCode.authInProgress:
        return const BiometricException(
          'Ya hay una autenticación biométrica en curso.',
          'AuthInProgress',
        );
      case LocalAuthExceptionCode.uiUnavailable:
        return const BiometricException(
          'No se pudo abrir la autenticación biométrica. Intenta de nuevo o usa tu contraseña.',
          'UiUnavailable',
        );
      case LocalAuthExceptionCode.noBiometricHardware:
        return BiometricException.notAvailable();
      case LocalAuthExceptionCode.noBiometricsEnrolled:
        return BiometricException.notEnrolled();
      case LocalAuthExceptionCode.biometricHardwareTemporarilyUnavailable:
        return const BiometricException(
          'La biometría no está disponible temporalmente. Intenta de nuevo.',
          'TemporarilyUnavailable',
        );
      case LocalAuthExceptionCode.temporaryLockout:
        return BiometricException.lockedOut();
      case LocalAuthExceptionCode.biometricLockout:
        return BiometricException.permanentlyLockedOut();
      case LocalAuthExceptionCode.userCanceled:
        return BiometricException.cancelled();
      case LocalAuthExceptionCode.systemCanceled:
        return BiometricException.cancelled();
      case LocalAuthExceptionCode.timeout:
        return BiometricException.cancelled();
      case LocalAuthExceptionCode.userRequestedFallback:
        return BiometricException.cancelled();
      case LocalAuthExceptionCode.noCredentialsSet:
        return BiometricException.notAvailable();
      case LocalAuthExceptionCode.deviceError:
        return BiometricException(
          'Error del dispositivo biométrico: ${e.description ?? 'intenta de nuevo'}',
          'DeviceError',
        );
      case LocalAuthExceptionCode.unknownError:
        return BiometricException(
          'Error de autenticación: ${e.description ?? e.code.name}',
          e.code.name,
        );
    }
  }

  BiometricException _mapError(String code) {
    switch (code) {
      case 'NotAvailable':
        return BiometricException.notAvailable();
      case 'NotEnrolled':
        return BiometricException.notEnrolled();
      case 'LockedOut':
        return BiometricException.lockedOut();
      case 'PermanentlyLockedOut':
        return BiometricException.permanentlyLockedOut();
      case 'PasscodeNotSet':
        return BiometricException.notAvailable();
      default:
        return BiometricException.cancelled();
    }
  }

  static Future<bool> openBiometricSettings() async {
    const channel = MethodChannel('com.example.gastos_personales/settings');
    try {
      await channel.invokeMethod('openSecuritySettings');
      return true;
    } catch (e) {
      debugPrint('Error opening biometric settings: $e');
      return false;
    }
  }
}

class BiometricException implements Exception {
  final String message;
  final String code;

  const BiometricException(this.message, this.code);

  factory BiometricException.notAvailable() => const BiometricException(
    'El dispositivo no tiene biometría configurada',
    'NotAvailable',
  );

  factory BiometricException.notEnrolled() => const BiometricException(
    'No hay huellas registradas. Registra una en Ajustes > Seguridad',
    'NotEnrolled',
  );

  factory BiometricException.lockedOut() => const BiometricException(
    'Demasiados intentos fallidos. Espera un momento o usa tu contraseña',
    'LockedOut',
  );

  factory BiometricException.permanentlyLockedOut() => const BiometricException(
    'Biometría bloqueada. Inicia sesión con tu contraseña',
    'PermanentlyLockedOut',
  );

  factory BiometricException.cancelled() =>
      const BiometricException('Autenticación cancelada', 'UserCancel');

  @override
  String toString() => message;
}
