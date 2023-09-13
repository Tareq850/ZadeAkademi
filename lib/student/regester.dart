
import 'package:myplatform/student/check.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

import '../provider.dart';
class Regester extends StatefulWidget{
  final reg;
  final id;
  final username;
  Regester(this.reg, this.id, this.username);
  @override
  State<StatefulWidget> createState() {
    return RegesterState();
  }
}
List<String> genders = ["ذكر", "انثى"];
class RegesterState extends State<Regester>{
  String gender = genders[0];
  String country = "";
  String? state ;
  var phone ;
  var date;
  GlobalKey<FormState> forms = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var Prov = Provider.of<AuthP>(context);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(title: Text(" دورة : ${widget.reg['course_name']}"), leading: IconButton(icon :const Icon(Icons.arrow_back), onPressed: () {
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
                      Image.network("${widget.reg['imgurl']}", width: double.infinity,height: 250, fit: BoxFit.fill,),
                      const SizedBox(height: 10,),
                      const Center(child: Text("املأ الحقول التالية لتقديم طلب التسجيل"),),
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
                        onStateChanged:(State) {},
                        onCityChanged:(City) {},
                      ),
                      const SizedBox(height: 20,),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: IntlPhoneField(
                          decoration: const InputDecoration(
                            labelText: 'رقم الهاتف',
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
                          state = widget.reg['course_name'];
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
                      MaterialButton(
                        onPressed: () async {
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
                            Navigator.of(context).push(MaterialPageRoute(builder: (context){
                              return Check(country, phone, date, gender, widget.reg, widget.id, widget.username,);
                            }));
                            var bar = SnackBar(content: Text("تم التسجيل بالدورة، يرجى تأكيد الطلب"), backgroundColor: Theme.of(context).colorScheme.primary,);
                            ScaffoldMessenger.of(context).showSnackBar(bar);
                          }
                          else{
                            var bar = SnackBar(content: Text("فشل طلب التسجيل"), backgroundColor: Theme.of(context).primaryColor,);
                            ScaffoldMessenger.of(context).showSnackBar(bar);
                          }
                        },
                        color: Theme.of(context).colorScheme.primary,
                        child: const Text("تسجيل",style: TextStyle(color: Color(0xffffffff)),),
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
}