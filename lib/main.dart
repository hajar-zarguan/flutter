import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Users',
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ),
      home: new MyHomePage(title: 'Gestion des utilisateurs '),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}
List<User> users = [];

class _MyHomePageState extends State<MyHomePage> {

    Future<List<User>> _getUsers() async {
    var data = await http.get(Uri.parse('https://randomuser.me/api/?results=10'));

    var jsonData = json.decode(data.body);


    for(var u in jsonData["results"]){
      User user = User( u["id"]["name"], u["name"]["last"],u["name"]["first"], u["email"], u["phone"], u["picture"]["large"], u["gender"]);

      users.add(user);
    }

    print(users.length);

    return users;

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            print(snapshot.data);
            if(snapshot.data == null){
              return Container(
                  child: Center(
                      child: Text("Loading...")
                  )
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card (child:ListTile(
                    leading: CircleAvatar(backgroundImage:
                    NetworkImage(  snapshot.data[index].image)),


                    //snapshot.data[index].picture
                    //): ,),
                    //Colors.lightBlueAccent
                    //backgroundImage: NetworkImage(
                    //snapshot.data[index].picture
                    //),
                    //),
                    title: Text(snapshot.data[index].firstname + "  "+snapshot.data[index].lastname ),
                    subtitle: Text(snapshot.data[index].email + " - Phone: " + snapshot.data[index].phone  ),

                    onTap: (){
                      Navigator.push(context,
                          new MaterialPageRoute(builder: (context) => DetailPage(snapshot.data[index]))
                      );
                    },
                  ));
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {

  final User user;

  DetailPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              "user.firstname",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
            subtitle: Row(
              children: <Widget>[
                Icon(Icons.linear_scale, color: Colors.yellowAccent),
                Text(" Intermediate", style: TextStyle(color: Colors.white))
              ],
            ),
            trailing:
            Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0));










        )
    );
  }
}


class User {
  final String id;

  final String firstname;
  final String lastname;
  final String gender;
  final String email;
  final String phone;
  final String image;


  User(this.id, this.lastname , this.firstname, this.email,this.phone, this.image , this.gender);


}



