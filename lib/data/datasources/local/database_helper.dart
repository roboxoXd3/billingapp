import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import '../../../core/utils/constants.dart';
import '../../../domain/entities/bill_line_item.dart';
import '../../models/bill_item_model.dart';
import '../../models/company_details_model.dart';
import '../../models/field_config_model.dart';
import '../../../core/error/exceptions.dart';

@singleton
class DatabaseHelper {
  static sqflite.Database? _database;

  Future<sqflite.Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<sqflite.Database> _initDatabase() async {
    try {
      final dbPath = await sqflite.getDatabasesPath();
      final path = join(dbPath, dbName);

      return await sqflite.openDatabase(
        path,
        version: dbVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    } catch (e) {
      throw DatabaseException('Failed to initialize database: $e');
    }
  }

  Future<void> _onCreate(sqflite.Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableCompanyDetails (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        address TEXT NOT NULL,
        phone TEXT NOT NULL,
        email TEXT NOT NULL,
        logo TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableFieldConfigs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fieldId TEXT NOT NULL,
        label TEXT NOT NULL,
        type TEXT NOT NULL,
        required INTEGER NOT NULL,
        defaultValue TEXT,
        isCalculated INTEGER NOT NULL,
        calculationFormula TEXT,
        orderIndex INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableBills (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        billNumber TEXT NOT NULL,
        customerName TEXT NOT NULL,
        location TEXT NOT NULL,
        lineItems TEXT NOT NULL,
        dynamicFields TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(
      sqflite.Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Backup existing data
      final List<Map<String, dynamic>> oldBills = await db.query(tableBills);

      // Drop the old table
      await db.execute('DROP TABLE IF EXISTS $tableBills');

      // Create the new table
      await db.execute('''
        CREATE TABLE $tableBills (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          billNumber TEXT NOT NULL,
          customerName TEXT NOT NULL,
          location TEXT NOT NULL,
          lineItems TEXT NOT NULL,
          dynamicFields TEXT NOT NULL,
          createdAt TEXT NOT NULL
        )
      ''');

      // Migrate old data to new format
      for (var oldBill in oldBills) {
        final lineItems = [
          {
            'description': oldBill['description'],
            'gross': oldBill['gross'],
            'less': oldBill['less'],
            'rate': oldBill['rate'],
            'discount': oldBill['discount'],
            'dynamicFields': jsonDecode(oldBill['dynamicFields'] as String),
          }
        ];

        await db.insert(tableBills, {
          'billNumber': oldBill['billNumber'],
          'customerName': oldBill['customerName'],
          'location': oldBill['location'],
          'lineItems': jsonEncode(lineItems),
          'dynamicFields': oldBill['dynamicFields'],
          'createdAt': oldBill['createdAt'] ?? DateTime.now().toIso8601String(),
        });
      }
    }
  }

  // Company Details Methods
  Future<CompanyDetailsModel?> getCompanyDetails() async {
    final db = await database;
    final results = await db.query(tableCompanyDetails);
    if (results.isEmpty) return null;
    return CompanyDetailsModel.fromMap(results.first);
  }

  Future<void> saveCompanyDetails(CompanyDetailsModel details) async {
    final db = await database;
    await db.delete(tableCompanyDetails);
    await db.insert(tableCompanyDetails, details.toMap());
  }

  // Field Config Methods
  Future<List<FieldConfigModel>> getAllFields() async {
    final db = await database;
    final results = await db.query(
      tableFieldConfigs,
      orderBy: 'orderIndex ASC',
    );
    return results.map((map) => FieldConfigModel.fromMap(map)).toList();
  }

  Future<FieldConfigModel> saveField(FieldConfigModel field) async {
    final db = await database;
    final id = await db.insert(tableFieldConfigs, field.toMap());
    return field.copyWith(id: id);
  }

  Future<void> deleteField(int id) async {
    final db = await database;
    await db.delete(
      tableFieldConfigs,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Bill Methods
  Future<List<BillItemModel>> getBills() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableBills);

    return maps.map((map) {
      final lineItemsList = jsonDecode(map['lineItems'] as String) as List;
      final lineItems = lineItemsList
          .map((item) => BillLineItemModel(
                description: item['description'] as String,
                gross: (item['gross'] as num).toDouble(),
                less: (item['less'] as num).toDouble(),
                rate: (item['rate'] as num).toDouble(),
                discount: (item['discount'] as num).toDouble(),
                type: item['type'] as String? ?? billTypeSale,
                dynamicFields:
                    Map<String, dynamic>.from(item['dynamicFields'] as Map),
              ))
          .toList();

      final dynamicFields =
          jsonDecode(map['dynamicFields'] as String) as Map<String, dynamic>;

      return BillItemModel(
        id: map['id'] as int?,
        billNumber: map['billNumber'] as String,
        customerName: map['customerName'] as String,
        location: map['location'] as String,
        lineItems: lineItems,
        dynamicFields: dynamicFields,
      );
    }).toList();
  }

  Future<BillItemModel> saveBill(BillItemModel bill) async {
    final db = await database;

    bill.lineItems.forEach((item) {
      print('Saving line item - Type: ${item.type}');
    });

    final lineItemsJson = jsonEncode(bill.lineItems
        .map((item) => {
              'description': item.description,
              'gross': item.gross,
              'less': item.less,
              'rate': item.rate,
              'discount': item.discount,
              'type': item.type,
              'dynamicFields': item.dynamicFields,
            })
        .toList());

    final billMap = {
      'billNumber': bill.billNumber,
      'customerName': bill.customerName,
      'location': bill.location,
      'lineItems': lineItemsJson,
      'dynamicFields': jsonEncode(bill.dynamicFields),
      'createdAt': DateTime.now().toIso8601String(),
    };

    int id;
    if (bill.id != null) {
      await db.update(
        tableBills,
        billMap,
        where: 'id = ?',
        whereArgs: [bill.id],
      );
      id = bill.id!;
    } else {
      id = await db.insert(tableBills, billMap);
    }

    return BillItemModel(
      id: id,
      billNumber: bill.billNumber,
      customerName: bill.customerName,
      location: bill.location,
      lineItems: bill.lineItems,
      dynamicFields: bill.dynamicFields,
    );
  }

  Future<void> deleteBill(int id) async {
    final db = await database;
    await db.delete(
      tableBills,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<BillItemModel?> getBillById(int id) async {
    final db = await database;
    final results = await db.query(
      tableBills,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (results.isEmpty) return null;
    return BillItemModel.fromMap(results.first);
  }
}
