import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:my_shop_ecommerce_flutter/src/exceptions/app_exception.dart';
import 'package:my_shop_ecommerce_flutter/src/features/authentication/domain/fake_app_user.dart';
import 'package:my_shop_ecommerce_flutter/src/features/authentication/application/auth_service.dart';

import '../../../../mocks.dart';

void main() {
  const fakeUserId = '123';
  const fakeUser = FakeAppUser(uid: fakeUserId);
  late MockAuthRepository mockAuthRepository;
  late MockCartSyncService mockCartSyncService;
  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockCartSyncService = MockCartSyncService();
    // Fallback value for email anad password
    registerFallbackValue('');
  });

  group('signInWithEmailAndPassword', () {
    test('signInWithEmailAndPassword and copyItemsToRemote succeed', () async {
      // setup
      when(() => mockAuthRepository.signInWithEmailAndPassword(
            captureAny(),
            captureAny(),
          )).thenAnswer((invocation) => Future.value());
      when(() => mockAuthRepository.currentUser).thenReturn(fakeUser);
      when(() => mockCartSyncService.moveItemsToRemote(fakeUserId))
          .thenAnswer((invocation) => Future.value(const Success(null)));
      final authService = AuthService(
        authRepository: mockAuthRepository,
        cartSyncService: mockCartSyncService,
      );
      // run
      final result =
          await authService.signInWithEmailAndPassword('email', 'password');
      // verify
      expect(result.isSuccess(), true);
    });

    test('signInWithEmailAndPassword succeeds, copyItemsToRemote fails',
        () async {
      // setup
      when(() => mockAuthRepository.signInWithEmailAndPassword(
            captureAny(),
            captureAny(),
          )).thenAnswer((invocation) => Future.value());
      when(() => mockAuthRepository.currentUser).thenReturn(fakeUser);
      when(() => mockCartSyncService.moveItemsToRemote(fakeUserId)).thenAnswer(
        (_) async =>
            Future.value(const Error(AppException.permissionDenied(''))),
      );
      final authService = AuthService(
        authRepository: mockAuthRepository,
        cartSyncService: mockCartSyncService,
      );
      // run
      final result =
          await authService.signInWithEmailAndPassword('email', 'password');
      // verify
      expect(result.isError(), true);
    });

    test('signInWithEmailAndPassword fails, copyItemsToRemote not called',
        () async {
      // setup
      const exception = AppException.invalidEmail('');
      when(() => mockAuthRepository.signInWithEmailAndPassword(
            captureAny(),
            captureAny(),
          )).thenThrow(exception); // will generate AppException.unknown
      when(() => mockAuthRepository.currentUser).thenReturn(null);
      final authService = AuthService(
        authRepository: mockAuthRepository,
        cartSyncService: mockCartSyncService,
      );
      // run
      final result =
          await authService.signInWithEmailAndPassword('email', 'password');
      // verify
      expect(result.isError(), true);
      verifyNever(() => mockCartSyncService.moveItemsToRemote(fakeUserId));
    });
  });

  group('createUserWithEmailAndPassword', () {
    test('createUserWithEmailAndPassword and copyItemsToRemote succeed',
        () async {
      // setup
      when(() => mockAuthRepository.createUserWithEmailAndPassword(
            captureAny(),
            captureAny(),
          )).thenAnswer((invocation) => Future.value());
      when(() => mockAuthRepository.currentUser).thenReturn(fakeUser);
      when(() => mockCartSyncService.moveItemsToRemote(fakeUserId))
          .thenAnswer((invocation) => Future.value(const Success(null)));
      final authService = AuthService(
        authRepository: mockAuthRepository,
        cartSyncService: mockCartSyncService,
      );
      // run
      final result =
          await authService.createUserWithEmailAndPassword('email', 'password');
      // verify
      expect(result.isSuccess(), true);
    });

    test('createUserWithEmailAndPassword succeeds, copyItemsToRemote fails',
        () async {
      // setup
      when(() => mockAuthRepository.createUserWithEmailAndPassword(
            captureAny(),
            captureAny(),
          )).thenAnswer((invocation) => Future.value());
      when(() => mockAuthRepository.currentUser).thenReturn(fakeUser);
      when(() => mockCartSyncService.moveItemsToRemote(fakeUserId)).thenAnswer(
        (_) async =>
            Future.value(const Error(AppException.permissionDenied(''))),
      );
      final authService = AuthService(
        authRepository: mockAuthRepository,
        cartSyncService: mockCartSyncService,
      );
      // run
      final result =
          await authService.createUserWithEmailAndPassword('email', 'password');
      // verify
      expect(result.isError(), true);
    });

    test('createUserWithEmailAndPassword fails, copyItemsToRemote not called',
        () async {
      // setup
      const exception = AppException.invalidEmail('');
      when(() => mockAuthRepository.createUserWithEmailAndPassword(
            captureAny(),
            captureAny(),
          )).thenThrow(exception); // will generate AppException.unknown
      when(() => mockAuthRepository.currentUser).thenReturn(null);
      final authService = AuthService(
        authRepository: mockAuthRepository,
        cartSyncService: mockCartSyncService,
      );
      // run
      final result =
          await authService.createUserWithEmailAndPassword('email', 'password');
      // verify
      expect(result.isError(), true);
      verifyNever(() => mockCartSyncService.moveItemsToRemote(fakeUserId));
    });
  });

  group('sendPasswordResetEmail', () {
    test('sendPasswordResetEmail called, copyItemsToRemote not called',
        () async {
      // setup
      when(() => mockAuthRepository.sendPasswordResetEmail(
            captureAny(),
          )).thenAnswer((invocation) => Future.value());
      final authService = AuthService(
        authRepository: mockAuthRepository,
        cartSyncService: mockCartSyncService,
      );
      // run & verify
      final result = await authService.sendPasswordResetEmail('email');
      expect(result.isSuccess(), true);
      verifyNever(() => mockCartSyncService.moveItemsToRemote(fakeUserId));
    });
  });
}
