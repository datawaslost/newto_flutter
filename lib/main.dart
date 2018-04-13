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
				'/onboarding': (BuildContext context) => new Onboarding(),
				'/landing': (BuildContext context) => new Landing(),
				'/yourlist': (BuildContext context) => new YourList(),
				'/listitems': (BuildContext context) => new ListItems(),
				'/discover': (BuildContext context) => new Discover(),
				'/search': (BuildContext context) => new Search(),
				'/searchresults': (BuildContext context) => new SearchResults(),
				'/bookmarks': (BuildContext context) => new Bookmarks(),
			},
		);
	}
}

void _navbar(num){
	// bottom nav bar decider
	switch (num) {
		case 0:
			return '/landing';
			break;
		case 1:
			return '/yourlist';
			break;
		case 2:
			return '/discover';	
			break;
		case 3:
			return '/bookmarks';	
			break;
		case 4:
			return '/org';	
			break;
	}
}

class bottomBar extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return new BottomNavigationBar(
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
			],
			onTap: (num) => Navigator.of(context).pushNamed(_navbar(num)),
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
			bottomNavigationBar: new bottomBar(),
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
						// Your List
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
									padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
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
									padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
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
									padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
									sliver: new SliverGrid.count(
										crossAxisSpacing: 10.0,
										mainAxisSpacing: 10.0,
										crossAxisCount: 1,
										childAspectRatio: 1.0,
										children: <Widget>[
											new Card(
												elevation: 3.0,
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
															new Expanded(
																child: new Container()
															),															
															new Row(
																children: [
																	new Container(
																		padding: new EdgeInsets.fromLTRB(11.0, 8.0, 11.0, 7.0),
																		child: new Text(
																			'Sponsor'.toUpperCase(),
																			textAlign: TextAlign.left,
																			style: new TextStyle(
																				color: const Color(0xFF000000),
																				fontFamily: 'Montserrat',
																				fontWeight: FontWeight.w800,
																				fontSize: 10.0,
																			),
																		),
																		decoration: new BoxDecoration(color: const Color(0xFFFCEE21) ),
																	),
																	new Expanded(
																		child: new Container()
																	),
																]
															)
														],
													),
												),
											),
										]
									)
								),
								new SliverPadding(
									padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
									sliver: new SliverGrid.count(
										crossAxisCount: 1,
										childAspectRatio: 4.0,
										children: <Widget>[
											new Row(
												children: <Widget>[
													new Expanded( child: new Container() ),
													new Container(
														decoration: new BoxDecoration (
															borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
															color: const Color(0xFF1033FF),
														),
														padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
														child: new Row(
															children: <Widget>[
																new Container(
																	padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
																	child: const Icon(Icons.add, size: 18.0),
																),
																new Container(
																	padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
																	child: const Icon(Icons.create, size: 18.0),
																),
																new Container(
																	padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
																	child: const Icon(Icons.more_horiz, size: 18.0),
																),
															],
														),
													),
													new Expanded( child: new Container() ),
												]
											)
										]
									)
								),
							],
						),
						// Popular
						new CustomScrollView(
							primary: false,
							slivers: <Widget>[
								new SliverPadding(
									padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
									sliver: new SliverGrid.count(
										crossAxisCount: 1,
										childAspectRatio: 1.2,
										children: <Widget>[
											new GestureDetector(
												onTap: (){
													// go to list view
													Navigator.of(context).pushNamed('/listitems');
												},
												child: new Stack(
													fit: StackFit.expand,
													children: <Widget>[
														new Container(
															margin: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
															child: new Card(
																elevation: 3.0,
																child: new Container(
																	padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 15.0),
																	child: new Column(
																		children: [
																			new Expanded( child: new Container() ),
																			new Row(
																				crossAxisAlignment: CrossAxisAlignment.end,
																				children: [
																					new Expanded(
																						child: new Text(
																							'Back to school essentials'.toUpperCase(),
																							textAlign: TextAlign.left,
																							style: new TextStyle(
																								color: const Color(0xFF000000),
																								fontFamily: 'Montserrat',
																								fontWeight: FontWeight.w800,
																								fontSize: 24.0,
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
																		]
																	)
																),														
															),
														),
														new Container(
															margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 80.0),
															padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
															child: new Container(
																decoration: new BoxDecoration(
																	image: new DecorationImage(
																		image: new AssetImage('images/cardphoto.png'),
																		fit: BoxFit.cover,
																	),
																),
															),
														),
													],
												),
											),
										]
									),
								),
								new SliverPadding(
									padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
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
														"Set up your email and student accounts",
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
														'Check in and get your welcome packet',
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
														'Buy books for your classes',
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
									padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
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
										],
									),
								),
							],
						),
						new Icon(Icons.directions_bike),
					],
				),
				bottomNavigationBar: new bottomBar(),
			)
		);

	}

}


