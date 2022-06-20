import 'dart:convert';
import 'package:flutter_login/model/absen.dart';
import 'package:http/http.dart' as http;

class ApiUndangan {
  final url = "http://mhs.rey1024.com/apiundangan/getListUndangan.php";
  Future<List<Undangan>?> getUndanganAll() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return undanganFromJson(response.body);
    } else {
      print("Error ${response.toString()}");
      return null;
    }
  }

//cek kehadiran
  Future<Undangan?> cekUndangan(String email) async {
    final response = await http.get(Uri.parse(
        "http://mhs.rey1024.com/apiundangan/cekUndangan.php?email=$email"));
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return Undangan.fromJson(result[0]);
    } else {
      print("Error ${response.toString()}");
      return null;
    }
  }

//ubah status kehadiran
  Future<bool> updateKehadiran(Undangan undangan) async {
    final response = await http.get(Uri.parse(
        "http://mhs.rey1024.com/apiundangan/updateKehadiran.php?undangan_id=${undangan.undanganId}"));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

//reset status kehadiran
  Future<bool> resetKehadiran() async {
    final response = await http.get(
        Uri.parse("http://mhs.rey1024.com/apiundangan/resetKehadiran.php"));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
