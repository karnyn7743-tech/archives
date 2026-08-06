import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/register_category.dart';

class DocumentEntryScreen extends StatefulWidget {
  final RegisterCategory category;

  const DocumentEntryScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<DocumentEntryScreen> createState() => _DocumentEntryScreenState();
}

class _DocumentEntryScreenState extends State<DocumentEntryScreen> {
  final Map<String, TextEditingController> _controllers = {};
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // إنشاء متحكم لكل عمود خاص بالسجل المختار تلقائياً
    for (var column in widget.category.columns) {
      if (column != 'م') { // إغفال الترقيم التلقائي
        _controllers[column] = TextEditingController();
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

  // التقاط صورة عبر الكاميرا أو المعرض
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
        SnackBar(content: Text('خطأ في التقاط الصورة: $e')),
      );
    }
  }

  void _saveDocument() {
    // هنا يتم حفظ البيانات مع مسار الصورة _selectedImage?.path
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تمت أرشفة المستند في ${widget.category.title} بنجاح')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('إدخال وثيقة: ${widget.category.title}'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // قسم التقاط المرفق / الصورة
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
                              child: Image.file(_selectedImage!, height: 180, fit: BoxFit.cover),
                            )
                          : Container(
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: const Center(
                                child: Text('لم يتم إلتقاط صورة للوثيقة بعد'),
                              ),
                            ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _pickImage(ImageSource.camera),
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('الكاميرا'),
                            style: ElevatedButton.styleFrom(backgroundColor: widget.category.color, foregroundColor: Colors.white),
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
              const SizedBox(height: 20),

              // حقول إدخال البيانات الديناميكية المستخرجة من أعمدة السجل
              ..._controllers.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: TextField(
                    controller: entry.value,
                    decoration: InputDecoration(
                      labelText: entry.key,
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                  ),
                );
              }).toList(),

              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveDocument,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: widget.category.color,
                  foregroundColor: Colors.white,
                ),
                child: const Text('حفظ وأرشفة الوثيقة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
