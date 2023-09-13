import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider.dart';
import 'addexams.dart';
import 'editexams.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
class Exam extends StatefulWidget{
  final c_info;
  final c_id;
  final s_info;
  final s_id;
  Exam(this.c_info, this.c_id, this.s_info, this.s_id);
  @override
  State<StatefulWidget> createState() {
    return ExamState();
  }
}
class ExamState extends State<Exam>{
  openExam(exam_url) async{
    var examURl = Uri.parse(exam_url);
    await launchUrl(examURl);
  }
  @override
  Widget build(BuildContext context) {
    var Prov = Provider.of<AuthP>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: widget.s_info['type'] == 'مدير' && widget.s_info['type'] != null? Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context){
                    return AddExam(widget.c_info, widget.c_id, widget.s_info, widget.s_id);
                  }));
            },
            backgroundColor: Theme.of(context).colorScheme.background,
            child: const Icon(Icons.add),
          ),
          appBar: AppBar(
            title: const Text("قائمة الاختبارات"),
            backgroundColor: Theme.of(context).primaryColor,
            leading: IconButton(icon :const Icon(Icons.arrow_back), onPressed: () {
              Navigator.of(context).pushReplacementNamed('home');
            },),
          ),
          body:StreamBuilder(
              stream: Prov.exam.where("course_name", isEqualTo: widget.c_info['course_name']).snapshots(includeMetadataChanges: true),
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
                        return Exam(widget.c_info, widget.c_id, widget.s_info, widget.s_id);
                      }));
                    },
                    child: ListView.builder(
                      itemCount: snapshot.data?.docs.length ?? 0,
                      itemBuilder: (context, index) {
                        final courseData = snapshot.data?.docs[index];
                        final courseName = courseData?['course_name'] ?? "";
                        final teName = courseData?['teatcher_name'] ?? "";
                        final examUrl = courseData?['exam_url'] ?? "";
                        final data = snapshot.data!.docs[index];
                        final timestamp = data['date'] as Timestamp;
                        final dateTime = timestamp.toDate();
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
                            child: Slidable(
                              key: UniqueKey(),
                              startActionPane: ActionPane(
                                // A motion is a widget used to control how the pane animates.
                                motion: ScrollMotion(),
                                // All actions are defined in the children parameter.
                                children: [
                                  // A SlidableAction can have an icon and/or a label.
                                  SlidableAction(
                                    onPressed: (context) async {
                                      await Prov.exam.doc(courseData?.id).delete();
                                    },
                                    backgroundColor: Color(0xFFFE4A49),
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                  ),
                                  SlidableAction(
                                    onPressed:(context) {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                        return EditExam(courseData?.data(), courseData?.id);
                                      }));
                                    },
                                    backgroundColor: Color(0xFF21B7CA),
                                    foregroundColor: Colors.white,
                                    icon: Icons.edit,
                                  ),
                                  SlidableAction(
                                    onPressed:(context) {
                                      openExam(courseData?['result_url']);
                                    },
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    icon: Icons.search,
                                  ),
                                ],
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
                                      "تاريخ الاختبار : ${dateTime.year}/${dateTime.month}/${dateTime.day}",
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.secondary,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "اسم الأستاذ : $teName",
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  openExam(examUrl);
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    )

                );
              })):
      widget.s_info['type'] == "معلم"?
      Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context){
                    return AddExam(widget.c_info, widget.c_id, widget.s_info, widget.s_id);
                  }));
            },
            backgroundColor: Theme.of(context).colorScheme.background,
            child: const Icon(Icons.add),
          ),
          appBar: AppBar(
            title: const Text("قائمة الاختبارات"),
            backgroundColor: Theme.of(context).colorScheme.primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('home');
              },
            ),
          ),
          body:StreamBuilder(
              stream: Prov.exam.where("teatcher_name", isEqualTo: widget.s_info['name']).where("course_name", isEqualTo: widget.c_info["course_name"]).snapshots(includeMetadataChanges: true),
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
                        return Exam(widget.c_info, widget.c_id, widget.s_info, widget.s_id);
                      }));
                    },
                    child: ListView.builder(
                      itemCount: snapshot.data?.docs.length ?? 0,
                      itemBuilder: (context, index) {
                        final courseData = snapshot.data?.docs[index];
                        final courseName = courseData?['course_name'] ?? "";
                        final teName = courseData?['teatcher_name'] ?? "";
                        final examUrl = courseData?['exam_url'] ?? "";
                        final data = snapshot.data!.docs[index];
                        final timestamp = data['date'] as Timestamp;
                        final dateTime = timestamp.toDate();
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
                            child: Dismissible(
                              key: UniqueKey(),
                              onDismissed: (direction) {
                                // تنفيذ إجراء عند السحب (مثل حذف العنصر)
                                if (direction == DismissDirection.endToStart) {
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () async {
                                            await Prov.exam.doc(courseData?.id).delete();
                                          },
                                          icon: Icon(Icons.delete)
                                      ),
                                      IconButton(
                                          onPressed: (){
                                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                                                builder: (context){
                                                  return EditExam(snapshot.data?.docs[index].data(), snapshot.data?.docs[index].id);
                                                }));
                                          },
                                          icon: Icon(Icons.edit)
                                      ),
                                    ],
                                  );
                                }
                              },
                              background: Container(
                                color: Colors.red, // لون الخلفية عند الحذف
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
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
                                      "تاريخ الاختبار : ${dateTime.year}/${dateTime.month}/${dateTime.day}",
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.secondary,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "اسم الأستاذ : $teName",
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  openExam(examUrl);
                                },
                              ),
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
          title: Text("قائمة الاختبارات"),
          backgroundColor: Theme.of(context).colorScheme.primary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('home');
            },
          ),
        ),
        body: StreamBuilder(
          stream: Prov.exam.where("course_name", isEqualTo: widget.c_info['course_name']).snapshots(includeMetadataChanges: true),
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

            final List<Widget> examWidgets = [];

            if (snapshot1.hasData) {
              final List<DocumentSnapshot> examData = snapshot1.data!.docs;

              examWidgets.addAll(examData.map((exam) {
                final courseName = exam['course_name'];
                final teName = exam['teatcher_name'];
                final examUrl = exam['exam_url'];
                final timestamp = exam['date'] as Timestamp;
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
                            openExam(examUrl);
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
                                  "تاريخ الاختبار : ${dateTime.year}/${dateTime.month}/${dateTime.day}",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                                SizedBox(height: 18),
                                Text(
                                  "اسم الاستاذ: $teName",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.secondary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                  return Exam(widget.c_info, widget.c_id, widget.s_info, widget.s_id);
                }));
              },
              child: ListView(
                children: examWidgets,
              ),
            );
          },
        ),
      ),
    );
  }
}

