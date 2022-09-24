import 'package:absensi_arduino_admin/page/rekap_page.dart';
import 'package:absensi_arduino_admin/source/source_db.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/var.dart';

class ClassPage extends StatefulWidget {
  const ClassPage({Key? key, required this.idClass}) : super(key: key);
  final String idClass;

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  RxBool loading = false.obs;
  List listStudent = [];
  getToday() async {
    loading.value = true;
    listStudent = await SourceDB.getStudentPerClass(widget.idClass);
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
                  'KELAS ',
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
                    'Jam Masuk',
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
                  ? DView.empty('Belum ada absen untuk hari ini')
                  : ListView.separated(
                      padding: const EdgeInsets.all(0),
                      itemCount: listStudent.length,
                      itemBuilder: (context, index) {
                        Map item = listStudent[index];
                        String jamMasuk =
                            item['absensi']['time'] ?? 'Tidak Masuk';
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
                          tileColor: jamMasuk == 'Tidak Masuk'
                              ? Colors.red[300]
                              : null,
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(item['name']),
                              ),
                              Text(jamMasuk),
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
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () =>
                    Get.to(() => RekapPage(idClass: widget.idClass)),
                child: const Text('REKAP KEHADIRAN'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
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
