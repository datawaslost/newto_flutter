import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'package:carousel/carousel.dart';
import 'package:map_view/map_view.dart';
import "dart:ui";


void main() {
	MapView.setApiKey("AIzaSyAbhJpKCspO0OX3udKg6shFr5wwHw3yd_E");
	runApp(new MyApp());
}


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
				canvasColor: const Color(0xFF262626),
				scaffoldBackgroundColor: const Color(0xFFFFFFFF),
				disabledColor: const Color(0xFFFFFFFF),
				buttonColor: const Color(0xFFFFFFFF),
				iconTheme: new IconThemeData( color: const Color(0xFFFFFFFF) ),
				primaryIconTheme: new IconThemeData( color: const Color(0xFFFFFFFF) ),
				accentIconTheme: new IconThemeData( color: const Color(0xFFFFFFFF) ),
				bottomAppBarColor: const Color(0xFF262626),
				primaryColor: const Color(0xFF000000),
				indicatorColor: const Color(0xFF00C3FF),
				fontFamily: 'Montserrat',
			),
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
				'/account': (BuildContext context) => new Account(),
				'/article': (BuildContext context) => new Article(),
				'/place': (BuildContext context) => new Place(),
				'/org': (BuildContext context) => new Organization(),
			},
		);
	}
}


