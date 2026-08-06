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

// القائمة المعتمدة المحدثة (18 سجلاً)
final List<RegisterCategory> allArchiveCategories = [
  RegisterCategory(
    id: 'circulars',
    title: 'سجل التعميمات والأوامر',
    icon: Icons.campaign_rounded,
    color: Colors.redAccent,
    excelSheetName: 'التعميمات_والأوامر',
    columns: ['م', 'رقم التعميم', 'الجهة المصدرة', 'تاريخ التعميم', 'الموضوع', 'ملاحظات'],
  ),
  RegisterCategory(
    id: 'honors_penalties',
    title: 'سجل التكريمات والجزاءات',
    icon: Icons.emoji_events_rounded,
    color: Colors.amber,
    excelSheetName: 'التكريمات_والجزاءات',
    columns: ['م', 'الاسم', 'الصف/الوظيفة', 'نوع القرار (تكريم/جزاء)', 'السبب', 'التاريخ', 'ملاحظات'],
  ),
  RegisterCategory(
    id: 'enrollment',
    title: 'سجل القيد والتوزيع',
    icon: Icons.app_registration_rounded,
    color: Colors.blue,
    excelSheetName: 'القيد_والتوزيع',
    columns: ['م', 'رقم القيد', 'اسم الطالب', 'تاريخ الميلاد', 'الصف', 'اسم ولي الأمر', 'ملاحظات'],
  ),
  RegisterCategory(
    id: 'transfers',
    title: 'سجل المنقولين',
    icon: Icons.move_up_rounded,
    color: Colors.indigo,
    excelSheetName: 'المنقولين',
    columns: ['م', 'اسم الطالب', 'الصف', 'المدرسة المنقول إليها/منها', 'تاريخ النقل', 'ملاحظات'],
  ),
  RegisterCategory(
    id: 'attendance',
    title: 'سجل الحضور والانصراف',
    icon: Icons.access_time_filled_rounded,
    color: Colors.teal,
    excelSheetName: 'الحضور_والانصراف',
    columns: ['م', 'الاسم', 'التاريخ', 'وقت الحضور', 'وقت الانصراف', 'حالة التواجد', 'ملاحظات'],
  ),
  RegisterCategory(
    id: 'expatriates',
    title: 'سجل الوافدين',
    icon: Icons.flight_land_rounded,
    color: Colors.cyan,
    excelSheetName: 'الوافدين',
    columns: ['م', 'اسم الطالب', 'الجنسية', 'الدولة القادم منها', 'الصف', 'تاريخ الالتحاق', 'ملاحظات'],
  ),
  RegisterCategory(
    id: 'visitors',
    title: 'سجل الزيارات',
    icon: Icons.transfer_within_a_station_rounded,
    color: Colors.deepPurple,
    excelSheetName: 'الزيارات',
    columns: ['م', 'اسم الزائر', 'جهة العمل', 'سبب الزيارة', 'التاريخ', 'التوقيع', 'ملاحظات'],
  ),
  RegisterCategory(
    id: 'dropouts',
    title: 'سجل المتسربين',
    icon: Icons.person_off_rounded,
    color: Colors.blueGrey,
    excelSheetName: 'المتسربين',
    columns: ['م', 'اسم الطالب', 'الصف', 'تاريخ الانقطاع', 'سبب التسرب', 'إجراءات التواصل', 'ملاحظات'],
  ),
  RegisterCategory(
    id: 'staff',
    title: 'سجل العاملين',
    icon: Icons.badge_rounded,
    color: Colors.brown,
    excelSheetName: 'العاملين',
    columns: ['م', 'اسم الموظف', 'المسمى الوظيفي', 'التخصص', 'رقم الهاتف', 'تاريخ المباشرة', 'ملاحظات'],
  ),
  RegisterCategory(
    id: 'control_records',
    title: 'سجلات الكنترول',
    icon: Icons.fact_check_rounded,
    color: Colors.deepOrange,
    excelSheetName: 'الكنترول',
    columns: ['م', 'رقم الجلوس', 'اسم الطالب', 'الصف', 'المادة', 'الدرجة', 'الحالة', 'ملاحظات'],
  ),
  RegisterCategory(
    id: 'school_building',
    title: 'سجل المبنى المدرسي',
    icon: Icons.domain_rounded,
    color: Colors.green,
    excelSheetName: 'المبنى_المدرسي',
    columns: ['م', 'اسم القاعة/المرافق', 'حالة المرافق', 'الاحتياجات', 'آخر تاريخ فحص', 'ملاحظات'],
  ),
  RegisterCategory(
    id: 'reports',
    title: 'سجلات التقارير',
    icon: Icons.assessment_rounded,
    color: Colors.lightBlue,
    excelSheetName: 'التقارير',
    columns: ['م', 'عنوان التقرير', 'الجهة الموجه إليها', 'تاريخ الإعداد', 'ملخص التقرير', 'ملاحظات'],
  ),
  RegisterCategory(
    id: 'custody_maintenance',
    title: 'سجل العُهد والصيانة',
    icon: Icons.build_rounded,
    color: Colors.grey,
    excelSheetName: 'العُهد_والصيانة',
    columns: ['م', 'اسم العُهدة/الجهاز', 'المسؤول عنها', 'حالة الجهاز', 'تاريخ الصيانة', 'ملاحظات'],
  ),
  RegisterCategory(
    id: 'in_out_docs',
    title: 'سجلات الصادر والوارد',
    icon: Icons.swap_horiz_rounded,
    color: Colors.purple,
    excelSheetName: 'الصادر_والوارد',
    columns: ['م', 'النوع (صادر/وارد)', 'الرقم الإشاري', 'الجهة', 'التاريخ', 'الموضوع', 'ملاحظات'],
  ),
  RegisterCategory(
    id: 'community_partner',
    title: 'سجل المشاركة المجتمعية',
    icon: Icons.handshake_rounded,
    color: Colors.lightGreen,
    excelSheetName: 'المشاركة_المجتمعية',
    columns: ['م', 'اسم الشريك/المؤسسة', 'نوع الدعم/النشاط', 'التاريخ', 'المستفيدون', 'ملاحظات'],
  ),
  RegisterCategory(
    id: 'promotions',
    title: 'سجلات الترفيعات',
    icon: Icons.trending_up_rounded,
    color: Colors.pink,
    excelSheetName: 'الترفيعات',
    columns: ['م', 'اسم الطالب', 'الصف السابق', 'الصف المرفّع إليه', 'العام الدراسي', 'النتيجة', 'ملاحظات'],
  ),
  RegisterCategory(
    id: 'year_work',
    title: 'سجل أعمال سنة',
    icon: Icons.edit_calendar_rounded,
    color: Colors.orange,
    excelSheetName: 'أعمال_سنة',
    columns: ['م', 'اسم الطالب', 'الصف', 'المادة', 'درجة أعمال السنة', 'ملاحظات'],
  ),
  RegisterCategory(
    id: 'repeaters',
    title: 'سجلات المعيدين',
    icon: Icons.repeat_rounded,
    color: Colors.red,
    excelSheetName: 'المعيدين',
    columns: ['م', 'اسم الطالب', 'الصف', 'سنوات الإعادة', 'المواد المتبقية', 'ملاحظات'],
  ),
];
