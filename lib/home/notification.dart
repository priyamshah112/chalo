import 'package:chaloapp/services/DatabaseService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NotificationList extends StatefulWidget {
  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text('Notifications'),
      centerTitle: true,
    );
  }

  bool loading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            loading = false;
          });
          await Future.delayed(Duration(seconds: 2));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height -
                _buildAppBar().preferredSize.height -
                MediaQuery.of(context).padding.top,
            child: FutureBuilder(
              future: DataService().getNotification(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    loading) return Center(child: CircularProgressIndicator());
                if (snapshot.connectionState == ConnectionState.active &&
                        snapshot.data == null ||
                    !snapshot.hasData)
                  return Center(child: Text('No new notifications :)'));
                final List<DocumentSnapshot> notifications = snapshot.data;
                return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) => Card(
                            child: Slidable(
                          key: ValueKey(index),
                          actionPane: SlidableDrawerActionPane(),
                          secondaryActions: <Widget>[
                            IconSlideAction(
                              caption: 'Delete',
                              icon: Icons.delete,
                              color: Colors.red,
                              onTap: () async {
                                await notifications[index].reference.delete();
                                setState(() => notifications.removeAt(index));
                              },
                              closeOnTap: true,
                            )
                          ],
                          dismissal: SlidableDismissal(
                            child: SlidableDrawerDismissal(),
                            onDismissed: (actionType) async {
                              await notifications[index].reference.delete();
                              setState(() => notifications.removeAt(index));
                            },
                          ),
                          child: ListTile(
                              title:
                                  Text('${notifications[index].data['msg']}')),
                        )));
              },
            ),
          ),
        ),
      ),
    );
  }
}
