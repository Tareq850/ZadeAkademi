import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text("الاشعارات"), leading: IconButton(icon :const Icon(Icons.arrow_back), onPressed: () {
          Navigator.of(context).pushReplacementNamed('home') ;
        },),backgroundColor: Theme.of(context).colorScheme.primary,),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Notifications').orderBy("time", descending: true).snapshots(includeMetadataChanges: true),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            List<DocumentSnapshot> notifications = snapshot.data!.docs;

            if (notifications.isEmpty) {
              return const Center(child: Text('لا توجد إشعارات حالياً.'));
            }

            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final data = notifications[index]['time']as Timestamp;
                final dateTime = data.toDate();
                String title = notifications[index]['title'];
                String message = notifications[index]['message'];
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: ListTile(
                    tileColor: index.isEven? Colors.black12 : Colors.white70 ,
                    title: Container( margin: EdgeInsets.only(right: 10), child: Text(title, style: TextStyle(color: Theme.of(context).colorScheme.primary,))),
                    subtitle: Container(margin: EdgeInsets.only(right: 10), child: Text(message, style: TextStyle(color: Theme.of(context).colorScheme.primary,))),
                    leading: const Icon(Icons.notifications_active),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(margin: EdgeInsets.only(right: 10), child: Text("${dateTime.year}/${dateTime.month}/${dateTime.day}" , style: TextStyle(color: Theme.of(context).colorScheme.secondary,))),
                        Container(margin: EdgeInsets.only(right: 10), child: Text("${dateTime.hour}:${dateTime.minute}:${dateTime.second}" , style: TextStyle(color: Theme.of(context).colorScheme.secondary,))),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
