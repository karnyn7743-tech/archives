import 'package:flutter/material.dart';
import 'register_category.dart';

// نموذج وهمي يمثل الوثيقة المخزنة
class ArchiveDocument {
  final int id;
  final String title;
  final String date;
  final String categoryName;
  final bool isArchived; // هل تم رفع الـ PDF أم لا
  final String? pdfPath;

  ArchiveDocument({
    required this.id,
    required this.title,
    required this.date,
    required this.categoryName,
    required this.isArchived,
    this.pdfPath,
  });
}

class SearchPreviewScreen extends StatefulWidget {
  final RegisterCategory category;

  const SearchPreviewScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<SearchPreviewScreen> createState() => _SearchPreviewScreenState();
}

class _SearchPreviewScreenState extends State<SearchPreviewScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  // بيانات تجريبية محاكاة لبيانات الإكسل
  final List<ArchiveDocument> _allDocuments = [
    ArchiveDocument(id: 103, title: 'مذكرة نقل الطالب أحمد علي', date: '2026/08/05', categoryName: 'سجل المنقولين', isArchived: true, pdfPath: 'doc_103.pdf'),
    ArchiveDocument(id: 102, title: 'إشعار انتقال مدرسة الفاروق', date: '2026/08/02', categoryName: 'سجل المنقولين', isArchived: true, pdfPath: 'doc_102.pdf'),
    ArchiveDocument(id: 101, title: 'طلب تحويل ملف طالب', date: '2026/07/28', categoryName: 'سجل المنقولين', isArchived: false),
  ];

  List<ArchiveDocument> _filteredDocuments = [];

  @override
  void initState() {
    super.initState();
    _filteredDocuments = _allDocuments;
  }

  void _filterSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredDocuments = _allDocuments;
      } else {
        _filteredDocuments = _allDocuments
            .where((doc) =>
                doc.title.contains(query) ||
                doc.date.contains(query) ||
                doc.id.toString().contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('سجل: ${widget.category.title}'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [
              // 1. حقل البحث السريع
              TextField(
                controller: _searchController,
                onChanged: _filterSearch,
                decoration: InputDecoration(
                  hintText: 'ابحث بكلمة، اسم، أو تاريخ الوثيقة...',
                  prefixIcon: const Icon(Icons.search, color: Colors.indigo),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _filterSearch('');
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),

              const SizedBox(height: 16),

              // 2. إحصائية سريعة لنتائج البحث
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'إجمالي النتائج: ${_filteredDocuments.length}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  const Text(
                    'مرتب من الأحدث للأقدم',
                    style: TextStyle(fontSize: 12, color: Colors.indigo),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // 3. قائمة نتائج الوثائق الموثقة وغير الموثقة
              Expanded(
                child: _filteredDocuments.isEmpty
                    ? const Center(child: Text('لا توجد وثائق تطابق البحث'))
                    : ListView.builder(
                        itemCount: _filteredDocuments.length,
                        itemBuilder: (context, index) {
                          final doc = _filteredDocuments[index];
                          return _buildDocumentCard(doc);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentCard(ArchiveDocument doc) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade50,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'رقم الأرشيف: #${doc.id}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      doc.date,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
                // شارة حالة التوثيق
                Chip(
                  avatar: Icon(
                    doc.isArchived ? Icons.check_circle : Icons.warning_amber_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                  label: Text(
                    doc.isArchived ? 'موثقة' : 'غير موثقة',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  backgroundColor: doc.isArchived ? Colors.teal : Colors.orange.shade800,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              doc.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (doc.isArchived)
                  ElevatedButton.icon(
                    onPressed: () {
                      // فتح عرض الـ PDF
                    },
                    icon: const Icon(Icons.picture_as_pdf, size: 18),
                    label: const Text('عرض الوثيقة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                      foregroundColor: Colors.white,
                      visualDensity: VisualDensity.compact,
                    ),
                  )
                else
                  OutlinedButton.icon(
                    onPressed: () {
                      // إكمال التوثيق ورفع الملف
                    },
                    icon: const Icon(Icons.upload_file, size: 18),
                    label: const Text('إكمال التوثيق الآن'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.orange.shade900,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
