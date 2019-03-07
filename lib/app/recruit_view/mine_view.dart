import 'package:flutter/material.dart';
import 'package:flutter_app/app/view/login_view.dart';
import 'package:flutter_app/app/recruit_view/job/job_list.dart';
import 'package:flutter_app/app/model/job.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/app/model/app.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:flutter_app/actions/actions.dart';

class MineTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MineTabState();
}

class MineTabState extends State<MineTab> {

  final double _appBarHeight = 150.0;
  String userAvatar = '';
  String jobStatus = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, appState) {
        return new Scaffold(
          backgroundColor: new Color.fromARGB(255, 242, 242, 245),
          body: new CustomScrollView(
            slivers: <Widget>[
              new SliverAppBar(
                expandedHeight: _appBarHeight,
                flexibleSpace: new FlexibleSpaceBar(
                  background: new Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      const DecoratedBox(
                        decoration: const BoxDecoration(
                          gradient: const LinearGradient(
                            begin: const Alignment(0.0, -1.0),
                            end: const Alignment(0.0, -0.4),
                            colors: const <Color>[
                              const Color(0x00000000), const Color(0x00000000)],
                          ),
                        ),
                      ),

                      new GestureDetector(
                        onTap: () {
                          if(appState.userName != '') return;
                          _login();
                        },
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            new Padding(
                              padding: EdgeInsets.only(
                                top: 20.0*factor,
                                left: 30.0*factor,
                                right: 20.0*factor,
                              ),
                              child: appState.resume == null || appState.resume.personalInfo.avatar == ''
                                ? new Image.asset(
                                    "assets/images/ic_avatar_default.png",
                                    width: 120.0*factor,
                                  )
                                : new CircleAvatar(
                                  radius: 60.0*factor,
                                  backgroundImage: new NetworkImage(appState.resume.personalInfo.avatar)
                                )
                            ),

                            new Row(
                              children: <Widget>[
                                new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    new Padding(
                                        padding: EdgeInsets.only(
                                          top: 10.0*factor,
                                          bottom: 10.0*factor,
                                        ),
                                        child: new Text(
                                            appState.userName == '' ? "点击头像登录" : appState.userName,
                                            style: new TextStyle(
                                                color: Colors.white, fontSize: 26.0*factor))
                                    ),
                                    new Text(
                                        appState.resume == null || appState.resume.jobStatus == '' ? "" : appState.resume.jobStatus,
                                        style: new TextStyle(
                                            color: Colors.white, fontSize: 18.0*factor)
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),

              new SliverList(
                delegate: new SliverChildListDelegate(<Widget>[
                  new InkWell(
                    onTap: () {
                      if(appState.userName == '') {
                        _login();
                      } else {
                        _navToPubJobList();
                      }
                    },
                    child: new Container(
                      height: 60.0*factor,
                      margin: EdgeInsets.only(top: 10.0*factor, bottom: 10.0*factor),
                      decoration: new BoxDecoration(
                        color: Colors.white,
                      ),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Padding(
                            padding: EdgeInsets.all(10.0*factor),
                            child: new Row(
                              children: <Widget>[
                                new Icon(Icons.near_me, size: 30.0*factor,),
                                new Padding(
                                  padding: EdgeInsets.only(right: 10.0*factor),
                                ),
                                new Text('投递记录', style: TextStyle(fontSize: 22.0*factor),),
                              ],
                            ),
                          ),
                          new Icon(Icons.chevron_right, size: 30.0*factor,),
                        ],
                      ),
                    )
                  ),

                  new Container(
                    color: Colors.white,
                    child: new Padding(
                      padding: EdgeInsets.only(
                        top: 10.0*factor,
                        bottom: 10.0*factor,
                      ),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          new _ContactItem(
                            onPressed: () {
                              showDialog(context: context, child: new AlertDialog(
                                  content: new Text(
                                    "沟通过",
                                    style: new TextStyle(fontSize: 20.0*factor),
                                  )));
                            },
                            count: '590',
                            title: '沟通过',
                          ),
                          new _ContactItem(
                            onPressed: () {
                              showDialog(context: context, child: new AlertDialog(
                                  content: new Text(
                                    "已沟通",
                                    style: new TextStyle(fontSize: 20.0*factor),
                                  )));
                            },
                            count: '71',
                            title: '已沟通',
                          ),
                          new _ContactItem(
                            onPressed: () {
                              showDialog(context: context, child: new AlertDialog(
                                  content: new Text(
                                    "已沟通",
                                    style: new TextStyle(fontSize: 20.0*factor),
                                  )));
                            },
                            count: '0',
                            title: '待面试',
                          ),
                        ],
                      ),
                    ),
                  ),
                ])
              )
            ],
          ),
        );
      },
    );
  }

  _login() {
    Navigator
      .of(context)
      .push(new MaterialPageRoute(builder: (context) {
        return new NewLoginPage();
      }))
      .then((result) {
        if(result == null) return;
        final store = StoreProvider.of<AppState>(context);
        Api().getRecruitJobList(store.state.userName)
          .then((Response response) {
            store.dispatch(SetJobsAction(Job.fromJson(response.data['list'])));
          })
          .catchError((e) {
            print(e);
          });
      });
  }

  _navToPubJobList() {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new PubJobList();
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

class _ContactItem extends StatelessWidget {
  _ContactItem({ Key key, this.count, this.title, this.onPressed })
      : super(key: key);

  final String count;
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    return new GestureDetector(
        onTap: onPressed,
        child: new Column(
          children: [
            new Padding(
              padding: EdgeInsets.only(
                bottom: 10.0*factor,
              ),
              child: new Text(count, style: new TextStyle(
                  fontSize: 28.0*factor)),
            ),
            new Text(title, style: TextStyle(fontSize: 22.0*factor),),
          ],
        )
    );
  }
}
