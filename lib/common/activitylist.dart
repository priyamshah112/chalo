import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/User.dart';

class ActivityList {
  static Future<List<List<String>>> getActivityList() async {
    final snapshot =
        await Firestore.instance.collection('chalo_activity').getDocuments();
    return List<List<String>>.generate(snapshot.documents.length, (index) {
      final doc = snapshot.documents[index];
      return [doc.data['logo'], doc.data['name'], 'false'];
    });
  }

  static Future<List<List<String>>> getSelectedActivityList() async {
    final user = await UserData.getUser();
    final userinfo = await Firestore.instance
        .collection('additional_info')
        .document(user['email'])
        .get();
    List<List<String>> selected = [];
    for (var activity in userinfo.data['interested_activities']) {
      var chaloactivity = await Firestore.instance
          .collection('chalo_activity')
          .document(activity)
          .get();
      selected.add([chaloactivity.data['logo'], chaloactivity['name']]);
    }
    return selected;
  }
}
