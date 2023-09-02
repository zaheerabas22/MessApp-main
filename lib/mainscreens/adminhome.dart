import 'package:flutter/material.dart';
import 'package:messapp/mainscreens/account_user.dart';
import 'package:messapp/mainscreens/admin_complain.dart';
import 'package:messapp/mainscreens/attendec_screen.dart';
import 'package:messapp/mainscreens/complain_screen.dart';
import 'package:messapp/mainscreens/editmenu.dart';
import 'package:messapp/mainscreens/mess_menu_user.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const MessMenuUserScreen(),
    const EditMenuScreen(),
    const AdminComplain(),
    const UserAccountScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        elevation: 0,
        selectedItemColor: Colors.lightBlue,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Mess Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_rounded),
            label: 'Edit Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_alert),
            label: 'Complain',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
