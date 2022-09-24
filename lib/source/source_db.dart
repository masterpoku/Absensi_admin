import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String generateRandomString(int length) {
  final _random = Random();
  const _availableChars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final randomString = List.generate(length,
          (index) => _availableChars[_random.nextInt(_availableChars.length)])
      .join();

  return randomString;
}

class SourceDB {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static Future<bool> registrationStudent(Map<String, dynamic> data) async {
    var response =
        await _db.collection('Student').where('id_siswa', isEqualTo: '').get();
    if (response.size > 0) {
      var doc = response.docs.first;
      data['password'] = generateRandomString(5);
      data['id'] = doc.id;
      doc.reference.update(data);
      return true;
    } else {
      return false;
    }
  }

  static Future<Set<String>> getClass() async {
    var response = await _db.collection('Student').get();
    return response.docs.map((e) => e.data()['id_class'] as String).toSet();
  }

  static Future<Map<String, dynamic>> getAbsenToday(String rfid) async {
    var response = await _db
        .collection('Absensi')
        .where('rfid', isEqualTo: rfid)
        .where(
          'date',
          isEqualTo: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        )
        .get();
    if (response.size > 0) {
      return response.docs[0].data();
    }
    return {};
  }

  static Future<List<Map<String, dynamic>>> getStudent(String rfid) async {
    var response =
        await _db.collection('Student').where('rfid', isEqualTo: rfid).get();
    return response.docs.map((e) => e.data()).toList();
  }

  static Future<List<Map<String, dynamic>>> getStudentPerClass(
      String idClass) async {
    List<Map<String, dynamic>> list = [];
    var response = await _db
        .collection('Student')
        .where('id_class', isEqualTo: idClass)
        .get();
    for (var e in response.docs) {
      var data = e.data();
      data['absensi'] = (await getAbsenToday(data['rfid']));
      list.add(data);
    }
    list.sort((a, b) => a['name'].compareTo(b['name']));
    return list;
  }

  static Future<List<Map<String, dynamic>>> getRekapKehadiran(
      String idClass) async {
    List<Map<String, dynamic>> list = [];
    var response = await _db
        .collection('Student')
        .where('id_class', isEqualTo: idClass)
        .get();
    for (var e in response.docs) {
      var data = e.data();
      var response = await _db
          .collection('Absensi')
          .where('rfid', isEqualTo: data['rfid'])
          .get();
      data['absen_count'] = response.size;
      list.add(data);
    }
    list.sort((a, b) => a['name'].compareTo(b['name']));
    return list;
  }
}
