
import 'package:flutter/material.dart';
import 'package:noise_detector_str/controller/realtime_db_controller.dart';
import 'package:noise_detector_str/model/NoiseModel.dart';
import 'package:noise_meter/noise_meter.dart';
import 'table_data_view/data.csv.dart';


class DatatableView extends StatefulWidget {
  static route({Key? key}) =>
      MaterialPageRoute(builder: (context) => DatatableView(key: key));

  const DatatableView({super.key});

  //static const String routeName = '/data-table';

  @override
  State<DatatableView> createState() => _DatatableViewState();
}

class _DatatableViewState extends State<DatatableView> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int? _sortColumnIndex;
  bool _sortAscending = true;
  late final DoctorDataSource _doctorsDataSource; // = DoctorDataSource();

  RealtimeDataController realtimeData = RealtimeDataController();

  //TransferProtocol http = const TransferProtocol("https://exploress.space/api/doctor-sample/csv");

  void loadData() async {
    var query = await realtimeData.messagesRef.once();
    var data = query.snapshot.value;
    _doctorsDataSource = DoctorDataSource(data: null);
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void _sort<T>(
      Comparable<T> Function(NoiseModel d) getField,
      int columnIndex,
      bool ascending,
      ) {
    _doctorsDataSource.sort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  Future<List<Map<String, dynamic>>> load() async {
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    /*final ScrollController scrollController = ScrollController(
      debugLabel: 'scrollDoctors',
    );*/

    return Scaffold(
      appBar: AppBar(
        title: const Text('Données sur les docteurs'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
          future: load(), //as List<Map<String, String>>,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
              // Afficher un indicateur de chargement en attendant que les données soient récupérées
            }

            else if (!snapshot.hasData) {
              return const Center(
                  child: SizedBox(
                    height: 200,
                    child: Column(children: [
                      Icon(Icons.do_not_disturb_alt),
                      Text("")
                    ],),
                  )
              );
            }

            return SingleChildScrollView(
              //controller: scrollController,
              padding: const EdgeInsets.all(20.0),
              child: PaginatedDataTable(

                header: const Text('Docteurs'),
                actions: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.link,
                    ),
                  ),
                  IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () async {
                        /*Go.of(context).to(
                        routeName: AddDoctorPage.routeName,
                      );*/
                      }),
                ],
                rowsPerPage: _rowsPerPage,
                onRowsPerPageChanged: (int? value) {
                  setState(() {
                    _rowsPerPage = value!;
                  });
                },
                sortColumnIndex: _sortColumnIndex,
                sortAscending: _sortAscending,
                onSelectAll: _doctorsDataSource.selectAll,
                availableRowsPerPage: const <int>[10, 20, 40],
                columns: <DataColumn>[
                  DataColumn(
                    label: const Text('Nom Complet'),
                    onSort: (int columnIndex, bool ascending) => _sort<String>(
                        (NoiseModel d) => d.deviceName, columnIndex, ascending),
                  ),
                  DataColumn(
                    label: const Text('Sex'),
                    //numeric: true,
                    onSort: (int columnIndex, bool ascending) => _sort<String>(
                        (NoiseModel d) => d.noiseValue, columnIndex, ascending),
                  ),
                  DataColumn(
                    label: const Text('Speciality'),
                    onSort: (int columnIndex, bool ascending) => _sort<String>(
                        (NoiseModel d) => d.dateTime, columnIndex, ascending),
                  ),
                ],
                source: _doctorsDataSource,
              ),
            );
          }),
    );
  }
}






class DoctorDataSource extends DataTableSource {
  final List<NoiseModel> _doctors;
  DoctorDataSource({required data}) : _doctors = data
      .map((final Map<String, dynamic> map) => NoiseModel.fromMap(map))
      .toList();



  void sort<T>(Comparable<T> Function(NoiseModel d) getField, bool ascending) {
    _doctors.sort((NoiseModel a, NoiseModel b) {
      if (!ascending) {
        final NoiseModel c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    notifyListeners();
  }

  int _selectedCount = 0;

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= _doctors.length) return null;
    final NoiseModel noise = _doctors[index];
    return DataRow.byIndex(
      index: index,
      selected: noise.selected!,
      onSelectChanged: (bool? value) {
        if (noise.selected != value) {
          _selectedCount += value! ? 1 : -1;
          assert(_selectedCount >= 0);
          noise.selected = value;
          notifyListeners();
        }
      },
      cells: <DataCell>[
        DataCell(
          Text("${noise.deviceName} "),
        ),
        DataCell(Text(noise.noiseValue)),
        DataCell(Text(noise.dateTime)),
      ],
    );
  }

  @override
  int get rowCount => _doctors.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  void selectAll(bool? checked) {
    for (final NoiseModel noise in _doctors) {
      noise.selected = checked;
    }
    _selectedCount = checked! ? _doctors.length : 0;
    notifyListeners();
  }
}

