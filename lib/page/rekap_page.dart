import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/var.dart';
import '../source/source_db.dart';

class RekapPage extends StatefulWidget {
  const RekapPage({Key? key, required this.idClass}) : super(key: key);
  final String idClass;

  @override
  State<RekapPage> createState() => _RekapPageState();
}

class _RekapPageState extends State<RekapPage> {
  RxBool loading = false.obs;
  List listStudent = [];
  getToday() async {
    loading.value = true;
    listStudent = await SourceDB.getRekapKehadiran(widget.idClass);
    setState(() {});
    loading.value = false;
  }

  @override
  void initState() {
    getToday();
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'REKAP KEHADIRAN KELAS ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  widget.idClass,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Material(
            elevation: 2,
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.black87,
                radius: 16,
                child: Text(
                  'No',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              horizontalTitleGap: 0,
              title: Row(
                children: const [
                  Expanded(
                    child: Text(
                      'Nama',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    'Hadir',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (loading.value) return DView.loadingCircle();
              return listStudent.isEmpty
                  ? DView.empty('Belum ada data kehadiran')
                  : ListView.separated(
                      padding: const EdgeInsets.all(0),
                      itemCount: listStudent.length,
                      itemBuilder: (context, index) {
                        Map item = listStudent[index];
                        return ListTile(
                          onTap: () {
                            Get.dialog(
                              AlertDialog(
                                title: const Text('Password'),
                                content: Text(
                                  '${item['password']}',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: const Text('Tutup'),
                                  ),
                                ],
                              ),
                              barrierDismissible: false,
                            );
                          },
                          leading: CircleAvatar(
                            radius: 16,
                            child: Text('${index + 1}'),
                          ),
                          horizontalTitleGap: 0,
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(item['name']),
                              ),
                              Text(item['absen_count'].toString()),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        endIndent: 16,
                        indent: 16,
                      ),
                    );
            }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                child: const Text('KEMBALI'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
