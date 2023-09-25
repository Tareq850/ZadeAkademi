import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/foundation.dart';
import 'package:myplatform/management/conferances.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myplatform/provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:http/http.dart' as http;
class AddConferance extends StatefulWidget{
  final userinfo;
  final id;
  const AddConferance(this.userinfo, this.id ,{super.key});

  @override
  State<StatefulWidget> createState() {
    return AddConferanceState();
  }

}
class AddConferanceState extends State<AddConferance> {

  final String _serverToken =
      "AAAA2oFIeyM:APA91bGYNN-27wbbDkk8iWd6oAfLYHINM3C2HiAyR6WMSdBAOCXiGXTCky1HXitpyfTb2GeEVBjmzTHlDen-TQg3niRULGWledKDDhNQ6Ll2hN7a8OYCgHg1tByNyjkes4_ykrqW3-XP";
  String title = "";
  String body = "";
  String tobic = "";
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

  GlobalKey<FormState> forms = GlobalKey<FormState>();
  String con_url = "";
  String te_name = "";
  String c_name = "";
  var startday ;
  var endday;
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime =
  TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 3)));
  @override
  Widget build(BuildContext context) {
    var Prov = Provider.of<AuthP>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("إضافة جلسة"),
          backgroundColor: Theme.of(context).primaryColor ,
          leading: IconButton(icon :const Icon(Icons.arrow_back), onPressed: () {
            Navigator.of(context).pushReplacementNamed('home');
          },),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(vertical: 30),
          child: ListView(
            children: [
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Form(
                      key: forms,
                      child: Column(
                        children: [
                          ListView(
                            shrinkWrap: true,
                            children: [
                              StreamBuilder<QuerySnapshot>(
                                stream: Prov.course.snapshots(includeMetadataChanges: true),
                                builder: (context, snapshot) {
                                  List <DropdownMenuItem> course_name= [];
                                  if (!snapshot.hasData) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  else {
                                    final clients = snapshot.data!.docs.reversed.toList();
                                    course_name.add(const DropdownMenuItem(
                                        value: "",
                                        child: Text("اختر الدورة")));

                                    for (var i in clients){
                                      tobic = i.id.toString();
                                      course_name.add(DropdownMenuItem(
                                          value: i['course_name'] ?? "",
                                          child: Text(i['course_name'])));
                                    }
                                    return DropdownButtonFormField(
                                      items: course_name,
                                      onChanged: (value) {
                                        setState((){
                                          c_name = value;
                                        });
                                      },

                                      // add the below two lines
                                      value: c_name,
                                      hint: const Text('اختر دورة'),
                                      isExpanded: false,
                                    );
                                  }
                                },
                              ),
                              const SizedBox(height: 20,),
                              StreamBuilder<QuerySnapshot>(
                                stream: Prov.course.snapshots(includeMetadataChanges: true),
                                builder: (context, snapshot) {
                                  List <DropdownMenuItem> teacher_name= [];
                                  if (!snapshot.hasData) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  else {
                                    final clients = snapshot.data!.docs.reversed.toList();
                                    teacher_name.add(const DropdownMenuItem(
                                        value: "",
                                        child: Text("اختر الاستاذ")));

                                    for (var i in clients){
                                      teacher_name.add(DropdownMenuItem(
                                          value: i['teatcher_name'] ?? "",
                                          child: Text(i['teatcher_name'])));
                                    }
                                    return DropdownButtonFormField(
                                      items: teacher_name,
                                      onChanged: (newValue) {
                                        setState(() => te_name = newValue);
                                      },

                                      // add the below two lines
                                      value: te_name,
                                      hint: const Text('اختر استاذ'),
                                      isExpanded: false,
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                          /*StreamBuilder<QuerySnapshot>(
                              stream: Prov.course.snapshots(),
                              builder: (context, snapshot){
                                if (!snapshot.hasData) {
                                  return const Center(
                                    child: CupertinoActivityIndicator(),
                                  );
                                }
                                var index = snapshot.data!.docs.length;
                                DocumentSnapshot ds = snapshot.data!.docs[index - 1];
                                var queryCat = snapshot.data!.docs[index];
                                return Container(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  //width: screenSize.width*0.9,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                          flex: 2,
                                          child: Container(
                                            padding: const EdgeInsets.fromLTRB(12.0,10.0,10.0,10.0),
                                            child: const Text("اسم الاستاذ",),
                                          )
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child:InputDecorator(
                                          decoration: const InputDecoration(
                                            //labelText: 'Activity',
                                            hintText: 'اختر اسم الاستاذ',
                                            hintStyle: TextStyle(
                                              fontSize: 16.0,
                                              fontFamily: "OpenSans",
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          isEmpty: c_name == null,
                                          child: DropdownButton(
                                            value: c_name,
                                            isDense: true,
                                            onChanged: (value) {
                                              setState(() {
                                                c_name = value!;
                                              });
                                            },
                                            items: snapshot.data!.docs.map((DocumentSnapshot document) {
                                              return DropdownMenuItem<String>(
                                                  value: queryCat['teacher_name'],
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5.0)
                                                    ),
                                                    height: 100.0,
                                                    padding: const EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 0.0),
                                                    //color: primaryColor,
                                                    child: new Text(queryCat['teacher_name'],),
                                                  )
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                          ),*/
                          const SizedBox(height: 20,),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              children: [
                                Text(" تاريخ ووقت بدء الجلسة : ", style: TextStyle(color: Theme.of(context).colorScheme.primary,),),
                                const SizedBox(height: 10,),
                                DateTimeFormField(
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(color: Colors.black45),
                                    errorStyle: TextStyle(color: Theme.of(context).colorScheme.primary,),
                                    border: OutlineInputBorder(),
                                    suffixIcon: Icon(Icons.event_note),
                                    labelText: ' تاريخ الجلسة',
                                  ),
                                  firstDate: DateTime.now().add(const Duration(days: 1)),
                                  lastDate: DateTime.now().add(const Duration(days: 20)),
                                  initialDate: DateTime.now().add(const Duration(days: 10)),
                                  mode: DateTimeFieldPickerMode.date,
                                  autovalidateMode: AutovalidateMode.always,
                                  validator: (e) => (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                                  onDateSelected: (DateTime value) {
                                    startday = value;
                                  },
                                ),
                                const SizedBox(height: 20,),
                                MaterialButton(
                                  onPressed: () {
                                    showTimeRangePicker(
                                      context: context,
                                      start: const TimeOfDay(hour: 22, minute: 9),
                                      onStartChange: (start) {
                                        if (kDebugMode) {
                                          _startTime = start;
                                        }
                                        _startTime = start;
                                      },
                                      onEndChange: (end) {
                                        if (kDebugMode) {
                                          _endTime = end;
                                        }
                                        _endTime = end;
                                      },
                                      interval: const Duration(hours: 1),
                                      minDuration: const Duration(hours: 1),
                                      use24HourFormat: false,
                                      padding: 30,
                                      strokeWidth: 20,
                                      handlerRadius: 14,
                                      strokeColor: Theme.of(context).colorScheme.secondary,
                                      handlerColor: Theme.of(context).colorScheme.primary,
                                      selectedColor: Theme.of(context).colorScheme.secondary,
                                      backgroundColor: Colors.black.withOpacity(0.3),
                                      ticks: 12,
                                      ticksColor: Colors.white,
                                      snap: true,
                                      labels: [
                                        "12 am",
                                        "3 am",
                                        "6 am",
                                        "9 am",
                                        "12 pm",
                                        "3 pm",
                                        "6 pm",
                                        "9 pm"
                                      ].asMap().entries.map((e) {
                                        return ClockLabel.fromIndex(
                                            idx: e.key, length: 8, text: e.value);
                                      }).toList(),
                                      labelOffset: -30,
                                      labelStyle: const TextStyle(
                                          fontSize: 22,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                      timeTextStyle: TextStyle(
                                        color: Theme.of(context).colorScheme.secondary,
                                        fontSize: 24,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      activeTimeTextStyle: TextStyle(
                                        color: Theme.of(context).colorScheme.secondary,
                                        fontSize: 26,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                  color: Theme.of(context).colorScheme.primary,
                                  child: const Row( // تحسين العرض باستخدام Row بدلاً من Text فقط
                                    mainAxisAlignment: MainAxisAlignment.center, // محاذاة المحتوى في الوسط
                                    children: [
                                      Icon(Icons.access_time, color: Colors.white), // أيقونة الوقت
                                      SizedBox(width: 8), // توفير بعض التباعد بين الأيقونة والنص
                                      Text(
                                        "تحديد وقت البدء والانتهاء",
                                        style: TextStyle(color: Colors.white),
                                      ), // النص
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20,),
                                Column(
                                  children: [
                                    Text(" رابط الجلسة : ", style: TextStyle(color: Theme.of(context).colorScheme.primary,),),
                                    const SizedBox(height: 10,),
                                    TextFormField(
                                      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                      decoration: const InputDecoration(
                                        labelText: 'رابط الجلسة',
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'يرجى إدخال رابط';
                                        }
                                        return null;
                                      },
                                      onChanged: (value){
                                        con_url = value;
                                      },
                                      onSaved: (value){
                                        con_url = value!;
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20,),
                          SizedBox(
                            width: 230,
                            height: 50,
                            child: MaterialButton(
                              onPressed: () async {
                                if (c_name != "" && te_name != "" && con_url != "") {
                                  var data = forms.currentState;
                                  if (data!.validate()) {
                                    data.save();
                                    showDialog<void>(
                                      context: context,
                                      builder: (BuildContext dialogContext) {
                                        return AlertDialog(
                                          title: Center(child: Text('انتظر قليلاً..')),
                                          content: Container(
                                            height: 200,
                                            width: 200,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.white,
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.black12,
                                                  blurRadius: 10,
                                                  offset: Offset(0, 5),
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                valueColor: AlwaysStoppedAnimation<Color>(
                                                  Theme.of(context).colorScheme.primary,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                                        .collection('courses')
                                        .where('course_name', isEqualTo: c_name)
                                        .get();
                                    var courseID = querySnapshot.docs.first.id;
                                    await Prov.add_Confecance(
                                        c_name, te_name, _startTime.format(context), _endTime.format(context),
                                        startday, con_url);
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(builder: (context) {
                                          return Conferances(widget.userinfo, widget.id);
                                        }));
                                    var bar = SnackBar(
                                        content: const Text("تمت اضافة الجلسة"), backgroundColor: Theme.of(context).colorScheme.secondary,);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        bar);
                                    _sendNotification(c_name, "تاريخ الجلسة )${startday.toString()} الساعة( ${_startTime.format(context).toString()} ", courseID.toString());
                                    print(courseID.toString());
                                    print(_startTime.hour);
                                  }
                                  else {
                                    AwesomeDialog(
                                      width: 400,
                                      context: context,
                                      dialogType: DialogType.error,
                                      animType: AnimType.bottomSlide,
                                      title: "${Prov.errorMessag}",
                                      desc: 'يرجى تعبئة باقي الحقول',
                                    ).show();
                                  }
                                }
                                else {
                                  AwesomeDialog(
                                    width: 400,
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.bottomSlide,
                                    title: "${Prov.errorMessag}",
                                    desc: 'حصلت مشكلة غير متوقعة',
                                  ).show();
                                }
                              },
                              color: Theme.of(context).colorScheme.primary,
                              elevation: 0,
                              highlightColor: Theme.of(context).colorScheme.primary,
                              focusColor: Theme.of(context).colorScheme.primary,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("إضافة الجلسة", style: TextStyle(
                                      fontSize: 20, color: Colors.white),),
                                  SizedBox(width: 30,),
                                  Icon(FontAwesomeIcons.bullhorn,
                                    color: Colors.white,),
                                ],),
                            ),
                          ),
                        ],
                      ),

                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}