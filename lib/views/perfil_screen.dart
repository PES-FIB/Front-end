import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../controllers/reviews_controller.dart';
import '../controllers/userController.dart';
import 'login_page.dart';
import '../models/User.dart';
import 'perfil_config.dart';
import 'styles/custom_snackbar.dart';
import 'styles/custom_user_image.dart';

class Perfil extends StatefulWidget {
  @override
  State<Perfil> createState() {
    return _PerfilState();
  }
}

class _PerfilState extends State<Perfil> {
  @override
  Widget build(BuildContext context) {
    final ReviewController reviewController = ReviewController(context);
    final UserController userController = UserController(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.redAccent,
                        child: IconButton(
                          tooltip: 'Tanca Sessió',
                          style: IconButton.styleFrom(shape: CircleBorder()),
                          onPressed: () async {
                            int response = 0;
                            try {
                              response = await UserController.logOut();
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                    customSnackbar(context,
                                        'No s\'ha pogut tancar sessió'));
                            } finally {
                              if (response == 200) {
                                Navigator.of(context, rootNavigator: true)
                                    .pushReplacement(MaterialPageRoute(
                                        builder: (context) => LoginPage()));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    customSnackbar(context,
                                        'No s\'ha pogut tancar sessió'));
                              }
                            }
                          },
                          icon: Icon(LineAwesomeIcons.alternate_sign_out,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 5),
                      CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.redAccent,
                          child: IconButton(
                            tooltip: 'Configuració',
                            style: IconButton.styleFrom(shape: CircleBorder()),
                            onPressed: () async {
                              await Navigator.of(context,
                                      rootNavigator: true)
                                  .push(
                                MaterialPageRoute(
                                    builder: (context) => PerfilConfig()),
                              );
                              setState(() {
                                // do something with the result
                              });
                            },
                            icon:
                                Icon(LineAwesomeIcons.cog, color: Colors.white),
                          )),
                    ],
                  )
                ],
              ),
            ),
              SizedBox(
                width: 180,
                height: 180,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: UserImage(),
                  
                ),
              ),
              const SizedBox(height: 10),  
                Text(User.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                Text(User.email),
              const Divider(),
              const SizedBox(height: 20),
              SingleChildScrollView(
                child: Column(
                  children: [
                    ProfileWidget(title: 'Les meves valoracions', icon: LineAwesomeIcons.comments, onPress: (){reviewController.toUserReviews(true);}),
                    ProfileWidget(title: 'Entrades', icon: LineAwesomeIcons.alternate_ticket, onPress: (){}),
                    ProfileWidget(title: 'Compartir Perfil', icon: LineAwesomeIcons.share_square, onPress: (){}),
                    ProfileWidget(title: 'Ajuda', icon: LineAwesomeIcons.question, onPress: (){})
                  ],
                ),
              )


            ],
          ), 
      ),
    );
  }
}

class ProfileWidget extends StatelessWidget {
  const ProfileWidget(
      {super.key,
      required this.title,
      required this.icon,
      required this.onPress});
  final String title;
  final IconData icon;
  final VoidCallback onPress;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100), color: Colors.redAccent),
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      trailing: SizedBox(
        width: 30,
        height: 30,
        child: const Icon(LineAwesomeIcons.angle_right),
      ),
    );
  }
}