class ListItems extends StatefulWidget {
	ListItems({Key key, this.title}) : super(key: key);
	
	final String title;
	
	@override
	_ListItemsState createState() => new _ListItemsState();
}


class _ListItemsState extends State<ListItems> {
	
	@override
	Widget build(BuildContext context) {
	  
		// SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
		
		return new Scaffold(
			backgroundColor: const Color(0xFFF3F3F7),
			body: new CustomScrollView(
				primary: false,
				slivers: <Widget>[
					new SliverAppBar(
						backgroundColor: const Color(0xFFF3F3F7),
						pinned: false,
						expandedHeight: 230.0,
						floating: true,
						leading: new Container(),
						actions: <Widget>[
							new IconButton(
								icon: new Icon(Icons.close ),
								tooltip: 'Close',
								onPressed: () => Navigator.pop(context,true)
							),
						],
						flexibleSpace: const FlexibleSpaceBar(
							background: const Image(
								image: const AssetImage('images/cardphoto.png'),
								fit: BoxFit.cover,
							)
						),
					),
					new SliverPadding(
						padding: const EdgeInsets.all(20.0),
						sliver: new SliverGrid.count(
							crossAxisSpacing: 10.0,
							mainAxisSpacing: 10.0,
							crossAxisCount: 1,
							childAspectRatio: 8.0,
							children: <Widget>[
								new Text(
									'Back to school essentials'.toUpperCase(),
									textAlign: TextAlign.left,
									style: new TextStyle(
										color: const Color(0xFF000000),
										fontFamily: 'Montserrat',
										fontWeight: FontWeight.w800,
										fontSize: 28.0,
										height: 0.9,
									),
								),
							]
						),
					),
					new SliverPadding(
						padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
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
											"Set up your email and student accounts",
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
											'Check in and get your welcome packet',
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
											'Buy books for your classes',
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
						padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
						sliver: new SliverGrid.count(
							crossAxisSpacing: 10.0,
							mainAxisSpacing: 10.0,
							crossAxisCount: 1,
							childAspectRatio: 1.0,
							children: <Widget>[
								new Card(
									elevation: 3.0,
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
												new Expanded(
													child: new Container()
												),															
												new Row(
													children: [
														new Container(
															padding: new EdgeInsets.fromLTRB(11.0, 8.0, 11.0, 7.0),
															child: new Text(
																'Sponsor'.toUpperCase(),
																textAlign: TextAlign.left,
																style: new TextStyle(
																	color: const Color(0xFF000000),
																	fontFamily: 'Montserrat',
																	fontWeight: FontWeight.w800,
																	fontSize: 10.0,
																),
															),
															decoration: new BoxDecoration(color: const Color(0xFFFCEE21) ),
														),
														new Expanded(
															child: new Container()
														),
													]
												)
											],
										),
									),
								),
							]
						)
					),

				]
			),
		);
		
	}

}


class Discover extends StatefulWidget {
	Discover({Key key, this.title}) : super(key: key);
	
	final String title;
	
	@override
	_DiscoverState createState() => new _DiscoverState();
}


class _DiscoverState extends State<Discover> {
	
	void _account() {
		// load account info
		Navigator.of(context).pushNamed('/onboarding');
	}
	
	void _search() {
		// go to list page
		Navigator.of(context).pushNamed('/search');
	}

