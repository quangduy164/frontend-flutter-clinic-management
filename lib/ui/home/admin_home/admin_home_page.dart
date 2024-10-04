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
    return DataTable(
      columns: const [
        DataColumn(label: Text('Email')),
        DataColumn(label: Text('Action')),
      ],
      rows: users.map((user) {
        return DataRow(cells: [
          DataCell(Text(user['email'])),
          DataCell(
            Row(
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
                    // Xử lý xóa
                    print('Delete ${user['email']}');
                  },
                ),
              ],
            ),
          ),
        ]);
      }).toList(),
    );
  }

  // Làm mới danh sách bài hát
  Future<void> _refreshListUsers() async {
    setState(() {
      futureGetAllUsers = _userRepository.getAllUsers('ALL'); // Cập nhật lại future
    });
  }
}
