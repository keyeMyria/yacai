import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/resume.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_app/app/model/constants.dart';
import 'package:flutter_app/app/view/resume/resume_preview.dart';
import 'package:flutter_app/app/component/select.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

const List<String> MARKERS = [
  '-请选择-',
  '有意向',
  '已电联',
];

class UserListItem extends StatefulWidget {
  final PersonalInfo personalInfo;

  UserListItem(this.personalInfo);
  @override
  UserListItemState createState() => new UserListItemState();
}

class UserListItemState extends State<UserListItem> {
  PersonalInfo personalInfo;
  bool isRequesting = false;
  String userName;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      personalInfo = widget.personalInfo;
    });
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      setState(() {
        userName = prefs.getString('userName');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    return new Padding(
      padding: EdgeInsets.only(
        top: 10.0*factor,
        left: 10.0*factor,
        right: 10.0*factor,
        bottom: 10.0*factor,
      ),

      child: new Container(
        decoration: BoxDecoration(
          color: Colors.white
        ),
        child: new Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new InkWell(
                onTap: () => navResumePreview(personalInfo.id),
                child: new Padding(
                  padding: EdgeInsets.only(
                    top: 20.0*factor,
                    left: 20.0*factor,
                    right: 10.0*factor,
                    bottom: 15.0*factor,
                  ),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(
                            personalInfo.name,
                            style: new TextStyle(fontSize: 26.0*factor)
                          ),
                          new Row(
                            children: <Widget>[
                              new Padding(
                                padding: EdgeInsets.only(
                                  top: 15.0*factor,
                                  right: 10.0*factor,
                                ),
                                child: new Text(
                                  personalInfo.gender,
                                  textAlign: TextAlign.left,
                                  style: new TextStyle(
                                      fontSize: 22.0*factor, color: Colors.grey),
                                )
                              ),
                              new Padding(
                                padding: EdgeInsets.only(
                                  top: 15.0*factor,
                                  right: 10.0*factor,
                                ),
                                child: new Text(
                                  yearsOffset(personalInfo.birthDay).toString() + "岁",
                                  style: new TextStyle(fontSize: 22.0*factor, color: Colors.red)
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      personalInfo.avatar == null ? new Image.asset(
                        "assets/images/ic_avatar_default.png",
                        width: 90.0*factor,
                      ) : new CircleAvatar(
                        radius: 45.0*factor,
                        backgroundImage: new NetworkImage(personalInfo.avatar)
                      )
                    ],
                  ),
                ),
            ),
            
            new Divider(),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    new Padding(
                      padding: EdgeInsets.only(
                        top: 10.0*factor,
                        left: 20.0*factor,
                        right: 10.0*factor,
                        bottom: 15.0*factor,
                      ),
                      child: new Text(yearsOffset(personalInfo.firstJobTime).toString() + "年经验",
                          style: new TextStyle(fontSize: 22*factor, color: new Color.fromARGB(
                              255, 0, 215, 198))),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(
                        top: 10.0*factor,
                        bottom: 15.0*factor,
                      ),
                      child: new Text(academicArr[personalInfo.academic], style: new TextStyle(fontSize: 22*factor))
                    ),
                    personalInfo.school != null ? new Padding(
                      padding: EdgeInsets.only(
                        top: 10.0*factor,
                        right: 10.0*factor,
                        bottom: 15.0*factor,
                      ),
                      child: new Text('(${personalInfo.school})', style: new TextStyle(fontSize: 22*factor))
                    ) : Container(),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 10*factor),
                      child: Text('标记为:', style: TextStyle(fontSize: 22*factor),),
                    ),
                    // YCSelect(
                    //   selectedIndex: selectedIndex,
                    //   items: ['-请选择', '有意向', '已电联'],
                    //   onSelectedItemChanged: (value) {
                    //     setState(() {
                    //       selectedIndex = value;
                    //     });
                    //   },
                    //   itemWidth: 170*factor
                    // ),
                    InkWell(
                      child: Text(personalInfo.mark == null ? MARKERS[0] : MARKERS[personalInfo.mark], style: TextStyle(fontSize: 22*factor),),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context){
                            return new Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 10*factor, bottom: 15*factor),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      new Icon(Icons.close, size: 28.0*factor,),
                                      new Text('标记状态', style: new TextStyle(fontSize: 28.0*factor)),
                                      new Icon(Icons.check, size: 28.0*factor),
                                    ],
                                  ),
                                ),
                                new ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: MARKERS.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () async {
                                        setState(() {
                                          personalInfo.mark = index;
                                        });
                                        if (isRequesting) return;
                                        setState(() {
                                          isRequesting = true;
                                        });
                                        // 发送给webview，让webview登录后再取回token
                                        try {
                                          await Api().mark(userName, personalInfo.id, index);
                                          setState(() {
                                            isRequesting = false;
                                          });
                                        } catch (e) {
                                          setState(() {
                                            isRequesting = false;
                                          });
                                          print(e);
                                        }
                                        Navigator.pop(context);
                                      },
                                      child: new Container(
                                        height: 50*factor,
                                        color: personalInfo.mark == index ? Colors.grey[300] : Colors.transparent,
                                        child: new Center(
                                          child: new Text(MARKERS[index], style: TextStyle(fontSize: 22.0*factor),),
                                        ),
                                      ),
                                    );
                                  }
                                ),
                              ],
                            );
                          }
                        );
                      },
                    ),
                    Container(width: 20*factor,)
                  ]
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  navResumePreview(int userId) {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new ResumePreview(userId);
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

  static int yearsOffset(String dateTime) {
    DateTime now = DateTime.parse(formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]));
    int v = now.millisecondsSinceEpoch - DateTime.parse(dateTime).millisecondsSinceEpoch;
    if (v < 0) v = -v;
    return v ~/ (86400000 * 30 * 12);
  }
}
//You can use any Widget
class MySelectionItem extends StatelessWidget {
  final String title;
  final bool isForList;

  const MySelectionItem({this.title, this.isForList = true});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      child: isForList
          ? Padding(
              child: _buildItem(context),
              padding: EdgeInsets.all(10.0),
            )
          : Card(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              child: Stack(
                children: <Widget>[
                  _buildItem(context),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.arrow_drop_down),
                  )
                ],
              ),
            ),
    );
  }

  _buildItem(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: Text(title),
    );
  }
}
