import 'package:flutter/material.dart';
import 'package:flutter_app/app/component/icon_tab.dart';
import 'package:flutter_app/app/recruit_view/pub_list.dart';
import 'package:flutter_app/app/recruit_view/resume_list.dart';
import 'package:flutter_app/app/recruit_view/mine_view.dart';

const double _kTabTextSize = 11.0;
const int INDEX_RESUME = 0;
const int INDEX_PUB = 1;
const int INDEX_MINE = 2;
const int INDEX_JOB = 3;
Color _kPrimaryColor = new Color.fromARGB(255, 0, 215, 198);

class Recruit extends StatefulWidget {
  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<Recruit> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  TabController _controller;
  VoidCallback onChanged;

  @override
  void initState() {
    super.initState();
    _controller =
        new TabController(initialIndex: _currentIndex, length: 3, vsync: this);
    onChanged = () {
      setState(() {
        _currentIndex = this._controller.index;
      });
    };

    _controller.addListener(onChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(onChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double factor = MediaQuery.of(context).size.width/750;
    return new Scaffold(
      body: new TabBarView(
        children: <Widget>[
          new ResumeTab('精英简历', null, 1),
          new PubTab('我的职位'),
          new MineTab(),
          // new JobsTab(1, '全职'),
        ],
        controller: _controller,
      ),
      bottomNavigationBar: new Material(
        color: Colors.white,
        child: SafeArea(
          bottom: true,
          child: new TabBar(
            controller: _controller,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: new TextStyle(fontSize: _kTabTextSize*factor),
            tabs: <IconTab>[
              new IconTab(
                  iconData: Icons.school,
                  text: "简历大厅",
                  color: _currentIndex == INDEX_RESUME
                      ? _kPrimaryColor
                      : Colors.grey[900]),
              new IconTab(
                  iconData: Icons.work,
                  text: "职位",
                  color: _currentIndex == INDEX_PUB
                      ? _kPrimaryColor
                      : Colors.grey[900]),
              new IconTab(
                  iconData: Icons.person_outline,
                  text: "我的",
                  color: _currentIndex == INDEX_MINE
                      ? _kPrimaryColor
                      : Colors.grey[900]),
              // new IconTab(
              //     iconData: Icons.shop,
              //     text: "全职",
              //     color: _currentIndex == INDEX_JOB
              //         ? _kPrimaryColor
              //         : Colors.grey[900]),
            ],
          ),
        )
      ),
    );
  }
}

void main() {
  runApp(new MaterialApp(
      title: "丫财",
      theme: new ThemeData(
        primaryIconTheme: const IconThemeData(color: Colors.white),
        brightness: Brightness.light,
        primaryColor: _kPrimaryColor,
        accentColor: Colors.cyan[300],
      ),
      home: new Recruit()
  ));
}
