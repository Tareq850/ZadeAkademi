import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../provider.dart';
import 'myonereq.dart';
class MyReq extends StatefulWidget{
  final info;
  final id;
  MyReq(this.info, this.id);
  @override
  State<StatefulWidget> createState() {
    return MyReqState();
  }
}

class MyReqState extends State<MyReq>{
  @override
  Widget build(BuildContext context) {
    var Prov = Provider.of<AuthP>(context);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(" كورساتي "),backgroundColor:  Theme.of(context).colorScheme.primary,
            leading: IconButton(icon :const Icon(Icons.arrow_back), onPressed: () {
              Navigator.of(context).pop(context);
            },),
          ),
          body: FutureBuilder(
            future: Prov.student.get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());}
              if (snapshot.data?.docs.isEmpty ?? true) {
                return const Center(child: Text("لا يوجد بيانات لعرضها"));
              }
              if (!snapshot.hasData){
                return const Center(child: Text("لا يوجد بيانات لعرضها",  style: TextStyle(color: Colors.black87),));
              }
              if(snapshot.hasData){
                return RefreshIndicator(
                  onRefresh: (){
                    return Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                      return MyReq(widget.info, widget.id);
                    }));
                  },
                  child: ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index){
                        if(snapshot.data?.docs[index]['userId'] == widget.info['userId']){
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: Dismissible(
                              key: UniqueKey(),
                              background: Container(
                                color: Colors.red, // لون الخلفية عند السحب للحذف
                                child: Icon(Icons.delete, color: Colors.white),
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 20.0),
                              ),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                AwesomeDialog(
                                  context: context,
                                  width: 400,
                                  title: "تأكيد حذف الدورة",
                                  desc: 'هل أنت متأكد من رغبتك في حذف الدورة بشكل نهائي؟',
                                  dialogType: DialogType.warning,
                                  animType: AnimType.rightSlide,
                                  autoHide: Duration(seconds: 60),
                                  btnCancelOnPress: () {
                                    Navigator.of(context).pop();
                                  },
                                  btnCancelColor: Color(0xffff0000),
                                  btnCancelText: "لا",
                                  btnOkOnPress: () async {
                                    Navigator.of(context).pushReplacementNamed('home');
                                  },
                                  btnOkColor: Theme.of(context).colorScheme.primary,
                                  btnOkText: "تأكيد",
                                  buttonsTextStyle: TextStyle(color: Colors.white),
                                ).show();
                              },
                              child: ListTile(
                                title: Text(" اسم الدورة: ${snapshot.data?.docs[index]['course_name']}", style: TextStyle(color: Colors.black87),),
                                leading: snapshot.data?.docs[index]['status'] == "تم تسجيل الطالب"?Container( padding: const EdgeInsets.all(5) ,color: Colors.green ,child: const Icon(FontAwesomeIcons.check,color: Colors.white,)):Container( padding: const EdgeInsets.all(5) ,color: const Color(0xffff0000) ,child: const Icon(FontAwesomeIcons.xmark,color: Colors.white,),)  ,
                                subtitle: Text(" حالة الدورة: ${snapshot.data?.docs[index]['status']}"),
                                onTap: (){
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context){
                                        return MyOneReq(snapshot.data?.docs[index].data(), snapshot.data?.docs[index].id);
                                      }));
                                },
                              ),
                            ),
                          );
                        }
                        else {
                          return const SizedBox();
                        }
                      }
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