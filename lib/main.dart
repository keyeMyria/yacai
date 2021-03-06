import 'package:flutter/material.dart';
import 'package:flutter_app/splash.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_app/app/model/app.dart';
import 'package:flutter_app/reducers/app_state_reducer.dart';

void main() {
  // debugPaintSizeEnabled=true;
  final store = Store<AppState>(
    appReducer,
    initialState: AppState(userName: '')
  );
  runApp(
    StoreProvider(
      store: store,
      child: new MaterialApp(
        title: "丫财",
        theme: new ThemeData(
          primaryIconTheme: const IconThemeData(color: Colors.white),
          brightness: Brightness.light,
          primaryColor: new Color.fromARGB(255, 0, 215, 198),
          accentColor: Colors.cyan[300],
        ),
        home: new SplashPage()
      )
    )
  );
}