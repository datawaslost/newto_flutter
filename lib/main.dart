import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'package:carousel/carousel.dart';
import "dart:ui";

void main() => runApp(new MyApp());

	class MyApp extends StatelessWidget {
	// This widget is the root of your application.
	@override
	Widget build(BuildContext context) {
		return new MaterialApp(
			title: 'NewTo',
			theme: new ThemeData(
				// This is the theme of your application.
				primarySwatch: Colors.blue,
				backgroundColor: const Color(0xFF000000),
				canvasColor: const Color(0xFF000000),
				scaffoldBackgroundColor: const Color(0xFFFFFFFF),
				disabledColor: const Color(0xFFFFFFFF),
				buttonColor: const Color(0xFFFFFFFF),
				iconTheme: new IconThemeData( color: const Color(0xFFFFFFFF) ),
				primaryIconTheme: new IconThemeData( color: const Color(0xFFFFFFFF) ),
				accentIconTheme: new IconThemeData( color: const Color(0xFFFFFFFF) ),
				bottomAppBarColor: const Color(0x000000),
				primaryColor: const Color(0xFF000000),
				indicatorColor: const Color(0xFF00C3FF),
			),
			// home: new Onboarding(),
			home: new Home(),
		    routes: <String, WidgetBuilder> {
				'/onboarding': (BuildContext context) => new Onboarding(title: 'on b'),
				'/landing': (BuildContext context) => new Landing(title: 'on b'),
				'/yourlist': (BuildContext context) => new YourList(title: 'on b'),
			},
		);
	}
}

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {

	bool isLoggedIn = true;
	
    @override
    void initState() {
      super.initState();
      
      // need to test for logged in state here.

      if(!isLoggedIn) {
        print("not logged in, going to login page");
		SchedulerBinding.instance.addPostFrameCallback((_) {
		  Navigator.of(context).pushNamed("/onboarding");
		});
      } else {
		SchedulerBinding.instance.addPostFrameCallback((_) {
		  Navigator.of(context).pushNamed("/landing");
		});
	  }

    }
    
	@override
	Widget build(BuildContext context) {
		return new Scaffold();
	}
	
}

class Onboarding extends StatefulWidget {
  Onboarding({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _OnboardingState createState() => new _OnboardingState();
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
  });

  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onFieldSubmitted;

  @override
  _PasswordFieldState createState() => new _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
	bool _obscureText = true;
	
	@override
	Widget build(BuildContext context) {
		return new TextFormField(
			obscureText: _obscureText,
			onSaved: widget.onSaved,
			validator: widget.validator,
			onFieldSubmitted: widget.onFieldSubmitted,
			style: new TextStyle(
				color: const Color(0xFF000000),
				fontFamily: 'Montserrat',
				fontWeight: FontWeight.w800,
				fontSize: 18.0,
			),
			decoration: new InputDecoration(
				fillColor: const Color(0x66E0E1EA),
				filled: true,
				suffixIcon: new GestureDetector(
				  onTap: () {
				    setState(() {
				      _obscureText = !_obscureText;
				    });
				  },
				  child: new Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
				),
			),
		);
	}
}

