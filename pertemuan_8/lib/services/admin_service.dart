import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/admin_model.dart';

class AdminService {
  final String baseUrl = 'https://jsonplaceholder.typicode.com/users';

  // GET: Mengambil seluruh data Admin
  Future<List<Admin>> getAdmins() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Admin.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat daftar Admin');
    }
  }

  // GET: Mengambil satu data Admin berdasarkan ID
  Future<Admin> getAdmin(int id) async {
    final targetId = id > 10 ? 1 : id;
    final response = await http.get(Uri.parse('$baseUrl/$targetId'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Admin(
        id: id,
        name: data['name'] ?? 'Admin $id',
        email: data['email'] ?? 'admin$id@system.com',
        department: data['company']?['name'] ?? 'System Administration',
      );
    } else {
      throw Exception('Admin dengan ID $id tidak ditemukan');
    }
  }

  // DELETE: Menghapus data Admin berdasarkan ID
  Future<bool> deleteAdmin(int id) async {
    final targetId = id > 10 ? 1 : id;
    final response = await http.delete(Uri.parse('$baseUrl/$targetId'));
    return response.statusCode == 200;
  }
}