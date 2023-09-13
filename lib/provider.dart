


import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

enum AuthStatus{
  unAuthenticated,
  authenticating,
  authenticated,
}

class AuthP extends ChangeNotifier{
  User? profile = FirebaseAuth.instance.currentUser;       //return current user
  CollectionReference users = FirebaseFirestore.instance.collection('students');//return colomn from data base
  CollectionReference course = FirebaseFirestore.instance.collection('courses');
  CollectionReference student = FirebaseFirestore.instance.collection('student');
  CollectionReference conferance = FirebaseFirestore.instance.collection('conferance');
  CollectionReference exam = FirebaseFirestore.instance.collection('exam');
  final CollectionReference notificationsCollection = FirebaseFirestore.instance.collection('Notifications');
  late FirebaseAuth _auth;
  late User _user;
  AuthStatus _authStatus = AuthStatus.unAuthenticated;
  String? errorMessag;
  String tok = "";
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String ver = "راجع بريدك لاثبات ملكية الحساب";
  bool isEmailVerified = true;
  bool _isManager = false;
  bool get isManager => _isManager;
  void setIsManager(bool value) {
    _isManager = value;
  }
  AuthP(){
    _auth = FirebaseAuth.instance;
    // var user = FirebaseAuth.instance.currentUser;
    _auth.authStateChanges().listen((User? user) {
      if(user == null){
        _authStatus = AuthStatus.unAuthenticated;
      }else{
        _user = user;
        _authStatus = AuthStatus.authenticated;
      }
      notifyListeners();
    });
  }
  AuthStatus get authStatus => _authStatus;
  User get user => _user;

