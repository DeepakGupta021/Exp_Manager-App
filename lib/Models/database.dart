import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

import './transaction.dart' as transac;

class DBprovider {
  DBprovider._();
  static final DBprovider db = DBprovider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), "transactionDB.db"),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE transactions(
            id TEXT PRIMARY,pnameTEXT,unameTEXT,amount INTEGER,date TEXT
            )
        ''');
      },
      version: 1,
    );
  }

  newTransac(transac.Transaction t) async {
    final db = await database;

    var res = await db.rawInsert('''
      INSERT INTO transactions(
        id,pname,uname,amount,date
      ) VALUES(?,?,?,?,?)
    ''', [t.id, t.pName, t.uName, t.amount, t.date.toString()]);
    
    return res;
  }

  Future<List<transac.Transaction>> getTransaction() async
  {
    final db=await database;
    final List<transac.Transaction> txList=[];
    transac.Transaction t1;

    var res=await db.query("transactions");
    if(res.length==0)
    {
      return null;
    }
    try {
      for (var i = 0; i < res.length; i++) {
          res[0].forEach((key, value) { });   
      }
      var resMap=res[0];
      return resMap.isNotEmpty ? resMap : Null;
    } catch (e) {
      return null;
    }

  }

}
