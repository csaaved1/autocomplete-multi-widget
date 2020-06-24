import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'auto-complete-widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutoComplete Widget Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'AutoComplete Widget Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Person> bufferList = new List<Person>();


  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    bufferList.add(Person('Carlo', 23, true));
    bufferList.add(Person('Joe', 25, false));
    bufferList.add(Person('Sarah', 22, true));
    bufferList.add(Person('Bob', 29, true));
    bufferList.add(Person('Kate', 21, true));
    bufferList.add(Person('Tom', 54, false));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () => _awaitReturnValueFromAutoCompleteScreen(context, bufferList, false),
                child: Text('Single-Select', style: TextStyle(fontSize: 20)),
            ),
            RaisedButton(
              onPressed: () => _awaitReturnValueFromAutoCompleteScreen(context, bufferList, true),
              child: Text('Multi-Select', style: TextStyle(fontSize: 20)),
            ),

          ],
        ),
      ),
    );
  }


   _awaitReturnValueFromAutoCompleteScreen(BuildContext context, List<Person> myList, bool isMulti) async {

    final  result = await  Navigator.push(
      context,

      MaterialPageRoute(builder: (context) =>
          AutoCompleteWidget(
              myList,
              'name',
              isMulti == true ? true : false,
          ),
      ),
    );

    print('RESULT(S) RECIEVED');
    print(result);
    // after the SecondScreen result comes back update the Text widget with it
  }
}



class Person {
  final String name;
  final  int age;
  final bool employed;

  const Person(this.name, this.age, this.employed);
}
