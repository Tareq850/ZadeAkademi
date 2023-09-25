import 'dart:io';

import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:myplatform/provider.dart';

class Check extends StatefulWidget {
  final country;
  final phone;
  final birthdate;
  final gender;
  final reg;
  final id;
  final username;
  final city;
  final address;
  final dadPhone;
  final student_status;
  final schoolName;
  Check(
      this.country,
      this.phone,
      this.birthdate,
      this.gender,
      this.reg,
      this.id,
      this.username,
      this.city,
      this.address,
      this.dadPhone,
      this.student_status,
      this.schoolName
      );

  @override
  State<StatefulWidget> createState() {
    return CheckState();
  }
}

class CheckState extends State<Check> {
  openWhatsApp({required String phoneNumber, required String message}) async{
    var whatsapp =phoneNumber;
    var whatsappURl_android = Uri.parse("whatsapp://send?phone=$whatsapp&text=$message");
    var whatappURL_ios = Uri.parse("https://wa.me/$whatsapp?text=${Uri.parse(message)}");
    if(Platform.isIOS){
      // for iOS phone only
      if( await canLaunchUrl(whatappURL_ios)){
        await launchUrl(whatappURL_ios);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("واتس اب غير مثبت")));
      }
    }else{
      // android , web
      if( await canLaunchUrl(whatsappURl_android)){
        await launchUrl(whatsappURl_android);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("واتس اب غير مثبت")));
      }
    }
  }
  var name;
  bool? status ;
  Future<void> _checkAndShowMessage(email, courseName) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('student')
        .where('email', isEqualTo: email).where('course_name', isEqualTo: courseName)
        .get();
    if (snapshot.docs.isNotEmpty) {
      status = false;
    } else {
      status = true;
    }
  }
  @override
  Widget build(BuildContext context) {
    var Prov = Provider.of<AuthP>(context);
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text(" دورة : ${widget.reg['course_name']}"),
            backgroundColor: Theme.of(context).colorScheme.primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                AwesomeDialog(
                  context: context,
                  width: 400,
                  btnOkText: "تأكيد",
                  btnOkColor: Theme.of(context).primaryColor,
                  btnOkOnPress: () {
                    Navigator.of(context).popAndPushNamed("home");
                    var bar = const SnackBar(content: Text("تم الغاء طلب التسجيل"));
                    ScaffoldMessenger.of(context).showSnackBar(bar);
                  },
                  btnCancelText: "الغاء",
                  btnCancelColor: Theme.of(context).colorScheme.error,
                  dialogType: DialogType.question,
                  title: "إلغاء طلب التسجيل",
                  body: const Text("هل أنت متأكد من رغبتك في الغاء طلب التسجيل بشكل نهائي؟"),
                  btnCancelOnPress: () {
                    Navigator.of(context).pop();
                  },
                ).show();
              },
            ),
          ),
          body: FutureBuilder(
            future: Prov.users.where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData) {
                return const Center(child: Text("لا يوجد بيانات لعرضها"));
              }
              if (snapshot.data?.docs.isEmpty ?? true) {
                return const Center(child: Text("لا يوجد بيانات لعرضها"));
              }
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, i) {
                    return Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 1, color: Theme.of(context).colorScheme.primary,),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(" الدولة :  ${widget.country}", style: TextStyle(color: Colors.black87),),
                          ),
                          ListTile(
                            title: Text(" الولاية :  ${widget.city}", style: TextStyle(color: Colors.black87),),
                          ),
                          ListTile(
                            title: Text(" المدينة :  ${widget.address}", style: TextStyle(color: Colors.black87),),
                          ),
                          ListTile(
                            title: Text(" الجنس :  ${widget.gender}", style: TextStyle(color: Colors.black87)),
                          ),
                          ListTile(
                            title: Text(" الهاتف :  ${widget.phone}", style: TextStyle(color: Colors.black87)),
                          ),
                          ListTile(
                            title: Text(" ولي الأمر :  ${widget.dadPhone}", style: TextStyle(color: Colors.black87)),
                          ),
                          ListTile(
                            title: Text(" تاريخ الميلاد :  ${widget.birthdate}", style: TextStyle(color: Colors.black87)),
                          ),
                          MaterialButton(
                            onPressed: () async {
                              QuerySnapshot snap = await FirebaseFirestore.instance.collection('student')
                                  .where('email', isEqualTo: Prov.user.email).where('course_name', isEqualTo: widget.reg['course_name'])
                                  .get();
                              if(snap.docs.isEmpty){
                                AwesomeDialog(
                                  context: context,
                                  width: 400,
                                  btnOkText: "لانتقال الى واتس اب ",
                                  btnOkColor: Theme.of(context).primaryColor,
                                  btnOkOnPress: () async {
                                    await FirebaseMessaging.instance.subscribeToTopic(widget.id.toString());
                                    await Prov.users.where("userId", isEqualTo: Prov.user.uid).get().then((QuerySnapshot snapshot) {
                                      snapshot.docs.forEach((doc) {
                                        name = doc["name"];
                                      });
                                    });
                                    await Prov.updateStudent(
                                        snapshot.data?.docs[i].id,
                                        widget.birthdate,
                                        widget.phone.toString(),
                                        widget.country,
                                        widget.gender,
                                        widget.city,
                                        widget.address,
                                        widget.dadPhone,
                                        widget.student_status,
                                        widget.schoolName
                                    );
                                    await Prov.regesterInCourse(
                                        widget.id,
                                        Prov.user.uid,
                                        name,
                                        Prov.user.email,
                                        widget.birthdate,
                                        widget.phone,
                                        widget.country,
                                        widget.gender,
                                        widget.reg['course_name'].toString(),
                                        widget.city,
                                        widget.address,
                                        widget.dadPhone,
                                        widget.student_status,
                                        widget.schoolName
                                    );
                                    await openWhatsApp(phoneNumber: '+905058908442', message: 'ISAR');
                                  },
                                  btnCancelText: "لاحقاً",
                                  btnCancelColor: const Color(0xffff0000),
                                  dialogType: DialogType.success,
                                  title: "تم تسجيل الطلب",
                                  body: const Text("يُرجى التواصل مع الادارة على واتس اب من أجل اتمام عملية الدفع "),
                                  btnCancelOnPress: () async {
                                    Navigator.of(context).pushReplacementNamed("home");
                                    var bar = const SnackBar(content: Text("سيتم تثبيت التسجيل بعد الدفع"));
                                    ScaffoldMessenger.of(context).showSnackBar(bar);
                                    await FirebaseMessaging.instance.subscribeToTopic(widget.id.toString().trim());
                                    await Prov.users.where("userId", isEqualTo: Prov.user.uid).get().then((QuerySnapshot snapshot) {
                                      snapshot.docs.forEach((doc) {
                                        name = doc["name"];
                                      });
                                    });
                                    await Prov.updateStudent(
                                        snapshot.data?.docs[i].id,
                                        widget.birthdate,
                                        widget.phone.toString(),
                                        widget.country,
                                        widget.gender,
                                        widget.city,
                                        widget.address,
                                        widget.dadPhone,
                                        widget.student_status,
                                        widget.schoolName
                                    );
                                    await Prov.regesterInCourse(
                                        widget.id,
                                        Prov.user.uid,
                                        name,
                                        Prov.user.email,
                                        widget.birthdate,
                                        widget.phone,
                                        widget.country,
                                        widget.gender,
                                        widget.reg['course_name'].toString(),
                                        widget.city,
                                        widget.address,
                                        widget.dadPhone,
                                        widget.student_status,
                                        widget.schoolName
                                    );
                                  },
                                ).show();
                              }else{
                                await FirebaseMessaging.instance.subscribeToTopic(widget.id.toString());
                                print("${widget.id.toString().trim()}..............................................");
                                Navigator.of(context).pushReplacementNamed("home");
                                var bar = const SnackBar(content: Text("انت مسجل بالدورة من قبل"));
                                ScaffoldMessenger.of(context).showSnackBar(bar);
                              }
                            },
                            child: const Text("تأكيد"),
                          )

                        ],
                      ),
                    );
                  },
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }
}
