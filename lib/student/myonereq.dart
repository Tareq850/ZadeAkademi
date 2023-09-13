import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../provider.dart';
class MyOneReq extends StatefulWidget{
  final info;
  final id;
  MyOneReq(this.info, this.id);
  @override
  State<StatefulWidget> createState() {
    return MyOneReqState();
  }
}

class MyOneReqState extends State<MyOneReq>{
  openWhatsApp({required String phoneNumber, required String message}) async{
    var whatsapp =phoneNumber;
    var whatsappURl_android = Uri.parse("whatsapp://send?phone=$whatsapp&text=$message");
    var whatappURL_ios = Uri.parse("https://wa.me/$whatsapp?text=${Uri.parse(message)}");
    if(Platform.isIOS){
      // for iOS phone only
      if( await canLaunchUrl(whatappURL_ios)){
        await launchUrl(whatappURL_ios);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("واتس اب غير مثبت")));
      }
    }else{
      // android , web
      if( await canLaunchUrl(whatsappURl_android)){
        await launchUrl(whatsappURl_android);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("واتس اب غير مثبت")));
      }
    }
  }
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
          ),
          body: FutureBuilder(
            future: Prov.course.get(),
            builder: (context, snapshot){
              if(!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.data?.docs.isEmpty ?? true) {
                return const Center(child: Text("لا يوجد بيانات لعرضها"));
              }
              if(snapshot.hasData){
                return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    final data = snapshot.data?.docs[index]['enddate']as Timestamp;
                    final dateTime = data.toDate();
                    if(snapshot.data?.docs[index]['course_name'] == widget.info['course_name']){
                      return Column(
                        children: [
                          Image.network("${snapshot.data?.docs[index]['imgurl']}", width: double.infinity,height: 250, fit: BoxFit.cover,),
                          Container(
                              margin: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(" اسم الدورة: ${widget.info['course_name']}",style: TextStyle(color: Colors.black87),),
                                    leading: const Icon(FontAwesomeIcons.school),
                                  ),
                                  ListTile(
                                    title: Text(" اسم الاستاذ: ${snapshot.data?.docs[index]['teatcher_name']??""}", style: TextStyle(color: Colors.black87),),
                                    leading: const Icon(FontAwesomeIcons.personChalkboard),
                                  ),
                                  ListTile(
                                    title: Text(" عدد الساعات: ${snapshot.data!.docs[index]['houres']??""}", style: TextStyle(color: Colors.black87),),
                                    leading: const Icon(FontAwesomeIcons.hourglassStart),
                                  ),
                                  Visibility(
                                      visible: widget.info['status'] == "تم تسجيل الطالب"? false : true,
                                      child: ListTile(
                                        title: const Text("الانتقال الى واتس اب لتثبيت الطلب",style: TextStyle(color: Colors.green),),
                                        leading: const Icon(FontAwesomeIcons.whatsapp),
                                        onTap: (){
                                          openWhatsApp(phoneNumber: '+905058908442', message: 'ISAR');
                                        },
                                      )),
                                  ListTile(
                                    title:   widget.info['status'] == "تم تسجيل الطالب"?const Text("مسجل بالدورة",style: TextStyle(color: Colors.green)):const Text("بانتظار اتمام طلب التسجيل",style: TextStyle(color:  Colors.red)),
                                    leading: widget.info['status'] == "تم تسجيل الطالب"?const Icon(FontAwesomeIcons.check):const Icon(FontAwesomeIcons.ban),
                                  ),
                                  Visibility(
                                      visible: widget.info['status'] == "تم تسجيل الطالب"? true : false,
                                      child: ListTile(
                                        title: Text(" تاريخ انتهاء الدورة: ${dateTime.year} / ${dateTime.month} / ${dateTime.day}", style: TextStyle(color: Colors.black87)),
                                        leading: const Icon(FontAwesomeIcons.database),
                                      )),
                                  Visibility(
                                      visible: widget.info['status'] == "تم تسجيل الطالب"? true : false,
                                      child: ListTile(
                                        title: Text(" عدد أيام الدورة: ${snapshot.data!.docs[index]['number_days']}", style: TextStyle(color: Colors.black87)),
                                        leading: const Icon(FontAwesomeIcons.accusoft),
                                      )),
                                ],
                              )),
                        ],
                      );
                    }
                    else {
                      return const SizedBox();
                    }
                  },
                );
              }

              else{
                return const Center(child: CircularProgressIndicator() ,);
              }
            },
          ),
        )
    );
  }
}