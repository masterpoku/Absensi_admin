import 'package:absensi_arduino_admin/source/source_db.dart';
import 'package:d_info/d_info.dart';
import 'package:d_input/d_input.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final controllerIdClass = TextEditingController();
  final controllerIdSiswa = TextEditingController();
  final controllerName = TextEditingController();

  registration() async {
    bool success = await SourceDB.registrationStudent({
      'id_class': controllerIdClass.text,
      'id_siswa': controllerIdSiswa.text,
      'name': controllerName.text,
    });
    if (success) {
      DInfo.dialogSuccess('Berhasil Registrasi');
      DInfo.closeDialog(actionAfterClose: () {
        Get.back(result: true);
      });
    } else {
      DInfo.dialogError('Gagal Registrasi');
      DInfo.closeDialog();
    }
  }

  iregistration() async {
    // ignore: unused_local_variable
    bool success = await SourceDB.registrationStudent({
      'id_class': controllerIdClass.text,
      'id_siswa': controllerIdSiswa.text,
      'name': controllerName,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text('Registrasi'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DInput(
            controller: controllerIdClass,
            title: 'ID Class (Contoh: 1A)',
          ),
          DView.spaceHeight(),
          DInput(
            controller: controllerIdSiswa,
            title: 'NISN Siswa',
          ),
          DView.spaceHeight(),
          DInput(
            controller: controllerName,
            title: 'Nama',
          ),
          DView.spaceHeight(),
          ElevatedButton(
            onPressed: () => registration(),
            child: const Text('SIMPAN'),
          ),
        ],
      ),
    );
  }
}
