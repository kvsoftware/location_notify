// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_module.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorDatabaseModule {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$DatabaseModuleBuilder databaseBuilder(String name) =>
      _$DatabaseModuleBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$DatabaseModuleBuilder inMemoryDatabaseBuilder() =>
      _$DatabaseModuleBuilder(null);
}

class _$DatabaseModuleBuilder {
  _$DatabaseModuleBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$DatabaseModuleBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$DatabaseModuleBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<DatabaseModule> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$DatabaseModule();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$DatabaseModule extends DatabaseModule {
  _$DatabaseModule([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  NotifyDao? _notifyDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `notify` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `latitude` REAL NOT NULL, `longitude` REAL NOT NULL, `radius` REAL NOT NULL, `address` TEXT NOT NULL, `isEnabled` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  NotifyDao get notifyDao {
    return _notifyDaoInstance ??= _$NotifyDao(database, changeListener);
  }
}

class _$NotifyDao extends NotifyDao {
  _$NotifyDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _notifyDbModelInsertionAdapter = InsertionAdapter(
            database,
            'notify',
            (NotifyDbModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'radius': item.radius,
                  'address': item.address,
                  'isEnabled': item.isEnabled ? 1 : 0
                }),
        _notifyDbModelDeletionAdapter = DeletionAdapter(
            database,
            'notify',
            ['id'],
            (NotifyDbModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'radius': item.radius,
                  'address': item.address,
                  'isEnabled': item.isEnabled ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<NotifyDbModel> _notifyDbModelInsertionAdapter;

  final DeletionAdapter<NotifyDbModel> _notifyDbModelDeletionAdapter;

  @override
  Future<NotifyDbModel?> getNotifyById(int id) async {
    return _queryAdapter.query('SELECT * FROM notify WHERE id = ?1',
        mapper: (Map<String, Object?> row) => NotifyDbModel(
            id: row['id'] as int?,
            name: row['name'] as String,
            latitude: row['latitude'] as double,
            longitude: row['longitude'] as double,
            radius: row['radius'] as double,
            address: row['address'] as String,
            isEnabled: (row['isEnabled'] as int) != 0),
        arguments: [id]);
  }

  @override
  Future<List<NotifyDbModel>> getNotifies() async {
    return _queryAdapter.queryList('SELECT * FROM notify',
        mapper: (Map<String, Object?> row) => NotifyDbModel(
            id: row['id'] as int?,
            name: row['name'] as String,
            latitude: row['latitude'] as double,
            longitude: row['longitude'] as double,
            radius: row['radius'] as double,
            address: row['address'] as String,
            isEnabled: (row['isEnabled'] as int) != 0));
  }

  @override
  Future<void> insertNotify(NotifyDbModel notifyDbModel) async {
    await _notifyDbModelInsertionAdapter.insert(
        notifyDbModel, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteNotify(NotifyDbModel notifyDbModel) async {
    await _notifyDbModelDeletionAdapter.delete(notifyDbModel);
  }
}
