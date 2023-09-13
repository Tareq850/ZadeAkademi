import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../provider.dart';
import 'onest.dart';
class StudentCourse extends StatefulWidget{
  final info;
  final id;
  StudentCourse(this.info, this.id);
  @override
  State<StatefulWidget> createState() {
    return StudentCourseState();
  }
}

class StudentCourseState extends State<StudentCourse> {
  @override
  Widget build(BuildContext context) {
    var Prov = Provider.of<AuthP>(context);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text("${widget.info['course_name']}"),backgroundColor:  Theme.of(context).colorScheme.primary,
            leading: IconButton(icon :const Icon(Icons.arrow_back), onPressed: () {
              Navigator.of(context).pop(context);
            },),
          ),
          body: StreamBuilder(
            stream: Prov.student.snapshots(includeMetadataChanges: true),
            builder: (context, snapshot) {
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
                return RefreshIndicator(
                  onRefresh: (){
                    return Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                      return StudentCourse(widget.info, widget.id);
                    }));
                  },
                  child: ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      if(widget.info["course_name"] == snapshot.data?.docs[index]["course_name"]){
                        return Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(width: 1)
                          ),
                          child: ListTile(
                            title: Text(" اسم الطالب: ${snapshot.data?.docs[index]["name"]}", style: TextStyle(color: Colors.black87),),
                            leading: snapshot.data?.docs[index]['status'] == "تم تسجيل الطالب"?Container( padding: const EdgeInsets.all(5) ,color: Colors.green ,child: const Icon(FontAwesomeIcons.check,color: Colors.white,)):Container( padding: const EdgeInsets.all(5) ,color: const Color(0xffff0000) ,child: const Icon(FontAwesomeIcons.xmark,color: Colors.white,),),
                            subtitle: Text(" الجنس: ${snapshot.data?.docs[index]["gender"]}"),
                            trailing: snapshot.data?.docs[index]['status'] == "تم تسجيل الطالب"?const Text("مُثبت"):const Text("غير مُثبت"),
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                return Onestu(snapshot.data?.docs[index].data(), snapshot.data?.docs[index].id);
                              }));
                            },
                          ),
                        );
                      }
                      else {
                        return const SizedBox();
                      }
                    },
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator(),);
            },
          ),

        )
    );
  }
}