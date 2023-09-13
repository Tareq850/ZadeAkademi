import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myplatform/pages/edite.dart';
import 'package:myplatform/provider.dart';
import 'package:myplatform/student/regester.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'exams.dart';
import 'management/notifbycourse.dart';
import 'management/stucourse.dart';

class Viewss extends StatefulWidget{
  final cours;
  final id;
  final username;
  const Viewss(this.cours, this.id, this.username, {super.key});
  @override
  State<StatefulWidget> createState() {
    return ViewssState();
  }
}

class ViewssState extends State<Viewss>{
  @override
  Widget build(BuildContext context) {
    var Prov = Provider.of<AuthP>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(" دورة :  ${widget.cours['course_name']}"), leading: IconButton(icon :const Icon(Icons.arrow_back), onPressed: () {
          Navigator.of(context).pushReplacementNamed('home') ;
        },),backgroundColor: Theme.of(context).colorScheme.primary,),
        body: FutureBuilder(
            future: Prov.users.where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get(),
            builder: (context, snapshot){
              if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());}
              if (snapshot.hasError) {
                return const Text("حصل خطأ ما");
              }
              if (snapshot.data?.docs.isEmpty ?? true) {
                return const Center(child: Text("لا يوجد بيانات لعرضها"));
              }
              if (snapshot.hasData){
                return RefreshIndicator(
                  onRefresh: (){
                    return Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                      return Viewss(widget.cours, widget.id, widget.username);
                    }));
                  },
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, i){
                        if(snapshot.data?.docs[i]['type'] == "مدير" || snapshot.data?.docs[i]['type'] == "معلم"){
                          if(widget.cours['status'] == true){
                            final data = widget.cours['startdate']as Timestamp;
                            final dateTime = data.toDate();
                            final dataEnd = widget.cours['enddate']as Timestamp;
                            final dateTimeEnd = dataEnd.toDate();
                            return Directionality(
                              textDirection: TextDirection.rtl,
                              child: Column(children: [
                                Image.network("${widget.cours['imgurl']}", width: double.infinity,height: 250, fit: BoxFit.cover,),
                                Container(
                                    margin: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text(" اسم الدورة: ${widget.cours['course_name']}",style: const TextStyle(color: Colors.black87)),
                                          leading: const Icon(FontAwesomeIcons.school),
                                        ),
                                        ListTile(
                                          title: Text(" اسم الاستاذ: ${widget.cours['teatcher_name']}",style: const TextStyle(color: Colors.black87)),
                                          leading: const Icon(FontAwesomeIcons.personChalkboard),
                                        ),
                                        ListTile(
                                          title: Text(" سعر الدورة: ${widget.cours['price']}",style: const TextStyle(color: Colors.black87)),
                                          leading: const Icon(FontAwesomeIcons.handHoldingDollar),
                                        ),
                                        ListTile(
                                          title: Text(" عدد الساعات: ${widget.cours['houres']}",style: const TextStyle(color: Colors.black87)),
                                          leading: const Icon(FontAwesomeIcons.hourglassStart),
                                        ),
                                        ListTile(
                                          title:   widget.cours['status'] == true ?Text("الدورة مفتوحة للتسجيل",style: TextStyle(color: Colors.green[900], fontSize: 18),):Text("سيتم إعلان الدورة قريباً",style: Theme.of(context).textTheme.bodyText2,),
                                          leading: widget.cours['status'] == true ?const Icon(FontAwesomeIcons.check):const Icon(FontAwesomeIcons.ban),
                                        ),
                                        Visibility(
                                            visible: widget.cours['status'] == true? true : false,
                                            child: ListTile(
                                              title: Row(
                                                children: [
                                                  Expanded(child: Text(" تاريخ البدء: ${dateTime.year}/${dateTime.month}/${dateTime.day}",style: TextStyle(color: Colors.black87))),
                                                  Expanded(child: Text(" تاريخ الانتهاء: ${dateTimeEnd.year}/${dateTimeEnd.month}/${dateTimeEnd.day}",style: TextStyle(color: Colors.black87))),
                                                ],
                                              ),
                                              leading: const Icon(FontAwesomeIcons.database),
                                            )),
                                        Visibility(
                                            visible: widget.cours['status'] == true? true : false,
                                            child: ListTile(
                                              title: Text(" عدد أيام الدورة: ${widget.cours['number_days']}",style: TextStyle(color: Colors.black87)),
                                              leading: const Icon(FontAwesomeIcons.accusoft),
                                            )),
                                        ListTile(
                                          tileColor: const Color(0xffeeeeee),
                                          title: const Text("اضغط لاستعراض الطلاب المُسجلين بالدورة",style: TextStyle(color: Colors.black87)),
                                          leading: const Icon(FontAwesomeIcons.eye),
                                          onTap: (){
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                              return StudentCourse(widget.cours, widget.id);
                                            }));
                                          },
                                        ),
                                        Visibility(
                                          visible: widget.cours['status'] == true? true : false,
                                          child: ListTile(
                                            title: Text("الاختبارات",style: TextStyle(color: Colors.black87)),
                                            leading: const Icon(FontAwesomeIcons.pencil),
                                            onTap: (){
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                                return Exam(widget.cours, widget.id, snapshot.data!.docs[i].data(), snapshot.data!.docs[i].id);
                                              }));
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 4,),
                                        ListTile(
                                          tileColor: const Color(0xffeeeeee),
                                          title: const Text("ارسال اشعار لطلاب الدورة",style: TextStyle(color: Colors.black87)),
                                          leading: const Icon(FontAwesomeIcons.penToSquare),
                                          onTap: (){
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                              return NotificationCourse(widget.cours, widget.id);
                                            }));
                                          },
                                        ),
                                        const SizedBox(height: 4,),
                                        ListTile(
                                          tileColor: const Color(0xffeeeeee),
                                          title: const Text("اضغط لتعديل معلومات الدورة",style: TextStyle(color: Colors.black87)),
                                          leading: const Icon(FontAwesomeIcons.penToSquare),
                                          onTap: (){
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                              return EditCourse(widget.cours, widget.id);
                                            }));
                                          },
                                        ),
                                        ListTile(
                                          //tileColor: Color(0xffeeeeee),
                                          title: const Text("حذف الدورة بشكل نهائي",style: TextStyle(color: Color(0xffff0000)),),
                                          leading: const Icon(FontAwesomeIcons.deleteLeft),
                                          onTap: (){
                                            AwesomeDialog(
                                              context: context,
                                              width: 400,
                                              title: "تأكيد حذف الدورة",
                                              desc: 'هل انت متأكد من رغبتك في حذف الدورة بشكل نهائي؟',
                                              dialogType: DialogType.warning,
                                              animType: AnimType.rightSlide,
                                              autoHide: const Duration(seconds: 60),
                                              btnCancelOnPress: (){
                                                Navigator.of(context).pop(context);
                                              },
                                              btnCancelColor: const Color(0xffff0000),
                                              btnCancelText: "لا",
                                              btnOkOnPress: () async {
                                                Navigator.of(context).pushReplacementNamed('home');
                                                await Prov.deleteCourse(widget.cours['course_name'], widget.id, widget.cours['imgurl']);
                                                await Future.delayed(const Duration(seconds: 1));
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
                            );}
                          else{
                            return Directionality(
                              textDirection: TextDirection.rtl,
                              child: Column(children: [
                                Image.network("${widget.cours['imgurl']}", width: double.infinity,height: 250, fit: BoxFit.cover,),
                                Container(
                                    margin: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text(" اسم الدورة: ${widget.cours['course_name']}",style: const TextStyle(color: Colors.black87)),
                                          leading: const Icon(FontAwesomeIcons.school),
                                        ),
                                        ListTile(
                                          title: Text(" اسم الاستاذ: ${widget.cours['teatcher_name']}",style: const TextStyle(color: Colors.black87)),
                                          leading: const Icon(FontAwesomeIcons.personChalkboard),
                                        ),
                                        ListTile(
                                          title: Text(" سعر الدورة: ${widget.cours['price']}",style: const TextStyle(color: Colors.black87)),
                                          leading: const Icon(FontAwesomeIcons.handHoldingDollar),
                                        ),
                                        ListTile(
                                          title: Text(" عدد الساعات: ${widget.cours['houres']}",style: const TextStyle(color: Colors.black87)),
                                          leading: const Icon(FontAwesomeIcons.hourglassStart),
                                        ),
                                        ListTile(
                                          title:   Text("سيتم إعلان الدورة قريباً",style: TextStyle(color: Theme.of(context).primaryColor)),
                                          leading: const Icon(FontAwesomeIcons.ban),
                                        ),
                                        ListTile(
                                          tileColor: const Color(0xffeeeeee),
                                          title: const Text("اضغط لتعديل معلومات الدورة",style: TextStyle(color: Colors.black87)),
                                          leading: const Icon(FontAwesomeIcons.penToSquare),
                                          onTap: (){
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                              return EditCourse(widget.cours, widget.id);
                                            }));
                                          },
                                        ),
                                        ListTile(
                                          //tileColor: Color(0xffeeeeee),
                                          title: const Text("حذف الدورة بشكل نهائي",style: TextStyle(color: Color(0xffff0000)),),
                                          leading: const Icon(FontAwesomeIcons.deleteLeft),
                                          onTap: (){
                                            AwesomeDialog(
                                              context: context,
                                              width: 400,
                                              title: "تأكيد حذف الدورة",
                                              desc: 'هل انت متأكد من رغبتك في حذف الدورة بشكل نهائي؟',
                                              dialogType: DialogType.warning,
                                              animType: AnimType.rightSlide,
                                              autoHide: const Duration(seconds: 60),
                                              btnCancelOnPress: (){
                                                Navigator.of(context).pop(context);
                                              },
                                              btnCancelColor: const Color(0xffff0000),
                                              btnCancelText: "لا",
                                              btnOkOnPress: () async {
                                                Navigator.of(context).pushReplacementNamed('home');
                                                await Prov.deleteCourse(widget.cours['course_name'], widget.id, widget.cours['imgurl']);
                                                await Future.delayed(const Duration(seconds: 1));
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
                            );}}
                        else if(snapshot.data!.docs[i]['type'] == 'معلم'){
                          if(widget.cours['status'] == true){
                            final data = widget.cours['startdate']as Timestamp;
                            final dateTime = data.toDate();
                            final dataEnd = widget.cours['enddate']as Timestamp;
                            final dateTimeEnd = dataEnd.toDate();
                            return Directionality(
                              textDirection: TextDirection.rtl,
                              child: Column(children: [
                                Image.network("${widget.cours['imgurl']}", width: double.infinity,height: 300, fit: BoxFit.cover,),
                                Container(
                                    margin: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text(" اسم الدورة: ${widget.cours['course_name']}",style: const TextStyle(color: Colors.black87)),
                                          leading: const Icon(FontAwesomeIcons.school),
                                        ),
                                        ListTile(
                                          title: Text(" اسم الاستاذ: ${widget.cours['teatcher_name']}",style: const TextStyle(color: Colors.black87)),
                                          leading: const Icon(FontAwesomeIcons.personChalkboard),
                                        ),
                                        ListTile(
                                          title: Text(" سعر الدورة: ${widget.cours['price']}",style: const TextStyle(color: Colors.black87)),
                                          leading: const Icon(FontAwesomeIcons.handHoldingDollar),
                                        ),
                                        ListTile(
                                          title: Text(" عدد الساعات: ${widget.cours['houres']}",style: const TextStyle(color: Colors.black87)),
                                          leading: const Icon(FontAwesomeIcons.hourglassStart),
                                        ),
                                        const ListTile(
                                          title: Text("الدورة مفتوحة للتسجيل",style: TextStyle(color: Colors.black87)),
                                          leading: Icon(FontAwesomeIcons.check),
                                        ),
                                        ListTile(
                                          title: Row(
                                            children: [
                                              Expanded(child: Text(" تاريخ البدء: ${dateTime.year}/${dateTime.month}/${dateTime.day}",style: TextStyle(color: Colors.black87))),
                                              Expanded(child: Text(" تاريخ البدء: ${dateTimeEnd.year}/${dateTimeEnd.month}/${dateTimeEnd.day}",style: TextStyle(color: Colors.black87))),
                                            ],
                                          ),
                                          leading: const Icon(FontAwesomeIcons.database),
                                        ),
                                        ListTile(
                                          title: Text(" عدد أيام الدورة: ${widget.cours['number_days']}",style: TextStyle(color: Colors.black87)),
                                          leading: const Icon(FontAwesomeIcons.accusoft),
                                        ),
                                        Visibility(
                                          visible: widget.cours['status'] == true? true : false,
                                          child: ListTile(
                                            title: Text("الاختبارات",style: TextStyle(color: Colors.black87)),
                                            leading: const Icon(FontAwesomeIcons.pencil),
                                            onTap: (){
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                                return Exam(widget.cours, widget.id, snapshot.data!.docs[i].data(), snapshot.data!.docs[i].id);
                                              }));
                                            },
                                          ),
                                        ),
                                      ],
                                    )),


                              ],),
                            );
                          }
                          else{
                            return Directionality(
                              textDirection: TextDirection.rtl,
                              child: Column(children: [
                                Image.network("${widget.cours['imgurl']}", width: double.infinity,height: 300, fit: BoxFit.cover,),
                                Container(
                                    margin: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text(" اسم الدورة: ${widget.cours['course_name']}",style: const TextStyle(color: Colors.black87)),
                                          leading: const Icon(FontAwesomeIcons.school),
                                        ),
                                        ListTile(
                                          title: Text(" اسم الاستاذ: ${widget.cours['teatcher_name']}",style: const TextStyle(color: Colors.black87)),
                                          leading: const Icon(FontAwesomeIcons.personChalkboard),
                                        ),
                                        ListTile(
                                          title: Text(" سعر الدورة: ${widget.cours['price']}",style: const TextStyle(color: Colors.black87)),
                                          leading: const Icon(FontAwesomeIcons.handHoldingDollar),
                                        ),
                                        ListTile(
                                          title: Text(" عدد الساعات: ${widget.cours['houres']}",style: const TextStyle(color: Colors.black87)),
                                          leading: const Icon(FontAwesomeIcons.hourglassStart),
                                        ),
                                        const ListTile(
                                          title: Text("سيتم إعلان الدورة قريباً",style: TextStyle(color: Colors.black87)),
                                          leading: Icon(FontAwesomeIcons.ban),
                                        ),
                                      ],
                                    )),


                              ],),
                            );
                          }
                        }
                        else{
                          if(widget.cours['status'] == true){
                            final data = widget.cours['startdate']as Timestamp;
                            final dateTime = data.toDate();
                            final dataEnd = widget.cours['enddate']as Timestamp;
                            final dateTimeEnd = dataEnd.toDate();
                            return Directionality(
                              textDirection: TextDirection.rtl,
                              child: Column(children: [
                                Image.network("${widget.cours['imgurl']}", width: double.infinity,height: 300, fit: BoxFit.cover,),
                                Container(
                                    margin: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text(" اسم الدورة: ${widget.cours['course_name']}",style: const TextStyle(color: Colors.black87)),
                                          leading: const Icon(FontAwesomeIcons.school),
                                        ),
                                        ListTile(
                                          title: Text(" اسم الاستاذ: ${widget.cours['teatcher_name']}",style: const TextStyle(color: Colors.black87)),
                                          leading: const Icon(FontAwesomeIcons.personChalkboard),
                                        ),
                                        ListTile(
                                          title: Text(" سعر الدورة: ${widget.cours['price']}",style: const TextStyle(color: Colors.black87)),
                                          leading: const Icon(FontAwesomeIcons.handHoldingDollar),
                                        ),
                                        ListTile(
                                          title: Text(" عدد الساعات: ${widget.cours['houres']}",style: const TextStyle(color: Colors.black87)),
                                          leading: const Icon(FontAwesomeIcons.hourglassStart),
                                        ),
                                        const ListTile(
                                          title: Text("الدورة مفتوحة للتسجيل",style: TextStyle(color: Colors.black87)),
                                          leading: Icon(FontAwesomeIcons.check),
                                        ),
                                        ListTile(
                                          title: Row(
                                            children: [
                                              Expanded(child: Text(" تاريخ البدء: ${dateTime.year}/${dateTime.month}/${dateTime.day}",style: TextStyle(color: Colors.black87))),
                                              Expanded(child: Text(" تاريخ البدء: ${dateTimeEnd.year}/${dateTimeEnd.month}/${dateTimeEnd.day}",style: TextStyle(color: Colors.black87))),
                                            ],
                                          ),
                                          leading: const Icon(FontAwesomeIcons.database),
                                        ),
                                        ListTile(
                                          title: Text(" عدد أيام الدورة: ${widget.cours['number_days']}",style: TextStyle(color: Colors.black87)),
                                          leading: const Icon(FontAwesomeIcons.accusoft),
                                        ),
                                        Visibility(
                                          visible: widget.cours['status'] == true? true : false,
                                          child: ListTile(
                                            title: Text("الاختبارات",style: TextStyle(color: Colors.black87)),
                                            leading: const Icon(FontAwesomeIcons.pencil),
                                            onTap: (){
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                                return Exam(widget.cours, widget.id, snapshot.data!.docs[i].data(), snapshot.data!.docs[i].id);
                                              }));
                                            },
                                          ),
                                        ),
                                        ListTile(
                                          tileColor: const Color(0xffeeeeee),
                                          title: const Text("اضغط للتسجيل بالدورة",style: TextStyle(color: Colors.black87)),
                                          leading: const Icon(FontAwesomeIcons.penToSquare),
                                          onTap: (){
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                              return Regester(widget.cours, widget.id, widget.username);
                                            }));
                                          },
                                        ),

                                      ],
                                    )),


                              ],),
                            );
                          }else{
                            return Directionality(
                              textDirection: TextDirection.rtl,
                              child: Column(children: [
                                Image.network("${widget.cours['imgurl']}", width: double.infinity,height: 300, fit: BoxFit.cover,),
                                Container(
                                    margin: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text(" اسم الدورة: ${widget.cours['course_name']}",style: const TextStyle(color: Colors.black87)),
                                          leading: const Icon(FontAwesomeIcons.school),
                                        ),
                                        ListTile(
                                          title: Text(" اسم الاستاذ: ${widget.cours['teatcher_name']}",style: const TextStyle(color: Colors.black87)),
                                          leading: const Icon(FontAwesomeIcons.personChalkboard),
                                        ),
                                        ListTile(
                                          title: Text(" سعر الدورة: ${widget.cours['price']}",style: const TextStyle(color: Colors.black87)),
                                          leading: const Icon(FontAwesomeIcons.handHoldingDollar),
                                        ),
                                        ListTile(
                                          title: Text(" عدد الساعات: ${widget.cours['houres']}",style: const TextStyle(color: Colors.black87)),
                                          leading: const Icon(FontAwesomeIcons.hourglassStart),
                                        ),
                                        const ListTile(
                                          title: Text("سيتم إعلان الدورة قريباً",style: TextStyle(color: Colors.black87)),
                                          leading: Icon(FontAwesomeIcons.ban),
                                        ),
                                      ],
                                    )),


                              ],),
                            );
                          }

                        }
                      }),
                );
              }
              else{
                return const Center(child: CircularProgressIndicator() ,);
              }

            }),
      ),
    );}}