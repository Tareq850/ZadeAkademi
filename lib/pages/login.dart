import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:myplatform/pages/repassword.dart';
import 'package:myplatform/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override

  Widget build(BuildContext context) {
    var Prov = Provider.of<AuthP>(context);

    return kIsWeb?
    Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xfff6f9ff),
        body: Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 250, right: 100),
                //alignment: Alignment.topRight,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextFieldWeb(
                        _emailController,
                        "الايميل",
                        Icons.email,
                        TextInputType.emailAddress,
                            (value) {
                          if (value!.isEmpty || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return "الايميل المُدخل خاطئ أو غير موجود";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10,),
                      _buildTextFieldWeb(
                        _passwordController,
                        "كلمة السر",
                        Icons.password,
                        TextInputType.visiblePassword,
                            (value) {
                          if (value!.isEmpty) {
                            return "كلمة المرور ضعيفة";
                          }
                          return null;
                        },
                        isPassword: true,
                      ),
                      const SizedBox(height: 30,),
                      _buildLoginButtonWeb(Prov),
                      const SizedBox(height: 20,),
                      _buildForgotPasswordLink(),
                      const SizedBox(height: 25,),
                      _buildSignUpLink(),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                constraints: BoxConstraints(maxWidth: 600),
                //margin: const EdgeInsets.only(top: 40, bottom: 40),
                //alignment: Alignment.topLeft,
                height: 700,
                child: Lottie.asset('images/login.json'),
              ),
            ),
          ],
        ),
      ),
    )
    :Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: const Color(0xfff6f9ff),
            body: ListView(
              shrinkWrap: false,
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: 400),
                  margin: const EdgeInsets.only(top: 25, bottom: 25),
                  alignment: Alignment.topCenter,
                  height: 300,
                  child: Lottie.asset('images/login.json'),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField(
                          _emailController,
                          "الايميل",
                          Icons.email,
                          TextInputType.emailAddress,
                              (value) {
                            if (value!.isEmpty || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                              return "الايميل المُدخل خاطئ أو غير موجود";
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
                            return null;
                          },
                          isPassword: true,
                        ),
                        const SizedBox(height: 20,),
                        _buildLoginButton(Prov),
                        const SizedBox(height: 5,),
                        _buildForgotPasswordLink(),
                        const SizedBox(height: 10,),
                        _buildSignUpLink(),
                      ],
                    ),
                  ),
                )
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

      Widget _buildLoginButton(AuthP Prov) {
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
                bool loginSuccess = await Prov.login(_emailController.text, _passwordController.text);
                if (loginSuccess) {
                  await FirebaseMessaging.instance.subscribeToTopic("student");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("تمت عملية تسجيل الدخول"),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                  );
                  Navigator.of(context).pushReplacementNamed('home');
                }
                else{
                  AwesomeDialog(
                    width: 400,
                    context: context,
                    dialogType: DialogType.error,
                    animType: AnimType.bottomSlide,
                    title: "${Prov.errorMessag}",
                    desc: "يرجى معالجة المُدخلات الخاطئة",
                  ).show();
                }

              }
            },
            color: Theme.of(context).primaryColor,
            elevation: 0,
            highlightColor: Theme.of(context).primaryColor,
            focusColor: Theme.of(context).primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("تسجيل الدخول", style: TextStyle(fontSize: 20, color: Colors.white),),
                SizedBox(width: 30,),
                Icon(Icons.login, color: Colors.white,),
              ],
            ),
          ),
        );
      }
  Widget _buildLoginButtonWeb(AuthP Prov) {
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
                  title: const Center(child: Text('انتظر قليلاً..')),
                  content: Container(
                    height: 700,
                    width: 700,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 30,
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
            bool loginSuccess = await Prov.login(_emailController.text, _passwordController.text);
            if (loginSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("تمت عملية تسجيل الدخول"),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
              );
              Navigator.of(context).pushReplacementNamed('home');
            }
            else{
              AwesomeDialog(
                width: 1400,
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.bottomSlide,
                title: "${Prov.errorMessag}",
                desc: "يرجى معالجة المُدخلات الخاطئة",
              ).show();
            }

          }
        },
        color: Theme.of(context).primaryColor,
        elevation: 0,
        highlightColor: Theme.of(context).primaryColor,
        focusColor: Theme.of(context).primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("تسجيل الدخول", style: TextStyle(fontSize: 20, color: Colors.white),),
            SizedBox(width: 80,),
            Icon(Icons.login, color: Colors.white,),
          ],
        ),
      ),
    );
  }

      Widget _buildForgotPasswordLink() {
        return Center(
          child: InkWell(
            highlightColor: const Color(0xff7bffe4),
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return ResetPasswordPage();
              }));
            },
            child: Text(" نسيت كلمة السر",style: TextStyle(color: Theme.of(context).colorScheme.primary,),),
          ),
        );
      }

      Widget _buildSignUpLink() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("إذا كنت لا تملك حساب",style: TextStyle(color: Theme.of(context).colorScheme.secondary,)),
            InkWell(
              highlightColor: const Color(0xff7bffe4),
              onTap: (){
                Navigator.of(context).pushReplacementNamed('sign');
              },
              child: Text(" انشئ حساب الأن",style: TextStyle(color: Theme.of(context).colorScheme.primary,),),
            ),
          ],
        );
  }
}
