import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/job.dart';

class JobDesc extends StatelessWidget {

  final Job job;

  JobDesc(this.job);

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
        left: 10.0,
        right: 10.0,
        bottom: 10.0,
      ),
      child: new Container(
          color: Colors.white,
          height: 260.0,
          child: new Padding(
              padding: const EdgeInsets.all(15.0),
              child: new Column(
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Container(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        child: new Text(
                            '职位详情', style: new TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),

                  new RichText(
                    text: new TextSpan(
                      text: job.detail,
                      style: new TextStyle(
                          fontSize: 13.0,
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