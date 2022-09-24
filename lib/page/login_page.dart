import 'package:absensi_arduino_admin/config/var.dart';
import 'package:absensi_arduino_admin/page/home_page.dart';
import 'package:absensi_arduino_admin/source/source_auth.dart';
import 'package:d_info/d_info.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/app_asset.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  login() async {
    bool success =
        await SourceAuth.login(controllerEmail.text, controllerPassword.text);
    if (success) {
      DInfo.dialogSuccess('Berhasil Masuk');
      DInfo.closeDialog(actionAfterClose: () {
        Get.to(() => const HomePage());
      });
    } else {
      DInfo.dialogError('Gagal Masuk');
      DInfo.closeDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(50, 16, 50, 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        child: Image.asset(
                          AppAsset.logo,
                          width: 190,
                          height: 190,
                          fit: BoxFit.cover,
                        ),
                      ),
                      DView.spaceHeight(),
                      const Text(
                        Var.schollName,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DView.spaceHeight(40),
                      TextField(
                        controller: controllerEmail,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          fillColor: Colors.grey[300],
                          filled: true,
                          hintText: 'Email',
                        ),
                      ),
                      DView.spaceHeight(),
                      TextField(
                        controller: controllerPassword,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          fillColor: Colors.grey[300],
                          filled: true,
                          hintText: 'Password',
                        ),
                      ),
                      DView.spaceHeight(),
                      ElevatedButton(
                        onPressed: () => login(),
                        child: const Text('MASUK'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
