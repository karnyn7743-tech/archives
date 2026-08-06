import 'package:flutter/material.dart';
import 'register_category.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFA5F0FA),
        appBar: AppBar(
          title: const Text(
            'الأرشفة الإدارية',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          centerTitle: true,
          elevation: 2,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // فتح شاشة البحث العام
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: GridView.builder(
            itemCount: mainCategories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // عدد الأعمدة (يمكن تعديلها لـ 3 على الشاشات الكبيرة)
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
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          // الانتقال لشاشة خيارات السجل المختار
          _navigateToRegisterOptions(context, category);
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
                radius: 28,
                backgroundColor: category.color.withOpacity(0.15),
                child: Icon(category.icon, size: 30, color: category.color),
              ),
              const SizedBox(height: 10),
              Text(
                category.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
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

  void _navigateToRegisterOptions(BuildContext context, RegisterCategory category) {
    // سيتم ربطها بشاشة الخيارات (إضافة / استعراض)
  }
}
