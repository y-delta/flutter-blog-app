import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:BlogApp/pages/login.dart';

import 'PhotoUpload.dart';
import 'model/Posts.dart';

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
      }   
    }
    
    class _HomePageState extends State<HomePage> {
      FirebaseUser currentUser;
      List<Posts> postList = [];

      @override
      void initState() {
        super.initState();
        this.getCurrentUser();
        
        DatabaseReference postsRef = FirebaseDatabase.instance.reference().child("Posts");
        postsRef.once().then((DataSnapshot snap){
          var KEYS = snap.value.keys;
          var DATA = snap.value;

          postList.clear();

          for(var individualKey in KEYS)
          {
            Posts posts = new Posts(
              DATA[individualKey]['author'], 
              DATA[individualKey]['date'],
              DATA[individualKey]['description'],
              DATA[individualKey]['image'],
              DATA[individualKey]['time'],
              DATA[individualKey]['title'],
              DATA[individualKey]['uid']
              );
              postList.add(posts);
          }

          setState(() {
            print('Length: ${postList.length}');
          });

        });

       }
        void getCurrentUser() async {
        currentUser = await FirebaseAuth.instance.currentUser();
       // LoginPage();
      }
    @override
   Widget build(BuildContext context) {
    return new Scaffold(
     appBar: AppBar(
            title: Text("Blog"),
            automaticallyImplyLeading: false,//replace with title
            actions: <Widget>[
              FlatButton(
                child: Text("Log Out"),
                textColor: Colors.white,
                onPressed: () {
                  FirebaseAuth.instance
                      .signOut()
                      .then((result) =>
                          Navigator.pushReplacementNamed(context, "/login"))
                      .catchError((err) => print(err));
                },
              )
            ],
          ),
      body: new Container(
        child: postList.length == 0 ? new Text("No blogs") : new ListView.builder(
          itemCount: postList.length,
          itemBuilder: (_, index){
            return PostsUI(postList[index].author,
            postList[index].date,
            postList[index].description,
            postList[index].image,
            postList[index].time,
            postList[index].title,
            postList[index].uid,
            );
          }
        ),
      ),
      floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => UploadPhotoPage(
                    user:currentUser.email, uid:currentUser.uid,
                  )));
            },
            tooltip: 'Add',
            child: Icon(Icons.create),
          ),
    );
  }
  Widget PostsUI(String author,String date,String description,String image,String time,String title,String uid)
  {
    return new Card(
      elevation: 20.0,
      margin: EdgeInsets.all(15.0),

      child: new Container(
        padding: new EdgeInsets.all(14.0),

        child: new Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>
              [
            new Text(
              author,
              style: Theme.of(context).textTheme.subtitle,
              textAlign: TextAlign.center,
            ),
            new Text(
              title,
              style: Theme.of(context).textTheme.subtitle,
              textAlign: TextAlign.center,
            ),
            new Text(
              date,
              style: Theme.of(context).textTheme.subtitle,
              textAlign: TextAlign.center,
            ),
            ]
            ),
            SizedBox(height:10.0,),
            new Image.network(image, fit:BoxFit.cover),
            SizedBox(height: 10.0,),
            new Text(
              description,
              style: Theme.of(context).textTheme.subhead,
              textAlign: TextAlign.center,
            ),

          ],
        )
      )
    );
  }
      
}