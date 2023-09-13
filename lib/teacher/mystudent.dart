import 'package:myplatform/teacher/searchmystu.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../provider.dart';
class MyStudents extends StatefulWidget{
  final info;
  final id;
  MyStudents(this.info, this.id);
  @override
  State<StatefulWidget> createState() {
    return MyStudentsState();
  }
}

class MyStudentsState extends State<MyStudents> {
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
            actions: [
              IconButton(onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchMyStudent(widget.info)));
              },
                icon: const Icon(FontAwesomeIcons.magnifyingGlass),),
            ],
          ),
          body: FutureBuilder(
            future: Prov.student.get(),
            builder: (context, snapshot) {
              if(!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.data?.docs.isEmpty ?? true) {
                return const Center(child: Text("لا يوجد بيانات لعرضها"));
              }
              if (snapshot.hasData){
                return RefreshIndicator(
                  onRefresh: (){
                    return Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                      return MyStudents(widget.info, widget.id);
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
                              title: Text(" اسم الطالب: ${snapshot.data?.docs[index]["name"]??""}"),
                              leading: snapshot.data?.docs[index]['status'] == "تم تسجيل الطالب"?Container( padding: const EdgeInsets.all(5) ,color: Colors.green ,child: const Icon(FontAwesomeIcons.check,color: Colors.white,)):Container( padding: const EdgeInsets.all(5) ,color: const Color(0xffff0000) ,child: const Icon(FontAwesomeIcons.xmark,color: Colors.white,),),
                              subtitle: Text(" الجنس: ${snapshot.data!.docs[index]["gender"]}"),
                              trailing: snapshot.data?.docs[index]['status'] == "تم تسجيل الطالب"?const Text("مُثبت"):const Text("غير مُثبت")
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