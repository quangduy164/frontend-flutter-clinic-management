import 'package:clinic_management/data/blocs/authentication_bloc.dart';
import 'package:clinic_management/data/events/authentication_event.dart';
import 'package:clinic_management/data/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AdminHomePageState();
  }
}

class _AdminHomePageState extends State<AdminHomePage> {
  late Future<List<Map<String, dynamic>>> futureGetAllUsers;
  final UserRepository _userRepository = UserRepository();

  @override
  void initState() {
    futureGetAllUsers = _userRepository.getAllUsers('ALL');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Clinic Management',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.lightBlueAccent),
          ),
        ),
        drawer: _getDrawer(),
        body: Padding(padding: const EdgeInsets.all(8.0), child: _getBody()),
      ),
    );
  }

  Widget _getDrawer() {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      child: ListView(
        padding: EdgeInsets.zero, //để phủ kín màu drawerheader
        children: [
          Container(
            height: 80,
            child: DrawerHeader(
              decoration: BoxDecoration(color: Colors.lightBlueAccent),
              child: ListTile(
                leading: Icon(Icons.admin_panel_settings),
                title: Text('Admin',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                },
              ),
            ),
          ),
          //Danh sách options
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context); //đóng drawer
            },
          ),
          Divider(), // Add a separator line
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              //Đăng xuất
              BlocProvider.of<AuthenticationBloc>(context)
                  .add(AuthenticationEventLoggedOut());
            },
          ),
        ],
      ),
    );
  }

  Widget _getBody() {
    return RefreshIndicator(
      onRefresh: _refreshListUsers,
      child: _getUsersTable(),
    );
  }

  Widget _getUsersTable() {
    return Column(
      children: [
        Text(
          'Management Users',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
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
              return _buildUserTable(users);
            }
          },
        ),
      ],
    );
  }

  Widget _buildUserTable(List<Map<String, dynamic>> users) {
    return SizedBox(
      height: 450,
      width: 335,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,//cuộn theo chiều dọc
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Email')),
              DataColumn(label: Text('Action')),
            ],
            rows: users.map((user) {
              return DataRow(cells: [
                DataCell(Text(user['email'])),
                DataCell(
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          // Xử lý chỉnh sửa
                          print('Edit ${user['email']}');
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _confirmDelete(user['id'], user['email']);
                        },
                      ),
                    ],
                  ),
                ),
              ]);
            }).toList(),
            border: const TableBorder(
              horizontalInside: BorderSide(color: Colors.grey), // Đường kẻ ngang giữa các hàng
              verticalInside: BorderSide(color: Colors.grey), // Đường kẻ dọc giữa các cột
              top: BorderSide(color: Colors.grey, width: 1), // Đường kẻ trên
              bottom: BorderSide(color: Colors.grey, width: 1), // Đường kẻ dưới
            ),
          ),
        ),
      ),
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
              child: Text('Trở về'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Xóa', style: TextStyle(color: Colors.red),),
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
      final result = await _userRepository.deleteUser(userId);
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Xóa người dùng thành công')),
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

  // Làm mới danh sách bài hát
  Future<void> _refreshListUsers() async {
    setState(() {
      futureGetAllUsers = _userRepository.getAllUsers('ALL'); // Cập nhật lại future
    });
  }
}
