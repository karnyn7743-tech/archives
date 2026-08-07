import 'dart:io';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart' hide Border;
import 'package:path_provider/path_provider.dart';
import '../models/register_category.dart';

class SearchPreviewScreen extends StatefulWidget {
  final RegisterCategory category;

  const SearchPreviewScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<SearchPreviewScreen> createState() => _SearchPreviewScreenState();
}

class _SearchPreviewScreenState extends State<SearchPreviewScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _allRecords = [];
  List<Map<String, String>> _filteredRecords = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDataFromExcel();
  }

  Future<void> _loadDataFromExcel() async {
    try {
      Directory? externalDir = await getExternalStorageDirectory();
      String newPath = "";
      List<String> paths = externalDir!.path.split("/");
      for (int x = 1; x < paths.length; x++) {
        String folder = paths[x];
        if (folder != "Android") {
          newPath += "/" + folder;
        } else {
          break;
        }
      }

      final filePath = '$newPath/Documents/archives/Archives.xlsx';
      final file = File(filePath);

      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        final excel = Excel.decodeBytes(bytes);
        final sheet = excel[widget.category.excelSheetName];

        List<Map<String, String>> loaded = [];

        if (sheet.maxRows > 1) {
          for (int i = 1; i < sheet.maxRows; i++) {
            var row = sheet.row(i);
            Map<String, String> rowMap = {};
            for (int j = 0; j < widget.category.columns.length; j++) {
              String colName = widget.category.columns[j];
              String cellVal = (j < row.length && row[j] != null) ? row[j]!.value.toString() : '';
              rowMap[colName] = cellVal;
            }
            loaded.add(rowMap);
          }
        }

        setState(() {
          _allRecords = loaded;
          _filteredRecords = loaded;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterResults(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        _filteredRecords = _allRecords;
      });
      return;
    }

    final lowerQuery = query.toLowerCase();
    setState(() {
      _filteredRecords = _allRecords.where((record) {
        return record.values.any((value) => value.toLowerCase().contains(lowerQuery));
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('سجلات: ${widget.category.title}'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _searchController,
                onChanged: _filterResults,
                decoration: InputDecoration(
                  hintText: 'بحث في ${widget.category.title}...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredRecords.isEmpty
                      ? const Center(child: Text('لا توجد سجلات مطابقة للبحث'))
                      : SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              headingRowColor: MaterialStateProperty.all(
                                widget.category.color.withOpacity(0.15),
                              ),
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
                              rows: _filteredRecords.map((dataRow) {
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
