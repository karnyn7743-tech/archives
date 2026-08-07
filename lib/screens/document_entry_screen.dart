import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // إنشاء متحكم لكل عمود في السجل باستثناء خانة التسلسل الآلي (م)
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

  /// الحصول على مسار الملف المحلي الموحد في ذاكرة الهاتف الدائمة
  Future<File> _getLocalArchivesFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/Archives.xlsx';
    final file = File(path);

    // إذا لم يكن الملف موجوداً في التخزين المحلي، نتحقق من وجود نسخة أولية في الـ Assets
    if (!await file.exists()) {
      try {
        final byteData = await rootBundle.load('assets/Archives.xlsx');
        await file.writeAsBytes(
          byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
        );
      } catch (_) {
        // في حال عدم وجود ملف بالـ Assets يتم إنشاء ملف جديد وتأسيسه تلقائياً
        final newExcel = Excel.createExcel();
        final bytes = newExcel.save();
        if (bytes != null) {
          await file.writeAsBytes(bytes);
        }
      }
    }
    return file;
  }

  /// فتح الملف الموحد وتحديث بيانات الورقة الحالية ثم حفظه
  Future<void> _saveAndAppendRecord() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final file = await _getLocalArchivesFile();
      final bytes = await file.readAsBytes();
      final excel = Excel.decodeBytes(bytes);

      String sheetName = widget.category.excelSheetName;
      Sheet sheet = excel[sheetName];

      // إذا كانت الورقة فارغة، نقوم بكتابة العناوين الأساسية أولاً
      if (sheet.maxRows == 0) {
        List<CellValue> headers =
            widget.category.columns.map((e) => TextCellValue(e)).toList();
        sheet.appendRow(headers);
      }

      // حساب رقم التسلسل الآلي (م) استناداً إلى عدد الصفوف الحالية
      int autoIncrementId = sheet.maxRows;

      // تجميع قيم الحقول المدخلة وفقاً لترتيب الأعمدة بالضبط
      List<CellValue> rowCells = [];
      for (var colName in widget.category.columns) {
        if (colName == 'م') {
          rowCells.add(TextCellValue(autoIncrementId.toString()));
        } else {
          String textValue = _controllers[colName]?.text.trim() ?? '';
          rowCells.add(TextCellValue(textValue));
        }
      }

      // إدراج الصف الجديد في نهاية السجل
      sheet.appendRow(rowCells);

      // حفظ التعديلات نهائياً على الملف المحلي
      final updatedBytes = excel.save();
      if (updatedBytes != null) {
        await file.writeAsBytes(updatedBytes, flush: true);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تمت إضافة السجل وتحديث ملف Archives.xlsx بنجاح!'),
              backgroundColor: Colors.green,
            ),
          );

          // إتاحة خيار فتح/مشاركة النسخة المحدثة فوراً
          await Share.shareXFiles(
            [XFile(file.path)],
            text: 'سجل مأرشف محدّث: ${widget.category.title}',
          );

          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ أثناء تحديث الملف: $e'),
            backgroundColor: Colors.red,
          ),
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
                      Card(
                        color: widget.category.color.withOpacity(0.1),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Icon(widget.category.icon, color: widget.category.color),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'تحديث ورقة: ${widget.category.excelSheetName}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: widget.category.color,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // توليد حقول الإدخال الديناميكية لجميع أعمدة ورقة العمل
                      ...widget.category.columns.where((col) => col != 'م').map((colName) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: TextFormField(
                            controller: _controllers[colName],
                            decoration: InputDecoration(
                              labelText: colName,
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
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
                        onPressed: _saveAndAppendRecord,
                        icon: const Icon(Icons.save_rounded),
                        label: const Text(
                          'حفظ وتحديث الملف الموحد',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
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
