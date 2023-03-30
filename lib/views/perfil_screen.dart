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
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.orange,
                   child: IconButton (
                    tooltip: 'Tanca Sessió',
                    style: IconButton.styleFrom(
                        shape: CircleBorder()
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
                    icon: Icon(LineAwesomeIcons.alternate_sign_out, color: Colors.black),
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
                Text(User.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                Text(User.email),
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