void bottomBar(context, _selected) {
	
	var _navOptions = [
		["landing", "home"],
		["yourlist", "list"],
		["discover", "compass"],
		["bookmarks", "bookmark"],
		["org", "umw"],
	];
	
	List<Widget> _navItems = [];
	
	for (var i = 0; i < _navOptions.length; i++) {

		var _borderColor = const Color(0xFF262626);
		var _selectedName = "";
		
		if (i == _selected) {
			_borderColor = const Color(0xFF1033FF);
			_selectedName = "_selected";
		}
		
		_navItems.add(
			new Expanded(
		        child: new GestureDetector(
					onTap: () { if (i != _selected) { Navigator.of(context).pushNamed("/" + _navOptions[i][0]);}},
					child: new Container(
						child: new ImageIcon(new AssetImage("images/icon_" + _navOptions[i][1] + _selectedName + ".png"), color: const Color(0xFFFFFFFF), size: 39.0),
						decoration: new BoxDecoration( border: new Border( bottom: new BorderSide( width: 3.0, color: _borderColor ), ), ),
						padding: new EdgeInsets.all(8.0),
					),
				),
			),
		);
		
	}
	
	return new Hero(
		tag: "bottomNavigationBar",
		child: new Container(
	        height: 60.0,
	        color: const Color(0xFF262626),
	        child: new Row(
		        children: _navItems,
			),
		),
    );
    
}

				
class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

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
														onPressed: () => Navigator.of(context).pushNamed('/landing'),
														padding: new EdgeInsets.all(14.0),  
														color: const Color(0xFF1033FF),
														textColor: const Color(0xFFFFFFFF),
														child: new Text(
															'Complete Sign Up'.toUpperCase(),
															style: new TextStyle(
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
														onPressed: () => Navigator.of(context).pushNamed('/landing'),
														padding: new EdgeInsets.all(14.0),  
														color: const Color(0xFF1033FF),
														textColor: const Color(0xFFFFFFFF),
														child: new Text(
															'Login'.toUpperCase(),
															style: new TextStyle(
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

void discoverItem(txt, img, context, { bool sponsored = false, bool bookmarked = false }) {
	return new GestureDetector(
		onTap: () {
			Navigator.of(context).pushNamed('/article');
		},
		child: new Card(
			elevation: 3.0,
			child: new Container(
				decoration: new BoxDecoration(
					image: new DecorationImage(
						image: new AssetImage('images/'+img),
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
								child: new Row(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: <Widget>[
										new Expanded(
											child: new Text(
												txt.toUpperCase(),
												textAlign: TextAlign.left,
												style: new TextStyle(
													color: const Color(0xFF000000),
													fontWeight: FontWeight.w800,
													fontSize: 24.0,
												),
											),
										),
										( bookmarked
											? new Container(
												child: new Icon(Icons.bookmark, color: const Color(0xFF00C3FF), size: 20.0),
											) : new SizedBox(width: 0.0)
										)
									]
								),
								decoration: new BoxDecoration(color: Colors.white.withOpacity(0.5)),
							),
						),
						new Expanded(
							child: new Container(
								alignment: Alignment.bottomCenter,
								decoration: new BoxDecoration(
									image: new DecorationImage(
										image: new AssetImage('images/'+img),
										fit: BoxFit.cover,
										alignment: Alignment.bottomCenter,
									),
								),
								child: ( sponsored
									? new Column(
										mainAxisSize: MainAxisSize.min,
										children: <Widget>[
											new Expanded( child: new Container() ),
											new Row(
												children: [
													new Container(
														padding: new EdgeInsets.fromLTRB(11.0, 8.0, 11.0, 7.0),
														child: new Text(
															'Sponsor'.toUpperCase(),
															textAlign: TextAlign.left,
															style: new TextStyle(
																color: const Color(0xFF000000),
																fontWeight: FontWeight.w800,
																fontSize: 10.0,
															),
														),
														decoration: new BoxDecoration(color: const Color(0xFFFCEE21) ),
													),
													new Expanded( child: new Container() ),
												]
											),
										]
									) : new Container()
								),
							),
						),
					],
				),
			),
		),
	);
}
						

class Landing extends StatefulWidget {
	Landing({Key key, this.title}) : super(key: key);
	
	final String title;
	
	@override
	_LandingState createState() => new _LandingState();
}


class _LandingState extends State<Landing> {

	String _response;
	bool _details = false;
	
	@override
	Widget build(BuildContext context) {
	  
		// SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
		
		void _dialog() {
			showDialog(
				context: context,
				child: new AlertDialog(
					contentPadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 30.0),
					content: new SingleChildScrollView(
						scrollDirection: Axis.vertical,
						child: new Column(
							mainAxisSize: MainAxisSize.min,
							children: <Widget>[
								new Row(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: <Widget>[
										new Expanded(
											child: new Text(
												'Turn in your housing insurance forms'.toUpperCase(),
												textAlign: TextAlign.left,
												style: new TextStyle(
													color: const Color(0xFF000000),
													fontWeight: FontWeight.w800,
													fontSize: 28.0,
													height: 0.9,
												),
											),
										),
										new Container(
											width: 20.0,
											child: new IconButton(
												alignment: Alignment.topRight,
												padding: const EdgeInsets.all(0.0),
												icon: new Icon(Icons.close, color: const Color(0xFF000000) ),
												tooltip: 'Close',
												onPressed: () => Navigator.pop(context,true)
											),
										),
									]
								),
								new SizedBox( height: 20.0 ),
								new Text(
									"Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. Nullam quis risus eget urna mollis ornare vel eu leo. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit.",
									textAlign: TextAlign.left,
									style: new TextStyle(
										color: const Color(0xFF000000),
										fontWeight: FontWeight.w300,
										fontSize: 14.0,
										height: 1.15,
									),
								),
								new SizedBox( height: 25.0 ),
								new Row(
									children: <Widget>[
										new Expanded(
											child: new RaisedButton(
												onPressed: () => Navigator.pop(context,true),
												padding: new EdgeInsets.all(14.0),  
												color: const Color(0xFF1033FF),
												textColor: const Color(0xFFFFFFFF),
												child: new Text(
													'Do it online'.toUpperCase(),
													style: new TextStyle(
														fontWeight: FontWeight.w800,
													),
												),
											),
										)
									]
								),
								new SizedBox( height: 10.0 ),
								new Row(
									children: <Widget>[
										new Expanded(
											child: new RaisedButton(
												onPressed: () => Navigator.pop(context,true),
												padding: new EdgeInsets.all(14.0),  
												color: const Color(0xFFE3F5FF),
												textColor: const Color(0xFF000000),
												child: new Text(
													'Download Forms'.toUpperCase(),
													style: new TextStyle(
														fontWeight: FontWeight.w800,
													),
												),
											),
										)
									]
								),
							],
						),
					),
				)
			);
		}
		
		void carouselItem(txt) {
			return new Stack(
				children: [
				    new GestureDetector(
						onTap: _dialog,
						onLongPress: () {
							setState(() { _details = true; });
						},
						child: new Container(
							padding: new EdgeInsets.fromLTRB(60.0, 0.0, 60.0, 0.0),
							alignment: Alignment.center,
							child: new Column(
								mainAxisSize: MainAxisSize.min,
								children: <Widget>[
									new Text(
										'Your List'.toUpperCase(),
										textAlign: TextAlign.center,
										style: new TextStyle(
											color: const Color(0xFF838383),
											fontWeight: FontWeight.w800,
											fontSize: 14.0,
										),
									),
									new SizedBox(height: 10.0),
									new Text(
										txt.toUpperCase(),
										textAlign: TextAlign.center,
										style: new TextStyle(
											color: const Color(0xFFFFFFFF),
											fontWeight: FontWeight.w800,
											fontSize: 24.0,
											height: 0.9,
										),
									),
									new FlatButton(
										onPressed: () => Navigator.of(context).pushNamed('/yourlist'),
										child: new Icon(
											Icons.arrow_forward,
											color: const Color(0xFFFFFFFF),
										),
									),
								],
							),
						),
					),
					
					(_details
						? new Container(
							color: const Color(0xFF000000),
							padding: new EdgeInsets.fromLTRB(80.0, 0.0, 80.0, 0.0),
							// alignment: Alignment.center,
							child: new Center(
								child: new Row(
									children: [
										new Expanded(
											child: new InkWell(
												onTap: () => setState(() { _details = false; }),
												child: listButton(Icons.check),
											),
										),
										new Expanded(
											child: new InkWell(
												onTap: () => setState(() { _details = false; }),
												child: listButton(Icons.bookmark_border),
											),
										),
										new Expanded(
											child: new InkWell(
												onTap: () => setState(() { _details = false; }),
												child: listButton(Icons.close),
											),
										),
									]
								)
							),
						)
						: new Container()
					)
				]
			);
		}
		
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
											fontWeight: FontWeight.w300,
											fontSize: 14.0,
										),
									),
								),
							),
						]
					)
				),
				leading: new Container(),
				actions: <Widget>[
					new IconButton(
						icon: new Icon(Icons.account_circle ),
						tooltip: 'Account',
						onPressed: () => Navigator.of(context).pushNamed('/account'),
					),
				],
			),
			body: new Column(
				mainAxisSize: MainAxisSize.min,
				children: <Widget>[
					new Expanded(
						child: new Carousel(
							displayDuration: new Duration(seconds: 200000),
							children: [
								carouselItem('Tell your friends your new address'),
								carouselItem('Turn in your housing insurance forms'),
							]
						),
					),
					new Container(
						child: new LinearProgressIndicator(
							value: 0.5,
							backgroundColor: const Color(0xFF2D2D2F),
							valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
						),
						// this is overlapped
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
								new SizedBox(height: 25.0, ),
								new Text(
									'Discover'.toUpperCase(),
									textAlign: TextAlign.center,
									style: new TextStyle(
										color: const Color(0xFF838383),
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
												new Container( width: 278.0, height: 278.0, margin: new EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 20.0), child: discoverItem('Create the Perfect Dorm Room', 'cardphoto.png', context) ),
												new Container( width: 278.0, height: 278.0, margin: new EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 20.0), child: discoverItem('Get to know UMW', 'background.png', context, sponsored: true) ),
											],
										)
									)
								)
							],
						),
					)
				]
			),
			bottomNavigationBar: bottomBar(context, 0),
		);

	}
	
}

