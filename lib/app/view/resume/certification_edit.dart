import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/resume.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:flutter_app/actions/actions.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/app/model/app.dart';
import 'package:date_format/date_format.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppBarBehavior { normal, pinned, floating, snapping }

class CertificationEditView extends StatefulWidget {

  final Certification _certification;

  CertificationEditView(this._certification);

  @override
  CertificationEditViewState createState() => new CertificationEditViewState();
}

class CertificationEditViewState extends State<CertificationEditView>
    with TickerProviderStateMixin {

  VoidCallback onChanged;
  Certification _certification;
  bool isRequesting = false;
  String userName = '';

  @override
  void initState() {
    super.initState();
    setState(() {
     _certification = widget._certification; 
    });
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      setState(() {
        userName = prefs.getString('userName');
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return new Scaffold(
          backgroundColor: Colors.white,
          appBar: new AppBar(
            elevation: 0.0,
            leading: IconButton(
              icon: const BackButtonIcon(),
              iconSize: 40*factor,
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              onPressed: () {
                Navigator.maybePop(context);
              }
            ),
            title: new Text('证书',
                style: new TextStyle(fontSize: 30.0*factor, color: Colors.white)),
          ),
          body: new Stack(
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.all(20.0*factor),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Padding(
                      padding: EdgeInsets.only(bottom: 10.0*factor),
                      child: new Text(
                        '证书名称：',
                        textAlign: TextAlign.left,
                        style: new TextStyle(fontSize: 24.0*factor),
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(bottom: 16.0*factor),
                      child: new TextField(
                        style: TextStyle(fontSize: 20.0*factor),
                        controller: TextEditingController.fromValue(
                          TextEditingValue(
                            text: _certification.name,
                            selection: TextSelection.fromPosition(
                              TextPosition(
                                affinity: TextAffinity.downstream,
                                offset: _certification.name.length
                              )
                            )
                          )
                        ),
                        onChanged: (val) {
                          setState(() {
                            _certification.name = val;
                          });
                        },
                        decoration: new InputDecoration(
                          hintText: "请输入证书名称",
                          hintStyle: new TextStyle(
                              color: const Color(0xFF808080)
                          ),
                          border: new UnderlineInputBorder(
                            borderSide: BorderSide(width: factor)
                          ),
                          contentPadding: EdgeInsets.all(10.0*factor)
                        ),
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(top: 10*factor, bottom: 10.0*factor),
                      child: new Text(
                        '颁发单位：',
                        textAlign: TextAlign.left,
                        style: new TextStyle(fontSize: 24.0*factor),
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(bottom: 16.0*factor),
                      child: new TextField(
                        style: TextStyle(fontSize: 20.0*factor),
                        controller: TextEditingController.fromValue(
                          TextEditingValue(
                            text: _certification.industry,
                            selection: TextSelection.fromPosition(
                              TextPosition(
                                affinity: TextAffinity.downstream,
                                offset: _certification.industry.length
                              )
                            )
                          )
                        ),
                        onChanged: (val) {
                          setState(() {
                            _certification.industry = val;
                          });
                        },
                        decoration: new InputDecoration(
                          hintText: "请输入颁发单位",
                          hintStyle: new TextStyle(
                              color: const Color(0xFF808080)
                          ),
                          border: new UnderlineInputBorder(
                            borderSide: BorderSide(width: 1.0*factor)
                          ),
                          contentPadding: EdgeInsets.all(10.0*factor)
                        ),
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(top: 10*factor, bottom: 10.0*factor),
                      child: new Text(
                        '证书编号：',
                        textAlign: TextAlign.left,
                        style: new TextStyle(fontSize: 24.0*factor),
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(bottom: 16.0*factor),
                      child: new TextField(
                        style: TextStyle(fontSize: 20*factor),
                        controller: TextEditingController.fromValue(
                          TextEditingValue(
                            text: _certification.code,
                            selection: TextSelection.fromPosition(
                              TextPosition(
                                affinity: TextAffinity.downstream,
                                offset: _certification.code.length
                              )
                            )
                          )
                        ),
                        onChanged: (val) {
                          setState(() {
                            _certification.code = val;
                          });
                        },
                        decoration: new InputDecoration(
                          hintText: "请输入证书编号",
                          hintStyle: new TextStyle(
                              color: const Color(0xFF808080)
                          ),
                          border: new UnderlineInputBorder(),
                          contentPadding: EdgeInsets.all(10.0*factor)
                        ),
                      ),
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 10*factor),
                          child: new Text(
                            '颁发时间：',
                            textAlign: TextAlign.left,
                            style: new TextStyle(fontSize: 24.0*factor),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10*factor),
                          child: new InkWell(
                            onTap: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.parse(_certification.qualifiedTime),
                                firstDate: DateTime.parse('1900-01-01'), // 减 30 天
                                lastDate: new DateTime.now(),       // 加 30 天
                              ).then((DateTime val) {
                                setState(() {
                                  _certification.qualifiedTime = formatDate(val, [yyyy, '-', mm, '-', dd]);
                                });
                              }).catchError((err) {
                                print(err);
                              });
                            },
                            child: new Text(_certification.qualifiedTime, style: new TextStyle(fontSize: 24.0*factor),),
                          ),
                        ),
                      ],
                    ),
                    Container(height: 10*factor,),
                    new Divider(),
                  ],
                ),
              ),
              new Positioned(
                bottom: 30.0*factor,
                left: 20.0*factor,
                width: MediaQuery.of(context).size.width - 40*factor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton(
                      child: new Container(
                        width: 200*factor,
                        height: 70*factor,
                        child: new Center(
                          child: Text(
                            "删除",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28.0*factor,
                              letterSpacing: 40*factor
                            ),
                          ),
                        ),
                      ),
                      color: Colors.orange,
                      onPressed: () {
                        if (isRequesting) return;
                        showDialog<Null>(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return new AlertDialog(
                              content: Text("确认要删除么？", style: TextStyle(fontSize: 28*factor),),
                              actions: <Widget>[
                                new FlatButton(
                                  child: new Text('确定', style: TextStyle(fontSize: 24*factor, color: Colors.orange),),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    setState(() {
                                      isRequesting = true;
                                    });
                                    // 发送给webview，让webview登录后再取回token
                                    Api().deleteCertification(_certification.id)
                                      .then((Response response) {
                                        setState(() {
                                          isRequesting = false;
                                        });
                                        if(response.data['code'] != 1) {
                                          Scaffold.of(context).showSnackBar(new SnackBar(
                                            content: new Text("删除失败！"),
                                          ));
                                          return;
                                        }
                                        Resume resume = state.resume;
                                        resume.certificates.removeWhere((Certification certification) => certification.id == _certification.id);
                                        StoreProvider.of<AppState>(context).dispatch(SetResumeAction(resume));
                                        Navigator.pop(context);
                                      })
                                      .catchError((e) {
                                        setState(() {
                                          isRequesting = false;
                                        });
                                        print(e);
                                      });
                                  },
                                ),
                                new FlatButton(
                                  child: new Text('取消', style: TextStyle(fontSize: 24*factor),),
                                  onPressed: () {
                                      Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    ),
                    FlatButton(
                      child: new Container(
                        width: 200*factor,
                        height: 70*factor,
                        child: new Center(
                          child: Text(
                            "保存",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28.0*factor,
                              letterSpacing: 40*factor
                            ),
                          ),
                        ),
                      ),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        if (isRequesting) return;
                        setState(() {
                          isRequesting = true;
                        });
                        // 发送给webview，让webview登录后再取回token
                        Api().saveCertification(
                          _certification.name,
                          _certification.industry,
                          _certification.code,
                          _certification.qualifiedTime,
                          userName,
                          _certification.id,
                        )
                          .then((Response response) {
                            setState(() {
                              isRequesting = false;
                            });
                            if(response.data['code'] != 1) {
                              Scaffold.of(context).showSnackBar(new SnackBar(
                                content: new Text("保存失败！"),
                              ));
                              return;
                            }
                            Resume resume = state.resume;
                            if(_certification.id == null) {
                              resume.certificates.add(Certification.fromMap(response.data['info']));
                              StoreProvider.of<AppState>(context).dispatch(SetResumeAction(resume));
                            } else {
                              for (var i = 0; i < resume.certificates.length; i++) {
                                if(resume.certificates[i].id == _certification.id) {
                                  resume.certificates[i] = _certification;
                                  break;
                                }
                              }
                              StoreProvider.of<AppState>(context).dispatch(SetResumeAction(resume));
                            }
                            Navigator.pop(context, response.data['info']);
                          })
                          .catchError((e) {
                            setState(() {
                              isRequesting = false;
                            });
                            print(e);
                          });
                      }
                    ),
                  ]
                )
              )
            ]
          )
        );
      }
    );
  }
}