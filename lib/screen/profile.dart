import 'package:flutter_login/login_home_page.dart';
import 'package:flutter_login/login_page.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'datapresensi.dart';

class ProfilCall extends MaterialPageRoute {
  ProfilCall(int id)
      : super(builder: (BuildContext context) {
          return Profil();
        });
}

class Profil extends StatefulWidget {
  Profil({Key? key}) : super(key: key);

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  String? name = 'yogi', username = 'yogi s', email = 'yogi@gmail.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('PROFIL'),
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      drawer: Drawer(
        backgroundColor: Color.fromARGB(255, 45, 41, 52),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            ListTile(
              trailing: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              title: Text(
                'ABSENSI DOORLOCK',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              leading: Icon(
                Icons.dashboard,
                color: Colors.white,
              ),
              title: Text(
                'Dashboard',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => Navigator.of(context).push(DashboardCall(1)),
            ),
            ListTile(
              leading: Icon(
                Icons.data_array,
                color: Colors.white,
              ),
              title: Text(
                'Presensi',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DataPresensi())),
            ),
            ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.white,
              ),
              title: Text(
                'Profil',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => Navigator.of(context).push(ProfilCall(1)),
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              title: Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => fetchLogout(context),
            ),
          ],
        ),
      ),
      // data
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              child: Container(
                width: double.infinity,
              ),
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.2,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.04, bottom: 35),
              //left: defaultMargin,
              //right: defaultMargin),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 0),
                    child: CircleAvatar(
                      child: Icon(
                        Icons.person,
                        size: 40,
                      ),
                      radius: 35,
                    ),
                  ),
                  Text(
                    '$name',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$username | $email',
                    style:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.3,
                // left: defaultMargin,
                // right: defaultMargin,
                // bottom: defaultMargin,
              ),
              child: Column(
                children: [
                  Container(
                    child: ListTile(
                        title: Text(
                          'Account',
                        ),
                        leading: Icon(Icons.account_circle)),
                  ),
                  Container(
                    child: ListTile(
                        title: Text('Password'),
                        leading: Icon(Icons.lock_rounded)),
                  ),
                  Container(
                    child: ListTile(
                        title: Text('Tentang'), leading: Icon(Icons.category)),
                  ),
                  Container(
                    child: ListTile(
                        title: Text('Keluar'),
                        leading: Icon(Icons.logout_rounded)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void fetchLogout(BuildContext context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    final removeEmail = await prefs.remove('email');
    final removeToken = await prefs.remove('token');
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const LoginPage()));
  }
}
