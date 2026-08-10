import 'package:flutter/material.dart';
import '../models/register_category.dart';
import 'register_options_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الأرشفة الإدارية والسكرتارية للقعقاع الهاشمي'),
          centerTitle: true,
        ),
        body: GridView.builder(
          padding: const EdgeInsets.all(12.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.05,
          ),
          // هما السطرين المطلوبين لقراءة كافة السجلات الـ 18 ديناميكياً:
          itemCount: allArchiveCategories.length,
          itemBuilder: (context, index) {
            final category = allArchiveCategories[index];
            return _buildCategoryCard(context, category);
          },
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, RegisterCategory category) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegisterOptionsScreen(category: category),
            ),
          );
        },
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: category.color.withOpacity(0.15),
                child: Icon(category.icon, size: 28, color: category.color),
              ),
              const SizedBox(height: 8),
              Text(
                category.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
