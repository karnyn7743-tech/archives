import 'package:flutter/material.dart';

class RegisterCategory {
  final String id;
  final String title;
  final IconData icon;
  final Color color;
  final String excelSheetName;
  final List<String> columns;

  RegisterCategory({
    required this.id,
    required this.title,
    required this.icon,
    this.color = Colors.indigo,
    required this.excelSheetName,
    required this.columns,
  });
}

// قائمة السجلات التوضيحية
final List<RegisterCategory> mainCategories = [
  RegisterCategory(
    id: 'year_work',
    title: 'سجل أعمال سنة',
    icon: Icons.edit_calendar,
    color: Colors.teal,
    excelSheetName: 'Year_Work',
    columns: ['م', 'الاسم', 'درجة الأعمال', 'ملاحظات'],
  ),
  RegisterCategory(
    id: 'repeaters',
    title: 'سجلات المعيدين',
    icon: Icons.repeat,
    color: Colors.orange,
    excelSheetName: 'Repeaters',
    columns: ['م', 'اسم الطالب', 'الصف السابق', 'حالة الإعادة', 'ملاحظات'],
  ),
];