class _OnboardingState extends State<Onboarding> {

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
									value: 0.33,
									backgroundColor: const Color(0xFFFFFFFF),
								),
								new Row (
									children: <Widget>[
										new BackButton(),
										new Expanded(
											child: new Container(
												alignment: Alignment.topRight,
												child: new FlatButton(
													onPressed: _login,
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
									alignment: Alignment.topLeft,
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
														onPressed: _createAccount2,
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

	void _createAccount2() {
		Navigator.of(context).push(
			new MaterialPageRoute(
				builder: (context) {
					return new Scaffold(
						body: new Column(
							mainAxisSize: MainAxisSize.min,
							children: <Widget>[
								new LinearProgressIndicator(
									value: 0.66,
									backgroundColor: const Color(0xFFFFFFFF),
								),
								new Row (
									children: <Widget>[
										new BackButton(),
										new Expanded(
											child: new Container(
												alignment: Alignment.topRight,
												child: new FlatButton(
													onPressed: _login,
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
										),
									]
								),
								new Container(
									padding: new EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 0.0),
									alignment: Alignment.topLeft,
									child: new Text(
										'2/3',
										style: new TextStyle(
											fontFamily: 'Montserrat',
											fontWeight: FontWeight.w800,
											fontSize: 14.0,
										),
									),
								),
								new Container(
									padding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
									alignment: Alignment.topLeft,
									child: new Text(
										'Create your password.'.toUpperCase(),
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
							        child: new PasswordField(),
								),
								new Expanded(
									child: new Align(
										alignment: Alignment.bottomCenter,
										child: new Row(
											children: <Widget>[
												new Expanded(
													child: new RaisedButton(
														onPressed: _createAccount3,
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
							]
						),
					);
				},
			),
		);
	}

	void _createAccount3() {
		Navigator.of(context).push(
			new MaterialPageRoute(
				builder: (context) {
					return new Scaffold(
						body: new Column(
							mainAxisSize: MainAxisSize.min,
							children: <Widget>[
								new LinearProgressIndicator(
									value: 1.0,
									backgroundColor: const Color(0xFFFFFFFF),
								),
								new Row (
									children: <Widget>[
										new BackButton(),
										new Expanded(
											child: new Container(
												alignment: Alignment.topRight,
												child: new FlatButton(
													onPressed: _login,
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
										),
									]
								),
								new Container(
									padding: new EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 0.0),
									alignment: Alignment.topLeft,
									child: new Text(
										'3/3',
										style: new TextStyle(
											fontFamily: 'Montserrat',
											fontWeight: FontWeight.w800,
											fontSize: 14.0,
										),
									),
								),
								new Container(
									padding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
									alignment: Alignment.topLeft,
									child: new Text(
										'What is your hometown?'.toUpperCase(),
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
										"I'm From".toUpperCase(),
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
							        ),
								),
								new Expanded(
									child: new Align(
										alignment: Alignment.bottomCenter,
										child: new Row(
											children: <Widget>[
												new Expanded(
													child: new RaisedButton(
														onPressed: _landing,
														padding: new EdgeInsets.all(14.0),  
														color: const Color(0xFF1033FF),
														textColor: const Color(0xFFFFFFFF),
														child: new Text(
															'Complete Sign Up'.toUpperCase(),
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
							]
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
												alignment: Alignment.topRight,
												child: new FlatButton(
													onPressed: _createAccount,
													child: new Text(
														'Create Account'.toUpperCase(),
														style: new TextStyle(
															color: const Color(0xFF1033FF),
															fontFamily: 'Montserrat',
															fontWeight: FontWeight.w800,
															fontSize: 14.0,
														),
													),
												),
											),
										),
									]
								),
								new Container(
									padding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
									alignment: Alignment.topLeft,
									child: new Text(
										'Login'.toUpperCase(),
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
							        child: new PasswordField(),
								),
								new Expanded(
									child: new Align(
										alignment: Alignment.bottomCenter,
										child: new Row(children: <Widget>[
											new Expanded(
												child: new RaisedButton(
														onPressed: _landing,
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
	
	void _landing() {
		// go to landing page
		Navigator.of(context).pushNamed('/landing');
	}
	
	@override
	Widget build(BuildContext context) {
	  
		// SystemChrome.setEnabledSystemUIOverlays([]);
	  
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


class Landing extends StatefulWidget {
	Landing({Key key, this.title}) : super(key: key);
	
	final String title;
	
	@override
	_LandingState createState() => new _LandingState();
}


class _LandingState extends State<Landing> {
	
	void _account() {
		// load account info
		Navigator.of(context).pushNamed('/onboarding');
	}
	
	void _yourlist() {
		// go to list page
		Navigator.of(context).pushNamed('/yourlist');
	}

	@override
	Widget build(BuildContext context) {
	  
		// SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
		
		return new Scaffold(
			backgroundColor: const Color(0xFF000000),
			appBar: new AppBar(
				backgroundColor: const Color(0xFF000000),
				centerTitle: true,
				title: new Container(
					alignment: Alignment.centerRight,
					child: new Row(
						children: <Widget>[
							new Expanded(
								child: new Container(
									alignment: Alignment.centerRight,
									child: new Image.asset("images/LogoSpan-White.png", height: 12.0),
								)
							),
							new Expanded(
								child: new Container(
									alignment: Alignment.centerLeft,
									child: new Text(
										'UWM'.toUpperCase(),
										style: new TextStyle(
											color: const Color(0xFF838383),
											fontFamily: 'Montserrat',
											fontWeight: FontWeight.w300,
											fontSize: 14.0,
										),
									),
								),
							),
						]
					)
				),
				// title: new Image.asset("images/LogoSpan-White.png", height: 12.0),
				leading: new Container(),
				actions: <Widget>[
					new IconButton(
						icon: new Icon(Icons.account_circle ),
						tooltip: 'Account',
						onPressed: _account,
					),
				],
			),
			body: new Column(
				mainAxisSize: MainAxisSize.min,
				children: <Widget>[
					new Expanded(
						child: new Carousel(
							displayDuration: new Duration(seconds: 20),
							children: [
							    new Container(
									padding: new EdgeInsets.fromLTRB(65.0, 0.0, 65.0, 0.0),
									alignment: Alignment.center,
									child: new Column(
										mainAxisSize: MainAxisSize.min,
										children: <Widget>[
											new Text(
												'Your List'.toUpperCase(),
												textAlign: TextAlign.center,
												style: new TextStyle(
													color: const Color(0xFF838383),
													fontFamily: 'Montserrat',
													fontWeight: FontWeight.w800,
													fontSize: 14.0,
												),
											),
											new SizedBox(height: 10.0),
											new Text(
												'Tell your friends your new address'.toUpperCase(),
												textAlign: TextAlign.center,
												style: new TextStyle(
													color: const Color(0xFFFFFFFF),
													fontFamily: 'Montserrat',
													fontWeight: FontWeight.w800,
													fontSize: 24.0,
													height: 0.9,
												),
											),
											new FlatButton(
												onPressed: _yourlist,
												child: new Icon(
													Icons.arrow_forward,
													color: const Color(0xFFFFFFFF),
												),
											),
										],
									),
								),
							    new Container(
									padding: new EdgeInsets.fromLTRB(65.0, 0.0, 65.0, 0.0),
									alignment: Alignment.center,
									child: new Column(
										mainAxisSize: MainAxisSize.min,
										children: <Widget>[
											new Text(
												'Your List'.toUpperCase(),
												textAlign: TextAlign.center,
												style: new TextStyle(
													color: const Color(0xFF838383),
													fontFamily: 'Montserrat',
													fontWeight: FontWeight.w800,
													fontSize: 14.0,
												),
											),
											new SizedBox(height: 10.0),
											new Text(
												'Turn in your housing insurance forms'.toUpperCase(),
												textAlign: TextAlign.center,
												style: new TextStyle(
													color: const Color(0xFFFFFFFF),
													fontFamily: 'Montserrat',
													fontWeight: FontWeight.w800,
													fontSize: 24.0,
													height: 0.9,
												),
											),
											new FlatButton(
												onPressed: _yourlist,
												child: new Icon(
													Icons.arrow_forward,
													color: const Color(0xFFFFFFFF),
												),
											),
										],
									),
								),
							]
						),
					),
					new Container(
						child: new LinearProgressIndicator(
							value: 0.5,
							backgroundColor: const Color(0xFF2D2D2F),
							valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
						),
						decoration: new BoxDecoration(
							boxShadow: [
								new BoxShadow(
									color: Colors.black,
									blurRadius: 20.0,
								),
							]
						),
					),
					new Container(
						height: 365.0,
						decoration: new BoxDecoration(
							color: const Color(0xFFFFFFFF),
						),
						child: new Column(
							mainAxisSize: MainAxisSize.min,
							children: <Widget>[
								new SizedBox(height: 25.0),
								new Text(
									'Discover'.toUpperCase(),
									textAlign: TextAlign.center,
									style: new TextStyle(
										color: const Color(0xFF838383),
										fontFamily: 'Montserrat',
										fontWeight: FontWeight.w800,
										fontSize: 14.0,
									),
								),
								// new SizedBox(height: 10.0),
								new Expanded(
									child: new Container(
										margin: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
										child: new ListView(
											scrollDirection: Axis.horizontal,
											shrinkWrap: true,
											children: <Widget>[
												new Container(
													width: 278.0,
													height: 278.0,
													margin: new EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 20.0),
													child: new Card(
														elevation: 8.0,
														child: new Container(
															decoration: new BoxDecoration(
																image: new DecorationImage(
																	image: new AssetImage('images/cardphoto.png'),
																	fit: BoxFit.cover,
																),
															),
															child: new Column(
																mainAxisSize: MainAxisSize.min,
																children: <Widget>[
																	new BackdropFilter(
																		filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
																		child: new Container(
																			padding: new EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
																			child: new Text(
																				'Create the Perfect Dorm Room'.toUpperCase(),
																				textAlign: TextAlign.left,
																				style: new TextStyle(
																					color: const Color(0xFF000000),
																					fontFamily: 'Montserrat',
																					fontWeight: FontWeight.w800,
																					fontSize: 24.0,
																				),
																			),
																			decoration: new BoxDecoration(color: Colors.white.withOpacity(0.5)),
																		),
																	),
																],
															),
														),
													),
												),
												new Container(
													width: 278.0,
													height: 278.0,
													margin: new EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 20.0),
													child: new Card(
														elevation: 8.0,
														child: new Container(
															decoration: new BoxDecoration(
																image: new DecorationImage(
																	image: new AssetImage('images/background.png'),
																	fit: BoxFit.cover,
																),
															),
															child: new Column(
																mainAxisSize: MainAxisSize.min,
																children: <Widget>[
																	new BackdropFilter(
																		filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
																		child: new Container(
																			padding: new EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
																			child: new Text(
																				'Get to know UMW'.toUpperCase(),
																				textAlign: TextAlign.left,
																				style: new TextStyle(
																					color: const Color(0xFF000000),
																					fontFamily: 'Montserrat',
																					fontWeight: FontWeight.w800,
																					fontSize: 24.0,
																				),
																			),
																			decoration: new BoxDecoration(color: Colors.white.withOpacity(0.5)),
																		),
																	),
																],
															),
														),
													),
												),
											],
										)
									)
								)
							],
						),
					)
				]
			),
			bottomNavigationBar: new BottomNavigationBar(
				type: BottomNavigationBarType.fixed,
				iconSize: 39.0,
				fixedColor: const Color(0xFFFFFFFF),
				items: <BottomNavigationBarItem>[
					new BottomNavigationBarItem(
						icon: new Icon(Icons.home, color: const Color(0xFFFFFFFF)  ),
						title: new Text("", style: new TextStyle(fontSize: 0.0)),
					),
					new BottomNavigationBarItem(
						icon: new Icon(Icons.filter_none, color: const Color(0xFFFFFFFF) ),
						title: new Text("", style: new TextStyle(fontSize: 0.0)),
					),
					new BottomNavigationBarItem(
						icon: new Icon(Icons.location_searching, color: const Color(0xFFFFFFFF) ),
						title: new Text("", style: new TextStyle(fontSize: 0.0)),
					),
					new BottomNavigationBarItem(
						icon: new Icon(Icons.bookmark, color: const Color(0xFFFFFFFF) ),
						title: new Text("", style: new TextStyle(fontSize: 0.0)),
					),
					new BottomNavigationBarItem(
						icon: new Icon(Icons.insert_emoticon, color: const Color(0xFFFFFFFF) ),
						title: new Text("", style: new TextStyle(fontSize: 0.0)),
					),
				]
			),
		);

	}
	
}


class YourList extends StatefulWidget {
	YourList({Key key, this.title}) : super(key: key);
	
	final String title;
	
	@override
	_YourListState createState() => new _YourListState();
}


class _YourListState extends State<YourList> {

	void _account() {
		// load account info
		Navigator.of(context).pushNamed('/onboarding');
	}
	
	void _goto() {
		// holder
	}

	@override
	Widget build(BuildContext context) {
		  		
	    return new DefaultTabController(
	        length: 3,
	        child: new Scaffold(
				backgroundColor: const Color(0xFFF3F3F7),
				appBar: new AppBar(
					titleSpacing: 0.0,
					backgroundColor: const Color(0xFF000000),
					centerTitle: true,
					automaticallyImplyLeading: false,
					title: new TabBar(
						indicatorWeight: 4.0,
						indicatorColor: const Color(0xFF00C3FF),
						indicatorSize: TabBarIndicatorSize.label,
						isScrollable: false,
						labelStyle: new TextStyle(
							fontFamily: 'Montserrat',
							fontWeight: FontWeight.w800,
							fontSize: 14.0,
							height: 2.0,
						),
						tabs: [
							new Tab(text: "Your List".toUpperCase()),
							new Tab(text: "Popular".toUpperCase()),
							new Tab(text: "UWM".toUpperCase()),
						],
					),
					actions: <Widget>[
						new IconButton(
							icon: new Icon(Icons.account_circle ),
							tooltip: 'Account',
							onPressed: _account,
						),
					],
				),
				body: new TabBarView(
					children: [
						new CustomScrollView(
							primary: false,
							slivers: <Widget>[
								new SliverPadding(
									padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
									sliver: new SliverGrid.count(
										crossAxisSpacing: 10.0,
										mainAxisSpacing: 10.0,
										crossAxisCount: 2,
										childAspectRatio: 1.1,
										children: <Widget>[
											new Card(
												elevation: 3.0,
												child: new Container(
													padding: const EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 10.0),
													child: new Text(
														'Tell your friends your new address',
														textAlign: TextAlign.left,
														style: new TextStyle(
															color: const Color(0xFF000000),
															fontFamily: 'Montserrat',
															fontWeight: FontWeight.w700,
															fontSize: 14.0,
														),
													),
												),
											),
											new Card(
												elevation: 3.0,
												child: new Container(
													padding: const EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 10.0),
													child: new Text(
														"Plan how you're going to get around campus",
														textAlign: TextAlign.left,
														style: new TextStyle(
															color: const Color(0xFF000000),
															fontFamily: 'Montserrat',
															fontWeight: FontWeight.w700,
															fontSize: 14.0,
														),
													),
												),
											),
											new Card(
												elevation: 3.0,
												child: new Container(
													padding: const EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 10.0),
													child: new Text(
														'Find Your Doctor, Dentist, Eye care, Pharmacy',
														textAlign: TextAlign.left,
														style: new TextStyle(
															color: const Color(0xFF000000),
															fontFamily: 'Montserrat',
															fontWeight: FontWeight.w700,
															fontSize: 14.0,
														),
													),
												),
											),
											new Card(
												elevation: 3.0,
												child: new Container(
													padding: const EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 10.0),
													child: new Text(
														'Find the nearest grocery store',
														textAlign: TextAlign.left,
														style: new TextStyle(
															color: const Color(0xFF000000),
															fontFamily: 'Montserrat',
															fontWeight: FontWeight.w700,
															fontSize: 14.0,
														),
													),
												),
											),
										],
									),
								),
								new SliverPadding(
									padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
									sliver: new SliverGrid.count(
										crossAxisSpacing: 10.0,
										mainAxisSpacing: 10.0,
										crossAxisCount: 1,
										childAspectRatio: 2.75,
										children: <Widget>[
											new Card(
												elevation: 3.0,
												child: new Column(
													mainAxisSize: MainAxisSize.min,
													children: <Widget>[
														new Container(
															padding: const EdgeInsets.fromLTRB(20.0, 15.0, 10.0, 7.5),
															child: new Text(
																'Popular Activity Name Title Group'.toUpperCase(),
																textAlign: TextAlign.left,
																style: new TextStyle(
																	color: const Color(0xFF000000),
																	fontFamily: 'Montserrat',
																	fontWeight: FontWeight.w800,
																	fontSize: 24.0,
																),
															),
														),
														new Container(
															padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
															child: new Row(
																children: [
																	new Expanded(
																		child: new Text(
																			'Sponsored by UWM'.toUpperCase(),
																			textAlign: TextAlign.left,
																			style: new TextStyle(
																				color: const Color(0xFF838383),
																				fontFamily: 'Montserrat',
																				fontWeight: FontWeight.w800,
																				fontSize: 10.0,
																			),
																		),
																	),
																	new Text(
																		'4 '.toUpperCase(),
																		textAlign: TextAlign.left,
																		style: new TextStyle(
																			color: const Color(0xFF838383),
																			fontFamily: 'Montserrat',
																			fontWeight: FontWeight.w800,
																			fontSize: 10.0,
																		),
																	),
																	new Container(
																		padding: const EdgeInsets.fromLTRB(3.0, 0.0, 0.0, 0.0),
																		child: new Icon(
																			Icons.filter_none, 
																			color: const Color(0xFF838383), 
																			size: 10.0
																		)
																	),
																]
															)
														),
													],
												),
											),
											new Card(
												elevation: 3.0,
												child: new Column(
													mainAxisSize: MainAxisSize.min,
													children: <Widget>[
														new Container(
															padding: const EdgeInsets.fromLTRB(20.0, 15.0, 10.0, 7.5),
															child: new Text(
																'Popular Activity Name Title Group'.toUpperCase(),
																textAlign: TextAlign.left,
																style: new TextStyle(
																	color: const Color(0xFF000000),
																	fontFamily: 'Montserrat',
																	fontWeight: FontWeight.w800,
																	fontSize: 24.0,
																),
															),
														),
														new Container(
															padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
															child: new Row(
																children: [
																	new Expanded(
																		child: new Text(
																			'Sponsored by UWM'.toUpperCase(),
																			textAlign: TextAlign.left,
																			style: new TextStyle(
																				color: const Color(0xFF838383),
																				fontFamily: 'Montserrat',
																				fontWeight: FontWeight.w800,
																				fontSize: 10.0,
																			),
																		),
																	),
																	new Text(
																		'4 '.toUpperCase(),
																		textAlign: TextAlign.left,
																		style: new TextStyle(
																			color: const Color(0xFF838383),
																			fontFamily: 'Montserrat',
																			fontWeight: FontWeight.w800,
																			fontSize: 10.0,
																		),
																	),
																	new Container(
																		padding: const EdgeInsets.fromLTRB(3.0, 0.0, 0.0, 0.0),
																		child: new Icon(
																			Icons.filter_none, 
																			color: const Color(0xFF838383), 
																			size: 10.0
																		)
																	),
																]
															)
														),
													],
												),
											),
										],
									),
								),
								new SliverPadding(
									padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
									sliver: new SliverGrid.count(
										crossAxisSpacing: 10.0,
										mainAxisSpacing: 10.0,
										crossAxisCount: 2,
										childAspectRatio: 1.1,
										children: <Widget>[
											new Card(
												elevation: 3.0,
												child: new Container(
													padding: const EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 10.0),
													child: new Text(
														'Find the nearest convenience store',
														textAlign: TextAlign.left,
														style: new TextStyle(
															color: const Color(0xFF000000),
															fontFamily: 'Montserrat',
															fontWeight: FontWeight.w700,
															fontSize: 14.0,
														),
													),
												),
											),
											new Card(
												elevation: 3.0,
												child: new Container(
													padding: const EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 10.0),
													child: new Text(
														"Buy books for your class",
														textAlign: TextAlign.left,
														style: new TextStyle(
															color: const Color(0xFF000000),
															fontFamily: 'Montserrat',
															fontWeight: FontWeight.w700,
															fontSize: 14.0,
														),
													),
												),
											),
										],
									),
								),
								new SliverPadding(
									padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
								),
							],
						),
						new Icon(Icons.directions_transit),
						new Icon(Icons.directions_bike),
					],
				),
				bottomNavigationBar: new BottomNavigationBar(
					type: BottomNavigationBarType.fixed,
					iconSize: 39.0,
					fixedColor: const Color(0xFFFFFFFF),
					items: <BottomNavigationBarItem>[
						new BottomNavigationBarItem(
							icon: new Icon(Icons.home, color: const Color(0xFFFFFFFF)  ),
							title: new Text("", style: new TextStyle(fontSize: 0.0)),
						),
						new BottomNavigationBarItem(
							icon: new Icon(Icons.filter_none, color: const Color(0xFFFFFFFF) ),
							title: new Text("", style: new TextStyle(fontSize: 0.0)),
						),
						new BottomNavigationBarItem(
							icon: new Icon(Icons.location_searching, color: const Color(0xFFFFFFFF) ),
							title: new Text("", style: new TextStyle(fontSize: 0.0)),
						),
						new BottomNavigationBarItem(
							icon: new Icon(Icons.bookmark, color: const Color(0xFFFFFFFF) ),
							title: new Text("", style: new TextStyle(fontSize: 0.0)),
						),
						new BottomNavigationBarItem(
							icon: new Icon(Icons.insert_emoticon, color: const Color(0xFFFFFFFF) ),
							title: new Text("", style: new TextStyle(fontSize: 0.0)),
						),
					]
				)
			)
		);

	}

}
