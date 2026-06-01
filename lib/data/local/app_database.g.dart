// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DecksTable extends Decks with TableInfo<$DecksTable, Deck> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DecksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextSequentialCursorMeta =
      const VerificationMeta('nextSequentialCursor');
  @override
  late final GeneratedColumn<int> nextSequentialCursor = GeneratedColumn<int>(
    'next_sequential_cursor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    nextSequentialCursor,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'decks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Deck> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('next_sequential_cursor')) {
      context.handle(
        _nextSequentialCursorMeta,
        nextSequentialCursor.isAcceptableOrUnknown(
          data['next_sequential_cursor']!,
          _nextSequentialCursorMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Deck map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Deck(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nextSequentialCursor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}next_sequential_cursor'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DecksTable createAlias(String alias) {
    return $DecksTable(attachedDatabase, alias);
  }
}

class Deck extends DataClass implements Insertable<Deck> {
  final int id;
  final String name;
  final int nextSequentialCursor;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Deck({
    required this.id,
    required this.name,
    required this.nextSequentialCursor,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['next_sequential_cursor'] = Variable<int>(nextSequentialCursor);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DecksCompanion toCompanion(bool nullToAbsent) {
    return DecksCompanion(
      id: Value(id),
      name: Value(name),
      nextSequentialCursor: Value(nextSequentialCursor),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Deck.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Deck(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nextSequentialCursor: serializer.fromJson<int>(
        json['nextSequentialCursor'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'nextSequentialCursor': serializer.toJson<int>(nextSequentialCursor),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Deck copyWith({
    int? id,
    String? name,
    int? nextSequentialCursor,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Deck(
    id: id ?? this.id,
    name: name ?? this.name,
    nextSequentialCursor: nextSequentialCursor ?? this.nextSequentialCursor,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Deck copyWithCompanion(DecksCompanion data) {
    return Deck(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nextSequentialCursor: data.nextSequentialCursor.present
          ? data.nextSequentialCursor.value
          : this.nextSequentialCursor,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Deck(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nextSequentialCursor: $nextSequentialCursor, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, nextSequentialCursor, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Deck &&
          other.id == this.id &&
          other.name == this.name &&
          other.nextSequentialCursor == this.nextSequentialCursor &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DecksCompanion extends UpdateCompanion<Deck> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> nextSequentialCursor;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const DecksCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nextSequentialCursor = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DecksCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.nextSequentialCursor = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Deck> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? nextSequentialCursor,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nextSequentialCursor != null)
        'next_sequential_cursor': nextSequentialCursor,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DecksCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? nextSequentialCursor,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return DecksCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nextSequentialCursor: nextSequentialCursor ?? this.nextSequentialCursor,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nextSequentialCursor.present) {
      map['next_sequential_cursor'] = Variable<int>(nextSequentialCursor.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DecksCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nextSequentialCursor: $nextSequentialCursor, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $CardItemsTable extends CardItems
    with TableInfo<$CardItemsTable, CardItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _deckIdMeta = const VerificationMeta('deckId');
  @override
  late final GeneratedColumn<int> deckId = GeneratedColumn<int>(
    'deck_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES decks (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _answerMeta = const VerificationMeta('answer');
  @override
  late final GeneratedColumn<String> answer = GeneratedColumn<String>(
    'answer',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortIndexMeta = const VerificationMeta(
    'sortIndex',
  );
  @override
  late final GeneratedColumn<int> sortIndex = GeneratedColumn<int>(
    'sort_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _selectionCountMeta = const VerificationMeta(
    'selectionCount',
  );
  @override
  late final GeneratedColumn<int> selectionCount = GeneratedColumn<int>(
    'selection_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _resetCountMeta = const VerificationMeta(
    'resetCount',
  );
  @override
  late final GeneratedColumn<int> resetCount = GeneratedColumn<int>(
    'reset_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _overCountMeta = const VerificationMeta(
    'overCount',
  );
  @override
  late final GeneratedColumn<int> overCount = GeneratedColumn<int>(
    'over_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    deckId,
    title,
    answer,
    sortIndex,
    selectionCount,
    resetCount,
    overCount,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'card_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<CardItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('deck_id')) {
      context.handle(
        _deckIdMeta,
        deckId.isAcceptableOrUnknown(data['deck_id']!, _deckIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deckIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('answer')) {
      context.handle(
        _answerMeta,
        answer.isAcceptableOrUnknown(data['answer']!, _answerMeta),
      );
    }
    if (data.containsKey('sort_index')) {
      context.handle(
        _sortIndexMeta,
        sortIndex.isAcceptableOrUnknown(data['sort_index']!, _sortIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_sortIndexMeta);
    }
    if (data.containsKey('selection_count')) {
      context.handle(
        _selectionCountMeta,
        selectionCount.isAcceptableOrUnknown(
          data['selection_count']!,
          _selectionCountMeta,
        ),
      );
    }
    if (data.containsKey('reset_count')) {
      context.handle(
        _resetCountMeta,
        resetCount.isAcceptableOrUnknown(data['reset_count']!, _resetCountMeta),
      );
    }
    if (data.containsKey('over_count')) {
      context.handle(
        _overCountMeta,
        overCount.isAcceptableOrUnknown(data['over_count']!, _overCountMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      deckId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deck_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      answer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}answer'],
      ),
      sortIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_index'],
      )!,
      selectionCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}selection_count'],
      )!,
      resetCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reset_count'],
      )!,
      overCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}over_count'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CardItemsTable createAlias(String alias) {
    return $CardItemsTable(attachedDatabase, alias);
  }
}

class CardItem extends DataClass implements Insertable<CardItem> {
  final int id;
  final int deckId;
  final String title;
  final String? answer;
  final int sortIndex;
  final int selectionCount;
  final int resetCount;
  final int overCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CardItem({
    required this.id,
    required this.deckId,
    required this.title,
    this.answer,
    required this.sortIndex,
    required this.selectionCount,
    required this.resetCount,
    required this.overCount,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['deck_id'] = Variable<int>(deckId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || answer != null) {
      map['answer'] = Variable<String>(answer);
    }
    map['sort_index'] = Variable<int>(sortIndex);
    map['selection_count'] = Variable<int>(selectionCount);
    map['reset_count'] = Variable<int>(resetCount);
    map['over_count'] = Variable<int>(overCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CardItemsCompanion toCompanion(bool nullToAbsent) {
    return CardItemsCompanion(
      id: Value(id),
      deckId: Value(deckId),
      title: Value(title),
      answer: answer == null && nullToAbsent
          ? const Value.absent()
          : Value(answer),
      sortIndex: Value(sortIndex),
      selectionCount: Value(selectionCount),
      resetCount: Value(resetCount),
      overCount: Value(overCount),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CardItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardItem(
      id: serializer.fromJson<int>(json['id']),
      deckId: serializer.fromJson<int>(json['deckId']),
      title: serializer.fromJson<String>(json['title']),
      answer: serializer.fromJson<String?>(json['answer']),
      sortIndex: serializer.fromJson<int>(json['sortIndex']),
      selectionCount: serializer.fromJson<int>(json['selectionCount']),
      resetCount: serializer.fromJson<int>(json['resetCount']),
      overCount: serializer.fromJson<int>(json['overCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'deckId': serializer.toJson<int>(deckId),
      'title': serializer.toJson<String>(title),
      'answer': serializer.toJson<String?>(answer),
      'sortIndex': serializer.toJson<int>(sortIndex),
      'selectionCount': serializer.toJson<int>(selectionCount),
      'resetCount': serializer.toJson<int>(resetCount),
      'overCount': serializer.toJson<int>(overCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CardItem copyWith({
    int? id,
    int? deckId,
    String? title,
    Value<String?> answer = const Value.absent(),
    int? sortIndex,
    int? selectionCount,
    int? resetCount,
    int? overCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CardItem(
    id: id ?? this.id,
    deckId: deckId ?? this.deckId,
    title: title ?? this.title,
    answer: answer.present ? answer.value : this.answer,
    sortIndex: sortIndex ?? this.sortIndex,
    selectionCount: selectionCount ?? this.selectionCount,
    resetCount: resetCount ?? this.resetCount,
    overCount: overCount ?? this.overCount,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CardItem copyWithCompanion(CardItemsCompanion data) {
    return CardItem(
      id: data.id.present ? data.id.value : this.id,
      deckId: data.deckId.present ? data.deckId.value : this.deckId,
      title: data.title.present ? data.title.value : this.title,
      answer: data.answer.present ? data.answer.value : this.answer,
      sortIndex: data.sortIndex.present ? data.sortIndex.value : this.sortIndex,
      selectionCount: data.selectionCount.present
          ? data.selectionCount.value
          : this.selectionCount,
      resetCount: data.resetCount.present
          ? data.resetCount.value
          : this.resetCount,
      overCount: data.overCount.present ? data.overCount.value : this.overCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardItem(')
          ..write('id: $id, ')
          ..write('deckId: $deckId, ')
          ..write('title: $title, ')
          ..write('answer: $answer, ')
          ..write('sortIndex: $sortIndex, ')
          ..write('selectionCount: $selectionCount, ')
          ..write('resetCount: $resetCount, ')
          ..write('overCount: $overCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    deckId,
    title,
    answer,
    sortIndex,
    selectionCount,
    resetCount,
    overCount,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardItem &&
          other.id == this.id &&
          other.deckId == this.deckId &&
          other.title == this.title &&
          other.answer == this.answer &&
          other.sortIndex == this.sortIndex &&
          other.selectionCount == this.selectionCount &&
          other.resetCount == this.resetCount &&
          other.overCount == this.overCount &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CardItemsCompanion extends UpdateCompanion<CardItem> {
  final Value<int> id;
  final Value<int> deckId;
  final Value<String> title;
  final Value<String?> answer;
  final Value<int> sortIndex;
  final Value<int> selectionCount;
  final Value<int> resetCount;
  final Value<int> overCount;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const CardItemsCompanion({
    this.id = const Value.absent(),
    this.deckId = const Value.absent(),
    this.title = const Value.absent(),
    this.answer = const Value.absent(),
    this.sortIndex = const Value.absent(),
    this.selectionCount = const Value.absent(),
    this.resetCount = const Value.absent(),
    this.overCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CardItemsCompanion.insert({
    this.id = const Value.absent(),
    required int deckId,
    required String title,
    this.answer = const Value.absent(),
    required int sortIndex,
    this.selectionCount = const Value.absent(),
    this.resetCount = const Value.absent(),
    this.overCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : deckId = Value(deckId),
       title = Value(title),
       sortIndex = Value(sortIndex);
  static Insertable<CardItem> custom({
    Expression<int>? id,
    Expression<int>? deckId,
    Expression<String>? title,
    Expression<String>? answer,
    Expression<int>? sortIndex,
    Expression<int>? selectionCount,
    Expression<int>? resetCount,
    Expression<int>? overCount,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deckId != null) 'deck_id': deckId,
      if (title != null) 'title': title,
      if (answer != null) 'answer': answer,
      if (sortIndex != null) 'sort_index': sortIndex,
      if (selectionCount != null) 'selection_count': selectionCount,
      if (resetCount != null) 'reset_count': resetCount,
      if (overCount != null) 'over_count': overCount,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CardItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? deckId,
    Value<String>? title,
    Value<String?>? answer,
    Value<int>? sortIndex,
    Value<int>? selectionCount,
    Value<int>? resetCount,
    Value<int>? overCount,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return CardItemsCompanion(
      id: id ?? this.id,
      deckId: deckId ?? this.deckId,
      title: title ?? this.title,
      answer: answer ?? this.answer,
      sortIndex: sortIndex ?? this.sortIndex,
      selectionCount: selectionCount ?? this.selectionCount,
      resetCount: resetCount ?? this.resetCount,
      overCount: overCount ?? this.overCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (deckId.present) {
      map['deck_id'] = Variable<int>(deckId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (answer.present) {
      map['answer'] = Variable<String>(answer.value);
    }
    if (sortIndex.present) {
      map['sort_index'] = Variable<int>(sortIndex.value);
    }
    if (selectionCount.present) {
      map['selection_count'] = Variable<int>(selectionCount.value);
    }
    if (resetCount.present) {
      map['reset_count'] = Variable<int>(resetCount.value);
    }
    if (overCount.present) {
      map['over_count'] = Variable<int>(overCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardItemsCompanion(')
          ..write('id: $id, ')
          ..write('deckId: $deckId, ')
          ..write('title: $title, ')
          ..write('answer: $answer, ')
          ..write('sortIndex: $sortIndex, ')
          ..write('selectionCount: $selectionCount, ')
          ..write('resetCount: $resetCount, ')
          ..write('overCount: $overCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $StudySessionsTable extends StudySessions
    with TableInfo<$StudySessionsTable, StudySession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudySessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<int> source = GeneratedColumn<int>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<int> mode = GeneratedColumn<int>(
    'mode',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentIndexMeta = const VerificationMeta(
    'currentIndex',
  );
  @override
  late final GeneratedColumn<int> currentIndex = GeneratedColumn<int>(
    'current_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    source,
    mode,
    currentIndex,
    startedAt,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudySession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    if (data.containsKey('current_index')) {
      context.handle(
        _currentIndexMeta,
        currentIndex.isAcceptableOrUnknown(
          data['current_index']!,
          _currentIndexMeta,
        ),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudySession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudySession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}source'],
      )!,
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mode'],
      )!,
      currentIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_index'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $StudySessionsTable createAlias(String alias) {
    return $StudySessionsTable(attachedDatabase, alias);
  }
}

class StudySession extends DataClass implements Insertable<StudySession> {
  final int id;
  final int source;
  final int mode;
  final int currentIndex;
  final DateTime startedAt;
  final DateTime? completedAt;
  const StudySession({
    required this.id,
    required this.source,
    required this.mode,
    required this.currentIndex,
    required this.startedAt,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['source'] = Variable<int>(source);
    map['mode'] = Variable<int>(mode);
    map['current_index'] = Variable<int>(currentIndex);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  StudySessionsCompanion toCompanion(bool nullToAbsent) {
    return StudySessionsCompanion(
      id: Value(id),
      source: Value(source),
      mode: Value(mode),
      currentIndex: Value(currentIndex),
      startedAt: Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory StudySession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudySession(
      id: serializer.fromJson<int>(json['id']),
      source: serializer.fromJson<int>(json['source']),
      mode: serializer.fromJson<int>(json['mode']),
      currentIndex: serializer.fromJson<int>(json['currentIndex']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'source': serializer.toJson<int>(source),
      'mode': serializer.toJson<int>(mode),
      'currentIndex': serializer.toJson<int>(currentIndex),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  StudySession copyWith({
    int? id,
    int? source,
    int? mode,
    int? currentIndex,
    DateTime? startedAt,
    Value<DateTime?> completedAt = const Value.absent(),
  }) => StudySession(
    id: id ?? this.id,
    source: source ?? this.source,
    mode: mode ?? this.mode,
    currentIndex: currentIndex ?? this.currentIndex,
    startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  StudySession copyWithCompanion(StudySessionsCompanion data) {
    return StudySession(
      id: data.id.present ? data.id.value : this.id,
      source: data.source.present ? data.source.value : this.source,
      mode: data.mode.present ? data.mode.value : this.mode,
      currentIndex: data.currentIndex.present
          ? data.currentIndex.value
          : this.currentIndex,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudySession(')
          ..write('id: $id, ')
          ..write('source: $source, ')
          ..write('mode: $mode, ')
          ..write('currentIndex: $currentIndex, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, source, mode, currentIndex, startedAt, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudySession &&
          other.id == this.id &&
          other.source == this.source &&
          other.mode == this.mode &&
          other.currentIndex == this.currentIndex &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt);
}

class StudySessionsCompanion extends UpdateCompanion<StudySession> {
  final Value<int> id;
  final Value<int> source;
  final Value<int> mode;
  final Value<int> currentIndex;
  final Value<DateTime> startedAt;
  final Value<DateTime?> completedAt;
  const StudySessionsCompanion({
    this.id = const Value.absent(),
    this.source = const Value.absent(),
    this.mode = const Value.absent(),
    this.currentIndex = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
  });
  StudySessionsCompanion.insert({
    this.id = const Value.absent(),
    required int source,
    required int mode,
    this.currentIndex = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
  }) : source = Value(source),
       mode = Value(mode);
  static Insertable<StudySession> custom({
    Expression<int>? id,
    Expression<int>? source,
    Expression<int>? mode,
    Expression<int>? currentIndex,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (source != null) 'source': source,
      if (mode != null) 'mode': mode,
      if (currentIndex != null) 'current_index': currentIndex,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
    });
  }

  StudySessionsCompanion copyWith({
    Value<int>? id,
    Value<int>? source,
    Value<int>? mode,
    Value<int>? currentIndex,
    Value<DateTime>? startedAt,
    Value<DateTime?>? completedAt,
  }) {
    return StudySessionsCompanion(
      id: id ?? this.id,
      source: source ?? this.source,
      mode: mode ?? this.mode,
      currentIndex: currentIndex ?? this.currentIndex,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (source.present) {
      map['source'] = Variable<int>(source.value);
    }
    if (mode.present) {
      map['mode'] = Variable<int>(mode.value);
    }
    if (currentIndex.present) {
      map['current_index'] = Variable<int>(currentIndex.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudySessionsCompanion(')
          ..write('id: $id, ')
          ..write('source: $source, ')
          ..write('mode: $mode, ')
          ..write('currentIndex: $currentIndex, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }
}

class $StudySessionDecksTable extends StudySessionDecks
    with TableInfo<$StudySessionDecksTable, StudySessionDeck> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudySessionDecksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES study_sessions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _deckIdMeta = const VerificationMeta('deckId');
  @override
  late final GeneratedColumn<int> deckId = GeneratedColumn<int>(
    'deck_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES decks (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _deckOrderMeta = const VerificationMeta(
    'deckOrder',
  );
  @override
  late final GeneratedColumn<int> deckOrder = GeneratedColumn<int>(
    'deck_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _requestedCountSnapshotMeta =
      const VerificationMeta('requestedCountSnapshot');
  @override
  late final GeneratedColumn<int> requestedCountSnapshot = GeneratedColumn<int>(
    'requested_count_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    deckId,
    deckOrder,
    requestedCountSnapshot,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_session_decks';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudySessionDeck> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('deck_id')) {
      context.handle(
        _deckIdMeta,
        deckId.isAcceptableOrUnknown(data['deck_id']!, _deckIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deckIdMeta);
    }
    if (data.containsKey('deck_order')) {
      context.handle(
        _deckOrderMeta,
        deckOrder.isAcceptableOrUnknown(data['deck_order']!, _deckOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_deckOrderMeta);
    }
    if (data.containsKey('requested_count_snapshot')) {
      context.handle(
        _requestedCountSnapshotMeta,
        requestedCountSnapshot.isAcceptableOrUnknown(
          data['requested_count_snapshot']!,
          _requestedCountSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_requestedCountSnapshotMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudySessionDeck map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudySessionDeck(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_id'],
      )!,
      deckId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deck_id'],
      )!,
      deckOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deck_order'],
      )!,
      requestedCountSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}requested_count_snapshot'],
      )!,
    );
  }

  @override
  $StudySessionDecksTable createAlias(String alias) {
    return $StudySessionDecksTable(attachedDatabase, alias);
  }
}

class StudySessionDeck extends DataClass
    implements Insertable<StudySessionDeck> {
  final int id;
  final int sessionId;
  final int deckId;
  final int deckOrder;
  final int requestedCountSnapshot;
  const StudySessionDeck({
    required this.id,
    required this.sessionId,
    required this.deckId,
    required this.deckOrder,
    required this.requestedCountSnapshot,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['deck_id'] = Variable<int>(deckId);
    map['deck_order'] = Variable<int>(deckOrder);
    map['requested_count_snapshot'] = Variable<int>(requestedCountSnapshot);
    return map;
  }

  StudySessionDecksCompanion toCompanion(bool nullToAbsent) {
    return StudySessionDecksCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      deckId: Value(deckId),
      deckOrder: Value(deckOrder),
      requestedCountSnapshot: Value(requestedCountSnapshot),
    );
  }

  factory StudySessionDeck.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudySessionDeck(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      deckId: serializer.fromJson<int>(json['deckId']),
      deckOrder: serializer.fromJson<int>(json['deckOrder']),
      requestedCountSnapshot: serializer.fromJson<int>(
        json['requestedCountSnapshot'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'deckId': serializer.toJson<int>(deckId),
      'deckOrder': serializer.toJson<int>(deckOrder),
      'requestedCountSnapshot': serializer.toJson<int>(requestedCountSnapshot),
    };
  }

  StudySessionDeck copyWith({
    int? id,
    int? sessionId,
    int? deckId,
    int? deckOrder,
    int? requestedCountSnapshot,
  }) => StudySessionDeck(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    deckId: deckId ?? this.deckId,
    deckOrder: deckOrder ?? this.deckOrder,
    requestedCountSnapshot:
        requestedCountSnapshot ?? this.requestedCountSnapshot,
  );
  StudySessionDeck copyWithCompanion(StudySessionDecksCompanion data) {
    return StudySessionDeck(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      deckId: data.deckId.present ? data.deckId.value : this.deckId,
      deckOrder: data.deckOrder.present ? data.deckOrder.value : this.deckOrder,
      requestedCountSnapshot: data.requestedCountSnapshot.present
          ? data.requestedCountSnapshot.value
          : this.requestedCountSnapshot,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudySessionDeck(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('deckId: $deckId, ')
          ..write('deckOrder: $deckOrder, ')
          ..write('requestedCountSnapshot: $requestedCountSnapshot')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sessionId, deckId, deckOrder, requestedCountSnapshot);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudySessionDeck &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.deckId == this.deckId &&
          other.deckOrder == this.deckOrder &&
          other.requestedCountSnapshot == this.requestedCountSnapshot);
}

class StudySessionDecksCompanion extends UpdateCompanion<StudySessionDeck> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<int> deckId;
  final Value<int> deckOrder;
  final Value<int> requestedCountSnapshot;
  const StudySessionDecksCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.deckId = const Value.absent(),
    this.deckOrder = const Value.absent(),
    this.requestedCountSnapshot = const Value.absent(),
  });
  StudySessionDecksCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required int deckId,
    required int deckOrder,
    required int requestedCountSnapshot,
  }) : sessionId = Value(sessionId),
       deckId = Value(deckId),
       deckOrder = Value(deckOrder),
       requestedCountSnapshot = Value(requestedCountSnapshot);
  static Insertable<StudySessionDeck> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<int>? deckId,
    Expression<int>? deckOrder,
    Expression<int>? requestedCountSnapshot,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (deckId != null) 'deck_id': deckId,
      if (deckOrder != null) 'deck_order': deckOrder,
      if (requestedCountSnapshot != null)
        'requested_count_snapshot': requestedCountSnapshot,
    });
  }

  StudySessionDecksCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionId,
    Value<int>? deckId,
    Value<int>? deckOrder,
    Value<int>? requestedCountSnapshot,
  }) {
    return StudySessionDecksCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      deckId: deckId ?? this.deckId,
      deckOrder: deckOrder ?? this.deckOrder,
      requestedCountSnapshot:
          requestedCountSnapshot ?? this.requestedCountSnapshot,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (deckId.present) {
      map['deck_id'] = Variable<int>(deckId.value);
    }
    if (deckOrder.present) {
      map['deck_order'] = Variable<int>(deckOrder.value);
    }
    if (requestedCountSnapshot.present) {
      map['requested_count_snapshot'] = Variable<int>(
        requestedCountSnapshot.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudySessionDecksCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('deckId: $deckId, ')
          ..write('deckOrder: $deckOrder, ')
          ..write('requestedCountSnapshot: $requestedCountSnapshot')
          ..write(')'))
        .toString();
  }
}

class $StudySessionCardsTable extends StudySessionCards
    with TableInfo<$StudySessionCardsTable, StudySessionCard> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudySessionCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES study_sessions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<int> cardId = GeneratedColumn<int>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceDeckIdMeta = const VerificationMeta(
    'sourceDeckId',
  );
  @override
  late final GeneratedColumn<int> sourceDeckId = GeneratedColumn<int>(
    'source_deck_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES decks (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _titleSnapshotMeta = const VerificationMeta(
    'titleSnapshot',
  );
  @override
  late final GeneratedColumn<String> titleSnapshot = GeneratedColumn<String>(
    'title_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _answerSnapshotMeta = const VerificationMeta(
    'answerSnapshot',
  );
  @override
  late final GeneratedColumn<String> answerSnapshot = GeneratedColumn<String>(
    'answer_snapshot',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isOverMeta = const VerificationMeta('isOver');
  @override
  late final GeneratedColumn<bool> isOver = GeneratedColumn<bool>(
    'is_over',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_over" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    cardId,
    sourceDeckId,
    titleSnapshot,
    answerSnapshot,
    displayOrder,
    isOver,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_session_cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudySessionCard> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('source_deck_id')) {
      context.handle(
        _sourceDeckIdMeta,
        sourceDeckId.isAcceptableOrUnknown(
          data['source_deck_id']!,
          _sourceDeckIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceDeckIdMeta);
    }
    if (data.containsKey('title_snapshot')) {
      context.handle(
        _titleSnapshotMeta,
        titleSnapshot.isAcceptableOrUnknown(
          data['title_snapshot']!,
          _titleSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_titleSnapshotMeta);
    }
    if (data.containsKey('answer_snapshot')) {
      context.handle(
        _answerSnapshotMeta,
        answerSnapshot.isAcceptableOrUnknown(
          data['answer_snapshot']!,
          _answerSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayOrderMeta);
    }
    if (data.containsKey('is_over')) {
      context.handle(
        _isOverMeta,
        isOver.isAcceptableOrUnknown(data['is_over']!, _isOverMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudySessionCard map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudySessionCard(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_id'],
      )!,
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}card_id'],
      )!,
      sourceDeckId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}source_deck_id'],
      )!,
      titleSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_snapshot'],
      )!,
      answerSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}answer_snapshot'],
      ),
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
      isOver: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_over'],
      )!,
    );
  }

  @override
  $StudySessionCardsTable createAlias(String alias) {
    return $StudySessionCardsTable(attachedDatabase, alias);
  }
}

class StudySessionCard extends DataClass
    implements Insertable<StudySessionCard> {
  final int id;
  final int sessionId;
  final int cardId;
  final int sourceDeckId;
  final String titleSnapshot;
  final String? answerSnapshot;
  final int displayOrder;
  final bool isOver;
  const StudySessionCard({
    required this.id,
    required this.sessionId,
    required this.cardId,
    required this.sourceDeckId,
    required this.titleSnapshot,
    this.answerSnapshot,
    required this.displayOrder,
    required this.isOver,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['card_id'] = Variable<int>(cardId);
    map['source_deck_id'] = Variable<int>(sourceDeckId);
    map['title_snapshot'] = Variable<String>(titleSnapshot);
    if (!nullToAbsent || answerSnapshot != null) {
      map['answer_snapshot'] = Variable<String>(answerSnapshot);
    }
    map['display_order'] = Variable<int>(displayOrder);
    map['is_over'] = Variable<bool>(isOver);
    return map;
  }

  StudySessionCardsCompanion toCompanion(bool nullToAbsent) {
    return StudySessionCardsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      cardId: Value(cardId),
      sourceDeckId: Value(sourceDeckId),
      titleSnapshot: Value(titleSnapshot),
      answerSnapshot: answerSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(answerSnapshot),
      displayOrder: Value(displayOrder),
      isOver: Value(isOver),
    );
  }

  factory StudySessionCard.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudySessionCard(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      cardId: serializer.fromJson<int>(json['cardId']),
      sourceDeckId: serializer.fromJson<int>(json['sourceDeckId']),
      titleSnapshot: serializer.fromJson<String>(json['titleSnapshot']),
      answerSnapshot: serializer.fromJson<String?>(json['answerSnapshot']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
      isOver: serializer.fromJson<bool>(json['isOver']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'cardId': serializer.toJson<int>(cardId),
      'sourceDeckId': serializer.toJson<int>(sourceDeckId),
      'titleSnapshot': serializer.toJson<String>(titleSnapshot),
      'answerSnapshot': serializer.toJson<String?>(answerSnapshot),
      'displayOrder': serializer.toJson<int>(displayOrder),
      'isOver': serializer.toJson<bool>(isOver),
    };
  }

  StudySessionCard copyWith({
    int? id,
    int? sessionId,
    int? cardId,
    int? sourceDeckId,
    String? titleSnapshot,
    Value<String?> answerSnapshot = const Value.absent(),
    int? displayOrder,
    bool? isOver,
  }) => StudySessionCard(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    cardId: cardId ?? this.cardId,
    sourceDeckId: sourceDeckId ?? this.sourceDeckId,
    titleSnapshot: titleSnapshot ?? this.titleSnapshot,
    answerSnapshot: answerSnapshot.present
        ? answerSnapshot.value
        : this.answerSnapshot,
    displayOrder: displayOrder ?? this.displayOrder,
    isOver: isOver ?? this.isOver,
  );
  StudySessionCard copyWithCompanion(StudySessionCardsCompanion data) {
    return StudySessionCard(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      sourceDeckId: data.sourceDeckId.present
          ? data.sourceDeckId.value
          : this.sourceDeckId,
      titleSnapshot: data.titleSnapshot.present
          ? data.titleSnapshot.value
          : this.titleSnapshot,
      answerSnapshot: data.answerSnapshot.present
          ? data.answerSnapshot.value
          : this.answerSnapshot,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
      isOver: data.isOver.present ? data.isOver.value : this.isOver,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudySessionCard(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('cardId: $cardId, ')
          ..write('sourceDeckId: $sourceDeckId, ')
          ..write('titleSnapshot: $titleSnapshot, ')
          ..write('answerSnapshot: $answerSnapshot, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('isOver: $isOver')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    cardId,
    sourceDeckId,
    titleSnapshot,
    answerSnapshot,
    displayOrder,
    isOver,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudySessionCard &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.cardId == this.cardId &&
          other.sourceDeckId == this.sourceDeckId &&
          other.titleSnapshot == this.titleSnapshot &&
          other.answerSnapshot == this.answerSnapshot &&
          other.displayOrder == this.displayOrder &&
          other.isOver == this.isOver);
}

class StudySessionCardsCompanion extends UpdateCompanion<StudySessionCard> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<int> cardId;
  final Value<int> sourceDeckId;
  final Value<String> titleSnapshot;
  final Value<String?> answerSnapshot;
  final Value<int> displayOrder;
  final Value<bool> isOver;
  const StudySessionCardsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.cardId = const Value.absent(),
    this.sourceDeckId = const Value.absent(),
    this.titleSnapshot = const Value.absent(),
    this.answerSnapshot = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.isOver = const Value.absent(),
  });
  StudySessionCardsCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required int cardId,
    required int sourceDeckId,
    required String titleSnapshot,
    this.answerSnapshot = const Value.absent(),
    required int displayOrder,
    this.isOver = const Value.absent(),
  }) : sessionId = Value(sessionId),
       cardId = Value(cardId),
       sourceDeckId = Value(sourceDeckId),
       titleSnapshot = Value(titleSnapshot),
       displayOrder = Value(displayOrder);
  static Insertable<StudySessionCard> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<int>? cardId,
    Expression<int>? sourceDeckId,
    Expression<String>? titleSnapshot,
    Expression<String>? answerSnapshot,
    Expression<int>? displayOrder,
    Expression<bool>? isOver,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (cardId != null) 'card_id': cardId,
      if (sourceDeckId != null) 'source_deck_id': sourceDeckId,
      if (titleSnapshot != null) 'title_snapshot': titleSnapshot,
      if (answerSnapshot != null) 'answer_snapshot': answerSnapshot,
      if (displayOrder != null) 'display_order': displayOrder,
      if (isOver != null) 'is_over': isOver,
    });
  }

  StudySessionCardsCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionId,
    Value<int>? cardId,
    Value<int>? sourceDeckId,
    Value<String>? titleSnapshot,
    Value<String?>? answerSnapshot,
    Value<int>? displayOrder,
    Value<bool>? isOver,
  }) {
    return StudySessionCardsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      cardId: cardId ?? this.cardId,
      sourceDeckId: sourceDeckId ?? this.sourceDeckId,
      titleSnapshot: titleSnapshot ?? this.titleSnapshot,
      answerSnapshot: answerSnapshot ?? this.answerSnapshot,
      displayOrder: displayOrder ?? this.displayOrder,
      isOver: isOver ?? this.isOver,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<int>(cardId.value);
    }
    if (sourceDeckId.present) {
      map['source_deck_id'] = Variable<int>(sourceDeckId.value);
    }
    if (titleSnapshot.present) {
      map['title_snapshot'] = Variable<String>(titleSnapshot.value);
    }
    if (answerSnapshot.present) {
      map['answer_snapshot'] = Variable<String>(answerSnapshot.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (isOver.present) {
      map['is_over'] = Variable<bool>(isOver.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudySessionCardsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('cardId: $cardId, ')
          ..write('sourceDeckId: $sourceDeckId, ')
          ..write('titleSnapshot: $titleSnapshot, ')
          ..write('answerSnapshot: $answerSnapshot, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('isOver: $isOver')
          ..write(')'))
        .toString();
  }
}

class $StudyEventsTable extends StudyEvents
    with TableInfo<$StudyEventsTable, StudyEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudyEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES study_sessions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _sessionCardIdMeta = const VerificationMeta(
    'sessionCardId',
  );
  @override
  late final GeneratedColumn<int> sessionCardId = GeneratedColumn<int>(
    'session_card_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES study_session_cards (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _sourceDeckIdMeta = const VerificationMeta(
    'sourceDeckId',
  );
  @override
  late final GeneratedColumn<int> sourceDeckId = GeneratedColumn<int>(
    'source_deck_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES decks (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<int> cardId = GeneratedColumn<int>(
    'card_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    sessionCardId,
    sourceDeckId,
    cardId,
    type,
    payload,
    occurredAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudyEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('session_card_id')) {
      context.handle(
        _sessionCardIdMeta,
        sessionCardId.isAcceptableOrUnknown(
          data['session_card_id']!,
          _sessionCardIdMeta,
        ),
      );
    }
    if (data.containsKey('source_deck_id')) {
      context.handle(
        _sourceDeckIdMeta,
        sourceDeckId.isAcceptableOrUnknown(
          data['source_deck_id']!,
          _sourceDeckIdMeta,
        ),
      );
    }
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudyEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudyEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_id'],
      )!,
      sessionCardId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_card_id'],
      ),
      sourceDeckId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}source_deck_id'],
      ),
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}card_id'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}type'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      ),
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
    );
  }

  @override
  $StudyEventsTable createAlias(String alias) {
    return $StudyEventsTable(attachedDatabase, alias);
  }
}

class StudyEvent extends DataClass implements Insertable<StudyEvent> {
  final int id;
  final int sessionId;
  final int? sessionCardId;
  final int? sourceDeckId;
  final int? cardId;
  final int type;
  final String? payload;
  final DateTime occurredAt;
  const StudyEvent({
    required this.id,
    required this.sessionId,
    this.sessionCardId,
    this.sourceDeckId,
    this.cardId,
    required this.type,
    this.payload,
    required this.occurredAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    if (!nullToAbsent || sessionCardId != null) {
      map['session_card_id'] = Variable<int>(sessionCardId);
    }
    if (!nullToAbsent || sourceDeckId != null) {
      map['source_deck_id'] = Variable<int>(sourceDeckId);
    }
    if (!nullToAbsent || cardId != null) {
      map['card_id'] = Variable<int>(cardId);
    }
    map['type'] = Variable<int>(type);
    if (!nullToAbsent || payload != null) {
      map['payload'] = Variable<String>(payload);
    }
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    return map;
  }

  StudyEventsCompanion toCompanion(bool nullToAbsent) {
    return StudyEventsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      sessionCardId: sessionCardId == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionCardId),
      sourceDeckId: sourceDeckId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceDeckId),
      cardId: cardId == null && nullToAbsent
          ? const Value.absent()
          : Value(cardId),
      type: Value(type),
      payload: payload == null && nullToAbsent
          ? const Value.absent()
          : Value(payload),
      occurredAt: Value(occurredAt),
    );
  }

  factory StudyEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudyEvent(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      sessionCardId: serializer.fromJson<int?>(json['sessionCardId']),
      sourceDeckId: serializer.fromJson<int?>(json['sourceDeckId']),
      cardId: serializer.fromJson<int?>(json['cardId']),
      type: serializer.fromJson<int>(json['type']),
      payload: serializer.fromJson<String?>(json['payload']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'sessionCardId': serializer.toJson<int?>(sessionCardId),
      'sourceDeckId': serializer.toJson<int?>(sourceDeckId),
      'cardId': serializer.toJson<int?>(cardId),
      'type': serializer.toJson<int>(type),
      'payload': serializer.toJson<String?>(payload),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
    };
  }

  StudyEvent copyWith({
    int? id,
    int? sessionId,
    Value<int?> sessionCardId = const Value.absent(),
    Value<int?> sourceDeckId = const Value.absent(),
    Value<int?> cardId = const Value.absent(),
    int? type,
    Value<String?> payload = const Value.absent(),
    DateTime? occurredAt,
  }) => StudyEvent(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    sessionCardId: sessionCardId.present
        ? sessionCardId.value
        : this.sessionCardId,
    sourceDeckId: sourceDeckId.present ? sourceDeckId.value : this.sourceDeckId,
    cardId: cardId.present ? cardId.value : this.cardId,
    type: type ?? this.type,
    payload: payload.present ? payload.value : this.payload,
    occurredAt: occurredAt ?? this.occurredAt,
  );
  StudyEvent copyWithCompanion(StudyEventsCompanion data) {
    return StudyEvent(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      sessionCardId: data.sessionCardId.present
          ? data.sessionCardId.value
          : this.sessionCardId,
      sourceDeckId: data.sourceDeckId.present
          ? data.sourceDeckId.value
          : this.sourceDeckId,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      type: data.type.present ? data.type.value : this.type,
      payload: data.payload.present ? data.payload.value : this.payload,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudyEvent(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('sessionCardId: $sessionCardId, ')
          ..write('sourceDeckId: $sourceDeckId, ')
          ..write('cardId: $cardId, ')
          ..write('type: $type, ')
          ..write('payload: $payload, ')
          ..write('occurredAt: $occurredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    sessionCardId,
    sourceDeckId,
    cardId,
    type,
    payload,
    occurredAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudyEvent &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.sessionCardId == this.sessionCardId &&
          other.sourceDeckId == this.sourceDeckId &&
          other.cardId == this.cardId &&
          other.type == this.type &&
          other.payload == this.payload &&
          other.occurredAt == this.occurredAt);
}

class StudyEventsCompanion extends UpdateCompanion<StudyEvent> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<int?> sessionCardId;
  final Value<int?> sourceDeckId;
  final Value<int?> cardId;
  final Value<int> type;
  final Value<String?> payload;
  final Value<DateTime> occurredAt;
  const StudyEventsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.sessionCardId = const Value.absent(),
    this.sourceDeckId = const Value.absent(),
    this.cardId = const Value.absent(),
    this.type = const Value.absent(),
    this.payload = const Value.absent(),
    this.occurredAt = const Value.absent(),
  });
  StudyEventsCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    this.sessionCardId = const Value.absent(),
    this.sourceDeckId = const Value.absent(),
    this.cardId = const Value.absent(),
    required int type,
    this.payload = const Value.absent(),
    this.occurredAt = const Value.absent(),
  }) : sessionId = Value(sessionId),
       type = Value(type);
  static Insertable<StudyEvent> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<int>? sessionCardId,
    Expression<int>? sourceDeckId,
    Expression<int>? cardId,
    Expression<int>? type,
    Expression<String>? payload,
    Expression<DateTime>? occurredAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (sessionCardId != null) 'session_card_id': sessionCardId,
      if (sourceDeckId != null) 'source_deck_id': sourceDeckId,
      if (cardId != null) 'card_id': cardId,
      if (type != null) 'type': type,
      if (payload != null) 'payload': payload,
      if (occurredAt != null) 'occurred_at': occurredAt,
    });
  }

  StudyEventsCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionId,
    Value<int?>? sessionCardId,
    Value<int?>? sourceDeckId,
    Value<int?>? cardId,
    Value<int>? type,
    Value<String?>? payload,
    Value<DateTime>? occurredAt,
  }) {
    return StudyEventsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      sessionCardId: sessionCardId ?? this.sessionCardId,
      sourceDeckId: sourceDeckId ?? this.sourceDeckId,
      cardId: cardId ?? this.cardId,
      type: type ?? this.type,
      payload: payload ?? this.payload,
      occurredAt: occurredAt ?? this.occurredAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (sessionCardId.present) {
      map['session_card_id'] = Variable<int>(sessionCardId.value);
    }
    if (sourceDeckId.present) {
      map['source_deck_id'] = Variable<int>(sourceDeckId.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<int>(cardId.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudyEventsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('sessionCardId: $sessionCardId, ')
          ..write('sourceDeckId: $sourceDeckId, ')
          ..write('cardId: $cardId, ')
          ..write('type: $type, ')
          ..write('payload: $payload, ')
          ..write('occurredAt: $occurredAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DecksTable decks = $DecksTable(this);
  late final $CardItemsTable cardItems = $CardItemsTable(this);
  late final $StudySessionsTable studySessions = $StudySessionsTable(this);
  late final $StudySessionDecksTable studySessionDecks =
      $StudySessionDecksTable(this);
  late final $StudySessionCardsTable studySessionCards =
      $StudySessionCardsTable(this);
  late final $StudyEventsTable studyEvents = $StudyEventsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    decks,
    cardItems,
    studySessions,
    studySessionDecks,
    studySessionCards,
    studyEvents,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'decks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('card_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'study_sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('study_session_decks', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'decks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('study_session_decks', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'study_sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('study_session_cards', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'decks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('study_session_cards', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'study_sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('study_events', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'study_session_cards',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('study_events', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'decks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('study_events', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$DecksTableCreateCompanionBuilder =
    DecksCompanion Function({
      Value<int> id,
      required String name,
      Value<int> nextSequentialCursor,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$DecksTableUpdateCompanionBuilder =
    DecksCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> nextSequentialCursor,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$DecksTableReferences
    extends BaseReferences<_$AppDatabase, $DecksTable, Deck> {
  $$DecksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CardItemsTable, List<CardItem>>
  _cardItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cardItems,
    aliasName: $_aliasNameGenerator(db.decks.id, db.cardItems.deckId),
  );

  $$CardItemsTableProcessedTableManager get cardItemsRefs {
    final manager = $$CardItemsTableTableManager(
      $_db,
      $_db.cardItems,
    ).filter((f) => f.deckId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_cardItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StudySessionDecksTable, List<StudySessionDeck>>
  _studySessionDecksRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.studySessionDecks,
        aliasName: $_aliasNameGenerator(
          db.decks.id,
          db.studySessionDecks.deckId,
        ),
      );

  $$StudySessionDecksTableProcessedTableManager get studySessionDecksRefs {
    final manager = $$StudySessionDecksTableTableManager(
      $_db,
      $_db.studySessionDecks,
    ).filter((f) => f.deckId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _studySessionDecksRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StudySessionCardsTable, List<StudySessionCard>>
  _studySessionCardsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.studySessionCards,
        aliasName: $_aliasNameGenerator(
          db.decks.id,
          db.studySessionCards.sourceDeckId,
        ),
      );

  $$StudySessionCardsTableProcessedTableManager get studySessionCardsRefs {
    final manager = $$StudySessionCardsTableTableManager(
      $_db,
      $_db.studySessionCards,
    ).filter((f) => f.sourceDeckId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _studySessionCardsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StudyEventsTable, List<StudyEvent>>
  _studyEventsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.studyEvents,
    aliasName: $_aliasNameGenerator(db.decks.id, db.studyEvents.sourceDeckId),
  );

  $$StudyEventsTableProcessedTableManager get studyEventsRefs {
    final manager = $$StudyEventsTableTableManager(
      $_db,
      $_db.studyEvents,
    ).filter((f) => f.sourceDeckId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_studyEventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DecksTableFilterComposer extends Composer<_$AppDatabase, $DecksTable> {
  $$DecksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nextSequentialCursor => $composableBuilder(
    column: $table.nextSequentialCursor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> cardItemsRefs(
    Expression<bool> Function($$CardItemsTableFilterComposer f) f,
  ) {
    final $$CardItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cardItems,
      getReferencedColumn: (t) => t.deckId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardItemsTableFilterComposer(
            $db: $db,
            $table: $db.cardItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> studySessionDecksRefs(
    Expression<bool> Function($$StudySessionDecksTableFilterComposer f) f,
  ) {
    final $$StudySessionDecksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studySessionDecks,
      getReferencedColumn: (t) => t.deckId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudySessionDecksTableFilterComposer(
            $db: $db,
            $table: $db.studySessionDecks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> studySessionCardsRefs(
    Expression<bool> Function($$StudySessionCardsTableFilterComposer f) f,
  ) {
    final $$StudySessionCardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studySessionCards,
      getReferencedColumn: (t) => t.sourceDeckId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudySessionCardsTableFilterComposer(
            $db: $db,
            $table: $db.studySessionCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> studyEventsRefs(
    Expression<bool> Function($$StudyEventsTableFilterComposer f) f,
  ) {
    final $$StudyEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studyEvents,
      getReferencedColumn: (t) => t.sourceDeckId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyEventsTableFilterComposer(
            $db: $db,
            $table: $db.studyEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DecksTableOrderingComposer
    extends Composer<_$AppDatabase, $DecksTable> {
  $$DecksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nextSequentialCursor => $composableBuilder(
    column: $table.nextSequentialCursor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DecksTableAnnotationComposer
    extends Composer<_$AppDatabase, $DecksTable> {
  $$DecksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get nextSequentialCursor => $composableBuilder(
    column: $table.nextSequentialCursor,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> cardItemsRefs<T extends Object>(
    Expression<T> Function($$CardItemsTableAnnotationComposer a) f,
  ) {
    final $$CardItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cardItems,
      getReferencedColumn: (t) => t.deckId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.cardItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> studySessionDecksRefs<T extends Object>(
    Expression<T> Function($$StudySessionDecksTableAnnotationComposer a) f,
  ) {
    final $$StudySessionDecksTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.studySessionDecks,
          getReferencedColumn: (t) => t.deckId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StudySessionDecksTableAnnotationComposer(
                $db: $db,
                $table: $db.studySessionDecks,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> studySessionCardsRefs<T extends Object>(
    Expression<T> Function($$StudySessionCardsTableAnnotationComposer a) f,
  ) {
    final $$StudySessionCardsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.studySessionCards,
          getReferencedColumn: (t) => t.sourceDeckId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StudySessionCardsTableAnnotationComposer(
                $db: $db,
                $table: $db.studySessionCards,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> studyEventsRefs<T extends Object>(
    Expression<T> Function($$StudyEventsTableAnnotationComposer a) f,
  ) {
    final $$StudyEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studyEvents,
      getReferencedColumn: (t) => t.sourceDeckId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.studyEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DecksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DecksTable,
          Deck,
          $$DecksTableFilterComposer,
          $$DecksTableOrderingComposer,
          $$DecksTableAnnotationComposer,
          $$DecksTableCreateCompanionBuilder,
          $$DecksTableUpdateCompanionBuilder,
          (Deck, $$DecksTableReferences),
          Deck,
          PrefetchHooks Function({
            bool cardItemsRefs,
            bool studySessionDecksRefs,
            bool studySessionCardsRefs,
            bool studyEventsRefs,
          })
        > {
  $$DecksTableTableManager(_$AppDatabase db, $DecksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DecksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DecksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DecksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> nextSequentialCursor = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => DecksCompanion(
                id: id,
                name: name,
                nextSequentialCursor: nextSequentialCursor,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<int> nextSequentialCursor = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => DecksCompanion.insert(
                id: id,
                name: name,
                nextSequentialCursor: nextSequentialCursor,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$DecksTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                cardItemsRefs = false,
                studySessionDecksRefs = false,
                studySessionCardsRefs = false,
                studyEventsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (cardItemsRefs) db.cardItems,
                    if (studySessionDecksRefs) db.studySessionDecks,
                    if (studySessionCardsRefs) db.studySessionCards,
                    if (studyEventsRefs) db.studyEvents,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (cardItemsRefs)
                        await $_getPrefetchedData<Deck, $DecksTable, CardItem>(
                          currentTable: table,
                          referencedTable: $$DecksTableReferences
                              ._cardItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DecksTableReferences(
                                db,
                                table,
                                p0,
                              ).cardItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.deckId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (studySessionDecksRefs)
                        await $_getPrefetchedData<
                          Deck,
                          $DecksTable,
                          StudySessionDeck
                        >(
                          currentTable: table,
                          referencedTable: $$DecksTableReferences
                              ._studySessionDecksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DecksTableReferences(
                                db,
                                table,
                                p0,
                              ).studySessionDecksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.deckId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (studySessionCardsRefs)
                        await $_getPrefetchedData<
                          Deck,
                          $DecksTable,
                          StudySessionCard
                        >(
                          currentTable: table,
                          referencedTable: $$DecksTableReferences
                              ._studySessionCardsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DecksTableReferences(
                                db,
                                table,
                                p0,
                              ).studySessionCardsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sourceDeckId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (studyEventsRefs)
                        await $_getPrefetchedData<
                          Deck,
                          $DecksTable,
                          StudyEvent
                        >(
                          currentTable: table,
                          referencedTable: $$DecksTableReferences
                              ._studyEventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DecksTableReferences(
                                db,
                                table,
                                p0,
                              ).studyEventsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sourceDeckId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$DecksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DecksTable,
      Deck,
      $$DecksTableFilterComposer,
      $$DecksTableOrderingComposer,
      $$DecksTableAnnotationComposer,
      $$DecksTableCreateCompanionBuilder,
      $$DecksTableUpdateCompanionBuilder,
      (Deck, $$DecksTableReferences),
      Deck,
      PrefetchHooks Function({
        bool cardItemsRefs,
        bool studySessionDecksRefs,
        bool studySessionCardsRefs,
        bool studyEventsRefs,
      })
    >;
typedef $$CardItemsTableCreateCompanionBuilder =
    CardItemsCompanion Function({
      Value<int> id,
      required int deckId,
      required String title,
      Value<String?> answer,
      required int sortIndex,
      Value<int> selectionCount,
      Value<int> resetCount,
      Value<int> overCount,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$CardItemsTableUpdateCompanionBuilder =
    CardItemsCompanion Function({
      Value<int> id,
      Value<int> deckId,
      Value<String> title,
      Value<String?> answer,
      Value<int> sortIndex,
      Value<int> selectionCount,
      Value<int> resetCount,
      Value<int> overCount,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$CardItemsTableReferences
    extends BaseReferences<_$AppDatabase, $CardItemsTable, CardItem> {
  $$CardItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DecksTable _deckIdTable(_$AppDatabase db) => db.decks.createAlias(
    $_aliasNameGenerator(db.cardItems.deckId, db.decks.id),
  );

  $$DecksTableProcessedTableManager get deckId {
    final $_column = $_itemColumn<int>('deck_id')!;

    final manager = $$DecksTableTableManager(
      $_db,
      $_db.decks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_deckIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CardItemsTableFilterComposer
    extends Composer<_$AppDatabase, $CardItemsTable> {
  $$CardItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get answer => $composableBuilder(
    column: $table.answer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortIndex => $composableBuilder(
    column: $table.sortIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get selectionCount => $composableBuilder(
    column: $table.selectionCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get resetCount => $composableBuilder(
    column: $table.resetCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get overCount => $composableBuilder(
    column: $table.overCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$DecksTableFilterComposer get deckId {
    final $$DecksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deckId,
      referencedTable: $db.decks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DecksTableFilterComposer(
            $db: $db,
            $table: $db.decks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CardItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $CardItemsTable> {
  $$CardItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get answer => $composableBuilder(
    column: $table.answer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortIndex => $composableBuilder(
    column: $table.sortIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get selectionCount => $composableBuilder(
    column: $table.selectionCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get resetCount => $composableBuilder(
    column: $table.resetCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get overCount => $composableBuilder(
    column: $table.overCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$DecksTableOrderingComposer get deckId {
    final $$DecksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deckId,
      referencedTable: $db.decks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DecksTableOrderingComposer(
            $db: $db,
            $table: $db.decks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CardItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardItemsTable> {
  $$CardItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get answer =>
      $composableBuilder(column: $table.answer, builder: (column) => column);

  GeneratedColumn<int> get sortIndex =>
      $composableBuilder(column: $table.sortIndex, builder: (column) => column);

  GeneratedColumn<int> get selectionCount => $composableBuilder(
    column: $table.selectionCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get resetCount => $composableBuilder(
    column: $table.resetCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get overCount =>
      $composableBuilder(column: $table.overCount, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$DecksTableAnnotationComposer get deckId {
    final $$DecksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deckId,
      referencedTable: $db.decks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DecksTableAnnotationComposer(
            $db: $db,
            $table: $db.decks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CardItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardItemsTable,
          CardItem,
          $$CardItemsTableFilterComposer,
          $$CardItemsTableOrderingComposer,
          $$CardItemsTableAnnotationComposer,
          $$CardItemsTableCreateCompanionBuilder,
          $$CardItemsTableUpdateCompanionBuilder,
          (CardItem, $$CardItemsTableReferences),
          CardItem,
          PrefetchHooks Function({bool deckId})
        > {
  $$CardItemsTableTableManager(_$AppDatabase db, $CardItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> deckId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> answer = const Value.absent(),
                Value<int> sortIndex = const Value.absent(),
                Value<int> selectionCount = const Value.absent(),
                Value<int> resetCount = const Value.absent(),
                Value<int> overCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CardItemsCompanion(
                id: id,
                deckId: deckId,
                title: title,
                answer: answer,
                sortIndex: sortIndex,
                selectionCount: selectionCount,
                resetCount: resetCount,
                overCount: overCount,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int deckId,
                required String title,
                Value<String?> answer = const Value.absent(),
                required int sortIndex,
                Value<int> selectionCount = const Value.absent(),
                Value<int> resetCount = const Value.absent(),
                Value<int> overCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CardItemsCompanion.insert(
                id: id,
                deckId: deckId,
                title: title,
                answer: answer,
                sortIndex: sortIndex,
                selectionCount: selectionCount,
                resetCount: resetCount,
                overCount: overCount,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CardItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({deckId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (deckId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.deckId,
                                referencedTable: $$CardItemsTableReferences
                                    ._deckIdTable(db),
                                referencedColumn: $$CardItemsTableReferences
                                    ._deckIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CardItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardItemsTable,
      CardItem,
      $$CardItemsTableFilterComposer,
      $$CardItemsTableOrderingComposer,
      $$CardItemsTableAnnotationComposer,
      $$CardItemsTableCreateCompanionBuilder,
      $$CardItemsTableUpdateCompanionBuilder,
      (CardItem, $$CardItemsTableReferences),
      CardItem,
      PrefetchHooks Function({bool deckId})
    >;
typedef $$StudySessionsTableCreateCompanionBuilder =
    StudySessionsCompanion Function({
      Value<int> id,
      required int source,
      required int mode,
      Value<int> currentIndex,
      Value<DateTime> startedAt,
      Value<DateTime?> completedAt,
    });
typedef $$StudySessionsTableUpdateCompanionBuilder =
    StudySessionsCompanion Function({
      Value<int> id,
      Value<int> source,
      Value<int> mode,
      Value<int> currentIndex,
      Value<DateTime> startedAt,
      Value<DateTime?> completedAt,
    });

final class $$StudySessionsTableReferences
    extends BaseReferences<_$AppDatabase, $StudySessionsTable, StudySession> {
  $$StudySessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$StudySessionDecksTable, List<StudySessionDeck>>
  _studySessionDecksRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.studySessionDecks,
        aliasName: $_aliasNameGenerator(
          db.studySessions.id,
          db.studySessionDecks.sessionId,
        ),
      );

  $$StudySessionDecksTableProcessedTableManager get studySessionDecksRefs {
    final manager = $$StudySessionDecksTableTableManager(
      $_db,
      $_db.studySessionDecks,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _studySessionDecksRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StudySessionCardsTable, List<StudySessionCard>>
  _studySessionCardsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.studySessionCards,
        aliasName: $_aliasNameGenerator(
          db.studySessions.id,
          db.studySessionCards.sessionId,
        ),
      );

  $$StudySessionCardsTableProcessedTableManager get studySessionCardsRefs {
    final manager = $$StudySessionCardsTableTableManager(
      $_db,
      $_db.studySessionCards,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _studySessionCardsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StudyEventsTable, List<StudyEvent>>
  _studyEventsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.studyEvents,
    aliasName: $_aliasNameGenerator(
      db.studySessions.id,
      db.studyEvents.sessionId,
    ),
  );

  $$StudyEventsTableProcessedTableManager get studyEventsRefs {
    final manager = $$StudyEventsTableTableManager(
      $_db,
      $_db.studyEvents,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_studyEventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StudySessionsTableFilterComposer
    extends Composer<_$AppDatabase, $StudySessionsTable> {
  $$StudySessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentIndex => $composableBuilder(
    column: $table.currentIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> studySessionDecksRefs(
    Expression<bool> Function($$StudySessionDecksTableFilterComposer f) f,
  ) {
    final $$StudySessionDecksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studySessionDecks,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudySessionDecksTableFilterComposer(
            $db: $db,
            $table: $db.studySessionDecks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> studySessionCardsRefs(
    Expression<bool> Function($$StudySessionCardsTableFilterComposer f) f,
  ) {
    final $$StudySessionCardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studySessionCards,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudySessionCardsTableFilterComposer(
            $db: $db,
            $table: $db.studySessionCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> studyEventsRefs(
    Expression<bool> Function($$StudyEventsTableFilterComposer f) f,
  ) {
    final $$StudyEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studyEvents,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyEventsTableFilterComposer(
            $db: $db,
            $table: $db.studyEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StudySessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudySessionsTable> {
  $$StudySessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentIndex => $composableBuilder(
    column: $table.currentIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StudySessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudySessionsTable> {
  $$StudySessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<int> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<int> get currentIndex => $composableBuilder(
    column: $table.currentIndex,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  Expression<T> studySessionDecksRefs<T extends Object>(
    Expression<T> Function($$StudySessionDecksTableAnnotationComposer a) f,
  ) {
    final $$StudySessionDecksTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.studySessionDecks,
          getReferencedColumn: (t) => t.sessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StudySessionDecksTableAnnotationComposer(
                $db: $db,
                $table: $db.studySessionDecks,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> studySessionCardsRefs<T extends Object>(
    Expression<T> Function($$StudySessionCardsTableAnnotationComposer a) f,
  ) {
    final $$StudySessionCardsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.studySessionCards,
          getReferencedColumn: (t) => t.sessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StudySessionCardsTableAnnotationComposer(
                $db: $db,
                $table: $db.studySessionCards,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> studyEventsRefs<T extends Object>(
    Expression<T> Function($$StudyEventsTableAnnotationComposer a) f,
  ) {
    final $$StudyEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studyEvents,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.studyEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StudySessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudySessionsTable,
          StudySession,
          $$StudySessionsTableFilterComposer,
          $$StudySessionsTableOrderingComposer,
          $$StudySessionsTableAnnotationComposer,
          $$StudySessionsTableCreateCompanionBuilder,
          $$StudySessionsTableUpdateCompanionBuilder,
          (StudySession, $$StudySessionsTableReferences),
          StudySession,
          PrefetchHooks Function({
            bool studySessionDecksRefs,
            bool studySessionCardsRefs,
            bool studyEventsRefs,
          })
        > {
  $$StudySessionsTableTableManager(_$AppDatabase db, $StudySessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudySessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudySessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudySessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> source = const Value.absent(),
                Value<int> mode = const Value.absent(),
                Value<int> currentIndex = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
              }) => StudySessionsCompanion(
                id: id,
                source: source,
                mode: mode,
                currentIndex: currentIndex,
                startedAt: startedAt,
                completedAt: completedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int source,
                required int mode,
                Value<int> currentIndex = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
              }) => StudySessionsCompanion.insert(
                id: id,
                source: source,
                mode: mode,
                currentIndex: currentIndex,
                startedAt: startedAt,
                completedAt: completedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StudySessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                studySessionDecksRefs = false,
                studySessionCardsRefs = false,
                studyEventsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (studySessionDecksRefs) db.studySessionDecks,
                    if (studySessionCardsRefs) db.studySessionCards,
                    if (studyEventsRefs) db.studyEvents,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (studySessionDecksRefs)
                        await $_getPrefetchedData<
                          StudySession,
                          $StudySessionsTable,
                          StudySessionDeck
                        >(
                          currentTable: table,
                          referencedTable: $$StudySessionsTableReferences
                              ._studySessionDecksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StudySessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).studySessionDecksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (studySessionCardsRefs)
                        await $_getPrefetchedData<
                          StudySession,
                          $StudySessionsTable,
                          StudySessionCard
                        >(
                          currentTable: table,
                          referencedTable: $$StudySessionsTableReferences
                              ._studySessionCardsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StudySessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).studySessionCardsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (studyEventsRefs)
                        await $_getPrefetchedData<
                          StudySession,
                          $StudySessionsTable,
                          StudyEvent
                        >(
                          currentTable: table,
                          referencedTable: $$StudySessionsTableReferences
                              ._studyEventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StudySessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).studyEventsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$StudySessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudySessionsTable,
      StudySession,
      $$StudySessionsTableFilterComposer,
      $$StudySessionsTableOrderingComposer,
      $$StudySessionsTableAnnotationComposer,
      $$StudySessionsTableCreateCompanionBuilder,
      $$StudySessionsTableUpdateCompanionBuilder,
      (StudySession, $$StudySessionsTableReferences),
      StudySession,
      PrefetchHooks Function({
        bool studySessionDecksRefs,
        bool studySessionCardsRefs,
        bool studyEventsRefs,
      })
    >;
typedef $$StudySessionDecksTableCreateCompanionBuilder =
    StudySessionDecksCompanion Function({
      Value<int> id,
      required int sessionId,
      required int deckId,
      required int deckOrder,
      required int requestedCountSnapshot,
    });
typedef $$StudySessionDecksTableUpdateCompanionBuilder =
    StudySessionDecksCompanion Function({
      Value<int> id,
      Value<int> sessionId,
      Value<int> deckId,
      Value<int> deckOrder,
      Value<int> requestedCountSnapshot,
    });

final class $$StudySessionDecksTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $StudySessionDecksTable,
          StudySessionDeck
        > {
  $$StudySessionDecksTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StudySessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.studySessions.createAlias(
        $_aliasNameGenerator(
          db.studySessionDecks.sessionId,
          db.studySessions.id,
        ),
      );

  $$StudySessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager = $$StudySessionsTableTableManager(
      $_db,
      $_db.studySessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $DecksTable _deckIdTable(_$AppDatabase db) => db.decks.createAlias(
    $_aliasNameGenerator(db.studySessionDecks.deckId, db.decks.id),
  );

  $$DecksTableProcessedTableManager get deckId {
    final $_column = $_itemColumn<int>('deck_id')!;

    final manager = $$DecksTableTableManager(
      $_db,
      $_db.decks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_deckIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StudySessionDecksTableFilterComposer
    extends Composer<_$AppDatabase, $StudySessionDecksTable> {
  $$StudySessionDecksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deckOrder => $composableBuilder(
    column: $table.deckOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get requestedCountSnapshot => $composableBuilder(
    column: $table.requestedCountSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  $$StudySessionsTableFilterComposer get sessionId {
    final $$StudySessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.studySessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudySessionsTableFilterComposer(
            $db: $db,
            $table: $db.studySessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DecksTableFilterComposer get deckId {
    final $$DecksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deckId,
      referencedTable: $db.decks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DecksTableFilterComposer(
            $db: $db,
            $table: $db.decks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudySessionDecksTableOrderingComposer
    extends Composer<_$AppDatabase, $StudySessionDecksTable> {
  $$StudySessionDecksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deckOrder => $composableBuilder(
    column: $table.deckOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get requestedCountSnapshot => $composableBuilder(
    column: $table.requestedCountSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  $$StudySessionsTableOrderingComposer get sessionId {
    final $$StudySessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.studySessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudySessionsTableOrderingComposer(
            $db: $db,
            $table: $db.studySessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DecksTableOrderingComposer get deckId {
    final $$DecksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deckId,
      referencedTable: $db.decks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DecksTableOrderingComposer(
            $db: $db,
            $table: $db.decks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudySessionDecksTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudySessionDecksTable> {
  $$StudySessionDecksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get deckOrder =>
      $composableBuilder(column: $table.deckOrder, builder: (column) => column);

  GeneratedColumn<int> get requestedCountSnapshot => $composableBuilder(
    column: $table.requestedCountSnapshot,
    builder: (column) => column,
  );

  $$StudySessionsTableAnnotationComposer get sessionId {
    final $$StudySessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.studySessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudySessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.studySessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DecksTableAnnotationComposer get deckId {
    final $$DecksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deckId,
      referencedTable: $db.decks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DecksTableAnnotationComposer(
            $db: $db,
            $table: $db.decks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudySessionDecksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudySessionDecksTable,
          StudySessionDeck,
          $$StudySessionDecksTableFilterComposer,
          $$StudySessionDecksTableOrderingComposer,
          $$StudySessionDecksTableAnnotationComposer,
          $$StudySessionDecksTableCreateCompanionBuilder,
          $$StudySessionDecksTableUpdateCompanionBuilder,
          (StudySessionDeck, $$StudySessionDecksTableReferences),
          StudySessionDeck,
          PrefetchHooks Function({bool sessionId, bool deckId})
        > {
  $$StudySessionDecksTableTableManager(
    _$AppDatabase db,
    $StudySessionDecksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudySessionDecksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudySessionDecksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudySessionDecksTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionId = const Value.absent(),
                Value<int> deckId = const Value.absent(),
                Value<int> deckOrder = const Value.absent(),
                Value<int> requestedCountSnapshot = const Value.absent(),
              }) => StudySessionDecksCompanion(
                id: id,
                sessionId: sessionId,
                deckId: deckId,
                deckOrder: deckOrder,
                requestedCountSnapshot: requestedCountSnapshot,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sessionId,
                required int deckId,
                required int deckOrder,
                required int requestedCountSnapshot,
              }) => StudySessionDecksCompanion.insert(
                id: id,
                sessionId: sessionId,
                deckId: deckId,
                deckOrder: deckOrder,
                requestedCountSnapshot: requestedCountSnapshot,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StudySessionDecksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false, deckId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sessionId,
                                referencedTable:
                                    $$StudySessionDecksTableReferences
                                        ._sessionIdTable(db),
                                referencedColumn:
                                    $$StudySessionDecksTableReferences
                                        ._sessionIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (deckId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.deckId,
                                referencedTable:
                                    $$StudySessionDecksTableReferences
                                        ._deckIdTable(db),
                                referencedColumn:
                                    $$StudySessionDecksTableReferences
                                        ._deckIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StudySessionDecksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudySessionDecksTable,
      StudySessionDeck,
      $$StudySessionDecksTableFilterComposer,
      $$StudySessionDecksTableOrderingComposer,
      $$StudySessionDecksTableAnnotationComposer,
      $$StudySessionDecksTableCreateCompanionBuilder,
      $$StudySessionDecksTableUpdateCompanionBuilder,
      (StudySessionDeck, $$StudySessionDecksTableReferences),
      StudySessionDeck,
      PrefetchHooks Function({bool sessionId, bool deckId})
    >;
typedef $$StudySessionCardsTableCreateCompanionBuilder =
    StudySessionCardsCompanion Function({
      Value<int> id,
      required int sessionId,
      required int cardId,
      required int sourceDeckId,
      required String titleSnapshot,
      Value<String?> answerSnapshot,
      required int displayOrder,
      Value<bool> isOver,
    });
typedef $$StudySessionCardsTableUpdateCompanionBuilder =
    StudySessionCardsCompanion Function({
      Value<int> id,
      Value<int> sessionId,
      Value<int> cardId,
      Value<int> sourceDeckId,
      Value<String> titleSnapshot,
      Value<String?> answerSnapshot,
      Value<int> displayOrder,
      Value<bool> isOver,
    });

final class $$StudySessionCardsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $StudySessionCardsTable,
          StudySessionCard
        > {
  $$StudySessionCardsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StudySessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.studySessions.createAlias(
        $_aliasNameGenerator(
          db.studySessionCards.sessionId,
          db.studySessions.id,
        ),
      );

  $$StudySessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager = $$StudySessionsTableTableManager(
      $_db,
      $_db.studySessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $DecksTable _sourceDeckIdTable(_$AppDatabase db) =>
      db.decks.createAlias(
        $_aliasNameGenerator(db.studySessionCards.sourceDeckId, db.decks.id),
      );

  $$DecksTableProcessedTableManager get sourceDeckId {
    final $_column = $_itemColumn<int>('source_deck_id')!;

    final manager = $$DecksTableTableManager(
      $_db,
      $_db.decks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceDeckIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$StudyEventsTable, List<StudyEvent>>
  _studyEventsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.studyEvents,
    aliasName: $_aliasNameGenerator(
      db.studySessionCards.id,
      db.studyEvents.sessionCardId,
    ),
  );

  $$StudyEventsTableProcessedTableManager get studyEventsRefs {
    final manager = $$StudyEventsTableTableManager(
      $_db,
      $_db.studyEvents,
    ).filter((f) => f.sessionCardId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_studyEventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StudySessionCardsTableFilterComposer
    extends Composer<_$AppDatabase, $StudySessionCardsTable> {
  $$StudySessionCardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cardId => $composableBuilder(
    column: $table.cardId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleSnapshot => $composableBuilder(
    column: $table.titleSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get answerSnapshot => $composableBuilder(
    column: $table.answerSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOver => $composableBuilder(
    column: $table.isOver,
    builder: (column) => ColumnFilters(column),
  );

  $$StudySessionsTableFilterComposer get sessionId {
    final $$StudySessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.studySessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudySessionsTableFilterComposer(
            $db: $db,
            $table: $db.studySessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DecksTableFilterComposer get sourceDeckId {
    final $$DecksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceDeckId,
      referencedTable: $db.decks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DecksTableFilterComposer(
            $db: $db,
            $table: $db.decks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> studyEventsRefs(
    Expression<bool> Function($$StudyEventsTableFilterComposer f) f,
  ) {
    final $$StudyEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studyEvents,
      getReferencedColumn: (t) => t.sessionCardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyEventsTableFilterComposer(
            $db: $db,
            $table: $db.studyEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StudySessionCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudySessionCardsTable> {
  $$StudySessionCardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cardId => $composableBuilder(
    column: $table.cardId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleSnapshot => $composableBuilder(
    column: $table.titleSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get answerSnapshot => $composableBuilder(
    column: $table.answerSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOver => $composableBuilder(
    column: $table.isOver,
    builder: (column) => ColumnOrderings(column),
  );

  $$StudySessionsTableOrderingComposer get sessionId {
    final $$StudySessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.studySessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudySessionsTableOrderingComposer(
            $db: $db,
            $table: $db.studySessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DecksTableOrderingComposer get sourceDeckId {
    final $$DecksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceDeckId,
      referencedTable: $db.decks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DecksTableOrderingComposer(
            $db: $db,
            $table: $db.decks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudySessionCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudySessionCardsTable> {
  $$StudySessionCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get cardId =>
      $composableBuilder(column: $table.cardId, builder: (column) => column);

  GeneratedColumn<String> get titleSnapshot => $composableBuilder(
    column: $table.titleSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get answerSnapshot => $composableBuilder(
    column: $table.answerSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isOver =>
      $composableBuilder(column: $table.isOver, builder: (column) => column);

  $$StudySessionsTableAnnotationComposer get sessionId {
    final $$StudySessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.studySessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudySessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.studySessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DecksTableAnnotationComposer get sourceDeckId {
    final $$DecksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceDeckId,
      referencedTable: $db.decks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DecksTableAnnotationComposer(
            $db: $db,
            $table: $db.decks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> studyEventsRefs<T extends Object>(
    Expression<T> Function($$StudyEventsTableAnnotationComposer a) f,
  ) {
    final $$StudyEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studyEvents,
      getReferencedColumn: (t) => t.sessionCardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.studyEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StudySessionCardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudySessionCardsTable,
          StudySessionCard,
          $$StudySessionCardsTableFilterComposer,
          $$StudySessionCardsTableOrderingComposer,
          $$StudySessionCardsTableAnnotationComposer,
          $$StudySessionCardsTableCreateCompanionBuilder,
          $$StudySessionCardsTableUpdateCompanionBuilder,
          (StudySessionCard, $$StudySessionCardsTableReferences),
          StudySessionCard,
          PrefetchHooks Function({
            bool sessionId,
            bool sourceDeckId,
            bool studyEventsRefs,
          })
        > {
  $$StudySessionCardsTableTableManager(
    _$AppDatabase db,
    $StudySessionCardsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudySessionCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudySessionCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudySessionCardsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionId = const Value.absent(),
                Value<int> cardId = const Value.absent(),
                Value<int> sourceDeckId = const Value.absent(),
                Value<String> titleSnapshot = const Value.absent(),
                Value<String?> answerSnapshot = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<bool> isOver = const Value.absent(),
              }) => StudySessionCardsCompanion(
                id: id,
                sessionId: sessionId,
                cardId: cardId,
                sourceDeckId: sourceDeckId,
                titleSnapshot: titleSnapshot,
                answerSnapshot: answerSnapshot,
                displayOrder: displayOrder,
                isOver: isOver,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sessionId,
                required int cardId,
                required int sourceDeckId,
                required String titleSnapshot,
                Value<String?> answerSnapshot = const Value.absent(),
                required int displayOrder,
                Value<bool> isOver = const Value.absent(),
              }) => StudySessionCardsCompanion.insert(
                id: id,
                sessionId: sessionId,
                cardId: cardId,
                sourceDeckId: sourceDeckId,
                titleSnapshot: titleSnapshot,
                answerSnapshot: answerSnapshot,
                displayOrder: displayOrder,
                isOver: isOver,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StudySessionCardsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                sessionId = false,
                sourceDeckId = false,
                studyEventsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (studyEventsRefs) db.studyEvents,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (sessionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sessionId,
                                    referencedTable:
                                        $$StudySessionCardsTableReferences
                                            ._sessionIdTable(db),
                                    referencedColumn:
                                        $$StudySessionCardsTableReferences
                                            ._sessionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (sourceDeckId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sourceDeckId,
                                    referencedTable:
                                        $$StudySessionCardsTableReferences
                                            ._sourceDeckIdTable(db),
                                    referencedColumn:
                                        $$StudySessionCardsTableReferences
                                            ._sourceDeckIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (studyEventsRefs)
                        await $_getPrefetchedData<
                          StudySessionCard,
                          $StudySessionCardsTable,
                          StudyEvent
                        >(
                          currentTable: table,
                          referencedTable: $$StudySessionCardsTableReferences
                              ._studyEventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StudySessionCardsTableReferences(
                                db,
                                table,
                                p0,
                              ).studyEventsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionCardId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$StudySessionCardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudySessionCardsTable,
      StudySessionCard,
      $$StudySessionCardsTableFilterComposer,
      $$StudySessionCardsTableOrderingComposer,
      $$StudySessionCardsTableAnnotationComposer,
      $$StudySessionCardsTableCreateCompanionBuilder,
      $$StudySessionCardsTableUpdateCompanionBuilder,
      (StudySessionCard, $$StudySessionCardsTableReferences),
      StudySessionCard,
      PrefetchHooks Function({
        bool sessionId,
        bool sourceDeckId,
        bool studyEventsRefs,
      })
    >;
typedef $$StudyEventsTableCreateCompanionBuilder =
    StudyEventsCompanion Function({
      Value<int> id,
      required int sessionId,
      Value<int?> sessionCardId,
      Value<int?> sourceDeckId,
      Value<int?> cardId,
      required int type,
      Value<String?> payload,
      Value<DateTime> occurredAt,
    });
typedef $$StudyEventsTableUpdateCompanionBuilder =
    StudyEventsCompanion Function({
      Value<int> id,
      Value<int> sessionId,
      Value<int?> sessionCardId,
      Value<int?> sourceDeckId,
      Value<int?> cardId,
      Value<int> type,
      Value<String?> payload,
      Value<DateTime> occurredAt,
    });

final class $$StudyEventsTableReferences
    extends BaseReferences<_$AppDatabase, $StudyEventsTable, StudyEvent> {
  $$StudyEventsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $StudySessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.studySessions.createAlias(
        $_aliasNameGenerator(db.studyEvents.sessionId, db.studySessions.id),
      );

  $$StudySessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager = $$StudySessionsTableTableManager(
      $_db,
      $_db.studySessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $StudySessionCardsTable _sessionCardIdTable(_$AppDatabase db) =>
      db.studySessionCards.createAlias(
        $_aliasNameGenerator(
          db.studyEvents.sessionCardId,
          db.studySessionCards.id,
        ),
      );

  $$StudySessionCardsTableProcessedTableManager? get sessionCardId {
    final $_column = $_itemColumn<int>('session_card_id');
    if ($_column == null) return null;
    final manager = $$StudySessionCardsTableTableManager(
      $_db,
      $_db.studySessionCards,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionCardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $DecksTable _sourceDeckIdTable(_$AppDatabase db) =>
      db.decks.createAlias(
        $_aliasNameGenerator(db.studyEvents.sourceDeckId, db.decks.id),
      );

  $$DecksTableProcessedTableManager? get sourceDeckId {
    final $_column = $_itemColumn<int>('source_deck_id');
    if ($_column == null) return null;
    final manager = $$DecksTableTableManager(
      $_db,
      $_db.decks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceDeckIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StudyEventsTableFilterComposer
    extends Composer<_$AppDatabase, $StudyEventsTable> {
  $$StudyEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cardId => $composableBuilder(
    column: $table.cardId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  $$StudySessionsTableFilterComposer get sessionId {
    final $$StudySessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.studySessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudySessionsTableFilterComposer(
            $db: $db,
            $table: $db.studySessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StudySessionCardsTableFilterComposer get sessionCardId {
    final $$StudySessionCardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionCardId,
      referencedTable: $db.studySessionCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudySessionCardsTableFilterComposer(
            $db: $db,
            $table: $db.studySessionCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DecksTableFilterComposer get sourceDeckId {
    final $$DecksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceDeckId,
      referencedTable: $db.decks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DecksTableFilterComposer(
            $db: $db,
            $table: $db.decks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudyEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudyEventsTable> {
  $$StudyEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cardId => $composableBuilder(
    column: $table.cardId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$StudySessionsTableOrderingComposer get sessionId {
    final $$StudySessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.studySessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudySessionsTableOrderingComposer(
            $db: $db,
            $table: $db.studySessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StudySessionCardsTableOrderingComposer get sessionCardId {
    final $$StudySessionCardsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionCardId,
      referencedTable: $db.studySessionCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudySessionCardsTableOrderingComposer(
            $db: $db,
            $table: $db.studySessionCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DecksTableOrderingComposer get sourceDeckId {
    final $$DecksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceDeckId,
      referencedTable: $db.decks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DecksTableOrderingComposer(
            $db: $db,
            $table: $db.decks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudyEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudyEventsTable> {
  $$StudyEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get cardId =>
      $composableBuilder(column: $table.cardId, builder: (column) => column);

  GeneratedColumn<int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  $$StudySessionsTableAnnotationComposer get sessionId {
    final $$StudySessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.studySessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudySessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.studySessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StudySessionCardsTableAnnotationComposer get sessionCardId {
    final $$StudySessionCardsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sessionCardId,
          referencedTable: $db.studySessionCards,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StudySessionCardsTableAnnotationComposer(
                $db: $db,
                $table: $db.studySessionCards,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$DecksTableAnnotationComposer get sourceDeckId {
    final $$DecksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceDeckId,
      referencedTable: $db.decks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DecksTableAnnotationComposer(
            $db: $db,
            $table: $db.decks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudyEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudyEventsTable,
          StudyEvent,
          $$StudyEventsTableFilterComposer,
          $$StudyEventsTableOrderingComposer,
          $$StudyEventsTableAnnotationComposer,
          $$StudyEventsTableCreateCompanionBuilder,
          $$StudyEventsTableUpdateCompanionBuilder,
          (StudyEvent, $$StudyEventsTableReferences),
          StudyEvent,
          PrefetchHooks Function({
            bool sessionId,
            bool sessionCardId,
            bool sourceDeckId,
          })
        > {
  $$StudyEventsTableTableManager(_$AppDatabase db, $StudyEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudyEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudyEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudyEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionId = const Value.absent(),
                Value<int?> sessionCardId = const Value.absent(),
                Value<int?> sourceDeckId = const Value.absent(),
                Value<int?> cardId = const Value.absent(),
                Value<int> type = const Value.absent(),
                Value<String?> payload = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
              }) => StudyEventsCompanion(
                id: id,
                sessionId: sessionId,
                sessionCardId: sessionCardId,
                sourceDeckId: sourceDeckId,
                cardId: cardId,
                type: type,
                payload: payload,
                occurredAt: occurredAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sessionId,
                Value<int?> sessionCardId = const Value.absent(),
                Value<int?> sourceDeckId = const Value.absent(),
                Value<int?> cardId = const Value.absent(),
                required int type,
                Value<String?> payload = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
              }) => StudyEventsCompanion.insert(
                id: id,
                sessionId: sessionId,
                sessionCardId: sessionCardId,
                sourceDeckId: sourceDeckId,
                cardId: cardId,
                type: type,
                payload: payload,
                occurredAt: occurredAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StudyEventsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                sessionId = false,
                sessionCardId = false,
                sourceDeckId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (sessionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sessionId,
                                    referencedTable:
                                        $$StudyEventsTableReferences
                                            ._sessionIdTable(db),
                                    referencedColumn:
                                        $$StudyEventsTableReferences
                                            ._sessionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (sessionCardId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sessionCardId,
                                    referencedTable:
                                        $$StudyEventsTableReferences
                                            ._sessionCardIdTable(db),
                                    referencedColumn:
                                        $$StudyEventsTableReferences
                                            ._sessionCardIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (sourceDeckId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sourceDeckId,
                                    referencedTable:
                                        $$StudyEventsTableReferences
                                            ._sourceDeckIdTable(db),
                                    referencedColumn:
                                        $$StudyEventsTableReferences
                                            ._sourceDeckIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$StudyEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudyEventsTable,
      StudyEvent,
      $$StudyEventsTableFilterComposer,
      $$StudyEventsTableOrderingComposer,
      $$StudyEventsTableAnnotationComposer,
      $$StudyEventsTableCreateCompanionBuilder,
      $$StudyEventsTableUpdateCompanionBuilder,
      (StudyEvent, $$StudyEventsTableReferences),
      StudyEvent,
      PrefetchHooks Function({
        bool sessionId,
        bool sessionCardId,
        bool sourceDeckId,
      })
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DecksTableTableManager get decks =>
      $$DecksTableTableManager(_db, _db.decks);
  $$CardItemsTableTableManager get cardItems =>
      $$CardItemsTableTableManager(_db, _db.cardItems);
  $$StudySessionsTableTableManager get studySessions =>
      $$StudySessionsTableTableManager(_db, _db.studySessions);
  $$StudySessionDecksTableTableManager get studySessionDecks =>
      $$StudySessionDecksTableTableManager(_db, _db.studySessionDecks);
  $$StudySessionCardsTableTableManager get studySessionCards =>
      $$StudySessionCardsTableTableManager(_db, _db.studySessionCards);
  $$StudyEventsTableTableManager get studyEvents =>
      $$StudyEventsTableTableManager(_db, _db.studyEvents);
}
