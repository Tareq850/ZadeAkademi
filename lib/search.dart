import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myplatform/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import 'courses.dart';
class Search extends StatefulWidget{
  final username;
  Search(this.username);
  @override
  State<StatefulWidget> createState() {
    return SearchState();
  }
}

class SearchState extends State<Search>{
  String name = "";
  final _random = Random();
  @override
  Widget build(BuildContext context) {
    var Prov = Provider.of<AuthP>(context);
    return SafeArea(
      child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Card(
                color: Colors.white,
                child: TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search), hintText: 'بحث عن دورة...',
                      iconColor: Theme.of(context).colorScheme.primary,
                      suffixIconColor: Theme.of(context).colorScheme.primary,
                      prefixIconColor: Theme.of(context).colorScheme.primary,
                  ),
                  style: TextStyle(color: Theme.of(context).colorScheme.secondary,),
                  onChanged: (val) {
                    setState(() {
                      name = val;
                    });
                  },
                ),
              ),
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: (name != "")
                  ? Prov.course
                  .orderBy("course_name")
                  .startAt([name])
                  .endAt([name + '\uf8ff'])
                  .snapshots(includeMetadataChanges: true)
                  : Prov.course.snapshots(),
              builder: (context, snapshot) {
                return (snapshot.connectionState == ConnectionState.waiting)
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot data = snapshot.data!.docs[index];
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                          return Viewss(data.data(), data.id, widget.username);
                        }));
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(500, _random.nextInt(100),
                              _random.nextInt(100), _random.nextInt(120)),
                        ),
                        child: Wrap(
                          direction: Axis.horizontal,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: Image.network('${data['imgurl']}',
                                  fit: BoxFit.cover,
                                  width: double.maxFinite,
                                  height: 150),
                            ),
                            ListTile(
                              title: Text("اسم الدورة : ${data['course_name']} ",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18)),
                              subtitle: Text(
                                "عدد الساعات : ${data['houres']}",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                              trailing: Text(
                                " السعر:  ${data['price']}",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),

          )
      ),
    );
  }
}