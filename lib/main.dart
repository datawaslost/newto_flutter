import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'package:validate/validate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:map_view/map_view.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;

import "dart:ui";
import 'dart:convert';
import 'dart:io';

import 'carousel.dart';


final String domain = "http://dev.newto.com/";

var userData;

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
				'/login': (BuildContext context) => new Login(),
				'/create': (BuildContext context) => new CreateEmail(),
				'/landing': (BuildContext context) => new Landing(),
				'/yourlist': (BuildContext context) => new YourList(),
				'/discover': (BuildContext context) => new Discover(),
				'/bookmarks': (BuildContext context) => new Bookmarks(),
				'/account': (BuildContext context) => new Account(),
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
		["org", userData[0]["organization"]["nav_image"]],
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
						child: new ImageIcon(
							( _navOptions[i][0] == "org" ? imgDefault(_navOptions[i][1], "icon_compass_selected.png") : new AssetImage("images/icon_" + _navOptions[i][1] + _selectedName + ".png") ),
							color: const Color(0xFFFFFFFF),
							size: 39.0
						),
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


void getUserData(token, success, fail) async {
	
	if (token == null) {
		// get stored token
		final prefs = await SharedPreferences.getInstance();
		token = prefs.getString('token') ?? null;
	}
	
	final response = await http.get(
		domain + 'api/me/',
		headers: {
			HttpHeaders.AUTHORIZATION: "JWT " + token
		},
	);
		
	if (response.statusCode == 200) {
		// If server returns an OK response, parse the JSON
		userData = json.decode(response.body);
		success(userData);
	} else {
		// If that response was not OK, throw an error.
		print(response.body);
		fail(response.statusCode);
	}
	
}


void checkIfToken(success, fail) async {
	
	// obtain shared preferences
	final prefs = await SharedPreferences.getInstance();
	final String token = prefs.getString('token') ?? null;
		
	if(token == null) {
		// no token stored, must be their first time
		fail();
	} else {
		success(token);
	}

}


void saveToken(token) async {
	
	// obtain shared preferences
	final prefs = await SharedPreferences.getInstance();
	prefs.setString('token',token);
	
}


class _HomeState extends State<Home> {
	
	@override
	void initState() {
		super.initState();
		checkIfToken(
			(token){
				// if token success, use that token to get user data
				getUserData(
					token, 
					(data){
						// Success
						// print(data);
						Navigator.of(context).pushNamed("/landing");
					},
					(code){
						// Failure
						print("getUserData failure callback : " + code.toString());
						Navigator.of(context).pushNamed("/login");
					}
				);
			}, 
			(){
				// if failure because of no token, go to onboarding
				Navigator.of(context).pushNamed("/onboarding");
			}, 
		);
	}
	    
	@override
	Widget build(BuildContext context) {
		return new Scaffold();
	}
	
}

// used on both register and login screens
class PasswordField extends StatefulWidget {
	const PasswordField({
		this.onSaved,
		this.validator,
		this.onFieldSubmitted,
		this.controller,
	});
	
	final FormFieldSetter<String> onSaved;
	final FormFieldValidator<String> validator;
	final ValueChanged<String> onFieldSubmitted;
	final TextEditingController controller;
	
	@override
	_PasswordFieldState createState() => new _PasswordFieldState();
}


// used on both register and login screens
class _PasswordFieldState extends State<PasswordField> {
	bool _obscureText = true;
	