void listButton(icon) {
	return new Container(
		width: 50.0,
		height: 50.0,
		decoration: new BoxDecoration(
			shape: BoxShape.circle,
			color: const Color(0xFFFFFFFF),
			boxShadow: [new BoxShadow(
	            color: const Color(0x66000000),
	            blurRadius: 8.0,
          ),]
		),
		child: new Icon( icon, size: 25.0, color: const Color(0xFF000000) ),
	);
}


void listCard(String txt, {height, width, key, bookmarked = false}) {
	return new Card(
		key: key,
		elevation: 3.0,
		child: new Container(
			height: height,
			width: width,
			padding: const EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 10.0),
			child: new Stack(
				children: [
					new Text(
						txt,
						textAlign: TextAlign.left,
						style: new TextStyle(
							color: const Color(0xFF000000),
							fontWeight: FontWeight.w700,
							fontSize: 14.0,
						),
					),
					(bookmarked ? 
						new Positioned(
							bottom: 10.0,
							right: 10.0,
							child: new Icon(Icons.bookmark, color: const Color(0xFF00C3FF), size: 20.0)
						) : new Container()
					)
				]
			)
		),
	);
}


void listCardGesture(String txt, context, {bookmarked = false}) {
	
	// create a key so we can specifically reference the original card widget later to get its size, position
	GlobalKey stickyKey = new GlobalKey();

	return new GestureDetector(
		onTapUp: (details){
			var _offsety;
			var _boxwidth;
			var _boxheight;
			var _rightside = false;
			var _offsetx = 150.0;
			var _offsetx2 = 25.0;
			if (details.globalPosition.dx > 200) {
				_rightside = true;
				_offsetx = 25.0;
				_offsetx2 = 150.0;
			}
			final keyContext = stickyKey.currentContext;
			// if box is visible
	        if (keyContext != null) {
				final RenderBox box = keyContext.findRenderObject();
				_offsety = box.localToGlobal(Offset.zero).dy - 20.0;
				_boxwidth = box.size.width - 7.5;
				_boxheight = box.size.height - 7.5;
	        }
	        // if box is partially offscreen
	        if (_offsety < 0) {
		        // for now, don't show a dialog
		        // but we could also just push it down a bit
		        // _offsety = 0.0;
	        } else {
				showDialog(
					context: context,
					builder: (BuildContext context) {
						return new Column(
				            children: [
								new SizedBox(height: _offsety ),
								new Expanded(
						            child: new Stack(
							            children: [
								            new Positioned(
									            top: 0.0,
									            right: _rightside ? 20.0 : null,
									            left: _rightside ? null : 20.0,
									            child: listCard(txt, height:_boxheight, width:_boxwidth, bookmarked: bookmarked),
											),
								            new Row(
												children: [
													new SizedBox( width: _offsetx, height: _boxheight),
													new Expanded( child: listButton(Icons.check) ),
													new Expanded( child: listButton(Icons.bookmark_border) ),
													new Expanded( child: listButton(Icons.close) ),
													new SizedBox( width: _offsetx2 ),
												]
											)
										]
									)
								)
							]
						);
					}
				);
			}
		},
		child: listCard(txt, key: stickyKey, bookmarked: bookmarked),
	);
}


