
import 'package:myplatform/management/request.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../provider.dart';
class OneReq extends StatefulWidget{
  final info;
  final id;
  OneReq(this.info,this.id);
  @override
  State<StatefulWidget> createState() {
    return OneReqState();
  }
}

class OneReqState extends State<OneReq>{
  var status ;
  bool visibles = false;
  @override
  Widget build(BuildContext context) {
    var Prov = Provider.of<AuthP>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(" اسم الطالب: ${widget.info['name']}"),backgroundColor:  Theme.of(context).colorScheme.primary,
          leading: IconButton(icon :const Icon(Icons.arrow_back), onPressed: () {
            Navigator.of(context).pop(context);
          },),
        ),
        body: Column(children: [
          Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  ListTile(
                    title: Text(" اسم الدورة: ${widget.info['course_name']}",style: const TextStyle(color: Colors.black87, fontSize: 18)),
                    leading: const Icon(FontAwesomeIcons.school),
                  ),
                  ListTile(
                    title: Text(" اسم الطالب: ${widget.info['name']}",style: const TextStyle(color: Colors.black87, fontSize: 18)),
                    leading: const Icon(FontAwesomeIcons.graduationCap),
                  ),
                  ListTile(
                    title: Text(" الايميل: ${widget.info['email']}",style: const TextStyle(color: Colors.black87, fontSize: 18)),
                    leading: const Icon(FontAwesomeIcons.solidEnvelope),
                  ),
                  ListTile(
                    title: Text(" السعر: ${widget.info['price']}",style: const TextStyle(color: Colors.black87, fontSize: 18)),
                    leading: const Icon(FontAwesomeIcons.solidEnvelope),
                  ),
                  ListTile(
                    title: Text(" تاريخ الميلاد: ${widget.info['birthDate']}",style: const TextStyle(color: Colors.black87, fontSize: 18)),
                    leading: const Icon(FontAwesomeIcons.calendarDay),
                  ),
                  ListTile(
                    title: Text(" الهاتف: ${widget.info['phone']}",style: const TextStyle(color: Colors.black87, fontSize: 18),),
                    leading: const Icon(FontAwesomeIcons.phone),
                  ),
                  ListTile(
                    title: Text(" الدولة: ${widget.info['country']}",style: const TextStyle(color: Colors.black87, fontSize: 18)),
                    leading: const Icon(FontAwesomeIcons.locationDot),
                  ),
                  ListTile(
                    title: Text(" الجنس: ${widget.info['gender']}",style: const TextStyle(color: Colors.black87, fontSize: 18)),
                    leading: const Icon(FontAwesomeIcons.venusMars),
                  ),
                  ListTile(
                    title: Text(" الحالة: ${widget.info['status']}",style: const TextStyle(color: Colors.black87, fontSize: 18)),
                    leading: const Icon(FontAwesomeIcons.sliders),
                  ),
                  ListTile(
                    title: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      child: DropdownButton(
                        hint: const Text("تغيير حالة الطالب"),
                        value: status,
                        items: [
                          "بانتظار الدفع",
                          "تم تسجيل الطالب",
                        ].map((value) => DropdownMenuItem(value: value,child: Text(value),)).toList(),
                        onChanged: (value){
                          setState(() {
                            status = value!;
                            visibles = true;
                          });
                        },
                      ),
                    ),
                    leading: const Icon(FontAwesomeIcons.pen),
                  ),
                  const SizedBox(height: 20,),
                  Visibility(
                      visible: visibles == true?true:false,
                      child: MaterialButton(
                        onPressed: (){
                          AwesomeDialog(
                              context: context,
                              width: 400,
                              title: "تأكيد قبول الطالب",
                              body: const Text("هل أنت متأكد من أن الطالب قد تم تسجيله بالفعل"),
                              btnCancelOnPress: (){Navigator.of(context).pop;},
                              btnCancelColor: const Color(0xffff0000),
                              btnCancelText: "لا",
                              btnOkText: "نعم",
                              btnOkOnPress: () async {
                                await Prov.regesterUpCourse(widget.id, status);
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Requests()));
                                var bar = const SnackBar(content: Text("تمت تسجيل الطالب بنجاح"));
                                ScaffoldMessenger.of(context).showSnackBar(bar);
                              }
                          ).show();
                        },
                        color: const Color(0xffff0000),
                        child: const Text("حفظ التغييرات", style: TextStyle(color: Color(0xffffffff), fontSize: 18)),
                      ))
                ],
              )),

        ],),
      ),
    );
  }
}