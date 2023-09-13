import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:time_range_picker/time_range_picker.dart';
import '../provider.dart';

class EditExam extends StatefulWidget{
  final info;
  final id;
  EditExam(this.info, this.id);
  @override
  State<StatefulWidget> createState() {
    return EditExamState();
  }

}

class EditExamState extends State<EditExam> {
  String title = "";
  String body = "";
  String exam_url = "";
  String result_url = "";
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
          title: Text(" تعديل الاختبار ${widget.info['course_name']}"),backgroundColor:  Theme.of(context).colorScheme.primary,
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
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          children: [
                            Text(" تاريخ الاختبار : ",),
                            const SizedBox(height: 10,),
                            DateTimeFormField(
                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: Colors.black45),
                                errorStyle: TextStyle(color: Theme.of(context).colorScheme.primary,),
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.event_note),
                                labelText: ' تاريخ الجلسة',
                              ),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 20)),
                              initialDate: widget.info['date'],
                              mode: DateTimeFieldPickerMode.date,
                              autovalidateMode: AutovalidateMode.always,
                              validator: (e) => (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                              onDateSelected: (DateTime value) {
                                startday = value;
                              },
                            ),
                            const SizedBox(height: 20,),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                children: [
                                  Text(" رابط الاختبار : ", style: TextStyle(color: Theme.of(context).colorScheme.primary,),),
                                  const SizedBox(height: 10,),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'رابط الاختبار',
                                      hintText: 'google form URL',
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'يرجى إدخال رابط';
                                      }
                                      return null;
                                    },
                                    onChanged: (value){
                                      exam_url = value;
                                    },
                                    onSaved: (value){
                                      exam_url = value!;
                                    },
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'رابط النتائج',
                                      hintText: 'google sheet URL',
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'يرجى إدخال رابط';
                                      }
                                      return null;
                                    },
                                    onChanged: (value){
                                      result_url = value;
                                    },
                                    onSaved: (value){
                                      result_url = value!;
                                    },
                                  ),
                                ],
                              ),
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
                                Prov.update_Exam(widget.id, startday, exam_url, result_url);
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
                        child: const Text("تعديل الاختبار", style: TextStyle(
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