void listGroup(String txt, amount, context, {bookmarked = false, String sponsored}) {
	return new GestureDetector(
		onTap: () {
			Navigator.of(context).pushNamed('/listitems');
		},
		child: new Card(
			elevation: 3.0,
			child: new Column(
				mainAxisSize: MainAxisSize.min,
				crossAxisAlignment: CrossAxisAlignment.start,
				children: <Widget>[
					new Expanded(
						child: new Container(
							padding: const EdgeInsets.fromLTRB(20.0, 15.0, 10.0, 7.5),
							child: new Text(
								txt.toUpperCase(),
								textAlign: TextAlign.left,
								style: new TextStyle(
									color: const Color(0xFF000000),
									fontWeight: FontWeight.w800,
									fontSize: 24.0,
								),
							),
						),
					),
					new Container(
						padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
						child: new Row(
							children: [
								new Expanded(
									child: (sponsored != null ? 
										new Text(
											'Sponsored by UWM'.toUpperCase(),
											textAlign: TextAlign.left,
											style: new TextStyle(
												color: const Color(0xFF838383),
												fontWeight: FontWeight.w800,
												fontSize: 10.0,
											),
										): new Container()
									)
								),
								new Text(
									amount.toString() + ' '.toUpperCase(),
									textAlign: TextAlign.left,
									style: new TextStyle(
										color: const Color(0xFF838383),
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
	);
}


class YourList extends StatefulWidget {
	YourList({Key key, this.title}) : super(key: key);
	
	final String title;
	
	@override
	_YourListState createState() => new _YourListState();
}


class _YourListState extends State<YourList> {
	
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
							onPressed: () => Navigator.of(context).pushNamed('/account'),
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
											listCardGesture("Tell your friends your new address", context),																
											listCardGesture("Plan how you're going to get around campus", context),																	
											listCardGesture("Find Your Doctor, Dentist, Eye care, Pharmacy", context),																	
											listCardGesture("Find the nearest grocery store", context),																	
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
											listGroup("Popular Activity Name Title Group", 4, context, sponsored: "UWWM"),
											listGroup("Another Group", 3, context),
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
											listCardGesture("Find the nearest convenience store", context),																	
											listCardGesture("Buy books for your class", context),																	
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
											discoverItem('Create the Perfect Dorm Room', 'cardphoto.png', context, sponsored: true),
										]
									)
								),
								new SliverPadding(
									padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
									sliver: new SliverGrid.count(
										crossAxisSpacing: 10.0,
										mainAxisSpacing: 10.0,
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
										crossAxisSpacing: 10.0,
										mainAxisSpacing: 10.0,
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
									padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
									sliver: new SliverGrid.count(
										crossAxisSpacing: 10.0,
										mainAxisSpacing: 10.0,
										crossAxisCount: 2,
										childAspectRatio: 1.1,
										children: <Widget>[
											listCardGesture("Tell your friends your new address", context),
											listCardGesture("Set up your email and student accounts", context),
											listCardGesture("Check in and get your welcome packet", context),
											listCardGesture("Buy books for your classes", context),
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
											listGroup("Popular Activity Name Title Group", 4, context, sponsored: "UWWM"),
										],
									),
								),
							],
						),
						new Icon(Icons.directions_bike),
					],
				),
				bottomNavigationBar: bottomBar(context, 1),
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
										fontWeight: FontWeight.w800,
										fontSize: 28.0,
										height: 0.9,
									),
								),
							]
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
								listCardGesture("Tell your friends your new address", context),
								listCardGesture("Set up your email and student accounts", context),
								listCardGesture("Check in and get your welcome packet", context),
								listCardGesture("Buy books for your classes", context),
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
								discoverItem('Create the Perfect Dorm Room', 'cardphoto.png', context, sponsored: true),
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

	void searchCategory(txt, img) {
		return new GestureDetector(
			onTap: () {
				Navigator.of(context).pushNamed('/search');
			},
			child: new Container(
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
									image: new AssetImage('images/' + img),
									fit: BoxFit.cover,
								),
							),
						),
						new Text(
							txt.toUpperCase(),
							textAlign: TextAlign.left,
							style: new TextStyle(
								color: const Color(0xFFFFFFFF),
								fontWeight: FontWeight.w800,
								fontSize: 14.0,
								height: 1.8,
							),
						),
					],
				),
			),
		);
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
						fontWeight: FontWeight.w800,
						fontSize: 14.0,
					),
				),
				leading: new Container(),
				actions: <Widget>[
					new IconButton(
						icon: new Icon(Icons.account_circle ),
						tooltip: 'Account',
						onPressed: () => Navigator.of(context).pushNamed('/account'),
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
												new SizedBox(width: 15.0),
												searchCategory("Groceries", "cardphoto.png"),
												searchCategory("Restaurants", "cardphoto.png"),
												searchCategory("Madison", "cardphoto.png"),
												new SizedBox(width: 15.0),
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
														child: discoverItem('Create the Perfect Dorm Room', 'cardphoto.png', context),
													),
													new Container(
														width: 278.0,
														height: 278.0,
														margin: new EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 20.0),
														child: discoverItem('Get to know UMW', 'background.png', context),
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
											onPressed: () => Navigator.of(context).pushNamed('/search'),
											icon: new Icon(
												Icons.search, 
												color: const Color(0xFFFFFFFF),
												size: 12.0,
											),
											label: new Text(
												'Search'.toUpperCase(),
												style: new TextStyle(
													color: const Color(0xFFFFFFFF),
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
			bottomNavigationBar: bottomBar(context, 2),
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
	

	double _distance = 0.0;
	
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


void placeCard(txt, img, stars, distance, context, { featured = false, bookmarked = false }) {
	return new GestureDetector(
		onTap: () {
			Navigator.of(context).pushNamed('/place');
		},
		child: new Container(
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
												txt.toUpperCase(),
												textAlign: TextAlign.left,
												style: new TextStyle(
													color: const Color(0xFF000000),
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
										new Row(
											children: <Widget>[
												new Expanded(
													child: new Container(
														padding: const EdgeInsets.fromLTRB(20.0, 0.0, 5.0, 10.0),
														child: new Text(
															distance.toString() + ' mi',
															textAlign: TextAlign.left,
															style: new TextStyle(
																color: const Color(0xFF000000),
																fontWeight: FontWeight.w300,
																fontSize: 14.0,
															),
														),
													),
												),
												( bookmarked ?
													new Container(
														padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 10.0),
														child: new Icon(Icons.bookmark, color: const Color(0xFF00C3FF), size: 20.0),
													) : new Container()
												)
											]
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
								child: ( featured ? 
									new Column(
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
														fontWeight: FontWeight.w800,
														fontSize: 10.0,
													),
												),
											),
										]
									) : new Container()
								),
								decoration: new BoxDecoration(
									image: new DecorationImage(
										image: new AssetImage('images/'+img),
										fit: BoxFit.cover,
									),
								),
							),
						),
					),
				],
			),
		),
	);
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
					 placeCard('Whole Foods', 'cardphoto.png', 5.0, 2.7, context),
					 placeCard('Fresh Market Madison', 'background.png', 3.0, 1.3, context, featured: true),
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
						fontWeight: FontWeight.w800,
						fontSize: 14.0,
					),
				),
				leading: new Container(),
				actions: <Widget>[
					new IconButton(
						icon: new Icon(Icons.account_circle ),
						tooltip: 'Account',
						onPressed: () => Navigator.of(context).pushNamed('/account'),
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
								listCardGesture("Find your doctor, dentist, eye care, pharmacy", context, bookmarked: true),																
								listCardGesture("Find the nearest grocery store", context, bookmarked: true),																
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
							// fix this nonsense ^
							children: <Widget>[
								placeCard('Aldi', 'cardphoto.png', 5.0, 2.7, context, bookmarked: true),
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
								discoverItem('Create the Perfect Dorm Room', 'cardphoto.png', context, sponsored: true, bookmarked: true),
							]
						)
					),
				],
			),
			bottomNavigationBar: bottomBar(context, 3),
		);

	}
	
}


