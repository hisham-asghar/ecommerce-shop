import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/auth/fake_auth_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/reviews/review.dart';
import 'package:my_shop_ecommerce_flutter/src/services/reviews_service.dart';

import '../../mocks.dart';

void main() {
  const fakeUser = FakeAppUser(uid: '123');
  const fakeProductId = 'abc';
  final fakeReview = Review(
    score: 4,
    comment: 'comment',
    date: DateTime(2022, 2, 1),
  );

  late MockAuthRepository mockAuthRepository;
  late MockReviewsRepository mockReviewsRepository;
  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockReviewsRepository = MockReviewsRepository();
  });

  group('userReview', () {
    test(
        'Given user not null And review exists When userReview called Then review is emitted',
        () async {
      // setup
      final service = ReviewsService(
        reviewsRepository: mockReviewsRepository,
        authRepository: mockAuthRepository,
      );
      when(() => mockAuthRepository.currentUser).thenReturn(fakeUser);
      when(() => mockReviewsRepository.userReview(fakeProductId, fakeUser.uid))
          .thenAnswer((_) => Stream.value(fakeReview));
      // run
      expect(service.userReview(fakeProductId), emits(fakeReview));
    });
    test(
        'Given user not null And review doesn\'t exist When userReview called Then null is emitted',
        () async {
      // setup
      final service = ReviewsService(
        reviewsRepository: mockReviewsRepository,
        authRepository: mockAuthRepository,
      );
      when(() => mockAuthRepository.currentUser).thenReturn(fakeUser);
      when(() => mockReviewsRepository.userReview(fakeProductId, fakeUser.uid))
          .thenAnswer((_) => Stream.value(null));
      // run
      expect(service.userReview(fakeProductId), emits(null));
    });
    test('Given user is null When userReview called Then null is emitted',
        () async {
      // setup
      final service = ReviewsService(
        reviewsRepository: mockReviewsRepository,
        authRepository: mockAuthRepository,
      );
      when(() => mockAuthRepository.currentUser).thenReturn(null);
      // run
      expect(service.userReview(fakeProductId), emits(null));
    });
  });
  group('submitReview', () {
    test(
        'Given user not null When submitReview called Then calls submitReview in repository',
        () async {
      // setup
      final service = ReviewsService(
        reviewsRepository: mockReviewsRepository,
        authRepository: mockAuthRepository,
      );
      when(() => mockAuthRepository.currentUser).thenReturn(fakeUser);
      when(() => mockReviewsRepository.submitReview(
            productId: fakeProductId,
            uid: fakeUser.uid,
            review: fakeReview,
          )).thenAnswer((invocation) => Future.value());
      // run
      await service.submitReview(productId: fakeProductId, review: fakeReview);
      // verify
      verify(() => mockReviewsRepository.submitReview(
            productId: fakeProductId,
            uid: fakeUser.uid,
            review: fakeReview,
          )).called(1);
    });
    test('Given user is null When submitReview called Then throws error',
        () async {
      // setup
      final service = ReviewsService(
        reviewsRepository: mockReviewsRepository,
        authRepository: mockAuthRepository,
      );
      when(() => mockAuthRepository.currentUser).thenReturn(null);
      // run & verify
      expect(
          () => service.submitReview(
                productId: fakeProductId,
                review: fakeReview,
              ),
          throwsA(isA<UnsupportedError>()));
    });
  });
}
