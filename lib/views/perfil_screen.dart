import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:prova_login/controllers/userController.dart';
import 'login_page.dart';
import '../models/User.dart';

class Perfil extends StatefulWidget {
   @override
  State<Perfil> createState() {
    return _PerfilState();
  }
}
class _PerfilState extends State<Perfil> {
   List<User> lu = [];

  @override
  void initState() {
    super.initState();
    loadUser();
  }


  Future<void> loadUser() async {
    User CurrentUser = await userController.getUserInfo();
    setState(() {
      lu.add(CurrentUser);
      print('User loaded');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
            child: Column (
            children: <Widget> [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SizedBox(
                   child: ElevatedButton (
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                    ),
                    onPressed: () async {
                      int response = 0;
                      try {
                        response = await userController.logOut();
                      }
                      catch(e) {
                        print(e);
                      }
                      finally {
                        if (response == 200) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      }
                      }
                    },
                    child: const Icon(LineAwesomeIcons.alternate_sign_out),
                  )
                  ),
                ],
              ),
              SizedBox(
                width: 180,
                height: 180,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: const Image(image: AssetImage('assets/userImage.jpg')),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                child: lu.isEmpty?
                CircularProgressIndicator():
                Text(lu[0].name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30))
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
                child: lu.isEmpty?
                //Text("hola"/*lu[0].email*/),
                CircularProgressIndicator():
                Text(lu[0].email)
              ),
              const Divider(),
              const SizedBox(height: 20),
              ProfileWidget(title: 'Les meves valoracions', icon: LineAwesomeIcons.comments, onPress: (){}),
              ProfileWidget(title: 'Entrades', icon: LineAwesomeIcons.alternate_ticket, onPress: (){}),
              ProfileWidget(title: 'Compartir Perfil', icon: LineAwesomeIcons.share_square, onPress: (){}),
              ProfileWidget(title: 'Ajuda', icon: LineAwesomeIcons.question, onPress: (){})


            ],
          ), 
      ),
    );
  }
}

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress
  });
  final String title;
  final IconData icon;
  final VoidCallback onPress;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container (
        width: 40,
        height: 40,
        decoration: BoxDecoration (
          borderRadius: BorderRadius.circular(100),
          color: Colors.orange
        ),
        child: Icon(icon),
      ),
      title: Text (title, style:TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      trailing: SizedBox (
        width: 30,
        height: 30,
        child: const Icon(LineAwesomeIcons.angle_right),
      ),
    );
  }
}