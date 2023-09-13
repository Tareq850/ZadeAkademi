import 'package:myplatform/provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../courses.dart';
class MyCourse extends StatefulWidget{
  final info;
  final id;
  MyCourse(this.info, this.id);
  @override
  State<StatefulWidget> createState() {
    return MyCourseState();
  }
}

class MyCourseState extends State<MyCourse>{
  @override
  Widget build(BuildContext context) {
    var Prov = Provider.of<AuthP>(context);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(" كورساتي "),backgroundColor: Theme.of(context).colorScheme.primary,
            leading: IconButton(icon :const Icon(Icons.arrow_back), onPressed: () {
              Navigator.of(context).pop(context);
            },),
          ),
          body: FutureBuilder(
            future: Prov.course.where('teatcher_name', isEqualTo: widget.info['name']).get(),
            builder: (context, snapshot) {
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
                      return MyCourse(widget.info, widget.id);
                    }));
                  },
                  child: ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: ListTile(
                            title: Text(" اسم الدورة : ${snapshot.data?.docs[index]['course_name']??""}", style: TextStyle(color: Colors.black87),),
                            subtitle: snapshot.data?.docs[index]['status'] == true? const Text("الدورة مفتوحة"): const Text("الدورة مغلقة") ,
                            leading: snapshot.data?.docs[index]['status'] == true?Container( padding: const EdgeInsets.all(5) ,color: Colors.green ,child: const Icon(FontAwesomeIcons.check,color: Colors.white,)):Container( padding: const EdgeInsets.all(5) ,color: const Color(0xffff0000) ,child: const Icon(FontAwesomeIcons.xmark,color: Colors.white,),)  ,
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context){
                                    return Viewss(snapshot.data?.docs[index].data(), snapshot.data?.docs[index].id, widget.info['name']);
                                  }));
                            },
                          ),
                        );
                    },),
                );
              }
              return const SizedBox();
            },
          ),
        )
    );
  }
}