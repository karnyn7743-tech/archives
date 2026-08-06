import 'package:flutter/material.dart';
import '../models/register_category.dart';
import 'register_options_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final List<RegisterCategory> mainCategories = [
    RegisterCategory(
      id: 'transfers',
      title: 'سجل المنقولين',
      icon: Icons.move_up,
      color: Colors.indigo,
      excelSheetName: 'Transfers',
      columns: ['م', 'اسم الطالب', 'المدرسة المنقول إليها', 'تاريخ النقل', 'ملاحظات'],
    ),
    RegisterCategory(
      id: 'absences',
      title: 'سجل الغياب والغياب اليومي',
      icon: Icons.person_off,
      color: Colors.teal,
      excelSheetName: 'Absences',
      columns: ['م', 'اسم الطالب', 'الصف', 'تاريخ الغياب', 'العذر'],
    ),
    RegisterCategory(
      id: 'certificates',
      title: 'سجل الشهادات والوثائق',
      icon: Icons.card_membership,
      color: Colors.orange,
      excelSheetName: 'Certificates',
      columns: ['م', 'اسم الطالب', 'نوع الوثيقة', 'تاريخ الإصدار', 'ملاحظات'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('نظام الأرشيف والسجلات السكرتارية'),
          centerTitle: true,
        ),
        body: GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: mainCategories.length,
          itemBuilder: (context, index) {
            final category = mainCategories[index];
            return _buildCategoryCard(context, category);
          },
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, RegisterCategory category) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _navigateToRegisterOptions(context, category),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(category.icon, size: 48, color: category.color),
            const SizedBox(height: 12),
            Text(
              category.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToRegisterOptions(BuildContext context, RegisterCategory category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterOptionsScreen(category: category),
      ),
    );
  }
}
