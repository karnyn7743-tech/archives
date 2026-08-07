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
    required this.color,
    required this.excelSheetName,
    required this.columns,
  });
}

final List<RegisterCategory> allArchiveCategories = [
  RegisterCategory(
    id: 'circulars',
    title: 'سجل التعميمات والأوامر',
    icon: Icons.campaign_rounded,
    color: Colors.redAccent,
    excelSheetName: 'التعميمات_والأوامر',
    columns: ['م', 'موضوع التعميم', 'تاريخه', 'الجهة المصدرة للتعميم', 'الوجهة ', 'نسبة التنفيذ', 'المسؤول عن التنفيذ', 'ملاحظات'],
  ),
  RegisterCategory(
    id: 'honors_penalties',
    title: 'سجل التكريمات والجزاءات',
    icon: Icons.emoji_events_rounded,
    color: Colors.amber,
    excelSheetName: 'التكريمات_والجزاءات',
    columns: ['م', 'نوع التكريم', 'اسم المكرم', 'القائم بالتكريم', 'تاريخ التكريم', 'العام الدراسي المكرم عليه', 'المهمة التي بسببها تم تكريمه', 'ملاحظات'],
  ),
  RegisterCategory(
    id: 'enrollment',
    title: 'سجل القيد والتوزيع',
    icon: Icons.app_registration_rounded,
    color: Colors.blue,
    excelSheetName: 'القيد_والتوزيع',
    columns: ['م', 'اسم الطالب', 'الصف', 'الجنس', 'المدرسة ', 'المديرية', 'المحافظة', 'الحالة', 'تاريخ الميلاد يوم', 'الميلاد شهر', 'الميلاد سنة', 'مديرية', 'محافظة', 'الفترة الدراسية', 'ملاحظات'],
  ),
  RegisterCategory(
    id: 'transfers',
    title: 'سجل المنقولين',
    icon: Icons.move_up_rounded,
    color: Colors.indigo,
    excelSheetName: 'المنقولين',
    columns: ['م', 'اسم الطالب', 'آخر صف درسه', 'العام الدراسي', 'الوجهة التي إنتقل إليها', 'السبب', 'تاريخ النقل', 'ملاحظات'],
  ),
  RegisterCategory(
    id: 'attendance',
    title: 'سجل الحضور والإنصراف',
    icon: Icons.access_time_filled_rounded,
    color: Colors.teal,
    excelSheetName: 'الحضور_والإنصراف',
    columns: ['م', 'الفصل الدراسي', 'العام الدراسي', 'تاريخ الأرشفة', 'ملاحظات'],
  ),
  RegisterCategory(
    id: 'expatriates',
    title: 'سجل الوافدين',
    icon: Icons.flight_land_rounded,
    color: Colors.cyan,
    excelSheetName: 'الوافدين',
    columns: ['م', 'اسم الطالب', 'الصف', 'الجنس', 'المدرسة ', 'المديرية', 'المحافظة', 'ميلاد يوم', 'ميلاد شهر', 'ميلاد سنة', 'مديرية', 'محافظة', 'عدد الوثائق', 'اسماء الوثائق', 'العام الدراسي', 'ملاحظات'],
  ),
  RegisterCategory(
    id: 'visitors',
    title: 'سجل الزيارات',
    icon: Icons.transfer_within_a_station_rounded,
    color: Colors.deepPurple,
    excelSheetName: 'الزيارات',
    columns: ['م', 'اسم ابزائر', 'صفته', 'الوجهة التي أرسلته', 'تاريخ الزيارة', 'المهمة المكلف بها', 'التقييم', 'ملاحظات'],
  ),
  RegisterCategory(
    id: 'dropouts',
    title: 'سجل المتسربين',
    icon: Icons.person_off_rounded,
    color: Colors.blueGrey,
    excelSheetName: 'المتسربين',
    columns: ['م', 'اسم الطالب', 'الصف الذي أكمله', 'الجنس', 'العام الدراسي', 'سبب التسرب', 'نتائج التواصل مع أهله ليعود للدراسة', 'ملاحظات'],
  ),
  RegisterCategory(
    id: 'staff',
    title: 'سجل العاملين',
    icon: Icons.badge_rounded,
    color: Colors.brown,
    excelSheetName: 'العاملين',
    columns: ['م', 'الاسم', 'الرقم المالي', 'الحالة الوظيفية', 'تاريخ الميلاد', 'نوع البطاقة', 'مصدرها', 'رقمها', 'تاريخها', 'المؤهل', 'نوعه', 'تاريخه', 'عمله في المؤسسة', 'ملاحظات'],
  ),
  RegisterCategory(
    id: 'control_records',
    title: 'سجلات الكنترول',
    icon: Icons.fact_check_rounded,
    color: Colors.deepOrange,
    excelSheetName: 'الكنترول',
    columns: ['م', 'الموضوع ', 'التاريخ', 'نسبة التنفيذ', 'العام الدراسي', 'القائم بالمهمة', 'ملاحظات'],
  ),
  RegisterCategory(
    id: 'school_building',
    title: 'سجل المبنى المدرسي',
    icon: Icons.domain_rounded,
    color: Colors.green,
    excelSheetName: 'المبنى_المدرسي',
    columns: ['م', 'نوع الوثيقة', 'مصدرها', 'وجهتها', 'تاريخها', 'المسؤول عن التعاطي معها', 'نتيجة التنفيذ', 'ملاحظات'],
  ),
  RegisterCategory(
    id: 'reports',
    title: 'سجلات التقارير',
    icon: Icons.assessment_rounded,
    color: Colors.lightBlue,
    excelSheetName: 'التقارير',
    columns: ['م', 'موضوع التقرير', 'معد التقرير', 'نسبة التعاطي مع التقرير ', 'تاريخه', 'المسؤول عن التعامل معه', 'ملاحظات'],
  ),
  RegisterCategory(
    id: 'custody_maintenance',
    title: 'سجل العُهد والصيانة',
    icon: Icons.build_rounded,
    color: Colors.grey,
    excelSheetName: 'العهد_والصيانة',
    columns: ['م', 'تاريخ الجرد أو الضم إلى ممتلكات المدرسة', 'المصدر', 'الحالة', 'ملاحظات'],
  ),
  RegisterCategory(
    id: 'in_out_docs',
    title: 'سجلات الصادر والوارد',
    icon: Icons.swap_horiz_rounded,
    color: Colors.purple,
    excelSheetName: 'الصادر_والوارد',
    columns: ['م', 'نوع الوثيقة', 'الموضوع', 'نتيجة التعامل معها أو نسبة نجاح إرسالها', 'التاريخ', 'الغرض', 'المصدر', 'الوجهة', 'ملاحظات'],
  ),
  RegisterCategory(
    id: 'community_partner',
    title: 'سجل المشاركة المجتمعية',
    icon: Icons.handshake_rounded,
    color: Colors.lightGreen,
    excelSheetName: 'المشاركات_المجتمعية',
    columns: ['م', 'نوع المشاركة', 'المساهم فيها', 'الغرض', 'العام الدراسي', 'النتائج', 'ملاحظات'],
  ),
  RegisterCategory(
    id: 'promotions',
    title: 'سجلات الترفيعات',
    icon: Icons.trending_up_rounded,
    color: Colors.pink,
    excelSheetName: 'الترفيعات',
    columns: ['م', 'اسم الطالب', 'المواد التي تم ترفيعه فيها', 'العام الدراسي', 'ملاحظات'],
  ),
  RegisterCategory(
    id: 'year_work',
    title: 'سجل أعمال سنة',
    icon: Icons.edit_calendar_rounded,
    color: Colors.orange,
    excelSheetName: 'أعمال_السنة',
    columns: ['م', 'اسم المعلم', 'المواد التي يدرسها', 'العام الدراسي', 'التقييم', 'ملاحظات'],
  ),
  RegisterCategory(
    id: 'repeaters',
    title: 'سجلات المعيدين',
    icon: Icons.repeat_rounded,
    color: Colors.red,
    excelSheetName: 'المعيدين',
    columns: ['م', 'اسم الطالب', 'الصف', 'العام الدراسي', 'الحالة', 'ملاحظات'],
  ),
];
