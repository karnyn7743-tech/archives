import 'package:flutter/material.dart';
import '../models/register_category.dart';

class DocumentEntryScreen extends StatefulWidget {
  final RegisterCategory category;
  final List<String> columns; // أسماء أعمدة السجل المسحوبة من شيت الإكسل
  final int nextId; // رقم الأرشفة التلقائي (Max ID + 1)

  const DocumentEntryScreen({
    Key? key,
    required this.category,
    required this.columns,
    required this.nextId,
  }) : super(key: key);

  @override
  State<DocumentEntryScreen> createState() => _DocumentEntryScreenState();
}

class _DocumentEntryScreenState extends State<DocumentEntryScreen> {
  final Map<String, TextEditingController> _controllers = {};
  String? _attachedFilePath;
  bool _isCameraScan = false;

  @override
  void initState() {
    super.initState();
    // إنشاء متحكم نص لكل عمود في السجل باستثناء عمود "م"
    for (var col in widget.columns) {
      if (col.trim() != 'م') {
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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('أرشفة جديد: ${widget.category.title}'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. كارت رقم الأرشفة التلقائي والمرفقات
              _buildAttachmentSection(),

              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),

              const Text(
                'بيانات الوثيقة السجلية:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // 2. حقول الإدخال الديناميكية بحسب أعمدة الإكسل
              ...widget.columns.where((col) => col.trim() != 'م').map((colName) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: TextFormField(
                    controller: _controllers[colName],
                    maxLines: colName.contains('ملاحظات') ? 3 : 1,
                    decoration: InputDecoration(
                      labelText: colName,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                );
              }).toList(),

              const SizedBox(height: 20),

              // 3. أزرار الحفظ والإلغاء
              ElevatedButton.icon(
                onPressed: _saveDocument,
                icon: const Icon(Icons.save_alt),
                label: const Text('حفظ وتوثيق البيانات', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // قسم الرقم التسلسلي وإرفاق الملف/الكاميرا
  Widget _buildAttachmentSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('رقم الأرشفة التلقائي (م):', style: TextStyle(fontWeight: FontWeight.bold)),
                Chip(
                  label: Text('#${widget.nextId}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  backgroundColor: Colors.indigo,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // فتح الكاميرا للمسح الضوئي
                      setState(() {
                        _isCameraScan = true;
                        _attachedFilePath = 'scanned_doc_${widget.nextId}.pdf';
                      });
                    },
                    icon: const Icon(Icons.camera_alt, color: Colors.teal),
                    label: const Text('الكاميرا'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // اختيار ملف PDF من الجهاز
                      setState(() {
                        _isCameraScan = false;
                        _attachedFilePath = 'selected_doc_${widget.nextId}.pdf';
                      });
                    },
                    icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
                    label: const Text('ملف PDF'),
                  ),
                ),
              ],
            ),
            if (_attachedFilePath != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(_isCameraScan ? Icons.center_focus_strong : Icons.picture_as_pdf, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'تم المرفق: $_attachedFilePath',
                        style: const TextStyle(fontSize: 12, color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _saveDocument() {
    // كود حفظ البيانات وتحديث شيت الإكسل
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم توثيق الوثيقة وحفظ البيانات بنجاح!')),
    );
    Navigator.pop(context);
  }
}
