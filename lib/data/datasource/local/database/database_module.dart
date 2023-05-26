import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../model/notify_db_model.dart';
import 'notify_dao.dart';

part 'database_module.g.dart';

@Database(version: 1, entities: [NotifyDbModel])
abstract class DatabaseModule extends FloorDatabase {
  NotifyDao get notifyDao;
}
