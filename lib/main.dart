import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: Scaffold(
      body: MyHomePage(),
      )
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  String _currentSelectedValue = 'Select Food Item';
  var _currencies = [
    "Select Food Item",
    "Biryani",
    "Chicken Fried Rice",
    "Burger",
    "Pizza",
    "Kadhai Paneer",
    "Dal Makhni",
    "Tandoori Roti"
  ];

  int _n = 0;
  void add() {
    setState(() {
      _n++;
    });
  }
  void minus() {
    setState(() {
      if (_n != 0)
        _n--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
          key: _formKey,
          child: ListView(

            
            children: <Widget>[
              Container(
                height: 600,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage("https://cdn.vox-cdn.com/thumbor/8fZR_P4E2OCgm3T99Y-5ABG7Mx4=/0x0:7360x4912/920x613/filters:focal(3092x1868:4268x3044):format(webp)/cdn.vox-cdn.com/uploads/chorus_image/image/67000785/shutterstock_1435374326.0.jpg"), fit: BoxFit.cover)),

              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left:40,right: 40,bottom: 10),
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text("Order Food", style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:20,left:40.0,right: 40),
                    child: Container(
                      padding: EdgeInsets.only(left: 20,right: 20),
                      decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.amber,Colors.orangeAccent[700]]),borderRadius: BorderRadius.circular(20)),
                      child: FormField<String>(
                        builder: (FormFieldState<String> state) {
                          return InputDecorator(
                            decoration: InputDecoration(

                              errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                            ),
                            isEmpty: _currentSelectedValue == '',
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
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

                  Padding(
                    padding: const EdgeInsets.only(top:20,left: 40,right: 40),
                    child: Container(
                      decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.amber,Colors.orangeAccent[700]]),borderRadius: BorderRadius.circular(20)),
                      child: new Center(
                        child: new Row(

                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 20,right: 20),
                              child: Text("Selct Quantity",style: TextStyle(color: Colors.black),),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 20,right: 10),
                              child: new FloatingActionButton(
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

                  Padding(
                    padding: const EdgeInsets.only(left:40.0,right: 40,top: 20,bottom: 20),
                    child: Container(
                      decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.amber,Colors.orangeAccent[700]]),borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.only(left: 20,right: 20),
                      child: TextFormField(

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


              Padding(
                padding: const EdgeInsets.only(top: 20,left:140,right: 140,bottom: 40),
                child: FloatingActionButton.extended(
                  backgroundColor: Colors.yellow[800],

                  onPressed: () {
                    // Validate returns true if the form is valid, or false
                    // otherwise.
                    if (_formKey.currentState.validate()) {
                      // If the form is valid, display a Snackbar.
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text('Processing Data')));
                    }
                  },
                  label: Text("Order",style: TextStyle(color: Colors.black),),
                ),
              ),


            ],
          ),

    );
  }
}
