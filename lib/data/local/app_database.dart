import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class Decks extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  IntColumn get nextSequentialCursor => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class CardItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get deckId => integer().references(Decks, #id, onDelete: KeyAction.cascade)();

  TextColumn get title => text()();

  TextColumn get answer => text().nullable()();

  IntColumn get sortIndex => integer()();

  IntColumn get selectionCount => integer().withDefault(const Constant(0))();

  IntColumn get resetCount => integer().withDefault(const Constant(0))();

  IntColumn get overCount => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class StudySessions extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get deckId => integer().references(Decks, #id, onDelete: KeyAction.cascade)();

  IntColumn get source => integer()();

  IntColumn get mode => integer()();

  IntColumn get currentIndex => integer().withDefault(const Constant(0))();

  IntColumn get cycleCount => integer().withDefault(const Constant(0))();

  DateTimeColumn get startedAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get completedAt => dateTime().nullable()();
}

class StudySessionCards extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get sessionId => integer().references(StudySessions, #id, onDelete: KeyAction.cascade)();

  IntColumn get cardId => integer()();

  TextColumn get titleSnapshot => text()();

  TextColumn get answerSnapshot => text().nullable()();

  IntColumn get displayOrder => integer()();

  BoolColumn get isOver => boolean().withDefault(const Constant(false))();
}

class StudyEvents extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get sessionId => integer().references(StudySessions, #id, onDelete: KeyAction.cascade)();

  IntColumn get deckId => integer()();

  IntColumn get cardId => integer().nullable()();

  IntColumn get type => integer()();

  TextColumn get payload => text().nullable()();

  DateTimeColumn get occurredAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(
  tables: [
    Decks,
    CardItems,
    StudySessions,
    StudySessionCards,
    StudyEvents,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'eng_card.db'));
    return NativeDatabase.createInBackground(file);
  });
}
