import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../provider.dart';

class SendNotification extends StatefulWidget {
  final info;
  final id;

  SendNotification(this.info, this.id);

  @override
  State<StatefulWidget> createState() {
    return SendNotificationState();
  }
}

class SendNotificationState extends State<SendNotification> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final String _serverToken =
      "AAAA2oFIeyM:APA91bGYNN-27wbbDkk8iWd6oAfLYHINM3C2HiAyR6WMSdBAOCXiGXTCky1HXitpyfTb2GeEVBjmzTHlDen-TQg3niRULGWledKDDhNQ6Ll2hN7a8OYCgHg1tByNyjkes4_ykrqW3-XP";

  String _title = "";
  String _body = "";
  String _type = "";
  String _selectedType = "اختر فئة";

  Future<void> _sendNotification(String title, String body, String type) async {
    final response = await http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$_serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': body,
            'title': title,
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'name': 'test',
            'lastname': 'tareq',
          },
          'to': '/topics/$type',
        },
      ),
    );

    if (response.statusCode == 200) {
      print("Notification sent successfully");
    } else {
      print("Failed to send notification");
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthP prov = Provider.of<AuthP>(context);

    return SafeArea(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text("إرسال إشعار"),
                  centerTitle: true,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                    Navigator.of(context).pushReplacementNamed('home');
                    },
                    ),),
                body: Container(
                  margin: const EdgeInsets.all(10),
                  child: ListView(
                    shrinkWrap: false,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Form(
                            key: _formKey,
                            child:
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 25.0),
                                child: Column(
                                  children: [
                                    TextFormField(
                                      onChanged: (value) {
                                        setState(() {
                                        _title = value;
                                       });
                                         },
                                      onSaved: (val) {
                                      _title = val!;
                                        },
                                      validator: (value) {
                                      if (value!.isEmpty) {
                                      return "العنوان فارغ.";
                                        }
                                      return null;
                                      },
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                      fontSize: 15,
                                      color: Theme.of(context).colorScheme.primary,
                                      ),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                        Icons.email,
                                        color: Theme.of(context).colorScheme.primary,
                                        ),
                                        labelText: "العنوان",
                                        labelStyle: TextStyle(
                                        color: Theme.of(context).colorScheme.primary,
                                        ),
                                        focusColor: Theme.of(context).primaryColor,
                                        enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                        width: 1.0,
                                        color: Theme.of(context).colorScheme.primary,
                                        ),),
                                        focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                        width: 1.0,
                                        color: Theme.of(context).colorScheme.primary,
                                        ),),
                                        suffixText: "${_title.length}",
                                        ),),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "حقل الموضوع فارغ.";
                                        }
                                        return null;
                                      },
                                      onSaved: (val) {
                                        _body = val!;
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                        _body = value;
                                       });
                                      },
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Theme.of(context).colorScheme.primary,
                                      ),
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                      Icons.password,
                                      color: Theme.of(context).colorScheme.primary,),
                                      labelText: "الموضوع",
                                      labelStyle: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,),
                                      focusColor: Theme.of(context).colorScheme.primary,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 1.0,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 1.0,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),),
                                      suffixText: "${_body.length}",
                                      ),
                                    ),
                                   /* StreamBuilder<QuerySnapshot>(
                                      stream: prov.student.snapshots(includeMetadataChanges: true),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          AwesomeDialog(
                                        context: context,
                                        width: 400,
                                        title: "خطأ",
                                        desc: 'حصل خطأ ما أثناء جلب البيانات',
                                        dialogType: DialogType.error,
                                        animType: AnimType.rightSlide,
                                        autoHide: Duration(seconds: 10),
                                        ).show();
                                        }
                                        if (!snapshot.hasData ||
                                        snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator());
                                        }
                                        if (snapshot.hasData) {
                                          final clients =
                                          snapshot.data!.docs.toList();
                                            return DropdownButtonFormField<String>(
                                              items: [
                                                DropdownMenuItem(
                                                  value: "",
                                                  child: Text("اختر الدورة"),
                                                ),
                                              for (var i in clients)
                                                DropdownMenuItem(
                                                  value: i['course_name'].toString().replaceAll(" ", "") ?? "",
                                                  child: Text(i['course_name'].toString().replaceAll(" ", "")),
                                                ),
                                                ],
                                                onChanged: (value) {
                                                  setState(() {
                                                    _type = value ?? "";
                                                  });
                                                },
                                                value: _type,
                                                hint: Text('اختر دورة'),
                                                isExpanded: false,
                                              );
                                        }
                                        return const SizedBox();
                                      },
                                    ),*/
                                    DropdownButtonFormField(
                                      hint: Text('اختر فئة'),
                                      isExpanded: false,
                                      value: _selectedType,
                                      items: [
                                        "اختر فئة", // يجب أن تكون هذه القيمة داخل List بين قوسين مربعين.
                                        "student",
                                        "teacher",
                                        "manager",
                                      ].map((value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Text(value), // تستخدم القيمة بدلاً من "اختر فئة"
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedType = value ?? "اختر فئة";
                                        });
                                      },
                                    ),

                                    const SizedBox(height: 40),
                                  SizedBox(
                                    width: 230,
                                    height: 50,
                                    child: MaterialButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          _formKey.currentState!.save();

                                          showDialog<void>(
                                            context: context,
                                            builder: (BuildContext dialogContext) {
                                              return const AlertDialog(
                                                title: Text('انتظر من فضلك..'),
                                                content: SizedBox(
                                                  height: 200,
                                                  width: 200,
                                                  child: Center(
                                                    child: CircularProgressIndicator(),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                          print("$_selectedType....................................");
                                          await _sendNotification(_title, _body, _selectedType);
                                          //await prov.sendNotification(_title, _body, _type, DateTime.now());
                                          Navigator.of(context).pushNamed('home');
                                        }
                                      },
                                      color: Theme.of(context).colorScheme.primary,
                                      elevation: 0,
                                      highlightColor:
                                      Theme.of(context).colorScheme.primary,
                                      focusColor: Theme.of(context).colorScheme.primary,
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "إرسال الإشعار",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(width: 30),
                                          Icon(Icons.login, color: Colors.white),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  ],
                                ),
                              ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

