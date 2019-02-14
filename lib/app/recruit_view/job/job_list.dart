import 'package:flutter/material.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/item/joblist_item.dart';
import 'package:flutter_app/app/model/job.dart';
import 'package:flutter_app/app/model/app.dart';
import 'package:flutter_app/app/recruit_view/resume_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_redux/flutter_redux.dart';
// import 'dart:developer';

class PubJobList extends StatefulWidget {
  PubJobList();

  @override
  PubJobListState createState() => new PubJobListState();
}

class PubJobListState extends State<PubJobList> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return new Scaffold(
          backgroundColor: new Color.fromARGB(255, 242, 242, 245),
          appBar: new AppBar(
            elevation: 0.0,
            title: Text(
              '投递记录',
              style: TextStyle(fontSize: 20.0, color: Colors.white)
            )
          ),
          body:new ListView.builder(
            itemCount: state.jobs.length,
            itemBuilder: buildJobItem
          )
        );
      }
    );
  }

  Widget buildJobItem(BuildContext context, int index) {
    Job job = StoreProvider.of<AppState>(context).state.jobs[index];

    var jobItem = new InkWell(
        onTap: () => navToResumeList(job),
        child: new JobListItem(job));

    return jobItem;
  }

  navToResumeList(Job job) {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new ResumeTab('简历投递列表', job.id);
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
