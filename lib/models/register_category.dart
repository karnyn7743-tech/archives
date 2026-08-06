import 'package:flutter/material.dart';

class RegisterCategory {
  final String title;
  final IconData icon;
  final String excelSheetName;
  final Color color;

  RegisterCategory({
    required this.title,
    required this.icon,
    required this.excelSheetName,
    this.color = Colors.indigo,
  });
}

final List<RegisterCategory> mainCategories = [
  RegisterCategory(title: 'سجل التعميمات والأوامر', icon: Icons.assignment, excelSheetName: 'Circulars'),
  RegisterCategory(title: 'سجل التكريمات والجزاءات', icon: Icons.military_tech, excelSheetName: 'Honors_Penalties'),
  RegisterCategory(title: 'سجل القيد والتسجيل', icon: Icons.app_registration, excelSheetName: 'Registration'),
  RegisterCategory(title: 'سجل المنقولين', icon: Icons.move_up, excelSheetName: 'Transferred_out'),
  RegisterCategory(title: 'سجل الحضور والانصراف', icon: Icons.badge, excelSheetName: 'Attendance'),
  RegisterCategory(title: 'سجل الوافدين', icon: Icons.person_add_alt_1, excelSheetName: 'Transferred_In'),
  RegisterCategory(title: 'سجل الزيارات', icon: Icons.groups, excelSheetName: 'Visits'),
  RegisterCategory(title: 'سجل المتسربين', icon: Icons.person_off, excelSheetName: 'Dropouts'),
  RegisterCategory(title: 'سجل العاملين', icon: Icons.engineering, excelSheetName: 'Staff'),
  RegisterCategory(title: 'سجلات الكنترول', icon: Icons.fact_check, excelSheetName: 'control'),
  RegisterCategory(title: 'سجل المبنى المدرسي', icon: Icons.domain, excelSheetName: 'School_Building'),
  RegisterCategory(title: 'سجلات التقارير', icon: Icons.analytics, excelSheetName: 'Reports'),
  RegisterCategory(title: 'سجل العُهد والصيانة', icon: Icons.build, excelSheetName: 'Assets_Maintenance'),
  RegisterCategory(title: 'سجلات الصادر والوارد', icon: Icons.swap_horiz, excelSheetName: 'Mail_Archive'),
  RegisterCategory(title: 'سجل المشاركة المجتمعية', icon: Icons.handshake, excelSheetName: 'Community_Share'),
  RegisterCategory(title: 'سجلات الترفيعات', icon: Icons.grade, excelSheetName: 'Promotions'),
  RegisterCategory(title: 'سجل أعمال سنة', icon: Icons.edit_calendar, excelSheetName: 'Year_Work'),
  RegisterCategory(title: 'سجلات المعيدين', icon: Icons.repeat, excelSheetName: 'Repeaters'),
];
