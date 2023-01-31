// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tables.dart';

// ignore_for_file: type=lint
class $UserTable extends User with TableInfo<$UserTable, UserData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _passwordMeta =
      const VerificationMeta('password');
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
      'password', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<int> phone = GeneratedColumn<int>(
      'phone', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _mailMeta = const VerificationMeta('mail');
  @override
  late final GeneratedColumn<String> mail = GeneratedColumn<String>(
      'mail', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, username, password, phone, mail];
  @override
  String get aliasedName => _alias ?? 'user';
  @override
  String get actualTableName => 'user';
  @override
  VerificationContext validateIntegrity(Insertable<UserData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('mail')) {
      context.handle(
          _mailMeta, mail.isAcceptableOrUnknown(data['mail']!, _mailMeta));
    } else if (isInserting) {
      context.missing(_mailMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      password: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}phone'])!,
      mail: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mail'])!,
    );
  }

  @override
  $UserTable createAlias(String alias) {
    return $UserTable(attachedDatabase, alias);
  }
}

class UserData extends DataClass implements Insertable<UserData> {
  final int id;
  final String username;
  final String password;
  final int phone;
  final String mail;
  const UserData(
      {required this.id,
      required this.username,
      required this.password,
      required this.phone,
      required this.mail});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['username'] = Variable<String>(username);
    map['password'] = Variable<String>(password);
    map['phone'] = Variable<int>(phone);
    map['mail'] = Variable<String>(mail);
    return map;
  }

  UserCompanion toCompanion(bool nullToAbsent) {
    return UserCompanion(
      id: Value(id),
      username: Value(username),
      password: Value(password),
      phone: Value(phone),
      mail: Value(mail),
    );
  }

  factory UserData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserData(
      id: serializer.fromJson<int>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      password: serializer.fromJson<String>(json['password']),
      phone: serializer.fromJson<int>(json['phone']),
      mail: serializer.fromJson<String>(json['mail']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'username': serializer.toJson<String>(username),
      'password': serializer.toJson<String>(password),
      'phone': serializer.toJson<int>(phone),
      'mail': serializer.toJson<String>(mail),
    };
  }

  UserData copyWith(
          {int? id,
          String? username,
          String? password,
          int? phone,
          String? mail}) =>
      UserData(
        id: id ?? this.id,
        username: username ?? this.username,
        password: password ?? this.password,
        phone: phone ?? this.phone,
        mail: mail ?? this.mail,
      );
  @override
  String toString() {
    return (StringBuffer('UserData(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('phone: $phone, ')
          ..write('mail: $mail')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, username, password, phone, mail);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserData &&
          other.id == this.id &&
          other.username == this.username &&
          other.password == this.password &&
          other.phone == this.phone &&
          other.mail == this.mail);
}

class UserCompanion extends UpdateCompanion<UserData> {
  final Value<int> id;
  final Value<String> username;
  final Value<String> password;
  final Value<int> phone;
  final Value<String> mail;
  const UserCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.password = const Value.absent(),
    this.phone = const Value.absent(),
    this.mail = const Value.absent(),
  });
  UserCompanion.insert({
    this.id = const Value.absent(),
    required String username,
    required String password,
    required int phone,
    required String mail,
  })  : username = Value(username),
        password = Value(password),
        phone = Value(phone),
        mail = Value(mail);
  static Insertable<UserData> custom({
    Expression<int>? id,
    Expression<String>? username,
    Expression<String>? password,
    Expression<int>? phone,
    Expression<String>? mail,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (password != null) 'password': password,
      if (phone != null) 'phone': phone,
      if (mail != null) 'mail': mail,
    });
  }

  UserCompanion copyWith(
      {Value<int>? id,
      Value<String>? username,
      Value<String>? password,
      Value<int>? phone,
      Value<String>? mail}) {
    return UserCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      mail: mail ?? this.mail,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (phone.present) {
      map['phone'] = Variable<int>(phone.value);
    }
    if (mail.present) {
      map['mail'] = Variable<String>(mail.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('phone: $phone, ')
          ..write('mail: $mail')
          ..write(')'))
        .toString();
  }
}

class $MaterialTypeTable extends MaterialType
    with TableInfo<$MaterialTypeTable, MaterialTypeData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MaterialTypeTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, type];
  @override
  String get aliasedName => _alias ?? 'material_type';
  @override
  String get actualTableName => 'material_type';
  @override
  VerificationContext validateIntegrity(Insertable<MaterialTypeData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MaterialTypeData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MaterialTypeData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
    );
  }

  @override
  $MaterialTypeTable createAlias(String alias) {
    return $MaterialTypeTable(attachedDatabase, alias);
  }
}

class MaterialTypeData extends DataClass
    implements Insertable<MaterialTypeData> {
  final int id;
  final String type;
  const MaterialTypeData({required this.id, required this.type});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    return map;
  }

  MaterialTypeCompanion toCompanion(bool nullToAbsent) {
    return MaterialTypeCompanion(
      id: Value(id),
      type: Value(type),
    );
  }

  factory MaterialTypeData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MaterialTypeData(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
    };
  }

  MaterialTypeData copyWith({int? id, String? type}) => MaterialTypeData(
        id: id ?? this.id,
        type: type ?? this.type,
      );
  @override
  String toString() {
    return (StringBuffer('MaterialTypeData(')
          ..write('id: $id, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MaterialTypeData &&
          other.id == this.id &&
          other.type == this.type);
}

class MaterialTypeCompanion extends UpdateCompanion<MaterialTypeData> {
  final Value<int> id;
  final Value<String> type;
  const MaterialTypeCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
  });
  MaterialTypeCompanion.insert({
    this.id = const Value.absent(),
    required String type,
  }) : type = Value(type);
  static Insertable<MaterialTypeData> custom({
    Expression<int>? id,
    Expression<String>? type,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
    });
  }

  MaterialTypeCompanion copyWith({Value<int>? id, Value<String>? type}) {
    return MaterialTypeCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MaterialTypeCompanion(')
          ..write('id: $id, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }
}

class $PartyTypeMasterTable extends PartyTypeMaster
    with TableInfo<$PartyTypeMasterTable, PartyTypeMasterData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartyTypeMasterTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, type];
  @override
  String get aliasedName => _alias ?? 'party_type_master';
  @override
  String get actualTableName => 'party_type_master';
  @override
  VerificationContext validateIntegrity(
      Insertable<PartyTypeMasterData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PartyTypeMasterData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PartyTypeMasterData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
    );
  }

  @override
  $PartyTypeMasterTable createAlias(String alias) {
    return $PartyTypeMasterTable(attachedDatabase, alias);
  }
}

class PartyTypeMasterData extends DataClass
    implements Insertable<PartyTypeMasterData> {
  final int id;
  final String type;
  const PartyTypeMasterData({required this.id, required this.type});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    return map;
  }

  PartyTypeMasterCompanion toCompanion(bool nullToAbsent) {
    return PartyTypeMasterCompanion(
      id: Value(id),
      type: Value(type),
    );
  }

  factory PartyTypeMasterData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PartyTypeMasterData(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
    };
  }

  PartyTypeMasterData copyWith({int? id, String? type}) => PartyTypeMasterData(
        id: id ?? this.id,
        type: type ?? this.type,
      );
  @override
  String toString() {
    return (StringBuffer('PartyTypeMasterData(')
          ..write('id: $id, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PartyTypeMasterData &&
          other.id == this.id &&
          other.type == this.type);
}

class PartyTypeMasterCompanion extends UpdateCompanion<PartyTypeMasterData> {
  final Value<int> id;
  final Value<String> type;
  const PartyTypeMasterCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
  });
  PartyTypeMasterCompanion.insert({
    this.id = const Value.absent(),
    required String type,
  }) : type = Value(type);
  static Insertable<PartyTypeMasterData> custom({
    Expression<int>? id,
    Expression<String>? type,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
    });
  }

  PartyTypeMasterCompanion copyWith({Value<int>? id, Value<String>? type}) {
    return PartyTypeMasterCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartyTypeMasterCompanion(')
          ..write('id: $id, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }
}

class $PartyMasterTable extends PartyMaster
    with TableInfo<$PartyMasterTable, PartyMasterData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartyMasterTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ptIDMeta = const VerificationMeta('ptID');
  @override
  late final GeneratedColumn<int> ptID = GeneratedColumn<int>(
      'pt_i_d', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES party_type_master (id)'));
  @override
  List<GeneratedColumn> get $columns => [id, name, ptID];
  @override
  String get aliasedName => _alias ?? 'party_master';
  @override
  String get actualTableName => 'party_master';
  @override
  VerificationContext validateIntegrity(Insertable<PartyMasterData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('pt_i_d')) {
      context.handle(
          _ptIDMeta, ptID.isAcceptableOrUnknown(data['pt_i_d']!, _ptIDMeta));
    } else if (isInserting) {
      context.missing(_ptIDMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PartyMasterData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PartyMasterData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      ptID: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pt_i_d'])!,
    );
  }

  @override
  $PartyMasterTable createAlias(String alias) {
    return $PartyMasterTable(attachedDatabase, alias);
  }
}

class PartyMasterData extends DataClass implements Insertable<PartyMasterData> {
  final int id;
  final String name;
  final int ptID;
  const PartyMasterData(
      {required this.id, required this.name, required this.ptID});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['pt_i_d'] = Variable<int>(ptID);
    return map;
  }

  PartyMasterCompanion toCompanion(bool nullToAbsent) {
    return PartyMasterCompanion(
      id: Value(id),
      name: Value(name),
      ptID: Value(ptID),
    );
  }

  factory PartyMasterData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PartyMasterData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      ptID: serializer.fromJson<int>(json['ptID']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'ptID': serializer.toJson<int>(ptID),
    };
  }

  PartyMasterData copyWith({int? id, String? name, int? ptID}) =>
      PartyMasterData(
        id: id ?? this.id,
        name: name ?? this.name,
        ptID: ptID ?? this.ptID,
      );
  @override
  String toString() {
    return (StringBuffer('PartyMasterData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('ptID: $ptID')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, ptID);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PartyMasterData &&
          other.id == this.id &&
          other.name == this.name &&
          other.ptID == this.ptID);
}

class PartyMasterCompanion extends UpdateCompanion<PartyMasterData> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> ptID;
  const PartyMasterCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.ptID = const Value.absent(),
  });
  PartyMasterCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int ptID,
  })  : name = Value(name),
        ptID = Value(ptID);
  static Insertable<PartyMasterData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? ptID,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (ptID != null) 'pt_i_d': ptID,
    });
  }

  PartyMasterCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<int>? ptID}) {
    return PartyMasterCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      ptID: ptID ?? this.ptID,
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
    if (ptID.present) {
      map['pt_i_d'] = Variable<int>(ptID.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartyMasterCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('ptID: $ptID')
          ..write(')'))
        .toString();
  }
}

class $PartyComissionDetailTable extends PartyComissionDetail
    with TableInfo<$PartyComissionDetailTable, PartyComissionDetailData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartyComissionDetailTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _pIDMeta = const VerificationMeta('pID');
  @override
  late final GeneratedColumn<int> pID = GeneratedColumn<int>(
      'p_i_d', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES party_master (id)'));
  static const VerificationMeta _mtIDMeta = const VerificationMeta('mtID');
  @override
  late final GeneratedColumn<int> mtID = GeneratedColumn<int>(
      'mt_i_d', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES material_type (id)'));
  static const VerificationMeta _comission1Meta =
      const VerificationMeta('comission1');
  @override
  late final GeneratedColumn<double> comission1 = GeneratedColumn<double>(
      'comission1', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _comission2Meta =
      const VerificationMeta('comission2');
  @override
  late final GeneratedColumn<double> comission2 = GeneratedColumn<double>(
      'comission2', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _comission3Meta =
      const VerificationMeta('comission3');
  @override
  late final GeneratedColumn<double> comission3 = GeneratedColumn<double>(
      'comission3', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _mpriceMeta = const VerificationMeta('mprice');
  @override
  late final GeneratedColumn<double> mprice = GeneratedColumn<double>(
      'mprice', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, pID, mtID, comission1, comission2, comission3, mprice];
  @override
  String get aliasedName => _alias ?? 'party_comission_detail';
  @override
  String get actualTableName => 'party_comission_detail';
  @override
  VerificationContext validateIntegrity(
      Insertable<PartyComissionDetailData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('p_i_d')) {
      context.handle(
          _pIDMeta, pID.isAcceptableOrUnknown(data['p_i_d']!, _pIDMeta));
    } else if (isInserting) {
      context.missing(_pIDMeta);
    }
    if (data.containsKey('mt_i_d')) {
      context.handle(
          _mtIDMeta, mtID.isAcceptableOrUnknown(data['mt_i_d']!, _mtIDMeta));
    } else if (isInserting) {
      context.missing(_mtIDMeta);
    }
    if (data.containsKey('comission1')) {
      context.handle(
          _comission1Meta,
          comission1.isAcceptableOrUnknown(
              data['comission1']!, _comission1Meta));
    } else if (isInserting) {
      context.missing(_comission1Meta);
    }
    if (data.containsKey('comission2')) {
      context.handle(
          _comission2Meta,
          comission2.isAcceptableOrUnknown(
              data['comission2']!, _comission2Meta));
    } else if (isInserting) {
      context.missing(_comission2Meta);
    }
    if (data.containsKey('comission3')) {
      context.handle(
          _comission3Meta,
          comission3.isAcceptableOrUnknown(
              data['comission3']!, _comission3Meta));
    } else if (isInserting) {
      context.missing(_comission3Meta);
    }
    if (data.containsKey('mprice')) {
      context.handle(_mpriceMeta,
          mprice.isAcceptableOrUnknown(data['mprice']!, _mpriceMeta));
    } else if (isInserting) {
      context.missing(_mpriceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PartyComissionDetailData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PartyComissionDetailData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      pID: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}p_i_d'])!,
      mtID: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}mt_i_d'])!,
      comission1: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}comission1'])!,
      comission2: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}comission2'])!,
      comission3: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}comission3'])!,
      mprice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}mprice'])!,
    );
  }

  @override
  $PartyComissionDetailTable createAlias(String alias) {
    return $PartyComissionDetailTable(attachedDatabase, alias);
  }
}

