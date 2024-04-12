import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bldapp/Colors.dart';
import 'package:bldapp/Provider/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class inventoryView extends StatefulWidget {
  inventoryView({
    Key? key,
    required this.id,
  }) : super(key: key);
  final String id;
  @override
  State<inventoryView> createState() => _inventoryViewState();
}

class _inventoryViewState extends State<inventoryView> {
  String searchQuery = '';
  TextEditingController text = TextEditingController();

  @override 
  Widget build(BuildContext context) {
        var _theme = Provider.of<ThemeProvider>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
            backgroundColor: _theme.isDarkMode? Colors.amber : background,

        onPressed: () {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.question,
            animType: AnimType.rightSlide,
            title: 'Are you sure to delete data ?',
            desc: 'The data will be completely erased from the application',
            btnCancelOnPress: () {},
            btnOkOnPress: () async {
              final collectionReference =
                  FirebaseFirestore.instance.collection('inventoryTable');

              final documents = await collectionReference.get();

              for (var document in documents.docs) {
                await document.reference.delete();
              }
            },
          )..show();
        },
        child: Icon(Icons.delete,color:  _theme.isDarkMode? background: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            children: [
              DateHeader(
                onChanged: (p0) => searchFunc(p0),
                onTap: () {
                  text.clear();
                  searchFunc('');
                },
                searchController: text,
              ),
              const SizedBox(height: 20),
              Expanded(
                  child: SingleChildScrollView(
                child: StreamBuilder<List<QueryDocumentSnapshot>>(
                  stream: FirebaseFirestore.instance
                      .collection('inventoryTable')
                      .where('id', isEqualTo: widget.id)
                      .snapshots()
                      .map((snapshot) => snapshot.docs),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Something went wrong'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: LinearProgressIndicator());
                    }

                    List<QueryDocumentSnapshot> dataList = snapshot.data!;

                    if (searchQuery.isNotEmpty) {
                      dataList = dataList.where((document) {
                        Map<String, dynamic> dataItem =
                            document.data() as Map<String, dynamic>;
                        String serialNumber =
                            dataItem['serialNumber'].toString();
                        return serialNumber
                            .toLowerCase()
                            .contains(searchQuery.toLowerCase());
                      }).toList();
                    }

                    return DataTable(
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Text(
                            'Blood Type',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.amber,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Date',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.amber,
                                                            fontWeight: FontWeight.bold

                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Serial Num',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.amber,
                                                            fontWeight: FontWeight.bold

                            ),
                          ),
                        ),
                      ],
                      rows: dataList.map((DocumentSnapshot document) {
                        Map<String, dynamic> dataItem =
                            document.data() as Map<String, dynamic>;
                        return DataRow(
                          cells: [
                            DataCell(Row(
                              children: [
                                dataItem['process'] == 'add'
                                    ? Icon(Icons.arrow_forward,
                                        color: Colors.green)
                                    : Icon(
                                        Icons.arrow_back,
                                        color: Colors.red,
                                      ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(dataItem['bloodType'].toString()),
                              ],
                            )),
                            DataCell(Text(dataItem['UpdatedDate'])),
                            DataCell(Text(dataItem['serialNumber'])),
                          ],
                        );
                      }).toList(),
                    );
                  },
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  void searchFunc(String query) {
    setState(() {
      searchQuery = query;
    });
  }
}

// ignore: must_be_immutable
class DateHeader extends StatefulWidget {
  TextEditingController? searchController;
  void Function(String)? onChanged;
  Function()? onTap;
  DateHeader(
      {super.key,
      required this.onChanged,
      required this.searchController,
      this.onTap});

  @override
  _DateHeaderState createState() => _DateHeaderState();
}

class _DateHeaderState extends State<DateHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isSearchVisible = false;
  @override
  void initState() {
    super.initState();
    widget.searchController = TextEditingController();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    widget.searchController!.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MMMM yyyy').format(now);
    String dayYear = DateFormat('dd').format(now);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_today, ),
                    SizedBox(width: 20),
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _animation.value,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                formattedDate,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                dayYear,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(width: 10),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearchVisible = !_isSearchVisible;
                });
              },
            ),
          ],
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: _isSearchVisible ? 60 : 0,
          curve: Curves.easeInOut,
          child: _isSearchVisible
              ? Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          onChanged: widget.onChanged,
                          onTap: widget.onTap,
                          controller: widget.searchController,
                          decoration: InputDecoration(
                            hintText: 'Search',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : null,
        ),
      ],
    );
  }
}
