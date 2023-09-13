

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myplatform/management/addconferance.dart';
import 'package:myplatform/management/onecon.dart';
import 'package:myplatform/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider.dart';

class Conferances extends StatefulWidget{
  final userinfo;
  final id;
  Conferances(this.userinfo, this.id);
  @override
  State<StatefulWidget> createState() {
    return ConferancesState();
  }
}

class ConferancesState extends State<Conferances>{
  @override
  Widget build(BuildContext context) {
    var Prov = Provider.of<AuthP>(context);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: widget.userinfo['type'] == 'مدير' && widget.userinfo['type'] != null? Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context){
                      return AddConferance(widget.userinfo, widget.id);
                    }));
              },
              backgroundColor: Theme.of(context).colorScheme.background,
              child: const Icon(Icons.add),
            ),
            appBar: AppBar(
              title: const Text("قائمة الجلسات"),
              backgroundColor: Theme.of(context).primaryColor,
              leading: IconButton(icon :const Icon(Icons.arrow_back), onPressed: () {
                Navigator.of(context).pushReplacementNamed('home');
              },),
            ),
            body:StreamBuilder(
                stream: Prov.conferance.orderBy('start', descending: true).snapshots(includeMetadataChanges: true),
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
                    return RefreshIndicator(
                      onRefresh: (){
                        return Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                          return Conferances(widget.userinfo, widget.id);
                        }));
                      },
                      child: ListView.builder(
                        itemCount: snapshot.data?.docs.length ?? 0,
                        itemBuilder: (context, index) {
                          final courseData = snapshot.data?.docs[index];
                          final courseName = courseData?['course_name'] ?? "";
                          final data = snapshot.data!.docs[index];
                          final timestamp = data['date'] as Timestamp;
                          final dateTime = timestamp.toDate();
                          final start = courseData?['start'] ?? "";
                          final end = courseData?['end'] ?? "";

                          return Container(
                            margin: const EdgeInsets.all(5),
                            child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  width: 1,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              child: ListTile(
                                title: Text(
                                  "اسم الدورة: $courseName",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.secondary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                leading: Text(
                                  "${index + 1}",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.secondary,
                                    fontSize: 15,
                                  ),
                                ),
                                subtitle: Column(
                                  children: [
                                    SizedBox(height: 20,),
                                    Text(
                                      "تاريخ الجلسة : ${dateTime.year}/${dateTime.month}/${dateTime.day}",
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.secondary,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Icon(
                                            Icons.access_alarm,
                                            color: Theme.of(context).colorScheme.secondary,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "$start",
                                            style: TextStyle(
                                              color: Theme.of(context).colorScheme.secondary,
                                              fontSize: 16
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Icon(
                                            Icons.arrow_circle_left_outlined,
                                            color: Theme.of(context).colorScheme.secondary,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "$end",
                                            style: TextStyle(
                                              color: Theme.of(context).colorScheme.secondary,
                                                fontSize: 16
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) {
                                      return OneCon(
                                        courseData?.data(),
                                        courseData?.id,
                                        widget.userinfo,
                                        widget.id,
                                      );
                                    }),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      )

                    );
                })):
        widget.userinfo['type'] == "معلم"?
        Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context){
                      return AddConferance(widget.userinfo, widget.id);
                    }));
              },
              backgroundColor: Theme.of(context).colorScheme.background,
              child: const Icon(Icons.add),
            ),
          appBar: AppBar(
            title: Text("قائمة الجلسات"),
            backgroundColor: Theme.of(context).colorScheme.primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('home');
              },
            ),
          ),
          body:StreamBuilder(
              stream: Prov.conferance.where("teatcher_name", isEqualTo: widget.userinfo['name']).snapshots(includeMetadataChanges: true),
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
                return RefreshIndicator(
                    onRefresh: (){
                      return Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                        return Conferances(widget.userinfo, widget.id);
                      }));
                    },
                    child: ListView.builder(
                      itemCount: snapshot.data?.docs.length ?? 0,
                      itemBuilder: (context, index) {
                        final courseData = snapshot.data?.docs[index];
                        final courseName = courseData?['course_name'] ?? "";
                        final data = snapshot.data!.docs[index];
                        final timestamp = data['date'] as Timestamp;
                        final dateTime = timestamp.toDate();
                        final start = courseData?['start'] ?? "";
                        final end = courseData?['end'] ?? "";

                        return Container(
                          margin: const EdgeInsets.all(5),
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                width: 1,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            child: ListTile(
                              title: Text(
                                "اسم الدورة: $courseName",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.secondary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              leading: Text(
                                "${index + 1}",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.secondary,
                                  fontSize: 15,
                                ),
                              ),
                              subtitle: Column(
                                children: [
                                  SizedBox(height: 20,),
                                  Text(
                                    "تاريخ الجلسة : ${dateTime.year}/${dateTime.month}/${dateTime.day}",
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Icon(
                                          Icons.access_alarm,
                                          color: Theme.of(context).colorScheme.secondary,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          "$start",
                                          style: TextStyle(
                                              color: Theme.of(context).colorScheme.secondary,
                                              fontSize: 16
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Icon(
                                          Icons.arrow_circle_left_outlined,
                                          color: Theme.of(context).colorScheme.secondary,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          "$end",
                                          style: TextStyle(
                                              color: Theme.of(context).colorScheme.secondary,
                                              fontSize: 16
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) {
                                    return OneCon(
                                      courseData?.data(),
                                      courseData?.id,
                                      widget.userinfo,
                                      widget.id,
                                    );
                                  }),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    )

                );
              })
        )
       :Scaffold(
          appBar: AppBar(
            title: Text("قائمة الجلسات"),
            backgroundColor: Theme.of(context).colorScheme.primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('home');
              },
            ),
          ),
          body: StreamBuilder(
            stream: Prov.conferance.orderBy('start', descending: true).snapshots(includeMetadataChanges: true),
            builder: (context, snapshot1) {
              if(!snapshot1.hasData || snapshot1.connectionState == ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot1.data?.docs.isEmpty ?? true) {
                return const Center(child: Text("لا يوجد بيانات لعرضها"));
              }
              if (snapshot1.hasError) {
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

              final List<Widget> conferenceWidgets = [];

              if (snapshot1.hasData) {
                final List<DocumentSnapshot> conferenceData = snapshot1.data!.docs;

                conferenceWidgets.addAll(conferenceData.map((conference) {
                  final courseName = conference['course_name'];
                  final timestamp = conference['date'] as Timestamp;
                  final dateTime = timestamp.toDate();
                  final matchingStudentStream = Prov.student
                      .where('course_name', isEqualTo: courseName)
                      .where('status', isEqualTo: 'تم تسجيل الطالب')
                      .snapshots();

                  return StreamBuilder<QuerySnapshot>(
                    stream: matchingStudentStream,
                    builder: (context, studentSnapshot) {
                      if (studentSnapshot.connectionState == ConnectionState.waiting) {
                        return Container(); // You can return a loading indicator here
                      }

                      final List<DocumentSnapshot> matchingStudents = studentSnapshot.data!.docs;

                      if (matchingStudents.isEmpty) {
                        return Container(); // Don't show anything if no matching student
                      }

                      return Container(
                        margin: const EdgeInsets.all(8),
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(width: 1, color: Theme.of(context).colorScheme.primary),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                return OneCon(conference.data(), conference.id, widget.userinfo, widget.id);
                              }));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "اسم الدورة: $courseName",
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.secondary,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "تاريخ الجلسة : ${dateTime.year}/${dateTime.month}/${dateTime.day}",
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                                  ),
                                  SizedBox(height: 18),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Icon(
                                          Icons.access_alarm,
                                          color: Theme.of(context).colorScheme.secondary,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          "${conference['start']}",
                                          style: TextStyle(
                                            color: Theme.of(context).colorScheme.secondary,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Icon(
                                          Icons.arrow_circle_left_outlined,
                                          color: Theme.of(context).colorScheme.secondary,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          "${conference['end']}",
                                          style: TextStyle(
                                            color: Theme.of(context).colorScheme.secondary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );

                    },
                  );
                }).toList());
              }

              return RefreshIndicator(
                onRefresh: () {
                  return Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                    return Conferances(widget.userinfo, widget.id);
                  }));
                },
                child: ListView(
                  children: conferenceWidgets,
                ),
              );
            },
          ),
        ),
    );



  }}