  Future<bool> login(String email, String Password) async{
    //messaging.getToken();
    bool x = false;
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: Password,
      );
      _authStatus = AuthStatus.authenticating;
      if (credential.user!.emailVerified==false){
        await profile?.sendEmailVerification();
        isEmailVerified = false;
      }
      else {
        isEmailVerified = true;
      }
      x = true;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errorMessag = "المستخدم غير موجود";
      } else if (e.code == 'wrong-password') {
        errorMessag = "كلمة السر غير صحيحة";
      }
      x = false;
      notifyListeners();

    } catch (e) {
      errorMessag = "$e";}
    notifyListeners();
    return x;
  }


  logout(context) async{
    try {
      await _auth.signOut();
      _authStatus = AuthStatus.unAuthenticated;
      Navigator.of(context).pushReplacementNamed('login');
      print("تم تسجيل الخروج بنجاح");
    } catch (e) {
      print("حدث خطأ أثناء تسجيل الخروج: $e");
    }
    notifyListeners();
  }

  signup(String Email, String Password) async{
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: Email,
          password: Password
      );
      if(!_user.emailVerified){
        await user.sendEmailVerification();
        isEmailVerified = false;
      }
      else {
        isEmailVerified = true;
      }
    }
    on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        errorMessag = 'كلمة المرور ضعيفة';
      } else if (e.code == 'email-already-in-use') {
        errorMessag = 'الايميل مسجل سابقاً';
      }
    } catch (e) {
      errorMessag = e.toString();
    }
    notifyListeners();
  }


  add(String email, String name, String type) async{
    await messaging.getToken().then((value) {
      tok = value!;
    });
    _authStatus = AuthStatus.authenticated;
    await users.add({
      'email' : email,
      'name' : name,
      'token' : tok.toString(),
      'userId': _auth.currentUser!.uid,
      'type' : type,
    });
    notifyListeners();
  }
  add_Courses(String c_name, String te_name, String price, String numclass, bool stat, String imgurl ) async {
    _authStatus = AuthStatus.authenticated;
    await course.add({
      'course_name' : c_name,
      'teatcher_name' : te_name,
      'price' : price,
      'houres': numclass,
      'status' : stat,
      'imgurl' : imgurl
    });
    notifyListeners();
  }
  add_Courses_Ac(String c_name, String te_name, String price, String numclass, bool stat, String imgurl, start, end, num ) async {
    _authStatus = AuthStatus.authenticated;
    await course.add({
      'course_name' : c_name,
      'teatcher_name' : te_name,
      'price' : price,
      'houres': numclass,
      'status' : stat,
      'imgurl' : imgurl,
      'startdate':start,
      'enddate':end,
      "number_days": num,
    });
    notifyListeners();
  }


  username() async{
    var x = await users.where("userId", isEqualTo: profile!.uid).get();
    notifyListeners();
    return x;
  }

  updateCourseWithAll(String c_name, String te_name, String price, String numclass, bool stat, String imgurl, String id, start, end, num) async{
    await course.doc(id).update({
      'course_name' : c_name,
      'teatcher_name' : te_name,
      'price' : price,
      'houres': numclass,
      'status' : stat,
      'imgurl' : imgurl,
      'startdate':start,
      'enddate':end,
      "number_days": num,
    });
    notifyListeners();
  }
  updateCourse(String c_name, String te_name, String price, String numclass, bool stat, String id, start, end, num) async{
    await course.doc(id).update({
      'course_name' : c_name,
      'teatcher_name' : te_name,
      'price' : price,
      'houres': numclass,
      'status' : stat,
      'startdate':start,
      'enddate':end,
      "number_days": num,
    });
    notifyListeners();
  }
  updateCourseWithImg(String c_name, String te_name, String price, String numclass, bool stat, String imgurl, String id) async{
    await course.doc(id).update({
      'course_name' : c_name,
      'teatcher_name' : te_name,
      'price' : price,
      'houres': numclass,
      'status' : stat,
      'imgurl' : imgurl,
    });
    notifyListeners();
  }
  updateCourseWithoutAll(String c_name, String te_name, String price, String numclass, bool stat, String id) async{
    await course.doc(id).update({
      'course_name' : c_name,
      'teatcher_name' : te_name,
      'price' : price,
      'houres': numclass,
      'status' : stat,
    });
    notifyListeners();
  }
  deleteCourse(courseName, id, String url) async{
    await course.doc(id).delete();
    await FirebaseStorage.instance.refFromURL(url).delete();
    final studentsToDelete = await student.where("course_name", isEqualTo: courseName).get();
    for (final studentDoc in studentsToDelete.docs) {
      await studentDoc.reference.delete();
    }
    final confToDelete = await conferance.where("course_name", isEqualTo: courseName).get();
    for (final confDoc in confToDelete.docs) {
      await confDoc.reference.delete();
    }
    final notificationsToDelete = await notificationsCollection.where("topic", isEqualTo: courseName).get();
    for (final confDoc in notificationsToDelete.docs) {
      await confDoc.reference.delete();
    }
    notifyListeners();
  }
  updateStudent(id, birthDate, phone, country, String gender) async {
    await messaging.getToken().then((value) {
      tok = value!;
    });
    await users.doc(id).update(
        {
          'birthDate' : birthDate,
          'phone'     : phone,
          'country'   : country,
          'gender'    : gender,
          'token'     : tok,
          'userId': _auth.currentUser!.uid,
          'emailVerified' : ver
        });
    notifyListeners();
  }

  addStudents(String name ,String email, String type) async {
    await users.add({
      'email' : email,
      'name' : name,
      'userId': _auth.currentUser!.uid,
      'type' : type
    });
    notifyListeners();
  }
  updateType(String type, id) async{
    await users.doc(id).update({
      'type' : type,
    });
    notifyListeners();
  }
  regesterInCourse(id,String userId, name, email, birthDate, phone, country, String gender, course_name) async {
    await student.add({
      'userId' : userId,
      'name' : name,
      'email': email,
      'birthDate': birthDate,
      'phone': phone,
      'country': country,
      'gender': gender,
      'status': 'بانتظار الدفع',
      'course_name': course_name,
      'emailVerified' : ver
    });
    notifyListeners();
  }
  regesterUpCourse(id, String status) async {
    await student.doc(id).update({
      'status': status,
    });
    notifyListeners();
  }
  add_Exam(String c_name, String te_name, date, exam_url, result_url) async {
    _authStatus = AuthStatus.authenticated;
    await exam.add({
      'course_name' : c_name,
      'teatcher_name' : te_name,
      'date': date,
      'exam_url' : exam_url,
      'result_url' : result_url
    });
    notifyListeners();
  }
  update_Exam(id , date , exam_url, result_url) async {
    _authStatus = AuthStatus.authenticated;
    await exam.doc(id).update({
      'date': date,
      'exam_url' : exam_url,
      'result_url' : result_url
    });
    notifyListeners();
  }
  add_Confecance(String c_name, String te_name, start, end, date) async {
    _authStatus = AuthStatus.authenticated;
    await conferance.add({
      'course_name' : c_name,
      'teatcher_name' : te_name,
      'start' : start,
      'end': end,
      'date': date
    });
    notifyListeners();
  }
  update_Confecance(id ,String c_name, String te_name, start, end, date) async {
    _authStatus = AuthStatus.authenticated;
    await conferance.doc(id).update({
      'course_name' : c_name,
      'teatcher_name' : te_name,
      'start' : start,
      'end': end,
      'date': date
    });
    notifyListeners();
  }
  Future<void> deleteAccount() async {
    try {
      // يتم الحصول على معرّف المستخدم الحالي
        await _auth.currentUser?.delete();

        print('تم حذف الحساب بنجاح');
    } catch (e) {
      print('حدث خطأ أثناء حذف الحساب: $e');
    }
    _authStatus = AuthStatus.unAuthenticated;
    notifyListeners();
  }
  Future<void> resetPassword(email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('حدث خطأ أثناء إعادة تعيين كلمة المرور: $e');
    }
    notifyListeners();
  }
  Future<void> sendNotification(title, message, topic, time) async {
    await notificationsCollection.add({
      'title': title,
      'message': message,
      'topic': topic,
      'time': time,
    });
    notifyListeners();
  }
  deleteStuCourse(course) async{
    final studentsToDelete = await student.where("course_name", isEqualTo: course).get();
    for (final studentDoc in studentsToDelete.docs) {
      await studentDoc.reference.delete();
    }
    notifyListeners();
  }
}
