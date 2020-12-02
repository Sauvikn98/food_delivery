import 'package:flutter/material.dart';
import 'auth.dart';
import 'auth_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String a = '';
  final databaseReference = FirebaseFirestore.instance;
  final myController = TextEditingController();
  final myController1 = TextEditingController();
  final myController2 = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _currentSelectedValue = 'Select Food Item';
  int _n = 0;
  var _currencies = ["Select Food Item", "Biryani", "Chicken Fried Rice", "Burger", "Pizza", "Kadhai Paneer", "Dal Makhni", "Tandoori Roti"];

  final List _isHovering = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  bool _isProcessing = false;

  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    myController1.dispose();
    myController2.dispose();
    super.dispose();
  }


  //QuantityAdd
  void add() {
    setState(() {
      _n++;
    });
  }

  //QuantitySubtract
  void minus() {
    setState(() {
      if (_n != 0)
        _n--;
    });
  }

  void createRecord() async {

    DocumentReference ref = await databaseReference.collection("Food")
        .add({
      'Food': _currentSelectedValue,
      'Quantity': _n,
      'Name': myController.text,
      'Phone Number': myController1.text,
      'Address': myController2.text,
    });
    a = ref.id;
  }

  //DeliveryAlert
  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Order Successful"),
      content: Text("Your order has been placed successfully, Your order Id is $a"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    FloatingActionButton btn1;
    FloatingActionButton btn2;
    FloatingActionButton btn3;
    return Scaffold(
      body: Container(
        child: Form(
          key: _formKey,
          child: ListView(


            children: <Widget>[
              //Image
              Container(
                height: 600,
                padding: EdgeInsets.only(top: 20,right: 20),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("asset/biryani.jpg"), fit: BoxFit.cover)),
                child: Container(
                  alignment: Alignment.topRight,
                  child:  InkWell(
                    onHover: (value) {
                      setState(() {
                        value ? _isHovering[3] = true : _isHovering[3] = false;
                      });
                    },
                    onTap: userEmail == null
                        ? () {
                      showDialog(
                        context: context,
                        builder: (context) => AuthDialog(),
                      );
                    }
                        : null,
                    child: userEmail == null
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image(
                              image: AssetImage("asset/google_logo.png"),
                              height: 30.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                      'Sign in',
                      style: TextStyle(
                              color: _isHovering[3] ? Colors.black: Colors.white,
                              fontSize: 20
                      ),
                    ),
                            ),
                          ],
                        )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundImage: imageUrl != null
                              ? NetworkImage(imageUrl)
                              : null,
                          child: imageUrl == null
                              ? Icon(
                            Icons.account_circle,
                            size: 30,
                          )
                              : Container(),
                        ),
                        SizedBox(width: 5),
                        Text(
                          name ?? userEmail,
                          style: TextStyle(
                            color: _isHovering[3]
                                ? Colors.white
                                : Colors.white,
                          ),
                        ),
                        SizedBox(width: 10),
                        FlatButton(
                          color: Colors.blueGrey,
                          hoverColor: Colors.blueGrey[700],
                          highlightColor: Colors.blueGrey[800],
                          onPressed: _isProcessing
                              ? null
                              : () async {
                            setState(() {
                              _isProcessing = true;
                            });
                            await signOut().then((result) {
                              print(result);
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  fullscreenDialog: true,
                                  builder: (context) => MyHomePage(),
                                ),
                              );
                            }).catchError((error) {
                              print('Sign Out Error: $error');
                            });
                            setState(() {
                              _isProcessing = false;
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 8.0,
                              bottom: 8.0,
                            ),
                            child: _isProcessing
                                ? CircularProgressIndicator()
                                : Text(
                              'Sign out',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: 20,),

                  //OrderFood
                  Padding(
                    padding: const EdgeInsets.only(left:40,right: 40,bottom: 10),
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text("Order Food", style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),)),
                  ),

                  //DropDown
                  Padding(
                    padding: const EdgeInsets.only(top:20,left:40.0,right: 40),
                    child: Container(
                      height: 70,
                      padding: EdgeInsets.only(left: 20,right: 20),
                      decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.amber.withOpacity(0.8),Colors.orangeAccent[700]]),borderRadius: BorderRadius.circular(20)),
                      child: FormField<String>(
                        builder: (FormFieldState<String> state) {
                          return InputDecorator(
                            decoration: InputDecoration(

                              errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                            ),
                            isEmpty: _currentSelectedValue == '',
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                iconEnabledColor: Colors.black,
                                value: _currentSelectedValue,
                                isDense: true,
                                onChanged: (String newValue) {
                                  setState(() {
                                    _currentSelectedValue = newValue;
                                    state.didChange(newValue);
                                  });
                                },
                                items: _currencies.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value,style: TextStyle(color: Colors.black),),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  //SelectQuantity
                  Padding(
                    padding: const EdgeInsets.only(top:20,left: 40,right: 40),
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.amber.withOpacity(0.8),Colors.orangeAccent[700]]),borderRadius: BorderRadius.circular(20)),
                      child: new Center(
                        child: new Row(

                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 20,right: 20),
                              child: Text("Select Quantity",style: TextStyle(color: Colors.black),),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 20,right: 10),
                              child: new FloatingActionButton(
                                heroTag: btn2,
                                mini: true,
                                onPressed: minus,
                                child: new Icon(
                                    Icons.remove,
                                    color: Colors.black),
                                backgroundColor: Colors.white,),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new Text('$_n',
                                  style: new TextStyle(fontSize: 20.0)),
                            ),



                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: new FloatingActionButton(
                                heroTag: btn3,
                                mini: true,
                                onPressed: add,
                                child: new Icon(Icons.add, color: Colors.black,),
                                backgroundColor: Colors.white,),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  //Name
                  Padding(
                    padding: const EdgeInsets.only(left:40.0,right: 40,top: 20),
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.amber.withOpacity(0.8),Colors.orangeAccent[700]]),borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.only(left: 20,right: 20),
                      child: TextFormField(
                        controller: myController,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(fillColor: Colors.black,hintText: 'Name',hintStyle: TextStyle(color: Colors.black)),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),

                  //PhoneNumber
                  Padding(
                    padding: const EdgeInsets.only(left:40.0,right: 40,top: 20),
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.amber.withOpacity(0.8),Colors.orangeAccent[700]]),borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.only(left: 20,right: 20),
                      child: TextFormField(
                        controller: myController1,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(fillColor: Colors.black,hintText: 'Phone Number',hintStyle: TextStyle(color: Colors.black)),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),

                  //Address
                  Padding(
                    padding: const EdgeInsets.only(left:40.0,right: 40,top: 20,bottom: 20),
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.amber.withOpacity(0.8),Colors.orangeAccent[700]]),borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.only(left: 20,right: 20),
                      child: TextFormField(
                        controller: myController2,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(fillColor: Colors.black,hintText: 'Address',hintStyle: TextStyle(color: Colors.black)),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ],
              ),

              //OrderButton
              Padding(
                padding: const EdgeInsets.only(top: 20,left:140,right: 140,bottom: 40),
                child: FloatingActionButton.extended(
                  heroTag: btn1,
                  backgroundColor: Colors.yellow[800],

                  onPressed: () {
                    createRecord();
                    // Validate returns true if the form is valid, or false
                    // otherwise.
                    if (_formKey.currentState.validate()) {
                      // If the form is valid, display a Snackbar.
                      showAlertDialog(context);
                    }
                  },
                  label: Text("Order",style: TextStyle(color: Colors.black),),
                ),
              ),

              SizedBox(height: 20,),

              //DevelopedBy
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Text("© Developed By Sauvik Nath",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),textAlign: TextAlign.center,),
              ),

              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
}
