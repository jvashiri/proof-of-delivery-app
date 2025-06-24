import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PoD SQLite + Firestore Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PocPodPage(),
    );
  }
}

class PocPodPage extends StatefulWidget {
  const PocPodPage({super.key});
  @override
  State<PocPodPage> createState() => _PocPodPageState();
}

class _PocPodPageState extends State<PocPodPage> {
  final PocPodViewModel vm = PocPodViewModel();

  @override
  void initState() {
    super.initState();
    vm.initDatabase();
    vm.getSavedEntries();
    vm.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Proof of Delivery')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: vm.waybillController,
              decoration: const InputDecoration(labelText: 'Waybill'),
            ),
            TextField(
              controller: vm.customerController,
              decoration: const InputDecoration(labelText: 'Customer'),
            ),
            TextField(
              controller: vm.consigneeController,
              decoration: const InputDecoration(labelText: 'Consignee'),
            ),
            TextField(
              controller: vm.phoneNumberController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            DropdownButton<String>(
              value: vm.deliveryType,
              onChanged: (val) {
                if (val != null) {
                  setState(() => vm.deliveryType = val);
                }
              },
              items: ['Pickup', 'Delivery']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
            ),
            const SizedBox(height: 12),
            vm.image != null
                ? Image.file(File(vm.image!.path), height: 150)
                : const Text('No image selected'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                  onPressed: () => vm.pickImage(ImageSource.camera),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.photo),
                  label: const Text('Gallery'),
                  onPressed: () => vm.pickImage(ImageSource.gallery),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await vm.saveDataLocally();
                await vm.getSavedEntries();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Saved locally')),
                );
              },
              child: const Text('Save Locally (SQLite)'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                await vm.saveDataToWebDatabase();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Saved to Firestore')),
                );
              },
              child: const Text('Save to Firestore (Web)'),
            ),
            const SizedBox(height: 20),
            const Text('Saved Entries:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            vm.savedEntries.isEmpty
                ? const Text('No saved entries')
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: vm.savedEntries.length,
                    itemBuilder: (context, index) {
                      final item = vm.savedEntries[index];
                      return ListTile(
                        title: Text(item['waybill'] ?? ''),
                        subtitle: Text('${item['customer'] ?? ''} | ${item['phoneNumber'] ?? ''}'),
                        trailing: Text(item['deliveryType'] ?? ''),
                      );
                    },
                  )
          ],
        ),
      ),
    );
  }
}

class PocPodViewModel extends ChangeNotifier {
  String deliveryType = 'Pickup';

  TextEditingController waybillController = TextEditingController();
  TextEditingController customerController = TextEditingController();
  TextEditingController consigneeController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  XFile? image;
  Database? _database;

  List<Map<String, dynamic>> savedEntries = [];

  /// Initialize the SQLite database and ensure the table exists
  Future<void> initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'poc_pod.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        debugPrint("Creating table poc_pod...");
        await db.execute('''
          CREATE TABLE poc_pod (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            waybill TEXT,
            customer TEXT,
            consignee TEXT,
            phoneNumber TEXT,
            deliveryType TEXT,
            imagePath TEXT,
            timestamp TEXT
          )
        ''');
        debugPrint("Table poc_pod created");
      },
    );

    // Ensure table exists (in case DB file exists but table was missing)
    await _database!.execute('''
      CREATE TABLE IF NOT EXISTS poc_pod (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        waybill TEXT,
        customer TEXT,
        consignee TEXT,
        phoneNumber TEXT,
        deliveryType TEXT,
        imagePath TEXT,
        timestamp TEXT
      )
    ''');
  }

  /// Pick image from camera or gallery
  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    image = await picker.pickImage(source: source);
    notifyListeners();
  }

  /// Save form data locally to SQLite
  Future<void> saveDataLocally() async {
    try {
      if (_database == null) {
        debugPrint("Database not initialized, initializing now...");
        await initDatabase();
      }

      String? imagePath;
      if (image != null) {
        final dir = await getApplicationDocumentsDirectory();
        final imgPath = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
        final savedImage = await File(image!.path).copy(imgPath);
        imagePath = savedImage.path;
      }

      final entry = {
        'waybill': waybillController.text.trim(),
        'customer': customerController.text.trim(),
        'consignee': consigneeController.text.trim(),
        'phoneNumber': phoneNumberController.text.trim(),
        'deliveryType': deliveryType,
        'imagePath': imagePath,
        'timestamp': DateTime.now().toIso8601String(),
      };

      debugPrint("Saving to SQLite: $entry");

      await _database!.insert('poc_pod', entry);
      clearForm();
      notifyListeners();
    } catch (e) {
      debugPrint("SQLite Save Error: $e");
    }
  }

  /// Save form data to Firestore (for web)
  Future<void> saveDataToWebDatabase() async {
    try {
      final entry = {
        'waybill': waybillController.text.trim(),
        'customer': customerController.text.trim(),
        'consignee': consigneeController.text.trim(),
        'phoneNumber': phoneNumberController.text.trim(),
        'deliveryType': deliveryType,
        'imageUrl': null, // Future: Add Firebase Storage integration
        'timestamp': DateTime.now().toIso8601String(),
      };

      debugPrint("Saving to Firestore: $entry");

      await FirebaseFirestore.instance.collection('poc_pod').add(entry);

      clearForm();
      notifyListeners();
    } catch (e) {
      debugPrint("Firestore Save Error: $e");
    }
  }

  /// Load saved entries from local SQLite
  Future<void> getSavedEntries() async {
    try {
      if (_database == null) {
        debugPrint("Database not initialized, initializing now...");
        await initDatabase();
      }
      final result = await _database!.query('poc_pod', orderBy: 'timestamp DESC');
      savedEntries = result;
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading entries: $e");
    }
  }

  /// Clear form input
  void clearForm() {
    waybillController.clear();
    customerController.clear();
    consigneeController.clear();
    phoneNumberController.clear();
    deliveryType = 'Pickup';
    image = null;
    notifyListeners();
  }
}
