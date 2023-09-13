import 'dart:io';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../provider.dart';

class EditCourse extends StatefulWidget{
  final edit;
  final id;
  EditCourse(this.edit, this.id);
  @override
  State<StatefulWidget> createState() {
    return EditCourseState();
  }

}

class EditCourseState extends State<EditCourse> {
  String te_name = "";
  String c_name = "";
  String price = "";
  String numclass = "";
  String title = "";
  String body = "";
  String imgure = "";
  File? img;
  bool stat = false;
  late Reference ref;
  GlobalKey<FormState> forms = GlobalKey<FormState>();
  DateTimeRange daterange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(const Duration(days: 10))
  );
  var startday;
  var endday;
  @override
  void initState() {
    stat = widget.edit['status']??"";
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var Prov = Provider.of<AuthP>(context);
    final start = daterange.start;
    final end = daterange.end;
    final difference = daterange.duration;
    Future pickDateRange() async{
      DateTimeRange? newDateRang = await showDateRangePicker(
          context: context,
          initialDateRange: daterange,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 100)));
      if(newDateRang == null){

      }
      startday = daterange.start;
      endday = daterange.end;
      setState(() {
        daterange = newDateRang!;
      });
    }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(" تعديل دورة ${widget.edit['course_name']}"),backgroundColor:  Theme.of(context).colorScheme.primary,
          leading: IconButton(icon :const Icon(Icons.arrow_back), onPressed: () {
            Navigator.of(context).pop(context);
          },),
        ),
        body: ListView(
          shrinkWrap: true,
          children: [
            Column(
              children: [
                Form(
                  key: forms,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: widget.edit['course_name'],
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "تعديل اسم الدورة",
                          labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary,),
                          prefixIcon: Icon(FontAwesomeIcons.discourse, color: Theme.of(context).colorScheme.primary,),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2.5)
                          ),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1)
                          ),
                        ),
                        style: TextStyle(color: Theme.of(context).colorScheme.secondary,),
                        maxLength: 30,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return ("خطأ");
                          }
                          return null;
                        },
                        onSaved: (val) {
                          c_name = val!;
                        },
                      ),
                      TextFormField(
                        initialValue: widget.edit['teatcher_name'],
                        minLines: 1,
                        maxLines: 3,
                        maxLength: 200,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "تعديل اسم المُدرس",
                          prefixIcon: Icon(FontAwesomeIcons.personChalkboard, color: Theme.of(context).colorScheme.primary,),
                          labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary,),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2.5)
                          ),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1)
                          ),
                        ),
                        style: TextStyle(color: Theme.of(context).colorScheme.secondary,),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return ("خطأ");
                          }
                          return null;
                        },
                        onSaved: (val) {
                          te_name = val!;
                        },
                      ),
                      TextFormField(
                        initialValue: widget.edit['price'],
                        minLines: 1,
                        maxLines: 3,
                        maxLength: 200,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "تعديل السعر",
                          prefixIcon: Icon(FontAwesomeIcons.moneyCheckDollar, color: Theme.of(context).colorScheme.primary,),
                          labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary,),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2.5)
                          ),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1)
                          ),
                        ),
                        style: TextStyle(color: Theme.of(context).colorScheme.secondary,),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return ("خطأ");
                          }
                          return null;
                        },
                        onSaved: (val) {
                          price = val!;
                        },
                      ),
                      TextFormField(
                        initialValue: widget.edit['houres'],
                        minLines: 1,
                        maxLines: 3,
                        maxLength: 200,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "تعديل الساعات",
                          prefixIcon: Icon(FontAwesomeIcons.hourglassStart, color: Theme.of(context).colorScheme.primary,),
                          labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary,),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2.5)
                          ),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1)
                          ),
                        ),
                        style: TextStyle(color: Theme.of(context).colorScheme.secondary,),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return ("خطأ");
                          }
                          return null;
                        },
                        onSaved: (val) {
                          numclass = val!;
                        },
                      ),
                      SwitchListTile(
                        value: stat,
                        onChanged: (val){
                          setState(() {
                            stat = val;
                          });
                        },
                        title: Text("الدورة مفتوحة للتسجيل", style: TextStyle(color: Theme.of(context).colorScheme.primary,),),
                        activeColor: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 10,),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          children: [
                            Visibility(
                                visible: stat == false? false : true,
                                child: const Text(" تاريخ بدء وانتهاء الدورة : ",)),
                            const SizedBox(height: 10,),
                            Row(
                              children: [
                                Expanded(
                                  child: MaterialButton(
                                    onPressed: stat == false? null : pickDateRange,
                                    color: Theme.of(context).colorScheme.primary,
                                    child: Text("${start.year}/ ${start.month}/ ${start.day}", style: const TextStyle(color: Colors.white)),
                                  ),
                                ),
                                Expanded(child: Visibility(visible: stat == false? false : true,child: const SizedBox(child: Icon(FontAwesomeIcons.leftLong), ))),
                                Expanded(
                                  child: MaterialButton(
                                    onPressed: stat == false? null : pickDateRange,
                                    color: Theme.of(context).primaryColor,
                                    child: Text("${end.year}/ ${end.month}/ ${end.day}", style: const TextStyle(color: Colors.white),),
                                  ),
                                ),
                              ],
                            ),
                            Visibility(
                                visible: stat == false? false : true,
                                child: const SizedBox(height: 10,)),
                            Visibility(
                                visible: stat == false? false : true,
                                child: Text(" عدد أيام الدورة : ${difference.inDays}",)),
                          ],
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          showBottonSheet(context);
                        },
                        color: Theme
                            .of(context)
                            .primaryColor,
                        child: const Text("تعديل صورة الدورة", style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),),
                      ),
                      MaterialButton(
                        onPressed: () async {
                          AwesomeDialog(
                            context: context,
                            width: 400,
                            title: "تأكيد حفظ التعديلات",
                            desc: 'هل انت متأكد من رغبتك في حفظ التعديلات؟',
                            dialogType: DialogType.warning,
                            animType: AnimType.rightSlide,
                            autoHide: const Duration(seconds: 60),
                            btnCancelOnPress: (){
                              Navigator.of(context).pop;
                            },
                            btnCancelColor: Theme.of(context).colorScheme.error,
                            btnCancelText: "لا",
                            btnOkOnPress: () async {
                              var data = forms.currentState;
                              if(stat == true){
                                if (img == null) {
                                  if (data!.validate()) {
                                    showDialog<void>(
                                      context: context,
                                      builder: (BuildContext dialogContext) {
                                        return const AlertDialog(
                                          title: Text('انتظر قليلا..'),
                                          content: SizedBox(height: 200,width: 200 ,child: Center(child: CircularProgressIndicator(),),),
                                        );
                                      },
                                    );
                                    data.save();
                                    await Prov.updateCourse(c_name, te_name, price, numclass, stat, widget.id,start, end, difference.inDays);
                                    Navigator.of(context).pushReplacementNamed('home');
                                    var bar = const SnackBar(content: Text("تم اجراء التعديلات"));
                                    ScaffoldMessenger.of(context).showSnackBar(bar);
                                  }
                                }
                                else if(img != null){
                                  if (data!.validate()) {
                                    showDialog<void>(
                                      context: context,
                                      builder: (BuildContext dialogContext) {
                                        return const AlertDialog(
                                          title: Text('انتظر قليلا..'),
                                          content: SizedBox(height: 200,width: 200 ,child: Center(child: CircularProgressIndicator(),),),
                                        );
                                      },
                                    );
                                    data.save();
                                    await ref.putFile(img!);
                                    imgure = await ref.getDownloadURL();
                                    await Prov.updateCourseWithAll(c_name, te_name, price, numclass, stat, imgure, widget.id,start, end, difference.inDays);
                                    Navigator.of(context).pushReplacementNamed('home');
                                    var bar = SnackBar(content: Text("تمت العملية بنجاح"), backgroundColor: Theme.of(context).primaryColor,);
                                    ScaffoldMessenger.of(context).showSnackBar(bar);
                                  }
                                }}
                              else{
                                if (img == null) {
                                  if (data!.validate()) {
                                    showDialog<void>(
                                      context: context,
                                      builder: (BuildContext dialogContext) {
                                        return AlertDialog(
                                          title: Text('انتظر قليلا..', style: TextStyle(color: Theme.of(context).primaryColor),),
                                          content: const SizedBox(height: 200,width: 200 ,child: Center(child: CircularProgressIndicator(),),),
                                        );
                                      },
                                    );
                                    data.save();
                                    await Prov.updateCourseWithoutAll(c_name, te_name, price, numclass, stat ,widget.id);
                                    Navigator.of(context).pushReplacementNamed('home');
                                    var bar = SnackBar(content: Text("تم اجراء التعديلات"), backgroundColor: Theme.of(context).primaryColor,);
                                    ScaffoldMessenger.of(context).showSnackBar(bar);
                                  }
                                }
                                else if(img == null){
                                  if (data!.validate()) {
                                    showDialog<void>(
                                      context: context,
                                      builder: (BuildContext dialogContext) {
                                        return AlertDialog(
                                          title: Center(child: Text('انتظر قليلاً..')),
                                          content: Container(
                                            height: 200,
                                            width: 200,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.white,
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.black12,
                                                  blurRadius: 10,
                                                  offset: Offset(0, 5),
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                valueColor: AlwaysStoppedAnimation<Color>(
                                                  Theme.of(context).colorScheme.primary,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                    data.save();
                                    await ref.putFile(img!);
                                    imgure = await ref.getDownloadURL();
                                    await Prov.updateCourseWithImg(c_name, te_name, price, numclass, stat,imgure ,widget.id);
                                    Navigator.of(context).pushReplacementNamed('home');
                                    var bar = SnackBar(content: Text("تمت العملية بنجاح"), backgroundColor: Theme.of(context).primaryColor,);
                                    ScaffoldMessenger.of(context).showSnackBar(bar);
                                  }
                                }
                              }
                            },
                            btnOkColor: Theme.of(context).colorScheme.primary,
                            btnOkText: "نعم",
                            buttonsTextStyle: const TextStyle(color: Colors.white),

                          ).show();
                        },
                        color: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 100, vertical: 10),
                        child: const Text("تعديل الدورة", style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),),
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),


      ),
    );
  }
  showBottonSheet(context){
    return showModalBottomSheet(context: context, builder: (context){
      return Container(
        padding: const EdgeInsets.only(top: 20),
        height: 260,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text("Choose Image:", style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),),
            ),
            const SizedBox(height: 20,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.photo,size: 50,color: Theme.of(context).colorScheme.primary,), onPressed: () async{
                      Navigator.of(context).pop();
                      var picked = await ImagePicker();
                      final XFile? photo = await picked.pickImage(source: ImageSource.gallery);
                      img = File(photo!.path);
                      var rand = Random(100000);
                      var name = "$rand${basename(photo.path)}";
                      ref = FirebaseStorage.instance.ref("images/$name");
                    },
                    ),
                    const SizedBox(height: 40,),
                    const Padding(
                      padding: EdgeInsets.only(left: 18.0, bottom: 55.0),
                      child: Text("المعرض",style: TextStyle(fontSize: 16),),
                    ),
                  ],
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.camera,size: 50,color: Theme.of(context).colorScheme.primary,), onPressed: () async{
                      Navigator.of(context).pop();
                      var picked = await ImagePicker();
                      final XFile? photo = await picked.pickImage(source: ImageSource.camera);
                      img = File(photo!.path);
                      var rand = Random(100000);
                      var name = "$rand${basename(photo.path)}";
                      ref = FirebaseStorage.instance.ref("images/$name");
                    },
                    ),
                    const SizedBox(height: 40,),
                    const Padding(
                      padding: EdgeInsets.only(left: 18.0, bottom: 55.0),
                      child: Text("الكاميرا",style: TextStyle(fontSize: 16),),
                    ),
                  ],
                ),

              ],
            ),
          ],
        ),
      );
    });
  }
}