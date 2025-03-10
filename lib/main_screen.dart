import 'package:ai_text_extracter_app/constants/colors.dart';
import 'package:ai_text_extracter_app/screens/home_page.dart';
import 'package:ai_text_extracter_app/screens/user_history.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  //Method to handle the tapping on bottom navigatin item
  void _onTapItem(int index) {
    debugPrint(index.toString());
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.transform),
            label: "Conversion",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "History",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onTapItem,
        selectedItemColor: Colors.white,
        unselectedItemColor: Color.fromARGB(255, 3, 42, 34),
        backgroundColor: mainColor,
      ),
      body: _selectedIndex == 0 ? HomePage() : UserHistory(),
    );
  }
}
