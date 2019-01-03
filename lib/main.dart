import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'package:validate/validate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:map_view/map_view.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import "dart:ui";
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'carousel.dart';
import 'swipeCard.dart';
import 'onboarding.dart';


final String domain = "http://dev.newto.com/";

var userData;
var internetListener;

// Instance of WebView plugin
final flutterWebviewPlugin = new FlutterWebviewPlugin();

void main() {
	MapView.setApiKey("AIzaSyAbhJpKCspO0OX3udKg6shFr5wwHw3yd_E");
	runApp(new Newto());
}


class Newto extends StatefulWidget {
	Newto();
	@override
	_NewtoState createState() => new _NewtoState();
}


class _NewtoState extends State<Newto> {
	
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
			// home: new Home(),
			initialRoute: '/',
		    routes: <String, WidgetBuilder> {
				'/': (BuildContext context) => new Home(),
				'/onboarding': (BuildContext context) => new Onboarding(),
				'/login': (BuildContext context) => new Login(),
				'/create': (BuildContext context) => new CreateEmail(),
				'/landing': (BuildContext context) => new Landing(),
				'/yourlist': (BuildContext context) => new YourList(),
				'/discover': (BuildContext context) => new Discover(),
				'/bookmarks': (BuildContext context) => new Bookmarks(),
				'/account': (BuildContext context) => new Account(),
				'/org': (BuildContext context) => new Organization(),
				'/nointernet': (BuildContext context) => new NoInternet(),
			},
		);
	}

}


