import 'package:clinic_management/data/blocs/authentication_bloc.dart';
import 'package:clinic_management/data/events/authentication_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_tab/home_tab.dart';
import 'notification_tab/notification_tab.dart';
import 'pesonal_tab/pesonal_tab.dart';
import 'schedule_tab/schedule_tab.dart';

class UserHomePage extends StatefulWidget {
  final String firstName;
  const UserHomePage({super.key, required this.firstName});

  @override
  State<StatefulWidget> createState() {
    return _UserHomePageState();
  }
}

class _UserHomePageState extends State<UserHomePage> {
  int _selectedIndex = 0; // Chỉ số tab hiện tại

  final List<Widget> _tabs = [
    const HomeTab(),
    const NotificationTab(),
    const ScheduleTab(),
    const PesonalTab(),
  ];



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: SizedBox(
            height: 55,
            width: 160,
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain, //hình ảnh vừa với kích thước
            ),
          ),
        ),
        drawer: _getDrawer(),
        body: _tabs[_selectedIndex], //Hiển thị tab hiện tại
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notification'),
            BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedule'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
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
          SizedBox(
            height: 80,
            child: DrawerHeader(
              decoration: const BoxDecoration(color: Colors.lightBlueAccent),
              child: ListTile(
                leading: const Icon(Icons.account_circle),
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
          const Divider(), // Add a separator line
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