	@override
	Widget build(BuildContext context) {
	  
		return new Scaffold(
			backgroundColor: const Color(0xFF000000),
			appBar: new AppBar(
				backgroundColor: const Color(0xFF000000),
				centerTitle: true,
				title: new Text(
					'Discover Madison, WI'.toUpperCase(),
					style: new TextStyle(
						color: const Color(0xFF838383),
						fontFamily: 'Montserrat',
						fontWeight: FontWeight.w800,
						fontSize: 14.0,
					),
				),
				leading: new Container(),
				actions: <Widget>[
					new IconButton(
						icon: new Icon(Icons.account_circle ),
						tooltip: 'Account',
						onPressed: _account,
					),
				],
			),
			body: new SingleChildScrollView(
				scrollDirection: Axis.vertical,
				child: new Column(
					mainAxisSize: MainAxisSize.min,
					children: <Widget>[
						new Container(
							child: new Column(
								mainAxisSize: MainAxisSize.min,
								children: <Widget>[
									new Container(
										padding: new EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
										child: new Text(
											'Find places that best speak to you'.toUpperCase(),
											textAlign: TextAlign.center,
											style: new TextStyle(
												color: const Color(0xFFFFFFFF),
												fontFamily: 'Montserrat',
												fontWeight: FontWeight.w800,
												fontSize: 28.0,
											),
										),
									),
									new Container(
										margin: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
										height: 255.0,
										child: new ListView(
											scrollDirection: Axis.horizontal,
											shrinkWrap: true,
											children: <Widget>[
												new Container(
													margin: new EdgeInsets.fromLTRB(20.0, 0.0, 5.0, 0.0),
													child: new Column(
														mainAxisSize: MainAxisSize.min,
														crossAxisAlignment: CrossAxisAlignment.start,
														children: <Widget>[
															new Container(
																width: 150.0,
																height: 180.0,
																decoration: new BoxDecoration(
																	image: new DecorationImage(
																		image: new AssetImage('images/cardphoto.png'),
																		fit: BoxFit.cover,
																	),
																),
															),
															new Text(
																'Groceries'.toUpperCase(),
																textAlign: TextAlign.left,
																style: new TextStyle(
																	color: const Color(0xFFFFFFFF),
																	fontFamily: 'Montserrat',
																	fontWeight: FontWeight.w800,
																	fontSize: 14.0,
																	height: 1.8,
																),
															),
														],
													),
												),
												new Container(
													margin: new EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
													child: new Column(
														mainAxisSize: MainAxisSize.min,
														crossAxisAlignment: CrossAxisAlignment.start,
														children: <Widget>[
															new Container(
																width: 150.0,
																height: 180.0,
																decoration: new BoxDecoration(
																	image: new DecorationImage(
																		image: new AssetImage('images/cardphoto.png'),
																		fit: BoxFit.cover,
																	),
																),
															),
															new Text(
																'Restaurants'.toUpperCase(),
																textAlign: TextAlign.left,
																style: new TextStyle(
																	color: const Color(0xFFFFFFFF),
																	fontFamily: 'Montserrat',
																	fontWeight: FontWeight.w800,
																	fontSize: 14.0,
																	height: 1.8,
																),
															),
														],
													),
												),
												new Container(
													margin: new EdgeInsets.fromLTRB(5.0, 0.0, 20.0, 0.0),
													child: new Column(
														mainAxisSize: MainAxisSize.min,
														crossAxisAlignment: CrossAxisAlignment.start,
														// mainAxisAlignment: MainAxisAlignment.start,
														children: <Widget>[
															new Container(
																width: 150.0,
																height: 180.0,
																decoration: new BoxDecoration(
																	image: new DecorationImage(
																		image: new AssetImage('images/cardphoto.png'),
																		fit: BoxFit.cover,
																	),
																),
															),
															new Text(
																'Madison'.toUpperCase(),
																textAlign: TextAlign.left,
																style: new TextStyle(
																	color: const Color(0xFFFFFFFF),
																	fontFamily: 'Montserrat',
																	fontWeight: FontWeight.w800,
																	fontSize: 14.0,
																	height: 1.8,
																),
															),
														],
													),
												),											
	
	
											],
										)
									)
								]
							),
						),
						new Container(
							height: 365.0,
							decoration: new BoxDecoration(
								color: const Color(0xFFF3F3F7),
							),
							child: new Column(
								mainAxisSize: MainAxisSize.min,
								children: <Widget>[
									new SizedBox(height: 25.0),
									new Text(
										'Featured'.toUpperCase(),
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
						),
						new Container(
							height: 105.0,
							decoration: new BoxDecoration(
								color: const Color(0xFFF3F3F7),
							),
							child: new Row(
								children: <Widget>[
									new Expanded( child: new Container() ),
									new Container(
										decoration: new BoxDecoration (
											borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
											color: const Color(0xFF1033FF),
										),
										padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
										child: new FlatButton.icon(
											onPressed: _search,
											icon: new Icon(
												Icons.search, 
												color: const Color(0xFFFFFFFF),
												size: 12.0,
											),
											label: new Text(
												'Search'.toUpperCase(),
												style: new TextStyle(
													color: const Color(0xFFFFFFFF),
													fontFamily: 'Montserrat',
													fontWeight: FontWeight.w800,
													fontSize: 12.0,
												),
											),
										),
									),
									new Expanded( child: new Container() ),
								]
							),
						),
					]
				),
			),
			bottomNavigationBar: new bottomBar(),
		);

	}
	
}


class Search extends StatefulWidget {
	Search({Key key, this.title}) : super(key: key);
	
	final String title;
	
	@override
	_SearchState createState() => new _SearchState();
}


class _SearchState extends State<Search> {
	

	var double _distance = 0.0;
	
	@override
	Widget build(BuildContext context) {
	  
		return new Scaffold(
			backgroundColor: const Color(0xFFFFFFFF),
			appBar: new AppBar(
				backgroundColor: const Color(0xFFFFFFFF),
				elevation: 0.0,
				centerTitle: true,
				title: new Text(
					'Find a grocery store'.toUpperCase(),
					style: new TextStyle(
						color: const Color(0xFF838383),
						fontFamily: 'Montserrat',
						fontWeight: FontWeight.w800,
						fontSize: 14.0,
					),
				),
				leading: new Container(),
				actions: <Widget>[
					new IconButton(
						icon: new Icon(Icons.close, color: const Color(0xFF000000) ),
						tooltip: 'Close',
						onPressed: () => Navigator.pop(context,true)
					),
				],
			),
			body: new Column(
				mainAxisSize: MainAxisSize.min,
				crossAxisAlignment: CrossAxisAlignment.start,
				children: <Widget>[
					new Container(
						padding: const EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 2.0),
						child: new Text(
							'Distance'.toUpperCase(),
							textAlign: TextAlign.left,
							style: new TextStyle(
								color: const Color(0xFF000000),
								fontFamily: 'Montserrat',
								fontWeight: FontWeight.w800,
								fontSize: 28.0,
							),
						),
					),
					new Container(
						padding: const EdgeInsets.fromLTRB(20.0, 0.0, 10.0, 0.0),
						child: new Text(
							'Average distance in miles',
							textAlign: TextAlign.left,
							style: new TextStyle(
								color: const Color(0xFF000000),
								fontFamily: 'Montserrat',
								fontWeight: FontWeight.w300,
								fontSize: 14.0,
							),
						),
					),
					new Container(
						padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 20.0),
						child: new Slider(
							divisions: 2,
							max: 2.0,
							min: 0.0,
							label: _distance.round().toString(),
							value: _distance.toDouble(),
							onChanged: (double newValue) {
								setState(() {
									_distance = newValue;
									// print(_distance);
								});
							},
						),
					),
					new Container(
						padding: const EdgeInsets.fromLTRB(20.0, 45.0, 10.0, 2.0),
						child: new Text(
							'Selection'.toUpperCase(),
							textAlign: TextAlign.left,
							style: new TextStyle(
								color: const Color(0xFF000000),
								fontFamily: 'Montserrat',
								fontWeight: FontWeight.w800,
								fontSize: 28.0,
							),
						),
					),
					new Container(
						padding: const EdgeInsets.fromLTRB(20.0, 0.0, 10.0, 20.0),
						child: new Text(
							'Type of Grocery Store',
							textAlign: TextAlign.left,
							style: new TextStyle(
								color: const Color(0xFF000000),
								fontFamily: 'Montserrat',
								fontWeight: FontWeight.w300,
								fontSize: 14.0,
							),
						),
					),
					new Row(
						children: <Widget>[
							new Container( width: 20.0 ),
							new Expanded(
								child: new Card(
									elevation: 3.0,
									child: new Container(
										height: 85.0,
										alignment: Alignment.center,
										padding: const EdgeInsets.all(10.0),
										child: new Text(
											'Familiar and Affordable'.toUpperCase(),
											textAlign: TextAlign.center,
											style: new TextStyle(
												color: const Color(0xFF000000),
												fontFamily: 'Montserrat',
												fontWeight: FontWeight.w800,
												fontSize: 14.0,
											),
										),
									),
								),
							),
							new Container( width: 20.0 ),
							new Expanded(
								child: new Card(
									elevation: 3.0,
									child: new Container(
										height: 85.0,
										alignment: Alignment.center,
										padding: const EdgeInsets.all(10.0),
										child: new Text(
											'Hidden Gems'.toUpperCase(),
											textAlign: TextAlign.center,
											style: new TextStyle(
												color: const Color(0xFF000000),
												fontFamily: 'Montserrat',
												fontWeight: FontWeight.w800,
												fontSize: 14.0,
											),
										),
									),
								),
							),
							new Container( width: 20.0 ),
						]
					),
					new Container( height: 20.0 ),
					new Row(
						children: <Widget>[
							new Container( width: 20.0 ),
							new Expanded(
								child: new Card(
									elevation: 3.0,
									child: new Container(
										height: 85.0,
										alignment: Alignment.center,
										padding: const EdgeInsets.all(10.0),
										child: new Text(
											'The Finer Things'.toUpperCase(),
											textAlign: TextAlign.center,
											style: new TextStyle(
												color: const Color(0xFF000000),
												fontFamily: 'Montserrat',
												fontWeight: FontWeight.w800,
												fontSize: 14.0,
											),
										),
									),
								),
							),
							new Container( width: 20.0 ),
							new Expanded(
								child: new Card(
									elevation: 3.0,
									child: new Container(
										height: 85.0,
										alignment: Alignment.center,
										padding: const EdgeInsets.all(10.0),
										child: new Text(
											'Surprise Me'.toUpperCase(),
											textAlign: TextAlign.center,
											style: new TextStyle(
												color: const Color(0xFF000000),
												fontFamily: 'Montserrat',
												fontWeight: FontWeight.w800,
												fontSize: 14.0,
											),
										),
									),
								),
							),
							new Container( width: 20.0 ),
						]
					),
					new Expanded(
						child: new Align(
							alignment: Alignment.bottomCenter,
							child: new Row(
								children: <Widget>[
									new Expanded(
										child: new RaisedButton(
											onPressed: () => Navigator.of(context).pushNamed('/searchresults'),
											padding: new EdgeInsets.all(20.0),  
											color: const Color(0xFF1033FF),
											textColor: const Color(0xFFFFFFFF),
											child: new Text(
												'View Results'.toUpperCase(),
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

	}
	
}



class SearchResults extends StatefulWidget {
	SearchResults({Key key, this.title}) : super(key: key);
	
	final String title;
	
	@override
	_SearchResultsState createState() => new _SearchResultsState();
}


class _SearchResultsState extends State<SearchResults> {
	
	@override
	Widget build(BuildContext context) {
	  
		return new Scaffold(
			backgroundColor: const Color(0xFFFFFFFF),
			appBar: new AppBar(
				backgroundColor: const Color(0xFFFFFFFF),
				elevation: 0.0,
				centerTitle: true,
				title: new Text(
					'Grocery Stores'.toUpperCase(),
					style: new TextStyle(
						color: const Color(0xFF838383),
						fontFamily: 'Montserrat',
						fontWeight: FontWeight.w800,
						fontSize: 14.0,
					),
				),
				leading: new Container(),
				actions: <Widget>[
					new IconButton(
						icon: new Icon(Icons.close, color: const Color(0xFF000000) ),
						tooltip: 'Close',
						onPressed: () => Navigator.pop(context,true)
					),
				],
			),
			body: new ListView(
				shrinkWrap: true,
				padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
				children: <Widget>[
					// result card
					new Container(
						height: 150.0,
						margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
						child: new Stack(
							fit: StackFit.loose,
							children: <Widget>[
								new Container(
									margin: const EdgeInsets.fromLTRB(0.0, 7.5, 0.0, 7.5),
									child: new Card(
										elevation: 3.0,
										child: new Container(
											padding: const EdgeInsets.fromLTRB(145.0, 0.0, 0.0, 0.0),
											child: new Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: <Widget>[
													new Container(
														padding: const EdgeInsets.fromLTRB(20.0, 20.0, 5.0, 0.0),
														child: new Text(
															'Fresh Market Madison'.toUpperCase(),
															textAlign: TextAlign.left,
															style: new TextStyle(
																color: const Color(0xFF000000),
																fontFamily: 'Montserrat',
																fontWeight: FontWeight.w800,
																fontSize: 14.0,
															),
														),
													),
													new Expanded(
														child: new Row(
															children: [
																new SizedBox( width: 20.0 ),
																new Expanded(child:new Icon(Icons.star, color: const Color(0xFF1033FF), size: 30.0)),
																new Expanded(child:new Icon(Icons.star, color: const Color(0xFF1033FF), size: 30.0)),
																new Expanded(child:new Icon(Icons.star, color: const Color(0xFF1033FF), size: 30.0)),
																new Expanded(child:new Icon(Icons.star_border, color: const Color(0xFF838383), size: 30.0)),
																new Expanded(child:new Icon(Icons.star_border, color: const Color(0xFF838383), size: 30.0)),
																new SizedBox( width: 20.0 ),
															],
														),
													),
													new Container(
														padding: const EdgeInsets.fromLTRB(20.0, 0.0, 5.0, 10.0),
														child: new Text(
															'2.7 mi',
															textAlign: TextAlign.left,
															style: new TextStyle(
																color: const Color(0xFF000000),
																fontFamily: 'Montserrat',
																fontWeight: FontWeight.w300,
																fontSize: 14.0,
															),
														),
													),

												]
											),	
										),														
									),
								),
								new Container(
									margin: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
									child: new SizedBox(
										width: 125.0,
										child: new Container(
											decoration: new BoxDecoration(
												image: new DecorationImage(
													image: new AssetImage('images/cardphoto.png'),
													fit: BoxFit.cover,
												),
											),
										),
									),
								),
							],
						),
					),
					// result card 2
					new Container(
						height: 150.0,
						child: new Stack(
							fit: StackFit.loose,
							children: <Widget>[
								new Container(
									margin: const EdgeInsets.fromLTRB(0.0, 7.5, 0.0, 7.5),
									child: new Card(
										elevation: 3.0,
										child: new Container(
											padding: const EdgeInsets.fromLTRB(145.0, 0.0, 0.0, 0.0),
											child: new Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: <Widget>[
													new Container(
														padding: const EdgeInsets.fromLTRB(20.0, 20.0, 5.0, 0.0),
														child: new Text(
															'Whole Foods'.toUpperCase(),
															textAlign: TextAlign.left,
															style: new TextStyle(
																color: const Color(0xFF000000),
																fontFamily: 'Montserrat',
																fontWeight: FontWeight.w800,
																fontSize: 14.0,
															),
														),
													),
													new Expanded(
														child: new Row(
															children: [
																new SizedBox( width: 20.0 ),
																new Expanded(child:new Icon(Icons.star, color: const Color(0xFF1033FF), size: 30.0)),
																new Expanded(child:new Icon(Icons.star, color: const Color(0xFF1033FF), size: 30.0)),
																new Expanded(child:new Icon(Icons.star, color: const Color(0xFF1033FF), size: 30.0)),
																new Expanded(child:new Icon(Icons.star_border, color: const Color(0xFF838383), size: 30.0)),
																new Expanded(child:new Icon(Icons.star_border, color: const Color(0xFF838383), size: 30.0)),
																new SizedBox( width: 20.0 ),
															],
														),
													),
													new Container(
														padding: const EdgeInsets.fromLTRB(20.0, 0.0, 5.0, 10.0),
														child: new Text(
															'1.3 mi',
															textAlign: TextAlign.left,
															style: new TextStyle(
																color: const Color(0xFF000000),
																fontFamily: 'Montserrat',
																fontWeight: FontWeight.w300,
																fontSize: 14.0,
															),
														),
													),

												]
											),	
										),
									),
								),
								new Container(
									margin: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
									child: new SizedBox(
										width: 125.0,
										child: new Container(
											child: new Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: <Widget>[
													new Expanded( child: new Container() ),
													new Container(
														width: 125.0,
														padding: const EdgeInsets.fromLTRB(10.0, 7.0, 10.0, 7.0),
														color: const Color(0xFFFCEE21),
														child: new Text(
															'Featured'.toUpperCase(),
															textAlign: TextAlign.left,
															style: new TextStyle(
																color: const Color(0xFF000000),
																fontFamily: 'Montserrat',
																fontWeight: FontWeight.w800,
																fontSize: 10.0,
															),
														),
													),
												]
											),
											decoration: new BoxDecoration(
												image: new DecorationImage(
													image: new AssetImage('images/cardphoto.png'),
													fit: BoxFit.cover,
												),
											),
										),
									),
								),
							],
						),
					),
				],
			)
		);

	}
	
}


class Bookmarks extends StatefulWidget {
	Bookmarks({Key key, this.title}) : super(key: key);
	
	final String title;
	
	@override
	_BookmarksState createState() => new _BookmarksState();
}


class _BookmarksState extends State<Bookmarks> {
	
	@override
	Widget build(BuildContext context) {
	  
		return new Scaffold(
			backgroundColor: const Color(0xFFF3F3F7),
			appBar: new AppBar(
				backgroundColor: const Color(0xFF000000),
				centerTitle: true,
				title: new Text(
					'Saved'.toUpperCase(),
					style: new TextStyle(
						color: const Color(0xFF838383),
						fontFamily: 'Montserrat',
						fontWeight: FontWeight.w800,
						fontSize: 14.0,
					),
				),
				leading: new Container(),
				actions: <Widget>[
					new IconButton(
						icon: new Icon(Icons.account_circle ),
						tooltip: 'Account',
						onPressed: () => Navigator.of(context).pushNamed('/onboarding'),
					),
				],
			),
			body: new CustomScrollView(
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
											"Find the nearest Grocery Store",
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
						padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
						sliver: new SliverGrid.count(
							crossAxisSpacing: 10.0,
							mainAxisSpacing: 10.0,
							crossAxisCount: 1,
							childAspectRatio: 2.25,
							children: <Widget>[
								new Container(
									height: 150.0,
									child: new Stack(
										fit: StackFit.loose,
										children: <Widget>[
											new Container(
												margin: const EdgeInsets.fromLTRB(0.0, 7.5, 0.0, 7.5),
												child: new Card(
													elevation: 3.0,
													child: new Container(
														padding: const EdgeInsets.fromLTRB(145.0, 0.0, 0.0, 0.0),
														child: new Column(
															crossAxisAlignment: CrossAxisAlignment.start,
															children: <Widget>[
																new Container(
																	padding: const EdgeInsets.fromLTRB(20.0, 20.0, 5.0, 0.0),
																	child: new Text(
																		'Aldi'.toUpperCase(),
																		textAlign: TextAlign.left,
																		style: new TextStyle(
																			color: const Color(0xFF000000),
																			fontFamily: 'Montserrat',
																			fontWeight: FontWeight.w800,
																			fontSize: 14.0,
																		),
																	),
																),
																new Expanded(
																	child: new Row(
																		children: [
																			new SizedBox( width: 20.0 ),
																			new Expanded(child:new Icon(Icons.star, color: const Color(0xFF1033FF), size: 30.0)),
																			new Expanded(child:new Icon(Icons.star, color: const Color(0xFF1033FF), size: 30.0)),
																			new Expanded(child:new Icon(Icons.star, color: const Color(0xFF1033FF), size: 30.0)),
																			new Expanded(child:new Icon(Icons.star_border, color: const Color(0xFF838383), size: 30.0)),
																			new Expanded(child:new Icon(Icons.star_border, color: const Color(0xFF838383), size: 30.0)),
																			new SizedBox( width: 20.0 ),
																		],
																	),
																),
																new Container(
																	padding: const EdgeInsets.fromLTRB(20.0, 0.0, 5.0, 10.0),
																	child: new Text(
																		'1.3 mi',
																		textAlign: TextAlign.left,
																		style: new TextStyle(
																			color: const Color(0xFF000000),
																			fontFamily: 'Montserrat',
																			fontWeight: FontWeight.w300,
																			fontSize: 14.0,
																		),
																	),
																),
			
															]
														),	
													),
												),
											),
											new Container(
												margin: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
												child: new SizedBox(
													width: 125.0,
													child: new Container(
														decoration: new BoxDecoration(
															image: new DecorationImage(
																image: new AssetImage('images/cardphoto.png'),
																fit: BoxFit.cover,
															),
														),
													),
												),
											),
										],
									),
								),
							],
						),
					),
					new SliverPadding(
						padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
						sliver: new SliverGrid.count(
							crossAxisSpacing: 10.0,
							mainAxisSpacing: 10.0,
							crossAxisCount: 1,
							childAspectRatio: 1.0,
							children: <Widget>[
								new Card(
									elevation: 3.0,
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
												new Expanded(
													child: new Container()
												),															
											],
										),
									),
								),
							]
						)
					),
				],
			),
			bottomNavigationBar: new bottomBar(),
		);

	}
	
}
