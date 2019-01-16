import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/resume.dart';

enum AppBarBehavior { normal, pinned, floating, snapping }

class EducationView extends StatefulWidget {

  final Education _education;

  EducationView(this._education);

  @override
  EducationViewState createState() => new EducationViewState();
}

class EducationViewState extends State<EducationView>
    with TickerProviderStateMixin {

  VoidCallback onChanged;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle detailStyle = new TextStyle(fontSize: 10.0, color: Colors.grey);
    return new Container(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(widget._education.name, style: new TextStyle(fontSize: 12.0) ),
              new Text(
                "${widget._education.startTime}-${widget._education.endTime}",
                style: detailStyle
              ),
            ]
          ),
          new Text(widget._education.major, style: detailStyle),
          new Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
          ),
          new Text(widget._education.detail, style: new TextStyle(fontSize: 12.0)),
        ],
      ),
    );
  }
}