class Account extends StatefulWidget {
	Account({Key key, this.title}) : super(key: key);
	
	final String title;
	
	@override
	_AccountState createState() => new _AccountState();
}


class _AccountState extends State<Account> {
	
	@override
	Widget build(BuildContext context) {
	  
		return new Scaffold(
			backgroundColor: const Color(0xFFFFFFFF),
			appBar: new AppBar(
				backgroundColor: const Color(0xFF000000),
				centerTitle: true,
				title: new Text(
					'Account Settings'.toUpperCase(),
					style: new TextStyle(
						color: const Color(0xFF838383),
						fontWeight: FontWeight.w800,
						fontSize: 14.0,
					),
				),
				leading: new Container(),
				actions: <Widget>[
					new IconButton(
						icon: new Icon(Icons.close, color: const Color(0xFFFFFFFF) ),
						tooltip: 'Close',
						onPressed: () => Navigator.pop(context,true)
					),
				],
			),
			body: new ListView(
				children: <Widget>[
					new ListTile(
						title: new Text('karen@uwmadison.edu',
							style: new TextStyle(
								fontWeight: FontWeight.w300,
								fontSize: 14.0,
							)
						),
						leading: new Icon(
							Icons.mail_outline,
							color: const Color(0xFF838383),
						),
						trailing: new IconButton(
							icon: new Icon(Icons.arrow_forward, color: const Color(0xFF000000) ),
						),
						onTap: () => print("email"),
					),
					new Divider(
						height: 1.0,
						color: const Color(0xFFE0E1EA),
					),
					new ListTile(
						title: new Text('Chicago, IL',
							style: new TextStyle(
								fontWeight: FontWeight.w300,
								fontSize: 14.0,
							)
						),
						leading: new Icon(
							Icons.home,
							color: const Color(0xFF838383),
						),
						trailing: new IconButton(
							icon: new Icon(Icons.arrow_forward, color: const Color(0xFF000000) ),
						),
						onTap: () => print("city"),
					),
					new Divider(
						height: 1.0,
						color: const Color(0xFFE0E1EA),
					),			
					new ListTile(
						title: new Text('Change Password',
							style: new TextStyle(
								fontWeight: FontWeight.w300,
								fontSize: 14.0,
							)
						),
						leading: new Icon(
							Icons.lock_outline,
							color: const Color(0xFF838383),
						),
						trailing: new IconButton(
							icon: new Icon(Icons.arrow_forward, color: const Color(0xFF000000) ),
						),
						onTap: () => print("change password"),
					),
					new Divider(
						height: 1.0,
						color: const Color(0xFFE0E1EA),
					),			
					new ListTile(
						title: new Text('Log Out',
							style: new TextStyle(
								fontWeight: FontWeight.w300,
								fontSize: 14.0,
							)
						),
						leading: new Icon(
							Icons.power_settings_new,
							color: const Color(0xFF838383),
						),
						trailing: new IconButton(
							icon: new Icon(Icons.arrow_forward, color: const Color(0xFF000000) ),
						),
						onTap: () => Navigator.of(context).pushNamed('/onboarding'),
					),
					new Divider(
						height: 1.0,
						color: const Color(0xFFE0E1EA),
					),
				],
			),
		);

	}
	
}


