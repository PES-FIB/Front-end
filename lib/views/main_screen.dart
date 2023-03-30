import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'map_screen.dart';
import 'favorites_screen.dart';
import 'perfil_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    Widget page;
    String headerPage;

    switch (selectedIndex) {
      case 0:
        headerPage = 'Home';
        page = Home();
        break;
      case 1:
        headerPage = 'Map';
        page = Map();
        break;
      case 2:
        headerPage = 'Favorites';
        page = Favorites();
        break;
      case 3:
        headerPage = 'Perfil';
        page = Perfil();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    // The container for the current page, with its background color
    var mainArea = ColoredBox(
      color: colorScheme.surfaceVariant,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: page,
      ),
    );

    return Scaffold(
      appBar: AppBar( 
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange,
        elevation: 10,
        title: Text(headerPage, style: TextStyle(color: Colors.white))
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          //
          if (constraints.maxWidth < 599) {
            // Use a more mobile-friendly layout with BottomNavigationBar
            // on narrow screens.
            return Center(
              child: Column(
                children: [
                  Expanded(child: mainArea),
                  Center(
                    child: SafeArea(
                      child: BottomNavigationBar(
                        elevation: 4,
                        unselectedItemColor: Colors.black,
                        selectedItemColor: Colors.orange,
                        items: [
                          BottomNavigationBarItem(
                            icon: Icon(Icons.calendar_month),
                            label: 'Home',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.place),
                            label: 'Map',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.star),
                            label: 'Favorites',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.person),
                            label: 'Perfil', 
                          ),
                        ],
                        currentIndex: selectedIndex,
                        onTap: (value) {
                          setState(() {
                            selectedIndex = value;
                          });
                        },
                        selectedLabelStyle: TextStyle(
                          color: Colors.orange,
                          fontSize: 16,
                        ),
                        iconSize: 30,
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 600,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.calendar_today, color: Colors.orange),
                        label: Text('Home', style: TextStyle(color: Colors.orange)),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.place, color: Colors.orange),
                        label: Text('Map', style: TextStyle(color: Colors.orange)),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.star, color: Colors.orange),
                        label: Text('Favorites', style: TextStyle(color: Colors.orange)),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.person, color: Colors.orange),
                        label: Text('Perfil', style: TextStyle(color: Colors.orange)),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
                Expanded(child: mainArea),
              ],
            );
          }
        },
      ),
    );
  }
}