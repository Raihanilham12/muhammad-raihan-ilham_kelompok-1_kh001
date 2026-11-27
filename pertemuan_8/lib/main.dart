import 'package:flutter/material.dart';
import 'models/user.dart';
import 'models/admin_model.dart';
import 'services/api_service.dart';
import 'services/admin_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Praktikum CRUD User & Admin (N=299)',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Konstanta NIM: N = 299
  static const int nimN = 299;
  static const int customUserId = 1000 + nimN; // 1299
  static const int customAdminId = 2000 + nimN; // 2299

  final ApiService _apiService = ApiService();
  final AdminService _adminService = AdminService();

  List<User> _users = [];
  List<Admin> _admins = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    try {
      final fetchedUsers = await _apiService.getUsers();
      final fetchedAdmins = await _adminService.getAdmins();

      // Menyisipkan data Admin khusus NIM (ID: 2299) ke dalam daftar tampilan
      final nimAdmin = Admin(
        id: customAdminId,
        name: 'Admin Utama NIM $nimN',
        email: 'admin.$customAdminId@kampus.ac.id',
        department: 'Pusat Sistem Informasi',
      );

      setState(() {
        _users = fetchedUsers;
        _admins = [nimAdmin, ...fetchedAdmins];
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Error memuat data: $e');
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  // --- OPERASI USER ---

  Future<void> _handlePostUser() async {
    final newUser = User(
      id: customUserId, // 1299
      name: 'Mahasiswa NIM $nimN',
      email: 'user.$customUserId@kampus.ac.id',
      city: 'Jakarta',
    );

    try {
      final created = await _apiService.createUser(newUser);
      setState(() {
        _users.removeWhere((u) => u.id == customUserId);
        _users.insert(0, created);
      });
      _showSnackBar('POST Berhasil: User ID ${created.id} ditambahkan');
    } catch (e) {
      _showSnackBar('Gagal POST User: $e');
    }
  }

  Future<void> _handlePutUser(User user) async {
    try {
      final updated = await _apiService.updateUserPut(
        user.id,
        '${user.name} (Updated)',
        'updated.${user.id}@kampus.ac.id',
        user.city,
      );
      setState(() {
        final idx = _users.indexWhere((u) => u.id == user.id);
        if (idx != -1) _users[idx] = updated;
      });
      _showSnackBar('PUT Berhasil: Nama & Email ID ${user.id} diperbarui');
    } catch (e) {
      _showSnackBar('Gagal PUT User: $e');
    }
  }

  Future<void> _handlePatchUser(User user) async {
    try {
      final patched = await _apiService.updateUserPatch(user);
      setState(() {
        final idx = _users.indexWhere((u) => u.id == user.id);
        if (idx != -1) _users[idx] = patched;
      });
      _showSnackBar('PATCH Berhasil: Ditambahkan "- Flutter Developer"');
    } catch (e) {
      _showSnackBar('Gagal PATCH User: $e');
    }
  }

  Future<void> _handleDeleteUser(int id) async {
    try {
      final success = await _apiService.deleteUser(id);
      if (success) {
        setState(() {
          _users.removeWhere((u) => u.id == id);
        });
        _showSnackBar('DELETE Berhasil: User ID $id dihapus');
      }
    } catch (e) {
      _showSnackBar('Gagal DELETE User: $e');
    }
  }

  // --- OPERASI ADMIN ---

  Future<void> _handleDeleteAdmin(int id) async {
    try {
      final success = await _adminService.deleteAdmin(id);
      if (success) {
        setState(() {
          _admins.removeWhere((a) => a.id == id);
        });
        _showSnackBar('DELETE Berhasil: Admin ID $id dihapus');
      }
    } catch (e) {
      _showSnackBar('Gagal DELETE Admin: $e');
    }
  }

  // --- DIALOG DETAIL BY ID ---

  void _showDetailDialog({required String role, required int id}) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      if (role == 'User') {
        final localMatch = _users.where((u) => u.id == id).firstOrNull;
        final user = localMatch ?? await _apiService.getUser(id);
        if (!mounted) return;
        Navigator.pop(context);
        _renderDetailModal(
          title: 'Detail User (ID: ${user.id})',
          details: {
            'ID': '${user.id}',
            'Name': user.name,
            'Email': user.email,
            'City': user.city,
          },
        );
      } else {
        final localMatch = _admins.where((a) => a.id == id).firstOrNull;
        final admin = localMatch ?? await _adminService.getAdmin(id);
        if (!mounted) return;
        Navigator.pop(context);
        _renderDetailModal(
          title: 'Detail Admin (ID: ${admin.id})',
          details: {
            'ID': '${admin.id}',
            'Name': admin.name,
            'Email': admin.email,
            'Department': admin.department,
          },
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      _showSnackBar('Data tidak ditemukan: $e');
    }
  }

  void _renderDetailModal({
    required String title,
    required Map<String, String> details,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: details.entries
              .map(
                (entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text('${entry.key}: ${entry.value}'),
            ),
          )
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showSearchByIdDialog() {
    final idController = TextEditingController();
    String selectedRole = 'User';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Cari Detail Berdasarkan ID'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedRole,
                items: ['User', 'Admin']
                    .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                    .toList(),
                onChanged: (val) => setDialogState(() => selectedRole = val!),
                decoration: const InputDecoration(labelText: 'Tipe Model'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: idController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Masukkan ID (cth: 1299 atau 2299)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final id = int.tryParse(idController.text.trim());
                if (id != null) {
                  Navigator.pop(ctx);
                  _showDetailDialog(role: selectedRole, id: id);
                }
              },
              child: const Text('Cari'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('CRUD User & Admin (N=299)'),
          actions: [
            IconButton(
              tooltip: 'Cari Detail by ID',
              icon: const Icon(Icons.search),
              onPressed: _showSearchByIdDialog,
            ),
            IconButton(
              tooltip: 'Refresh Data',
              icon: const Icon(Icons.refresh),
              onPressed: _loadInitialData,
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.person), text: 'Users (ID: 1299)'),
              Tab(icon: Icon(Icons.admin_panel_settings), text: 'Admins (ID: 2299)'),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
          children: [
            _buildUserTab(),
            _buildAdminTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _handlePostUser,
              icon: const Icon(Icons.person_add),
              label: const Text('POST User Baru (ID: 1299)'),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _users.length,
            itemBuilder: (context, index) {
              final user = _users[index];
              final isNimUser = user.id == customUserId;
              return Card(
                color: isNimUser ? Colors.indigo.shade50 : null,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  onTap: () => _showDetailDialog(role: 'User', id: user.id),
                  leading: CircleAvatar(child: Text('${user.id}')),
                  title: Text(
                    user.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${user.email}\nKota: ${user.city}'),
                  isThreeLine: true,
                  trailing: PopupMenuButton<String>(
                    onSelected: (action) {
                      if (action == 'put') _handlePutUser(user);
                      if (action == 'patch') _handlePatchUser(user);
                      if (action == 'delete') _handleDeleteUser(user.id);
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'put',
                        child: Text('PUT (Update Nama & Email)'),
                      ),
                      const PopupMenuItem(
                        value: 'patch',
                        child: Text('PATCH (+ Flutter Developer)'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('DELETE User', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAdminTab() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: _admins.length,
      itemBuilder: (context, index) {
        final admin = _admins[index];
        final isNimAdmin = admin.id == customAdminId;
        return Card(
          color: isNimAdmin ? Colors.amber.shade50 : null,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            onTap: () => _showDetailDialog(role: 'Admin', id: admin.id),
            leading: CircleAvatar(
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
              child: Text('${admin.id}'),
            ),
            title: Text(
              admin.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${admin.email}\nDept: ${admin.department}'),
            isThreeLine: true,
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: 'Hapus Admin',
              onPressed: () => _handleDeleteAdmin(admin.id),
            ),
          ),
        );
      },
    );
  }
}