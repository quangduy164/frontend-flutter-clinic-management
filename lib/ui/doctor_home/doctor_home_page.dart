import 'package:clinic_management/data/blocs/authentication_bloc.dart';
import 'package:clinic_management/data/events/authentication_event.dart';
import 'package:clinic_management/ui/doctor_home/manage_patient_tab/manage_patient_tab.dart';
import 'package:clinic_management/ui/doctor_home/manage_schedule_tab/manage_schedule_tab.dart';
import 'package:clinic_management/ui/user_home/personal_tab/personal_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorHomePage extends StatefulWidget {
  final int doctorId;
  final String firstName;

  const DoctorHomePage({super.key,required this.doctorId, required this.firstName});

  @override
  State<StatefulWidget> createState() {
    return _DoctorHomePageState();
  }
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  int _selectedIndex = 0; // Chỉ số tab hiện tại

  late List<Widget> _tabs; // Chỉ định `late` để khởi tạo sau

  @override
  void initState() {
    super.initState();
    _tabs = [
      ManageScheduleTab(doctorId: widget.doctorId),
      const ManagePatientTab(),
      PersonalTab(userId: widget.doctorId)
    ];
  }

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
            BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Manage Schedule'),
            BottomNavigationBarItem(icon: Icon(Icons.meeting_room), label: 'Manage Patients'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Personal'),
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
                leading: const Icon(Icons.perm_identity),
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