dynamic bottomBar(context, _selected) {


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
					onTap: () {
						if (i != _selected) {
							
							// close org webview
							flutterWebviewPlugin.close();
							
							getUserData(
								null, 
								(data){
									// Success
									// print(data);
								},
								(code){
									// Failure
									print("getUserData failure callback : " + code.toString());
								}
							);
							Navigator.of(context).pushNamed("/" + _navOptions[i][0]);
						}
					},
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


dynamic imgDefault(img, defaultImg) {
	if (img == null || img == "") {
		// default image
		return new AssetImage('images/' + defaultImg);
	} else if (!img.startsWith("/static/")) {
		return new AssetImage('images/'+img);
	} else {
		return new NetworkImage(domain + img);
	}
}


dynamic discoverItem(id, txt, img, context, { String sponsored = null, bool bookmarked = false }) {
	
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
						image: imgDefault(img, "misssaigon.jpg"),
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
								child: ( sponsored != null && sponsored != ""
									? new Column(
										mainAxisSize: MainAxisSize.min,
										children: <Widget>[
											new Expanded( child: new Container() ),
											new Row(
												children: [
													new Container(
														padding: new EdgeInsets.fromLTRB(11.0, 8.0, 11.0, 7.0),
														child: new Text(
															sponsored.toUpperCase(),
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
	  
		dynamic _dialog(item) {
			
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
									onPressed: () {
										if (cta["link"] != null && cta["link"] != "") {
											Navigator.push(
												context,
												new MaterialPageRoute(
													builder: (BuildContext context) => new WebviewScaffold(
														url: cta["link"],
														appBar: new AppBar(
															title: new Text(
																cta["name"].toUpperCase(),
																overflow: TextOverflow.fade,
																style: new TextStyle(
																	fontWeight: FontWeight.w800,
																	fontSize: 28.0,
																	height: 0.9,
																),
															),
														),
													),
												)
											);
										} else {
											// no url link specified in cta - should just close or also complete?
											Navigator.pop(context,true);
										}
									},
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
				);
				_widgetList.add(
					SizedBox(height: 10.0),
				);
			}
			
			_widgetList.add(
				new Row(
					children: <Widget>[
						new Expanded(
							child: new RaisedButton(
								onPressed: () => setThis("adddone", { "id": item["id"].toString() }, (){
									setState(() {
										// update icon and close details on success
										item["done"] = true;
										// immediately remove item from todo list
										userData[0]["todo"].removeWhere((i) => i["id"] == item["id"]);
										_details = false;
										Navigator.pop(context,true);
									});
								}, () { print("failure!"); }),
								// need to also complete the item here?
								padding: new EdgeInsets.all(14.0),  
								color: const Color(0xFFE3F5FF),
								textColor: const Color(0xFF000000),
								child: new Text(
									"Mark as Done".toUpperCase(),
									style: new TextStyle(
										fontWeight: FontWeight.w800,
									),
								),
							),
						)
					]
				)
			);
			
			if (item["group"] == true) {
				// if it's a group, just go to that screen
				Navigator.push(context, new MaterialPageRoute(
					builder: (BuildContext context) => new Group(item["id"]),
				));
			} else {
				// show quick content dialog for todo items and articles
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
			
		}
	
		dynamic carouselItem(item) {
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
									new SizedBox(height: 5.0),
									new Icon(
										Icons.arrow_forward,
										color: const Color(0xFFFFFFFF),
									),
								],
							),
						),
					),
					(_details
						? new Stack(
							fit: StackFit.expand,
							children: <Widget>[
								GestureDetector(
									onTap: () => setState(() { _details = false; }),
									child: Container(
										color: const Color(0xFF000000),
									),
								),
								Container(
									padding: new EdgeInsets.fromLTRB(80.0, 0.0, 80.0, 0.0),
									child: new Center(
										child: new Row(
											children: [
												( item["done"] == true && item["done"] != null ? 
													// is done, tap removes
													new Expanded(
														child: new InkWell(
															// remove done
															onTap: () => setThis("removedone", { "id": item["id"].toString() }, (){
																setState(() {
																	// update icon and close details on success
																	item["done"] = false;
																	_details = false;
																});
															}, () { print("failure!"); }),
															child: listButton(Icons.remove),
														),
													)
												:
													// not done, tap adds
													new Expanded(
														child: new InkWell(
															// add done
															onTap: () => setThis("adddone", { "id": item["id"].toString() }, (){
																setState(() {
																	// update icon and close details on success
																	item["done"] = true;
																	// immediately remove item from todo list
																	userData[0]["todo"].removeWhere((i) => i["id"] == item["id"]);
																	_details = false;
																});
															}, () { print("failure!"); }),
															child: listButton(Icons.check),
														),
													)
												),
												( item["bookmarked"] == true && item["bookmarked"] != null ? 
													// has bookmark, tap removes
													new Expanded(
														child: new InkWell(
															// remove bookmark
															onTap: () => setThis("removebookmark", { "id": item["id"].toString() }, (){
																setState(() {
																	// update icon and close details on success
																	item["bookmarked"] = false;
																	// remove item from bookmarks list
																	userData[0]["bookmarks"].removeWhere((i) => i["id"] == item["id"]);
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
															onTap: () => setThis("addbookmark", { "id": item["id"].toString() }, (){
																setState(() {
																	// update icon and close details on success
																	item["bookmarked"] = true;
																	// add item to bookmarks list
																	Map newItemData = json.decode(json.encode(item));
																	userData[0]["bookmarks"].add(newItemData);
																	_details = false;
																});
															}, () { print("failure!"); }),
															child: listButton(Icons.bookmark_border),
														),
													)
												),
												// no bookmark, tap adds
												new Expanded(
													child: new InkWell(
														// remove from list
														onTap: () => setThis("removelist", { "id": item["id"].toString() }, (){
															// update icon on success
															setState(() {
																item["done"] = null;
																// immediately remove item from list
																userData[0]["todo"].removeWhere((i) => i["id"] == item["id"]);
																_details = false;
															});	
														}, () { print("failure!"); }),
														child: listButton(Icons.delete_outline),
													),
												),
											]
										)
									),
								),
							]
						) : new Container()
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
				_discoverItems.add(new Container( width: 278.0, height: 278.0, margin: new EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 20.0), child: listGroupImage(item["id"], item["name"], item["items"], item["image"], context, sponsored: item["sponsor"], bookmarked: ( item["bookmarked"] == null ? false : item["bookmarked"] )  ) ) );
			} else {
				_discoverItems.add(new Container( width: 278.0, height: 278.0, margin: new EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 20.0), child: discoverItem(item["id"], item["name"], item["image"], context, sponsored: item["sponsor"], bookmarked: ( item["bookmarked"] == null ? false : item["bookmarked"] ) ) ) );
			}
		}

		return new Scaffold(
			backgroundColor: const Color(0xFFFFFFFF),
			appBar: new AppBar(
				brightness: Brightness.light,
				backgroundColor: const Color(0x00FFFFFF),
				elevation: 0.0,
				centerTitle: true,
				title: Column(
					mainAxisAlignment: MainAxisAlignment.end,
					children: <Widget>[
						Image.asset("images/LogoSpan-Black.png", height: 12.0),
						Container(
							padding: const EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 5.0),
							child: Text(
								userData[0]["organization"]["nav_name"].toString().toUpperCase(),
								style: new TextStyle(
									color: const Color(0xFF838383),
									fontWeight: FontWeight.w300,
									fontSize: 16.0,
								),
							),
						),
					]
				),
				leading: IconButton(
					icon: new Icon(Icons.account_circle),
					// icon: new Icon(Icons.person_outline),
					color: const Color(0xFF838383),
					tooltip: 'Account',
					onPressed: () => Navigator.of(context).pushNamed('/account'),
					iconSize: 35.0,
					padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
				),
			),
			body: new swipeCards(userData[0]["organization"]["discover_items"]),

			/*
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
			*/
			
			bottomNavigationBar: bottomBar(context, 0),
		);

	}
	
}

dynamic listButton(icon, { double size = 50.0 }) {
	return new Container(
		width: size,
		height: size,
		decoration: new BoxDecoration(
			shape: BoxShape.circle,
			color: const Color(0xFFFFFFFF),
			boxShadow: [new BoxShadow(
	            color: const Color(0x66000000),
	            blurRadius: 8.0,
          ),]
		),
		child: new Icon( icon, size: size/2, color: const Color(0xFF000000) ),
	);
}


dynamic todoButton(icon, { double size = 50.0, var color = const Color(0xFFFFFFFF)  }) {
	return new Container(
		width: size,
		height: size,
		decoration: new BoxDecoration(
			shape: BoxShape.circle,
			color: color,
			boxShadow: [new BoxShadow(
	            color: const Color(0xFFFFFFFF),
	            blurRadius: 0.0,
          ),]
		),
		child: new Icon( icon, size: size/1.25, color: const Color(0xFFFFFFFF) ),
	);
}


class listTodo extends StatefulWidget {
	listTodo(this.item, this.context, {this.bookmarked = false, this.yourlist = false});
	var item;
	var context;
	bool bookmarked;
	bool yourlist;
	@override
	_listTodoState createState() => new _listTodoState(this.item, this.context, this.bookmarked, this.yourlist);
}


class _listTodoState extends State<listTodo> {

	_listTodoState(this.item, this.context, this.bookmarked, this.yourlist);
	
	var item;
	var context;
	bool bookmarked;
	bool yourlist;
	var mainButton;
	List secondaryButtons = <Widget>[];
	
	@override
	Widget build(BuildContext context) {
		
		// set secondary buttons
		if (bookmarked == true) {
			// if we're in bookmarks
			secondaryButtons = <Widget>[
				( item["done"] != null ?
					// if item is in our list
					SlideAction(
						child: new Icon( Icons.playlist_play, size: 32.0, color: const Color(0xFF000000) ),
						onTap: () => setThis("removelist", { "id": item["id"].toString() }, (){
							// update icon on success
							setState(() {
								item["done"] = null;
								// immediately remove item from list
								userData[0]["todo"].removeWhere((i) => i["id"] == item["id"]);
							});	
						}, () { print("failure!"); }),
					)
				:
					SlideAction(
						child: new Icon( Icons.playlist_add, size: 32.0, color: const Color(0xFF000000) ),
						onTap: () => setThis("addlist", { "id": item["id"].toString() }, (){							
							setState(() {
								item["done"] = false;
								// immediately add item to your list
								Map newItemData = json.decode(json.encode(item));
								userData[0]["todo"].add(newItemData);
							});
						}, () { print("failure!"); }),
					)
				)
			];
		} else if (yourlist == true) {
			// if we're anywhere else but bookmarks
			secondaryButtons = <Widget>[
				( item["bookmarked"] == true && item["bookmarked"] != null ? 
					SlideAction(
						child: new Icon( Icons.bookmark, size: 32.0, color: const Color(0xFF000000)  ),
						onTap: () => setThis("removebookmark", { "id": item["id"].toString() }, (){
							// update icon on success
							setState(() {
								item["bookmarked"] = false;
								// immediately remove item from bookmarks list
								// userData[0]["bookmarks"].removeWhere((i) => i["id"] == item["id"]);
							});	
						}, () { print("failure!"); }),
					)
				:
					SlideAction(
						child: new Icon( Icons.bookmark_border, size: 32.0, color: const Color(0xFF000000) ),
						onTap: () => setThis("addbookmark", { "id": item["id"].toString() }, (){
							setState(() {
								// update icon and close dialog on success
								item["bookmarked"] = true;
								// immediately add item to bookmarks list
								Map newItemData = json.decode(json.encode(item));
								userData[0]["bookmarks"].add(newItemData);
							});	
						}, () { print("failure!"); }),
					)
				),
				( item["done"] != null ?
					// if item is in our list
					SlideAction(
						child: new Icon( Icons.delete_outline, size: 32.0, color: const Color(0xFF000000) ),
						onTap: () => setThis("removelist", { "id": item["id"].toString() }, (){
							// update icon on success
							setState(() {
								item["done"] = null;
								// immediately remove item from list
								userData[0]["todo"].removeWhere((i) => i["id"] == item["id"]);
							});	
						}, () { print("failure!"); }),
					)
				:
					SlideAction(
						child: new Icon( Icons.playlist_add, size: 32.0, color: const Color(0xFF000000) ),
						onTap: () => setThis("addlist", { "id": item["id"].toString() }, (){							
							setState(() {
								item["done"] = false;
								// immediately add item to your list
								Map newItemData = json.decode(json.encode(item));
								userData[0]["todo"].add(newItemData);
							});
						}, () { print("failure!"); }),
					)
				)
			];
		} else  {
			// if we're anywhere else but bookmarks or your list
			secondaryButtons = <Widget>[
				( item["bookmarked"] == true && item["bookmarked"] != null ? 
					SlideAction(
						child: new Icon( Icons.bookmark, size: 32.0, color: const Color(0xFF000000)  ),
						onTap: () => setThis("removebookmark", { "id": item["id"].toString() }, (){
							// update icon on success
							setState(() {
								item["bookmarked"] = false;
								// immediately remove item from bookmarks list
								// userData[0]["bookmarks"].removeWhere((i) => i["id"] == item["id"]);
							});	
						}, () { print("failure!"); }),
					)
				:
					SlideAction(
						child: new Icon( Icons.bookmark_border, size: 32.0, color: const Color(0xFF838383) ),
						onTap: () => setThis("addbookmark", { "id": item["id"].toString() }, (){
							setState(() {
								// update icon and close dialog on success
								item["bookmarked"] = true;
								// immediately add item to bookmarks list
								Map newItemData = json.decode(json.encode(item));
								userData[0]["bookmarks"].add(newItemData);
							});	
						}, () { print("failure!"); }),
					)
				)
			];
		}
	
		if (yourlist == true) {
			// if we're in your list
			if ( item["done"] == true && item["done"] != null) {
				// if item has been marked done
				mainButton = GestureDetector(
					child: todoButton(Icons.check_circle_outline, size: 35.0, color: const Color(0xFFA2EA3A) ),
					// remove done
					onTap: () => setThis("removedone", { "id": item["id"].toString() }, (){
						// update icon and close details on success
						setState(() {
							item["done"] = false;
						});	
					}, () { print("failure!"); }),
				);
			} else {
				// if item has not been marked done
				mainButton = GestureDetector(
					child: todoButton(Icons.check_circle_outline, size: 35.0, color: const Color(0xFFE0E1EA) ),
					// remove done
					onTap: () => setThis("adddone", { "id": item["id"].toString() }, (){
						setState(() {
							item["done"] = true;
							// set done to true in the user data so that it's persistent until the data refreshes
							int index = userData[0]["todo"].indexWhere((i) => i["id"] == item["id"]);
							if (index != -1) userData[0]["todo"][index]["done"] = true;
						});	
					}, () { print("failure!"); }),
				);
			}
		} else if (bookmarked == true) {
			// if we're in bookmarks
			if ( item["bookmarked"] == true && item["bookmarked"] != null) {
				// if item is in our bookmarks
				mainButton = GestureDetector(
					child: todoButton(Icons.bookmark, size: 35.0, color: const Color(0xFFA2EA3A) ),
					// remove bookmark
					onTap: () => setThis("removebookmark", { "id": item["id"].toString() }, (){
						// update icon and close details on success
						setState(() {
							item["bookmarked"] = false;
							// set bookmarked to false in the user data so that it's persistent until the data refreshes
							int index = userData[0]["bookmarks"].indexWhere((i) => i["id"] == item["id"]);
							if (index != -1) userData[0]["bookmarks"][index]["bookmarked"] = false;
							// immediately remove item from bookmarks list
							// userData[0]["bookmarks"].removeWhere((i) => i["id"] == item["id"]);
						});	
					}, () { print("failure!"); }),
				);
			} else {
				// if item is not in our bookmarks (ie, has just been removed)
				mainButton = GestureDetector(
					child: todoButton(Icons.bookmark_border, size: 35.0, color: const Color(0xFFE0E1EA) ),
					// add bookmark
					onTap: () => setThis("addbookmark", { "id": item["id"].toString() }, (){
						setState(() {
							item["bookmarked"] = true;
						});	
					}, () { print("failure!"); }),
				);
			}
		} else { 
			// if we're in popular, a group, etc.
			if ( item["done"] != null ) {
				// if item is in our list
				mainButton = GestureDetector(
					child: todoButton(Icons.playlist_play, size: 35.0, color: const Color(0xFFA2EA3A) ),
					// remove bookmark
					onTap: () => setThis("removelist", { "id": item["id"].toString() }, (){
						// update icon and close details on success
						setState(() {
							item["done"] = null;
							// immediately remove item from list
							userData[0]["todo"].removeWhere((i) => i["id"] == item["id"]);
						});	
					}, () { print("failure!"); }),
				);
			} else {
				// if item is not in our todo list
				mainButton = GestureDetector(
					child: todoButton(Icons.playlist_add, size: 35.0, color: const Color(0xFFE0E1EA) ),
					// add to list
					onTap: () => setThis("addlist", { "id": item["id"].toString() }, (){
						setState(() {
							// this setstate isn't updating the data for the other tab
							item["done"] = false;
							// immediately add item to your list
							Map newItemData = json.decode(json.encode(item));
							userData[0]["todo"].add(newItemData);
						});	
					}, () { print("failure!"); }),
				);
			}
		}
		
		if (item["done"] != null || yourlist != true) {
			return Slidable(
				delegate: SlidableDrawerDelegate(),
				actionExtentRatio: 0.25,
				child: Row(
					mainAxisSize: MainAxisSize.min,
					crossAxisAlignment: CrossAxisAlignment.center,
					children: [
						Container(
							padding: const EdgeInsets.fromLTRB(10.0, 10.0, 15.0, 10.0),
							child: mainButton,
						),
						Expanded(
							child: Container(
								alignment: Alignment.centerLeft,
								constraints: BoxConstraints(
									minHeight: 45.0,
								),
								padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
								decoration: BoxDecoration(
				                    color: const Color(0xFF023cf5),
				                    borderRadius: new BorderRadius.circular(20.0),
				                    boxShadow: [new BoxShadow(
										color: const Color(0x66000000),
										blurRadius: 10.0,
										offset: Offset(0.0, 5.0),
									),]
								),
								child: Text(
									item["name"],
									textAlign: TextAlign.left,
									style: TextStyle(
										color: const Color(0xFFFFFFFF),
										fontWeight: FontWeight.w600,
										fontSize: 16.0,
									),
								),
							),
						),
						(bookmarked ? 
							SizedBox(
								width: 40.0,
								child: Icon(Icons.bookmark, color: const Color(0xFF00C3FF), size: 20.0)
							) : Container()
						),
						Container(),
					],
				),
				secondaryActions: secondaryButtons,
			);
		} else {
			return RaisedButton(
				onPressed: () => setThis("addlist", { "id": item["id"].toString() }, (){							
					setState(() {
						item["done"] = false;
					});
				}, () { print("failure!"); }),
				padding: new EdgeInsets.all(20.0),  
				color: const Color(0xFFE3F5FF),
				textColor: const Color(0xFF000000),
				child: new Text(
					'Item removed from list. Tap to undo',
					style: new TextStyle(
						fontWeight: FontWeight.w800,
					),
				),
			);

		}
		
	}
}


dynamic listGroup(int id, String txt, amount, context, {bookmarked = false, String sponsored}) {
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
									child: (sponsored != null && sponsored != "" ? 
										new Text(
											sponsored.toUpperCase(),
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


dynamic listGroupImage(int id, String txt, amount, img, context, {bookmarked = false, String sponsored}) {

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
								image: imgDefault(img, "cardphoto.png"),
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



dynamic addItem(context) {

	final TextEditingController _todoController = new TextEditingController();
	final _todoFormKey = GlobalKey<FormState>();

	showDialog(
		context: context,
		child: new AlertDialog(
			contentPadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 30.0),
			content: new SingleChildScrollView(
				scrollDirection: Axis.vertical,
				child: new Column(
					mainAxisSize: MainAxisSize.min,
					children: [
						new Container(
							padding: new EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
							alignment: Alignment.topLeft,
							child: new Text(
								'Add a new Todo Item'.toUpperCase(),
								style: new TextStyle(
									color: const Color(0xFF838383),
									fontWeight: FontWeight.w800,
									fontSize: 14.0,
								),
							),
						),
						new Form(
							key: _todoFormKey,
							child: new Container(
								padding: new EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
								child: new TextFormField(
									autofocus: true,
						        	controller: _todoController,
						        	validator: (value) {
										if (value.isEmpty) return 'Please enter text for your todo item.';
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
									maxLines: 3,
						        ),
							),
						),
						
						new RaisedButton(
							onPressed: () {
								if (_todoFormKey.currentState.validate()) {
									setThis("addtodo", { "name": _todoController.text }, (data){
										// setState(() {
											Map newTodoData = {
												"name": _todoController.text,
												"id" : data["id"],
												"done": false,
												"place": false,
												"group": false,
												"article": false,
												"order": 1,
											};
											userData[0]["todo"].add(newTodoData);
										// });
										Navigator.pop(context,true);
									}, (data) { print("failure!"); },
									returndata: true,
									);
								}
							},
							padding: new EdgeInsets.all(14.0),  
							color: const Color(0xFF1033FF),
							textColor: const Color(0xFFFFFFFF),
							child: new Text(
								'Add Todo Item'.toUpperCase(),
								style: new TextStyle(
									fontWeight: FontWeight.w800,
								),
							),
						),
		
					],
				),
			),
		)
	);

}


/*
class addButton extends StatefulWidget {
	addButton();
	@override
	_addButtonState createState() => new _addButtonState();
}


class _addButtonState extends State<addButton> {

	_addButtonState();
	
	@override
	Widget build(BuildContext context) {

		final TextEditingController _todoController = new TextEditingController();
		final _todoFormKey = GlobalKey<FormState>();

		return new SliverPadding(
			padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
			sliver: new SliverGrid.count(
				crossAxisSpacing: 10.0,
				mainAxisSpacing: 10.0,
				crossAxisCount: 1,
				childAspectRatio: 4.0,
				children: <Widget>[
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
										onPressed: () => showDialog(
											context: context,
											child: new AlertDialog(
												contentPadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 30.0),
												content: new SingleChildScrollView(
													scrollDirection: Axis.vertical,
													child: new Column(
														mainAxisSize: MainAxisSize.min,
														children: [
															new Container(
																padding: new EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
																alignment: Alignment.topLeft,
																child: new Text(
																	'Add a new Todo Item'.toUpperCase(),
																	style: new TextStyle(
																		color: const Color(0xFF838383),
																		fontWeight: FontWeight.w800,
																		fontSize: 14.0,
																	),
																),
															),
															new Form(
																key: _todoFormKey,
																child: new Container(
																	padding: new EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
																	child: new TextFormField(
															        	controller: _todoController,
															        	validator: (value) {
																			if (value.isEmpty) return 'Please enter text for your todo item.';
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
																		maxLines: 3,
															        ),
																),
															),
															
															new RaisedButton(
																onPressed: () {
																	if (_todoFormKey.currentState.validate()) {
																		print(_todoController.text);
																		setThis("addtodo", { "name": _todoController.text }, (data){
																			// on success
																			print(data);
																			setState(() {
																				Map newTodoData = {
																					"name": _todoController.text,
																					"id" : data["id"],
																					"done": false,
																					"place": false,
																					"group": false,
																					"article": false,
																					"order": 1,
																				};
																				userData[0]["todo"].add(newTodoData);
																			});
																			Navigator.pop(context,true);
																		}, (data) { print("failure!"); },
																		returndata: true,
																		);
																	}
																},
																padding: new EdgeInsets.all(14.0),  
																color: const Color(0xFF1033FF),
																textColor: const Color(0xFFFFFFFF),
																child: new Text(
																	'Add Todo Item'.toUpperCase(),
																	style: new TextStyle(
																		fontWeight: FontWeight.w800,
																	),
																),
															),
											
														],
													),
												),
											)
										),
										icon: new Icon(
											Icons.add, 
											color: const Color(0xFFFFFFFF),
											size: 12.0,
										),
										label: new Text(
											'Add Item'.toUpperCase(),
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
				],
			),
		);

	}
	
}
*/


dynamic parseItems(list, context, { bookmarked = false, yourlist = false } ) {
	
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
						// childAspectRatio: 2.25,
						childAspectRatio: 2.0,
						// fix this nonsense ^
						children: <Widget>[
							placeCard(item["id"], item["name"], item["image"], item["rating"], item["distance"], context, bookmarked: bookmarked ),
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
								listGroupImage(item["id"], item["name"], item["items"], item["image"], context, sponsored: item["sponsor"], bookmarked: bookmarked ),
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
								discoverItem(item["id"], item["name"], item["image"], context, sponsored: item["sponsor"], bookmarked: bookmarked ),
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
							listGroup(item["id"], item["name"], item["items"], context, sponsored: item["sponsor"], bookmarked: bookmarked),
						],
					),
				)
			);
		} else {
			// if it's a todo
			_listItems.add(
				new SliverPadding(
					padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
					sliver: new SliverGrid.count(
						crossAxisSpacing: 10.0,
						mainAxisSpacing: 10.0,
						crossAxisCount: 1,
						childAspectRatio: 4.0,
						children: <Widget>[
							listTodo(item, context, bookmarked: bookmarked, yourlist: yourlist),	
						],
					),
				)
			);

		}
	}

	// if (yourlist == true) _listItems.add(addButton());
						
	// bottom padding
	_listItems.add(
		new SliverPadding(
			padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
		)
	);
	
	return _listItems;

}


class listScreen extends StatefulWidget {
	listScreen(this.list, this.context, this.yourlist);
	var list;
	var context;
	bool yourlist;
	@override
	_listScreenState createState() => new _listScreenState(this.list, this.context, this.yourlist);
}


class _listScreenState extends State<listScreen> {

	_listScreenState(this.list, this.context, this.yourlist);
	
	var list;
	var context;
	bool yourlist;
	
	@override
	Widget build(BuildContext context) {
		
		if (yourlist) {
						
			var current_todos = parseItems(userData[0]["todo"], context, yourlist: true);
			var completed_todos = parseItems(userData[0]["complete"], context, yourlist: true);
			
			current_todos.add(
				
				new SliverPadding(
					padding: const EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 0.0),
					sliver: new SliverGrid.count(
						crossAxisSpacing: 10.0,
						mainAxisSpacing: 10.0,
						crossAxisCount: 1,
						childAspectRatio: 8.0,
						children: <Widget>[
							new Text(
								'Completed'.toUpperCase(),
								textAlign: TextAlign.center,
								style: new TextStyle(
									color: const Color(0xFF000000),
									fontWeight: FontWeight.w800,
									fontSize: 28.0,
								),
							)
						],
					),
				)

			);
						
			var todos = new List<Widget>.from(current_todos)..addAll(completed_todos);
			
			todos.add(
				new SliverPadding(
					padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
				)
			);

			return new Scaffold(
				backgroundColor: const Color(0xFFF7F7F7),
				appBar: new AppBar(
					brightness: Brightness.light,
					backgroundColor: const Color(0x00FFFFFF),
					elevation: 0.0,
					centerTitle: true,
					title: Column(
						mainAxisAlignment: MainAxisAlignment.end,
						children: <Widget>[
							Image.asset("images/LogoSpan-Black.png", height: 12.0),
							Container(
								padding: const EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 5.0),
								child: Text(
									userData[0]["organization"]["nav_name"].toString().toUpperCase(),
									style: new TextStyle(
										color: const Color(0xFF838383),
										fontWeight: FontWeight.w300,
										fontSize: 16.0,
									),
								),
							),
						]
					),
					leading: IconButton(
						icon: new Icon(Icons.account_circle),
						// icon: new Icon(Icons.person_outline),
						color: const Color(0xFF838383),
						tooltip: 'Account',
						onPressed: () => Navigator.of(context).pushNamed('/account'),
						iconSize: 35.0,
						padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
					),
				),
				body: new CustomScrollView(
					slivers: todos,
				),
				floatingActionButton: new FloatingActionButton(
					child: new Icon(Icons.add),
					onPressed: () => addItem(context),
					backgroundColor: const Color(0xFF1033FF),
				),
			);
			
		} else {
			return new CustomScrollView(
				primary: false,
				slivers: parseItems(list, context),
			);
		}

	}

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
		
		return listScreen([], context, true);
		
		/*
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
							fontFamily: "Montserrat",
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
						listScreen([], context, true),
						listScreen(userData[0]["organization"]["popular"], context, false),
						listScreen(userData[0]["organization"]["discover_items"], context, false),
					],
				),
				bottomNavigationBar: bottomBar(context, 1),
			)
		);
		*/

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

	void getLocation() async {
		
		var location = new Loc();

		// Platform messages may fail, so we use a try/catch PlatformException.
		try {
			// final currentLocation = await location.getLocation;
			final currentLocation = location.getLocation();
			currentLocation.then((loc) {
				setThis(
					"location",
					{
						"latitude": loc["latitude"].toString(),
						"longitude": loc["longitude"].toString(),						
					},
					(){
						// success
					},
					(){
						// fail
						print("geolocation error");
					}
				);
			});
		} on PlatformException {
			print("geolocation platform error");
		}

    }

    @override
    void initState() {        
		getLocation();		
    }

	dynamic searchCategory(cat) {
		
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
									image: imgDefault(cat["image"], "misssaigon.jpg"),
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
				_discoverItems.add(new Container( width: 278.0, height: 278.0, margin: new EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 20.0), child: listGroupImage(item["id"], item["name"], item["items"], item["image"], context, sponsored: item["sponsor"], bookmarked: (item["bookmarked"] == null ? false : item["bookmarked"] ) ) ) );
			} else {
				_discoverItems.add(new Container( width: 278.0, height: 278.0, margin: new EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 20.0), child: discoverItem(item["id"], item["name"], item["image"], context, sponsored: item["sponsor"], bookmarked: (item["bookmarked"] == null ? false : item["bookmarked"] ) ) ) );
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

