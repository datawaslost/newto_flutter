import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/services.dart';

import 'main.dart' show imgDefault, setThis, userData;



class swipeCards extends StatefulWidget {
	swipeCards(this.cardsData);
	var cardsData;
	@override
	swipeCardsState createState() => new swipeCardsState(this.cardsData);
}

class swipeCardsState extends State<swipeCards> with TickerProviderStateMixin {

	swipeCardsState(this.cardsData);
	
	List data;
	var cardsData;
	AnimationController _scaleController;
	AnimationController _posController;
	
	void initState() {

		super.initState();
		_scaleController = AnimationController(vsync:this, duration: Duration(milliseconds: 400));
		_posController = AnimationController(vsync:this, duration: Duration(milliseconds: 400));

		print(cardsData);
		
	}

	dismissItem(item) {
		// (() {
			data.remove(item);
		// });
	}

	addItem(item) {
		// setState(() {
			// send to back of stack
			data.remove(item);
			data.insert(data.length,item);
		// });
	}

	@override
	Widget build(BuildContext context) {
	  
		data = cardsData;
    
		// limit how many are shown
		int limit = 3;
		if (data.length < 3) limit = data.length;
		List limiteddata = data.reversed.toList().sublist(data.length-limit, data.length);
		
		var dataLength = limiteddata.length;
		timeDilation = 0.4;
		double backCardPosition = 0.0;
		double backCardWidth = 80.0;
		double scale = 1.0;
		int counter = 1;

	    return ( Container(
			alignment: Alignment.bottomCenter,
			child: dataLength > 0
				? Stack(
					alignment: AlignmentDirectional.center,
					children: limiteddata.map((item) {
						
						counter += 1;
	 					backCardPosition = (dataLength-counter) * 45.0;
						scale = (10.0 - ((dataLength-counter)*1.5) ) / 10.0;
	
						return swipeCard(
							item,
							backCardPosition,
							backCardWidth,
							context,
							dismissItem,
							addItem,
							_scaleController,
							_posController,
							scale
						);
	
					}).toList())
				: Text("No Event Left", style: TextStyle(color: Colors.black, fontSize: 50.0)),
	        )
	    );
	}
	
}


class swipeCard extends StatefulWidget {
	
	swipeCard(
	    this.item,
	    this.bottom,
	    this.cardMargin,
	    this.context,
	    this.dismissItem,
	    this.addItem,
	    this._scaleController,
	    this._posController,
	    this.scale
	);
	
	var item;
    double bottom;
    double cardMargin;
    BuildContext context;
    Function dismissItem;
    Function addItem;
    AnimationController _scaleController;
    AnimationController _posController;
    double scale;

	@override
	swipeCardState createState() => new swipeCardState(
		this.item,
	    this.bottom,
	    this.cardMargin,
	    this.context,
	    this.dismissItem,
	    this.addItem,
	    this._scaleController,
	    this._posController,
	    this.scale
	);
	
}


class swipeCardState extends State<swipeCard> {

	swipeCardState(
		this.item,
	    this.bottom,
	    this.cardMargin,
	    this.context,
	    this.dismissItem,
	    this.addItem,
	    this._scaleController,
	    this._posController,
	    this.scale
	);

	var item;
    double bottom;
    double cardMargin;
    BuildContext context;
    Function dismissItem;
    Function addItem;
    AnimationController _scaleController;
    AnimationController _posController;
    double scale;

