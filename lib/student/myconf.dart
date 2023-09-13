import 'package:myplatform/management/onecon.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../provider.dart';
import 'myonereq.dart';
class MyConf extends StatefulWidget{
  final info;
  final id;
  MyConf(this.info, this.id);
  @override
  State<StatefulWidget> createState() {
    return MyConfState();
  }
}

class MyConfState extends State<MyConf>{
  @override
  Widget build(BuildContext context) {
    var Prov = Provider.of<AuthP>(context);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(" جلساتي "),backgroundColor:  Theme.of(context).colorScheme.primary,
            leading: IconButton(icon :const Icon(Icons.arrow_back), onPressed: () {
              Navigator.of(context).pop(context);
            },),
          ),
          body: FutureBuilder(
            future: Prov.conferance.get(),
            builder: (context, snapshot) {
              if(snapshot.hasError){}
              if(!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.data?.docs.isEmpty ?? true) {
                return const Center(child: Text("لا يوجد بيانات لعرضها"));
              }
              if(snapshot.hasData){
                return RefreshIndicator(
                  onRefresh: (){
                    return Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                      return MyConf(widget.info, widget.id);
                    }));
                  },
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index){
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: ListTile(
                            title: Text(" اسم الدورة: ${snapshot.data!.docs[index]['course_name']}"),
                            leading: snapshot.data!.docs[index]['status'] == "تم تسجيل الطالب"?Container( padding: EdgeInsets.all(5) ,color: Colors.green ,child: Icon(FontAwesomeIcons.check,color: Colors.white,)):Container( padding: EdgeInsets.all(5) ,color: Color(0xffff0000) ,child: Icon(FontAwesomeIcons.xmark,color: Colors.white,),)  ,
                            subtitle: Text(" حالة الدورة: ${snapshot.data!.docs[index]['status']}"),
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context){
                                    return OneCon(snapshot.data!.docs[index].data(), snapshot.data!.docs[index].id, widget.info, widget.id);
                                  }));
                            },
                          ),
                        );
                      }
                  ),
                );
              }
              return Center(child: CircularProgressIndicator(),);
            },
          ),
        )
    );
  }
}