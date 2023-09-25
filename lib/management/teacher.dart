import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:myplatform/management/searchmanagmentteacher.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../provider.dart';
import 'onetech.dart';
class Teatcher extends StatefulWidget{
  final userinfo;
  final id;
  Teatcher(this.userinfo, this.id);
  @override
  State<StatefulWidget> createState() {
    return TeatcherState();
  }
}

class TeatcherState extends State<Teatcher>{
  @override
  Widget build(BuildContext context) {
    var Prov = Provider.of<AuthP>(context);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("قائمة الاساتذة"),
            backgroundColor: Theme.of(context).colorScheme.primary,
            leading: IconButton(icon :const Icon(Icons.arrow_back), onPressed: () {
              Navigator.of(context).pop(context);
            },),
            actions: [
              IconButton(onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchManagmentT(widget.userinfo)));
              },
                icon: const Icon(FontAwesomeIcons.magnifyingGlass),),
            ],
          ),

          body: FutureBuilder(
              future: Prov.users.where('type', isEqualTo: 'معلم').get(),
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
                if(snapshot.hasData){
                  return RefreshIndicator(
                    onRefresh: (){
                      return Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                        return Teatcher(widget.userinfo, widget.id);
                      }));
                    },
                    child: ListView.builder (
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index){
                          if(snapshot.data?.docs[index]['type'] == "معلم"){
                            return Container(
                              margin: EdgeInsets.all(5),
                              child: ListTile(
                                shape: Border.all(width: 1, color: Theme.of(context).colorScheme.primary,),
                                title: Text(" اسم الاستاذ : ${snapshot.data?.docs[index]['name']}",style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
                                leading: CircleAvatar(child: Image.network("${snapshot.data?.docs[index]['imgurl']}", width: double.infinity,height: 250, fit: BoxFit.cover,)),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                    return Onetech(snapshot.data?.docs[index].data(), snapshot.data?.docs[index].id);
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