import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider.dart';
import 'onetech.dart';
class SearchManagmentT extends StatefulWidget{
  final info;
  SearchManagmentT(this.info);
  @override
  State<StatefulWidget> createState() {
    return SearchManagmentTState();
  }
}

class SearchManagmentTState extends State<SearchManagmentT>{
  String name = "";
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
                      prefixIcon: Icon(Icons.search, color: Theme.of(context).primaryColor,), hintText: 'بحث عن دورة...'),
                  style: TextStyle(color: Theme.of(context).colorScheme.secondary,),                  onChanged: (val) {
                    setState(() {
                      name = val;
                    });
                  },
                ),
              ),
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: (name != "")
                  ? Prov.users.orderBy("name")
                  .startAt([name])
                  .endAt([name + '\uf8ff'])
                  .snapshots(includeMetadataChanges: true)
                  : Prov.users.snapshots(),
              builder: (context, snapshot) {
                return (snapshot.connectionState == ConnectionState.waiting)
                    ? const Center(child: CircularProgressIndicator())
                    :  ListView.builder (
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index){
                      if(snapshot.data?.docs[index]['type'] == "معلم"){
                        return Container(
                          margin: const EdgeInsets.all(5),
                          child: ListTile(
                            shape: Border.all(width: 1, color: Theme.of(context).colorScheme.primary,),
                            title: Text(" اسم الاستاذ : ${snapshot.data?.docs[index]['name']??""}", style: TextStyle(color: Theme.of(context).colorScheme.secondary,),),
                            leading: const Icon(Icons.accessibility),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                return Onetech(snapshot.data?.docs[index].data(), snapshot.data?.docs[index].id);
                              }));
                            },
                          ),
                        );
                      }

                      return const SizedBox();


                    }
                );
              },
            ),
          )
      ),
    );
  }
}