import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_shop_ecommerce_flutter/src/models/fake_app_user.dart';
import 'package:my_shop_ecommerce_flutter/src/services/auth_service.dart';

import '../../mocks.dart';

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
          .thenAnswer((invocation) => Future.value());
      final authService = AuthService(
        authRepository: mockAuthRepository,
        cartSyncService: mockCartSyncService,
      );
      // run & verify
      expect(
        () => authService.signInWithEmailAndPassword('email', 'password'),
        returnsNormally,
      );
    });

    test('signInWithEmailAndPassword succeeds, copyItemsToRemote fails',
        () async {
      // setup
      final exception = Exception('failed copying items');
      when(() => mockAuthRepository.signInWithEmailAndPassword(
            captureAny(),
            captureAny(),
          )).thenAnswer((invocation) => Future.value());
      when(() => mockAuthRepository.currentUser).thenReturn(fakeUser);
      when(() => mockCartSyncService.moveItemsToRemote(fakeUserId)).thenThrow(exception);
      final authService = AuthService(
        authRepository: mockAuthRepository,
        cartSyncService: mockCartSyncService,
      );
      // run & verify
      expect(
        () => authService.signInWithEmailAndPassword('email', 'password'),
        throwsA(isA<Exception>()),
      );
    });

    test('signInWithEmailAndPassword fails, copyItemsToRemote not called',
        () async {
      // setup
      final exception = Exception('failed sign in');
      when(() => mockAuthRepository.signInWithEmailAndPassword(
            captureAny(),
            captureAny(),
          )).thenThrow(exception);
      final authService = AuthService(
        authRepository: mockAuthRepository,
        cartSyncService: mockCartSyncService,
      );
      // run & verify
      expect(
        () => authService.signInWithEmailAndPassword('email', 'password'),
        throwsA(isA<Exception>()),
      );
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
          .thenAnswer((invocation) => Future.value());
      final authService = AuthService(
        authRepository: mockAuthRepository,
        cartSyncService: mockCartSyncService,
      );
      // run & verify
      expect(
        () => authService.createUserWithEmailAndPassword('email', 'password'),
        returnsNormally,
      );
    });

    test('createUserWithEmailAndPassword succeeds, copyItemsToRemote fails',
        () async {
      // setup
      final exception = Exception('failed copying items');
      when(() => mockAuthRepository.createUserWithEmailAndPassword(
            captureAny(),
            captureAny(),
          )).thenAnswer((invocation) => Future.value());
      when(() => mockAuthRepository.currentUser).thenReturn(fakeUser);
      when(() => mockCartSyncService.moveItemsToRemote(fakeUserId)).thenThrow(exception);
      final authService = AuthService(
        authRepository: mockAuthRepository,
        cartSyncService: mockCartSyncService,
      );
      // run & verify
      expect(
        () => authService.createUserWithEmailAndPassword('email', 'password'),
        throwsA(isA<Exception>()),
      );
    });

    test('createUserWithEmailAndPassword fails, copyItemsToRemote not called',
        () async {
      // setup
      final exception = Exception('failed sign in');
      when(() => mockAuthRepository.createUserWithEmailAndPassword(
            captureAny(),
            captureAny(),
          )).thenThrow(exception);
      final authService = AuthService(
        authRepository: mockAuthRepository,
        cartSyncService: mockCartSyncService,
      );
      // run & verify
      expect(
        () => authService.createUserWithEmailAndPassword('email', 'password'),
        throwsA(isA<Exception>()),
      );
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
      expect(
        () => authService.sendPasswordResetEmail('email'),
        returnsNormally,
      );
      verifyNever(() => mockCartSyncService.moveItemsToRemote(fakeUserId));
    });
  });
}
