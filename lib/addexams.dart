import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myplatform/provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'exams.dart';
class AddExam extends StatefulWidget{
  final c_info;
  final c_id;
  final s_info;
  final s_id;
  const AddExam(this.c_info, this.c_id ,this.s_info, this.s_id,{super.key});

  @override
  State<StatefulWidget> createState() {
    return AddExamState();
  }

}
class AddExamState extends State<AddExam> {
  GlobalKey<FormState> forms = GlobalKey<FormState>();
  String exam_url = "";
  String result_url = "";
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
          title: const Text("إضافة اختبار"),
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
                              Text("${widget.c_info["course_name"]}"),
                              const SizedBox(height: 20,),
                              Text("اسم الأستاذ : ${widget.c_info['teatcher_name']}")
                            ],
                          ),
                          const SizedBox(height: 20,),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              children: [
                                Text(" تاريخ الاختبار : ", style: TextStyle(color: Theme.of(context).colorScheme.primary,),),
                                const SizedBox(height: 10,),
                                DateTimeFormField(
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(color: Colors.black45),
                                    errorStyle: TextStyle(color: Theme.of(context).colorScheme.primary,),
                                    border: OutlineInputBorder(),
                                    suffixIcon: Icon(Icons.event_note),
                                    labelText: ' تاريخ الاختبار',
                                  ),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(const Duration(days: 20)),
                                  initialDate: DateTime.now(),
                                  mode: DateTimeFieldPickerMode.date,
                                  autovalidateMode: AutovalidateMode.always,
                                  validator: (e) => (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                                  onDateSelected: (DateTime value) {
                                    startday = value;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20,),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              children: [
                                Text(" رابط الاختبار : ", style: TextStyle(color: Theme.of(context).colorScheme.primary,),),
                                const SizedBox(height: 10,),
                                TextFormField(
                                  style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                  decoration: InputDecoration(
                                    labelText: 'رابط الاختبار',
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
                              ],
                            ),
                          ),
                          const SizedBox(height: 20,),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              children: [
                                Text(" رابط النتائج : ", style: TextStyle(color: Theme.of(context).colorScheme.primary,),),
                                const SizedBox(height: 10,),
                                TextFormField(
                                  style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                  decoration: InputDecoration(
                                    labelText: 'رابط النتائج',
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
                          const SizedBox(height: 100,),
                          SizedBox(
                            width: 230,
                            height: 50,
                            child: MaterialButton(
                              onPressed: () async {
                                if (exam_url != "" && result_url != "") {
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
                                    await Prov.add_Exam(
                                        widget.c_info["course_name"], widget.c_info["teatcher_name"], startday, exam_url, result_url);
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(builder: (context) {
                                          return Exam(widget.c_info, widget.c_id, widget.s_info, widget.s_id);
                                        }));
                                    var bar = SnackBar(
                                      content: const Text("تمت اضافة الاختبار"), backgroundColor: Theme.of(context).colorScheme.secondary,);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        bar);
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
                                    desc: 'يرجى تعبئة حقل الرابط',
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
                                  Text("إضافة الاختبار", style: TextStyle(
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