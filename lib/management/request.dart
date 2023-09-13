import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:myplatform/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'onerequest.dart';
class Requests extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return RequestsState();
  }
}

class RequestsState extends State<Requests>{
  @override
  Widget build(BuildContext context) {
    var Prov = Provider.of<AuthP>(context);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: AppBar(
              title: Text(" طلبات التسجيل"),backgroundColor:  Theme.of(context).colorScheme.primary,
              leading: IconButton(icon :Icon(Icons.arrow_back), onPressed: () {
                Navigator.of(context).pushReplacementNamed('home');
              },),
            ),
            body: StreamBuilder(
                stream: Prov.student.snapshots(includeMetadataChanges: true),
                builder: (context,snapshot) {
                  if(snapshot.hasError){
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
                  if (!snapshot.hasData){
                    return const Center(child: Text("لا يوجد بيانات لعرضها"));
                  }
                    return RefreshIndicator(
                      onRefresh: (){
                        return Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                          return Requests();
                        }));
                      },
                      child: ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context ,i){
                            return ListTile(
                              title: Text(" اسم الدورة : ${snapshot.data?.docs[i]['course_name']??""}", style: TextStyle(color: Colors.black87),),
                              subtitle: Text(" اسم الطالب  : ${snapshot.data?.docs[i]['name']??""}"),
                              leading: Text("${i + 1}"),
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                  return OneReq(snapshot.data?.docs[i].data(),snapshot.data?.docs[i].id);
                                }));
                              },
                            );
                          }
                      ),
                    );
                }

            )
        )
    );
  }
}