class Article extends StatefulWidget {
	Article({Key key, this.title}) : super(key: key);
	
	final String title;
	
	@override
	_ArticleState createState() => new _ArticleState();
}


class _ArticleState extends State<Article> {
	
	@override
	Widget build(BuildContext context) {
	  
		return new Scaffold(
			backgroundColor: const Color(0xFFFFFFFF),
			body: new SingleChildScrollView(
				scrollDirection: Axis.vertical,
				child: new Column(
					children: <Widget>[
						new Container(
							height: 324.0,
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
											padding: new EdgeInsets.fromLTRB(20.0, 30.0, 10.0, 15.0),
											child: new Row(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: <Widget>[
													new Expanded(
														child: new Text(
															'Create the Perfect Dorm Room'.toUpperCase(),
															textAlign: TextAlign.left,
															style: new TextStyle(
																color: const Color(0xFF000000),
																fontWeight: FontWeight.w800,
																fontSize: 28.0,
																height: 0.9,
															),
														),
													),
													new IconButton(
														icon: new Icon(Icons.close, color: const Color(0xFF000000)),
														padding: new EdgeInsets.all(0.0),
														alignment: Alignment.topCenter,
														onPressed: () => Navigator.pop(context,true),
													),
												]
											),
											decoration: new BoxDecoration(color: Colors.white.withOpacity(0.5)),
										),
									),
									new Expanded(
										child: new Container(
											decoration: new BoxDecoration(
												image: new DecorationImage(
													image: new AssetImage('images/cardphoto.png'),
													fit: BoxFit.cover,
													alignment: Alignment.bottomCenter,
												),
											), 
										),
									),															
								],
							),
						),
						new Row(
							children: [
								new Container(
									padding: new EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
									child: new Text(
										'Sponsor'.toUpperCase(),
										textAlign: TextAlign.left,
										style: new TextStyle(
											color: const Color(0xFF000000),
											fontWeight: FontWeight.w800,
											fontSize: 12.0,
										),
									),
									decoration: new BoxDecoration(color: const Color(0xFFFCEE21) ),
								),
								new Expanded(
									child: Container( decoration: BoxDecoration(color: const Color(0xFFFFFFFF) ) )
								),
							]
						),
						new Container(
							padding: new EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 15.0),
							child:  new Text(
								"It will be seen that this mere painstaking burrower and grub-worm of a poor devil of a Sub-Sub appears to have gone through the long Vaticans and street-stalls of the earth, picking up whatever random allusions to whales he could anyways find in any book whatsoever, sacred or profane. Therefore you must not, in every case at least, take the higgledy-piggledy whale statements, however authentic, in these extracts, for veritable gospel cetology. Far from it. As touching the ancient authors generally, as well as the poets here appearing, these extracts are solely valuable or entertaining, as affording a glancing bird's eye view of what has been promiscuously said, thought, fancied, and sung of Leviathan, by many nations and generations, including our own. It will be seen that this mere painstaking burrower and grub-worm of a poor devil of a Sub-Sub appears to have gone through the long Vaticans and street-stalls of the earth, picking up whatever random allusions to whales he could anyways find in any book whatsoever, sacred or profane. Therefore you must not, in every case at least, take the higgledy-piggledy whale statements, however authentic, in these extracts, for veritable gospel cetology. Far from it. As touching the ancient authors generally, as well as the poets here appearing, these extracts are solely valuable or entertaining, as affording a glancing bird's eye view of what has been promiscuously said, thought, fancied, and sung of Leviathan, by many nations and generations, including our own.",
								textAlign: TextAlign.left,
								style: new TextStyle(
									color: const Color(0xFF000000),
									fontWeight: FontWeight.w300,
									fontSize: 14.0,
									height: 1.15,
								),
							),
						),
						new Container(
							padding: new EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 30.0),
							child:  new Row(children: <Widget>[
								new Expanded(
									child: new RaisedButton(
											onPressed: () => Navigator.pop(context,true),
											padding: new EdgeInsets.all(14.0),  
											color: const Color(0xFF1033FF),
											textColor: const Color(0xFFFFFFFF),
											child: new Text(
												'Shop Now'.toUpperCase(),
												style: new TextStyle(
													fontWeight: FontWeight.w800,
												),
											),
										),
									)
								]
							),
						),
					],
				)
			),
			persistentFooterButtons: <Widget>[
				new FlatButton(
					onPressed: () => Navigator.pop(context,true),
					child: new Icon(
						Icons.add_circle_outline,
						color: const Color(0xFF2D2D2F),
					),
				),
				new FlatButton(
					onPressed: () => Navigator.pop(context,true),
					child: new Icon(
						Icons.check_circle_outline,
						color: const Color(0xFF2D2D2F),
					),
				),
				new FlatButton(
					onPressed: () => Navigator.pop(context,true),
					child: new Icon(
						Icons.bookmark_border,
						color: const Color(0xFF2D2D2F),
					),
				),
			],
		);

	}
	
}


