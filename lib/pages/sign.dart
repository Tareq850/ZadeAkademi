import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:myplatform/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthP>(context);

    return kIsWeb? Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xfff6f9ff),
        body: Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 170),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextFieldWeb(
                        _nameController,
                        "الإسم الكامل",
                        Icons.person,
                        TextInputType.text,
                            (value) {
                          if (value!.isEmpty) {
                            return "يرجى كتابة الاسم";
                          }
                          if (value.length < 4) {
                            return "لا يوجد اسم أقل من أربعة أحرف";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10,),
                      _buildTextFieldWeb(
                        _emailController,
                        "الايميل",
                        Icons.email,
                        TextInputType.emailAddress,
                            (value) {
                          if (value!.isEmpty || !EmailValidator.validate(value, true)) {
                            return "الايميل فارغ أو غير صحيح";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15,),
                      _buildTextFieldWeb(
                        _passwordController,
                        "كلمة السر",
                        Icons.password,
                        TextInputType.visiblePassword,
                            (value) {
                          if (value!.isEmpty) {
                            return "كلمة المرور ضعيفة";
                          }
                          RegExp strongPasswordRegex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                          if (!strongPasswordRegex.hasMatch(value)) {
                            return "يجب أن تحتوي على حروف كبيرة وصغيرة وأرقام ورموز خاصة";
                          }
                          return null;
                        },
                        isPassword: true,
                      ),
                      const SizedBox(height: 30,),
                      _buildSignUpButtonWeb(authProvider),
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("إذا كنت تملك حساب ",style: TextStyle(color: Theme.of(context).colorScheme.secondary,)),
                          InkWell(
                            highlightColor: const Color(0xff7bffe4),
                            onTap: (){
                              Navigator.of(context).pushNamed("login");
                            },
                            child: Text(" سجل الدخول",style: TextStyle(color: Theme.of(context).colorScheme.primary,),),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                constraints: BoxConstraints(maxWidth: 600),
                alignment: Alignment.topCenter,
                height: 700,
                child: Lottie.asset('images/animation_ll7rkrmr.json'),
              ),
            ),
          ],
        ),
      ),
    ) :Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xfff6f9ff),
        body: ListView(
          shrinkWrap: false,
          children: [
            Container(
              alignment: Alignment.topCenter,
              height: 300,
              child: Lottie.asset('images/animation_ll7rkrmr.json'),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(
                      _nameController,
                      "الإسم الكامل",
                      Icons.person,
                      TextInputType.text,
                          (value) {
                        if (value!.isEmpty) {
                          return "يرجى كتابة الاسم";
                        }
                        if (value.length < 4) {
                          return "لا يوجد اسم أقل من أربعة أحرف";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10,),
                    _buildTextField(
                      _emailController,
                      "الايميل",
                      Icons.email,
                      TextInputType.emailAddress,
                          (value) {
                        if (value!.isEmpty || !EmailValidator.validate(value, true)) {
                          return "الايميل فارغ أو غير صحيح";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10,),
                    _buildTextField(
                      _passwordController,
                      "كلمة السر",
                      Icons.password,
                      TextInputType.visiblePassword,
                          (value) {
                        if (value!.isEmpty) {
                          return "كلمة المرور ضعيفة";
                        }
                        RegExp strongPasswordRegex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                        if (!strongPasswordRegex.hasMatch(value)) {
                          return "يجب أن تحتوي على حروف كبيرة وصغيرة وأرقام ورموز خاصة";
                        }
                        return null;
                      },
                      isPassword: true,
                    ),
                    const SizedBox(height: 15,),
                    _buildSignUpButton(authProvider),
                    const SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("إذا كنت تملك حساب ",style: TextStyle(color: Theme.of(context).colorScheme.secondary,)),
                        InkWell(
                          highlightColor: const Color(0xff7bffe4),
                          onTap: (){
                            Navigator.of(context).pushNamed("login");
                          },
                          child: Text(" سجل الدخول",style: TextStyle(color: Theme.of(context).colorScheme.primary,),),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, TextInputType keyboardType, FormFieldValidator<String> validator, {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword,
      validator: validator,
      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
        labelText: label,
        labelStyle: TextStyle(color: Theme.of(context).primaryColor),
        focusColor: Theme.of(context).primaryColor,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.0, color: Theme.of(context).primaryColor)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.0, color: Theme.of(context).primaryColor)),
        border: OutlineInputBorder(borderSide: BorderSide(width: 1.0, color: Theme.of(context).primaryColor)),
        errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.0, color: Theme.of(context).colorScheme.error)),
      ),
    );
  }
  Widget _buildTextFieldWeb(TextEditingController controller, String label, IconData icon, TextInputType keyboardType, FormFieldValidator<String> validator, {bool isPassword = false}) {
    return Container(
      //margin: EdgeInsets.symmetric(horizontal: 300),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword,
        validator: validator,
        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
          labelText: label,
          labelStyle: TextStyle(color: Theme.of(context).primaryColor),
          focusColor: Theme.of(context).primaryColor,
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.0, color: Theme.of(context).primaryColor)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.0, color: Theme.of(context).primaryColor)),
          border: OutlineInputBorder(borderSide: BorderSide(width: 1.0, color: Theme.of(context).primaryColor)),
          errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.0, color: Theme.of(context).colorScheme.error)),
        ),
      ),
    );
  }

  Widget _buildSignUpButton(AuthP authProvider) {
    return SizedBox(
      width: 230,
      height: 50,
      child: MaterialButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
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
              await authProvider.signup(_emailController.text, _passwordController.text);
              await authProvider.add(_emailController.text, _nameController.text, "طالب");
              await authProvider.login(_emailController.text, _passwordController.text);
              Navigator.of(context).pushReplacementNamed('home');
              await FirebaseMessaging.instance.subscribeToTopic("student");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("تم انشاء الحساب وتسجيل الدخول"),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
              );
          } else {
            AwesomeDialog(
              width: 400,
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.bottomSlide,
              title: "${authProvider.errorMessag}",
              desc: "يرجى معالجة المُدخلات الخاطئة",
            ).show();
          }
        },
        color: Theme.of(context).primaryColor,
        elevation: 0,
        highlightColor: Theme.of(context).primaryColor,
        focusColor: Theme.of(context).primaryColor,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("انشاء حساب", style: TextStyle(fontSize: 20, color: Colors.white),),
            SizedBox(width: 30,),
            Icon(Icons.girl_outlined, color: Colors.white,),
          ],
        ),
      ),
    );
  }
  Widget _buildSignUpButtonWeb(AuthP authProvider) {
    return SizedBox(
      width: 350,
      height: 70,
      child: MaterialButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            showDialog<void>(
              context: context,
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  title: Center(child: Text('انتظر قليلاً..')),
                  content: Container(
                    height: 500,
                    width: 500,
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
            await authProvider.signup(_emailController.text, _passwordController.text);
            await authProvider.add(_emailController.text, _nameController.text, "طالب");
            await authProvider.login(_emailController.text, _passwordController.text);
            Navigator.of(context).pushReplacementNamed('home');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("تم انشاء الحساب يرجى التحقق من الإيميل المُرسل من قِبلنا"),
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
            );
          } else {
            AwesomeDialog(
              width: 400,
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.bottomSlide,
              title: "${authProvider.errorMessag}",
              desc: "يرجى معالجة المُدخلات الخاطئة",
            ).show();
          }
        },
        color: Theme.of(context).primaryColor,
        elevation: 0,
        highlightColor: Theme.of(context).primaryColor,
        focusColor: Theme.of(context).primaryColor,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("انشاء حساب", style: TextStyle(fontSize: 20, color: Colors.white),),
            SizedBox(width: 30,),
            Icon(Icons.girl_outlined, color: Colors.white,),
          ],
        ),
      ),
    );
  }
}
