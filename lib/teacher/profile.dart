
import 'dart:io';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myplatform/student/check.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

import '../provider.dart';
class TeacherProfile extends StatefulWidget{
  final userInfo;
  final id;
  TeacherProfile(this.userInfo, this.id);
  @override
  State<StatefulWidget> createState() {
    return TeacherProfileState();
  }
}
List<String> genders = ["ذكر", "انثى"];
class TeacherProfileState extends State<TeacherProfile>{
  String specialization = "";
  String gender = genders[0];
  String country = "";
  String? state ;
  var ids;
  var phone ;
  var date;
  String imgure ="";
  File? img;
  late Reference ref;
  String city = "";
  String address = "";
  GlobalKey<FormState> forms = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var Prov = Provider.of<AuthP>(context);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(title: Text("الاستاذ"), leading: IconButton(icon :const Icon(Icons.arrow_back), onPressed: () {
            Navigator.of(context).pushReplacementNamed('home') ;
          },),backgroundColor: Theme.of(context).colorScheme.primary,),
          body: Container(
            margin: const EdgeInsets.all(10),
            child: Form(
              key: forms,
              child: ListView(
                children: [
                  Column(
                    children: [
                      const Center(child: Text("املأ الحقول التالية"),),
                      const SizedBox(height: 10,),
                      CSCPicker(
                        countryDropdownLabel: "*الدولة",
                        stateDropdownLabel: "الولاية",
                        cityDropdownLabel: "المدينة",
                        layout: Layout.vertical,
                        //countryFilter: [CscCountry.Turkey,CscCountry.United_Arab_Emirates,CscCountry.Saudi_Arabia,CscCountry.Egypt],
                        // dropdownDialogRadius: 30,
                        // searchBarRadius: 30,
                        onCountryChanged: (Country) {
                          country = Country;
                        },
                        //currentCountry: country,
                        onStateChanged:(State) {
                        },
                        onCityChanged:(City) {
                        },
                      ),
                      const SizedBox(height: 20,),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: IntlPhoneField(
                          decoration: const InputDecoration(
                            labelText: "موبايل الاستاذ",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(),
                                borderRadius: BorderRadius.all(Radius.circular(5))
                            ),
                          ),
                          style: TextStyle(color: Theme.of(context).colorScheme.secondary,),
                          initialCountryCode: "TR",
                          onChanged: (value) {
                            phone = value.number ;
                          },
                          onSaved: (val){
                            phone = val!.number;
                          },
                        ),
                      ),
                      const SizedBox(height: 20,),
                      DateTimeFormField(
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(color: Colors.black45),
                          errorStyle: TextStyle(color: Theme.of(context).colorScheme.error,),
                          border: const OutlineInputBorder(),
                          suffixIcon: Icon(Icons.event_note, color: Theme.of(context).colorScheme.primary,),
                          labelText: 'تاريخ الميلاد',
                        ),
                        mode: DateTimeFieldPickerMode.date,
                        autovalidateMode: AutovalidateMode.always,
                        validator: (e) => (e?.day ?? 0) == 1 ? 'رجاءً اختر تاريخ صحيح' : null,
                        onDateSelected: (DateTime value) {
                          date = value.year;
                        },
                        onSaved: (val){
                          date = val!.year;
                          //state = widget.reg['course_name'];
                        },
                        lastDate: DateTime.now(),
                      ),
                      const SizedBox(height: 20, ),
                      Row(
                        children: [
                          const Expanded(
                              flex: 2,
                              child: Text("الجنس", style: TextStyle(color : Color(0xffffffff)))),
                          //SizedBox(width: 150),
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Text("ذكر", style: TextStyle(color: Theme.of(context).primaryColor),),
                                Radio(
                                  onChanged: (val){
                                    setState(() {
                                      gender = val.toString();
                                    });
                                  },
                                  value:genders[0],
                                  groupValue: gender,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Text("انثى", style: TextStyle(color: Theme.of(context).primaryColor),),
                                Radio(
                                  onChanged: (val){
                                    setState(() {
                                      gender = val.toString();
                                    });
                                  },
                                  value: genders[1],
                                  groupValue: gender,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15,),
                      Directionality(textDirection:
                      TextDirection.rtl,
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                              specialization = value;
                            });
                          },
                          onSaved: (val) {
                            specialization = val!;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "يرجى كتابة الاختصاص";
                            }
                            return null;
                          },
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            labelText: "الاختصاص",
                            labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            focusColor: Theme.of(context).primaryColor,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1.0,
                                color: Theme.of(context).colorScheme.primary,
                              ),),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1.0,
                                color: Theme.of(context).colorScheme.primary,
                              ),),
                            suffixText: "${specialization.length}",
                          ),),
                      ),
                      const SizedBox(height: 15,),
                      MaterialButton(
                          onPressed: (){
                            showBottonSheet(context);},
                          color: Theme.of(context).colorScheme.primary,
                          child: const Text("أضف صورة شخصية", style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),)
                      ),
                      const SizedBox(height: 15,),
                      MaterialButton(
                        onPressed: () async {
                          if(img == null){
                            AwesomeDialog(
                              width: 400,
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.bottomSlide,
                              title: "محتوى فارغ",
                              desc: 'يرجى اختيار صورة',
                            ).show();
                          } else{
                              var data = forms.currentState;
                              if(data!.validate()){
                                showDialog<void>(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return AlertDialog(
                                      title: Text('انتظر من فضلك..', style: TextStyle(color: Theme.of(context).primaryColor),),
                                      content: const SizedBox(height: 200,width: 200 ,child: Center(child: CircularProgressIndicator(),),),
                                    );
                                  },
                                );
                                data.save();
                                await ref.putFile(img!);
                                imgure = await ref.getDownloadURL();
                                await Prov.techer_profile(
                                    widget.id,
                                    date,
                                    phone.toString(),
                                    country,
                                    gender,
                                    city,
                                    address,
                                    imgure,
                                    specialization
                                );
                                Navigator.of(context).pushReplacementNamed('home');
                              }
                              else{
                                var bar = SnackBar(content: const Text("فشلت العملية"), backgroundColor: Theme.of(context).primaryColor,);
                                ScaffoldMessenger.of(context).showSnackBar(bar);
                              }

                          }
                        },
                        color: Theme.of(context).colorScheme.primary,
                        child: const Text("اضافة المعلومات",style: TextStyle(color: Color(0xffffffff)),),
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
  showBottonSheet(context) {
    return showModalBottomSheet(context: context, builder: (context) {
      return Container(
        padding: const EdgeInsets.only(top: 20),
        height: 260,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text("اختر صورة:", style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),),
            ),
            const SizedBox(height: 20,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.photo, size: 50, color: Theme
                            .of(context)
                            .primaryColor), onPressed: () async {
                        Navigator.of(context).pop();
                        var picked = await ImagePicker();
                        final XFile? photo = await picked.pickImage(
                            source: ImageSource.gallery);
                        img = File(photo!.path);
                        var rand = Random(100000);
                        var name = "$rand${basename(photo.path)}";
                        ref = FirebaseStorage.instance.ref("images/$name");
                        var bar = const SnackBar(
                            content: Text("تمت اضافة الصورة بنجاح"));
                        ScaffoldMessenger.of(context).showSnackBar(bar);
                      },
                      ),
                      const SizedBox(height: 20,),
                      const Padding(
                        padding: EdgeInsets.only(left: 20.0, bottom: 100.0),
                        child: Text("المعرض", style: TextStyle(fontSize: 16),),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.camera, size: 50, color: Theme
                            .of(context)
                            .primaryColor), onPressed: () async {
                        Navigator.of(context).pop();
                        var picked = ImagePicker();
                        final XFile? photo = await picked.pickImage(
                            source: ImageSource.camera);
                        img = File(photo!.path);
                        var rand = Random(100000);
                        var name = "$rand${basename(photo.path)}";
                        ref = FirebaseStorage.instance.ref("images/$name");
                        var bar = const SnackBar(
                            content: Text("تمت اضافة الصورة بنجاح"));
                        ScaffoldMessenger.of(context).showSnackBar(bar);
                      },
                      ),
                      const SizedBox(height: 20,),
                      const Padding(
                        padding: EdgeInsets.only(left: 18.0, bottom: 100.0),
                        child: Text("الكاميرا", style: TextStyle(fontSize: 16),),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ],
        ),
      );
    });
  }
}