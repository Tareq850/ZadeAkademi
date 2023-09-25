import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myplatform/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../meet.dart';
import 'editeconferance.dart'; // استبدال هذا باستيراد الملف الصحيح

class OneCon extends StatefulWidget {
  final info;
  final id;
  final user;
  final userid;
  OneCon(this.info, this.id, this.user, this.userid);

  @override
  State<StatefulWidget> createState() {
    return OneConState();
  }
}

class OneConState extends State<OneCon> {
  openCon(con_url) async{
    var conURl = Uri.parse(con_url);
    print("s22s");
    await launchUrl(conURl);
    print("ssss");
  }
  @override
  Widget build(BuildContext context) {
    final data = widget.info['date']as Timestamp;
    final dateTime = data.toDate();
    var Prov = Provider.of<AuthP>(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.info['course_name']),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: widget.user['type'] == 'مدير' || widget.user['type'] == 'معلم'
            ? buildConferenceList(context, Prov, dateTime)
            : buildConferenceList(context, Prov, dateTime),
      ),
    );
  }

  // هذا الوظيفة لبناء قائمة الجلسات بناءً على الشرط المطلوب
  StreamBuilder<QuerySnapshot> buildConferenceList(BuildContext context, AuthP Prov, DateTime dateTime) {
    return StreamBuilder<QuerySnapshot>(
      stream: Prov.conferance.snapshots(includeMetadataChanges: true),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("حصل خطأ ما");
        }
        if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: () {
            return Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) {
                return OneCon(widget.info, widget.id, widget.user, widget.userid);
              },
            ));
          },
          child: ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, i) {
              final conferenceData = snapshot.data!.docs[i];
              if (widget.info['course_name'] == conferenceData['course_name'] &&
                  widget.info['date'] == conferenceData['date'] &&
                  widget.info['start'] == conferenceData['start']) {
                if(widget.user['type'] == 'مدير' || widget.user['type'] == 'معلم'){
                  return buildConferenceItem(context, i, conferenceData, Prov, dateTime);
                }
                else {
                  return buildConferenceItemStu(context, i, conferenceData, Prov, dateTime);
                }
              } else {
                return SizedBox.shrink(); // إذا لم يطابق الشرط، قم بعرض عنصر غير مرئي
              }
            },
          ),
        );
      },
    );
  }

  // هذا الوظيفة لبناء عنصر واحد للجلسة
  Widget buildConferenceItem(BuildContext context, int index, DocumentSnapshot conferenceData, AuthP Prov, DateTime dateTime) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text(
              "اسم الدورة: ${widget.info['course_name']}",
              style: const TextStyle(color: Colors.black87, fontSize: 18),
            ),
            leading: const Icon(FontAwesomeIcons.school),
          ),
          ListTile(
            title: Text(
              " اسم الاستاذ: ${widget.info['teatcher_name']}",
              style: TextStyle(color: Colors.black87, fontSize: 18),
            ),
            leading: Icon(FontAwesomeIcons.personChalkboard),
          ),
          ListTile(
            title: Text(
              " تاريخ الجلسة: ${dateTime.year}/${dateTime.month}/${dateTime.day}",
              style: TextStyle(color: Colors.black87, fontSize: 18),
            ),
            leading: Icon(FontAwesomeIcons.venusMars),
          ),
          ListTile(
            title: Text(
              " ساعة البدء: ${widget.info['start']}",
              style: TextStyle(color: Colors.black87, fontSize: 18),
            ),
            leading: Icon(FontAwesomeIcons.calendarDay),
          ),
          ListTile(
            title: Text(
              " ساعة الانتهاء: ${widget.info['end']}",
              style: TextStyle(color: Colors.black87, fontSize: 18),
            ),
            leading: Icon(FontAwesomeIcons.locationDot),
          ),
          ListTile(
            title: Text(
              " الدخول الى الجلسة",
              style: TextStyle(color: Colors.black87, fontSize: 18),
            ),
            leading: Icon(FontAwesomeIcons.phone),
            onTap: () {
              openCon(widget.info['con_url']);
            },
          ),
          ListTile(
            title: Text(
              "تعديل الجلسة",
              style: TextStyle(color: Color(0xffff0000)),
            ),
            leading: Icon(FontAwesomeIcons.deleteLeft),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return EditConferance(widget.info, widget.id);
              }));
            },
          ),
          ListTile(
            title: Text(
              "حذف الجلسة بشكل نهائي",
              style: TextStyle(color: Color(0xffff0000)),
            ),
            leading: Icon(FontAwesomeIcons.deleteLeft),
            onTap: () {
              showDeleteConfirmationDialog(context, Prov);
            },
          ),
          // ... باقي معلومات الجلسة هنا ...
        ],
      ),
    );
  }

  void showDeleteConfirmationDialog(BuildContext context, AuthP Prov) {
    AwesomeDialog(
      context: context,
      width: 400,
      title: "تأكيد حذف الجلسة",
      desc: 'هل أنت متأكد من رغبتك في حذف حساب الجلسة بشكل نهائي؟',
      dialogType: DialogType.warning,
      animType: AnimType.rightSlide,
      autoHide: Duration(seconds: 60),
      btnCancelOnPress: () {
        Navigator.of(context).pop();
      },
      btnCancelColor: Color(0xffff0000),
      btnCancelText: "لا",
      btnOkOnPress: () async {
        await Prov.conferance.doc(widget.id).delete();
        Navigator.of(context).pushReplacementNamed('home');
      },
      btnOkColor: Theme.of(context).colorScheme.primary,
      btnOkText: "تأكيد",
      buttonsTextStyle: TextStyle(color: Colors.white),
    ).show();
  }

  Widget buildConferenceItemStu(BuildContext context, int index, DocumentSnapshot conferenceData, AuthP Prov, DateTime dateTime) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text(
              "اسم الدورة: ${widget.info['course_name']}",
              style: const TextStyle(color: Colors.black87, fontSize: 18),
            ),
            leading: const Icon(FontAwesomeIcons.school),
          ),
          ListTile(
            title: Text(
              " اسم الاستاذ: ${widget.info['teatcher_name']}",
              style: TextStyle(color: Colors.black87, fontSize: 18),
            ),
            leading: Icon(FontAwesomeIcons.personChalkboard),
          ),
          ListTile(
            title: Text(
              " تاريخ الجلسة: ${dateTime.year}/${dateTime.month}/${dateTime.day}",
              style: TextStyle(color: Colors.black87, fontSize: 18),
            ),
            leading: Icon(FontAwesomeIcons.venusMars),
          ),
          ListTile(
            title: Text(
              " ساعة البدء: ${widget.info['start']}",
              style: TextStyle(color: Colors.black87, fontSize: 18),
            ),
            leading: Icon(FontAwesomeIcons.calendarDay),
          ),
          ListTile(
            title: Text(
              " ساعة الانتهاء: ${widget.info['end']}",
              style: TextStyle(color: Colors.black87, fontSize: 18),
            ),
            leading: Icon(FontAwesomeIcons.locationDot),
          ),
          ListTile(
            title: Text(
              " الدخول الى الجلسة",
              style: TextStyle(color: Colors.black87, fontSize: 18),
            ),
            leading: Icon(FontAwesomeIcons.phone),
            onTap: () {
              openCon(widget.info['con_url']);
            },
          ),
        ],
      ),
    );
  }
}
