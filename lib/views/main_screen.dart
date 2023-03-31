import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'home_screen.dart';
import 'map_screen.dart';
import 'favorites_screen.dart';
import 'perfil_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var index = 0;

  @override
  Widget build(BuildContext context) {
    
   final List<Widget> _pages = [
    Home(),
    Map(),
    Favorites(),
    Perfil()];
    // The container for the current page, with its background color
    // var mainArea = ColoredBox(
    //   color: Colors.redAccent,
    //   child: AnimatedSwitcher(
    //     duration: Duration(milliseconds: 200),
    //     child: page,
    //   ),
    // );

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "C U L T U R I C A 'T",
          style: TextStyle(
            color:Colors.white,
            fontWeight: FontWeight.bold),
        ),
      ),
      body : CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem> [
          BottomNavigationBarItem(
            icon: Icon(LineAwesomeIcons.calendar),
            label: 'events',
          ),
          BottomNavigationBarItem(
            icon: Icon(LineAwesomeIcons.map_marker),
            label: 'map',
          ),
          BottomNavigationBarItem(
            icon: Icon(LineAwesomeIcons.heart),
            label: 'favs',
          ),
          BottomNavigationBarItem(
            icon: Icon(LineAwesomeIcons.user),
            label: 'perfil' 
          ),
        ],
        activeColor: Colors.redAccent,
        onTap: (ind) {
          setState(() {
            index = ind;
          });
        },
      ),
      
        tabBuilder: (context, i) {
          return CupertinoTabView(builder: (context) {
            return _pages[i];
          }
          );
        },
    ),
    );
  }
}
//           //
//           if (constraints.maxWidth < 599) {
//             // Use a more mobile-friendly layout with BottomNavigationBar
//             // on narrow screens.
//             return Center(
//               child: Column(
//                 children: [
//                   Expanded(child: mainArea),
//                   Center(
//                     child: SafeArea(
//                       child: BottomNavigationBar(
//                         elevation: 4,
//                         unselectedItemColor: Colors.black,
//                         selectedItemColor: Colors.orange,
//                         items: [
//                           BottomNavigationBarItem(
//                             icon: Icon(Icons.calendar_month),
//                             label: 'events',
//                           ),
//                           BottomNavigationBarItem(
//                             icon: Icon(Icons.place),
//                             label: 'map',
//                           ),
//                           BottomNavigationBarItem(
//                             icon: Icon(Icons.favorite),
//                             label: 'favs',
//                           ),
//                           BottomNavigationBarItem(
//                             icon: Icon(Icons.person),
//                             label: 'perfil' 
//                           ),
//                         ],
//                         currentIndex: selectedIndex,
//                         onTap: (value) {
//                           setState(() {
//                             selectedIndex = value;
//                           });
//                         },
//                         selectedLabelStyle: TextStyle(
//                           color: Colors.redAccent,
//                           fontSize: 16, 
//                         ),
//                         iconSize: 30,
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             );
//           } else {
//             return Row(
//               children: [
//                 SafeArea(
//                   child: NavigationRail(
//                     extended: constraints.maxWidth >= 600,
//                     destinations: [
//                       NavigationRailDestination(
//                         icon: Icon(Icons.calendar_today, color: Colors.orange),
//                         label: Text('Home', style: TextStyle(color: Colors.orange)),
//                       ),
//                       NavigationRailDestination(
//                         icon: Icon(Icons.place, color: Colors.orange),
//                         label: Text('Map', style: TextStyle(color: Colors.orange)),
//                       ),
//                       NavigationRailDestination(
//                         icon: Icon(Icons.star, color: Colors.orange),
//                         label: Text('Favorites', style: TextStyle(color: Colors.orange)),
//                       ),
//                       NavigationRailDestination(
//                         icon: Icon(Icons.person, color: Colors.orange),
//                         label: Text('Perfil', style: TextStyle(color: Colors.orange)),
//                       ),
//                     ],
//                     selectedIndex: selectedIndex,
//                     onDestinationSelected: (value) {
//                       setState(() {
//                         selectedIndex = value;
//                       });
//                     },
//                   ),
//                 ),
//                 Expanded(child: mainArea),
//               ],
//             );
//           }
//         },
//       ),
//     );
//   }
// }


