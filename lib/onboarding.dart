import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'package:validate/validate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import "dart:ui";
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'main.dart';




dynamic getUserData(token, success, fail) async {
	
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


dynamic checkIfToken(success, fail) async {
	
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


dynamic saveToken(token) async {
	
	// obtain shared preferences
	final prefs = await SharedPreferences.getInstance();
	prefs.setString('token',token);
	
}


dynamic initData(context) async {
	
	// check for internet connectivity
	new Connectivity().checkConnectivity().then((result) {
		if (result == ConnectivityResult.none) {
			// not connected to the internet
			print("no internet");
			Navigator.of(context).pushNamed("/nointernet");
		} else {
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
	});
	
}



class Home extends StatefulWidget {
	Home();
	@override
	_HomeState createState() => new _HomeState();
}


class _HomeState extends State<Home> {
	
	@override
	void initState() {
		
		super.initState();
		
		initData(context);
		
		// cleanup any existing listeners
		if (internetListener != null) internetListener.cancel();

		// setup listener for internet connection changes
		internetListener = new Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
			// when the internet connection changes
			if (result == ConnectivityResult.none) {
				// not connected to the internet
				print("no internet via listener");
				Navigator.of(context).pushNamed("/nointernet");
			}
		});

	}

	@override
	dispose() {
		print("disposed");
		super.dispose();
		internetListener.cancel();
	}
	    
	@override
	Widget build(BuildContext context) {
		
		return new Container(
			alignment: Alignment.center,
			child: new CircularProgressIndicator()
		);
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
				child: SafeArea(
					child: new Column(
						mainAxisSize: MainAxisSize.min,
						children: <Widget>[
							new Row (
								children: <Widget>[
									new BackButton(
										color: const Color(0xFF000000),
									),
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
	
	dynamic _emailCheck() async {
		
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
				child: SafeArea(
					child: new Column(
						mainAxisSize: MainAxisSize.min,
						children: <Widget>[
							new LinearProgressIndicator(
								valueColor: new AlwaysStoppedAnimation<Color>(const Color(0xFF1033FF)),
								value: 0.33,
								backgroundColor: const Color(0xFFFFFFFF),
							),
							new Row (
								children: <Widget>[
									new BackButton(
										color: const Color(0xFF000000),
									),
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
	var passwordValidator;

	final TextEditingController _passwordController = new TextEditingController();
	final _passwordFormKey = GlobalKey<FormState>();

	dynamic _passwordCheck() async {
		
		String password = _passwordController.text;
		
		if (password.isEmpty) {
			return 'Please enter a password.';
		}
		
		if (password.length < 8) {
			return 'Your password must be at least 8 characters.';
		}

		final response = await http.post(
			domain + 'api/passwordcheck/',
			body: { "password": password },
		);
				
		if (response.statusCode == 200) {
			if (json.decode(response.body)["success"]) {
				// If password is ok
				return null;
			} else {
				return json.decode(response.body)["error"];
			};
		} else {
			// If there was a problem
			return "There was a problem communicating with the servers : " + response.statusCode.toString();
		}
		
	}

	@override
	Widget build(BuildContext context) {

		return new Scaffold(
			body: SafeArea(
				child: new Form(
					key: _passwordFormKey,
					child: new Column(
						mainAxisSize: MainAxisSize.min,
						children: <Widget>[
							new LinearProgressIndicator(
								valueColor: new AlwaysStoppedAnimation<Color>(const Color(0xFF1033FF)),
								value: 0.66,
								backgroundColor: const Color(0xFFFFFFFF),
							),
							new Row (
								children: <Widget>[
									new BackButton(
										color: const Color(0xFF000000),
									),
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
										return passwordValidator;
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
													onPressed: () async {
														// asynchronously validate email
														var response = await _passwordCheck();
														setState(() {
															this.passwordValidator = response;
														});
														if (_passwordFormKey.currentState.validate()) {
															// if email is valid, go to the next screen
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

	dynamic _getOrganizations() async {
		
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
			body: SafeArea(
				child: new Column(
					mainAxisSize: MainAxisSize.min,
					children: <Widget>[
						new LinearProgressIndicator(
							valueColor: new AlwaysStoppedAnimation<Color>(const Color(0xFF1033FF)),
							value: 1.0,
							backgroundColor: const Color(0xFFFFFFFF),
						),
						new Row (
							children: <Widget>[
								new BackButton(
									color: const Color(0xFF000000),
								),
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
			),
		);
	}
}
