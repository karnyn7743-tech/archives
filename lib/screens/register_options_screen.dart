import 'package:flutter/material.dart';
import '../models/register_category.dart';
import 'document_entry_screen.dart';
import 'search_preview_screen.dart';

class RegisterOptionsScreen extends StatelessWidget {
  final RegisterCategory category;

  const RegisterOptionsScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(category.title),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: category.color.withOpacity(0.1),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(category.icon, size: 40, color: category.color),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'إدارة ${category.title}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: category.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // زر إضافة وثيقة جديدة (تم الربط مع الكاميرا والإدخال)
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DocumentEntryScreen(category: category),
                    ),
                  );
                },
                icon: const Icon(Icons.add_a_photo),
                label: const Text('أرشفة وثيقة جديدة', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: category.color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
              const SizedBox(height: 12),

              // زر عرض الوثائق المأرشفة
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchPreviewScreen(category: category),
                    ),
                  );
                },
                icon: const Icon(Icons.description),
                label: const Text('عرض السجلات المأرشفة', style: TextStyle(fontSize: 16)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
