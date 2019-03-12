import 'dart:convert';

import 'package:meta/meta.dart';

class Job {
  final int id;
  final String name; // 职位名称
  final String cname; // 公司名字
  final String salary; // 工资
  final String username; // 发布人
  final String title; // 发布人职位描述
  final String pubTime; // 发布时间
  String province; // 公司位置
  String city; // 公司位置
  String area; // 公司位置
  final String addrDetail; // 工作地点详情
  final String timereq; // 需要的工作年限
  final String academic; // 需要的学历
  final String detail; // 职位详情
  final int companyId; // 公司Id

  Job({
    this.id,
    this.province,
    this.city,
    this.area,
    @required this.name,
    @required this.cname,
    @required this.salary,
    @required this.username,
    @required this.title,
    @required this.pubTime,
    @required this.addrDetail,
    @required this.timereq,
    @required this.academic,
    @required this.detail,
    @required this.companyId
  });

  static List<Job> fromJson(List list) {
    List<Job> _jobs = [];
    for (var value in list) {
      _jobs.add(Job.fromMap(value));
    }
    return _jobs;
  }

  static Job fromMap(Map map) {
    return new Job(
        id: map['id'],
        name: map['name'],
        cname: map['cname'],
        salary: map['salary'],
        username: map['username'],
        title: map['title'],
        pubTime: map['pubTime'],
        addrDetail: map['addrDetail'],
        province: map['province'],
        city: map['city'],
        area: map['area'],
        timereq: map['timereq'],
        academic: map['academic'],
        detail: map['detail'],
        companyId: map['companyId']
    );
  }
}
