import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:time_range_picker/time_range_picker.dart';
import '../provider.dart';
import 'package:http/http.dart' as http;
class EditConferance extends StatefulWidget{
  final edit;
  final id;
  EditConferance(this.edit, this.id);
  @override
  State<StatefulWidget> createState() {
    return EditConferanceState();
  }

}

class EditConferanceState extends State<EditConferance> {
  String con_url = "";
  String te_name = "";
  String c_name = "";
  String title = "";
  String body = "";
  final String _serverToken =
      "AAAAXxgI6AE:APA91bFXM8VbyTERv879mnyxu1Mx3Gzoe9pmWroLPXxBoXZmJXDbxvjGtuMlm70pk2nl63c_V6pAcIASvlKdGCAcdSY4kXA_tRewDjKAzRIJbri-44xHMiXBLDNCI_saXcNeVZs6IvuH";
  String titles = "";
  String bodys = "";
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
  DateTimeRange daterange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime(2030, 12, 24 )
  );
  var startday = DateTime.now();
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
          title: Text(" تعديل جلسة ${widget.edit['course_name']}"),backgroundColor:  Theme.of(context).colorScheme.primary,
          leading: IconButton(icon :Icon(Icons.arrow_back), onPressed: () {
            Navigator.of(context).pop(context);
          },),
        ),
        body: ListView(
          shrinkWrap: true,
          children: [
            Column(
              children: [
                Form(
                  key: forms,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: widget.edit['course_name'] ?? " ",
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "تعديل اسم الدورة",
                          labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary,),
                          prefixIcon: Icon(FontAwesomeIcons.discourse, color: Theme.of(context).colorScheme.primary,),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2.5)
                          ),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1)
                          ),
                        ),
                        style: TextStyle(color: Theme.of(context).colorScheme.secondary,),
                        maxLength: 30,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return ("خطأ");
                          }
                          return null;
                        },
                        onSaved: (val) {
                          c_name = val!;
                        },
                      ),
                      TextFormField(
                        initialValue: widget.edit['teatcher_name']??" ",
                        minLines: 1,
                        maxLines: 3,
                        maxLength: 200,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "تعديل اسم المُدرس",
                          prefixIcon: Icon(FontAwesomeIcons.personChalkboard, color: Theme.of(context).colorScheme.primary,),
                          labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary,),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2.5)
                          ),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1)
                          ),
                        ),
                        style: TextStyle(color: Theme.of(context).colorScheme.secondary,),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return ("خطأ");
                          }
                          return null;
                        },
                        onSaved: (val) {
                          te_name = val!;
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          children: [
                            const Visibility(

                                child: Text(" تاريخ بدء وانتهاء الجلسة : ",)),
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
                                    "تعديل وقت البدء والانتهاء",
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
                                  decoration: InputDecoration(
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
                      MaterialButton(
                        onPressed: () async {
                          AwesomeDialog(
                            context: context,
                            width: 400,
                            title: "تأكيد حفظ التعديلات",
                            desc: 'هل انت متأكد من رغبتك في حفظ التعديلات؟',
                            dialogType: DialogType.warning,
                            animType: AnimType.rightSlide,
                            autoHide: const Duration(seconds: 60),
                            btnCancelOnPress: (){
                              Navigator.of(context).pop;
                            },
                            btnCancelColor: Theme.of(context).colorScheme.error,
                            btnCancelText: "لا",
                            btnOkOnPress: () async {
                              var data = forms.currentState;
                              if (data!.validate()) {
                                showDialog<void>(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return const AlertDialog(
                                      title: Center(child: Text('انتظر قليلا..')),
                                      content: SizedBox(height: 200,width: 200 ,child: Center(child: CircularProgressIndicator(),),),
                                    );
                                  },
                                );
                                data.save();
                                Prov.update_Confecance(widget.id, c_name, te_name, _startTime.format(context), _endTime.format(context), startday, con_url);
                                QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                                    .collection('courses')
                                    .where('course_name', isEqualTo: c_name)
                                    .get();
                                var courseID = querySnapshot.docs.first.id;
                                _sendNotification(c_name, "تاريخ الجلسة $startday الوقت ${_startTime.format(context)} ", courseID.toString().trim());
                                Navigator.of(context).pushReplacementNamed('home');
                                var bar = const SnackBar(content: Text("تم اجراء التعديلات"));
                                ScaffoldMessenger.of(context).showSnackBar(bar);
                              }
                            },
                            btnOkColor: Theme.of(context).colorScheme.primary,
                            btnOkText: "نعم",
                            buttonsTextStyle: const TextStyle(color: Colors.white),

                          ).show();
                        },
                        color: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 100, vertical: 10),
                        child: const Text("تعديل الجلسة", style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),),
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),


      ),
    );
  }
}