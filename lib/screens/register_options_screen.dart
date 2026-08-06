import 'package:flutter/material.dart';
import 'register_category.dart';

class RegisterOptionsScreen extends StatelessWidget {
  final RegisterCategory category;

  const RegisterOptionsScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6F9),
        appBar: AppBar(
          title: Text(category.title),
          centerTitle: true,
          elevation: 1,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // كارت الترويسة المخصص للسجل
              _buildHeaderCard(),

              const SizedBox(height: 24),

              // الخيارات الرئيسية (أرشفة جديدة / استعراض)
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      context: context,
                      title: 'أرشفة وثيقة جديدة',
                      subtitle: 'مسح ضوئي وإدخال',
                      icon: Icons.add_a_photo,
                      color: Colors.teal,
                      onTap: () {
                        // الانتقال لشاشة الإدخال والمسح الضوئي (الشاشة الثالثة)
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionButton(
                      context: context,
                      title: 'استعراض وبحث',
                      subtitle: 'عرض وتفتيش السجل',
                      icon: Icons.manage_search,
                      color: Colors.indigo,
                      onTap: () {
                        // الانتقال لشاشة البحث والاستعراض (الشاشة الرابعة)
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ترويسة قائمة أحدث الموثقات
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'أحدث الوثائق الموثقة',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'عرض الكل',
                    style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.w600),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // قائمة أحدث الوثائق
              Expanded(
                child: ListView.builder(
                  itemCount: 3, // نموذج لعرض أحدث 3 وثائق
                  itemBuilder: (context, index) {
                    return _buildRecentDocumentCard(index + 1);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // الترويسة العلوية
  Widget _buildHeaderCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [category.color, category.color.withOpacity(0.8)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white24,
              child: Icon(category.icon, size: 35, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ورقة العمل: ${category.excelSheetName}',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // كارت زر الأوامر
  Widget _buildActionButton({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Column(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: color.withOpacity(0.12),
                child: Icon(icon, size: 28, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // كارت الوثيقة الحديثة
  Widget _buildRecentDocumentCard(int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey.shade200,
          child: Text('#$index', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        ),
        title: Text('وثيقة رقم $index'),
        subtitle: const Text('تاريخ التوثيق: 2026/08/06'),
        trailing: const Icon(Icons.picture_as_pdf, color: Colors.red),
        onTap: () {
          // فتح ملف الـ PDF
        },
      ),
    );
  }
}
