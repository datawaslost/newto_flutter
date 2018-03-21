import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'NewTo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

	final TextEditingController _emailController = new TextEditingController();

	void _createAccount() {
		Navigator.of(context).push(
			new MaterialPageRoute(
				builder: (context) {
					return new Scaffold(
						body: new Column(
							mainAxisSize: MainAxisSize.min,
							children: <Widget>[
								new LinearProgressIndicator(
									value: 0.3,
									backgroundColor: const Color(0xFFFFFFFF),
								),
								new Row (
									children: <Widget>[
										new BackButton(),
										new Expanded(
											child: new Container(
												padding: new EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
												alignment: Alignment.topRight,
												child: new Text(
													'Login'.toUpperCase(),
													style: new TextStyle(
														color: const Color(0xFF1033FF),
														fontFamily: 'Montserrat',
														fontWeight: FontWeight.w800,
														fontSize: 14.0,
													),
												),
											),
										),
									]
								),
								new Container(
									padding: new EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 0.0),
									alignment: Alignment.topLeft,
									child: new Text(
										'1/3',
										style: new TextStyle(
											fontFamily: 'Montserrat',
											fontWeight: FontWeight.w800,
											fontSize: 14.0,
										),
									),
								),
								new Container(
									padding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
									child: new Text(
										'Tell us your school email.'.toUpperCase(),
										style: new TextStyle(
											fontFamily: 'Montserrat',
											fontWeight: FontWeight.w800,
											fontSize: 38.0,
											height: 1.0,
										),
									),
								),
								new Container(
									padding: new EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
									alignment: Alignment.topLeft,
									child: new Text(
										'Email'.toUpperCase(),
										style: new TextStyle(
											color: const Color(0xFF838383),
											fontFamily: 'Montserrat',
											fontWeight: FontWeight.w800,
											fontSize: 14.0,
										),
									),
								),
								new Container(
									padding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
							        child: new TextField(
							        	controller: _emailController,
										style: new TextStyle(
											color: const Color(0xFF000000),
											fontFamily: 'Montserrat',
											fontWeight: FontWeight.w800,
											fontSize: 18.0,
										),
										decoration: new InputDecoration(
							            	fillColor: const Color(0x66E0E1EA),
											filled: true,
										),
										keyboardType: TextInputType.emailAddress,
							        ),
								),
								new Container(
									padding: new EdgeInsets.all(20.0),
									child: new Text(
										'We’ll send you a confirmation email to confirm you school account.',
										style: new TextStyle(
											color: const Color(0xFF2D2D2F),
											fontFamily: 'Montserrat',
											fontWeight: FontWeight.w300,
											fontSize: 14.0,
										),
									),
								),
								new Expanded(
									child: new Align(
										alignment: Alignment.bottomCenter,
										child: new Row(children: <Widget>[
											new Expanded(
												child: new RaisedButton(
														onPressed: () {
															showDialog(
																context: context,
																child: new AlertDialog(
																	title: new Text('What you typed:'),
																	content: new Text(_emailController.text),
																),
															);
														},
														padding: new EdgeInsets.all(14.0),  
														color: const Color(0xFF1033FF),
														textColor: const Color(0xFFFFFFFF),
														child: new Text(
															'Next Step'.toUpperCase(),
															style: new TextStyle(
																fontFamily: 'Montserrat',
																fontWeight: FontWeight.w800,
															),
														),
													),
												)
											]
										),
									),
								),
						    ],
						),
				    );
				},
			),
		);
	}

	void _login() {
		Navigator.of(context).push(
			new MaterialPageRoute(
				builder: (context) {
					return new Scaffold(
						body: new Column(
							mainAxisSize: MainAxisSize.min,
							children: <Widget>[
								new Row (
									children: <Widget>[
										new BackButton(),
										new Expanded(
											child: new Container(
												padding: new EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
												alignment: Alignment.topRight,
												child: new Text(
													'Login'.toUpperCase(),
													style: new TextStyle(
														color: const Color(0xFF1033FF),
														fontFamily: 'Montserrat',
														fontWeight: FontWeight.w800,
														fontSize: 14.0,
													),
												),
											),
										),
									]
								),
								new Container(
									padding: new EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
									alignment: Alignment.topLeft,
									child: new Text(
										'Email'.toUpperCase(),
										style: new TextStyle(
											color: const Color(0xFF838383),
											fontFamily: 'Montserrat',
											fontWeight: FontWeight.w800,
											fontSize: 14.0,
										),
									),
								),
								new Container(
									padding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
							        child: new TextField(
							        	controller: _emailController,
										style: new TextStyle(
											color: const Color(0xFF000000),
											fontFamily: 'Montserrat',
											fontWeight: FontWeight.w800,
											fontSize: 18.0,
										),
										decoration: new InputDecoration(
							            	fillColor: const Color(0x66E0E1EA),
											filled: true,
										),
										keyboardType: TextInputType.emailAddress,
							        ),
								),
								new Container(
									padding: new EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
									alignment: Alignment.topLeft,
									child: new Text(
										'Password'.toUpperCase(),
										style: new TextStyle(
											color: const Color(0xFF838383),
											fontFamily: 'Montserrat',
											fontWeight: FontWeight.w800,
											fontSize: 14.0,
										),
									),
								),
								new Container(
									padding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
							        child: new TextField(
							        	obscureText: true,
										style: new TextStyle(
											color: const Color(0xFF000000),
											fontFamily: 'Montserrat',
											fontWeight: FontWeight.w800,
											fontSize: 18.0,
										),
										decoration: new InputDecoration(
							            	fillColor: const Color(0x66E0E1EA),
											filled: true,
										),
										keyboardType: TextInputType.emailAddress,
							        ),
								),
								new Expanded(
									child: new Align(
										alignment: Alignment.bottomCenter,
										child: new Row(children: <Widget>[
											new Expanded(
												child: new RaisedButton(
														onPressed: () {
															showDialog(
																context: context,
																child: new AlertDialog(
																	title: new Text('What you typed:'),
																	content: new Text(_emailController.text),
																),
															);
														},
														padding: new EdgeInsets.all(14.0),  
														color: const Color(0xFF1033FF),
														textColor: const Color(0xFFFFFFFF),
														child: new Text(
															'Login'.toUpperCase(),
															style: new TextStyle(
																fontFamily: 'Montserrat',
																fontWeight: FontWeight.w800,
															),
														),
													),
												)
											]
										),
									),
								),
						    ],
						),
					);
				},
			),
		);
	}
    
	@override
	Widget build(BuildContext context) {
	  
		SystemChrome.setEnabledSystemUIOverlays([]);
	  
    // This method is rerun every time setState is called
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      body: new Container(
	    padding: new EdgeInsets.all(40.0),
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: new Align(
			alignment: Alignment.bottomCenter,
			child: new Column(
				mainAxisSize: MainAxisSize.min,
				children: <Widget>[
					new Expanded(
						child: new Align(
							alignment: Alignment.topCenter,
							child: new Container(
								padding: new EdgeInsets.all(60.0),
								child: new Image.asset("images/LogoStack-White.png", height: 53.0),
							)
						)
					),
					new Row(
						children: <Widget>[
							new Expanded(
								child: new RaisedButton(
									onPressed: _createAccount,
									padding: new EdgeInsets.all(14.0),  
									color: const Color(0xFF1033FF),
									textColor: const Color(0xFFFFFFFF),
									child: new Text(
										'CREATE ACCOUNT',
										style: new TextStyle(
											fontFamily: 'Montserrat',
											fontWeight: FontWeight.w800,
										),
									),
								),
							)
						]
					),
					new Container(
						padding: new EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 10.0),
						child: new Text(
							'Already a member?',
							style: new TextStyle(
								color: const Color(0xFFFFFFFF),
								fontFamily: 'Montserrat',
							),
						),
					),
					new Row(
						children: <Widget>[
							new Expanded(
								child: new RaisedButton(
									onPressed: _login,
									padding: new EdgeInsets.all(14.0),  
									color: const Color(0xFFE3F5FF),
									textColor: const Color(0xFF2D2D2F),
									child: new Text(
										'LOGIN',
										style: new TextStyle(
											fontFamily: 'Montserrat',
											fontWeight: FontWeight.w800,
										),
									),
								),
							)
						]
					),
				]
			
			)
	    ),
      ),
	  
    );
  }
}
