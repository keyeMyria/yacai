import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/company.dart';
import 'package:flutter_app/app/model/job.dart';
import 'package:flutter_app/app/view/company/company_info.dart';
import 'package:flutter_app/app/view/job/job_base.dart';
import 'package:flutter_app/app/view/job/job_desc.dart';
import 'package:flutter_app/app/view/job/job_addr.dart';
import 'package:flutter_app/app/view/company/company_detail.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/api/api.dart';

enum AppBarBehavior { normal, pinned, floating, snapping }

class JobDetail extends StatefulWidget {
  final Job _job;

  JobDetail(this._job);

  @override
  JobDetailState createState() => new JobDetailState();
}

class JobDetailState extends State<JobDetail>
    with TickerProviderStateMixin {

  VoidCallback onChanged;
  Company _company;

  @override
  void initState() {
    super.initState();
    Api().getCompanyDetail(widget._job.companyId)
      .then((Response response) {
        setState(() {
          _company = Company.fromMap(response.data['data']);
        });
      })
     .catchError((e) {
       print(e);
     });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: new Color.fromARGB(255, 242, 242, 245),
        body: new Stack(
          children: <Widget>[
            new SingleChildScrollView(
                child: new Column(
                  children: <Widget>[
                    new Container(
                      color: Colors.white,
                      child: new Column(
                        children: <Widget>[
                          new JobBase(widget._job),
                          new Divider(),
                          new JobDesc(widget._job),
                          new Divider(),
                          new JobAddr(widget._job),
                          new Divider(),
                          new InkWell(
                              onTap: () => navCompanyDetail(_company),
                              child: _company == null ? new Container() : new CompanyInfo(_company)
                          )
                        ],
                      ),
                    ),
                  ],
                )
            ),

            new Positioned(
              top: 10.0,
              left: -10.0,
              child: new Container(
                  padding: const EdgeInsets.all(15.0),
                  child: new BackButton(color: Colors.grey)
              ),
            ),
          ],
        )
    );
  }

  navCompanyDetail(Company company) {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new CompanyDetail(company);
        },
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return new FadeTransition(
            opacity: animation,
            child: new SlideTransition(position: new Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(animation), child: child),
          );
        }
    ));
  }
}