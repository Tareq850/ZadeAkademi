import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myplatform/management/addstu.dart';
import 'package:myplatform/pages/settings.dart';
import 'package:myplatform/student/myreq.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../courses.dart';
import '../management/conferances.dart';
import '../management/request.dart';
import '../management/sendmessage.dart';
import '../management/student.dart';
import '../management/teacher.dart';
import '../provider.dart';
import '../search.dart';
import '../student/notifications.dart';
import '../teacher/mycourse.dart';
import 'package:new_version/new_version.dart';
class HomePage extends StatefulWidget{
  HomePage(this.user, {super.key});
  User user;
  @override
  State<StatefulWidget> createState() {
    return StateHomePage();
  }
}
class StateHomePage extends State<HomePage>{
  final _random = Random();
  var username = "";
  String courseName = "";
  String title = "";
  initMessage() async{
    var message = await FirebaseMessaging.instance.getInitialMessage();
    if(message != null){
      Navigator.of(context).pushNamed('home');
    }
  }
  requestPermission() async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    Text(' منح المستخدم الإذن: ${settings.authorizationStatus}');
  }
  basicStatusCheck(NewVersion newVersion) {
    newVersion.showAlertIfNecessary(context: context);
  }
  advancedStatusCheck(NewVersion newVersion) async {
    final status = await newVersion.getVersionStatus();
    if (status != null) {
      debugPrint(status.releaseNotes);
      debugPrint(status.appStoreLink);
      debugPrint(status.localVersion);
      debugPrint(status.storeVersion);
      debugPrint(status.canUpdate.toString());
      // ignore: use_build_context_synchronously
      newVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        dialogTitle: 'نسخة قديمة',
        dialogText: 'عليك تحديث التطبيق الى أحدث اصدار متوفر لضمان تحقيق جميع المتطلبات',
        updateButtonText: 'تحديث',
        dismissButtonText: 'لاحقاً',
        allowDismissal: false
      );
    }
  }
  @override
  void initState() {
    final newVersion = NewVersion(
      iOSId: 'com.google.Vespa',
      androidId: 'com.google.android.apps.cloudconsole',
    );
    advancedStatusCheck(newVersion);
    basicStatusCheck(newVersion);
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      Navigator.of(context).pushNamed('home');
    });
    initMessage();
    requestPermission();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var Prov = Provider.of<AuthP>(context);
    if (kIsWeb){
      return Prov.user.emailVerified ? Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Scaffold(
              appBar: AppBar(
                title: Text("ايثار التعليمية"),
                centerTitle: true,
                backgroundColor: Theme.of(context).colorScheme.primary,
                actions: [
                  IconButton(onPressed: (){
                    if (Prov.isManager == true){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Requests()));
                    }
                    else {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => NotificationsPage()));
                    }
                  },
                    icon: const Icon(FontAwesomeIcons.solidBell),),
                  IconButton(onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Search(username)));
                  },
                    icon: const Icon(FontAwesomeIcons.magnifyingGlass),),
                ],
              ),
              drawer: Drawer(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FutureBuilder(
                          future: Prov.users.where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get(),
                          builder: (context, snapshot){
                            if (snapshot.hasError) {
                              return Center(
                                child: Text("حدث خطأ ما. يُرجى إعادة تشغيل التطبيق."),
                              );
                            }
                            if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting){
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.hasData){
                              return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data?.docs.length,
                                  itemBuilder: (context, i){
                                    username = snapshot.data?.docs[i]['name'];
                                    if(snapshot.data?.docs[i]['type'] == "مدير"){
                                      Prov.setIsManager(true);
                                      return  Column(
                                        children: [
                                          UserAccountsDrawerHeader(
                                            accountName: Text("${snapshot.data?.docs[i]['name']?? ""}"),
                                            accountEmail: Text("${snapshot.data?.docs[i]['email']?? ""}"),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme.primary,
                                            ),
                                            currentAccountPicture: const Icon(FontAwesomeIcons.user, size: 50, color: Colors.white,),
                                          ),
                                          Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: ListTile(
                                              title: Text("الطلاب", style: TextStyle(color: Theme.of(context).colorScheme.primary,),),
                                              leading: Icon(FontAwesomeIcons.graduationCap, color: Theme.of(context).colorScheme.primary,),
                                              onTap: (){
                                                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                                  return Student(snapshot.data?.docs[i].data(), snapshot.data?.docs[i].id);
                                                }));
                                              },
                                            ),
                                          ),
                                          Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: ListTile(
                                              title: Text("الاساتذة", style: TextStyle(color: Theme.of(context).colorScheme.primary,),),
                                              leading: Icon(FontAwesomeIcons.personChalkboard, color : Theme.of(context).colorScheme.primary,),
                                              onTap: (){
                                                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                                  return Teatcher(snapshot.data?.docs[i].data(), snapshot.data?.docs[i].id);
                                                }));
                                              },
                                            ),
                                          ),
                                          Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: ListTile(
                                              title: Text("إضافة كورس", style: TextStyle(color: Theme.of(context).colorScheme.primary,),),
                                              leading: Icon(FontAwesomeIcons.circlePlus, color: Theme.of(context).colorScheme.primary,),
                                              onTap: (){
                                                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                                  return AddStudent(snapshot.data?.docs[i].data(), snapshot.data?.docs[i].id);
                                                }));
                                              },
                                            ),
                                          ),
                                          Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: ListTile(
                                              title: Text("إرسال إشعار", style: TextStyle(color: Theme.of(context).colorScheme.primary,),),
                                              leading: Icon(FontAwesomeIcons.solidPaperPlane, color: Theme.of(context).colorScheme.primary,),
                                              onTap: (){
                                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                                                  return SendNotification(snapshot.data?.docs[i].data(), snapshot.data?.docs[i].id);
                                                }));
                                              },
                                            ),
                                          ),
                                          Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: ListTile(
                                              title: Text("الجلسات", style: TextStyle(color: Theme.of(context).colorScheme.primary,),),
                                              leading: Icon(FontAwesomeIcons.table, color: Theme.of(context).colorScheme.primary,),
                                              onTap: (){
                                                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                                  return Conferances(snapshot.data?.docs[i].data(), snapshot.data?.docs[i].id);
                                                }));
                                              },
                                            ),
                                          ),
                                          Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: ListTile(
                                              title: Text("الاعدادات", style: TextStyle(color: Theme.of(context).colorScheme.primary,),),
                                              leading: Icon(FontAwesomeIcons.gear, color: Theme.of(context).colorScheme.primary,),
                                              onTap: (){
                                                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                                  return SettingsPage(snapshot.data?.docs[i].data(), snapshot.data?.docs[i].id);
                                                }));
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                    if (snapshot.data!.docs[i]['type'] == "طالب"){
                                      Prov.setIsManager(false);
                                      return  Column(
                                        children: [
                                          UserAccountsDrawerHeader(
                                            accountName: Text(" الطالب: ${snapshot.data?.docs[i]['name']?? ""}"),
                                            accountEmail: Text("${snapshot.data?.docs[i]['email']?? ""}"),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme.primary,
                                            ),
                                            currentAccountPicture: const Icon(FontAwesomeIcons.user, size: 50, color: Colors.white,),
                                          ),
                                          Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: ListTile(
                                              title: Text("كورساتي", style: TextStyle(color: Theme.of(context).colorScheme.primary,),),
                                              leading: Icon(FontAwesomeIcons.chalkboardUser,color: Theme.of(context).colorScheme.primary,),
                                              onTap: (){
                                                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                                  return MyReq(snapshot.data?.docs[i].data(), snapshot.data?.docs[i].id);
                                                }));
                                              },
                                            ),
                                          ),
                                          Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: ListTile(
                                              title: Text("الجلسات", style: TextStyle(color: Theme.of(context).colorScheme.primary,),),
                                              leading: Icon(Icons.mode, color: Theme.of(context).colorScheme.primary,),
                                              onTap: (){
                                                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                                  return Conferances(snapshot.data?.docs[i].data(), snapshot.data?.docs[i].id);
                                                }));
                                              },
                                            ),
                                          ),
                                          Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: ListTile(
                                              title: Text("الاعدادات", style: TextStyle(color: Theme.of(context).colorScheme.primary,),),
                                              leading: Icon(FontAwesomeIcons.gear, color: Theme.of(context).colorScheme.primary,),
                                              onTap: (){
                                                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                                  return SettingsPage(snapshot.data?.docs[i].data(), snapshot.data?.docs[i].id);
                                                }));
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                    if (snapshot.data!.docs[i]['type'] == "معلم"){
                                      Prov.setIsManager(false);
                                      return  Column(
                                        children: [
                                          UserAccountsDrawerHeader(
                                            accountName: Text(" الاستاذ:  ${snapshot.data?.docs[i]['name']?? ""}"),
                                            accountEmail: Text("${snapshot.data?.docs[i]['email']?? ""}"),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme.primary,
                                            ),
                                            currentAccountPicture: const Icon(FontAwesomeIcons.user, size: 50, color: Colors.white,),
                                          ),
                                          Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: ListTile(
                                              title: Text("كورساتي", style: TextStyle(color: Theme.of(context).colorScheme.primary,),),
                                              leading: Icon(FontAwesomeIcons.chalkboardUser, color: Theme.of(context).colorScheme.primary,),
                                              onTap: (){
                                                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                                  return MyCourse(snapshot.data?.docs[i].data(), snapshot.data?.docs[i].id);
                                                }));
                                              },
                                            ),
                                          ),
                                          Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: ListTile(
                                              title: Text("الجلسات", style: TextStyle(color: Theme.of(context).colorScheme.primary,),),
                                              leading: Icon(Icons.mode, color: Theme.of(context).colorScheme.primary,),
                                              onTap: (){
                                                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                                  return Conferances(snapshot.data?.docs[i].data(), snapshot.data?.docs[i].id);
                                                }));
                                              },
                                            ),
                                          ),
                                          Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: ListTile(
                                              title: Text("الاعدادات", style: TextStyle(color: Theme.of(context).colorScheme.primary,),),
                                              leading: Icon(FontAwesomeIcons.gear, color: Theme.of(context).colorScheme.primary,),
                                              onTap: (){
                                                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                                  return SettingsPage(snapshot.data?.docs[i].data(), snapshot.data?.docs[i].id);
                                                }));
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                    return null;
                                  });
                            }
                            return const Center(child: CircularProgressIndicator());
                          },
                        ),
                        const SizedBox(height: 40,),
                        Directionality(textDirection: TextDirection.rtl,
                          child: ListTile(
                            title: Text("تسجيل الخروج", style: TextStyle(color: Theme.of(context).colorScheme.primary,),),
                            leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.primary,),
                            onTap: (){
                              AwesomeDialog(
                                context: context,
                                width: 400,
                                title: "تأكيد تسجيل الخروج",
                                desc: 'هل انت متأكد من رغبتك في تسجيل الخروج؟',
                                dialogType: DialogType.warning,
                                animType: AnimType.rightSlide,
                                autoHide: const Duration(seconds: 60),
                                btnCancelOnPress: (){
                                  Navigator.of(context).pop(context);
                                },
                                btnCancelColor: Theme.of(context).colorScheme.error,
                                btnCancelText: "لا",
                                btnOkOnPress: () async {
                                  await Prov.logout(context);
                                  // Navigator.of(context).pushReplacementNamed('login');
                                },
                                btnOkColor: Theme.of(context).colorScheme.primary,
                                btnOkText: "نعم",
                                buttonsTextStyle: const TextStyle(color: Colors.white),
                              ).show();
                            },
                          ),)
                      ],
                    ),
                  ),
                ),
              ),
              body:
              Directionality(
                textDirection: TextDirection.rtl,
                child: RefreshIndicator(
                  onRefresh: () {
                    return Navigator.of(context).pushReplacementNamed('home');
                  },
                  child: StreamBuilder(
                    stream: Prov.course.orderBy('status', descending: true).snapshots(includeMetadataChanges: true),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: Text("لا يوجد بيانات لعرضها"));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.data?.docs.isEmpty ?? true) {
                        return const Center(child: Text("لا يوجد بيانات لعرضها"));
                      }
                      if (snapshot.hasError) {
                        AwesomeDialog(
                          context: context,
                          width: 600,
                          title: "خطأ",
                          desc: 'حصل خطأ ما أثناء جلب البيانات',
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          autoHide: const Duration(seconds: 10),
                        ).show();
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, i) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                return Viewss(snapshot.data?.docs[i].data(), snapshot.data?.docs[i].id, username);
                              }));
                            },
                            child: Container(
                              margin: const EdgeInsets.all(25),
                              width: 400, // تحديد العرض المطلوب بناءً على احتياجات التصميم
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromARGB(500, _random.nextInt(100),
                                    _random.nextInt(100), _random.nextInt(120)),
                              ),
                              child: Row( // استخدام Row لترتيب الصورة والنص جنبًا إلى جنب
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(10),
                                    width: 100, // تحديد عرض الصورة المطلوب
                                    height: 250, // تحديد ارتفاع الصورة المطلوب
                                    child: Image.network(
                                      '${snapshot.data?.docs[i]['imgurl'] ?? ""}',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Expanded( // استخدام Expanded لتعبئة المساحة المتبقية بالنصوص
                                    child: ListTile(
                                      title: Text(
                                        "اسم الدورة : ${snapshot.data?.docs[i]['course_name'] ?? ""}",
                                        style: const TextStyle(color: Colors.white, fontSize: 18),
                                      ),
                                      subtitle: Text(
                                        "عدد الساعات : ${snapshot.data?.docs[i]['houres'] ?? ""}",
                                        style: const TextStyle(color: Colors.white, fontSize: 14),
                                      ),
                                      trailing: Text(
                                        "السعر:  ${snapshot.data?.docs[i]['price'] ?? ""}",
                                        style: const TextStyle(color: Colors.white, fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )

                          );
                        },
                      );
                    },
                  ),
                ),
              )
          ),
        ),
      ):Scaffold(
        body: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(child: Text("يجب تأكيد البريد الإلكتروني أولاً.",)),
                SizedBox(height: 20,),
                MaterialButton(
                  onPressed: () async {
                    await Prov.logout(context);
                  },
                  color: Theme.of(context).colorScheme.error,
                  child: const Text('تم التحقق من الايميل', style: TextStyle(color: Colors.white),),
                )
              ],
            )
        ),
      );
    }
    else {
      return Prov.user.emailVerified ? Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text("منصة طريق النجاح"),
              centerTitle: true,
              backgroundColor: Theme.of(context).colorScheme.primary,
              actions: [
                IconButton(onPressed: (){
                  if (Prov.isManager == true){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Requests()));
                  }
                  else {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => NotificationsPage()));
                  }
                },
                  icon: const Icon(FontAwesomeIcons.solidBell),),
                IconButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Search(username)));
                },
                  icon: const Icon(FontAwesomeIcons.magnifyingGlass),),
              ],
            ),
            drawer: Drawer(
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FutureBuilder(
                        future: Prov.users.where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get(),
                        builder: (context, snapshot){
                          if (snapshot.hasError) {
                            AwesomeDialog(
                              context: context,
                              width: 400,
                              title: "حدث خطأ ما",
                              dialogType: DialogType.error,
                              body: const Text("يرجى إعادة تشغيل التطبيق"),
                              showCloseIcon: true,
                              autoHide: const Duration(seconds: 10),
                            ).show();
                          }
                          if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting){
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasData){
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data?.docs.length,
                                itemBuilder: (context, i){
                                  username = snapshot.data?.docs[i]['name'];
                                  if(snapshot.data?.docs[i]['type'] == "مدير"){
                                    Prov.setIsManager(true);
                                    FirebaseMessaging.instance.unsubscribeFromTopic('teacher');
                                    FirebaseMessaging.instance.unsubscribeFromTopic('student');
                                    FirebaseMessaging.instance.subscribeToTopic('manager');
                                    return  Column(
                                      children: [
                                        UserAccountsDrawerHeader(
                                          accountName: Text("${snapshot.data?.docs[i]['name']?? ""}"),
                                          accountEmail: Text("${snapshot.data?.docs[i]['email']?? ""}"),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                          currentAccountPicture: const Icon(FontAwesomeIcons.user, size: 50, color: Colors.white,),
                                        ),
                                        Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: ListTile(
                                            title: Text("الطلاب", style: TextStyle(color: Theme.of(context).colorScheme.primary,),),
                                            leading: Icon(FontAwesomeIcons.graduationCap, color: Theme.of(context).colorScheme.primary,),
                                            onTap: (){
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                                return Student(snapshot.data?.docs[i].data(), snapshot.data?.docs[i].id);
                                              }));
                                            },
                                          ),
                                        ),
                                        Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: ListTile(
                                            title: Text("الاساتذة", style: TextStyle(color: Theme.of(context).colorScheme.primary,),),
                                            leading: Icon(FontAwesomeIcons.personChalkboard, color : Theme.of(context).colorScheme.primary,),
                                            onTap: (){
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                                return Teatcher(snapshot.data?.docs[i].data(), snapshot.data?.docs[i].id);
                                              }));
                                            },
                                          ),
                                        ),
                                        Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: ListTile(
                                            title: Text("إضافة كورس", style: TextStyle(color: Theme.of(context).colorScheme.primary,),),
                                            leading: Icon(FontAwesomeIcons.circlePlus, color: Theme.of(context).colorScheme.primary,),
                                            onTap: (){
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                                return AddStudent(snapshot.data?.docs[i].data(), snapshot.data?.docs[i].id);
                                              }));
                                            },
                                          ),
                                        ),
                                        Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: ListTile(
                                            title: Text("إرسال إشعار", style: TextStyle(color: Theme.of(context).colorScheme.primary,),),
                                            leading: Icon(FontAwesomeIcons.solidPaperPlane, color: Theme.of(context).colorScheme.primary,),
                                            onTap: (){
                                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                                                return SendNotification(snapshot.data?.docs[i].data(), snapshot.data?.docs[i].id);
                                              }));
                                            },
                                          ),
                                        ),
                                        Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: ListTile(
                                            title: Text("الجلسات", style: TextStyle(color: Theme.of(context).colorScheme.primary,),),
                                            leading: Icon(FontAwesomeIcons.table, color: Theme.of(context).colorScheme.primary,),
                                            onTap: (){
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                                return Conferances(snapshot.data?.docs[i].data(), snapshot.data?.docs[i].id);
                                              }));
                                            },
                                          ),
                                        ),
                                        Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: ListTile(
                                            title: Text("الاعدادات", style: TextStyle(color: Theme.of(context).colorScheme.primary,),),
                                            leading: Icon(FontAwesomeIcons.gear, color: Theme.of(context).colorScheme.primary,),
                                            onTap: (){
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                                return SettingsPage(snapshot.data?.docs[i].data(), snapshot.data?.docs[i].id);
                                              }));
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  if (snapshot.data!.docs[i]['type'] == "طالب"){
                                    Prov.setIsManager(false);
                                    FirebaseMessaging.instance.unsubscribeFromTopic('manager');
                                    FirebaseMessaging.instance.unsubscribeFromTopic('teacher');
                                    FirebaseMessaging.instance.subscribeToTopic('student');
                                    return  Column(
                                      children: [
                                        UserAccountsDrawerHeader(
                                          accountName: Text(" الطالب: ${snapshot.data?.docs[i]['name']?? ""}"),
                                          accountEmail: Text("${snapshot.data?.docs[i]['email']?? ""}"),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                          currentAccountPicture: const Icon(FontAwesomeIcons.user, size: 50, color: Colors.white,),
                                        ),
                                        Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: ListTile(
                                            title: Text("كورساتي", style: TextStyle(color: Theme.of(context).colorScheme.primary,),),
                                            leading: Icon(FontAwesomeIcons.chalkboardUser,color: Theme.of(context).colorScheme.primary,),
                                            onTap: (){
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                                return MyReq(snapshot.data?.docs[i].data(), snapshot.data?.docs[i].id);
                                              }));
                                            },
                                          ),
                                        ),
                                        Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: ListTile(
                                            title: Text("الجلسات", style: TextStyle(color: Theme.of(context).colorScheme.primary,),),
                                            leading: Icon(Icons.mode, color: Theme.of(context).colorScheme.primary,),
                                            onTap: (){
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                                return Conferances(snapshot.data?.docs[i].data(), snapshot.data?.docs[i].id);
                                              }));
                                            },
                                          ),
                                        ),
                                        Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: ListTile(
                                            title: Text("الاعدادات", style: TextStyle(color: Theme.of(context).colorScheme.primary,),),
                                            leading: Icon(FontAwesomeIcons.gear, color: Theme.of(context).colorScheme.primary,),
                                            onTap: (){
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                                return SettingsPage(snapshot.data?.docs[i].data(), snapshot.data?.docs[i].id);
                                              }));
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  else{
                                    Prov.setIsManager(false);
                                    FirebaseMessaging.instance.unsubscribeFromTopic('student');
                                    FirebaseMessaging.instance.unsubscribeFromTopic('manager');
                                    FirebaseMessaging.instance.subscribeToTopic('teacher');
                                    return  Column(
                                      children: [
                                        UserAccountsDrawerHeader(
                                          accountName: Text(" الاستاذ:  ${snapshot.data?.docs[i]['name']?? ""}"),
                                          accountEmail: Text("${snapshot.data?.docs[i]['email']?? ""}"),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                          currentAccountPicture: const Icon(FontAwesomeIcons.user, size: 50, color: Colors.white,),
                                        ),
                                        Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: ListTile(
                                            title: Text("دوراتي", style: TextStyle(color: Theme.of(context).colorScheme.primary,),),
                                            leading: Icon(FontAwesomeIcons.chalkboardUser, color: Theme.of(context).colorScheme.primary,),
                                            onTap: (){
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                                return MyCourse(snapshot.data?.docs[i].data(), snapshot.data?.docs[i].id);
                                              }));
                                            },
                                          ),
                                        ),
                                        Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: ListTile(
                                            title: Text("الجلسات", style: TextStyle(color: Theme.of(context).colorScheme.primary,),),
                                            leading: Icon(Icons.mode, color: Theme.of(context).colorScheme.primary,),
                                            onTap: (){
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                                return Conferances(snapshot.data?.docs[i].data(), snapshot.data?.docs[i].id);
                                              }));
                                            },
                                          ),
                                        ),
                                        Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: ListTile(
                                            title: Text("الاعدادات", style: TextStyle(color: Theme.of(context).colorScheme.primary,),),
                                            leading: Icon(FontAwesomeIcons.gear, color: Theme.of(context).colorScheme.primary,),
                                            onTap: (){
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                                return SettingsPage(snapshot.data?.docs[i].data(), snapshot.data?.docs[i].id);
                                              }));
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                });
                          }
                          return const Center(child: CircularProgressIndicator());
                        },
                      ),
                      const SizedBox(height: 40,),
                      Directionality(textDirection: TextDirection.rtl,
                        child: ListTile(
                          title: Text("تسجيل الخروج", style: TextStyle(color: Theme.of(context).colorScheme.primary,),),
                          leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.primary,),
                          onTap: (){
                            AwesomeDialog(
                              context: context,
                              width: 400,
                              title: "تأكيد تسجيل الخروج",
                              desc: 'هل انت متأكد من رغبتك في تسجيل الخروج؟',
                              dialogType: DialogType.warning,
                              animType: AnimType.rightSlide,
                              autoHide: const Duration(seconds: 60),
                              btnCancelOnPress: (){
                                Navigator.of(context).pop(context);
                              },
                              btnCancelColor: Theme.of(context).colorScheme.error,
                              btnCancelText: "لا",
                              btnOkOnPress: () async {
                                await Prov.logout(context);
                               // Navigator.of(context).pushReplacementNamed('login');
                              },
                              btnOkColor: Theme.of(context).colorScheme.primary,
                              btnOkText: "نعم",
                              buttonsTextStyle: const TextStyle(color: Colors.white),
                            ).show();
                          },
                        ),)
                    ],
                  ),
                ),
              ),
            ),
            body:
            Directionality(
              textDirection: TextDirection.rtl,
              child: RefreshIndicator(
                onRefresh: () {
                  return Navigator.of(context).pushReplacementNamed('home');
                },
                child: StreamBuilder(
                  stream: Prov.course.orderBy('status', descending: true).snapshots(includeMetadataChanges: true),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: Text("لا يوجد بيانات لعرضها"));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.data?.docs.isEmpty ?? true) {
                      return const Center(child: Text("لا يوجد بيانات لعرضها"));
                    }
                    if (snapshot.hasError) {
                      AwesomeDialog(
                        context: context,
                        width: 400,
                        title: "خطأ",
                        desc: 'حصل خطأ ما أثناء جلب البيانات',
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        autoHide: const Duration(seconds: 10),
                      ).show();
                    }
                    return ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, i) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                              return Viewss(snapshot.data?.docs[i].data(), snapshot.data?.docs[i].id, username);
                            }));
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color.fromARGB(500, _random.nextInt(100),
                                  _random.nextInt(100), _random.nextInt(120)),
                            ),
                            child: Wrap(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  child: Image.network('${snapshot.data?.docs[i]['imgurl']?? ""}',fit: BoxFit.cover, width: double.maxFinite, height: 150,),
                                ),
                                ListTile(
                                  title: Text("اسم الدورة : ${snapshot.data?.docs[i]['course_name']?? ""} ",style: const TextStyle(color: Colors.white, fontSize: 18), ),
                                  subtitle: Text("عدد الساعات : ${snapshot.data?.docs[i]['houres']?? ""}",style: const TextStyle(color: Colors.white, fontSize: 14),),
                                  trailing: Text(" السعر:  ${snapshot.data?.docs[i]['price']?? ""}",style: const TextStyle(color: Colors.white, fontSize: 18),),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            )
        ),
      ),
    ): Scaffold(
      body: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(child: Text("يجب تأكيد البريد الإلكتروني أولاً.",)),
              SizedBox(height: 20,),
              MaterialButton(
                onPressed: () async {
                  await Prov.logout(context);
                },
                color: Theme.of(context).colorScheme.error,
                child: const Text('تم التحقق من الايميل', style: TextStyle(color: Colors.white),),
              )
            ],
          )
      ),
    );
    }
  }
}