class PartyComissionDetailData extends DataClass
    implements Insertable<PartyComissionDetailData> {
  final int id;
  final int pID;
  final int mtID;
  final double comission1;
  final double comission2;
  final double comission3;
  final double mprice;
  const PartyComissionDetailData(
      {required this.id,
      required this.pID,
      required this.mtID,
      required this.comission1,
      required this.comission2,
      required this.comission3,
      required this.mprice});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['p_i_d'] = Variable<int>(pID);
    map['mt_i_d'] = Variable<int>(mtID);
    map['comission1'] = Variable<double>(comission1);
    map['comission2'] = Variable<double>(comission2);
    map['comission3'] = Variable<double>(comission3);
    map['mprice'] = Variable<double>(mprice);
    return map;
  }

  PartyComissionDetailCompanion toCompanion(bool nullToAbsent) {
    return PartyComissionDetailCompanion(
      id: Value(id),
      pID: Value(pID),
      mtID: Value(mtID),
      comission1: Value(comission1),
      comission2: Value(comission2),
      comission3: Value(comission3),
      mprice: Value(mprice),
    );
  }

  factory PartyComissionDetailData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PartyComissionDetailData(
      id: serializer.fromJson<int>(json['id']),
      pID: serializer.fromJson<int>(json['pID']),
      mtID: serializer.fromJson<int>(json['mtID']),
      comission1: serializer.fromJson<double>(json['comission1']),
      comission2: serializer.fromJson<double>(json['comission2']),
      comission3: serializer.fromJson<double>(json['comission3']),
      mprice: serializer.fromJson<double>(json['mprice']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pID': serializer.toJson<int>(pID),
      'mtID': serializer.toJson<int>(mtID),
      'comission1': serializer.toJson<double>(comission1),
      'comission2': serializer.toJson<double>(comission2),
      'comission3': serializer.toJson<double>(comission3),
      'mprice': serializer.toJson<double>(mprice),
    };
  }

  PartyComissionDetailData copyWith(
          {int? id,
          int? pID,
          int? mtID,
          double? comission1,
          double? comission2,
          double? comission3,
          double? mprice}) =>
      PartyComissionDetailData(
        id: id ?? this.id,
        pID: pID ?? this.pID,
        mtID: mtID ?? this.mtID,
        comission1: comission1 ?? this.comission1,
        comission2: comission2 ?? this.comission2,
        comission3: comission3 ?? this.comission3,
        mprice: mprice ?? this.mprice,
      );
  @override
  String toString() {
    return (StringBuffer('PartyComissionDetailData(')
          ..write('id: $id, ')
          ..write('pID: $pID, ')
          ..write('mtID: $mtID, ')
          ..write('comission1: $comission1, ')
          ..write('comission2: $comission2, ')
          ..write('comission3: $comission3, ')
          ..write('mprice: $mprice')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, pID, mtID, comission1, comission2, comission3, mprice);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PartyComissionDetailData &&
          other.id == this.id &&
          other.pID == this.pID &&
          other.mtID == this.mtID &&
          other.comission1 == this.comission1 &&
          other.comission2 == this.comission2 &&
          other.comission3 == this.comission3 &&
          other.mprice == this.mprice);
}

