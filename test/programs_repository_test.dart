import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ptassistant/core/models/program.dart';
import 'package:ptassistant/core/repositories/programs_repository.dart';

void main() {
  test('setActive marks one program active and clears others', () async {
    final firestore = FakeFirebaseFirestore();
    final repo = ProgramsRepository(firestore);
    final id1 = await repo.create('u1', const Program(id: '', title: 'A'));
    final id2 = await repo.create('u1', const Program(id: '', title: 'B'));

    await repo.setActive('u1', id1);
    expect((await repo.get('u1', id1)).isActive, true);
    expect((await repo.get('u1', id2)).isActive, false);

    await repo.setActive('u1', id2);
    expect((await repo.get('u1', id1)).isActive, false);
    expect((await repo.get('u1', id2)).isActive, true);
  });

  test('duplicate clones a program inactive with kopya suffix', () async {
    final firestore = FakeFirebaseFirestore();
    final repo = ProgramsRepository(firestore);
    final id = await repo.create(
      'u1',
      const Program(id: '', title: 'Push', isActive: true),
    );
    final copyId = await repo.duplicate('u1', id);
    final copy = await repo.get('u1', copyId);
    expect(copy.title.contains('kopya'), true);
    expect(copy.isActive, false);
  });
}
