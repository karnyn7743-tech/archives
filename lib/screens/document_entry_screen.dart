import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:excel/excel.dart' hide Border;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/register_category.dart';

class DocumentEntryScreen extends StatefulWidget {
  final RegisterCategory category;

  const DocumentEntryScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<DocumentEntryScreen> createState() => _DocumentEntryScreenState();
}

class _DocumentEntryScreenState extends State<DocumentEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    for (var col in widget.category.columns) {
      if (col != 'م') {
        _controllers[col] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  /// طلب صريح لإذن الوصول للتخزين من المستخدم
  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      // محاولة الحصول على إذن التخزين العادي
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }

      // في أندرويد 11+ (API 30+) يتطلب الأمر إذن إدارة الملفات الكامل
      if (!status.isGranted) {
        var manageStatus = await Permission.manageExternalStorage.status;
        if (!manageStatus.isGranted) {
          manageStatus = await Permission.manageExternalStorage.request();
        }
        return manageStatus.isGranted;
      }
      return status.isGranted;
    }
    return true;
  }

  /// الحصول على المسار الرئيسي العام في ذاكرة الهاتف (Documents/archives)
  Future<Directory> _getPublicArchivesDirectory() async {
    Directory? externalDir = await getExternalStorageDirectory();
    String newPath = "";
    
    List<String> paths = externalDir!.path.split("/");
    for (int x = 1; x < paths.length; x++) {
      String folder = paths[x];
      if (folder != "Android") {
        newPath += "/" + folder;
      } else {
        break;
      }
    }
    
    Directory mainArchivesDir = Directory("$newPath/Documents/archives");
    if (!await mainArchivesDir.exists()) {
      await mainArchivesDir.create(recursive: true);
    }
    return mainArchivesDir;
  }

  // التقاط صورة أو اختيارها من المعرض
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في اختيار الصورة: $e')),
      );
    }
  }

  // حفظ الصورة داخل مجلد السجل المحدد
  Future<String?> _saveImageToCategoryFolder(Directory archivesDir) async {
    if (_selectedImage == null) return null;

    try {
      final categoryFolder = Directory('${archivesDir.path}/${widget.category.excelSheetName}');
      if (!await categoryFolder.exists()) {
        await categoryFolder.create(recursive: true);
      }

      final fileName = 'doc_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = await _selectedImage!.copy('${categoryFolder.path}/$fileName');
      return savedImage.path;
    } catch (e) {
      return null;
    }
  }

  // الحصول على أو إنشاء ملف Archives.xlsx الموحد
  Future<File> _getArchivesExcelFile(Directory archivesDir) async {
    final file = File('${archivesDir.path}/Archives.xlsx');

    if (!await file.exists()) {
      try {
        final byteData = await rootBundle.load('assets/Archives.xlsx');
        await file.writeAsBytes(
          byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
        );
      } catch (_) {
        final newExcel = Excel.createExcel();
        final bytes = newExcel.save();
        if (bytes != null) {
          await file.writeAsBytes(bytes);
        }
      }
    }
    return file;
  }

  // حفظ بيانات الأرشفة وتحديث الإكسل
  Future<void> _saveDocument() async {
    if (!_formKey.currentState!.validate()) return;

    // 1. التحقق من صلاحية التخزين وطلبها من المستخدم
    bool hasPermission = await _requestStoragePermission();
    if (!hasPermission) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('يرجى إعطاء صلاحية الوصول للذاكرة لتتمكن من حفظ الملفات'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 2. الحصول على مسار مجلد archives
      final archivesDir = await _getPublicArchivesDirectory();

      // 3. حفظ الصورة المرفقة إن وجدت
      final savedImagePath = await _saveImageToCategoryFolder(archivesDir);

      // 4. قراءة ملف الإكسل وتحديثه
      final file = await _getArchivesExcelFile(archivesDir);
      final bytes = await file.readAsBytes();
      final excel = Excel.decodeBytes(bytes);

      String sheetName = widget.category.excelSheetName;
      Sheet sheet = excel[sheetName];

      if (sheet.maxRows == 0) {
        List<CellValue> headers = widget.category.columns.map((e) => TextCellValue(e)).toList();
        sheet.appendRow(headers);
      }

      int autoId = sheet.maxRows;
      List<CellValue> rowData = [];

      for (var colName in widget.category.columns) {
        if (colName == 'م') {
          rowData.add(TextCellValue(autoId.toString()));
        } else if (colName.contains('ملاحظات') && savedImagePath != null) {
          String userNotes = _controllers[colName]?.text.trim() ?? '';
          rowData.add(TextCellValue('$userNotes [المسار: $savedImagePath]'));
        } else {
          rowData.add(TextCellValue(_controllers[colName]?.text.trim() ?? ''));
        }
      }

      sheet.appendRow(rowData);

      final updatedBytes = excel.save();
      if (updatedBytes != null) {
        await file.writeAsBytes(updatedBytes, flush: true);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تم الحفظ بنجاح في: Documents/archives/${widget.category.excelSheetName}'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 4),
            ),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ أثناء الحفظ: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('إدخال: ${widget.category.title}'),
          centerTitle: true,
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // كارت التقاط واختيار الصورة
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              _selectedImage != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(_selectedImage!, height: 160, fit: BoxFit.cover),
                                    )
                                  : Container(
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.grey.shade300),
                                      ),
                                      child: const Center(
                                        child: Text('لم يتم إرفاق صورة للوثيقة بعد'),
                                      ),
                                    ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () => _pickImage(ImageSource.camera),
                                    icon: const Icon(Icons.camera_alt),
                                    label: const Text('الكاميرا'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: widget.category.color,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                  OutlinedButton.icon(
                                    onPressed: () => _pickImage(ImageSource.gallery),
                                    icon: const Icon(Icons.photo_library),
                                    label: const Text('المعرض'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // توليد حقول الإدخال
                      ...widget.category.columns.where((col) => col != 'م').map((colName) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: TextFormField(
                            controller: _controllers[colName],
                            decoration: InputDecoration(
                              labelText: colName,
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'يرجى إدخال $colName';
                              }
                              return null;
                            },
                          ),
                        );
                      }).toList(),

                      const SizedBox(height: 16),

                      ElevatedButton.icon(
                        onPressed: _saveDocument,
                        icon: const Icon(Icons.save_rounded),
                        label: const Text('حفظ الوثيقة والسجل', style: TextStyle(fontSize: 16)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.category.color,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
