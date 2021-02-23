import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class MyFab extends StatefulWidget {
  MyFab();

  @override
  MyFabState createState() => MyFabState();
}

class MyFabState extends State<MyFab> with TickerProviderStateMixin {
  ScrollController scrollController;
  bool dialVisible = true;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController()
      ..addListener(() {
        setDialVisible(scrollController.position.userScrollDirection ==
            ScrollDirection.forward);
      });
  }

  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      closeManually: true,
      backgroundColor: Colors.blue[900],
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      // child: Icon(Icons.add),
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      visible: dialVisible,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: Icon(Icons.share, color: Colors.white),
          backgroundColor: Colors.blue[900],
          label: 'Share App',
          onTap: () {
            _onShare();
          }
        ),
        SpeedDialChild(
          child: Icon(Icons.star_rate, color: Colors.white),
          backgroundColor: Colors.blue[900],
          label: 'Request a Sticker Pack',
          onTap: () {
            launch('https://forms.gle/1Mx6Q5aBM2X8gnqq7');
          }
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildSpeedDial();
  }

  _onShare() async {
    Share.share(
        'Hey check out my app at : https://apps.apple.com/us/app/signal-stickers-meme-stickers/id1552273620');
  }
}
