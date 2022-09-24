import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/var.dart';
import '../source/source_db.dart';
import 'class_page.dart';
import 'registration_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> class1 = [];
  List<String> class2 = [];
  List<String> class3 = [];
  List<Map> listClass = [
    {'class': '1', 'expand': true},
    {'class': '2', 'expand': false},
    {'class': '3', 'expand': false},
  ];

  getClass() async {
    Set<String> allClass = await SourceDB.getClass();
    class1 = allClass.where((e) => e.contains('1')).toList();
    class2 = allClass.where((e) => e.contains('2')).toList();
    class3 = allClass.where((e) => e.contains('3')).toList();
    setState(() {});
  }

  @override
  void initState() {
    getClass();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: DView.nothing(),
        leadingWidth: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset(AppAsset.icSchool, height: 30),
            const Icon(Icons.school),
            DView.spaceWidth(),
            const Text(
              Var.schollName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      floatingActionButton: ButtonBar(
        children: [
          FloatingActionButton(
            heroTag: 'refresh',
            onPressed: () => getClass(),
            tooltip: 'Refresh',
            child: const Icon(Icons.refresh),
          ),
          FloatingActionButton(
            heroTag: 'registration',
            onPressed: () {
              Get.to(() => const RegistrationPage())?.then((value) {
                if (value ?? false) getClass();
              });
            },
            tooltip: 'Registrasi',
            child: const Icon(Icons.add),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => getClass(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 70),
            child: ExpansionPanelList(
              expansionCallback: (panelIndex, isExpanded) {
                setState(() {
                  listClass[panelIndex]['expand'] =
                      !listClass[panelIndex]['expand'];
                });
              },
              children: listClass.map((e) {
                List<String> listData = e['class'] == '1'
                    ? class1
                    : e['class'] == '2'
                        ? class2
                        : class3;
                listData.sort();
                return ExpansionPanel(
                  canTapOnHeader: true,
                  isExpanded: e['expand'],
                  backgroundColor: Colors.blue[800],
                  headerBuilder: (context, isExpanded) {
                    return ListTile(
                      title: Center(
                        child: Transform.translate(
                          offset: const Offset(30, 0),
                          child: Text('KELAS ${e['class']}'),
                        ),
                      ),
                      textColor: Colors.white,
                      iconColor: Colors.white,
                    );
                  },
                  body: listData.isEmpty
                      ? DView.nothing()
                      : Material(
                          color: Colors.grey[300],
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: listData.length,
                            padding: const EdgeInsets.all(16),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 8,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Get.to(() =>
                                      ClassPage(idClass: listData[index]));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 2),
                                    color: Colors.yellow,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    listData[index].substring(1),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
