import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../provider.dart';
class SearchMyStudent extends StatefulWidget{
  final info;
  SearchMyStudent(this.info);
  @override
  State<StatefulWidget> createState() {
    return SearchMyStudentState();
  }
}

class SearchMyStudentState extends State<SearchMyStudent>{
  String name = "";
  @override
  Widget build(BuildContext context) {
    var Prov = Provider.of<AuthP>(context);
    return SafeArea(
      child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Card(
                color: Colors.white,
                child: TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search), hintText: 'بحث عن طالب...', prefixIconColor: Theme.of(context).primaryColor),
                  style: TextStyle(color: Theme.of(context).colorScheme.secondary,),
                  onChanged: (val) {
                    setState(() {
                      name = val;
                    });
                  },
                ),
              ),
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: (name != "")
                  ? Prov.student.orderBy("name").startAt([name]).endAt([name + '\uf8ff']) .snapshots(includeMetadataChanges: true)
                  : Prov.student.snapshots(),
              builder: (context, snapshot) {
                return (snapshot.connectionState == ConnectionState.waiting)
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
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
                );
              },
            ),
          )
      ),
    );
  }
}