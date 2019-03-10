import 'package:flutter/material.dart';
import 'package:flutter_app/app/model/company.dart';
import 'package:flutter_app/app/model/job.dart';
import 'package:flutter_app/app/view/company/company_info.dart';
import 'package:flutter_app/app/component/common_button.dart';
import 'package:flutter_app/app/view/company/company_edit.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/app/api/api.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_app/app/model/constants.dart';
import 'package:flutter_app/app/component/city.dart';
import 'package:flutter_app/app/component/salary.dart';

enum AppBarBehavior { normal, pinned, floating, snapping }

class CompanyEdit extends StatefulWidget {

  final Company _company;
  CompanyEdit(this._company);

  @override
  CompanyEditState createState() => new CompanyEditState();
}

class CompanyEditState extends State<CompanyEdit>
    with TickerProviderStateMixin {

  VoidCallback onChanged;
  Company _company;
  final nameCtrl = new TextEditingController(text: '');
  final salaryCtrl = new TextEditingController(text: '');
  final addrCtrl = new TextEditingController(text: '');
  bool isRequesting = false;
  String date = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
  String timereq = '不限';
  String academic = '不限';
  String province = '上海市';
  String city = '上海市';
  String area = '黄浦区';
  int start = 1;
  int end = 2;
  Company company;

  @override
  void initState() {
    super.initState();
    setState(() {
      company = widget._company;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget timeReqOption(BuildContext context, int index) {
    double factor = MediaQuery.of(context).size.width/750;
    return new InkWell(
      onTap: () {
        setState(() {
          timereq =  index == 0 ? '不限' : timeReqArr[index - 1].toString() + '年';
        });
      },
      child: new Container(
        height: 40*factor,
        width: 108*factor,
        decoration: BoxDecoration(
          border: new Border.all(
            color: (index == 0 && timereq == '不限') || (index > 0 && timereq == timeReqArr[index - 1].toString() + '年') ? const Color(0xffaaaaaa) : const Color(0xffffffff),
            width: 2*factor
          ),
        ),
        child: new Center(
          child: new Text(index == 0 ? '不限' : timeReqArr[index - 1].toString() + '年', style: TextStyle(fontSize: 22.0*factor),),
        ),
      ),
    );
  }

  Widget academicOption(BuildContext context, int index) {
    double factor = MediaQuery.of(context).size.width/750;
    return new InkWell(
      onTap: () {
        setState(() {
          academic =  index == 0 ? '不限' : academicArr[index - 1];
        });
      },
      child: new Container(
        height: 40*factor,
        width: 108*factor,
        decoration: BoxDecoration(
          border: new Border.all(
            color: (index == 0 && academic == '不限') || (index > 0 && academic == academicArr[index - 1]) ? const Color(0xffaaaaaa) : const Color(0xffffffff),
            width: 2*factor
          ),
        ),
        child: new Center(
          child: new Text(index == 0 ? '不限' : academicArr[index - 1], style: TextStyle(fontSize: 22.0*factor),),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    return new Scaffold(
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
          title: new Text('公司信息',
              style: new TextStyle(fontSize: 30.0*factor, color: Colors.white)),
        ),
        body: new SingleChildScrollView(
          child: new Padding(
            padding: EdgeInsets.all(30.0*factor),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(bottom: 10.0*factor),
                  child: new Text(
                    '公司名称：',
                    textAlign: TextAlign.left,
                    style: new TextStyle(fontSize: 26.0*factor),
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.only(bottom: 36.0*factor),
                  child: new TextField(
                    style: TextStyle(fontSize: 20.0*factor),
                    controller: TextEditingController.fromValue(
                      TextEditingValue(
                        text: company.name,
                        selection: TextSelection.fromPosition(
                          TextPosition(
                            affinity: TextAffinity.downstream,
                            offset: company.name.length
                          )
                        )
                      )
                    ),
                    onChanged: (val) {
                      setState(() {
                        company.name = val;
                      });
                    },
                    decoration: new InputDecoration(
                      hintText: "请输入公司名称",
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
                  padding: EdgeInsets.only(bottom: 10.0*factor),
                  child: new Text(
                    '公司位置：',
                    textAlign: TextAlign.left,
                    style: new TextStyle(fontSize: 26.0*factor),
                  ),
                ),
                new InkWell(
                  onTap: () {
                    CityPicker.showCityPicker(
                      context,
                      selectProvince: (prov) {
                        setState(() {
                         province = prov['name']; 
                        });
                      },
                      selectCity: (res) {
                        setState(() {
                         city = res['name']; 
                        });
                      },
                      selectArea: (res) {
                        setState(() {
                         area = res['name']; 
                        });
                      },
                    );
                  },
                  child: Text('$province $city $area', style: TextStyle(fontSize: 22.0*factor, color: Colors.grey),),
                ),
                new Padding(
                  padding: EdgeInsets.only(bottom: 36.0*factor),
                  child: new TextField(
                    controller: addrCtrl,
                    style: TextStyle(fontSize: 22*factor),
                    decoration: new InputDecoration(
                      hintText: "请输入详细地址",
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
                  padding: EdgeInsets.only(bottom: 10.0*factor),
                  child: new Text(
                    '公司性质：',
                    textAlign: TextAlign.left,
                    style: new TextStyle(fontSize: 26.0*factor),
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.only(bottom: 36.0*factor),
                  child: new TextField(
                    style: TextStyle(fontSize: 20.0*factor),
                    controller: TextEditingController.fromValue(
                      TextEditingValue(
                        text: company.type,
                        selection: TextSelection.fromPosition(
                          TextPosition(
                            affinity: TextAffinity.downstream,
                            offset: company.type.length
                          )
                        )
                      )
                    ),
                    onChanged: (val) {
                      setState(() {
                        company.type = val;
                      });
                    },
                    decoration: new InputDecoration(
                      hintText: "请输入公司性质",
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
                  padding: EdgeInsets.only(bottom: 10.0*factor),
                  child: new Text(
                    '公司规模：',
                    textAlign: TextAlign.left,
                    style: new TextStyle(fontSize: 26.0*factor),
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.only(bottom: 36.0*factor),
                  child: new TextField(
                    style: TextStyle(fontSize: 20.0*factor),
                    controller: TextEditingController.fromValue(
                      TextEditingValue(
                        text: company.size,
                        selection: TextSelection.fromPosition(
                          TextPosition(
                            affinity: TextAffinity.downstream,
                            offset: company.size.length
                          )
                        )
                      )
                    ),
                    onChanged: (val) {
                      setState(() {
                        company.size = val;
                      });
                    },
                    decoration: new InputDecoration(
                      hintText: "请输入公司规模",
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
                  padding: EdgeInsets.only(bottom: 10.0*factor),
                  child: new Text(
                    '公司人数：',
                    textAlign: TextAlign.left,
                    style: new TextStyle(fontSize: 26.0*factor),
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.only(bottom: 36.0*factor),
                  child: new TextField(
                    style: TextStyle(fontSize: 20.0*factor),
                    controller: TextEditingController.fromValue(
                      TextEditingValue(
                        text: company.employee,
                        selection: TextSelection.fromPosition(
                          TextPosition(
                            affinity: TextAffinity.downstream,
                            offset: company.employee.length
                          )
                        )
                      )
                    ),
                    onChanged: (val) {
                      setState(() {
                        company.employee = val;
                      });
                    },
                    decoration: new InputDecoration(
                      hintText: "请输入公司人数",
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
                  padding: EdgeInsets.only(bottom: 10.0*factor),
                  child: new Text(
                    '详情描述：',
                    textAlign: TextAlign.left,
                    style: new TextStyle(fontSize: 26.0*factor),
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.only(bottom: 36.0*factor),
                  child: new TextField(
                    style: TextStyle(fontSize: 20.0*factor),
                    controller: TextEditingController.fromValue(
                      TextEditingValue(
                        text: company.inc,
                        selection: TextSelection.fromPosition(
                          TextPosition(
                            affinity: TextAffinity.downstream,
                            offset: company.inc.length
                          )
                        )
                      )
                    ),
                    onChanged: (val) {
                      setState(() {
                        company.inc = val;
                      });
                    },
                    decoration: new InputDecoration(
                      hintText: "请输入详情描述",
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
                
                new Container(
                  height: 36*factor,
                ),
                new Builder(builder: (ctx) {
                  return new CommonButton(
                    text: "保存",
                    color: new Color.fromARGB(255, 0, 215, 198),
                    onTap: () {
                      if (isRequesting) return;
                      setState(() {
                        isRequesting = true;
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

  navCompanyEdit() {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          Company company = new Company();
          return new CompanyEdit(company);
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