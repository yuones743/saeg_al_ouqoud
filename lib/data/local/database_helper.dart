import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    final existing = _db;
    if (existing != null) return existing;
    final created = await _initDb();
    _db = created;
    return created;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'saeg_al_ouqoud.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE contracts (id TEXT PRIMARY KEY, tenant_id TEXT NOT NULL, contract_type TEXT NOT NULL, status TEXT NOT NULL DEFAULT \'draft\', data_json TEXT NOT NULL, created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL)');
    await db.execute('CREATE TABLE audit_log (id INTEGER PRIMARY KEY AUTOINCREMENT, contract_id TEXT NOT NULL, decision_hash TEXT NOT NULL, decision_result TEXT NOT NULL, timestamp INTEGER NOT NULL, decisions_json TEXT)');
    await db.execute('CREATE INDEX idx_contracts_tenant ON contracts(tenant_id)');
    await db.execute('CREATE INDEX idx_audit_contract ON audit_log(contract_id)');
  }

  Future<void> close() async {
    final db = _db;
    if (db != null) { await db.close(); _db = null; }
  }
}