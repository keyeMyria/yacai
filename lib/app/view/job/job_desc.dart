import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/job.dart';

class JobDesc extends StatelessWidget {

  final Job job;

  JobDesc(this.job);

  @override
  Widget build(BuildContext context) {
    double screenWidthInPt = MediaQuery.of(context).size.width;
    return new Padding(
      padding: EdgeInsets.only(
        left: 10.0*screenWidthInPt/750,
        right: 10.0*screenWidthInPt/750
      ),
      child: new Container(
          color: Colors.white,
          height: 330.0*screenWidthInPt/750,
          child: new Padding(
              padding: EdgeInsets.all(15.0*screenWidthInPt/750),
              child: new Column(
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Container(
                        margin: EdgeInsets.only(bottom: 10.0*screenWidthInPt/750),
                        child: new Text(
                            '职位详情', style: new TextStyle(fontSize: 26.0*screenWidthInPt/750, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),

                  new RichText(
                    text: new TextSpan(
                      text: job.detail,
                      style: new TextStyle(
                          fontSize: 24.0*screenWidthInPt/750,
                          color: Colors.black
                      ),
                    ),
                  )
                ],
              )
          )
      ),
    );
  }
}