	@override
	Widget build(BuildContext context) {

		Size screenSize = MediaQuery.of(context).size;
		
		_scaleController.reset();
		_scaleController.forward();
	
		_posController.reset();
		_posController.forward();
	
		Animation<Offset> posAnimation = Tween<Offset>(
			begin: Offset( 0.0, bottom / 500.0 ),
			end: Offset( 0.0, bottom / 500.0 - 0.05 )
		).animate(
			CurvedAnimation(
				parent: _posController,
				curve: Curves.ease,
			),
		);
		
		Animation<double> scaleAnimation = Tween<double>(
			begin: scale - .1,
			end: scale,
		).animate(
			CurvedAnimation(
				parent: _scaleController,
				curve: Curves.ease,
			),
		);
	    
	    return /*SlideTransition(
		    position: posAnimation,
		    child: ScaleTransition(
				scale: scaleAnimation,
				child:*/ Dismissible(
					key: Key("frontcard"+Random().nextInt(1000000).toString()),
					crossAxisEndOffset: -0.3,
					onDismissed: (DismissDirection direction) {
						// if (direction == DismissDirection.endToStart)
						addItem(item);
					},
					child: Hero(
		            	tag: "img"+Random().nextInt(1000000).toString(),
						child: GestureDetector(
							onTap: () => {
				                // Navigator.of(context).push(new PageRouteBuilder( pageBuilder: (_, __, ___) => new DetailPage(type: img) ));
							},
			                child: Container(
								alignment: Alignment.center,
								width: screenSize.width - cardMargin,
								height: screenSize.height * .65,
								decoration: BoxDecoration(
				                    color: const Color(0xFF023cf5),
				                    borderRadius: new BorderRadius.circular(20.0),
									image: (item["group"] == true || item["article"] == true)
										? DecorationImage( image: imgDefault(item["image"], "misssaigon.jpg"), fit: BoxFit.cover )
										: null,
				                    boxShadow: [new BoxShadow(
										color: const Color(0x66000000),
										blurRadius: 10.0,
										offset: Offset(0.0, 5.0),
									),]
								),
								child: Column(
				                    children: <Widget>[
					                    ( item["tags"].length > 0)
					                    ? Container(
											padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 20.0),
						                    child: Container(
												padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
												alignment: Alignment.topLeft,
												child: Text(												
													item["tags"].map((fruit) => fruit['name']).join("   |   ").toString().toUpperCase(), 
													style: TextStyle(
														fontFamily: "Montserrat",
														fontWeight: FontWeight.w800,
														color: Colors.white, 
														fontSize: 11.0,
													)
												),
												decoration: BoxDecoration(
													border: Border(
														bottom: BorderSide(color: Colors.white, style: BorderStyle.solid,  width: 2.0),
													),
												),
											),
										)
										: Container(
											// empty container for spacing
											padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
										),
										// if this is a group or article, then show discover / sponsored tags
										(item["group"] == true || item["article"] == true)
					                    ? Container(
											padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
						                    child: Row(
												mainAxisAlignment: MainAxisAlignment.start,
												children: <Widget>[
													(item["sponsor"] != "")
													? tagPill(item["sponsor"], color: Color(0xFF6d6ef6))
													: tagPill("Discover", color: Color(0xFF70f1b2)),
													(item["group"] == true )
													? tagPill(item["items"].toString(), icon: Icons.filter_none )
													: Container(),												
												]
											),
										)
										: Container(
											// empty container for spacing
											padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
										),
						                Expanded(
											child: Container(
												padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
												alignment: Alignment.center,
												child: Text(
													item["name"], 
													style: TextStyle(
														fontFamily: "Montserrat",
														fontWeight: FontWeight.w700,
														color: Colors.white, 
														fontSize: 45.0,
														height: 0.85
													)
												),
											),
										),
										(item["group"] != true && item["article"] != true)
										? Container(
											padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 15.0),
											alignment: Alignment.bottomCenter,
											child: new Row(
												mainAxisAlignment: MainAxisAlignment.spaceBetween,
												children: <Widget>[
													Container(
														width: 50.0,
														height: 50.0,
														decoration: new BoxDecoration(
															shape: BoxShape.circle,
															color: const Color(0xFFFFFFFF),
															boxShadow: [
																BoxShadow(
																	color: const Color(0x66000000),
																	blurRadius: 8.0,
																),
															]
														),
														child: Icon( Icons.check, size: 25.0, color: const Color(0xFF023cf5) ),
													),
											        Container(
														width: 50.0,
														height: 50.0,
														decoration: new BoxDecoration(
															shape: BoxShape.circle,
															color: const Color(0xFFFFFFFF),
															boxShadow: [
																BoxShadow(
													            	color: const Color(0x66000000),
																	blurRadius: 8.0,
																),
															]
														),
														child: Icon( Icons.add, size: 25.0, color: const Color(0xFF023cf5) ),
													),
												],
											)
										)
										: // if it's an article or a group, just offer the ability to bookmark
										Container(
											padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 15.0),
											alignment: Alignment.bottomRight,
											child: (item["bookmarked"] == true)
											? // if item is already bookmarked
											GestureDetector(
												onTap: () => setThis("removebookmark", { "id": item["id"].toString() }, (){
													// update icon and close details on success
													// /*
													// setState(() {
														item["bookmarked"] = false;
														// set bookmarked to false in the user data so that it's persistent until the data refreshes
														int index = userData[0]["bookmarks"].indexWhere((i) => i["id"] == item["id"]);
														if (index != -1) userData[0]["bookmarks"][index]["bookmarked"] = false;
													// });	
													// */
												}, () { print("failure!"); }),
												child: Container(
													width: 50.0,
													height: 50.0,
													decoration: new BoxDecoration(
														shape: BoxShape.circle,
														color: const Color(0xFFFF023cf5),
														boxShadow: [
															BoxShadow(
												            	color: const Color(0x66000000),
																blurRadius: 8.0,
															),
														]
													),
													child: Icon( Icons.bookmark_border, size: 25.0, color: const Color(0xFFFFFFFF) ),
												),
											)
											: // If item isn't bookmarked
											GestureDetector(
												onTap: () => setThis("addbookmark", { "id": item["id"].toString() }, (){
													// update icon and close details on success
													// /*
													// setState(() {
														item["bookmarked"] = true;
													// });	
													// */
												}, () { print("failure!"); }),
												child: Container(
													width: 50.0,
													height: 50.0,
													decoration: new BoxDecoration(
														shape: BoxShape.circle,
														color: const Color(0xFFFFFFFF),
														boxShadow: [
															BoxShadow(
												            	color: const Color(0x66000000),
																blurRadius: 8.0,
															),
														]
													),
													child: Icon( Icons.bookmark_border, size: 25.0, color: const Color(0xFF023cf5) ),
												),
											)
	
										)
										
										
										/*
										if ( item["bookmarked"] == true && item["bookmarked"] != null) {
											// if item is in our bookmarks
											mainButton = GestureDetector(
												child: todoButton(Icons.bookmark, size: 35.0, color: const Color(0xFF013CF5), selected: true ),
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
												child: todoButton(Icons.bookmark_border, size: 35.0, color: const Color(0xFFA7A7A7) ),
												// add bookmark
												onTap: () => setThis("addbookmark", { "id": item["id"].toString() }, (){
													setState(() {
														item["bookmarked"] = true;
													});	
												}, () { print("failure!"); }),
											);
										}
										*/
									
									],
								),
							),
						),
					),
				// ),
			// ),
		);
	}
}



dynamic tagPill(txt, { Color color, double opacity, icon }) {
	
	// default opacity and color
	if (color != null) {
		if (opacity == null) opacity = 1.0;
	} else {
		color = const Color(0xFFFFFFFF);
		if (opacity == null) opacity = 0.5;
	}
	
	return Container(
		padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
		margin: EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
		decoration: BoxDecoration(
			color: color.withOpacity(opacity),
			borderRadius: BorderRadius.all(Radius.circular(10.0)),
		),
		child: Row(
		  	children: [
			  	(icon != null)
			  	? Container(
			  		padding: (txt != "")
			  			? EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0)
			  			: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
			  		child: Icon( icon, size: 11.0, color: const Color(0xFFFFFFFF) ), 
			  	)
			  	: Container(),
			  	(txt != "")
			  	? Text(
					txt.toUpperCase(),
					textAlign: TextAlign.left,
					style: TextStyle(
						color: const Color(0xFFFFFFFF),
						fontWeight: FontWeight.w500,
						fontSize: 11.0,
						height: 1,
					)
				)
			  	: Container(),
			]
		),
	);

}
