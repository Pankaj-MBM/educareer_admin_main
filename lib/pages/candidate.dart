import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

class Candidates extends StatefulWidget {
  const Candidates({super.key});

  @override
  _CandidatesState createState() => _CandidatesState();
}

class _CandidatesState extends State<Candidates> {
  final MyData _myData = MyData();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Candidates'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: SizedBox(
                width: 200,
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                  ),
                  onChanged: (query) {
                    setState(() {
                      _myData.filterData(query);
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: PaginatedDataTable2(
          source: _myData,
          columns: const [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Mail-Id')),
            DataColumn(label: Text('Phone No')),
            DataColumn(label: Text('Role')),
            DataColumn(label: Text('Exprience'), numeric: true),
          ],
          columnSpacing: 12,
          horizontalMargin: 12,
          rowsPerPage: 10,
          availableRowsPerPage: const [5, 10, 20],
          onRowsPerPageChanged: (rowsPerPage) {
            setState(() {
              _myData.notifyListeners();
            });
          },
          showCheckboxColumn: false,
        ),
      ),
    );
  }
}

class MyData extends DataTableSource {
  final List<Map<String, dynamic>> data = List.generate(
    100,
        (index) => {
      'columnA': 'A' * (10 - index % 10),
      'columnB': 'B' * (10 - (index + 5) % 10),
      'columnC': 'C' * (15 - (index + 5) % 10),
      'columnD': 'D' * (15 - (index + 10) % 10),
      'numbers': ((index + 0.1) * 25.4).toString()
    },
  );

  late List<Map<String, dynamic>> filteredData;

  MyData() {
    filteredData = List.from(data);
  }

  void filterData(String query) {
    if (query.isEmpty) {
      filteredData = List.from(data);
    } else {
      filteredData = data
          .where((row) =>
          row.values.any((value) => value.toString().contains(query)))
          .toList();
    }
    notifyListeners();
  }

  @override
  DataRow? getRow(int index) {
    final row = filteredData[index];
    return DataRow(cells: [
      DataCell(Text(row['columnA'])),
      DataCell(Text(row['columnB'])),
      DataCell(Text(row['columnC'])),
      DataCell(Text(row['columnD'])),
      DataCell(Text(row['numbers'])),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => filteredData.length;

  @override
  int get selectedRowCount => 0;
}


