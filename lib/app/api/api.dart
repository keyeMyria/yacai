import 'package:dio/dio.dart';
import 'dart:io';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/app/model/app.dart';
class Api {
  final String serverAddr = Platform.isAndroid ? "http://192.168.140.56:3000/api/" : "http://localhost:3000/api/";

  Future<Response<T>> getResumeList<T>(String userName, int jobId) {
    String url = '${serverAddr}user/getResumeList?userName=$userName';
    if (jobId != null) {
      url += '&jobId=$jobId';
    }
    return Dio().get(url);
  }

  Future<Response<T>> getJobList<T>(int type, String userName) {
    return Dio().get('${serverAddr}jobs/jobsList?type=$type&userName=$userName');
  }

  Future<Response<T>> getRecruitJobList<T>(String userName) {
    return Dio().get(serverAddr + "jobs/getRecruitJobList?userName=$userName");
  }

  Future<Response<T>> getPostList<T>() {
    return Dio().get(serverAddr + "post/query");
  }

  Future<Response<T>> getCompanyDetail<T>(int companyId) {
    return Dio().get(serverAddr + "company/query?id=" + companyId.toString());
  }

  Future<Response<T>> login<T>(String account, String pwd) {
    return Dio().get(serverAddr + "user/login?account=" + account + "&pwd=" + pwd);
  }

  Future<Response<T>> register<T>(String account, String pwd, int role) {
    return Dio().get(serverAddr + "user/register?account=$account&pwd=$pwd&role=$role");
  }

  Future<Response<T>> getUserInfo<T>(int id) {
    return Dio().get(serverAddr + "user/query?id=" + id.toString());
  }

  Future<Response<T>> getCompanyInfo<T>(int id) {
    return Dio().get(serverAddr + "user/getCompanyInfo?id=" + id.toString());
  }

  Future<Response<T>> addPost<T>(String askedBy, String title, String detail) {
    return Dio().get(serverAddr + "post/addPost?askedBy=" + askedBy + "&title=" + title + "&detail=" + detail);
  }

  Future<Response<T>> addAnswer<T>(String detail, String answerBy, int postId, ) {
    return Dio().get(serverAddr + "post/addAnswer?answerBy=" + answerBy + "&postId=" + postId.toString() + "&answer=" + detail);
  }

  Future<Response<T>> deliver<T>(String userName, int jobId, ) {
    return Dio().post('${serverAddr}jobs/deliver', data: {
        'userName': userName,
        'jobId': jobId,
      }
    );
  }

  Future<Response<T>> favorite<T>(String userName, int jobId, bool favorite) {
    return Dio().post('${serverAddr}jobs/favorite', data: {
        'userName': userName,
        'jobId': jobId,
        'favorite':favorite
      }
    );
  }

  Future<Response<T>> saveCompanyInfo<T>(
    String name,
    String province,
    String city,
    String area,
    String location,
    String type,
    String employee,
    String inc,
    String logo,
    String userName,
    int id
  ) {
    String url = '${serverAddr}company/saveCompanyInfo?name=$name&logo=$logo&province=$province&city=$city&area=$area&location=$location&type=$type&employee=$employee&inc=$inc&userName=$userName';
    if(id != null) {
      url += '&id=${id.toString()}';
    }
    return Dio().get(url);
  }

  Future<Response<T>> saveJobs<T>(
    String name,
    String cname,
    String salary,
    String province,
    String city,
    String area,
    String addrDetail,
    String timereq,
    String academic,
    String detail,
    int type,
    int companyId,
    String userName,
  ) {
    // String url = '${serverAddr}jobs/saveJobs?name=$name&cname=$cname&type=$type&companyId=$companyId&salary=$salary&province=$province&city=$city&area=$area&addrDetail=$addrDetail&timereq=$timereq&academic=$academic&detail=$detail&userName=$userName';
    return Dio().post('${serverAddr}jobs/saveJobs', data: {
        'name': name,
        'cname': cname,
        'salary': salary,
        'province': province,
        'city': city,
        'area': area,
        'addrDetail': addrDetail,
        'timereq': timereq,
        'academic': academic,
        'detail': detail,
        'type': type,
        'companyId': companyId,
        'userName': userName,
      }
    );
  }

  Future<Response<T>> savePersonalInfo<T>(
    String name,
    String gender,
    String firstJobTime,
    String wechatId,
    String birthDay,
    String summarize,
    String avatar,
    String userName
  ) {
    return Dio().get('${serverAddr}user/addUser?name=${name}&avatar=$avatar&gender=${gender}&firstJobTime=${firstJobTime}&wechatId=${wechatId}&birthDay=${birthDay}&summarize=${summarize}&userName=$userName');
  }

  Future<Response<T>> saveJobExpectation<T>(
    String jobTitle,
    String industry,
    String city,
    String salary,
    int type,
    String userName
  ) {
    return Dio().get('${serverAddr}user/addUser?jobTitle=${jobTitle}&industry=${industry}&city=$city&type=$type&salary=${salary}&userName=$userName');
  }

  Future<Response<T>> saveCompanyExperience<T>(
    String cname,
    String jobTitle,
    String startTime,
    String endTime,
    String detail,
    String performance,
    String userName,
    int id
  ) {
    String url = '${serverAddr}user/saveCompanyExperience?cname=${cname}&jobTitle=${jobTitle}&startTime=${startTime}&detail=${detail}&performance=${performance}&userName=$userName';
    if(endTime != null) {
      url += '&endTime=$endTime';
    }
    if(id != null) {
      url += '&id=$id';
    }
    return Dio().get(url);
  }

  Future<Response<T>> saveProject<T>(
    String name,
    String role,
    String startTime,
    String endTime,
    String detail,
    String performance,
    String userName,
    int id
  ) {
    String url = '${serverAddr}user/saveProject?name=${name}&role=${role}&startTime=${startTime}&detail=${detail}&performance=${performance}&userName=$userName';
    if(endTime != null) {
      url += '&endTime=$endTime';
    }
    if(id != null) {
      url += '&id=$id';
    }
    return Dio().get(url);
  }

  Future<Response<T>> saveEducation<T>(
    String name,
    int academic,
    String major,
    String startTime,
    String endTime,
    String detail,
    String userName,
    int id
  ) {
    String url = '${serverAddr}user/saveEducation?name=${name}&academic=${academic}&startTime=${startTime}&detail=${detail}&major=${major}&userName=$userName';
    if(endTime != null) {
      url += '&endTime=${endTime}';
    }
    if(id != null) {
      url += '&id=${id}';
    }
    return Dio().get(url);
  }

  Future<Response<T>> saveCertification<T>(
    String name,
    String industry,
    String code,
    String qualifiedTime,
    String userName,
    int id
  ) {
    String url = '${serverAddr}user/saveCertification?name=${name}&industry=${industry}&qualifiedTime=${qualifiedTime}&code=${code}&userName=$userName';
    if(id != null) {
      url += '&id=${id}';
    }
    return Dio().get(url);
  }

  Future<Response<T>> upload<T>(File file, String fileName) {
    FormData formData = new FormData.from({
      "file": new UploadFileInfo(file, fileName)
    });
    return Dio().post(serverAddr + "upload/uploadFile", data: formData);
  }
  
}