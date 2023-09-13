import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  bool _isSendingResetEmail = false;

  void _resetPassword() async {
    if (_emailController.text.isEmpty) {
      // يجب إدخال البريد الإلكتروني
      return ;
    }

    setState(() {
      _isSendingResetEmail = true;
    });

    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text);
      // تم إرسال رسالة إعادة تعيين كلمة المرور بنجاح
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("تم إرسال رسالة إعادة تعيين كلمة المرور")),
      );
      Navigator.of(context).pushReplacementNamed('login');
    } catch (e) {
      // حدث خطأ أثناء إرسال البريد الإلكتروني
      print("حدث خطأ: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("حدث خطأ أثناء إرسال البريد الإلكتروني")),
      );
    } finally {
      setState(() {
        _isSendingResetEmail = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("إعادة تعيين كلمة المرور", style: TextStyle(color: Colors.black87),),
        leading: IconButton(icon :const Icon(Icons.arrow_back), onPressed: () {
          Navigator.of(context).pushReplacementNamed('login');
        },),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "البريد الإلكتروني"),
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isSendingResetEmail ? null : _resetPassword,
              child: _isSendingResetEmail
                  ? const CircularProgressIndicator()
                  : const Text("إرسال رسالة إعادة تعيين كلمة المرور"),
            ),
          ],
        ),
      ),
    );
  }
}
