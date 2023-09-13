import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:myplatform/management/onest.dart';
import 'package:myplatform/management/searchmanagment.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../provider.dart';
class Student extends StatefulWidget{
  final userinfo;
  final id;
  Student(this.userinfo, this.id);
  @override
  State<StatefulWidget> createState() {
    return StudentState();
  }
}

class StudentState extends State<Student>{
  @override
  Widget build(BuildContext context) {
    var Prov = Provider.of<AuthP>(context);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("قائمة الطلاب"),
            backgroundColor: Theme.of(context).colorScheme.primary,
            leading: IconButton(icon :const Icon(Icons.arrow_back), onPressed: () {
              Navigator.of(context).pushReplacementNamed('home');
            },),
            actions: [
              IconButton(onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchManagment(widget.userinfo)));
              },
                icon: const Icon(FontAwesomeIcons.magnifyingGlass),),
            ],
          ),
          body: StreamBuilder(
              stream: Prov.users.snapshots(includeMetadataChanges: true),
              builder: (context, snapshot){
                if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());}
                if (snapshot.data?.docs.isEmpty ?? true) {
                  return const Center(child: Text("لا يوجد بيانات لعرضها"));
                }
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
                else if(snapshot.hasData){
                  return RefreshIndicator(
                    onRefresh: (){
                      return Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                        return Student(widget.userinfo, widget.id);
                      }));
                    },
                    child: ListView.builder (
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index){
                          if(snapshot.data?.docs[index]['type'] == "طالب"){
                            return Container(
                              margin: EdgeInsets.all(5),
                              child: ListTile(
                                shape: Border.all(width: 1, color: Theme.of(context).colorScheme.primary,),
                                title: Text(" اسم الطالب : ${snapshot.data?.docs[index]['name']}", style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
                                leading: const Icon(Icons.accessibility),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                    return Onestu(snapshot.data?.docs[index].data(), snapshot.data?.docs[index].id);
                                  }));
                                },
                              ),
                            );
                          }

                          return const SizedBox();
                        }
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              }
          ),
        )
    );
  }
}