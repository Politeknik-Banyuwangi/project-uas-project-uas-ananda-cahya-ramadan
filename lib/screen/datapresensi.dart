import 'package:flutter_login/login_page.dart';
import 'package:flutter_login/model/absen.dart';
import 'package:flutter_login/services/apiabsen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataPresensidCall extends MaterialPageRoute {
  DataPresensidCall(int id)
      : super(builder: (BuildContext context) {
          return DataPresensi();
        });
}

class DataPresensi extends StatefulWidget {
  DataPresensi({Key? key}) : super(key: key);

  @override
  State<DataPresensi> createState() => _DataPresensiState();
}

class _DataPresensiState extends State<DataPresensi> {
  ApiUndangan? apiUndangan = ApiUndangan();
  @override
  void initState() {
    super.initState();
    apiUndangan = ApiUndangan();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: FutureBuilder<List<Undangan>?>(
          future: apiUndangan!.getUndanganAll(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Undangan>?> snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error.toString());
              return Center(
                child: Text('Error ${snapshot.error.toString()}'),
              );
            } else if (snapshot.hasData) {
              List<Undangan>? _undangan = snapshot.data;
              if (_undangan != null)
                return _buildListView(_undangan);
              else
                return Text("Kosong");
            } else
              return CircularProgressIndicator();
          },
        ));
  }

  Widget _buildListView(List<Undangan> undangan) {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String datetime = tsdate.day.toString() +
        "/" +
        tsdate.month.toString() +
        "/" +
        tsdate.year.toString();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("KEHADIRAN"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 7,
              child: ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: undangan.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: undangan[index].statusDatang == "1"
                        ? Card(
                            child: ListTile(
                            title: Text("${undangan[index].nama}"),
                            subtitle: Text("${undangan[index].email}"),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "http://mhs.rey1024.com/apiundangan/${undangan[index].foto}"),
                            ),
                            trailing: undangan[index].statusDatang == "1"
                                ? Text(datetime + "   Hadir",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ))
                                : Text("Tidak Hadir",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    )),
                          ))
                        : Container(),
                  );
                },
              ),
            ),
            Container(
                margin: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                child: MaterialButton(
                  onPressed: () {
                    apiUndangan!.resetKehadiran();
                    setState(() {});
                  },
                  child: const Text("Reset Kehadiran",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16)),
                  color: Colors.deepPurple,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  padding: const EdgeInsets.all(20),
                )),
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
