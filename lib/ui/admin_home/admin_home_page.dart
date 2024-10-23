import 'package:clinic_management/data/blocs/authentication_bloc.dart';
import 'package:clinic_management/data/events/authentication_event.dart';
import 'package:clinic_management/ui/admin_home/clinics_tab/clinics_tab.dart';
import 'package:clinic_management/ui/admin_home/handbook_tab/handbook_tab.dart';
import 'package:clinic_management/ui/admin_home/specialties_tab/specialties_tab.dart';
import 'package:clinic_management/ui/admin_home/users_system_tab/manage_doctors.dart';
import 'package:clinic_management/ui/admin_home/users_system_tab/users_system_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminHomePage extends StatefulWidget {
  final String firstName;

  const AdminHomePage({super.key, required this.firstName});

  @override
  State<StatefulWidget> createState() {
    return _AdminHomePageState();
  }
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0; // Chỉ số tab hiện tại

  final List<Widget> _tabs = [
    const UsersSystemTab(),
    const ClinicsTab(),
    const SpecialtiesTab(),
    const HandbookTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: SizedBox(
            height: 50,
            width: 150,
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain,// Đảm bảo hình ảnh vừa với kích thước
            ),
          ),
        ),
        drawer: _getDrawer(),
        body: _tabs[_selectedIndex], //Hiển thị tab hiện tại
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Users System'),
            BottomNavigationBarItem(icon: Icon(Icons.meeting_room), label: 'Clinics'),
            BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Specialties'),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Handbook'),
          ],
          currentIndex: _selectedIndex, //chọn tab
          onTap: _onItemTapped, //khi nhấn thì setstate
          selectedItemColor: Colors.lightBlue, //màu tab được chọn
          unselectedItemColor: Colors.black87, //màu tab không được chọn
          backgroundColor: Colors.white, //màu nền BottomNavigationBar
          showUnselectedLabels: true, //show icon các tab k chọn
          showSelectedLabels: true, //show icon tab đc chọn
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Cập nhật chỉ số tab được chọn
    });
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
              decoration: const BoxDecoration(color: Colors.lightBlueAccent),
              child: ListTile(
                leading: const Icon(Icons.admin_panel_settings),
                title: Text(widget.firstName,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                },
              ),
            ),
          ),
          //Danh sách options
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context); //đóng drawer
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.accessibility),
            title: const Text('Manage Doctors'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ManageDoctors()
              ));
            },
          ),
          const Divider(),// Add a separator line
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
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
}
