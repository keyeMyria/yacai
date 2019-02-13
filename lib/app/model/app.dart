// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:meta/meta.dart';
import 'package:flutter_app/app/model/resume.dart';
import 'package:flutter_app/app/model/job.dart';

@immutable
class AppState {
  final String userName;
  final Resume resume;
  final List<Job> jobs;

  AppState({
    this.userName = '',
    this.resume,
    this.jobs
  });
}
