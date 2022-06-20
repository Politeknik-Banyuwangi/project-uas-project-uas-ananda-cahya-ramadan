import 'package:flutter/material.dart';
import 'package:flutter_login/screen/datapresensi.dart';
import 'package:flutter_login/screen/profile.dart';
import 'package:flutter_login/screen/qrcode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class DashboardCall extends MaterialPageRoute {
  DashboardCall(int id)
      : super(builder: (BuildContext context) {
          return LoginHomePage();
        });
}

class LoginHomePage extends StatefulWidget {
  const LoginHomePage({Key? key}) : super(key: key);

  @override
  _LoginHomePageState createState() => _LoginHomePageState();
}

class _LoginHomePageState extends State<LoginHomePage> {
  String? email;
  String? token;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadSharedPreference();
  }

  loadSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email');
      token = prefs.getString('token');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('DASHBOARD'),
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
      body: ListView(children: [
        SizedBox(
          height: 100,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        'https://i.postimg.cc/tCshkwZc/qr-code-1.png'),
                    fit: BoxFit.cover),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              'Selamat datang, lklkl ',
              style: TextStyle(color: Colors.deepPurple, fontSize: 25),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Klik tombol dibawah untuk presensi',
              style: TextStyle(color: Colors.deepPurple),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.deepPurple),
                      ),
                      elevation: 10,
                      minimumSize: const Size(300, 50)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QrViewExample()));
                  },
                  icon: const Icon(Icons.qr_code),
                  label: const Text(
                    "Presensi Sekerang",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  )),
              SizedBox(
                width: 10,
                height: 10,
              ),
            ],
          ),
        ),
      ]),
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
