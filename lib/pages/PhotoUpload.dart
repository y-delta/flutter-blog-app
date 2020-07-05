import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import "dart:io";

class UploadPhotoPage extends StatefulWidget{
    UploadPhotoPage({Key key, this.user, this.uid}) : super(key: key); //update this to include the uid in the constructor
    final String user; 
    final String uid;

  @override
  State<StatefulWidget> createState() {
    
   return _UploadPhotoPageState();
  }

}
class _UploadPhotoPageState extends State<UploadPhotoPage>{
  File sampleImage;
  String val;
  String url;
  String title;
  final formKey = new GlobalKey<FormState>();
  FirebaseUser currentUser;

  //String user;
   
  @override
  initState() {
    this.getCurrentUser();
    super.initState();

  }
  void getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
  }


  Future getImage() async{
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage= tempImage;
    });
  }

  bool validateAndSave(){
    final form = formKey.currentState;
    if (form.validate())
    {
      form.save();
      return true;
    }
    else{
      return false;
    }
  }

  void uploadPost() async{
    if(validateAndSave()){
      final StorageReference postImageRef = FirebaseStorage.instance.ref().child("Post Images");
      var timeKey = new DateTime.now();
      final StorageUploadTask uploadTask = postImageRef.child(timeKey.toString()+ ".jpg").putFile(sampleImage);

      var ImageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      url = ImageUrl.toString();
      print("Image URL : " + url);
      
      saveToDatabase(url);
      goToHomePage();

    }
  }
  void goToHomePage(){
//Navigator.pop(context);
   Navigator.pushReplacementNamed(context, "/home");
  }


  void saveToDatabase(url){
    var dbTimeKey = new DateTime.now();
    var formatDate = new DateFormat('MMM d, yyyy');
    var formatTime = new DateFormat('EEEE, hh:mm aaa');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    DatabaseReference ref = FirebaseDatabase.instance.reference();

    var data = 
    {
      "image": url,
      "title": title,
      "description": val,
      "date": date,
      "time": time,
      "author": widget.user,
      "uid":widget.uid,
    };
    ref.child("Posts").push().set(data).catchError((err)=>print(err));
  }

  @override
  Widget build(BuildContext context) {
    
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Upload Status")
      ),
      body: new Center(
        child: new Form(
        key:formKey,
        child: Column(
        children: <Widget>[      
         TextFormField(
              decoration: new InputDecoration(labelText: 'Title'),
              validator: (value){
                return value.isEmpty ? 'Blog Title is required' : null;
              },
              onSaved: (value){
                return title = value;
              },
            ),
            TextFormField(
              decoration: new InputDecoration(labelText: 'Description'),
              validator: (value){
                return value.isEmpty ? 'Blog Description is required' : null;
              },
              onSaved: (value){
                print(value);
                return val = value;
              },
            ),
            SizedBox(height: 15.0,),
            sampleImage == null ? Text("Select an image...") : enableUpload(),
            SizedBox(height: 15.0,),
            RaisedButton(
              elevation: 20.0,
              child: Text("Add a new post"),
              textColor: Colors.white,
              color: Colors.purple,
              onPressed: uploadPost,
            ),
          ],
          ),
      )
      ),
      floatingActionButton: new FloatingActionButton(
        tooltip: "Add Image",
        child: new Icon(Icons.add_a_photo),
        onPressed: getImage,
      ),
    );
  }
  Widget enableUpload()
  {
    return Container(
        child:  Column(
          children: <Widget>[
            Image.file(sampleImage, height: 230.0, width: 460.0,),        
          ],
        ),
    );
  }
}

  
