import 'dart:io';
import 'dart:math';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:myplatform/provider.dart';
class Social extends StatefulWidget{
  const Social({super.key});
  @override
  State<StatefulWidget> createState() {
    return SocialState();
  }
}
class SocialState extends State<Social> {
  String imgure ="";
  File? img;
  late Reference ref;
  @override
  Widget build(BuildContext context) {
    AuthP Prov = Provider.of<AuthP>(context);
    Prov.user_Type();
    if (Prov.manager == true){
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            Visibility(
              visible: img != null,
              child: MaterialButton(
                onPressed: () async {
                  await ref.putFile(img!);
                  imgure = await ref.getDownloadURL();
                  await Prov.update_Social(imgure);
                  Navigator.of(context).pushReplacementNamed('home');
                },
                color: Theme.of(context).primaryColor,
                child: const Text("اضافة", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () {
            showBottonSheet(context);
          },
        ),
        body: FutureBuilder(
          future: Prov.social.get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var socialUrl = snapshot.data?.docs[0]['social_url'];
              if (socialUrl != null && socialUrl.isNotEmpty) {
                return Center(
                  child: Image.network(
                    socialUrl,
                    width: double.infinity,
                    height: 400,
                    fit: BoxFit.cover,
                  ),
                );
              } else {
                // عنوان الصورة فارغ
                return const Center(
                  child: Text("لا توجد صورة متاحة"),
                );
              }
            } else if (snapshot.hasError) {
              // التعامل مع الخطأ إذا حدث
              return Center(
                child: Text("حدث خطأ أثناء تحميل البيانات"),
              );
            } else {
              // جاري تحميل البيانات
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );

    }else{
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: FutureBuilder(
            future: Prov.social.get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var socialUrl = snapshot.data?.docs[0]['social_url'];
                if (socialUrl != null && socialUrl.isNotEmpty) {
                  return Center(
                    child: Image.network(
                      socialUrl,
                      width: double.infinity,
                      height: 785,
                      fit: BoxFit.cover,
                    ),
                  );
                } else {
                  // عنوان الصورة فارغ
                  return Center(
                    child: Text("لا توجد صورة متاحة"),
                  );
                }
              } else if (snapshot.hasError) {
                // التعامل مع الخطأ إذا حدث
                return Center(
                  child: Text("حدث خطأ أثناء تحميل البيانات"),
                );
              } else {
                // جاري تحميل البيانات
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      );

    }
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
                        ref = FirebaseStorage.instance.ref("story/$name");
                        var bar = const SnackBar(
                            content: Text("تمت اضافة الصورة بنجاح"));
                        ScaffoldMessenger.of(context).showSnackBar(bar);
                        setState(() {
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
                        ref = FirebaseStorage.instance.ref("story/$name");
                        var bar = const SnackBar(
                            content: Text("تمت اضافة الصورة بنجاح"));
                        ScaffoldMessenger.of(context).showSnackBar(bar);
                        setState(() {
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