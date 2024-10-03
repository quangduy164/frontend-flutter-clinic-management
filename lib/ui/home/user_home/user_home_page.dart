import 'package:clinic_management/ui/home/user_home/account_tab/account_tab.dart';
import 'package:clinic_management/ui/home/user_home/home_tab/home_tab.dart';
import 'package:clinic_management/ui/home/user_home/notification_tab/notification_tab.dart';
import 'package:clinic_management/ui/home/user_home/schedule_tab/schedule_tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserHomePage extends StatefulWidget{
  const UserHomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _UserHomePageState();
  }
}

class _UserHomePageState extends State<UserHomePage>{
  final List<Widget> _tabs = [
    HomeTab(),
    NotificationTab(),
    ScheduleTab(),
    AccountTab()
  ];
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Clinic Management'),
      ),
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notification'),
            BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedule'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
          ],
        ),
        tabBuilder: (BuildContext context, int index){
          return _tabs[index];
        },
      ),
    );
  }

}