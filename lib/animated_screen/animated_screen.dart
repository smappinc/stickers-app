import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mediation_test/mediation_test.dart';
import 'package:web_app/home/home.dart';
import 'package:web_app/util/constants.dart';
import 'package:web_app/util/my_fab.dart';
import 'package:admob_flutter/admob_flutter.dart';

class AnimatedScreen extends StatefulWidget {
  @override
  _AnimatedScreenState createState() => _AnimatedScreenState();
}

class _AnimatedScreenState extends State<AnimatedScreen> {
  List stickers = new List<Map>();
  bool isLoading = true;
  String _outputText = '';

  @override
  void initState() {
    // Set the flag as true
    super.initState();
    getAllAnimatedStickers();
  }

  Future<void> getAllAnimatedStickers() async {
    String url = "https://smappinc.github.io/data/animated-stickerapi.json";
    var response = await get(url);
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      stickers = jsonDecode(response.body);
    } else {
      Constants.showDialog('Cannot connect to server');
    }
    setState(() {
      isLoading = false;
    });
  }

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        print('New Admob $adType Ad loaded!');
        break;
      case AdmobAdEvent.opened:
        print('Admob $adType Ad opened!');
        break;
      case AdmobAdEvent.closed:
        print('Admob $adType Ad closed!');
        break;
      case AdmobAdEvent.failedToLoad:
        print('Admob $adType failed to load. :(');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text(
          "Animated",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [],
      ),
      drawer: homeDrawer(),
      body: Container(
          margin: EdgeInsets.symmetric(vertical: 5.0),
          child: (isLoading)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: stickers.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return stickerCell(stickers[index]);
                  })),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: MyFab(),
      ),
      bottomNavigationBar: Container(
        height: 90,
        width: MediaQuery.of(context).size.width,
        color: Colors.black,
        child: AdmobBanner(
            adUnitId: 'ca-app-pub-6991932537186982/8366317248',
            adSize: AdmobBannerSize.ADAPTIVE_BANNER(
                width: MediaQuery.of(context)
                    .size
                    .width
                    .toInt()), // width: MediaQuery.of(context)
            listener: (AdmobAdEvent event, Map<String, dynamic> args) {
              switch (event) {
                case AdmobAdEvent.loaded:
                  print('Admob banner loaded!');
                  break;

                case AdmobAdEvent.opened:
                  print('Admob banner opened!');
                  break;

                case AdmobAdEvent.closed:
                  print('Admob banner closed!');
                  break;

                case AdmobAdEvent.failedToLoad:
                  print(
                      'Admob banner failed to load. Error code: ${args['errorCode']}');
                  break;
              }
            }),
      ),
    );
  }

  Widget stickerCell(Map sticker) {
    return GestureDetector(
      child: Container(
          height: 170,
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.only(top: 15, left: 15, right: 15),
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 100,
                margin: EdgeInsets.only(left: 20, right: 20),
                //color: Colors.red,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        width: 60,
                        height: 60,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: CachedNetworkImage(
                              imageUrl: sticker['imageurl'], fit: BoxFit.cover),
                        )),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          sticker['name'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                width: double.infinity,
                padding:
                    EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue[900],
                ),
                child: Center(
                    child: Text(
                  'Add Sticker Pack to Signal',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )),
              ),
            ],
          )),
      onTap: () async {
        MediationTest.presentTestSuite();
      },
    );
  }

  Widget homeDrawer() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("Signal Meme Stickers"),
            accountEmail: Text("pssst....drink some water"),
            currentAccountPicture: Container(
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: Icon(Icons.sentiment_very_satisfied,
                  size: 70, color: Colors.white),
            ),
            decoration: BoxDecoration(
              color: Colors.blue[900],
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: Colors.white,
              size: 30.0,
            ),
            title: Text(
              'Home',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (Route<dynamic> route) => false,
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.sentiment_satisfied_alt_sharp,
              color: Colors.white,
              size: 30.0,
            ),
            title: Text(
              'Animated Stickers',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