/*
Path _triangle(double size, Offset thumbCenter, {bool invert = false}) {
	final Path thumbPath = new Path();
	final double height = math.sqrt(3.0) / 2.0;
	final double halfSide = size / 2.0;
	final double centerHeight = size * height / 3.0;
	final double sign = invert ? -1.0 : 1.0;
	thumbPath.moveTo(thumbCenter.dx - halfSide, thumbCenter.dy + sign * centerHeight);
	thumbPath.lineTo(thumbCenter.dx, thumbCenter.dy - 2.0 * sign * centerHeight);
	thumbPath.lineTo(thumbCenter.dx + halfSide, thumbCenter.dy + sign * centerHeight);
	thumbPath.close();
	return thumbPath;
}
*/


class RoundSliderThumbShape extends SliderComponentShape {
  /// Create a slider thumb that draws a circle.
  const RoundSliderThumbShape();

  static const double _thumbRadius = 18.0;
  static const double _disabledThumbRadius = 16.0;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return new Size.fromRadius(isEnabled ? _thumbRadius : _disabledThumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset thumbCenter, {
    Animation<double> activationAnimation,
    Animation<double> enableAnimation,
    bool isDiscrete,
    TextPainter labelPainter,
    RenderBox parentBox,
    SliderThemeData sliderTheme,
    TextDirection textDirection,
    double value,
  }) {
    final Canvas canvas = context.canvas;
    final Tween<double> radiusTween = new Tween<double>(
      begin: _disabledThumbRadius,
      end: _thumbRadius,
    );
    final Tween<double> radiusTweenTwo = new Tween<double>(
      begin: _disabledThumbRadius,
      end: _thumbRadius + 3,
    );
    final ColorTween colorTween = new ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    );
    final ColorTween colorTweenTwo = new ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.activeTrackColor,
    );
    canvas.drawCircle(
      thumbCenter,
      radiusTweenTwo.evaluate(enableAnimation),
      new Paint()..color = colorTweenTwo.evaluate(enableAnimation),
    );
    canvas.drawCircle(
      thumbCenter,
      radiusTween.evaluate(enableAnimation),
      new Paint()..color = colorTween.evaluate(enableAnimation),
    );
    // new Icon(Icons.star, color: sliderTheme.thumbColor, size: 30.0);
    // print(value);
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

	var cat;
	List<Widget> _widgetList = [];
	double _distance = 8.0;
	
	@override
	Widget build(BuildContext context) {
		
		cat["distance"] = _distance.round();

		void toggleTag(tagnum) {
			setState(() {
				if (cat["tags"][tagnum]["selected"] != true) {
					cat["tags"][tagnum]["selected"] = true;
				} else {
					cat["tags"][tagnum]["selected"] = null;
				}
			});		
		}
		
		dynamic tagCard(tag, selected, tagnum) {
			
			var tagColor;
			
			if (selected) {
				tagColor = const Color(0xFFE3F5FF);
			} else {
				tagColor = const Color(0xFFFFFFFF);
			}

			return new GestureDetector(
				onTap: () => toggleTag(tagnum),
				child: new Card(
					elevation: 3.0,
					child: new Container(
						color: tagColor,
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
				)
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
			body: SafeArea(
				child: new Column(
					mainAxisSize: MainAxisSize.min,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: <Widget>[
						Container(
							padding: const EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 2.0),
							child: Text(
								'Distance'.toUpperCase(),
								textAlign: TextAlign.left,
								style: new TextStyle(
									color: const Color(0xFF000000),
									fontWeight: FontWeight.w800,
									fontSize: 28.0,
								),
							),
						),
						Container(
							padding: const EdgeInsets.fromLTRB(20.0, 0.0, 10.0, 0.0),
							child: Text(
								'Average distance in miles',
								textAlign: TextAlign.left,
								style: new TextStyle(
									color: const Color(0xFF000000),
									fontWeight: FontWeight.w300,
									fontSize: 14.0,
								),
							),
						),
						Container(
							padding: const EdgeInsets.fromLTRB(20.0, 55.0, 20.0, 10.0),
							child: Stack(
								fit: StackFit.loose,
								children: [
									SliderTheme(
										data: SliderThemeData(
											activeTrackColor: const Color(0xFF1033FF),
											inactiveTrackColor: const Color(0x66E0E1EA),
											disabledActiveTrackColor: const Color(0xFF000000),
											disabledInactiveTrackColor: const Color(0xFF000000),
											activeTickMarkColor: const Color(0xFFFFFFFF),
											inactiveTickMarkColor: const Color(0xFFFFFFFF),
											disabledActiveTickMarkColor: const Color(0xFFFFFFFF),
											disabledInactiveTickMarkColor: const Color(0xFF000000),
											thumbColor: const Color(0xFFFFFFFF),
											disabledThumbColor: const Color(0xFF000000),
											overlayColor: const Color(0x66E0E1EA),
											valueIndicatorColor: const Color(0x66E0E1EA),
											showValueIndicator: ShowValueIndicator.always,
											thumbShape: RoundSliderThumbShape(),
											valueIndicatorShape: PaddleSliderValueIndicatorShape(),
											valueIndicatorTextStyle: TextStyle(
												color: const Color(0xFF000000),
												fontWeight: FontWeight.w800,
												fontSize: 14.0,
											),
										),
										
										child: Slider(
											divisions: 2,
											max: 8.0,
											min: 2.0,
											label: "Within " + _distance.round().toString() + " miles",
											value: _distance.toDouble(),
											onChanged: (double newValue) {
												setState(() {
													_distance = newValue;
													cat["distance"] = _distance.round();
												});
											},
										),
										
									),
									IgnorePointer(
										child: Container(
											padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
											child: Row(
												children: [
													new CircleAvatar(
														backgroundColor: const Color(0xFFFFFFFF),
														maxRadius: 16.0,
														child: Icon(
															Icons.directions_run,
															color: const Color(0xFF838383),
														),
													),
													Expanded(
														child: new CircleAvatar(
															backgroundColor: const Color(0xFFFFFFFF),
															maxRadius: 16.0,
															child: Icon(
																Icons.directions_bike,
																color: const Color(0xFF838383),
															),
														),
													),
													new CircleAvatar(
														backgroundColor: const Color(0xFFFFFFFF),
														maxRadius: 16.0,
														child: Icon(
															Icons.directions_car,
															color: const Color(0xFF838383),
														),
													),
												],
											),
										),
									),
									
									
								]
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
								new Expanded( child: ( cat["tags"].length > 0 ? tagCard( cat["tags"][0], ( cat["tags"][0]["selected"] != null ), 0 ) : new Container() ) ),
								new Container( width: 20.0 ),
								new Expanded( child: ( cat["tags"].length > 1 ? tagCard( cat["tags"][1], ( cat["tags"][1]["selected"] != null ), 1 ) : new Container() ) ),
								new Container( width: 20.0 ),
							]
						),
						new Container( height: 20.0 ),
						new Row(
							children: <Widget>[
								new Container( width: 20.0 ),
								new Expanded( child: ( cat["tags"].length > 2 ? tagCard( cat["tags"][2], ( cat["tags"][2]["selected"] != null ), 2 ) : new Container() ) ),
								new Container( width: 20.0 ),
								new Expanded( child: ( cat["tags"].length > 3 ? tagCard( cat["tags"][3], ( cat["tags"][3]["selected"] != null ), 3 ) : new Container() ) ),
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
			),
		);

	}
	
}


dynamic placeCard(id, txt, img, stars, distance, context, { featured = false, bookmarked = false }) {
	
	// calculate stars
	List<Widget> _starsList = [ new SizedBox( width: 20.0 ) ];
	if (stars == null) stars = 0;
	for (var i = 0; i < stars.round(); i++) _starsList.add( new Expanded(child:new Icon(Icons.star, color: const Color(0xFF1033FF), size: 30.0)) );
	for (var i = 0; i < 5-stars.round(); i++) _starsList.add( new Expanded(child:new Icon(Icons.star_border, color: const Color(0xFF838383), size: 30.0)) );
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
														child: ( distance != null ?
															new Text(
																distance.toString() + ' mi',
																textAlign: TextAlign.left,
																style: new TextStyle(
																	color: const Color(0xFF000000),
																	fontWeight: FontWeight.w300,
																	fontSize: 14.0,
																),
															)
															:
															new Container()
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
										image: imgDefault(img, "misssaigon.jpg"),
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


dynamic getPlacesData(filters) async {
	
	// get stored token
	final prefs = await SharedPreferences.getInstance();
	final String token = prefs.getString('token') ?? null;
		
	List tags = [];
	
	// parse tags to filter on	
	for (var tag in filters["category"]["tags"] ) {
		if (tag["selected"] != null && tag["selected"] == true ) {
			tags.add(tag["id"]);	
		}
	}
	
	// build querystring
	final String qs = '?metro=' + userData[0]["organization"]["metro"]["id"].toString() + '&category=' + filters["category"]["id"].toString() + '&maxdistance=' + filters["category"]["distance"].toString() + '&tags=' + tags.join(',');
	
	final response = await http.get(
		domain + 'api/place/' + qs,
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
							
							if (_placeList.length == 0) {
								// if no places returned for this search
								_placeList.add(
									new Container(
										alignment: Alignment.center,
										padding: const EdgeInsets.fromLTRB(20.0, 80.0, 20.0, 10.0),
										child: new Text(
											'No Results Found'.toUpperCase(),
											style: new TextStyle( fontWeight: FontWeight.w800 ),
										)
									)
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
									padding: const EdgeInsets.fromLTRB(20.0, 80.0, 20.0, 10.0),
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


void setThis(settype, body, success, fail, { returndata = false }) async {

	// get stored token
	final prefs = await SharedPreferences.getInstance();
	final String token = prefs.getString('token') ?? null;
	final String qs = settype + "/";
	
	print(qs);
	print(body);

	final response = await http.post(
		domain + 'api/' + qs,
		headers: {
			HttpHeaders.AUTHORIZATION: "JWT " + token
		},
		body: body
	);
	
	if (response.statusCode == 200) {
		// If server returns an OK response
		if (json.decode(response.body)["success"]) {
			if (returndata){
				success(json.decode(response.body));
			} else {
			success();
			}
		} else {
			if (returndata){
				fail(json.decode(response.body));
			} else {
				fail();
			}
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
	var groupData;

    @override
    void initState() {        
        // We can't mark this method as async because of the @override
        getItemData('group', id).then((result) {
            // If we need to rebuild the widget with the resulting data, make sure to use `setState`
            setState(() {
                groupData = result;
            });
        });
    }

	@override
	Widget build(BuildContext context) {

        if (groupData == null) {
            // This is what we show while we're loading
			return Scaffold(
				body: Container(
					alignment: Alignment.center,
					child: new CircularProgressIndicator(),
				)
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
						image: imgDefault(groupData["image"], "cardphoto.png"),
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
							groupData["name"].toUpperCase(),
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
		
		_widgetList.addAll(parseItems(groupData["items"], context));

		return new Scaffold(
			backgroundColor: const Color(0xFFF3F3F7),
			body: new CustomScrollView(
				primary: false,
				slivers: _widgetList,
			),
			persistentFooterButtons: <Widget>[
				( groupData["done"] != true && groupData["todo"] == true ?
					new FlatButton(
						onPressed: () => setThis("adddone", { "id": groupData["id"].toString() }, (){
							// update icon on success
							setState(() {
								groupData["done"] = true;
								// remove item from todo list
								userData[0]["todo"].removeWhere((i) => i["id"] == groupData["id"]);
							});
						}, () { print("failure!"); }),
						child: new Icon(
							Icons.check_circle_outline,
							color: const Color(0xFF2D2D2F),
						),
					)
					: new FlatButton()
				),
				( groupData["todo"] == true && groupData["done"] != true ?
					new FlatButton(
						onPressed: () => setThis("removelist", { "id": groupData["id"].toString() }, (){
							// update icon on success
							setState(() {
								groupData["todo"] = false;
								// remove item from todo list
								userData[0]["todo"].removeWhere((i) => i["id"] == groupData["id"]);
							});
						}, () { print("failure!"); }),
						child: new Icon(
							Icons.delete_outline,
							color: const Color(0xFF2D2D2F),
						),
					) :
					new FlatButton(
						onPressed: () => setThis("addlist", { "id": groupData["id"].toString() }, (){
							// update icon on success
							setState(() {
								groupData["todo"] = true;
								groupData["done"] = false;
								// add group to todo list
								Map newGroupData = json.decode(json.encode(groupData));
								newGroupData["items"] = groupData["items"].length;
								newGroupData["order"] = 1;
								userData[0]["todo"].add(newGroupData);
							});
						}, () { print("failure!"); }),
						child: new Icon(
							Icons.add_circle_outline,
							color: const Color(0xFF2D2D2F),
						),
					)
				),
				( groupData["bookmarked"] == true ?
					new FlatButton(
						onPressed: () => setThis("removebookmark", { "id": groupData["id"].toString() }, (){
							// update icon on success
							setState(() {
								groupData["bookmarked"] = false;
								// remove item from bookmarks list
								userData[0]["bookmarks"].removeWhere((i) => i["id"] == groupData["id"]);
							});
						}, () { print("failure!"); }),
						child: new Icon(
							Icons.bookmark,
							color: const Color(0xFF2D2D2F),
						),
					) :
					new FlatButton(
						onPressed: () => setThis("addbookmark", { "id": groupData["id"].toString() }, (){
							// update icon on success
							setState(() {
								groupData["bookmarked"] = true;
								// add group to bookmarks list
								Map newGroupData = json.decode(json.encode(groupData));
								newGroupData["items"] = groupData["items"].length;
								newGroupData["order"] = 1;
								userData[0]["bookmarks"].add(newGroupData);
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
			return Scaffold(
				body: Container(
					alignment: Alignment.center,
					child: new CircularProgressIndicator(),
				)
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
			( articleData["sponsor"] != null && articleData["sponsor"] != "" ?
				new Row(
					children: [
						new Container(
							padding: new EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
							child: new Text(
								articleData["sponsor"].toUpperCase(),
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
									onPressed: () {
										if (cta["link"] != null && cta["link"] != "") {
											Navigator.push(
												context,
												new MaterialPageRoute(
													builder: (BuildContext context) => new WebviewScaffold(
														url: cta["link"],
														appBar: new AppBar(
															title: new Text(
																cta["name"].toUpperCase(),
																overflow: TextOverflow.fade,
																style: new TextStyle(
																	fontWeight: FontWeight.w800,
																	fontSize: 14.0,
																	height: 0.9,
																),
															),
														),
													),
												)
											);
										} else {
											// no link - should just close or also complete?
											Navigator.pop(context,true);
										}
									},
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
				( articleData["done"] != true && articleData["todo"] == true ?
					new FlatButton(
						onPressed: () => setThis("adddone", { "id": articleData["id"].toString() }, (){
							// update icon on success
							setState(() {
								articleData["done"] = true;
								// remove item from todo list
								userData[0]["todo"].removeWhere((i) => i["id"] == articleData["id"]);
							});
						}, () { print("failure!"); }),
						child: new Icon(
							Icons.check_circle_outline,
							color: const Color(0xFF2D2D2F),
						),
					)
					: new FlatButton()
				),
				( articleData["todo"] == true && articleData["done"] != true ?
					new FlatButton(
						onPressed: () => setThis("removelist", { "id": articleData["id"].toString() }, (){
							// update icon on success
							setState(() {
								articleData["todo"] = false;
								// remove article from todo list
								userData[0]["todo"].removeWhere((i) => i["id"] == articleData["id"]);
							});
						}, () { print("failure!"); }),
						child: new Icon(
							Icons.delete_outline,
							color: const Color(0xFF2D2D2F),
						),
					) :
					new FlatButton(
						onPressed: () => setThis("addlist", { "id": articleData["id"].toString() }, (){
							// update icon on success
							setState(() {
								articleData["todo"] = true;
								articleData["done"] = false;
								// add article to todo list
								Map newArticleData = json.decode(json.encode(articleData));
								newArticleData["order"] = 1;
								userData[0]["todo"].add(newArticleData);
							});
						}, () { print("failure!"); }),
						child: new Icon(
							Icons.add_circle_outline,
							color: const Color(0xFF2D2D2F),
						),
					)
				),
				( articleData["bookmarked"] == true ?
					new FlatButton(
						onPressed: () => setThis("removebookmark", { "id": articleData["id"].toString() }, (){
							// update icon on success
							setState(() {
								articleData["bookmarked"] = false;
								// remove item from bookmarks list
								userData[0]["bookmarks"].removeWhere((i) => i["id"] == articleData["id"]);
							});
						}, () { print("failure!"); }),
						child: new Icon(
							Icons.bookmark,
							color: const Color(0xFF2D2D2F),
						),
					) :
					new FlatButton(
						onPressed: () => setThis("addbookmark", { "id": articleData["id"].toString() }, (){
							// update icon on success
							setState(() {
								articleData["bookmarked"] = true;
								// add article to bookmarks list
								Map newArticleData = json.decode(json.encode(articleData));
								newArticleData["order"] = 1;
								userData[0]["bookmarks"].add(newArticleData);
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
	double stars = 0.0;
	int yourstars = 0;

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
    
    void setStars(stars) {
	    setThis(
	    	"addrating",
	    	{
	    		"id": placeData["id"].toString(),
	    		"rating": stars.toString(),
	    	},
	    	(){
				// update stars on success
				setState(() {
					placeData["yourrating"] = stars;
				});
				print("success");
			}, () { print("failure!"); },
		);
    }

	@override
	Widget build(BuildContext context) {
		
        if (placeData == null) {
            // This is what we show while we're loading
			return Scaffold(
				body: Container(
					alignment: Alignment.center,
					child: new CircularProgressIndicator(),
				)
			);
        }

		// calculate stars for average rating
		if (placeData["rating"] != null) stars = placeData["rating"];
		
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
		
		for (var i = 0; i < stars.round(); i++) _starsList.add( new Expanded(child:new Icon(Icons.star, color: const Color(0xFF1033FF), size: 20.0)) );
		for (var i = 0; i < 5-stars.round(); i++) _starsList.add( new Expanded(child:new Icon(Icons.star_border, color: const Color(0xFF838383), size: 20.0)) );

		// calculate stars for your rating
		if (placeData["yourrating"] != null) yourstars = placeData["yourrating"];
		
		List<Widget> _yourstarsList = [ 
			new SizedBox( width: 30.0 ),
		];

		for (var i = 0; i < yourstars; i++) _yourstarsList.add(
			new Expanded(
				child: new GestureDetector(
					onTap: () => setStars(i+1),
					child: new Icon(Icons.star, color: const Color(0xFF1033FF), size: 50.0),
				),
			)
		);

		for (var i = 0; i < 5-yourstars; i++) _yourstarsList.add(
			new Expanded(
				child: new GestureDetector(
					onTap: () => setStars(i+1+yourstars),
					child: new Icon(Icons.star_border, color: const Color(0xFF838383), size: 50.0),
				),
			)
		);
		
		_yourstarsList.add( new SizedBox( width: 30.0 ) );
		
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
									image: imgDefault(placeData["image"], "misssaigon.jpg"),
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
																fontSize: 14.0,
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
										placeData["openhours"],
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
									( stars == 0 ?
										new SizedBox( height: 0.0 )
									:
										new Row( children: _starsList )
									),
									new Container(
										padding: new EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 10.0),
										child: new Row(
											children: _yourstarsList,
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
						onPressed: () => setThis("removebookmark", { "id": placeData["id"].toString() }, (){
							// update icon on success
							setState(() {
								placeData["bookmarked"] = false;
								// remove place from bookmarks list
								userData[0]["bookmarks"].removeWhere((i) => i["id"] == placeData["id"]);
							});
						}, () { print("failure!"); }),
						child: new Icon(
							Icons.bookmark,
							color: const Color(0xFF2D2D2F),
						),
					) :
					new FlatButton(
						onPressed: () => setThis("addbookmark", { "id": placeData["id"].toString() }, (){
							// update icon on success
							setState(() {
								placeData["bookmarked"] = true;
								// add place to bookmarks list
								Map newPlaceData = json.decode(json.encode(placeData));
								newPlaceData["order"] = 1;
								newPlaceData["place"] = true;
								newPlaceData["group"] = false;
								newPlaceData["article"] = false;
								userData[0]["bookmarks"].add(newPlaceData);
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
	  
		if ( userData[0]["organization"]["link"] == null ) {
			return new Scaffold(
				body: new Container(),
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
				bottomNavigationBar: bottomBar(context, 4),
			);
		} else {
			return new WebviewScaffold(
				url: userData[0]["organization"]["link"],
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
				bottomNavigationBar: bottomBar(context, 4),
			);
		}

	}
	
}


class NoInternet extends StatefulWidget {
	NoInternet();
	@override
	_NoInternetState createState() => new _NoInternetState();
}


class _NoInternetState extends State<NoInternet> {

	@override
	Widget build(BuildContext context) {
		return new Scaffold(
			body: new Container(
				alignment: Alignment.center,
				child: new Column(
					children: [
						new Expanded(child: new Container()),
						new Text(
							"No Internet Connection",
							style: new TextStyle(
								color: const Color(0xFF000000),
								fontWeight: FontWeight.w800,
								fontSize: 18.0,
								height: 2.0,
							),
						),
						new Text(
							"Please connect to the internet to use NewTo",
							style: new TextStyle(
								color: const Color(0xFF838383),
								fontWeight: FontWeight.w400,
								fontSize: 14.0,	
							),
						),
						new SizedBox(height: 20.0),
						new RaisedButton(
							onPressed: () {
								new Connectivity().checkConnectivity().then((result) {
									if (result != ConnectivityResult.none) {
										if (userData == null) {
											initData(context);
										} else {
											Navigator.popUntil(context, (route) {
												if (route.settings.name == "/" || route.settings.name == "/nointernet") initData(context);
												return true;
											});
										}
									}
								});
							},
							padding: new EdgeInsets.all(14.0),  
							color: const Color(0xFF1033FF),
							textColor: const Color(0xFFFFFFFF),
							child: new Text(
								'RETRY',
								style: new TextStyle(
									fontWeight: FontWeight.w800,
								),
							),
						),
						new Expanded(child: new Container()),
					]
				),
			),
		);

	}
	
}
