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
    // إنشاء متحكم لكل عمود في السجل تلقائياً
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

  // دالة إنشاء ملف Excel وتصديره ومشاركته
  Future<void> _saveAndExportDocument() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      // 1. إنشاء ملف Excel جديد
      var excel = Excel.createExcel();
      String sheetName = widget.category.excelSheetName;
      
      // تغيير اسم ورقة العمل أو استخدام الافتراضية
      Sheet sheetObject = excel[sheetName];
      excel.setDefaultSheet(sheetName);

      // 2. إضافة رؤوس الأعمدة
      List<CellValue> headers = widget.category.columns.map((e) => TextCellValue(e)).toList();
      sheetObject.appendRow(headers);

      // 3. إضافة البيانات أدخلها المستخدم
      List<CellValue> rowData = [];
      for (var col in widget.category.columns) {
        if (col == 'م') {
          rowData.add(TextCellValue('1'));
        } else {
          rowData.add(TextCellValue(_controllers[col]?.text ?? ''));
        }
      }
      sheetObject.appendRow(rowData);

      // 4. ترميز الملف وتحديد المسار المؤقت للحفظ
      var fileBytes = excel.save();
      if (fileBytes != null) {
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/${widget.category.excelSheetName}_${DateTime.now().millisecondsSinceEpoch}.xlsx';
        
        File(filePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes);

        // 5. فتح نافذة المشاركة فوراً لحفظ الملف في Downloads أو إرساله
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم تجهيز الملف بنجاح!')),
          );
          
          await Share.shareXFiles(
            [XFile(filePath)],
            text: 'سجل مأرشف: ${widget.category.title}',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ أثناء التصدير: $e')),
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
                        Text(
                          'تعبئة بيانات ${widget.category.title}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: widget.category.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // توليد الحقول ديناميكياً حسب أعمدة السجل
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

                // زر حفظ الوثيقة وتصديرها
                ElevatedButton.icon(
                  onPressed: _saveAndExportDocument,
                  icon: const Icon(Icons.save_alt_rounded),
                  label: const Text('حفظ وتصدير إلى Excel', style: TextStyle(fontSize: 16)),
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