class Place extends StatefulWidget {
	Place({Key key, this.title}) : super(key: key);
	
	final String title;
	
	@override
	_PlaceState createState() => new _PlaceState();
}


class _PlaceState extends State<Place> {
	
	var _staticMapProvider = new StaticMapProvider('AIzaSyAbhJpKCspO0OX3udKg6shFr5wwHw3yd_E');
	
	@override
	Widget build(BuildContext context) {
	  
		return new Scaffold(
			backgroundColor: const Color(0xFFFFFFFF),
			body: new SingleChildScrollView(
				scrollDirection: Axis.vertical,
				child: new Column(
					children: <Widget>[
						new Container(
							height: 324.0,
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
											padding: new EdgeInsets.fromLTRB(20.0, 30.0, 10.0, 15.0),
											child: new Row(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: <Widget>[
													new Expanded(
														child: new Text(
															'Fresh Market Madison'.toUpperCase(),
															textAlign: TextAlign.left,
															style: new TextStyle(
																color: const Color(0xFF000000),
																fontWeight: FontWeight.w800,
																fontSize: 28.0,
																height: 0.9,
															),
														),
													),
													new IconButton(
														icon: new Icon(Icons.close, color: const Color(0xFF000000)),
														padding: new EdgeInsets.all(0.0),
														alignment: Alignment.topCenter,
														onPressed: () => Navigator.pop(context,true),
													),
												]
											),
											decoration: new BoxDecoration(color: Colors.white.withOpacity(0.5)),
										),
									),
									new Expanded(
										child: new Container(
											decoration: new BoxDecoration(
												image: new DecorationImage(
													image: new AssetImage('images/cardphoto.png'),
													fit: BoxFit.cover,
													alignment: Alignment.bottomCenter,
												),
											), 
										),
									),															
								],
							),
						),
						new Container(
							padding: new EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 15.0),
							alignment: Alignment.topLeft,
							child: new Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: <Widget>[
									new Text(
										"703 University Ave, Madison, WI 53715",
										textAlign: TextAlign.left,
										style: new TextStyle(
											color: const Color(0xFF1033FF),
											fontWeight: FontWeight.w400,
											fontSize: 14.0,
											height: 1.25,
										),
									),
									new Text(
										"freshmadisonmarket.com",
										textAlign: TextAlign.left,
										style: new TextStyle(
											color: const Color(0xFF1033FF),
											fontWeight: FontWeight.w400,
											fontSize: 14.0,
											height: 1.25,
										),
									),
									new Text(
										"(608) 287-0000",
										textAlign: TextAlign.left,
										style: new TextStyle(
											color: const Color(0xFF1033FF),
											fontWeight: FontWeight.w400,
											fontSize: 14.0,
											height: 1.25,
										),
									),
									new Text(
										"Open Now: 7AM-12AM",
										style: new TextStyle(
											color: const Color(0xFF000000),
											fontWeight: FontWeight.w300,
											fontSize: 14.0,
											height: 1.25,
										),
									),
									new Container(
										padding: new EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 20.0),
										child: new Image.network(
											_staticMapProvider.getStaticUriWithMarkers(
												<Marker>[ new Marker("1", "Fresh Market Madison", 45.523970, -122.663081) ],
												width: 600,
												height: 400,
												maptype: StaticMapViewType.roadmap,
											).toString()
										),
									),
									new Text(
										"Highlights".toUpperCase(),
										style: new TextStyle(
											color: const Color(0xFF000000),
											fontWeight: FontWeight.w800,
											fontSize: 14.0,
											height: 1.25,
										),
									),
									new Container(
										padding: new EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 25.0),
										child: new Text(
											"Get fresh in our aisles. Oh, behave. We’re so about fresh we can hardly contain ourselves. Fresh produce, fresh sushi, fresh deli, fresh faces, fresh seafood, fresh salads, sandwiches, panini’s and breakfast, lunch and dinner buffets, and a fresh approach to just about everything. We’re not your mother’s grocery store because we’re your grocery store. Come on now, it’s time to get fresh in our aisles.",
											style: new TextStyle(
												color: const Color(0xFF000000),
												fontWeight: FontWeight.w300,
												fontSize: 14.0,
												height: 1.25,
											),
										),								
									),
									new Divider(
										height: 1.0,
										color: const Color(0xFFE0E1EA),
									),
									new SizedBox( height: 20.0 ),
									new Row(
										children: [
											new Text(
												"What Others Think".toUpperCase(),
												style: new TextStyle(
													color: const Color(0xFF000000),
													fontWeight: FontWeight.w800,
													fontSize: 14.0,
													height: 1.25,
												),
											),
											new SizedBox( width: 20.0 ),
											new Text(
												"4.9".toUpperCase(),
												style: new TextStyle(
													color: const Color(0xFF1033FF),
													fontWeight: FontWeight.w800,
													fontSize: 14.0,
													height: 1.25,
												),
											),
											new SizedBox( width: 10.0 ),
											new Expanded(child:new Icon(Icons.star, color: const Color(0xFF1033FF), size: 20.0)),
											new Expanded(child:new Icon(Icons.star, color: const Color(0xFF1033FF), size: 20.0)),
											new Expanded(child:new Icon(Icons.star, color: const Color(0xFF1033FF), size: 20.0)),
											new Expanded(child:new Icon(Icons.star, color: const Color(0xFF1033FF), size: 20.0)),
											new Expanded(child:new Icon(Icons.star_border, color: const Color(0xFF838383), size: 20.0)),
										],
									),
									new Container(
										padding: new EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 10.0),
										child: new Row(
											children: [
												new SizedBox( width: 30.0 ),
												new Expanded(child:new Icon(Icons.star_border, color: const Color(0xFF838383), size: 50.0)),
												new Expanded(child:new Icon(Icons.star_border, color: const Color(0xFF838383), size: 50.0)),
												new Expanded(child:new Icon(Icons.star_border, color: const Color(0xFF838383), size: 50.0)),
												new Expanded(child:new Icon(Icons.star_border, color: const Color(0xFF838383), size: 50.0)),
												new Expanded(child:new Icon(Icons.star_border, color: const Color(0xFF838383), size: 50.0)),
												new SizedBox( width: 30.0 ),
											],
										),
									),
									new Row(
										children: [
											new Expanded(
												child: new Text(
													"What do you think?",
													textAlign: TextAlign.center,
													style: new TextStyle(
														color: const Color(0xFF000000),
														fontWeight: FontWeight.w300,
														fontSize: 14.0,
														height: 1.25,
													),
												),
											),
										],
									),
									new SizedBox( height: 50.0 ),
								]
							),
						),
					],
				)
			),
			persistentFooterButtons: <Widget>[
				new FlatButton(
					onPressed: () => Navigator.pop(context,true),
					child: new Icon(
						Icons.check_circle_outline,
						color: const Color(0xFF2D2D2F),
					),
				),
				new FlatButton(
					onPressed: () => Navigator.pop(context,true),
					child: new Icon(
						Icons.bookmark_border,
						color: const Color(0xFF2D2D2F),
					),
				),
			],
		);

	}
	
}


class Organization extends StatefulWidget {
	Organization({Key key, this.title}) : super(key: key);
	
	final String title;
	
	@override
	_OrganizationState createState() => new _OrganizationState();
}


class _OrganizationState extends State<Organization> {

	@override
	Widget build(BuildContext context) {
	  
		return new Scaffold(
			appBar: new AppBar(
				backgroundColor: const Color(0xFFFFFFFF),
				elevation: 0.0,
				centerTitle: true,
				title: new Text(
					'UWM'.toUpperCase(),
					style: new TextStyle(
						color: const Color(0xFF838383),
						fontWeight: FontWeight.w800,
						fontSize: 14.0,
					),
				),
				leading: new Container(),
			),
			body: new Container(),
			bottomNavigationBar: bottomBar(context, 4),
    	);

	}
	
}

