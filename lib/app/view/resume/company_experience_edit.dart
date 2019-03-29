import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/resume.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/app/model/app.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_app/app/component/common_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:flutter_app/actions/actions.dart';
import 'package:flutter_app/app/model/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';


enum AppBarBehavior { normal, pinned, floating, snapping }

class CompanyExperienceEditView extends StatefulWidget {

  final CompanyExperience _companyExperience;

  CompanyExperienceEditView(this._companyExperience);

  @override
  CompanyExperienceEditViewState createState() => new CompanyExperienceEditViewState();
}

class CompanyExperienceEditViewState extends State<CompanyExperienceEditView>
    with TickerProviderStateMixin {

  CompanyExperience _companyExperience;
  bool isRequesting = false;
  String userName = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      _companyExperience = widget._companyExperience;
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

  Widget titleOption(BuildContext context, int index) {
    double factor = MediaQuery.of(context).size.width/750;
    return new InkWell(
      onTap: () {
        setState(() {
          _companyExperience.jobTitle =  titleArr[index];
        });
      },
      child: new Container(
        height: 40*factor,
        width: 220*factor,
        decoration: BoxDecoration(
          border: _companyExperience.jobTitle == titleArr[index] ? new Border.all(
            color: const Color(0xffaaaaaa),
            width: 2*factor
          ) : Border(),
        ),
        child: new Center(
          child: new Text(titleArr[index], style: TextStyle(fontSize: 22.0*factor),),
        ),
      ),
    );
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
            title: new Text('工作经历',
                style: new TextStyle(fontSize: 30.0*factor, color: Colors.white)),
          ),
          body: new SingleChildScrollView(
            child: new Padding(
              padding: EdgeInsets.all(10.0*factor),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Padding(
                    padding: EdgeInsets.only(bottom: 10.0*factor),
                    child: new Text(
                      '公司名：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 24.0*factor),
                    ),
                  ),
                  new Padding(
                    padding: EdgeInsets.only(bottom: 16.0*factor),
                    child: TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                        autofocus: true,
                        controller: TextEditingController.fromValue(
                          TextEditingValue(
                            text: _companyExperience.cname,
                            selection: TextSelection.fromPosition(
                              TextPosition(
                                affinity: TextAffinity.downstream,
                                offset: _companyExperience.cname.length
                              )
                            )
                          )
                        ),
                        style: TextStyle(fontSize: 20*factor),
                        decoration: new InputDecoration(
                          hintText: "请输入公司名",
                          hintStyle: new TextStyle(
                              color: const Color(0xFF808080),
                              fontSize: 20.0*factor
                          ),
                          border: new UnderlineInputBorder(
                            borderSide: BorderSide(width: 1.0*factor)
                          ),
                          contentPadding: EdgeInsets.all(10.0*factor)
                        ),
                      ),
                      suggestionsCallback: (pattern) async {
                        Response response = await Api().getCompanySuggestions(pattern);
                        return response.data;
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          leading: Icon(Icons.business),
                          title: Text(suggestion['name']),
                          subtitle: Text('${suggestion['location']}'),
                        );
                      },
                      onSuggestionSelected: (suggestion) {
                        setState(() {
                        _companyExperience.cname = suggestion['name'];
                        });
                      },
                    )
                  ),
                  new Padding(
                    padding: EdgeInsets.only(bottom: 10.0*factor),
                    child: new Text(
                      '职位名称：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 24.0*factor),
                    ),
                  ),
                  new Container(
                    height: 60*factor,
                    child: new ListView.builder(
                      shrinkWrap: true,
                      itemCount: titleArr.length,
                      itemBuilder: titleOption,
                      scrollDirection: Axis.horizontal,
                      physics: const ClampingScrollPhysics(),
                    ),
                  ),
                  Container(height: 10*factor,),
                  Divider(),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10*factor, bottom: 10*factor),
                        child: new Text(
                          '开始时间：',
                          textAlign: TextAlign.left,
                          style: new TextStyle(fontSize: 24.0*factor),
                        ),
                      ),

                      new InkWell(
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.parse(_companyExperience.startTime),
                            firstDate: DateTime.parse('1900-01-01'), // 减 30 天
                            lastDate: new DateTime.now(),       // 加 30 天
                          ).then((DateTime val) {
                            setState(() {
                              _companyExperience.startTime = formatDate(val, [yyyy, '-', mm, '-', dd]);
                            });
                          }).catchError((err) {
                            print(err);
                          });
                        },
                        child: new Text(_companyExperience.startTime, style: TextStyle(fontSize: 24*factor),),
                      )
                    ],
                  ),
                  new Divider(),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10*factor, bottom: 10*factor),
                        child: new Text(
                          '结束时间：',
                          textAlign: TextAlign.left,
                          style: new TextStyle(fontSize: 24.0*factor),
                        ),
                      ),

                      new InkWell(
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.parse(
                              _companyExperience.endTime == null ? formatDate(new DateTime.now(), [yyyy, '-', mm, '-', dd]) : _companyExperience.endTime
                            ),
                            firstDate: DateTime.parse('1900-01-01'), // 减 30 天
                            lastDate: new DateTime.now(),       // 加 30 天
                          ).then((DateTime val) {
                            setState(() {
                              String currentDate = formatDate(new DateTime.now(), [yyyy, '-', mm, '-', dd]);
                              if (formatDate(val, [yyyy, '-', mm, '-', dd]) == currentDate) {
                                _companyExperience.endTime = null;
                              } else {
                                _companyExperience.endTime = formatDate(val, [yyyy, '-', mm, '-', dd]);
                              }
                            });
                          }).catchError((err) {
                            print(err);
                          });
                        },
                        child: new Text(_companyExperience.endTime == null ? '至今' : _companyExperience.endTime, style: TextStyle(fontSize: 24*factor),),
                      )
                    ],
                  ),
                  new Divider(),
                  new Padding(
                    padding: EdgeInsets.only(bottom: 20.0*factor),
                    child: new Text(
                      '工作内容：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 24.0*factor),
                    ),
                  ),
                  new TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    controller: TextEditingController.fromValue(
                      TextEditingValue(
                        text: _companyExperience.detail,
                        selection: TextSelection.fromPosition(
                          TextPosition(
                            affinity: TextAffinity.downstream,
                            offset: _companyExperience.detail.length
                          )
                        )
                      )
                    ),
                    onChanged: (val) {
                      setState(() {
                        _companyExperience.detail = val;
                      });
                    },
                    style: TextStyle(fontSize: 20.0*factor),
                    decoration: new InputDecoration(
                      hintText: "请输入您的工作内容",
                      hintStyle: new TextStyle(
                          color: const Color(0xFF808080),
                          fontSize: 20.0*factor
                      ),
                      border: new OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6.0*factor))
                      ),
                      contentPadding: EdgeInsets.all(10.0*factor)
                    ),
                  ),
                  new Divider(),
                  new Padding(
                    padding: EdgeInsets.only(bottom: 20.0*factor),
                    child: new Text(
                      '工作业绩：',
                      textAlign: TextAlign.left,
                      style: new TextStyle(fontSize: 24.0*factor),
                    ),
                  ),
                  new TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    style: TextStyle(fontSize: 20.0*factor),
                    controller: TextEditingController.fromValue(
                      TextEditingValue(
                        text: _companyExperience.performance == null ? '' : _companyExperience.performance,
                        selection: TextSelection.fromPosition(
                          TextPosition(
                            affinity: TextAffinity.downstream,
                            offset: _companyExperience.performance.length
                          )
                        )
                      )
                    ),
                    onChanged: (val) {
                      setState(() {
                        _companyExperience.performance = val;
                      });
                    },
                    decoration: new InputDecoration(
                      hintText: "请输入您的工作业绩",
                      hintStyle: new TextStyle(
                          color: const Color(0xFF808080),
                          fontSize: 20.0*factor
                      ),
                      border: new OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6.0*factor))
                      ),
                      contentPadding: EdgeInsets.all(10.0*factor)
                    ),
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
                        Api().saveCompanyExperience(
                          _companyExperience.cname,
                          _companyExperience.jobTitle,
                          _companyExperience.startTime,
                          _companyExperience.endTime,
                          _companyExperience.detail,
                          _companyExperience.performance,
                          userName,
                          _companyExperience.id,
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
                            if(_companyExperience.id == null) {
                              resume.companyExperiences.add(CompanyExperience.fromMap(response.data['info']));
                              StoreProvider.of<AppState>(context).dispatch(SetResumeAction(resume));
                            } else {
                              for (var i = 0; i < resume.companyExperiences.length; i++) {
                                if(resume.companyExperiences[i].id == _companyExperience.id) {
                                  resume.companyExperiences[i] = _companyExperience;
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