import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/resume.dart';
import 'package:flutter_app/app/component/common_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:flutter_app/actions/actions.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/app/model/app.dart';
import 'package:date_format/date_format.dart';

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

  @override
  void initState() {
    super.initState();
    setState(() {
     _certification = widget._certification; 
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return new Scaffold(
          backgroundColor: Colors.white,
          appBar: new AppBar(
            elevation: 0.0,
            title: new Text('证书',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
          ),
          body: new SingleChildScrollView(
            child: new Padding(
              padding: const EdgeInsets.all(10.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: new Text(
                      '证书名称：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 18.0),
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: new TextField(
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
                        border: new UnderlineInputBorder(),
                        contentPadding: const EdgeInsets.all(10.0)
                      ),
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: new Text(
                      '颁发单位：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 18.0),
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: new TextField(
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
                        border: new UnderlineInputBorder(),
                        contentPadding: const EdgeInsets.all(10.0)
                      ),
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: new Text(
                      '证书编号：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 18.0),
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: new TextField(
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
                        contentPadding: const EdgeInsets.all(10.0)
                      ),
                    ),
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Text(
                        '颁发时间：',
                        textAlign: TextAlign.left,
                        style: new TextStyle(fontSize: 18.0),
                      ),

                      new InkWell(
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
                        child: new Text(_certification.qualifiedTime),
                      )
                    ],
                  ),
                  new Divider(),
                  new Builder(builder: (ctx) {
                    return new CommonButton(
                      text: "保存",
                      color: new Color.fromARGB(255, 0, 215, 198),
                      onTap: () {
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
                          state.userName,
                          _certification.id,
                        )
                          .then((Response response) {
                            setState(() {
                              isRequesting = false;
                            });
                            if(response.data['code'] != 1) {
                              Scaffold.of(ctx).showSnackBar(new SnackBar(
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
                    );
                  })
                ],
              ),
            )
          )
        );
      }
    );
  }
}