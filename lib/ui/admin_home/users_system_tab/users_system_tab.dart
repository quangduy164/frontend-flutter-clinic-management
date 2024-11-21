import 'package:clinic_management/data/repository/user_repository.dart';
import 'package:flutter/material.dart';

import 'edit_user_page.dart';

class UsersSystemTab extends StatefulWidget {
  const UsersSystemTab({super.key});

  @override
  State<StatefulWidget> createState() {
    return _UsersSystemTabState();
  }
}

class _UsersSystemTabState extends State<UsersSystemTab> {
  late Future<List<Map<String, dynamic>>> futureGetAllUsers;
  String? email;
  int? userId;

  @override
  void initState() {
    futureGetAllUsers = UserRepository().getAllUsers('ALL');
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _getBody());
  }

  Widget _getBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RefreshIndicator(
        onRefresh: _refreshListUsers,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _getUsersTable(),
                ],
              ),
            )
        ),
      ),
    );
  }

  Widget _getUsersTable() {
    return Column(
      children: [
        const SizedBox(height: 10),
        const Text(
          'Management Users',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        //xây dựng giao diện dựa trên kết quả của Future là futureGetAllUsers
        FutureBuilder<List<Map<String, dynamic>>>(
          future: futureGetAllUsers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Lỗi: ${snapshot.error}');
            } else {
              final users = snapshot.data!;
              return _buildListUsers(users);
            }
          },
        )
      ],
    );
  }

  Widget _buildListUsers(List<Map<String, dynamic>> users) {
    if (users.isEmpty) {
      return const Center(child: Text('Không có tài khoản người dùng.'));
    }
    return Column(
      children: users.map((user) {
        return Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent.withOpacity(0.1),
                  border: Border.all(
                    color: Colors.grey, // Màu viền
                    width: 0.1, // Độ dày viền
                  ),
                ),
                child: userComponent(user)));
      }).toList(),
    );
  }

  Widget userComponent(Map<String, dynamic> user) {
    return Row(
      children: [
        Text(
          user['email'],
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditUserPage(user: user)));
                  },
                  icon:  const Icon(Icons.edit, color: Colors.blue,)),
              IconButton(
                  onPressed: () {
                    _confirmDelete(user['id'], user['email']);
                  },
                  icon: const Icon(Icons.delete, color: Colors.red,)),
            ],
          ),
        ),
      ],
    );
  }

  // Hộp thoại xác nhận xóa
  Future<void> _confirmDelete(int userId, String email) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text('Bạn chắc chắn muốn xóa email $email ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Trở về'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text(
                'Xóa',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
    if (confirm == true) {
      await _deleteUser(userId);
    }
  }

  // Hàm xóa người dùng
  Future<void> _deleteUser(int userId) async {
    try {
      final result = await UserRepository().deleteUser(userId);
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Xóa người dùng thành công')),
        );
        // Cập nhật lại danh sách người dùng sau khi xóa
        await _refreshListUsers();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${result['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Làm mới danh sách user
  Future<void> _refreshListUsers() async {
    setState(() {
      futureGetAllUsers =
          UserRepository().getAllUsers('ALL'); // Cập nhật lại future
    });
  }
}
