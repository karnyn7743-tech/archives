import 'package:flutter/material.dart';

// استدعي النماذج والشاشات حسب مسارات المجلدات لديك
import 'models/register_category.dart';
import 'screens/home_screen.dart';
import 'screens/register_options_screen.dart';
import 'screens/document_entry_screen.dart';
import 'screens/search_preview_screen.dart';

void main() {
  runApp(const SecretariatArchiveApp());
}

class SecretariatArchiveApp extends StatelessWidget {
  const SecretariatArchiveApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'الأرشفة الإدارية',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
        fontFamily: 'Roboto', // يمكنك تغيير الخط حسب المتوفر في مشروعك
      ),
      // ضبط اتجاه التطبيق كاملاً ليدعم اللغة العربية من اليمين للشمال
      home: const MainHomeScreen(),
    );
  }
}

class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6F9),
        appBar: AppBar(
          title: const Text(
            'الأرشفة الإدارية والسكرتارية',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          centerTitle: true,
          elevation: 2,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: GridView.builder(
            itemCount: mainCategories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (context, index) {
              final category = mainCategories[index];
              return _buildCategoryCard(context, category);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, RegisterCategory category) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          // التنقل إلى شاشة خيارات السجل المختار
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DemoRegisterOptionsScreen(category: category),
            ),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [Colors.white, Colors.indigo.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: category.color.withOpacity(0.15),
                child: Icon(category.icon, size: 28, color: category.color),
              ),
              const SizedBox(height: 10),
              Text(
                category.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// شاشة تفاعلية تربط الخيارات بالشاشات الأخرى لأغراض المعاينة والتجربة
class DemoRegisterOptionsScreen extends StatelessWidget {
  final RegisterCategory category;

  const DemoRegisterOptionsScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6F9),
        appBar: AppBar(
          title: Text(category.title),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // كارت عنوان السجل
              Card(
                color: category.color,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(category.icon, size: 40, color: Colors.white),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.title,
                            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'ورقة العمل: ${category.excelSheetName}',
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // الأزرار التفاعلية لفتح باقي الشاشات
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // تجربة فتح شاشة إدخال الوثيقة مع أعمدة افتراضية
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DocumentEntryScreen(
                              category: category,
                              columns: const ['م', 'الاسم', 'تاريخ الإجراء', 'الجهة / المدرج إليها', 'ملاحظات'],
                              nextId: 104,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_a_photo),
                      label: const Text('أرشفة وثيقة جديدة'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // تجربة فتح شاشة البحث والاستعراض
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchPreviewScreen(category: category),
                          ),
                        );
                      },
                      icon: const Icon(Icons.search),
                      label: const Text('استعراض وبحث'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
