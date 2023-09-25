import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myplatform/management/teacher.dart';
import 'package:myplatform/provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
class Onetech extends StatefulWidget{
  final info;
  final id;
  Onetech(this.info, this.id);
  @override
  State<StatefulWidget> createState() {
    return OnetechState();
  }
}

class OnetechState extends State<Onetech>{
  String type = "معلم";
  @override
  Widget build(BuildContext context) {
    var Prov = Provider.of<AuthP>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(" الأستاذ :  ${widget.info['name']}"),backgroundColor: Theme.of(context).colorScheme.primary,),
        body: FutureBuilder(
            future: Prov.users.where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get(),
            builder: (context, snapshot){
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
              if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());}
              if (snapshot.data?.docs.isEmpty ?? true) {
                return const Center(child: Text("لا يوجد بيانات لعرضها"));
              }
              if (snapshot.hasData){
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, i){
                      return Directionality(
                        textDirection: TextDirection.rtl,
                        child: Column(children: [
                          Container(
                              margin: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  CircleAvatar(child: Image.network("${widget.info['imgurl']}", width: double.infinity,height: 250, fit: BoxFit.cover,)),
                                  ListTile(
                                    title: Text(" اسم الأستاذ: ${widget.info['name']}",style: const TextStyle(color : Colors.black87, fontSize: 18)),
                                    leading: const Icon(FontAwesomeIcons.school),
                                  ),
                                  ListTile(
                                    title: Text(" ايميل الأستاذ: ${widget.info['email']}",style: const TextStyle(color : Colors.black87, fontSize: 18)),
                                    leading: const Icon(FontAwesomeIcons.personChalkboard),
                                  ),
                                  ListTile(
                                    title: Text(" جنس الأستاذ: ${widget.info['gender']}",style: const TextStyle(color : Colors.black87, fontSize: 18)),
                                    leading: const Icon(FontAwesomeIcons.venusMars),
                                  ),
                                  ListTile(
                                    title: Text(" تاريخ ميلاد الأستاذ: ${widget.info['birthDate']}",style: const TextStyle(color : Colors.black87, fontSize: 18)),
                                    leading: const Icon(FontAwesomeIcons.calendarDay),
                                  ),
                                  ListTile(
                                    title: Text(" الدولة: ${widget.info['country']}",style: const TextStyle(color : Colors.black87, fontSize: 18)),
                                    leading: const Icon(FontAwesomeIcons.locationDot),
                                  ),
                                  ListTile(
                                    title: Text(" الهاتف: ${widget.info['phone']}",style: const TextStyle(color : Colors.black87, fontSize: 18),),
                                    leading: const Icon(FontAwesomeIcons.phone),
                                  ),
                                  ListTile(
                                    title: Text(" الاختصاص: ${widget.info['specialization']}",style: const TextStyle(color : Colors.black87, fontSize: 18),),
                                    leading: const Icon(FontAwesomeIcons.phone),
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.tag),
                                    title: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 20),
                                      child: DropdownButton(
                                        value: type,
                                        items: [
                                          "طالب",
                                          "معلم",
                                          "مدير"
                                        ].map((value) => DropdownMenuItem(value: value,child: Text(value),)).toList(),
                                        onChanged: (value){
                                          setState(() {
                                            type = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Visibility(
                                          visible: type != "معلم"? true : false,
                                          child: MaterialButton(
                                            onPressed: () async {
                                              await Prov.updateType(type, widget.id);
                                              Navigator.of(context).pushReplacement(MaterialPageRoute(
                                                  builder: (context){
                                                    return Teatcher(widget.info, widget.id);
                                                  }));
                                            },
                                            color: const Color(0xffff0000),
                                            child: const Text("حفظ التغييرات", style: TextStyle(color : Color(0xffffffff), fontSize: 18)),
                                          )
                                      ),
                                      const SizedBox(width: 10,),
                                      Visibility(
                                          visible: type != "معلم"? true : false,
                                          child: MaterialButton(
                                            onPressed: () async {
                                              Navigator.of(context).pushReplacement(MaterialPageRoute(
                                                  builder: (context){
                                                    return Teatcher(widget.info, widget.id);
                                                  }));
                                            },
                                            color: const Color(0xffeeeeee),
                                            child: const Text("الغاء الأمر", style: TextStyle(color : Color(0xffffffff), fontSize: 18)),
                                          )
                                      ),
                                    ],
                                  ),
                                  ListTile(
                                    //tileColor: Color(0xffeeeeee),
                                    title: const Text("حذف حساب المعلم بشكل نهائي",style: TextStyle(color: Color(0xffff0000)),),
                                    leading: const Icon(FontAwesomeIcons.deleteLeft),
                                    onTap: (){
                                      AwesomeDialog(
                                        context: context,
                                        width: 400,
                                        title: "تأكيد حذف الحساب",
                                        desc: 'هل انت متأكد من رغبتك في حذف حساب المعلم بشكل نهائي؟',
                                        dialogType: DialogType.warning,
                                        animType: AnimType.rightSlide,
                                        autoHide: const Duration(seconds: 60),
                                        btnCancelOnPress: (){
                                          Navigator.of(context).pop(context);
                                        },
                                        btnCancelColor: const Color(0xffff0000),
                                        btnCancelText: "لا",
                                        btnOkOnPress: () async {
                                          await Prov.users.doc(widget.id).delete();
                                          Navigator.of(context).pushReplacementNamed('home');
                                        },
                                        btnOkColor: Theme.of(context).colorScheme.primary,
                                        btnOkText: "تأكيد",
                                        buttonsTextStyle: const TextStyle(color: Colors.white),

                                      ).show();
                                    },
                                  ),
                                ],
                              )),


                        ],),
                      );
                    });
              }
              else{
                return const Center(child: CircularProgressIndicator());
              }

            }),
      ),
    );}}