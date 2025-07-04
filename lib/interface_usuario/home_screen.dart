import 'package:flutter/material.dart';
import 'package:minhas_series/interface_usuario/my_lists_screen.dart';
import 'package:minhas_series/interface_usuario/search_screen.dart';

class HomeScreen extends StatefulWidget {
  
  final Map<String, dynamic> user;

  
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  
  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    
    _widgetOptions = <Widget>[
      MyListsScreen(user: widget.user),
      SearchScreen(user: widget.user,), 
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Minhas Listas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Buscar',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}