class PartyComissionDetailCompanion
    extends UpdateCompanion<PartyComissionDetailData> {
  final Value<int> id;
  final Value<int> pID;
  final Value<int> mtID;
  final Value<double> comission1;
  final Value<double> comission2;
  final Value<double> comission3;
  final Value<double> mprice;
  const PartyComissionDetailCompanion({
    this.id = const Value.absent(),
    this.pID = const Value.absent(),
    this.mtID = const Value.absent(),
    this.comission1 = const Value.absent(),
    this.comission2 = const Value.absent(),
    this.comission3 = const Value.absent(),
    this.mprice = const Value.absent(),
  });
  PartyComissionDetailCompanion.insert({
    this.id = const Value.absent(),
    required int pID,
    required int mtID,
    required double comission1,
    required double comission2,
    required double comission3,
    required double mprice,
  })  : pID = Value(pID),
        mtID = Value(mtID),
        comission1 = Value(comission1),
        comission2 = Value(comission2),
        comission3 = Value(comission3),
        mprice = Value(mprice);
  static Insertable<PartyComissionDetailData> custom({
    Expression<int>? id,
    Expression<int>? pID,
    Expression<int>? mtID,
    Expression<double>? comission1,
    Expression<double>? comission2,
    Expression<double>? comission3,
    Expression<double>? mprice,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pID != null) 'p_i_d': pID,
      if (mtID != null) 'mt_i_d': mtID,
      if (comission1 != null) 'comission1': comission1,
      if (comission2 != null) 'comission2': comission2,
      if (comission3 != null) 'comission3': comission3,
      if (mprice != null) 'mprice': mprice,
    });
  }

  PartyComissionDetailCompanion copyWith(
      {Value<int>? id,
      Value<int>? pID,
      Value<int>? mtID,
      Value<double>? comission1,
      Value<double>? comission2,
      Value<double>? comission3,
      Value<double>? mprice}) {
    return PartyComissionDetailCompanion(
      id: id ?? this.id,
      pID: pID ?? this.pID,
      mtID: mtID ?? this.mtID,
      comission1: comission1 ?? this.comission1,
      comission2: comission2 ?? this.comission2,
      comission3: comission3 ?? this.comission3,
      mprice: mprice ?? this.mprice,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pID.present) {
      map['p_i_d'] = Variable<int>(pID.value);
    }
    if (mtID.present) {
      map['mt_i_d'] = Variable<int>(mtID.value);
    }
    if (comission1.present) {
      map['comission1'] = Variable<double>(comission1.value);
    }
    if (comission2.present) {
      map['comission2'] = Variable<double>(comission2.value);
    }
    if (comission3.present) {
      map['comission3'] = Variable<double>(comission3.value);
    }
    if (mprice.present) {
      map['mprice'] = Variable<double>(mprice.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartyComissionDetailCompanion(')
          ..write('id: $id, ')
          ..write('pID: $pID, ')
          ..write('mtID: $mtID, ')
          ..write('comission1: $comission1, ')
          ..write('comission2: $comission2, ')
          ..write('comission3: $comission3, ')
          ..write('mprice: $mprice')
          ..write(')'))
        .toString();
  }
}

class $InputDataTable extends InputData
    with TableInfo<$InputDataTable, InputDataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InputDataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _documentTypeMeta =
      const VerificationMeta('documentType');
  @override
  late final GeneratedColumn<String> documentType = GeneratedColumn<String>(
      'document_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _distDocDateMeta =
      const VerificationMeta('distDocDate');
  @override
  late final GeneratedColumn<DateTime> distDocDate = GeneratedColumn<DateTime>(
      'dist_doc_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _distDocNoMeta =
      const VerificationMeta('distDocNo');
  @override
  late final GeneratedColumn<String> distDocNo = GeneratedColumn<String>(
      'dist_doc_no', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _hospitalIDMeta =
      const VerificationMeta('hospitalID');
  @override
  late final GeneratedColumn<int> hospitalID = GeneratedColumn<int>(
      'hospital_i_d', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES party_master (id)'));
  static const VerificationMeta _custBillCityMeta =
      const VerificationMeta('custBillCity');
  @override
  late final GeneratedColumn<String> custBillCity = GeneratedColumn<String>(
      'cust_bill_city', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _matCodeMeta =
      const VerificationMeta('matCode');
  @override
  late final GeneratedColumn<String> matCode = GeneratedColumn<String>(
      'mat_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _matNameMeta =
      const VerificationMeta('matName');
  @override
  late final GeneratedColumn<String> matName = GeneratedColumn<String>(
      'mat_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _mtIDMeta = const VerificationMeta('mtID');
  @override
  late final GeneratedColumn<int> mtID = GeneratedColumn<int>(
      'mt_i_d', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES material_type (id)'));
  static const VerificationMeta _qtyMeta = const VerificationMeta('qty');
  @override
  late final GeneratedColumn<int> qty = GeneratedColumn<int>(
      'qty', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _doctorIDMeta =
      const VerificationMeta('doctorID');
  @override
  late final GeneratedColumn<int> doctorID = GeneratedColumn<int>(
      'doctor_i_d', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES party_master (id)'));
  static const VerificationMeta _techniqalStaffIDMeta =
      const VerificationMeta('techniqalStaffID');
  @override
  late final GeneratedColumn<int> techniqalStaffID = GeneratedColumn<int>(
      'techniqal_staff_i_d', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES party_master (id)'));
  static const VerificationMeta _saleAmountMeta =
      const VerificationMeta('saleAmount');
  @override
  late final GeneratedColumn<double> saleAmount = GeneratedColumn<double>(
      'sale_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _totalSaleMeta =
      const VerificationMeta('totalSale');
  @override
  late final GeneratedColumn<double> totalSale = GeneratedColumn<double>(
      'total_sale', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _smtDocDateMeta =
      const VerificationMeta('smtDocDate');
  @override
  late final GeneratedColumn<DateTime> smtDocDate = GeneratedColumn<DateTime>(
      'smt_doc_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _smtDocNoMeta =
      const VerificationMeta('smtDocNo');
  @override
  late final GeneratedColumn<String> smtDocNo = GeneratedColumn<String>(
      'smt_doc_no', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _smtInvNoMeta =
      const VerificationMeta('smtInvNo');
  @override
  late final GeneratedColumn<String> smtInvNo = GeneratedColumn<String>(
      'smt_inv_no', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _purchaseTaxableAmountMeta =
      const VerificationMeta('purchaseTaxableAmount');
  @override
  late final GeneratedColumn<double> purchaseTaxableAmount =
      GeneratedColumn<double>('purchase_taxable_amount', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _totalPurchaseAmountMeta =
      const VerificationMeta('totalPurchaseAmount');
  @override
  late final GeneratedColumn<double> totalPurchaseAmount =
      GeneratedColumn<double>('total_purchase_amount', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _logIdMeta = const VerificationMeta('logId');
  @override
  late final GeneratedColumn<int> logId = GeneratedColumn<int>(
      'log_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _hospitalGenerateLedgerIdMeta =
      const VerificationMeta('hospitalGenerateLedgerId');
  @override
  late final GeneratedColumn<int> hospitalGenerateLedgerId =
      GeneratedColumn<int>('hospital_generate_ledger_id', aliasedName, false,
          type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _hospitalPaymentLedgerIdMeta =
      const VerificationMeta('hospitalPaymentLedgerId');
  @override
  late final GeneratedColumn<int> hospitalPaymentLedgerId =
      GeneratedColumn<int>('hospital_payment_ledger_id', aliasedName, false,
          type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _hospitalComissionMeta =
      const VerificationMeta('hospitalComission');
  @override
  late final GeneratedColumn<double> hospitalComission =
      GeneratedColumn<double>('hospital_comission', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _hospitalComissionAmountMeta =
      const VerificationMeta('hospitalComissionAmount');
  @override
  late final GeneratedColumn<double> hospitalComissionAmount =
      GeneratedColumn<double>('hospital_comission_amount', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _hospitalComissionPaidDateMeta =
      const VerificationMeta('hospitalComissionPaidDate');
  @override
  late final GeneratedColumn<DateTime> hospitalComissionPaidDate =
      GeneratedColumn<DateTime>(
          'hospital_comission_paid_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _hospitalAdjustComissionAmountMeta =
      const VerificationMeta('hospitalAdjustComissionAmount');
  @override
  late final GeneratedColumn<double> hospitalAdjustComissionAmount =
      GeneratedColumn<double>(
          'hospital_adjust_comission_amount', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _doctorGenerateLedgerIdMeta =
      const VerificationMeta('doctorGenerateLedgerId');
  @override
  late final GeneratedColumn<int> doctorGenerateLedgerId = GeneratedColumn<int>(
      'doctor_generate_ledger_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _doctorPaymentLedgerIdMeta =
      const VerificationMeta('doctorPaymentLedgerId');
  @override
  late final GeneratedColumn<int> doctorPaymentLedgerId = GeneratedColumn<int>(
      'doctor_payment_ledger_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _doctorComissionMeta =
      const VerificationMeta('doctorComission');
  @override
  late final GeneratedColumn<double> doctorComission = GeneratedColumn<double>(
      'doctor_comission', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _doctorComissionAmountMeta =
      const VerificationMeta('doctorComissionAmount');
  @override
  late final GeneratedColumn<double> doctorComissionAmount =
      GeneratedColumn<double>('doctor_comission_amount', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _doctorComissionPaidDateMeta =
      const VerificationMeta('doctorComissionPaidDate');
  @override
  late final GeneratedColumn<DateTime> doctorComissionPaidDate =
      GeneratedColumn<DateTime>(
          'doctor_comission_paid_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _doctorAdjustComissionAmountMeta =
      const VerificationMeta('doctorAdjustComissionAmount');
  @override
  late final GeneratedColumn<double> doctorAdjustComissionAmount =
      GeneratedColumn<double>(
          'doctor_adjust_comission_amount', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _techniqalStaffGenerateLedgerIdMeta =
      const VerificationMeta('techniqalStaffGenerateLedgerId');
  @override
  late final GeneratedColumn<int> techniqalStaffGenerateLedgerId =
      GeneratedColumn<int>(
          'techniqal_staff_generate_ledger_id', aliasedName, false,
          type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _techniqalStaffPaymentLedgerIdMeta =
      const VerificationMeta('techniqalStaffPaymentLedgerId');
  @override
  late final GeneratedColumn<int> techniqalStaffPaymentLedgerId =
      GeneratedColumn<int>(
          'techniqal_staff_payment_ledger_id', aliasedName, false,
          type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _techniqalStaffComissionMeta =
      const VerificationMeta('techniqalStaffComission');
  @override
  late final GeneratedColumn<double> techniqalStaffComission =
      GeneratedColumn<double>('techniqal_staff_comission', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _techniqalStaffComissionAmountMeta =
      const VerificationMeta('techniqalStaffComissionAmount');
  @override
  late final GeneratedColumn<double> techniqalStaffComissionAmount =
      GeneratedColumn<double>(
          'techniqal_staff_comission_amount', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _techniqalStaffComissionPaidDateMeta =
      const VerificationMeta('techniqalStaffComissionPaidDate');
  @override
  late final GeneratedColumn<DateTime> techniqalStaffComissionPaidDate =
      GeneratedColumn<DateTime>(
          'techniqal_staff_comission_paid_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _techniqalStaffAdjustComissionAmountMeta =
      const VerificationMeta('techniqalStaffAdjustComissionAmount');
  @override
  late final GeneratedColumn<double> techniqalStaffAdjustComissionAmount =
      GeneratedColumn<double>(
          'techniqal_staff_adjust_comission_amount', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        documentType,
        distDocDate,
        distDocNo,
        hospitalID,
        custBillCity,
        matCode,
        matName,
        mtID,
        qty,
        doctorID,
        techniqalStaffID,
        saleAmount,
        totalSale,
        smtDocDate,
        smtDocNo,
        smtInvNo,
        purchaseTaxableAmount,
        totalPurchaseAmount,
        logId,
        hospitalGenerateLedgerId,
        hospitalPaymentLedgerId,
        hospitalComission,
        hospitalComissionAmount,
        hospitalComissionPaidDate,
        hospitalAdjustComissionAmount,
        doctorGenerateLedgerId,
        doctorPaymentLedgerId,
        doctorComission,
        doctorComissionAmount,
        doctorComissionPaidDate,
        doctorAdjustComissionAmount,
        techniqalStaffGenerateLedgerId,
        techniqalStaffPaymentLedgerId,
        techniqalStaffComission,
        techniqalStaffComissionAmount,
        techniqalStaffComissionPaidDate,
        techniqalStaffAdjustComissionAmount
      ];
  @override
  String get aliasedName => _alias ?? 'input_data';
  @override
  String get actualTableName => 'input_data';
  @override
  VerificationContext validateIntegrity(Insertable<InputDataData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('document_type')) {
      context.handle(
          _documentTypeMeta,
          documentType.isAcceptableOrUnknown(
              data['document_type']!, _documentTypeMeta));
    } else if (isInserting) {
      context.missing(_documentTypeMeta);
    }
    if (data.containsKey('dist_doc_date')) {
      context.handle(
          _distDocDateMeta,
          distDocDate.isAcceptableOrUnknown(
              data['dist_doc_date']!, _distDocDateMeta));
    } else if (isInserting) {
      context.missing(_distDocDateMeta);
    }
    if (data.containsKey('dist_doc_no')) {
      context.handle(
          _distDocNoMeta,
          distDocNo.isAcceptableOrUnknown(
              data['dist_doc_no']!, _distDocNoMeta));
    } else if (isInserting) {
      context.missing(_distDocNoMeta);
    }
    if (data.containsKey('hospital_i_d')) {
      context.handle(
          _hospitalIDMeta,
          hospitalID.isAcceptableOrUnknown(
              data['hospital_i_d']!, _hospitalIDMeta));
    } else if (isInserting) {
      context.missing(_hospitalIDMeta);
    }
    if (data.containsKey('cust_bill_city')) {
      context.handle(
          _custBillCityMeta,
          custBillCity.isAcceptableOrUnknown(
              data['cust_bill_city']!, _custBillCityMeta));
    } else if (isInserting) {
      context.missing(_custBillCityMeta);
    }
    if (data.containsKey('mat_code')) {
      context.handle(_matCodeMeta,
          matCode.isAcceptableOrUnknown(data['mat_code']!, _matCodeMeta));
    } else if (isInserting) {
      context.missing(_matCodeMeta);
    }
    if (data.containsKey('mat_name')) {
      context.handle(_matNameMeta,
          matName.isAcceptableOrUnknown(data['mat_name']!, _matNameMeta));
    } else if (isInserting) {
      context.missing(_matNameMeta);
    }
    if (data.containsKey('mt_i_d')) {
      context.handle(
          _mtIDMeta, mtID.isAcceptableOrUnknown(data['mt_i_d']!, _mtIDMeta));
    } else if (isInserting) {
      context.missing(_mtIDMeta);
    }
    if (data.containsKey('qty')) {
      context.handle(
          _qtyMeta, qty.isAcceptableOrUnknown(data['qty']!, _qtyMeta));
    } else if (isInserting) {
      context.missing(_qtyMeta);
    }
    if (data.containsKey('doctor_i_d')) {
      context.handle(_doctorIDMeta,
          doctorID.isAcceptableOrUnknown(data['doctor_i_d']!, _doctorIDMeta));
    } else if (isInserting) {
      context.missing(_doctorIDMeta);
    }
    if (data.containsKey('techniqal_staff_i_d')) {
      context.handle(
          _techniqalStaffIDMeta,
          techniqalStaffID.isAcceptableOrUnknown(
              data['techniqal_staff_i_d']!, _techniqalStaffIDMeta));
    } else if (isInserting) {
      context.missing(_techniqalStaffIDMeta);
    }
    if (data.containsKey('sale_amount')) {
      context.handle(
          _saleAmountMeta,
          saleAmount.isAcceptableOrUnknown(
              data['sale_amount']!, _saleAmountMeta));
    } else if (isInserting) {
      context.missing(_saleAmountMeta);
    }
    if (data.containsKey('total_sale')) {
      context.handle(_totalSaleMeta,
          totalSale.isAcceptableOrUnknown(data['total_sale']!, _totalSaleMeta));
    } else if (isInserting) {
      context.missing(_totalSaleMeta);
    }
    if (data.containsKey('smt_doc_date')) {
      context.handle(
          _smtDocDateMeta,
          smtDocDate.isAcceptableOrUnknown(
              data['smt_doc_date']!, _smtDocDateMeta));
    } else if (isInserting) {
      context.missing(_smtDocDateMeta);
    }
    if (data.containsKey('smt_doc_no')) {
      context.handle(_smtDocNoMeta,
          smtDocNo.isAcceptableOrUnknown(data['smt_doc_no']!, _smtDocNoMeta));
    } else if (isInserting) {
      context.missing(_smtDocNoMeta);
    }
    if (data.containsKey('smt_inv_no')) {
      context.handle(_smtInvNoMeta,
          smtInvNo.isAcceptableOrUnknown(data['smt_inv_no']!, _smtInvNoMeta));
    } else if (isInserting) {
      context.missing(_smtInvNoMeta);
    }
    if (data.containsKey('purchase_taxable_amount')) {
      context.handle(
          _purchaseTaxableAmountMeta,
          purchaseTaxableAmount.isAcceptableOrUnknown(
              data['purchase_taxable_amount']!, _purchaseTaxableAmountMeta));
    } else if (isInserting) {
      context.missing(_purchaseTaxableAmountMeta);
    }
    if (data.containsKey('total_purchase_amount')) {
      context.handle(
          _totalPurchaseAmountMeta,
          totalPurchaseAmount.isAcceptableOrUnknown(
              data['total_purchase_amount']!, _totalPurchaseAmountMeta));
    } else if (isInserting) {
      context.missing(_totalPurchaseAmountMeta);
    }
    if (data.containsKey('log_id')) {
      context.handle(
          _logIdMeta, logId.isAcceptableOrUnknown(data['log_id']!, _logIdMeta));
    } else if (isInserting) {
      context.missing(_logIdMeta);
    }
    if (data.containsKey('hospital_generate_ledger_id')) {
      context.handle(
          _hospitalGenerateLedgerIdMeta,
          hospitalGenerateLedgerId.isAcceptableOrUnknown(
              data['hospital_generate_ledger_id']!,
              _hospitalGenerateLedgerIdMeta));
    } else if (isInserting) {
      context.missing(_hospitalGenerateLedgerIdMeta);
    }
    if (data.containsKey('hospital_payment_ledger_id')) {
      context.handle(
          _hospitalPaymentLedgerIdMeta,
          hospitalPaymentLedgerId.isAcceptableOrUnknown(
              data['hospital_payment_ledger_id']!,
              _hospitalPaymentLedgerIdMeta));
    } else if (isInserting) {
      context.missing(_hospitalPaymentLedgerIdMeta);
    }
    if (data.containsKey('hospital_comission')) {
      context.handle(
          _hospitalComissionMeta,
          hospitalComission.isAcceptableOrUnknown(
              data['hospital_comission']!, _hospitalComissionMeta));
    } else if (isInserting) {
      context.missing(_hospitalComissionMeta);
    }
    if (data.containsKey('hospital_comission_amount')) {
      context.handle(
          _hospitalComissionAmountMeta,
          hospitalComissionAmount.isAcceptableOrUnknown(
              data['hospital_comission_amount']!,
              _hospitalComissionAmountMeta));
    } else if (isInserting) {
      context.missing(_hospitalComissionAmountMeta);
    }
    if (data.containsKey('hospital_comission_paid_date')) {
      context.handle(
          _hospitalComissionPaidDateMeta,
          hospitalComissionPaidDate.isAcceptableOrUnknown(
              data['hospital_comission_paid_date']!,
              _hospitalComissionPaidDateMeta));
    } else if (isInserting) {
      context.missing(_hospitalComissionPaidDateMeta);
    }
    if (data.containsKey('hospital_adjust_comission_amount')) {
      context.handle(
          _hospitalAdjustComissionAmountMeta,
          hospitalAdjustComissionAmount.isAcceptableOrUnknown(
              data['hospital_adjust_comission_amount']!,
              _hospitalAdjustComissionAmountMeta));
    } else if (isInserting) {
      context.missing(_hospitalAdjustComissionAmountMeta);
    }
    if (data.containsKey('doctor_generate_ledger_id')) {
      context.handle(
          _doctorGenerateLedgerIdMeta,
          doctorGenerateLedgerId.isAcceptableOrUnknown(
              data['doctor_generate_ledger_id']!, _doctorGenerateLedgerIdMeta));
    } else if (isInserting) {
      context.missing(_doctorGenerateLedgerIdMeta);
    }
    if (data.containsKey('doctor_payment_ledger_id')) {
      context.handle(
          _doctorPaymentLedgerIdMeta,
          doctorPaymentLedgerId.isAcceptableOrUnknown(
              data['doctor_payment_ledger_id']!, _doctorPaymentLedgerIdMeta));
    } else if (isInserting) {
      context.missing(_doctorPaymentLedgerIdMeta);
    }
    if (data.containsKey('doctor_comission')) {
      context.handle(
          _doctorComissionMeta,
          doctorComission.isAcceptableOrUnknown(
              data['doctor_comission']!, _doctorComissionMeta));
    } else if (isInserting) {
      context.missing(_doctorComissionMeta);
    }
    if (data.containsKey('doctor_comission_amount')) {
      context.handle(
          _doctorComissionAmountMeta,
          doctorComissionAmount.isAcceptableOrUnknown(
              data['doctor_comission_amount']!, _doctorComissionAmountMeta));
    } else if (isInserting) {
      context.missing(_doctorComissionAmountMeta);
    }
    if (data.containsKey('doctor_comission_paid_date')) {
      context.handle(
          _doctorComissionPaidDateMeta,
          doctorComissionPaidDate.isAcceptableOrUnknown(
              data['doctor_comission_paid_date']!,
              _doctorComissionPaidDateMeta));
    } else if (isInserting) {
      context.missing(_doctorComissionPaidDateMeta);
    }
    if (data.containsKey('doctor_adjust_comission_amount')) {
      context.handle(
          _doctorAdjustComissionAmountMeta,
          doctorAdjustComissionAmount.isAcceptableOrUnknown(
              data['doctor_adjust_comission_amount']!,
              _doctorAdjustComissionAmountMeta));
    } else if (isInserting) {
      context.missing(_doctorAdjustComissionAmountMeta);
    }
    if (data.containsKey('techniqal_staff_generate_ledger_id')) {
      context.handle(
          _techniqalStaffGenerateLedgerIdMeta,
          techniqalStaffGenerateLedgerId.isAcceptableOrUnknown(
              data['techniqal_staff_generate_ledger_id']!,
              _techniqalStaffGenerateLedgerIdMeta));
    } else if (isInserting) {
      context.missing(_techniqalStaffGenerateLedgerIdMeta);
    }
    if (data.containsKey('techniqal_staff_payment_ledger_id')) {
      context.handle(
          _techniqalStaffPaymentLedgerIdMeta,
          techniqalStaffPaymentLedgerId.isAcceptableOrUnknown(
              data['techniqal_staff_payment_ledger_id']!,
              _techniqalStaffPaymentLedgerIdMeta));
    } else if (isInserting) {
      context.missing(_techniqalStaffPaymentLedgerIdMeta);
    }
    if (data.containsKey('techniqal_staff_comission')) {
      context.handle(
          _techniqalStaffComissionMeta,
          techniqalStaffComission.isAcceptableOrUnknown(
              data['techniqal_staff_comission']!,
              _techniqalStaffComissionMeta));
    } else if (isInserting) {
      context.missing(_techniqalStaffComissionMeta);
    }
    if (data.containsKey('techniqal_staff_comission_amount')) {
      context.handle(
          _techniqalStaffComissionAmountMeta,
          techniqalStaffComissionAmount.isAcceptableOrUnknown(
              data['techniqal_staff_comission_amount']!,
              _techniqalStaffComissionAmountMeta));
    } else if (isInserting) {
      context.missing(_techniqalStaffComissionAmountMeta);
    }
    if (data.containsKey('techniqal_staff_comission_paid_date')) {
      context.handle(
          _techniqalStaffComissionPaidDateMeta,
          techniqalStaffComissionPaidDate.isAcceptableOrUnknown(
              data['techniqal_staff_comission_paid_date']!,
              _techniqalStaffComissionPaidDateMeta));
    } else if (isInserting) {
      context.missing(_techniqalStaffComissionPaidDateMeta);
    }
    if (data.containsKey('techniqal_staff_adjust_comission_amount')) {
      context.handle(
          _techniqalStaffAdjustComissionAmountMeta,
          techniqalStaffAdjustComissionAmount.isAcceptableOrUnknown(
              data['techniqal_staff_adjust_comission_amount']!,
              _techniqalStaffAdjustComissionAmountMeta));
    } else if (isInserting) {
      context.missing(_techniqalStaffAdjustComissionAmountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InputDataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InputDataData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      documentType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}document_type'])!,
      distDocDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}dist_doc_date'])!,
      distDocNo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dist_doc_no'])!,
      hospitalID: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hospital_i_d'])!,
      custBillCity: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cust_bill_city'])!,
      matCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mat_code'])!,
      matName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mat_name'])!,
      mtID: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}mt_i_d'])!,
      qty: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}qty'])!,
      doctorID: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}doctor_i_d'])!,
      techniqalStaffID: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}techniqal_staff_i_d'])!,
      saleAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}sale_amount'])!,
      totalSale: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_sale'])!,
      smtDocDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}smt_doc_date'])!,
      smtDocNo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}smt_doc_no'])!,
      smtInvNo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}smt_inv_no'])!,
      purchaseTaxableAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}purchase_taxable_amount'])!,
      totalPurchaseAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}total_purchase_amount'])!,
      logId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}log_id'])!,
      hospitalGenerateLedgerId: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}hospital_generate_ledger_id'])!,
      hospitalPaymentLedgerId: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}hospital_payment_ledger_id'])!,
      hospitalComission: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}hospital_comission'])!,
      hospitalComissionAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}hospital_comission_amount'])!,
      hospitalComissionPaidDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}hospital_comission_paid_date'])!,
      hospitalAdjustComissionAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}hospital_adjust_comission_amount'])!,
      doctorGenerateLedgerId: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}doctor_generate_ledger_id'])!,
      doctorPaymentLedgerId: attachedDatabase.typeMapping.read(DriftSqlType.int,
          data['${effectivePrefix}doctor_payment_ledger_id'])!,
      doctorComission: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}doctor_comission'])!,
      doctorComissionAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}doctor_comission_amount'])!,
      doctorComissionPaidDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}doctor_comission_paid_date'])!,
      doctorAdjustComissionAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}doctor_adjust_comission_amount'])!,
      techniqalStaffGenerateLedgerId: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}techniqal_staff_generate_ledger_id'])!,
      techniqalStaffPaymentLedgerId: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}techniqal_staff_payment_ledger_id'])!,
      techniqalStaffComission: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}techniqal_staff_comission'])!,
      techniqalStaffComissionAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}techniqal_staff_comission_amount'])!,
      techniqalStaffComissionPaidDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}techniqal_staff_comission_paid_date'])!,
      techniqalStaffAdjustComissionAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}techniqal_staff_adjust_comission_amount'])!,
    );
  }

  @override
  $InputDataTable createAlias(String alias) {
    return $InputDataTable(attachedDatabase, alias);
  }
}

class InputDataData extends DataClass implements Insertable<InputDataData> {
  final int id;
  final String documentType;
  final DateTime distDocDate;
  final String distDocNo;
  final int hospitalID;
  final String custBillCity;
  final String matCode;
  final String matName;
  final int mtID;
  final int qty;
  final int doctorID;
  final int techniqalStaffID;
  final double saleAmount;
  final double totalSale;
  final DateTime smtDocDate;
  final String smtDocNo;
  final String smtInvNo;
  final double purchaseTaxableAmount;
  final double totalPurchaseAmount;
  final int logId;
  final int hospitalGenerateLedgerId;
  final int hospitalPaymentLedgerId;
  final double hospitalComission;
  final double hospitalComissionAmount;
  final DateTime hospitalComissionPaidDate;
  final double hospitalAdjustComissionAmount;
  final int doctorGenerateLedgerId;
  final int doctorPaymentLedgerId;
  final double doctorComission;
  final double doctorComissionAmount;
  final DateTime doctorComissionPaidDate;
  final double doctorAdjustComissionAmount;
  final int techniqalStaffGenerateLedgerId;
  final int techniqalStaffPaymentLedgerId;
  final double techniqalStaffComission;
  final double techniqalStaffComissionAmount;
  final DateTime techniqalStaffComissionPaidDate;
  final double techniqalStaffAdjustComissionAmount;
  const InputDataData(
      {required this.id,
      required this.documentType,
      required this.distDocDate,
      required this.distDocNo,
      required this.hospitalID,
      required this.custBillCity,
      required this.matCode,
      required this.matName,
      required this.mtID,
      required this.qty,
      required this.doctorID,
      required this.techniqalStaffID,
      required this.saleAmount,
      required this.totalSale,
      required this.smtDocDate,
      required this.smtDocNo,
      required this.smtInvNo,
      required this.purchaseTaxableAmount,
      required this.totalPurchaseAmount,
      required this.logId,
      required this.hospitalGenerateLedgerId,
      required this.hospitalPaymentLedgerId,
      required this.hospitalComission,
      required this.hospitalComissionAmount,
      required this.hospitalComissionPaidDate,
      required this.hospitalAdjustComissionAmount,
      required this.doctorGenerateLedgerId,
      required this.doctorPaymentLedgerId,
      required this.doctorComission,
      required this.doctorComissionAmount,
      required this.doctorComissionPaidDate,
      required this.doctorAdjustComissionAmount,
      required this.techniqalStaffGenerateLedgerId,
      required this.techniqalStaffPaymentLedgerId,
      required this.techniqalStaffComission,
      required this.techniqalStaffComissionAmount,
      required this.techniqalStaffComissionPaidDate,
      required this.techniqalStaffAdjustComissionAmount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['document_type'] = Variable<String>(documentType);
    map['dist_doc_date'] = Variable<DateTime>(distDocDate);
    map['dist_doc_no'] = Variable<String>(distDocNo);
    map['hospital_i_d'] = Variable<int>(hospitalID);
    map['cust_bill_city'] = Variable<String>(custBillCity);
    map['mat_code'] = Variable<String>(matCode);
    map['mat_name'] = Variable<String>(matName);
    map['mt_i_d'] = Variable<int>(mtID);
    map['qty'] = Variable<int>(qty);
    map['doctor_i_d'] = Variable<int>(doctorID);
    map['techniqal_staff_i_d'] = Variable<int>(techniqalStaffID);
    map['sale_amount'] = Variable<double>(saleAmount);
    map['total_sale'] = Variable<double>(totalSale);
    map['smt_doc_date'] = Variable<DateTime>(smtDocDate);
    map['smt_doc_no'] = Variable<String>(smtDocNo);
    map['smt_inv_no'] = Variable<String>(smtInvNo);
    map['purchase_taxable_amount'] = Variable<double>(purchaseTaxableAmount);
    map['total_purchase_amount'] = Variable<double>(totalPurchaseAmount);
    map['log_id'] = Variable<int>(logId);
    map['hospital_generate_ledger_id'] =
        Variable<int>(hospitalGenerateLedgerId);
    map['hospital_payment_ledger_id'] = Variable<int>(hospitalPaymentLedgerId);
    map['hospital_comission'] = Variable<double>(hospitalComission);
    map['hospital_comission_amount'] =
        Variable<double>(hospitalComissionAmount);
    map['hospital_comission_paid_date'] =
        Variable<DateTime>(hospitalComissionPaidDate);
    map['hospital_adjust_comission_amount'] =
        Variable<double>(hospitalAdjustComissionAmount);
    map['doctor_generate_ledger_id'] = Variable<int>(doctorGenerateLedgerId);
    map['doctor_payment_ledger_id'] = Variable<int>(doctorPaymentLedgerId);
    map['doctor_comission'] = Variable<double>(doctorComission);
    map['doctor_comission_amount'] = Variable<double>(doctorComissionAmount);
    map['doctor_comission_paid_date'] =
        Variable<DateTime>(doctorComissionPaidDate);
    map['doctor_adjust_comission_amount'] =
        Variable<double>(doctorAdjustComissionAmount);
    map['techniqal_staff_generate_ledger_id'] =
        Variable<int>(techniqalStaffGenerateLedgerId);
    map['techniqal_staff_payment_ledger_id'] =
        Variable<int>(techniqalStaffPaymentLedgerId);
    map['techniqal_staff_comission'] =
        Variable<double>(techniqalStaffComission);
    map['techniqal_staff_comission_amount'] =
        Variable<double>(techniqalStaffComissionAmount);
    map['techniqal_staff_comission_paid_date'] =
        Variable<DateTime>(techniqalStaffComissionPaidDate);
    map['techniqal_staff_adjust_comission_amount'] =
        Variable<double>(techniqalStaffAdjustComissionAmount);
    return map;
  }

  InputDataCompanion toCompanion(bool nullToAbsent) {
    return InputDataCompanion(
      id: Value(id),
      documentType: Value(documentType),
      distDocDate: Value(distDocDate),
      distDocNo: Value(distDocNo),
      hospitalID: Value(hospitalID),
      custBillCity: Value(custBillCity),
      matCode: Value(matCode),
      matName: Value(matName),
      mtID: Value(mtID),
      qty: Value(qty),
      doctorID: Value(doctorID),
      techniqalStaffID: Value(techniqalStaffID),
      saleAmount: Value(saleAmount),
      totalSale: Value(totalSale),
      smtDocDate: Value(smtDocDate),
      smtDocNo: Value(smtDocNo),
      smtInvNo: Value(smtInvNo),
      purchaseTaxableAmount: Value(purchaseTaxableAmount),
      totalPurchaseAmount: Value(totalPurchaseAmount),
      logId: Value(logId),
      hospitalGenerateLedgerId: Value(hospitalGenerateLedgerId),
      hospitalPaymentLedgerId: Value(hospitalPaymentLedgerId),
      hospitalComission: Value(hospitalComission),
      hospitalComissionAmount: Value(hospitalComissionAmount),
      hospitalComissionPaidDate: Value(hospitalComissionPaidDate),
      hospitalAdjustComissionAmount: Value(hospitalAdjustComissionAmount),
      doctorGenerateLedgerId: Value(doctorGenerateLedgerId),
      doctorPaymentLedgerId: Value(doctorPaymentLedgerId),
      doctorComission: Value(doctorComission),
      doctorComissionAmount: Value(doctorComissionAmount),
      doctorComissionPaidDate: Value(doctorComissionPaidDate),
      doctorAdjustComissionAmount: Value(doctorAdjustComissionAmount),
      techniqalStaffGenerateLedgerId: Value(techniqalStaffGenerateLedgerId),
      techniqalStaffPaymentLedgerId: Value(techniqalStaffPaymentLedgerId),
      techniqalStaffComission: Value(techniqalStaffComission),
      techniqalStaffComissionAmount: Value(techniqalStaffComissionAmount),
      techniqalStaffComissionPaidDate: Value(techniqalStaffComissionPaidDate),
      techniqalStaffAdjustComissionAmount:
          Value(techniqalStaffAdjustComissionAmount),
    );
  }

  factory InputDataData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InputDataData(
      id: serializer.fromJson<int>(json['id']),
      documentType: serializer.fromJson<String>(json['documentType']),
      distDocDate: serializer.fromJson<DateTime>(json['distDocDate']),
      distDocNo: serializer.fromJson<String>(json['distDocNo']),
      hospitalID: serializer.fromJson<int>(json['hospitalID']),
      custBillCity: serializer.fromJson<String>(json['custBillCity']),
      matCode: serializer.fromJson<String>(json['matCode']),
      matName: serializer.fromJson<String>(json['matName']),
      mtID: serializer.fromJson<int>(json['mtID']),
      qty: serializer.fromJson<int>(json['qty']),
      doctorID: serializer.fromJson<int>(json['doctorID']),
      techniqalStaffID: serializer.fromJson<int>(json['techniqalStaffID']),
      saleAmount: serializer.fromJson<double>(json['saleAmount']),
      totalSale: serializer.fromJson<double>(json['totalSale']),
      smtDocDate: serializer.fromJson<DateTime>(json['smtDocDate']),
      smtDocNo: serializer.fromJson<String>(json['smtDocNo']),
      smtInvNo: serializer.fromJson<String>(json['smtInvNo']),
      purchaseTaxableAmount:
          serializer.fromJson<double>(json['purchaseTaxableAmount']),
      totalPurchaseAmount:
          serializer.fromJson<double>(json['totalPurchaseAmount']),
      logId: serializer.fromJson<int>(json['logId']),
      hospitalGenerateLedgerId:
          serializer.fromJson<int>(json['hospitalGenerateLedgerId']),
      hospitalPaymentLedgerId:
          serializer.fromJson<int>(json['hospitalPaymentLedgerId']),
      hospitalComission: serializer.fromJson<double>(json['hospitalComission']),
      hospitalComissionAmount:
          serializer.fromJson<double>(json['hospitalComissionAmount']),
      hospitalComissionPaidDate:
          serializer.fromJson<DateTime>(json['hospitalComissionPaidDate']),
      hospitalAdjustComissionAmount:
          serializer.fromJson<double>(json['hospitalAdjustComissionAmount']),
      doctorGenerateLedgerId:
          serializer.fromJson<int>(json['doctorGenerateLedgerId']),
      doctorPaymentLedgerId:
          serializer.fromJson<int>(json['doctorPaymentLedgerId']),
      doctorComission: serializer.fromJson<double>(json['doctorComission']),
      doctorComissionAmount:
          serializer.fromJson<double>(json['doctorComissionAmount']),
      doctorComissionPaidDate:
          serializer.fromJson<DateTime>(json['doctorComissionPaidDate']),
      doctorAdjustComissionAmount:
          serializer.fromJson<double>(json['doctorAdjustComissionAmount']),
      techniqalStaffGenerateLedgerId:
          serializer.fromJson<int>(json['techniqalStaffGenerateLedgerId']),
      techniqalStaffPaymentLedgerId:
          serializer.fromJson<int>(json['techniqalStaffPaymentLedgerId']),
      techniqalStaffComission:
          serializer.fromJson<double>(json['techniqalStaffComission']),
      techniqalStaffComissionAmount:
          serializer.fromJson<double>(json['techniqalStaffComissionAmount']),
      techniqalStaffComissionPaidDate: serializer
          .fromJson<DateTime>(json['techniqalStaffComissionPaidDate']),
      techniqalStaffAdjustComissionAmount: serializer
          .fromJson<double>(json['techniqalStaffAdjustComissionAmount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'documentType': serializer.toJson<String>(documentType),
      'distDocDate': serializer.toJson<DateTime>(distDocDate),
      'distDocNo': serializer.toJson<String>(distDocNo),
      'hospitalID': serializer.toJson<int>(hospitalID),
      'custBillCity': serializer.toJson<String>(custBillCity),
      'matCode': serializer.toJson<String>(matCode),
      'matName': serializer.toJson<String>(matName),
      'mtID': serializer.toJson<int>(mtID),
      'qty': serializer.toJson<int>(qty),
      'doctorID': serializer.toJson<int>(doctorID),
      'techniqalStaffID': serializer.toJson<int>(techniqalStaffID),
      'saleAmount': serializer.toJson<double>(saleAmount),
      'totalSale': serializer.toJson<double>(totalSale),
      'smtDocDate': serializer.toJson<DateTime>(smtDocDate),
      'smtDocNo': serializer.toJson<String>(smtDocNo),
      'smtInvNo': serializer.toJson<String>(smtInvNo),
      'purchaseTaxableAmount': serializer.toJson<double>(purchaseTaxableAmount),
      'totalPurchaseAmount': serializer.toJson<double>(totalPurchaseAmount),
      'logId': serializer.toJson<int>(logId),
      'hospitalGenerateLedgerId':
          serializer.toJson<int>(hospitalGenerateLedgerId),
      'hospitalPaymentLedgerId':
          serializer.toJson<int>(hospitalPaymentLedgerId),
      'hospitalComission': serializer.toJson<double>(hospitalComission),
      'hospitalComissionAmount':
          serializer.toJson<double>(hospitalComissionAmount),
      'hospitalComissionPaidDate':
          serializer.toJson<DateTime>(hospitalComissionPaidDate),
      'hospitalAdjustComissionAmount':
          serializer.toJson<double>(hospitalAdjustComissionAmount),
      'doctorGenerateLedgerId': serializer.toJson<int>(doctorGenerateLedgerId),
      'doctorPaymentLedgerId': serializer.toJson<int>(doctorPaymentLedgerId),
      'doctorComission': serializer.toJson<double>(doctorComission),
      'doctorComissionAmount': serializer.toJson<double>(doctorComissionAmount),
      'doctorComissionPaidDate':
          serializer.toJson<DateTime>(doctorComissionPaidDate),
      'doctorAdjustComissionAmount':
          serializer.toJson<double>(doctorAdjustComissionAmount),
      'techniqalStaffGenerateLedgerId':
          serializer.toJson<int>(techniqalStaffGenerateLedgerId),
      'techniqalStaffPaymentLedgerId':
          serializer.toJson<int>(techniqalStaffPaymentLedgerId),
      'techniqalStaffComission':
          serializer.toJson<double>(techniqalStaffComission),
      'techniqalStaffComissionAmount':
          serializer.toJson<double>(techniqalStaffComissionAmount),
      'techniqalStaffComissionPaidDate':
          serializer.toJson<DateTime>(techniqalStaffComissionPaidDate),
      'techniqalStaffAdjustComissionAmount':
          serializer.toJson<double>(techniqalStaffAdjustComissionAmount),
    };
  }

  InputDataData copyWith(
          {int? id,
          String? documentType,
          DateTime? distDocDate,
          String? distDocNo,
          int? hospitalID,
          String? custBillCity,
          String? matCode,
          String? matName,
          int? mtID,
          int? qty,
          int? doctorID,
          int? techniqalStaffID,
          double? saleAmount,
          double? totalSale,
          DateTime? smtDocDate,
          String? smtDocNo,
          String? smtInvNo,
          double? purchaseTaxableAmount,
          double? totalPurchaseAmount,
          int? logId,
          int? hospitalGenerateLedgerId,
          int? hospitalPaymentLedgerId,
          double? hospitalComission,
          double? hospitalComissionAmount,
          DateTime? hospitalComissionPaidDate,
          double? hospitalAdjustComissionAmount,
          int? doctorGenerateLedgerId,
          int? doctorPaymentLedgerId,
          double? doctorComission,
          double? doctorComissionAmount,
          DateTime? doctorComissionPaidDate,
          double? doctorAdjustComissionAmount,
          int? techniqalStaffGenerateLedgerId,
          int? techniqalStaffPaymentLedgerId,
          double? techniqalStaffComission,
          double? techniqalStaffComissionAmount,
          DateTime? techniqalStaffComissionPaidDate,
          double? techniqalStaffAdjustComissionAmount}) =>
      InputDataData(
        id: id ?? this.id,
        documentType: documentType ?? this.documentType,
        distDocDate: distDocDate ?? this.distDocDate,
        distDocNo: distDocNo ?? this.distDocNo,
        hospitalID: hospitalID ?? this.hospitalID,
        custBillCity: custBillCity ?? this.custBillCity,
        matCode: matCode ?? this.matCode,
        matName: matName ?? this.matName,
        mtID: mtID ?? this.mtID,
        qty: qty ?? this.qty,
        doctorID: doctorID ?? this.doctorID,
        techniqalStaffID: techniqalStaffID ?? this.techniqalStaffID,
        saleAmount: saleAmount ?? this.saleAmount,
        totalSale: totalSale ?? this.totalSale,
        smtDocDate: smtDocDate ?? this.smtDocDate,
        smtDocNo: smtDocNo ?? this.smtDocNo,
        smtInvNo: smtInvNo ?? this.smtInvNo,
        purchaseTaxableAmount:
            purchaseTaxableAmount ?? this.purchaseTaxableAmount,
        totalPurchaseAmount: totalPurchaseAmount ?? this.totalPurchaseAmount,
        logId: logId ?? this.logId,
        hospitalGenerateLedgerId:
            hospitalGenerateLedgerId ?? this.hospitalGenerateLedgerId,
        hospitalPaymentLedgerId:
            hospitalPaymentLedgerId ?? this.hospitalPaymentLedgerId,
        hospitalComission: hospitalComission ?? this.hospitalComission,
        hospitalComissionAmount:
            hospitalComissionAmount ?? this.hospitalComissionAmount,
        hospitalComissionPaidDate:
            hospitalComissionPaidDate ?? this.hospitalComissionPaidDate,
        hospitalAdjustComissionAmount:
            hospitalAdjustComissionAmount ?? this.hospitalAdjustComissionAmount,
        doctorGenerateLedgerId:
            doctorGenerateLedgerId ?? this.doctorGenerateLedgerId,
        doctorPaymentLedgerId:
            doctorPaymentLedgerId ?? this.doctorPaymentLedgerId,
        doctorComission: doctorComission ?? this.doctorComission,
        doctorComissionAmount:
            doctorComissionAmount ?? this.doctorComissionAmount,
        doctorComissionPaidDate:
            doctorComissionPaidDate ?? this.doctorComissionPaidDate,
        doctorAdjustComissionAmount:
            doctorAdjustComissionAmount ?? this.doctorAdjustComissionAmount,
        techniqalStaffGenerateLedgerId: techniqalStaffGenerateLedgerId ??
            this.techniqalStaffGenerateLedgerId,
        techniqalStaffPaymentLedgerId:
            techniqalStaffPaymentLedgerId ?? this.techniqalStaffPaymentLedgerId,
        techniqalStaffComission:
            techniqalStaffComission ?? this.techniqalStaffComission,
        techniqalStaffComissionAmount:
            techniqalStaffComissionAmount ?? this.techniqalStaffComissionAmount,
        techniqalStaffComissionPaidDate: techniqalStaffComissionPaidDate ??
            this.techniqalStaffComissionPaidDate,
        techniqalStaffAdjustComissionAmount:
            techniqalStaffAdjustComissionAmount ??
                this.techniqalStaffAdjustComissionAmount,
      );
  @override
  String toString() {
    return (StringBuffer('InputDataData(')
          ..write('id: $id, ')
          ..write('documentType: $documentType, ')
          ..write('distDocDate: $distDocDate, ')
          ..write('distDocNo: $distDocNo, ')
          ..write('hospitalID: $hospitalID, ')
          ..write('custBillCity: $custBillCity, ')
          ..write('matCode: $matCode, ')
          ..write('matName: $matName, ')
          ..write('mtID: $mtID, ')
          ..write('qty: $qty, ')
          ..write('doctorID: $doctorID, ')
          ..write('techniqalStaffID: $techniqalStaffID, ')
          ..write('saleAmount: $saleAmount, ')
          ..write('totalSale: $totalSale, ')
          ..write('smtDocDate: $smtDocDate, ')
          ..write('smtDocNo: $smtDocNo, ')
          ..write('smtInvNo: $smtInvNo, ')
          ..write('purchaseTaxableAmount: $purchaseTaxableAmount, ')
          ..write('totalPurchaseAmount: $totalPurchaseAmount, ')
          ..write('logId: $logId, ')
          ..write('hospitalGenerateLedgerId: $hospitalGenerateLedgerId, ')
          ..write('hospitalPaymentLedgerId: $hospitalPaymentLedgerId, ')
          ..write('hospitalComission: $hospitalComission, ')
          ..write('hospitalComissionAmount: $hospitalComissionAmount, ')
          ..write('hospitalComissionPaidDate: $hospitalComissionPaidDate, ')
          ..write(
              'hospitalAdjustComissionAmount: $hospitalAdjustComissionAmount, ')
          ..write('doctorGenerateLedgerId: $doctorGenerateLedgerId, ')
          ..write('doctorPaymentLedgerId: $doctorPaymentLedgerId, ')
          ..write('doctorComission: $doctorComission, ')
          ..write('doctorComissionAmount: $doctorComissionAmount, ')
          ..write('doctorComissionPaidDate: $doctorComissionPaidDate, ')
          ..write('doctorAdjustComissionAmount: $doctorAdjustComissionAmount, ')
          ..write(
              'techniqalStaffGenerateLedgerId: $techniqalStaffGenerateLedgerId, ')
          ..write(
              'techniqalStaffPaymentLedgerId: $techniqalStaffPaymentLedgerId, ')
          ..write('techniqalStaffComission: $techniqalStaffComission, ')
          ..write(
              'techniqalStaffComissionAmount: $techniqalStaffComissionAmount, ')
          ..write(
              'techniqalStaffComissionPaidDate: $techniqalStaffComissionPaidDate, ')
          ..write(
              'techniqalStaffAdjustComissionAmount: $techniqalStaffAdjustComissionAmount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        documentType,
        distDocDate,
        distDocNo,
        hospitalID,
        custBillCity,
        matCode,
        matName,
        mtID,
        qty,
        doctorID,
        techniqalStaffID,
        saleAmount,
        totalSale,
        smtDocDate,
        smtDocNo,
        smtInvNo,
        purchaseTaxableAmount,
        totalPurchaseAmount,
        logId,
        hospitalGenerateLedgerId,
        hospitalPaymentLedgerId,
        hospitalComission,
        hospitalComissionAmount,
        hospitalComissionPaidDate,
        hospitalAdjustComissionAmount,
        doctorGenerateLedgerId,
        doctorPaymentLedgerId,
        doctorComission,
        doctorComissionAmount,
        doctorComissionPaidDate,
        doctorAdjustComissionAmount,
        techniqalStaffGenerateLedgerId,
        techniqalStaffPaymentLedgerId,
        techniqalStaffComission,
        techniqalStaffComissionAmount,
        techniqalStaffComissionPaidDate,
        techniqalStaffAdjustComissionAmount
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InputDataData &&
          other.id == this.id &&
          other.documentType == this.documentType &&
          other.distDocDate == this.distDocDate &&
          other.distDocNo == this.distDocNo &&
          other.hospitalID == this.hospitalID &&
          other.custBillCity == this.custBillCity &&
          other.matCode == this.matCode &&
          other.matName == this.matName &&
          other.mtID == this.mtID &&
          other.qty == this.qty &&
          other.doctorID == this.doctorID &&
          other.techniqalStaffID == this.techniqalStaffID &&
          other.saleAmount == this.saleAmount &&
          other.totalSale == this.totalSale &&
          other.smtDocDate == this.smtDocDate &&
          other.smtDocNo == this.smtDocNo &&
          other.smtInvNo == this.smtInvNo &&
          other.purchaseTaxableAmount == this.purchaseTaxableAmount &&
          other.totalPurchaseAmount == this.totalPurchaseAmount &&
          other.logId == this.logId &&
          other.hospitalGenerateLedgerId == this.hospitalGenerateLedgerId &&
          other.hospitalPaymentLedgerId == this.hospitalPaymentLedgerId &&
          other.hospitalComission == this.hospitalComission &&
          other.hospitalComissionAmount == this.hospitalComissionAmount &&
          other.hospitalComissionPaidDate == this.hospitalComissionPaidDate &&
          other.hospitalAdjustComissionAmount ==
              this.hospitalAdjustComissionAmount &&
          other.doctorGenerateLedgerId == this.doctorGenerateLedgerId &&
          other.doctorPaymentLedgerId == this.doctorPaymentLedgerId &&
          other.doctorComission == this.doctorComission &&
          other.doctorComissionAmount == this.doctorComissionAmount &&
          other.doctorComissionPaidDate == this.doctorComissionPaidDate &&
          other.doctorAdjustComissionAmount ==
              this.doctorAdjustComissionAmount &&
          other.techniqalStaffGenerateLedgerId ==
              this.techniqalStaffGenerateLedgerId &&
          other.techniqalStaffPaymentLedgerId ==
              this.techniqalStaffPaymentLedgerId &&
          other.techniqalStaffComission == this.techniqalStaffComission &&
          other.techniqalStaffComissionAmount ==
              this.techniqalStaffComissionAmount &&
          other.techniqalStaffComissionPaidDate ==
              this.techniqalStaffComissionPaidDate &&
          other.techniqalStaffAdjustComissionAmount ==
              this.techniqalStaffAdjustComissionAmount);
}

class InputDataCompanion extends UpdateCompanion<InputDataData> {
  final Value<int> id;
  final Value<String> documentType;
  final Value<DateTime> distDocDate;
  final Value<String> distDocNo;
  final Value<int> hospitalID;
  final Value<String> custBillCity;
  final Value<String> matCode;
  final Value<String> matName;
  final Value<int> mtID;
  final Value<int> qty;
  final Value<int> doctorID;
  final Value<int> techniqalStaffID;
  final Value<double> saleAmount;
  final Value<double> totalSale;
  final Value<DateTime> smtDocDate;
  final Value<String> smtDocNo;
  final Value<String> smtInvNo;
  final Value<double> purchaseTaxableAmount;
  final Value<double> totalPurchaseAmount;
  final Value<int> logId;
  final Value<int> hospitalGenerateLedgerId;
  final Value<int> hospitalPaymentLedgerId;
  final Value<double> hospitalComission;
  final Value<double> hospitalComissionAmount;
  final Value<DateTime> hospitalComissionPaidDate;
  final Value<double> hospitalAdjustComissionAmount;
  final Value<int> doctorGenerateLedgerId;
  final Value<int> doctorPaymentLedgerId;
  final Value<double> doctorComission;
  final Value<double> doctorComissionAmount;
  final Value<DateTime> doctorComissionPaidDate;
  final Value<double> doctorAdjustComissionAmount;
  final Value<int> techniqalStaffGenerateLedgerId;
  final Value<int> techniqalStaffPaymentLedgerId;
  final Value<double> techniqalStaffComission;
  final Value<double> techniqalStaffComissionAmount;
  final Value<DateTime> techniqalStaffComissionPaidDate;
  final Value<double> techniqalStaffAdjustComissionAmount;
  const InputDataCompanion({
    this.id = const Value.absent(),
    this.documentType = const Value.absent(),
    this.distDocDate = const Value.absent(),
    this.distDocNo = const Value.absent(),
    this.hospitalID = const Value.absent(),
    this.custBillCity = const Value.absent(),
    this.matCode = const Value.absent(),
    this.matName = const Value.absent(),
    this.mtID = const Value.absent(),
    this.qty = const Value.absent(),
    this.doctorID = const Value.absent(),
    this.techniqalStaffID = const Value.absent(),
    this.saleAmount = const Value.absent(),
    this.totalSale = const Value.absent(),
    this.smtDocDate = const Value.absent(),
    this.smtDocNo = const Value.absent(),
    this.smtInvNo = const Value.absent(),
    this.purchaseTaxableAmount = const Value.absent(),
    this.totalPurchaseAmount = const Value.absent(),
    this.logId = const Value.absent(),
    this.hospitalGenerateLedgerId = const Value.absent(),
    this.hospitalPaymentLedgerId = const Value.absent(),
    this.hospitalComission = const Value.absent(),
    this.hospitalComissionAmount = const Value.absent(),
    this.hospitalComissionPaidDate = const Value.absent(),
    this.hospitalAdjustComissionAmount = const Value.absent(),
    this.doctorGenerateLedgerId = const Value.absent(),
    this.doctorPaymentLedgerId = const Value.absent(),
    this.doctorComission = const Value.absent(),
    this.doctorComissionAmount = const Value.absent(),
    this.doctorComissionPaidDate = const Value.absent(),
    this.doctorAdjustComissionAmount = const Value.absent(),
    this.techniqalStaffGenerateLedgerId = const Value.absent(),
    this.techniqalStaffPaymentLedgerId = const Value.absent(),
    this.techniqalStaffComission = const Value.absent(),
    this.techniqalStaffComissionAmount = const Value.absent(),
    this.techniqalStaffComissionPaidDate = const Value.absent(),
    this.techniqalStaffAdjustComissionAmount = const Value.absent(),
  });
  InputDataCompanion.insert({
    this.id = const Value.absent(),
    required String documentType,
    required DateTime distDocDate,
    required String distDocNo,
    required int hospitalID,
    required String custBillCity,
    required String matCode,
    required String matName,
    required int mtID,
    required int qty,
    required int doctorID,
    required int techniqalStaffID,
    required double saleAmount,
    required double totalSale,
    required DateTime smtDocDate,
    required String smtDocNo,
    required String smtInvNo,
    required double purchaseTaxableAmount,
    required double totalPurchaseAmount,
    required int logId,
    required int hospitalGenerateLedgerId,
    required int hospitalPaymentLedgerId,
    required double hospitalComission,
    required double hospitalComissionAmount,
    required DateTime hospitalComissionPaidDate,
    required double hospitalAdjustComissionAmount,
    required int doctorGenerateLedgerId,
    required int doctorPaymentLedgerId,
    required double doctorComission,
    required double doctorComissionAmount,
    required DateTime doctorComissionPaidDate,
    required double doctorAdjustComissionAmount,
    required int techniqalStaffGenerateLedgerId,
    required int techniqalStaffPaymentLedgerId,
    required double techniqalStaffComission,
    required double techniqalStaffComissionAmount,
    required DateTime techniqalStaffComissionPaidDate,
    required double techniqalStaffAdjustComissionAmount,
  })  : documentType = Value(documentType),
        distDocDate = Value(distDocDate),
        distDocNo = Value(distDocNo),
        hospitalID = Value(hospitalID),
        custBillCity = Value(custBillCity),
        matCode = Value(matCode),
        matName = Value(matName),
        mtID = Value(mtID),
        qty = Value(qty),
        doctorID = Value(doctorID),
        techniqalStaffID = Value(techniqalStaffID),
        saleAmount = Value(saleAmount),
        totalSale = Value(totalSale),
        smtDocDate = Value(smtDocDate),
        smtDocNo = Value(smtDocNo),
        smtInvNo = Value(smtInvNo),
        purchaseTaxableAmount = Value(purchaseTaxableAmount),
        totalPurchaseAmount = Value(totalPurchaseAmount),
        logId = Value(logId),
        hospitalGenerateLedgerId = Value(hospitalGenerateLedgerId),
        hospitalPaymentLedgerId = Value(hospitalPaymentLedgerId),
        hospitalComission = Value(hospitalComission),
        hospitalComissionAmount = Value(hospitalComissionAmount),
        hospitalComissionPaidDate = Value(hospitalComissionPaidDate),
        hospitalAdjustComissionAmount = Value(hospitalAdjustComissionAmount),
        doctorGenerateLedgerId = Value(doctorGenerateLedgerId),
        doctorPaymentLedgerId = Value(doctorPaymentLedgerId),
        doctorComission = Value(doctorComission),
        doctorComissionAmount = Value(doctorComissionAmount),
        doctorComissionPaidDate = Value(doctorComissionPaidDate),
        doctorAdjustComissionAmount = Value(doctorAdjustComissionAmount),
        techniqalStaffGenerateLedgerId = Value(techniqalStaffGenerateLedgerId),
        techniqalStaffPaymentLedgerId = Value(techniqalStaffPaymentLedgerId),
        techniqalStaffComission = Value(techniqalStaffComission),
        techniqalStaffComissionAmount = Value(techniqalStaffComissionAmount),
        techniqalStaffComissionPaidDate =
            Value(techniqalStaffComissionPaidDate),
        techniqalStaffAdjustComissionAmount =
            Value(techniqalStaffAdjustComissionAmount);
  static Insertable<InputDataData> custom({
    Expression<int>? id,
    Expression<String>? documentType,
    Expression<DateTime>? distDocDate,
    Expression<String>? distDocNo,
    Expression<int>? hospitalID,
    Expression<String>? custBillCity,
    Expression<String>? matCode,
    Expression<String>? matName,
    Expression<int>? mtID,
    Expression<int>? qty,
    Expression<int>? doctorID,
    Expression<int>? techniqalStaffID,
    Expression<double>? saleAmount,
    Expression<double>? totalSale,
    Expression<DateTime>? smtDocDate,
    Expression<String>? smtDocNo,
    Expression<String>? smtInvNo,
    Expression<double>? purchaseTaxableAmount,
    Expression<double>? totalPurchaseAmount,
    Expression<int>? logId,
    Expression<int>? hospitalGenerateLedgerId,
    Expression<int>? hospitalPaymentLedgerId,
    Expression<double>? hospitalComission,
    Expression<double>? hospitalComissionAmount,
    Expression<DateTime>? hospitalComissionPaidDate,
    Expression<double>? hospitalAdjustComissionAmount,
    Expression<int>? doctorGenerateLedgerId,
    Expression<int>? doctorPaymentLedgerId,
    Expression<double>? doctorComission,
    Expression<double>? doctorComissionAmount,
    Expression<DateTime>? doctorComissionPaidDate,
    Expression<double>? doctorAdjustComissionAmount,
    Expression<int>? techniqalStaffGenerateLedgerId,
    Expression<int>? techniqalStaffPaymentLedgerId,
    Expression<double>? techniqalStaffComission,
    Expression<double>? techniqalStaffComissionAmount,
    Expression<DateTime>? techniqalStaffComissionPaidDate,
    Expression<double>? techniqalStaffAdjustComissionAmount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (documentType != null) 'document_type': documentType,
      if (distDocDate != null) 'dist_doc_date': distDocDate,
      if (distDocNo != null) 'dist_doc_no': distDocNo,
      if (hospitalID != null) 'hospital_i_d': hospitalID,
      if (custBillCity != null) 'cust_bill_city': custBillCity,
      if (matCode != null) 'mat_code': matCode,
      if (matName != null) 'mat_name': matName,
      if (mtID != null) 'mt_i_d': mtID,
      if (qty != null) 'qty': qty,
      if (doctorID != null) 'doctor_i_d': doctorID,
      if (techniqalStaffID != null) 'techniqal_staff_i_d': techniqalStaffID,
      if (saleAmount != null) 'sale_amount': saleAmount,
      if (totalSale != null) 'total_sale': totalSale,
      if (smtDocDate != null) 'smt_doc_date': smtDocDate,
      if (smtDocNo != null) 'smt_doc_no': smtDocNo,
      if (smtInvNo != null) 'smt_inv_no': smtInvNo,
      if (purchaseTaxableAmount != null)
        'purchase_taxable_amount': purchaseTaxableAmount,
      if (totalPurchaseAmount != null)
        'total_purchase_amount': totalPurchaseAmount,
      if (logId != null) 'log_id': logId,
      if (hospitalGenerateLedgerId != null)
        'hospital_generate_ledger_id': hospitalGenerateLedgerId,
      if (hospitalPaymentLedgerId != null)
        'hospital_payment_ledger_id': hospitalPaymentLedgerId,
      if (hospitalComission != null) 'hospital_comission': hospitalComission,
      if (hospitalComissionAmount != null)
        'hospital_comission_amount': hospitalComissionAmount,
      if (hospitalComissionPaidDate != null)
        'hospital_comission_paid_date': hospitalComissionPaidDate,
      if (hospitalAdjustComissionAmount != null)
        'hospital_adjust_comission_amount': hospitalAdjustComissionAmount,
      if (doctorGenerateLedgerId != null)
        'doctor_generate_ledger_id': doctorGenerateLedgerId,
      if (doctorPaymentLedgerId != null)
        'doctor_payment_ledger_id': doctorPaymentLedgerId,
      if (doctorComission != null) 'doctor_comission': doctorComission,
      if (doctorComissionAmount != null)
        'doctor_comission_amount': doctorComissionAmount,
      if (doctorComissionPaidDate != null)
        'doctor_comission_paid_date': doctorComissionPaidDate,
      if (doctorAdjustComissionAmount != null)
        'doctor_adjust_comission_amount': doctorAdjustComissionAmount,
      if (techniqalStaffGenerateLedgerId != null)
        'techniqal_staff_generate_ledger_id': techniqalStaffGenerateLedgerId,
      if (techniqalStaffPaymentLedgerId != null)
        'techniqal_staff_payment_ledger_id': techniqalStaffPaymentLedgerId,
      if (techniqalStaffComission != null)
        'techniqal_staff_comission': techniqalStaffComission,
      if (techniqalStaffComissionAmount != null)
        'techniqal_staff_comission_amount': techniqalStaffComissionAmount,
      if (techniqalStaffComissionPaidDate != null)
        'techniqal_staff_comission_paid_date': techniqalStaffComissionPaidDate,
      if (techniqalStaffAdjustComissionAmount != null)
        'techniqal_staff_adjust_comission_amount':
            techniqalStaffAdjustComissionAmount,
    });
  }

  InputDataCompanion copyWith(
      {Value<int>? id,
      Value<String>? documentType,
      Value<DateTime>? distDocDate,
      Value<String>? distDocNo,
      Value<int>? hospitalID,
      Value<String>? custBillCity,
      Value<String>? matCode,
      Value<String>? matName,
      Value<int>? mtID,
      Value<int>? qty,
      Value<int>? doctorID,
      Value<int>? techniqalStaffID,
      Value<double>? saleAmount,
      Value<double>? totalSale,
      Value<DateTime>? smtDocDate,
      Value<String>? smtDocNo,
      Value<String>? smtInvNo,
      Value<double>? purchaseTaxableAmount,
      Value<double>? totalPurchaseAmount,
      Value<int>? logId,
      Value<int>? hospitalGenerateLedgerId,
      Value<int>? hospitalPaymentLedgerId,
      Value<double>? hospitalComission,
      Value<double>? hospitalComissionAmount,
      Value<DateTime>? hospitalComissionPaidDate,
      Value<double>? hospitalAdjustComissionAmount,
      Value<int>? doctorGenerateLedgerId,
      Value<int>? doctorPaymentLedgerId,
      Value<double>? doctorComission,
      Value<double>? doctorComissionAmount,
      Value<DateTime>? doctorComissionPaidDate,
      Value<double>? doctorAdjustComissionAmount,
      Value<int>? techniqalStaffGenerateLedgerId,
      Value<int>? techniqalStaffPaymentLedgerId,
      Value<double>? techniqalStaffComission,
      Value<double>? techniqalStaffComissionAmount,
      Value<DateTime>? techniqalStaffComissionPaidDate,
      Value<double>? techniqalStaffAdjustComissionAmount}) {
    return InputDataCompanion(
      id: id ?? this.id,
      documentType: documentType ?? this.documentType,
      distDocDate: distDocDate ?? this.distDocDate,
      distDocNo: distDocNo ?? this.distDocNo,
      hospitalID: hospitalID ?? this.hospitalID,
      custBillCity: custBillCity ?? this.custBillCity,
      matCode: matCode ?? this.matCode,
      matName: matName ?? this.matName,
      mtID: mtID ?? this.mtID,
      qty: qty ?? this.qty,
      doctorID: doctorID ?? this.doctorID,
      techniqalStaffID: techniqalStaffID ?? this.techniqalStaffID,
      saleAmount: saleAmount ?? this.saleAmount,
      totalSale: totalSale ?? this.totalSale,
      smtDocDate: smtDocDate ?? this.smtDocDate,
      smtDocNo: smtDocNo ?? this.smtDocNo,
      smtInvNo: smtInvNo ?? this.smtInvNo,
      purchaseTaxableAmount:
          purchaseTaxableAmount ?? this.purchaseTaxableAmount,
      totalPurchaseAmount: totalPurchaseAmount ?? this.totalPurchaseAmount,
      logId: logId ?? this.logId,
      hospitalGenerateLedgerId:
          hospitalGenerateLedgerId ?? this.hospitalGenerateLedgerId,
      hospitalPaymentLedgerId:
          hospitalPaymentLedgerId ?? this.hospitalPaymentLedgerId,
      hospitalComission: hospitalComission ?? this.hospitalComission,
      hospitalComissionAmount:
          hospitalComissionAmount ?? this.hospitalComissionAmount,
      hospitalComissionPaidDate:
          hospitalComissionPaidDate ?? this.hospitalComissionPaidDate,
      hospitalAdjustComissionAmount:
          hospitalAdjustComissionAmount ?? this.hospitalAdjustComissionAmount,
      doctorGenerateLedgerId:
          doctorGenerateLedgerId ?? this.doctorGenerateLedgerId,
      doctorPaymentLedgerId:
          doctorPaymentLedgerId ?? this.doctorPaymentLedgerId,
      doctorComission: doctorComission ?? this.doctorComission,
      doctorComissionAmount:
          doctorComissionAmount ?? this.doctorComissionAmount,
      doctorComissionPaidDate:
          doctorComissionPaidDate ?? this.doctorComissionPaidDate,
      doctorAdjustComissionAmount:
          doctorAdjustComissionAmount ?? this.doctorAdjustComissionAmount,
      techniqalStaffGenerateLedgerId:
          techniqalStaffGenerateLedgerId ?? this.techniqalStaffGenerateLedgerId,
      techniqalStaffPaymentLedgerId:
          techniqalStaffPaymentLedgerId ?? this.techniqalStaffPaymentLedgerId,
      techniqalStaffComission:
          techniqalStaffComission ?? this.techniqalStaffComission,
      techniqalStaffComissionAmount:
          techniqalStaffComissionAmount ?? this.techniqalStaffComissionAmount,
      techniqalStaffComissionPaidDate: techniqalStaffComissionPaidDate ??
          this.techniqalStaffComissionPaidDate,
      techniqalStaffAdjustComissionAmount:
          techniqalStaffAdjustComissionAmount ??
              this.techniqalStaffAdjustComissionAmount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (documentType.present) {
      map['document_type'] = Variable<String>(documentType.value);
    }
    if (distDocDate.present) {
      map['dist_doc_date'] = Variable<DateTime>(distDocDate.value);
    }
    if (distDocNo.present) {
      map['dist_doc_no'] = Variable<String>(distDocNo.value);
    }
    if (hospitalID.present) {
      map['hospital_i_d'] = Variable<int>(hospitalID.value);
    }
    if (custBillCity.present) {
      map['cust_bill_city'] = Variable<String>(custBillCity.value);
    }
    if (matCode.present) {
      map['mat_code'] = Variable<String>(matCode.value);
    }
    if (matName.present) {
      map['mat_name'] = Variable<String>(matName.value);
    }
    if (mtID.present) {
      map['mt_i_d'] = Variable<int>(mtID.value);
    }
    if (qty.present) {
      map['qty'] = Variable<int>(qty.value);
    }
    if (doctorID.present) {
      map['doctor_i_d'] = Variable<int>(doctorID.value);
    }
    if (techniqalStaffID.present) {
      map['techniqal_staff_i_d'] = Variable<int>(techniqalStaffID.value);
    }
    if (saleAmount.present) {
      map['sale_amount'] = Variable<double>(saleAmount.value);
    }
    if (totalSale.present) {
      map['total_sale'] = Variable<double>(totalSale.value);
    }
    if (smtDocDate.present) {
      map['smt_doc_date'] = Variable<DateTime>(smtDocDate.value);
    }
    if (smtDocNo.present) {
      map['smt_doc_no'] = Variable<String>(smtDocNo.value);
    }
    if (smtInvNo.present) {
      map['smt_inv_no'] = Variable<String>(smtInvNo.value);
    }
    if (purchaseTaxableAmount.present) {
      map['purchase_taxable_amount'] =
          Variable<double>(purchaseTaxableAmount.value);
    }
    if (totalPurchaseAmount.present) {
      map['total_purchase_amount'] =
          Variable<double>(totalPurchaseAmount.value);
    }
    if (logId.present) {
      map['log_id'] = Variable<int>(logId.value);
    }
    if (hospitalGenerateLedgerId.present) {
      map['hospital_generate_ledger_id'] =
          Variable<int>(hospitalGenerateLedgerId.value);
    }
    if (hospitalPaymentLedgerId.present) {
      map['hospital_payment_ledger_id'] =
          Variable<int>(hospitalPaymentLedgerId.value);
    }
    if (hospitalComission.present) {
      map['hospital_comission'] = Variable<double>(hospitalComission.value);
    }
    if (hospitalComissionAmount.present) {
      map['hospital_comission_amount'] =
          Variable<double>(hospitalComissionAmount.value);
    }
    if (hospitalComissionPaidDate.present) {
      map['hospital_comission_paid_date'] =
          Variable<DateTime>(hospitalComissionPaidDate.value);
    }
    if (hospitalAdjustComissionAmount.present) {
      map['hospital_adjust_comission_amount'] =
          Variable<double>(hospitalAdjustComissionAmount.value);
    }
    if (doctorGenerateLedgerId.present) {
      map['doctor_generate_ledger_id'] =
          Variable<int>(doctorGenerateLedgerId.value);
    }
    if (doctorPaymentLedgerId.present) {
      map['doctor_payment_ledger_id'] =
          Variable<int>(doctorPaymentLedgerId.value);
    }
    if (doctorComission.present) {
      map['doctor_comission'] = Variable<double>(doctorComission.value);
    }
    if (doctorComissionAmount.present) {
      map['doctor_comission_amount'] =
          Variable<double>(doctorComissionAmount.value);
    }
    if (doctorComissionPaidDate.present) {
      map['doctor_comission_paid_date'] =
          Variable<DateTime>(doctorComissionPaidDate.value);
    }
    if (doctorAdjustComissionAmount.present) {
      map['doctor_adjust_comission_amount'] =
          Variable<double>(doctorAdjustComissionAmount.value);
    }
    if (techniqalStaffGenerateLedgerId.present) {
      map['techniqal_staff_generate_ledger_id'] =
          Variable<int>(techniqalStaffGenerateLedgerId.value);
    }
    if (techniqalStaffPaymentLedgerId.present) {
      map['techniqal_staff_payment_ledger_id'] =
          Variable<int>(techniqalStaffPaymentLedgerId.value);
    }
    if (techniqalStaffComission.present) {
      map['techniqal_staff_comission'] =
          Variable<double>(techniqalStaffComission.value);
    }
    if (techniqalStaffComissionAmount.present) {
      map['techniqal_staff_comission_amount'] =
          Variable<double>(techniqalStaffComissionAmount.value);
    }
    if (techniqalStaffComissionPaidDate.present) {
      map['techniqal_staff_comission_paid_date'] =
          Variable<DateTime>(techniqalStaffComissionPaidDate.value);
    }
    if (techniqalStaffAdjustComissionAmount.present) {
      map['techniqal_staff_adjust_comission_amount'] =
          Variable<double>(techniqalStaffAdjustComissionAmount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InputDataCompanion(')
          ..write('id: $id, ')
          ..write('documentType: $documentType, ')
          ..write('distDocDate: $distDocDate, ')
          ..write('distDocNo: $distDocNo, ')
          ..write('hospitalID: $hospitalID, ')
          ..write('custBillCity: $custBillCity, ')
          ..write('matCode: $matCode, ')
          ..write('matName: $matName, ')
          ..write('mtID: $mtID, ')
          ..write('qty: $qty, ')
          ..write('doctorID: $doctorID, ')
          ..write('techniqalStaffID: $techniqalStaffID, ')
          ..write('saleAmount: $saleAmount, ')
          ..write('totalSale: $totalSale, ')
          ..write('smtDocDate: $smtDocDate, ')
          ..write('smtDocNo: $smtDocNo, ')
          ..write('smtInvNo: $smtInvNo, ')
          ..write('purchaseTaxableAmount: $purchaseTaxableAmount, ')
          ..write('totalPurchaseAmount: $totalPurchaseAmount, ')
          ..write('logId: $logId, ')
          ..write('hospitalGenerateLedgerId: $hospitalGenerateLedgerId, ')
          ..write('hospitalPaymentLedgerId: $hospitalPaymentLedgerId, ')
          ..write('hospitalComission: $hospitalComission, ')
          ..write('hospitalComissionAmount: $hospitalComissionAmount, ')
          ..write('hospitalComissionPaidDate: $hospitalComissionPaidDate, ')
          ..write(
              'hospitalAdjustComissionAmount: $hospitalAdjustComissionAmount, ')
          ..write('doctorGenerateLedgerId: $doctorGenerateLedgerId, ')
          ..write('doctorPaymentLedgerId: $doctorPaymentLedgerId, ')
          ..write('doctorComission: $doctorComission, ')
          ..write('doctorComissionAmount: $doctorComissionAmount, ')
          ..write('doctorComissionPaidDate: $doctorComissionPaidDate, ')
          ..write('doctorAdjustComissionAmount: $doctorAdjustComissionAmount, ')
          ..write(
              'techniqalStaffGenerateLedgerId: $techniqalStaffGenerateLedgerId, ')
          ..write(
              'techniqalStaffPaymentLedgerId: $techniqalStaffPaymentLedgerId, ')
          ..write('techniqalStaffComission: $techniqalStaffComission, ')
          ..write(
              'techniqalStaffComissionAmount: $techniqalStaffComissionAmount, ')
          ..write(
              'techniqalStaffComissionPaidDate: $techniqalStaffComissionPaidDate, ')
          ..write(
              'techniqalStaffAdjustComissionAmount: $techniqalStaffAdjustComissionAmount')
          ..write(')'))
        .toString();
  }
}

class $LedgerTable extends Ledger with TableInfo<$LedgerTable, LedgerData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LedgerTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pIDMeta = const VerificationMeta('pID');
  @override
  late final GeneratedColumn<int> pID = GeneratedColumn<int>(
      'p_i_d', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES party_master (id)'));
  static const VerificationMeta _ledgerDateMeta =
      const VerificationMeta('ledgerDate');
  @override
  late final GeneratedColumn<DateTime> ledgerDate = GeneratedColumn<DateTime>(
      'ledger_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _drAmountMeta =
      const VerificationMeta('drAmount');
  @override
  late final GeneratedColumn<double> drAmount = GeneratedColumn<double>(
      'dr_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _crAmountMeta =
      const VerificationMeta('crAmount');
  @override
  late final GeneratedColumn<double> crAmount = GeneratedColumn<double>(
      'cr_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _extradrAmountMeta =
      const VerificationMeta('extradrAmount');
  @override
  late final GeneratedColumn<double> extradrAmount = GeneratedColumn<double>(
      'extradr_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _extracrAmountMeta =
      const VerificationMeta('extracrAmount');
  @override
  late final GeneratedColumn<double> extracrAmount = GeneratedColumn<double>(
      'extracr_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _ledgerNoteMeta =
      const VerificationMeta('ledgerNote');
  @override
  late final GeneratedColumn<String> ledgerNote = GeneratedColumn<String>(
      'ledger_note', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        type,
        pID,
        ledgerDate,
        drAmount,
        crAmount,
        extradrAmount,
        extracrAmount,
        ledgerNote
      ];
  @override
  String get aliasedName => _alias ?? 'ledger';
  @override
  String get actualTableName => 'ledger';
  @override
  VerificationContext validateIntegrity(Insertable<LedgerData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('p_i_d')) {
      context.handle(
          _pIDMeta, pID.isAcceptableOrUnknown(data['p_i_d']!, _pIDMeta));
    } else if (isInserting) {
      context.missing(_pIDMeta);
    }
    if (data.containsKey('ledger_date')) {
      context.handle(
          _ledgerDateMeta,
          ledgerDate.isAcceptableOrUnknown(
              data['ledger_date']!, _ledgerDateMeta));
    } else if (isInserting) {
      context.missing(_ledgerDateMeta);
    }
    if (data.containsKey('dr_amount')) {
      context.handle(_drAmountMeta,
          drAmount.isAcceptableOrUnknown(data['dr_amount']!, _drAmountMeta));
    } else if (isInserting) {
      context.missing(_drAmountMeta);
    }
    if (data.containsKey('cr_amount')) {
      context.handle(_crAmountMeta,
          crAmount.isAcceptableOrUnknown(data['cr_amount']!, _crAmountMeta));
    } else if (isInserting) {
      context.missing(_crAmountMeta);
    }
    if (data.containsKey('extradr_amount')) {
      context.handle(
          _extradrAmountMeta,
          extradrAmount.isAcceptableOrUnknown(
              data['extradr_amount']!, _extradrAmountMeta));
    } else if (isInserting) {
      context.missing(_extradrAmountMeta);
    }
    if (data.containsKey('extracr_amount')) {
      context.handle(
          _extracrAmountMeta,
          extracrAmount.isAcceptableOrUnknown(
              data['extracr_amount']!, _extracrAmountMeta));
    } else if (isInserting) {
      context.missing(_extracrAmountMeta);
    }
    if (data.containsKey('ledger_note')) {
      context.handle(
          _ledgerNoteMeta,
          ledgerNote.isAcceptableOrUnknown(
              data['ledger_note']!, _ledgerNoteMeta));
    } else if (isInserting) {
      context.missing(_ledgerNoteMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LedgerData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LedgerData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      pID: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}p_i_d'])!,
      ledgerDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}ledger_date'])!,
      drAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}dr_amount'])!,
      crAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cr_amount'])!,
      extradrAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}extradr_amount'])!,
      extracrAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}extracr_amount'])!,
      ledgerNote: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ledger_note'])!,
    );
  }

  @override
  $LedgerTable createAlias(String alias) {
    return $LedgerTable(attachedDatabase, alias);
  }
}

class LedgerData extends DataClass implements Insertable<LedgerData> {
  final int id;
  final String type;
  final int pID;
  final DateTime ledgerDate;
  final double drAmount;
  final double crAmount;
  final double extradrAmount;
  final double extracrAmount;
  final String ledgerNote;
  const LedgerData(
      {required this.id,
      required this.type,
      required this.pID,
      required this.ledgerDate,
      required this.drAmount,
      required this.crAmount,
      required this.extradrAmount,
      required this.extracrAmount,
      required this.ledgerNote});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    map['p_i_d'] = Variable<int>(pID);
    map['ledger_date'] = Variable<DateTime>(ledgerDate);
    map['dr_amount'] = Variable<double>(drAmount);
    map['cr_amount'] = Variable<double>(crAmount);
    map['extradr_amount'] = Variable<double>(extradrAmount);
    map['extracr_amount'] = Variable<double>(extracrAmount);
    map['ledger_note'] = Variable<String>(ledgerNote);
    return map;
  }

  LedgerCompanion toCompanion(bool nullToAbsent) {
    return LedgerCompanion(
      id: Value(id),
      type: Value(type),
      pID: Value(pID),
      ledgerDate: Value(ledgerDate),
      drAmount: Value(drAmount),
      crAmount: Value(crAmount),
      extradrAmount: Value(extradrAmount),
      extracrAmount: Value(extracrAmount),
      ledgerNote: Value(ledgerNote),
    );
  }

  factory LedgerData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LedgerData(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      pID: serializer.fromJson<int>(json['pID']),
      ledgerDate: serializer.fromJson<DateTime>(json['ledgerDate']),
      drAmount: serializer.fromJson<double>(json['drAmount']),
      crAmount: serializer.fromJson<double>(json['crAmount']),
      extradrAmount: serializer.fromJson<double>(json['extradrAmount']),
      extracrAmount: serializer.fromJson<double>(json['extracrAmount']),
      ledgerNote: serializer.fromJson<String>(json['ledgerNote']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'pID': serializer.toJson<int>(pID),
      'ledgerDate': serializer.toJson<DateTime>(ledgerDate),
      'drAmount': serializer.toJson<double>(drAmount),
      'crAmount': serializer.toJson<double>(crAmount),
      'extradrAmount': serializer.toJson<double>(extradrAmount),
      'extracrAmount': serializer.toJson<double>(extracrAmount),
      'ledgerNote': serializer.toJson<String>(ledgerNote),
    };
  }

  LedgerData copyWith(
          {int? id,
          String? type,
          int? pID,
          DateTime? ledgerDate,
          double? drAmount,
          double? crAmount,
          double? extradrAmount,
          double? extracrAmount,
          String? ledgerNote}) =>
      LedgerData(
        id: id ?? this.id,
        type: type ?? this.type,
        pID: pID ?? this.pID,
        ledgerDate: ledgerDate ?? this.ledgerDate,
        drAmount: drAmount ?? this.drAmount,
        crAmount: crAmount ?? this.crAmount,
        extradrAmount: extradrAmount ?? this.extradrAmount,
        extracrAmount: extracrAmount ?? this.extracrAmount,
        ledgerNote: ledgerNote ?? this.ledgerNote,
      );
  @override
  String toString() {
    return (StringBuffer('LedgerData(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('pID: $pID, ')
          ..write('ledgerDate: $ledgerDate, ')
          ..write('drAmount: $drAmount, ')
          ..write('crAmount: $crAmount, ')
          ..write('extradrAmount: $extradrAmount, ')
          ..write('extracrAmount: $extracrAmount, ')
          ..write('ledgerNote: $ledgerNote')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, type, pID, ledgerDate, drAmount, crAmount,
      extradrAmount, extracrAmount, ledgerNote);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LedgerData &&
          other.id == this.id &&
          other.type == this.type &&
          other.pID == this.pID &&
          other.ledgerDate == this.ledgerDate &&
          other.drAmount == this.drAmount &&
          other.crAmount == this.crAmount &&
          other.extradrAmount == this.extradrAmount &&
          other.extracrAmount == this.extracrAmount &&
          other.ledgerNote == this.ledgerNote);
}

class LedgerCompanion extends UpdateCompanion<LedgerData> {
  final Value<int> id;
  final Value<String> type;
  final Value<int> pID;
  final Value<DateTime> ledgerDate;
  final Value<double> drAmount;
  final Value<double> crAmount;
  final Value<double> extradrAmount;
  final Value<double> extracrAmount;
  final Value<String> ledgerNote;
  const LedgerCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.pID = const Value.absent(),
    this.ledgerDate = const Value.absent(),
    this.drAmount = const Value.absent(),
    this.crAmount = const Value.absent(),
    this.extradrAmount = const Value.absent(),
    this.extracrAmount = const Value.absent(),
    this.ledgerNote = const Value.absent(),
  });
  LedgerCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    required int pID,
    required DateTime ledgerDate,
    required double drAmount,
    required double crAmount,
    required double extradrAmount,
    required double extracrAmount,
    required String ledgerNote,
  })  : type = Value(type),
        pID = Value(pID),
        ledgerDate = Value(ledgerDate),
        drAmount = Value(drAmount),
        crAmount = Value(crAmount),
        extradrAmount = Value(extradrAmount),
        extracrAmount = Value(extracrAmount),
        ledgerNote = Value(ledgerNote);
  static Insertable<LedgerData> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<int>? pID,
    Expression<DateTime>? ledgerDate,
    Expression<double>? drAmount,
    Expression<double>? crAmount,
    Expression<double>? extradrAmount,
    Expression<double>? extracrAmount,
    Expression<String>? ledgerNote,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (pID != null) 'p_i_d': pID,
      if (ledgerDate != null) 'ledger_date': ledgerDate,
      if (drAmount != null) 'dr_amount': drAmount,
      if (crAmount != null) 'cr_amount': crAmount,
      if (extradrAmount != null) 'extradr_amount': extradrAmount,
      if (extracrAmount != null) 'extracr_amount': extracrAmount,
      if (ledgerNote != null) 'ledger_note': ledgerNote,
    });
  }

  LedgerCompanion copyWith(
      {Value<int>? id,
      Value<String>? type,
      Value<int>? pID,
      Value<DateTime>? ledgerDate,
      Value<double>? drAmount,
      Value<double>? crAmount,
      Value<double>? extradrAmount,
      Value<double>? extracrAmount,
      Value<String>? ledgerNote}) {
    return LedgerCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      pID: pID ?? this.pID,
      ledgerDate: ledgerDate ?? this.ledgerDate,
      drAmount: drAmount ?? this.drAmount,
      crAmount: crAmount ?? this.crAmount,
      extradrAmount: extradrAmount ?? this.extradrAmount,
      extracrAmount: extracrAmount ?? this.extracrAmount,
      ledgerNote: ledgerNote ?? this.ledgerNote,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (pID.present) {
      map['p_i_d'] = Variable<int>(pID.value);
    }
    if (ledgerDate.present) {
      map['ledger_date'] = Variable<DateTime>(ledgerDate.value);
    }
    if (drAmount.present) {
      map['dr_amount'] = Variable<double>(drAmount.value);
    }
    if (crAmount.present) {
      map['cr_amount'] = Variable<double>(crAmount.value);
    }
    if (extradrAmount.present) {
      map['extradr_amount'] = Variable<double>(extradrAmount.value);
    }
    if (extracrAmount.present) {
      map['extracr_amount'] = Variable<double>(extracrAmount.value);
    }
    if (ledgerNote.present) {
      map['ledger_note'] = Variable<String>(ledgerNote.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LedgerCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('pID: $pID, ')
          ..write('ledgerDate: $ledgerDate, ')
          ..write('drAmount: $drAmount, ')
          ..write('crAmount: $crAmount, ')
          ..write('extradrAmount: $extradrAmount, ')
          ..write('extracrAmount: $extracrAmount, ')
          ..write('ledgerNote: $ledgerNote')
          ..write(')'))
        .toString();
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(e);
  late final $UserTable user = $UserTable(this);
  late final $MaterialTypeTable materialType = $MaterialTypeTable(this);
  late final $PartyTypeMasterTable partyTypeMaster =
      $PartyTypeMasterTable(this);
  late final $PartyMasterTable partyMaster = $PartyMasterTable(this);
  late final $PartyComissionDetailTable partyComissionDetail =
      $PartyComissionDetailTable(this);
  late final $InputDataTable inputData = $InputDataTable(this);
  late final $LedgerTable ledger = $LedgerTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        user,
        materialType,
        partyTypeMaster,
        partyMaster,
        partyComissionDetail,
        inputData,
        ledger
      ];
}
