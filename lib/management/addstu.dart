import 'dart:io';
import 'dart:math';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:myplatform/provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../pages/home.dart';
import 'package:image_picker/image_picker.dart';
class AddStudent extends StatefulWidget{
  final user;
  final id;
  const AddStudent(this.user, this.id, {super.key});

  @override
  State<StatefulWidget> createState() {
    return AddStudentState();
  }

}
class AddStudentState extends State<AddStudent>{
  GlobalKey<FormState> forms = GlobalKey<FormState>();
  String te_name = "";
  String c_name = "";
  String price = "";
  String numclass = "";
  bool stat = false;
  String imgure ="";
  File? img;
  late Reference ref;
  String addfoto = "أضف صورة للدورة";
  var startday ;
  var endday;
  DateTimeRange daterange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(const Duration(days: 10))
  );
  @override
  Widget build(BuildContext context) {
    final start = daterange.start;
    final end = daterange.end;
    final difference = daterange.duration;    //num days difference.indays
    Future pickDateRange() async{
      DateTimeRange? newDateRang = await showDateRangePicker(
          context: context,
          saveText:  "حفظ",
          cancelText: "الغاء",
          textDirection: TextDirection.rtl,
          initialDateRange: daterange,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 100)));
      if(newDateRang != null){
      }
      startday = daterange.start;
      endday = daterange.end;
      setState(() {
        daterange = newDateRang!;
      });
    }
    var Prov = Provider.of<AuthP>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("إضافة دورة"),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: ListView(
          children: [
            Column(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  height: 150,
                  child: Lottie.asset('images/si.json'),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Form(
                    key: forms,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex:2,
                              child: TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    c_name = value;
                                  });
                                },
                                onSaved: (val){
                                  c_name = val!;
                                },
                                validator: (value){
                                  if(value!.isEmpty ){
                                    return ("يجب إضافة اسم الدورة.");
                                  }
                                  return null;
                                },
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(FontAwesomeIcons.discourse, color: Theme.of(context).colorScheme.primary,),
                                  labelText: "اسم الدورة",
                                  labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary,),
                                  focusColor: Theme.of(context).colorScheme.primary,
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.0, color: Theme.of(context).colorScheme.primary,)),
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.0, color: Theme.of(context).colorScheme.primary,)),
                                  suffixText: "${c_name.length}",
                                ),
                              ),
                            ),
                            const Expanded(
                                flex:1,
                                child: SizedBox(width: 5,)
                            ),
                            Expanded(
                              flex:2,
                              child: TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    te_name = value;
                                  });
                                },
                                onSaved: (val){
                                  te_name = val!;
                                },
                                validator: (value){
                                  if(value!.isEmpty ){
                                    return ("يجب اضافة اسم المُدرس");
                                  }
                                  return null;
                                },
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(FontAwesomeIcons.personChalkboard, color: Theme.of(context).colorScheme.primary,),
                                  labelText: "اسم الاستاذ",
                                  labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary,),
                                  focusColor: Theme.of(context).colorScheme.primary,
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.0, color: Theme.of(context).colorScheme.primary,)),
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.0, color: Theme.of(context).colorScheme.primary,)),
                                  suffixText: "${te_name.length}",
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              numclass = value;
                            });
                          },
                          onSaved: (val){
                            numclass = val!;
                          },
                          validator: (value){
                            if(value!.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(value)){
                              return ("يجب أن يكون رقم");
                            }
                            else {
                              return null;
                            }
                          },
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Icon(FontAwesomeIcons.hourglassStart, color: Theme.of(context).colorScheme.primary,),
                            labelText: "عدد الساعات",
                            labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary,),
                            focusColor: Theme.of(context).colorScheme.primary,
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.0, color: Theme.of(context).colorScheme.primary,)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.0, color: Theme.of(context).colorScheme.primary,)),
                            suffixText: "${numclass.length}",
                          ),
                        ),
                        const SizedBox(height: 10,),
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              price = value;
                            });
                          },
                          onSaved: (val){
                            price = val!;
                          },
                          validator: (value){
                            if(value!.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(value)){
                              return ("يجب أن يكون رقم");
                            }
                            else {
                              return null;
                            }
                          },
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Icon(FontAwesomeIcons.moneyCheckDollar, color: Theme.of(context).colorScheme.primary,),
                            labelText: "سعر الدورة",
                            labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary,),
                            focusColor: Theme.of(context).colorScheme.primary,
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.0, color: Theme.of(context).colorScheme.primary,)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.0, color: Theme.of(context).colorScheme.primary,)),
                            suffixIcon: Icon(Icons.attach_money, color: Theme.of(context).colorScheme.primary,),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        SwitchListTile(
                          value: stat,
                          onChanged: (val){
                            setState(() {
                              stat = val;
                            });
                          },
                          title: Text("الدورة مفتوحة للتسجيل" , style: TextStyle(color: Theme.of(context).colorScheme.primary,),),
                          activeColor: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            children: [
                              Visibility(
                                  visible: stat == false? false : true,
                                  child: Text(" تاريخ بدء وانتهاء الدورة : ", style: TextStyle(color : Theme.of(context).colorScheme.primary,),)),
                              const SizedBox(height: 10,),
                              Row(
                                children: [
                                  Expanded(
                                    child: MaterialButton(
                                      onPressed: stat == false? null : pickDateRange,
                                      color: Theme.of(context).colorScheme.primary,
                                      child: Text("${start.year}/ ${start.month}/ ${start.day}", style: const TextStyle(color: Colors.white))
                                    ),
                                  ),
                                  Expanded(child: Visibility(visible: stat == false? false : true,child: const SizedBox(child: Icon(FontAwesomeIcons.leftLong), ))),
                                  Expanded(
                                    child: MaterialButton(
                                      onPressed: stat == false? null : pickDateRange,
                                      color: Theme.of(context).colorScheme.primary,
                                      child: Text("${end.year}/ ${end.month}/ ${end.day}", style: const TextStyle(color: Colors.white),)
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
                        const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              onPressed: (){
                                showBottonSheet(context);},
                              color: Theme.of(context).colorScheme.primary,
                              child: Text(addfoto, style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),)
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 230,
                          height: 50,
                          child: MaterialButton (
                            onPressed: ()async{
                              if(img == null){
                                AwesomeDialog(
                                  width: 400,
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.bottomSlide,
                                  title: "محتوى فارغ",
                                  desc: 'يرجى اختيار صورة',
                                ).show();
                              }
                              if(startday != null && endday != null){
                                var data = forms.currentState;
                                if(data!.validate()){
                                  data.save();
                                  showDialog<void>(
                                    context: context,
                                    builder: (BuildContext dialogContext) {
                                      return AlertDialog(
                                        title: const Center(child: Text('انتظر قليلاً..')),
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
                                  await ref.putFile(img!);
                                  imgure = await ref.getDownloadURL();
                                  await Prov.add_Courses_Ac(c_name, te_name, price, numclass, stat, imgure, start, end, difference.inDays);
                                  Navigator.of(context).pushReplacementNamed('home');
                                  var bar = const SnackBar(content: Text("تمت اضافة الدورة"));
                                  ScaffoldMessenger.of(context).showSnackBar(bar);
                                }
                                else{
                                  AwesomeDialog(
                                    width: 400,
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.bottomSlide,
                                    title: "${Prov.errorMessag}",
                                    desc: 'يرجى تعبئة باقي الحقول',
                                  ).show();
                                }
                              }
                              else{
                                var data = forms.currentState;
                                if(data!.validate()){
                                  data.save();
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
                                  await ref.putFile(img!);
                                  imgure = await ref.getDownloadURL();
                                  await Prov.add_Courses(c_name, te_name, price, numclass, stat, imgure);
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)
                                  {
                                    return HomePage(Prov.user);
                                  }));
                                  var bar = SnackBar(content: Text("تمت اضافة الدورة",), backgroundColor: Theme.of(context).colorScheme.secondary,);
                                  ScaffoldMessenger.of(context).showSnackBar(bar);
                                }
                                else{
                                  AwesomeDialog(
                                    width: 400,
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.bottomSlide,
                                    title: "${Prov.errorMessag}",
                                    desc: 'يرجى تعبئة باقي الحقول',
                                  ).show();
                                }
                              }

                            },
                            color: Theme.of(context).colorScheme.primary,
                            elevation: 0,
                            highlightColor:Theme.of(context).colorScheme.primary,
                            focusColor: Theme.of(context).colorScheme.primary,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("اضافة الكورس", style: TextStyle(fontSize: 20, color: Colors.white),),
                                SizedBox(width: 30,),
                                Icon(FontAwesomeIcons.bullhorn, color: Colors.white,),
                              ],),
                          ),
                        ),
                      ],
                    ),

                  ),
                )
              ],
            )
          ],
        ),
      ),
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
                        setState(() {
                          addfoto = "تمت اضافة الصورة";
                        });
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
                        setState(() {
                          addfoto = "تمت اضافة الصورة";
                        });
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