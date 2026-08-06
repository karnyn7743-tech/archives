import 'package:flutter/material.dart';
import '../models/register_category.dart';

class SearchPreviewScreen extends StatefulWidget {
  final RegisterCategory category;

  const SearchPreviewScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<SearchPreviewScreen> createState() => _SearchPreviewScreenState();
}

class _SearchPreviewScreenState extends State<SearchPreviewScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  // نموذج لبيانات توضيحية مؤقتة لعرض شكل الجدول
  final List<Map<String, String>> _mockData = [];

  @override
  void initState() {
    super.initState();
    _generateMockData();
  }

  void _generateMockData() {
    // صف توضيحي متوافق مع رؤوس الأعمدة
    Map<String, String> row = {};
    for (var col in widget.category.columns) {
      if (col == 'م') {
        row[col] = '1';
      } else {
        row[col] = 'بيان توضيحي';
      }
    }
    _mockData.add(row);
  }

  void _exportToExcel() {
    // هنا يتم استدعاء دالة حفظ ملف الإكسل باسم الورقة المحدد
    final sheetName = widget.category.excelSheetName;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('جاري تصدير السجل إلى ورقة: $sheetName.xlsx')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('سجلات: ${widget.category.title}'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.description_outlined),
              tooltip: 'تصدير إلى Excel',
              onPressed: _exportToExcel,
            ),
          ],
        ),
        body: Column(
          children: [
            // شريط البحث
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'بحث في ${widget.category.title}...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),
            
            // جدول عرض البيانات الديناميكي
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(
                      widget.category.color.withOpacity(0.15),
                    ),
                    // رؤوس الأعمدة الديناميكية
                    columns: widget.category.columns.map((colName) {
                      return DataColumn(
                        label: Text(
                          colName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: widget.category.color,
                          ),
                        ),
                      );
                    }).toList(),
                    // صفوف البيانات
                    rows: _mockData.map((dataRow) {
                      return DataRow(
                        cells: widget.category.columns.map((colName) {
                          return DataCell(
                            Text(dataRow[colName] ?? '-'),
                          );
                        }).toList(),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
