import 'dart:io';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
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

  @override
  void initState() {
    super.initState();
    // إنشاء حقل لكل عمود في ورقة العمل الخاصة بالسجل
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

  // الحصول على المسار الموحد لملف Archives.xlsx في التخزين الداخلي
  Future<File> _getArchivesFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/Archives.xlsx';
    return File(path);
  }

  Future<void> _saveToUnifiedExcel() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final file = await _getArchivesFile();
      Excel excel;

      if (await file.exists()) {
        var bytes = await file.readAsBytes();
        excel = Excel.decodeBytes(bytes);
      } else {
        excel = Excel.createExcel();
      }

      String sheetName = widget.category.excelSheetName;
      Sheet sheet = excel[sheetName];

      // إضافة رؤوس الأعمدة إذا كانت الورقة فارغة
      if (sheet.maxRows == 0) {
        List<CellValue> headers = widget.category.columns.map((e) => TextCellValue(e)).toList();
        sheet.appendRow(headers);
      }

      // إحتساب التسلسل الآلي (م) بناءً على عدد الصفوف الحالية
      int nextAutoId = sheet.maxRows > 0 ? sheet.maxRows : 1;

      // تجميع بيانات الصف الجديد بناءً على حقول الشاشة
      List<CellValue> newRow = [];
      for (var col in widget.category.columns) {
        if (col == 'م') {
          newRow.add(TextCellValue(nextAutoId.toString()));
        } else {
          newRow.add(TextCellValue(_controllers[col]?.text ?? ''));
        }
      }

      sheet.appendRow(newRow);

      // حفظ الملف المحدث في ذاكرة التطبيق
      var fileBytes = excel.save();
      if (fileBytes != null) {
        await file.writeAsBytes(fileBytes);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تمت إضافة السجل إلى ورقة "${widget.category.title}" بنجاح!')),
          );

          // إتاحة خيار مشاركة/تصدير النسخة المحدثة فوراً
          await Share.shareXFiles(
            [XFile(file.path)],
            text: 'ملف الأرشفة الموحد المحدث - Archives.xlsx',
          );

          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ أثناء الحفظ: $e')),
        );
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
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  color: widget.category.color.withOpacity(0.1),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Icon(widget.category.icon, color: widget.category.color),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'تعبئة بيانات ورقة: ${widget.category.excelSheetName}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: widget.category.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // توليد الحقول المطابقة لرؤوس أعمدة الورقة بالضبط
                ...widget.category.columns.where((col) => col != 'م').map((colName) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: TextFormField(
                      controller: _controllers[colName],
                      decoration: InputDecoration(
                        labelText: colName,
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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

                const SizedBox(height: 20),

                ElevatedButton.icon(
                  onPressed: _saveToUnifiedExcel,
                  icon: const Icon(Icons.save_rounded),
                  label: const Text('حفظ في ملف Archives.xlsx الموحد', style: TextStyle(fontSize: 16)),
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