	@override
	Widget build(BuildContext context) {
		return new TextFormField(
			obscureText: _obscureText,
			onSaved: widget.onSaved,
			validator: widget.validator,
			onFieldSubmitted: widget.onFieldSubmitted,
			controller: widget.controller,
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


class Onboarding extends StatefulWidget {
	Onboarding({Key key, this.title}) : super(key: key);
	final String title;
	@override
	_OnboardingState createState() => new _OnboardingState();
}


class _OnboardingState extends State<Onboarding> {
	
	@override
	Widget build(BuildContext context) {
		    
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
											onPressed: () => Navigator.of(context).pushNamed('/create'),
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
											onPressed: () => Navigator.of(context).pushNamed('/login'),
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


class Login extends StatefulWidget {
	Login({Key key, this.title}) : super(key: key);
	final String title;
	@override
	_LoginState createState() => new _LoginState();
}


class _LoginState extends State<Login> {

	final TextEditingController _emailController = new TextEditingController();
	final TextEditingController _passwordController = new TextEditingController();
	final _loginFormKey = GlobalKey<FormState>();

	void _loginWithCredentials(success, fail) async {
		
		final response = await http.post(
			domain + 'rest-auth/login/',
			body: {
				"username": _emailController.text,
				"password": _passwordController.text
			}
		);
		
		if (response.statusCode == 200) {
			// If server returns an OK response, save the token
			final token = json.decode(response.body)["token"];
			saveToken(token);
			// get user data before doing anything else
			getUserData(token, success, fail);
		} else {
			// If that response was not OK, throw an error.
			fail(response.body);
		}
		
	}


	@override
	Widget build(BuildContext context) {
	      
		return new Scaffold(
			body: new Form(
				key: _loginFormKey,
				child: new Column(
					mainAxisSize: MainAxisSize.min,
					children: <Widget>[
						new Row (
							children: <Widget>[
								new BackButton(),
								new Expanded(
									child: new Container(
										alignment: Alignment.topRight,
										child: new FlatButton(
											onPressed: () => Navigator.of(context).pushNamed('/create'),
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
							child: new TextFormField(
					        	controller: _emailController,
					        	validator: (value) {
									if (value.isEmpty) {
										return 'Please enter your email address.';
									}
									return null;
								},
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
							child: new PasswordField(
						        controller: _passwordController,
					        	validator: (value) {
									if (value.isEmpty) {
										return 'Please enter your password.';
									}
									return null;
								},
					        ),
						),
						new Expanded(
							child: new Align(
								alignment: Alignment.bottomCenter,
								child: new Row(
									children: <Widget>[
										new Expanded(
											child: new RaisedButton(
												onPressed: () {
													if (_loginFormKey.currentState.validate()) {
														_loginWithCredentials(
															(data) {
																// Success
																Navigator.of(context).pushNamed('/landing');
															},
															(error) {
																// Failure
																print(error);
															},
														);
													}
												},
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
			),
		);
	
	}

}


class CreateEmail extends StatefulWidget {
	CreateEmail({Key key, this.title}) : super(key: key);
	final String title;
	@override
	_CreateEmailState createState() => new _CreateEmailState();
}


class _CreateEmailState extends State<CreateEmail> {

	final TextEditingController _emailController = new TextEditingController();
	final _emailFormKey = GlobalKey<FormState>();
	int _organization;
	var usernameValidator;
	
	void _emailCheck() async {
		
		String email = _emailController.text;
		
		if (email.isEmpty) {
			return 'Please enter your email address.';
		} else {
			try {
				Validate.isEmail(email);
			} catch (e) {
				return 'Please enter a valid email address.';
			}
		}

		final response = await http.post(
			domain + 'api/emailcheck/',
			body: { "email": email },
		);
				
		if (response.statusCode == 200) {
			if (json.decode(response.body)["exists"]) {
				// If email exists
				return "That email already exists in our system. Try logging in.";
			} else {
				// If email does not exist, save organization if there is one.
				_organization = json.decode(response.body)["organization"];
				return null;
			};
		} else {
			// If there was a problem
			return "There was a problem communicating with the servers : " + response.statusCode.toString();
		}
		
	}

	@override
	Widget build(BuildContext context) {
				
		return new Scaffold(
			body: new Form(
				key: _emailFormKey,
				child: new Column(
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
											onPressed: () => Navigator.of(context).pushNamed('/login'),
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
					        child: new TextFormField(
					        	controller: _emailController,
								validator: (value) {
									return usernameValidator;
								},
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
						/*
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
						*/
						new Expanded(
							child: new Align(
								alignment: Alignment.bottomCenter,
								child: new Row(
									children: <Widget>[
										new Expanded(
											child: new RaisedButton(
												onPressed: () async {
													// asynchronously validate email
													var response = await _emailCheck();
													setState(() {
														this.usernameValidator = response;
													});
													if (_emailFormKey.currentState.validate()) {
														// if email is valid, go to the next screen
														Navigator.push(context, new MaterialPageRoute(
															builder: (BuildContext context) => new CreatePassword(_emailController.text, _organization),
														));
													}
												},
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
			),
	    );

	}

}


class CreatePassword extends StatefulWidget {
	CreatePassword(this.email, this.organization);
	final String email;
	final int organization;
	@override
	_CreatePasswordState createState() => new _CreatePasswordState(email, organization);
}


class _CreatePasswordState extends State<CreatePassword> {

	_CreatePasswordState(this.email, this.organization);
	
	final String email;
	final int organization;
	
	final TextEditingController _passwordController = new TextEditingController();
	final _passwordFormKey = GlobalKey<FormState>();
	
	@override
	Widget build(BuildContext context) {

		return new Scaffold(
			body: new Form(
				key: _passwordFormKey,
				child: new Column(
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
											onPressed: () => Navigator.of(context).pushNamed('/login'),
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
					        child: new PasswordField(
						        controller: _passwordController,
					        	validator: (value) {
									if (value.length < 8) {
										return 'Your password must be at least 8 characters.';
									}
									return null;
								},
					        ),
						),
						new Expanded(
							child: new Align(
								alignment: Alignment.bottomCenter,
								child: new Row(
									children: <Widget>[
										new Expanded(
											child: new RaisedButton(
												onPressed: () {
													if (_passwordFormKey.currentState.validate()) {
														Navigator.push(context, new MaterialPageRoute(
															builder: (BuildContext context) => new CreateFinish(email, _passwordController.text, organization),
														));
													}
												},
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
			),
		);
	}
}


class CreateFinish extends StatefulWidget {
	CreateFinish(this.email, this.password, this.organization);
	final String email;
	final String password;
	final int organization;
	@override
	_CreateFinishState createState() => new _CreateFinishState(email, password, organization);
}


class _CreateFinishState extends State<CreateFinish> {

	_CreateFinishState(this.email, this.password, this.organization);
	
	final String email;
	final String password;
	final int organization;
	List _organizations = [];
	int _org;
	final TextEditingController _hometownController = new TextEditingController();

	void _registerWithCredentials(success, fail) async {

		// just to make sure, remove token
		final prefs = await SharedPreferences.getInstance();
		prefs.remove('token');

		final response = await http.post(
			domain + 'rest-auth/registration/',
			body: {
				"username": email,
				"email": email,
				"password1": password,
				"password2": password,
			}
		);
				
		if (response.statusCode == 201) {
			// If server returns an OK response, parse the JSON
			_onboarding(success, fail, json.decode(response.body));
		} else {
			// If that response was not OK, throw an error.
			fail(response.body);
		}
		
	}

	void _onboarding(success, fail, body) async {
		
		// save the token we got from registering
		final token = body["token"];
		saveToken(token);
		
		// send email + id for onbboarding
		var onboarding_data = {
			"email": body["user"]["email"],
			"id": body["user"]["pk"].toString(),
		};
			
		// check if we have a hometown entered
		if (!_hometownController.text.isEmpty) onboarding_data["hometown"] = _hometownController.text.toString();
		
		if (organization != null) {
			// if we have an organization attached to this email
			onboarding_data["organization"] = organization.toString();
		} else if (_org != null) {		
			// if they chose an organization
			onboarding_data["organization"] = _org.toString();
		}

		final response = await http.post(
			domain + 'api/onboarding/',
			body: onboarding_data
		);
				
		if (response.statusCode == 200 || response.statusCode == 201) {
			// get user data before doing anything else
			getUserData(token, success, fail);

		} else {
			// If that response was not OK, throw an error.
			fail(response.body);
		}
		
	}

	void _getOrganizations() async {
		
		if (_organizations.length > 0) {
			return _organizations;
		} else {
			final response = await http.get( domain + 'api/organization/' );
			if (response.statusCode == 200) {
				// If we get organization data back
				_organizations = json.decode(response.body);
				return _organizations;
			} else {
				// If there was a problem
				return "There was a problem communicating with the servers : " + response.statusCode.toString();
			}
		}
	}
	
	@override
	Widget build(BuildContext context) {

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
										onPressed: () => Navigator.of(context).pushNamed('/login'),
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
						child: new TextFormField(
				        	controller: _hometownController,
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
					( organization == null
						? new Container(
							padding: new EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 0.0),
							alignment: Alignment.topLeft,
							child: new Text(
								"I'm with".toUpperCase(),
								style: new TextStyle(
									color: const Color(0xFF838383),
									fontWeight: FontWeight.w800,
									fontSize: 14.0,
								),
							),
						) : new SizedBox(width: 0.0)
					),
					( organization == null ?
						new FutureBuilder(
							future: _getOrganizations(),
							builder: (BuildContext context, AsyncSnapshot snapshot) {
								if (snapshot.hasData) {
									if (snapshot.data!=null) {
										
										// default to first item
										if (_org == null) _org = snapshot.data[0]["id"];
	
										return new Container(
											padding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
											child: new Theme(
												data: Theme.of(context).copyWith(
													canvasColor: Colors.white,
												),
												child: new FractionallySizedBox(
													widthFactor: 1.0,
													child: new DropdownButton<int>(
														items: snapshot.data.map((org) {
															return new DropdownMenuItem<int>(
																value: org["id"],
																child: new Text(
																	org["name"],
																	style: new TextStyle(
																		color: const Color(0xFF000000),
																		fontWeight: FontWeight.w800,
																		fontSize: 18.0,
																	),
																),
															);
														}).toList().cast<DropdownMenuItem<int>>(),
														value: _org,
														onChanged: (Object newVal) {
															setState(() {
																_org = newVal;
															});
														},
														style: new TextStyle(
															color: const Color(0xFF000000),
															fontWeight: FontWeight.w800,
															fontSize: 18.0,
														),		
													),
													),
											),
										);
															
									} else {
										return new Container();
									}
								} else {
									return new Container();
								}
							}
						) : new SizedBox(width: 0.0)
					),
						
					new Expanded(
						child: new Align(
							alignment: Alignment.bottomCenter,
							child: new Row(
								children: <Widget>[
									new Expanded(
										child: new RaisedButton(
											onPressed: () => _registerWithCredentials(
												(userData) {
													// Success
													Navigator.of(context).pushNamed('/landing');
												},
												(error) {
													// Failure
													print(error);
												},
											),
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
	}
}


void imgDefault(img, defaultImg) {
	if (img == null || img == "") {
		// default image
		return new AssetImage('images/' + defaultImg);
	} else if (!img.startsWith("/static/")) {
		return new AssetImage('images/'+img);
	} else {
		return new NetworkImage(domain + img);
	}
}


void discoverItem(id, txt, img, context, { String sponsored = null, bool bookmarked = false }) {
	
	var imgWidget = imgDefault(img, "misssaigon.jpg");
		
	return new GestureDetector(
		onTap: () {
			Navigator.push(context, new MaterialPageRoute(
				builder: (BuildContext context) => new Article(id),
			));
		},
		child: new Card(
			elevation: 3.0,
			child: new Container(
				decoration: new BoxDecoration(
					image: new DecorationImage(
						image: imgWidget,
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
										image: imgWidget,
										fit: BoxFit.cover,
										alignment: Alignment.bottomCenter,
									),
								),
								child: ( sponsored != null
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
	List<Widget> _carouselItems = [];
	List<Widget> _discoverItems = [];
	double _carouselProgress = 1 / userData[0]["todo"].length;
	
	@override
	Widget build(BuildContext context) {
	  
		void _dialog(item) {
			
			List<Widget> _widgetList = [
				new Row(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: <Widget>[
						new Expanded(
							child: new Text(
								item["name"].toUpperCase(),
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
				( item["content"] != "" && item["content"] !=null ?
					new Text(
						item["content"],
						textAlign: TextAlign.left,
						style: new TextStyle(
							color: const Color(0xFF000000),
							fontWeight: FontWeight.w300,
							fontSize: 14.0,
							height: 1.15,
						),
					) : new SizedBox( height: 0.0 )
				),
				new SizedBox( height: 25.0 ),
			];
			
			for (var cta in item["ctas"]) {
				_widgetList.add(
					new Row(
						children: <Widget>[
							new Expanded(
								child: new RaisedButton(
									onPressed: () => Navigator.pop(context,true),
									padding: new EdgeInsets.all(14.0),  
									color: const Color(0xFF1033FF),
									// color: const Color(0xFFE3F5FF),
									textColor: const Color(0xFFFFFFFF),
									child: new Text(
										cta["name"].toUpperCase(),
										style: new TextStyle(
											fontWeight: FontWeight.w800,
										),
									),
								),
							)
						]
					)
				);
			}
			
			if (item["ctas"].length == 0) {
				_widgetList.add(
					new Row(
						children: <Widget>[
							new Expanded(
								child: new RaisedButton(
									onPressed: () => Navigator.pop(context,true),
									padding: new EdgeInsets.all(14.0),  
									color: const Color(0xFF1033FF),
									// color: const Color(0xFFE3F5FF),
									textColor: const Color(0xFFFFFFFF),
									child: new Text(
										"Complete".toUpperCase(),
										style: new TextStyle(
											fontWeight: FontWeight.w800,
										),
									),
								),
							)
						]
					)
				);
			}

			showDialog(
				context: context,
				child: new AlertDialog(
					contentPadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 30.0),
					content: new SingleChildScrollView(
						scrollDirection: Axis.vertical,
						child: new Column(
							mainAxisSize: MainAxisSize.min,
							children: _widgetList,
						),
					),
				)
			);
		}
	
		void carouselItem(item) {
			return new Stack(
				children: [
				    new GestureDetector(
						onTap: () => _dialog(item),
						onLongPress: () => setState(() { _details = true; }),
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
										item["name"].toUpperCase(),
										textAlign: TextAlign.center,
										style: new TextStyle(
											color: const Color(0xFFFFFFFF),
											fontWeight: FontWeight.w800,
											fontSize: 24.0,
											height: 0.9,
										),
									),
									new FlatButton(
										// onPressed: () => Navigator.of(context).pushNamed('/yourlist'),
										onPressed: () => _dialog(item),
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
							child: new Center(
								child: new Row(
									children: [
										new Expanded(
											child: new InkWell(
												onTap: () => setState(() { _details = false; }),
												child: listButton(Icons.check),
											),
										),
										( item["bookmarked"] == true && item["bookmarked"] != null ? 
											// has bookmark, tap removes
											new Expanded(
												child: new InkWell(
													// remove bookmark
													onTap: () => setBookmark(item["id"], false, (){
														setState(() {
															// update icon and close details on success
															item["bookmarked"] = false;
															_details = false;
														});
													}, () { print("failure!"); }),
													child: listButton(Icons.bookmark),
												),
											)
										:
											// no bookmark, tap adds
											new Expanded(
												child: new InkWell(
													// add bookmark
													onTap: () => setBookmark(item["id"], true, (){
														setState(() {
															// update icon and close details on success
															item["bookmarked"] = true;
															_details = false;
														});
													}, () { print("failure!"); }),
													child: listButton(Icons.bookmark_border),
												),
											)
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
		
		// set up carousel items
		_carouselItems = [];
		userData[0]["todo"].forEach( (item) => _carouselItems.add(carouselItem(item)) );
	
		// set up discover items
		_discoverItems = [];
		for (var item in userData[0]["organization"]["discover_items"]) {
			if (item["group"] != null && item["group"] != "" && item["group"] != "false" && item["group"] != false) {
				_discoverItems.add(new Container( width: 278.0, height: 278.0, margin: new EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 20.0), child: listGroupImage(item["id"], item["name"], item["items"], item["image"], context, sponsored: item["sponsored"] ) ) );
			} else {
				_discoverItems.add(new Container( width: 278.0, height: 278.0, margin: new EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 20.0), child: discoverItem(item["id"], item["name"], item["image"], context) ) );
			}
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
										userData[0]["organization"]["nav_name"].toString().toUpperCase(),
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
						child: ( _carouselItems.length > 0 ?
							new Carousel(
								onCarouselChange: (i, t) => setState(() { 
									_carouselProgress = (i+1)/t;
								}),
								displayDuration: new Duration(seconds: 200000),
								children: _carouselItems,
							) : new Container()
						)
					),
					new Container(
						child: new LinearProgressIndicator(
							value: _carouselProgress,
							backgroundColor: const Color(0xFF2D2D2F),
							valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
						),
					),
					( _discoverItems.length > 0 ?
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
												children: _discoverItems,
											)
										)
									)
								],
							),
						) : new Container()
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


void listCardGesture(item, context, {bookmarked = false}) {
	
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
				_offsety = box.localToGlobal(Offset.zero).dy - MediaQuery.of(context).padding.top;
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
									            child: listCard(item["name"], height:_boxheight, width:_boxwidth, bookmarked: bookmarked),
											),
								            new Row(
												children: [
													new SizedBox( width: _offsetx, height: _boxheight),
													new Expanded( child: listButton(Icons.check) ),
													( item["bookmarked"] == true && item["bookmarked"] != null ? 
														// has bookmark, tap removes
														new Expanded(
															child: new GestureDetector(
																// remove bookmark
																onTap: () => setBookmark(item["id"], false, (){
																	// update icon and close dialog on success
																	item["bookmarked"] = false;
																	Navigator.pop(context);
																}, () { print("failure!"); }),
																child: listButton(Icons.bookmark),
															),
														)
													:
														// no bookmark, tap adds
														new Expanded(
															child: new GestureDetector(
																// add bookmark
																onTap: () => setBookmark(item["id"], true, (){
																	// update icon and close dialog on success
																	item["bookmarked"] = true;
																	Navigator.pop(context);
																}, () { print("failure!"); }),
																child: listButton(Icons.bookmark_border),
															),
														)
													),
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
		child: listCard(item["name"], key: stickyKey, bookmarked: bookmarked),
	);
}


void listGroup(int id, String txt, amount, context, {bookmarked = false, String sponsored}) {
	return new GestureDetector(
		onTap: () {
			Navigator.push(context, new MaterialPageRoute(
				builder: (BuildContext context) => new Group(id),
			));
		},
		child: new Card(
			elevation: 3.0,
			child: new Column(
				mainAxisSize: MainAxisSize.min,
				crossAxisAlignment: CrossAxisAlignment.start,
				children: <Widget>[
					new Expanded(
						child: new Container(
							padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 7.5),
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
					new Container(
						padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
						child: new Row(
							children: [
								new Expanded(
									child: (sponsored != null ? 
										new Text(
											'Sponsored by Amherst'.toUpperCase(),
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


void listGroupImage(int id, String txt, amount, img, context, {bookmarked = false, String sponsored}) {

	var imgWidget = imgDefault(img, "cardphoto.png");
	
	return new GestureDetector(
		onTap: () {
			Navigator.push(context, new MaterialPageRoute(
				builder: (BuildContext context) => new Group(id),
			));
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
													txt.toUpperCase(),
													textAlign: TextAlign.left,
													style: new TextStyle(
														color: const Color(0xFF000000),
														fontWeight: FontWeight.w800,
														fontSize: 24.0,
													),
												),
											),
											new Text(
												amount.toString().toUpperCase() + " ",
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
								image: imgWidget,
								fit: BoxFit.cover,
							),
						),
					),
				),
				( bookmarked
					? new Container(
						alignment: Alignment.topRight,
						margin: const EdgeInsets.fromLTRB(0.0, 10.0, 30.0, 0.0),
						child: new Icon(Icons.bookmark, color: const Color(0xFF00C3FF), size: 20.0),
					) : new SizedBox(width: 0.0)
				),
			],
		),
	);
	
}


void parseItems(list, context, {bookmarked = false}) {
	
	List<Widget> _listItems = [];
	List _listTodos = [];

	for (var item in list) {
		if (item["place"] != null && item["place"] != "" && item["place"] != "false" && item["place"] != false) {
			// it's a place
			_listItems.add(
				new SliverPadding(
					padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
					sliver: new SliverGrid.count(
						crossAxisSpacing: 10.0,
						mainAxisSpacing: 10.0,
						crossAxisCount: 1,
						childAspectRatio: 2.25,
						// fix this nonsense ^
						children: <Widget>[
							placeCard(item["id"], item["name"], item["image"], item["rating"], item["distance"], context, bookmarked: bookmarked),
						],
					),
				)
			);
		} else if (item["image"] != null && item["image"] != "") {
			// it's got an image we can feature
			if (item["group"] != null && item["group"] != "" && item["group"] != "false" && item["group"] != false) {
				// if it's a group with an image
				_listItems.add(
					new SliverPadding(
						padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
						sliver: new SliverGrid.count(
							crossAxisSpacing: 10.0,
							mainAxisSpacing: 10.0,
							crossAxisCount: 1,
							childAspectRatio: 1.2,
							children: <Widget>[
								listGroupImage(item["id"], item["name"], item["items"], item["image"], context, sponsored: item["sponsored"], bookmarked: bookmarked),
							]
						),
					)
				);
			} else {
				// not a group, has an image (probably an article)
				_listItems.add(
					new SliverPadding(
						padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
						sliver: new SliverGrid.count(
							crossAxisSpacing: 10.0,
							mainAxisSpacing: 10.0,
							crossAxisCount: 1,
							childAspectRatio: 1.0,
							children: <Widget>[
								discoverItem(item["id"], item["name"], item["image"], context, sponsored: item["sponsored"], bookmarked: bookmarked),
							]
						)
					)
				);
			}
		}  else if (item["group"] != null && item["group"] != "" && item["group"] != "false" && item["group"] != false) {
			// if it's a group without an image
			_listItems.add(
				new SliverPadding(
					padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
					sliver: new SliverGrid.count(
						crossAxisSpacing: 10.0,
						mainAxisSpacing: 10.0,
						crossAxisCount: 1,
						childAspectRatio: 2.75,
						children: <Widget>[
							listGroup(item["id"], item["name"], item["items"], context, sponsored: item["sponsored"], bookmarked: bookmarked),
						],
					),
				)
			);
		} else {
			// if it's a todo
			_listTodos.add(item);
			if (_listTodos.length > 1) {
				_listItems.add(
					new SliverPadding(
						padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
						sliver: new SliverGrid.count(
							crossAxisSpacing: 10.0,
							mainAxisSpacing: 10.0,
							crossAxisCount: 2,
							childAspectRatio: 1.1,
							children: <Widget>[
								listCardGesture(_listTodos[0], context, bookmarked: bookmarked),																
								listCardGesture(_listTodos[1], context, bookmarked: bookmarked),																
							],
						),
					)
				);
				_listTodos.clear();
			}
		}
	}
	
	// cleanup any remaining todo items
	if (_listTodos.length > 0) {
		_listItems.add(
			new SliverPadding(
				padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
				sliver: new SliverGrid.count(
					crossAxisSpacing: 10.0,
					mainAxisSpacing: 10.0,
					crossAxisCount: 2,
					childAspectRatio: 1.1,
					children: <Widget>[
						listCardGesture(_listTodos[0], context, bookmarked: bookmarked),																
					],
				),
			)
		);
	}
	
	// bottom padding
	_listItems.add(
		new SliverPadding(
			padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
		)
	);
	
	return _listItems;

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
							new Tab(text: userData[0]["organization"]["metro"]["name"].toString().toUpperCase()),
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
							slivers: parseItems(userData[0]["todo"], context),
						),
						// Popular
						new CustomScrollView(
							primary: false,
							slivers: parseItems(userData[0]["organization"]["popular"], context),
						),
						// Metro
						new CustomScrollView(
							primary: false,
							slivers: parseItems(userData[0]["organization"]["discover_items"], context),
						),
					],
				),
				bottomNavigationBar: bottomBar(context, 1),
			)
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

	List<Widget> _discoverItems = [];

	void searchCategory(cat) {
		
		var imgWidget = imgDefault(cat["image"], "misssaigon.jpg");
		
		return new GestureDetector(
			onTap: () {
				Navigator.push(context, new MaterialPageRoute(
					builder: (BuildContext context) => new Search(cat),
				));
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
									image: imgWidget,
									fit: BoxFit.cover,
								),
							),
						),
						new Text(
							cat["name"].toUpperCase(),
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
	
		// get categories from userData
		List<Widget> _categoryList = [];
		_categoryList.add(new SizedBox(width: 15.0));
		for (var cat in userData[0]["organization"]["categories"]) _categoryList.add( searchCategory(cat) );
		_categoryList.add(new SizedBox(width: 15.0));

		// set up discover items
		_discoverItems = [];
		for (var item in userData[0]["organization"]["discover_items"]) {
			if (item["group"] != null && item["group"] != "" && item["group"] != "false" && item["group"] != false) {
				_discoverItems.add(new Container( width: 278.0, height: 278.0, margin: new EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 20.0), child: listGroupImage(item["id"], item["name"], item["items"], item["image"], context, sponsored: item["sponsored"] ) ) );
			} else {
				_discoverItems.add(new Container( width: 278.0, height: 278.0, margin: new EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 20.0), child: discoverItem(item["id"], item["name"], item["image"], context) ) );
			}
		}

		return new Scaffold(
			backgroundColor: const Color(0xFF000000),
			appBar: new AppBar(
				backgroundColor: const Color(0xFF000000),
				centerTitle: true,
				title: new Text(
					'Discover '.toUpperCase() + userData[0]["organization"]["metro"]["name"].toUpperCase(),
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
											children: _categoryList,
										)
									)
								]
							),
						),
						( _discoverItems.length > 0 ?
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
													children: _discoverItems,
												)
											)
										)
									],
								)
							) : new Container()
						),
					]
				),
			),
			bottomNavigationBar: bottomBar(context, 2),
		);

	}
	
}


class Search extends StatefulWidget {
	Search(this.cat);
	final cat;
	@override
	_SearchState createState() => new _SearchState(cat);
}


class _SearchState extends State<Search> {

	_SearchState(this.cat);

	final cat;
	List<Widget> _widgetList = [];
	double _distance = 0.0;
	
	@override
	Widget build(BuildContext context) {
				
		void tagCard(tag) {
			return new Card(
				elevation: 3.0,
				child: new Container(
					height: 85.0,
					alignment: Alignment.center,
					padding: const EdgeInsets.all(10.0),
					child: new Text(
						tag["name"].toUpperCase(),
						textAlign: TextAlign.center,
						style: new TextStyle(
							color: const Color(0xFF000000),
							fontWeight: FontWeight.w800,
							fontSize: 14.0,
						),
					),
				),
			);
		};
			  
		return new Scaffold(
			backgroundColor: const Color(0xFFFFFFFF),
			appBar: new AppBar(
				backgroundColor: const Color(0xFFFFFFFF),
				elevation: 0.0,
				centerTitle: true,
				title: new Text(
					'FIND ' + cat["name"].toUpperCase(),
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
							'Type of ' + cat["name"],
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
							new Expanded( child: ( cat["tags"].length > 0 ? tagCard( cat["tags"][0] ) : new Container() ) ),
							new Container( width: 20.0 ),
							new Expanded( child: ( cat["tags"].length > 1 ? tagCard( cat["tags"][1] ) : new Container() ) ),
							new Container( width: 20.0 ),
						]
					),
					new Container( height: 20.0 ),
					new Row(
						children: <Widget>[
							new Container( width: 20.0 ),
							new Expanded( child: ( cat["tags"].length > 2 ? tagCard( cat["tags"][2] ) : new Container() ) ),
							new Container( width: 20.0 ),
							new Expanded( child: ( cat["tags"].length > 3 ? tagCard( cat["tags"][3] ) : new Container() ) ),
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
											onPressed: () {
												Navigator.push(context, new MaterialPageRoute(
													builder: (BuildContext context) => new SearchResults({"category": cat}),
												));
											},
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


void placeCard(id, txt, img, stars, distance, context, { featured = false, bookmarked = false }) {
	
	var imgWidget = imgDefault(img, "misssaigon.jpg");
	
	// calculate stars
	List<Widget> _starsList = [ new SizedBox( width: 20.0 ) ];
	for (var i = 0; i < stars; i++) _starsList.add( new Expanded(child:new Icon(Icons.star, color: const Color(0xFF1033FF), size: 30.0)) );
	for (var i = 0; i < 5-stars; i++) _starsList.add( new Expanded(child:new Icon(Icons.star_border, color: const Color(0xFF838383), size: 30.0)) );
	_starsList.add( new SizedBox( width: 20.0 ) );

	return new GestureDetector(
		onTap: () {
			Navigator.push(context, new MaterialPageRoute(
				builder: (BuildContext context) => new Place(id),
			));
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
												children: _starsList,
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
										image: imgWidget,
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


void getPlacesData(filters) async {
	
	// get stored token
	final prefs = await SharedPreferences.getInstance();
	final String token = prefs.getString('token') ?? null;
	var placesData;

	final response = await http.get(
		domain + 'api/place/',
		headers: {
			HttpHeaders.AUTHORIZATION: "JWT " + token
		},
	);
	
	if (response.statusCode == 200) {
		// If server returns an OK response, parse the JSON
		placesData = json.decode(response.body);
		return placesData;
	} else {
		// If that response was not OK, print the error and return null
		print(response.statusCode);
		print(response.body);
		return null;
	}
	
}


class SearchResults extends StatefulWidget {
	SearchResults(this.filters);
	final filters;
	@override
	_SearchResultsState createState() => new _SearchResultsState(filters);
}


class _SearchResultsState extends State<SearchResults> {

	_SearchResultsState(this.filters);
	final filters;
	List<Widget> _placeList = [];

	@override
	Widget build(BuildContext context) {
	  
		return new Scaffold(
			backgroundColor: const Color(0xFFFFFFFF),
			appBar: new AppBar(
				backgroundColor: const Color(0xFFFFFFFF),
				elevation: 0.0,
				centerTitle: true,
				title: new Text(
					filters["category"]["name"].toUpperCase(),
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
			body: new FutureBuilder(
				future: getPlacesData(filters),
				builder: (BuildContext context, AsyncSnapshot snapshot) {
					if (snapshot.hasData) {
						if (snapshot.data!=null) {
							
							_placeList = [];
							
							for (var place in snapshot.data) {
								_placeList.add(
									placeCard(place["id"], place["name"], place["image"], place["rating"], place["distance"], context)
								);
							}
							
							return new ListView(
								shrinkWrap: true,
								padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
								children: _placeList,
							);
							
						} else {
							return new ListView(
								shrinkWrap: true,
								padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
								children: [
									new Text(
										'Loading Error'.toUpperCase(),
										style: new TextStyle( fontWeight: FontWeight.w800 ),
									)
								],
							);
						}
					} else {
						return new ListView(
							shrinkWrap: true,
							padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
							children: [
								new Container(
									alignment: Alignment.center,
									child: new CircularProgressIndicator(),
								)
							],
						);
					}
				}
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
	void initState() {
		super.initState();
		getUserData(
			null, 
			(data){
				// Success
				setState(() {
					// print(data);
				});		
			},
			(code){
				// Failure
				print("getUserData failure callback : " + code.toString());
			}
		);
	}

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
				slivers: parseItems(userData[0]["bookmarks"], context, bookmarked: true),
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
						title: new Text(userData[0]["user"]["email"],
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
						title: new Text(userData[0]["hometown"],
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
						onTap: () => print("hometown"),
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
						onTap: () async {
							final prefs = await SharedPreferences.getInstance();
							prefs.remove('token');
							Navigator.of(context).pushNamed('/onboarding');
						},
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


void setBookmark(id, addremove, success, fail) async {

	// get stored token
	final prefs = await SharedPreferences.getInstance();
	final String token = prefs.getString('token') ?? null;
	
	// add or remove bookmark
	String bookmarktype = (addremove ? "addbookmark/" : "removebookmark/");

	final response = await http.post(
		domain + 'api/' + bookmarktype,
		headers: {
			HttpHeaders.AUTHORIZATION: "JWT " + token
		},
		body: {
			"id": id.toString(),
		}
	);
	
	if (response.statusCode == 200) {
		// If server returns an OK response
		final s = json.decode(response.body)["success"];
		if (s) {
			success();
		} else {
			print(response.body);
			fail();
		}
	} else {
		// If that response was not OK, throw an error.
		print(response.body);
		fail();
	}
	
}


getItemData(itemtype, id) async {
	
	// get stored token
	final prefs = await SharedPreferences.getInstance();
	final String token = prefs.getString('token') ?? null;

	final response = await http.get(
		domain + 'api/' + itemtype + '/' + id.toString() + '/',
		headers: {
			HttpHeaders.AUTHORIZATION: "JWT " + token
		},
	);
	
	if (response.statusCode == 200) {
		// If server returns an OK response, parse the JSON
		return json.decode(response.body);
	} else {
		// If that response was not OK, print the error and return null
		print(response.statusCode);
		print(response.body);
		return null;
	}
	
}


class Group extends StatefulWidget {
	Group(this.id);
	final int id;
	@override
	_GroupState createState() => new _GroupState(this.id);
}


class _GroupState extends State<Group> {

	_GroupState(this.id);

	final int id;
	List<Widget> _widgetList = [];
	var GroupData;

    @override
    void initState() {        
        // We can't mark this method as async because of the @override
        getItemData('group', id).then((result) {
            // If we need to rebuild the widget with the resulting data, make sure to use `setState`
            setState(() {
                GroupData = result;
            });
        });
    }

	@override
	Widget build(BuildContext context) {

        if (GroupData == null) {
            // This is what we show while we're loading
			return new Container(
				alignment: Alignment.center,
				child: new CircularProgressIndicator()
			);
        }

		_widgetList = [
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
				flexibleSpace: new FlexibleSpaceBar(
					background: new Image(
						image: imgDefault(GroupData["image"], "cardphoto.png"),
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
							GroupData["name"].toUpperCase(),
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
		];
		
		_widgetList.addAll(parseItems(GroupData["items"], context));

		return new Scaffold(
			backgroundColor: const Color(0xFFF3F3F7),
			body: new CustomScrollView(
				primary: false,
				slivers: _widgetList,
			),
			persistentFooterButtons: <Widget>[
				( GroupData["bookmarked"] == true ?
					new FlatButton(
						onPressed: () => setBookmark(GroupData["id"], false, (){
							// update icon on success
							setState(() {
								GroupData["bookmarked"] = false;
							});
						}, () { print("failure!"); }),
						child: new Icon(
							Icons.bookmark,
							color: const Color(0xFF2D2D2F),
						),
					) :
					new FlatButton(
						onPressed: () => setBookmark(GroupData["id"], true, (){
							// update icon on success
							setState(() {
								GroupData["bookmarked"] = true;
							});
						}, () { print("failure!"); }),
						child: new Icon(
							Icons.bookmark_border,
							color: const Color(0xFF2D2D2F),
						),
					)
				)
			],

		);

	}

}


class Article extends StatefulWidget {
	Article(this.id);
	final int id;
	@override
	_ArticleState createState() => new _ArticleState(this.id);
}


class _ArticleState extends State<Article> {

	_ArticleState(this.id);

	final int id;
	List<Widget> _widgetList = [];
	var articleData;

    @override
    void initState() {        
        // We can't mark this method as async because of the @override
        getItemData('item', id).then((result) {
            // If we need to rebuild the widget with the resulting data, make sure to use `setState`
            setState(() {
                articleData = result;
            });
        });
    }

	@override
	Widget build(BuildContext context) {

        if (articleData == null) {
            // This is what we show while we're loading
			return new Container(
				alignment: Alignment.center,
				child: new CircularProgressIndicator()
			);
        }

		_widgetList = [
			new Container(
				height: 324.0,
				decoration: new BoxDecoration(
					image: new DecorationImage(
						image: imgDefault(articleData["image"], "misssaigon.jpg"),
						fit: BoxFit.cover,
					),
				),
				child: new Column(
					mainAxisSize: MainAxisSize.min,
					children: <Widget>[
						new BackdropFilter(
							filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
							child: new Container(
								padding: new EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 15.0),
								child: new SafeArea(
									child: new Row(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: <Widget>[
											new Expanded(
												child: new Text(
													articleData["name"].toUpperCase(),
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
								),
								decoration: new BoxDecoration(color: Colors.white.withOpacity(0.5)),
							),
						),
					],
				),
			),
			( articleData["sponsor"] != "" ?
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
				) : new Container()
			),
			new Container(
				padding: new EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 15.0),
				child:  new Text(
					articleData["content"],
					textAlign: TextAlign.left,
					style: new TextStyle(
						color: const Color(0xFF000000),
						fontWeight: FontWeight.w300,
						fontSize: 14.0,
						height: 1.15,
					),
				),
			),
		];
		
		for (var cta in articleData["ctas"]) {
			_widgetList.add(
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
										cta["name"].toUpperCase(),
										style: new TextStyle(
											fontWeight: FontWeight.w800,
										),
									),
								),
							)
						]
					),
				),
			);
		}

		return new Scaffold(
			backgroundColor: const Color(0xFFFFFFFF),
			body: new SingleChildScrollView(
				scrollDirection: Axis.vertical,
				child: new Column(
					children: _widgetList,
				),
			),
			persistentFooterButtons: <Widget>[
				/*
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
				*/
				( articleData["bookmarked"] == true ?
					new FlatButton(
						onPressed: () => setBookmark(articleData["id"], false, (){
							// update icon on success
							setState(() {
								articleData["bookmarked"] = false;
							});
						}, () { print("failure!"); }),
						child: new Icon(
							Icons.bookmark,
							color: const Color(0xFF2D2D2F),
						),
					) :
					new FlatButton(
						onPressed: () => setBookmark(articleData["id"], true, (){
							// update icon on success
							setState(() {
								articleData["bookmarked"] = true;
							});
						}, () { print("failure!"); }),
						child: new Icon(
							Icons.bookmark_border,
							color: const Color(0xFF2D2D2F),
						),
					)
				)
			],
		);

	}
	
}


class Place extends StatefulWidget {
	Place(this.id);
	final int id;
	@override
	_PlaceState createState() => new _PlaceState(this.id);
}


class _PlaceState extends State<Place> {

	_PlaceState(this.id);

	final int id;
	List<Widget> _widgetList = [];
	var _staticMapProvider = new StaticMapProvider('AIzaSyAbhJpKCspO0OX3udKg6shFr5wwHw3yd_E');
	var placeData;

    @override
    void initState() {
        // We can't mark this method as async because of the @override
        getItemData('place', id).then((result) {
            // If we need to rebuild the widget with the resulting data, make sure to use `setState`
            setState(() {
                placeData = result;
            });
        });
    }

	@override
	Widget build(BuildContext context) {

        if (placeData == null) {
            // This is what we show while we're loading
			return new Container(
				alignment: Alignment.center,
				child: new CircularProgressIndicator()
			);
        }

		var imgWidget = imgDefault(placeData["image"], "misssaigon.jpg");

		// calculate stars
		final stars = placeData["rating"];
		List<Widget> _starsList = [ 
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
				stars.toString().toUpperCase(),
				style: new TextStyle(
					color: const Color(0xFF1033FF),
					fontWeight: FontWeight.w800,
					fontSize: 14.0,
					height: 1.25,
				),
			),
			new SizedBox( width: 10.0 ),
		];
		
		for (var i = 0; i < stars; i++) _starsList.add( new Expanded(child:new Icon(Icons.star, color: const Color(0xFF1033FF), size: 20.0)) );
		for (var i = 0; i < 5-stars; i++) _starsList.add( new Expanded(child:new Icon(Icons.star_border, color: const Color(0xFF838383), size: 20.0)) );

		return new Scaffold(
			backgroundColor: const Color(0xFFFFFFFF),
			body: new SingleChildScrollView(
				scrollDirection: Axis.vertical,
				child:  new Column(
					children: <Widget>[
						new Container(
							height: 324.0,
							decoration: new BoxDecoration(
								image: new DecorationImage(
									image: imgWidget,
									fit: BoxFit.cover,
								),
							),
							child: new Column(
								mainAxisSize: MainAxisSize.min,
								children: <Widget>[
									new BackdropFilter(
										filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
										child: new Container(
											padding: new EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 15.0),
											child: new SafeArea(
													child: new Row(
													crossAxisAlignment: CrossAxisAlignment.start,
													children: <Widget>[
														new Expanded(
															child: new Text(
																placeData["name"].toUpperCase(),
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
											),
											decoration: new BoxDecoration(color: Colors.white.withOpacity(0.5)),
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
										placeData["address"] + ", " + placeData["city"] + ", " + placeData["state"],
										textAlign: TextAlign.left,
										style: new TextStyle(
											color: const Color(0xFF1033FF),
											fontWeight: FontWeight.w400,
											fontSize: 14.0,
											height: 1.25,
										),
									),
									new GestureDetector(
										onTap: () {
											Navigator.push(context, new MaterialPageRoute(
												builder: (BuildContext context) => new WebviewScaffold(
													url: placeData["link"],
													appBar: new AppBar(
														title: new Text(
															placeData["name"].toUpperCase(),
															overflow: TextOverflow.fade,
															style: new TextStyle(
																fontWeight: FontWeight.w800,
																fontSize: 28.0,
																height: 0.9,
															),
														),
													),
												),
											));
										},
										child: new Text(
											placeData["link"].replaceFirst("https://www.", "").replaceFirst("http://www.", "").replaceFirst("http://", "").replaceFirst("https://", ""),
											textAlign: TextAlign.left,
											style: new TextStyle(
												color: const Color(0xFF1033FF),
												fontWeight: FontWeight.w400,
												fontSize: 14.0,
												height: 1.25,
											),
										),
									),
									new Text(
										placeData["phone"],
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
									( placeData["location"] != null ?
										new Container(
											padding: new EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 20.0),
											child: new Image.network(
												_staticMapProvider.getStaticUriWithMarkers(
													<Marker>[ new Marker("1", placeData["name"], placeData["location"]["longitude"], placeData["location"]["latitude"]) ],
													width: 600,
													height: 400,
													maptype: StaticMapViewType.roadmap,
												).toString()
											),
										) : new Container()
									),
									new SizedBox( height: 20.0 ),
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
											placeData["content"],
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
										children: _starsList,
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
				),
			),
			persistentFooterButtons: <Widget>[
				( placeData["bookmarked"] == true ?
					new FlatButton(
						onPressed: () => setBookmark(placeData["id"], false, (){
							// update icon on success
							setState(() {
								placeData["bookmarked"] = false;
							});
						}, () { print("failure!"); }),
						child: new Icon(
							Icons.bookmark,
							color: const Color(0xFF2D2D2F),
						),
					) :
					new FlatButton(
						onPressed: () => setBookmark(placeData["id"], true, (){
							// update icon on success
							setState(() {
								placeData["bookmarked"] = true;
							});
						}, () { print("failure!"); }),
						child: new Icon(
							Icons.bookmark_border,
							color: const Color(0xFF2D2D2F),
						),
					)
				)
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
					userData[0]["organization"]["name"].toString().toUpperCase(),
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

