import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider.dart';

class SettingsPage extends StatefulWidget {
  final user;
  final id;
  SettingsPage(this.user, this.id);
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    var Prov = Provider.of<AuthP>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text("الاعدادات"), leading: IconButton(icon :const Icon(Icons.arrow_back), onPressed: () {
          Navigator.of(context).pushNamed('home') ;
        },),backgroundColor: Theme.of(context).colorScheme.primary,),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'معلومات الحساب',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: Text('اسم المستخدم', style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 18),),
                subtitle: Text(widget.user['name'],style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 18),),
              ),
              ListTile(
                title: Text('البريد الإلكتروني', style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 18),),
                subtitle: Text(widget.user['email'], style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 18),),
              ),
              Divider(),
              Text(
                'خيارات الحساب',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: Text('حذف الحساب', style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 18),),
                onTap: () async{
                  AwesomeDialog(
                    context: context,
                    width: 400,
                    title: "تأكيد حذف الدورة",
                    desc: 'هل انت متأكد من رغبتك في حذف الدورة بشكل نهائي؟',
                    dialogType: DialogType.warning,
                    animType: AnimType.rightSlide,
                    autoHide: const Duration(seconds: 60),
                    btnCancelOnPress: (){
                      Navigator.of(context).pop(context);
                    },
                    btnCancelColor: const Color(0xffff0000),
                    btnCancelText: "لا",
                    btnOkOnPress: () async {
                      Navigator.of(context).pushReplacementNamed('login');
                      await Prov.deleteAccount();
                    },
                    btnOkColor: Theme.of(context).colorScheme.primary,
                    btnOkText: "تأكيد",
                    buttonsTextStyle: const TextStyle(color: Colors.white),
                  ).show();
                },
              ),
              ListTile(
                title: Text('إعادة تعيين كلمة المرور',style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 18),),
                onTap: () async {
                  await Prov.resetPassword(widget.user['email']);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      content: const Text('تم إرسال رابط إعادة تعيين كلمة المرور إلى البريد الإلكتروني.', style: TextStyle(color: Colors.white),),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
