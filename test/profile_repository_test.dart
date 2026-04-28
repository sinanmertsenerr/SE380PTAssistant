import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ptassistant/core/models/user_profile.dart';
import 'package:ptassistant/core/repositories/profile_repository.dart';

void main() {
  test('ProfileRepository.create writes merged document', () async {
    final firestore = FakeFirebaseFirestore();
    final repo = ProfileRepository(firestore);
    await repo.create(
      const UserProfile(
        uid: 'u1',
        firstName: 'A',
        lastName: 'B',
        heightCm: 175,
      ),
    );
    final loaded = await repo.get('u1');
    expect(loaded.firstName, 'A');
    expect(loaded.heightCm, 175);
  });

  test('ProfileRepository.update merges fields', () async {
    final firestore = FakeFirebaseFirestore();
    final repo = ProfileRepository(firestore);
    await repo.create(const UserProfile(uid: 'u1'));
    await repo.update('u1', {'weightKg': 80, 'firstName': 'X'});
    final loaded = await repo.get('u1');
    expect(loaded.weightKg, 80);
    expect(loaded.firstName, 'X');
  });

  test('setOnboardingComplete flips flag', () async {
    final firestore = FakeFirebaseFirestore();
    final repo = ProfileRepository(firestore);
    await repo.create(const UserProfile(uid: 'u1'));
    expect((await repo.get('u1')).onboardingComplete, false);
    await repo.setOnboardingComplete('u1');
    expect((await repo.get('u1')).onboardingComplete, true);
  });
}
