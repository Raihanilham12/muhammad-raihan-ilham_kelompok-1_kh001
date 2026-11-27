import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class ApiService {
  final String baseUrl = 'https://jsonplaceholder.typicode.com/users';

  // GET: Mengambil seluruh data User
  Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat daftar User');
    }
  }

  // GET: Mengambil detail satu User berdasarkan ID
  Future<User> getUser(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('User dengan ID $id tidak ditemukan');
    }
  }

  // POST: Menambahkan User baru berdasarkan ID NIM (1000 + 299 = 1299)
  Future<User> createUser(User user) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode(user.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = json.decode(response.body);
      return User(
        id: user.id, // Mempertahankan ID 1299 karena mock API mengembalikan ID 11
        name: data['name'] ?? user.name,
        email: data['email'] ?? user.email,
        city: data['city'] ?? user.city,
      );
    } else {
      throw Exception('Gagal menambahkan User');
    }
  }

  // PUT: Memperbarui nama dan email User
  Future<User> updateUserPut(int id, String name, String email, String city) async {
    final targetId = id > 10 ? 1 : id; // Fallback endpoint JSONPlaceholder
    final response = await http.put(
      Uri.parse('$baseUrl/$targetId'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode({
        'id': id,
        'name': name,
        'email': email,
        'city': city,
      }),
    );
    if (response.statusCode == 200) {
      return User(id: id, name: name, email: email, city: city);
    } else {
      throw Exception('Gagal memperbarui User (PUT)');
    }
  }

  // PATCH: Memperbarui nama User dengan menambahkan "- Flutter Developer"
  Future<User> updateUserPatch(User currentUser) async {
    final targetId = currentUser.id > 10 ? 1 : currentUser.id;
    final updatedName = '${currentUser.name} - Flutter Developer';
    final response = await http.patch(
      Uri.parse('$baseUrl/$targetId'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode({'name': updatedName}),
    );
    if (response.statusCode == 200) {
      return User(
        id: currentUser.id,
        name: updatedName,
        email: currentUser.email,
        city: currentUser.city,
      );
    } else {
      throw Exception('Gagal memperbarui User (PATCH)');
    }
  }

  // DELETE: Menghapus User berdasarkan ID
  Future<bool> deleteUser(int id) async {
    final targetId = id > 10 ? 1 : id;
    final response = await http.delete(Uri.parse('$baseUrl/$targetId'));
    return response.statusCode == 200;
  }
}