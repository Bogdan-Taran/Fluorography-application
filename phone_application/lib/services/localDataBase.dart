import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:path_provider/path_provider.dart';
import 'package:project_fluorography/models/single_group_with_students_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/staff_and_students_model.dart';
import 'api_service_get_community_members.dart';

class CacheService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'cache.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
            CREATE TABLE cache (
              id TEXT PRIMARY KEY,
              data TEXT NOT NULL,
              timestamp INTEGER NOT NULL
            )
          ''');
      },
    );
  }

  Future<void> saveToCache(String id, String data) async {
    final db = await database;
    await db.insert('cache', {
      'id': id,
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<String?> getCachedData(String id) async {
    final db = await database;
    final result = await db.query('cache', where: 'id = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      final timestamp = result.first['timestamp'] as int;
/*
      if(DateTime.now().millisecondsSinceEpoch - timestamp > 36000){
         await removeFromCache(id);
         return null;
       }*/

      return result.first['data'] as String?;
    }
    return null;
  }

  Future<void> removeFromCache(String id) async {
    final db = await database;
    await db.delete('cache', where: 'id = ?', whereArgs: [id]);
  }
}

class CheckerCacheService {
  final CacheService _cache = CacheService();
  final ApiServiceGetCommunityMembers _ApiServiceGetCommunityMembers =
      ApiServiceGetCommunityMembers();

  Future<List<SingleGroupWithStudentsModel>> getGroupsCuratorWithCache() async {
    const cacheId = 'groups_data';
    //check cache
    final cached = await _cache.getCachedData(cacheId);
    if (cached != null) {
      try {
        print('Пробую раскэшировать данные');
        final list = jsonDecode(cached) as List<dynamic>;
        print('Данные раскэшированы, выозвращаю их');
        return list
            .map((e) => SingleGroupWithStudentsModel.fromJson(e))
            .toList();
      } catch (e) {
        print('Ошибка при получении кэшированных данных');
        print(e);
      }
    }
    print('Пробую обратиться к api');
    try {
      final data = await _ApiServiceGetCommunityMembers.getGroupsForCurator();
      print('Данные из api получены');
      final jsonString = jsonEncode(data.map((e) => e.toJson()).toList());
      print('Сохраняю в кэш');
      await _cache.saveToCache(cacheId, jsonString);
      print('Возвращаю данные');
      return data;
    } catch (e) {
      print('Ошибка при попытке запросить данные из api и сохранить их в кэш');
    }
    print('Давай по новой, миша, всё хуйня - запрос к api');
    final dataFromApi =
        await _ApiServiceGetCommunityMembers.getGroupsForCurator();
    return dataFromApi;
  }


  Future<List<StaffAndStudentsModel>> getGroupsMedicWithCache() async {
    // const cacheId = 'groups_medic_data';
    const cacheId = 'groups_data';

    //check cache
    final cached = await _cache.getCachedData(cacheId);
    if (cached != null) {
      try {
        print('Пробую раскэшировать данные');
        final list = jsonDecode(cached) as List<dynamic>;
        print('Данные раскэшированы, выозвращаю их');
        return list
            .map((e) => StaffAndStudentsModel.fromJson(e))
            .toList();
      } catch (e) {
        print('Ошибка при получении кэшированных данных');
        print(e);
      }
    }
    print('Пробую обратиться к api');
    try {
      final data = await _ApiServiceGetCommunityMembers.getAllComuintyForMedic();
      print('Данные из api получены');
      final jsonString = jsonEncode(data.map((e) => e.toJson()).toList());
      print('Сохраняю в кэш');
      await _cache.saveToCache(cacheId, jsonString);
      print('Возвращаю данные');
      return data;
    } catch (e) {
      print('Ошибка при попытке запросить данные из api и сохранить их в кэш');
    }
    print('Давай по новой, миша, всё хуйня - запрос к api');
    final dataFromApi =
    await _ApiServiceGetCommunityMembers.getAllComuintyForMedic();
    return dataFromApi;
  }


  Future<List<SingleGroupWithStudentsModel>> getGroupsAdminWithCache() async {
    // const cacheId = 'groups_admin_data';
    const cacheId = 'groups_data';

    //check cache
    final cached = await _cache.getCachedData(cacheId);
    if (cached != null) {
      try {
        print('Пробую раскэшировать данные');
        final list = jsonDecode(cached) as List<dynamic>;
        print('Данные раскэшированы, выозвращаю их');
        return list
            .map((e) => SingleGroupWithStudentsModel.fromJson(e))
            .toList();
      } catch (e) {
        print('Ошибка при получении кэшированных данных');
        print(e);
      }
    }
    print('Пробую обратиться к api');
    try {
      final data = await _ApiServiceGetCommunityMembers.getGroupsForAdmin();
      print('Данные из api получены');
      final jsonString = jsonEncode(data.map((e) => e.toJson()).toList());
      print('Сохраняю в кэш');
      await _cache.saveToCache(cacheId, jsonString);
      print('Возвращаю данные');
      return data;
    } catch (e) {
      print('Ошибка при попытке запросить данные из api и сохранить их в кэш');
    }
    print('Давай по новой, миша, всё хуйня - запрос к api');
    final dataFromApi =
    await _ApiServiceGetCommunityMembers.getGroupsForAdmin();
    return dataFromApi;
  }
}
