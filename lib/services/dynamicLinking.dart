import '../Activites/Activity_Detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DynamicLinkService {
  static Future<DocumentReference> retrieveDynamicLink(
      BuildContext context) async {
    DocumentReference ref;
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;
    if (deepLink != null) ref = await handleLink(deepLink);
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData data) async {
      final Uri deepLink = data?.link;
      if (deepLink != null)
        ref = await handleLink(deepLink, onResume: true, context: context);
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
    return ref;
  }

  static Future<String> createLink(String activityId, String admin) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://chaloactivity.page.link',
      link: Uri.parse('https://www.chalo.com/activity?id=$activityId'),
      androidParameters: AndroidParameters(
        packageName: 'com.northstarinnovations.chalo',
      ),
      // NOT ALL ARE REQUIRED ===== HERE AS AN EXAMPLE =====
      //   iosParameters: IosParameters(
      //     bundleId: 'com.example.ios',
      //     minimumVersion: '1.0.1',
      //     appStoreId: '123456789',
      //   ),
      //   googleAnalyticsParameters: GoogleAnalyticsParameters(
      //     campaign: 'example-promo',
      //     medium: 'social',
      //     source: 'orkut',
      //   ),
      //   itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
      //     providerToken: '123456',
      //     campaignToken: 'example-promo',
      //   ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'Chalo Activity Sharing',
        description: 'This link will take you to $admin\'s activity',
      ),
    );

    final Uri dynamicUrl = await parameters.buildUrl();
    final shortenedUrl = await DynamicLinkParameters.shortenUrl(
        dynamicUrl,
        DynamicLinkParametersOptions(
            shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short));
    return shortenedUrl.shortUrl.toString();
  }
}

Future<DocumentReference> handleLink(Uri deepLink,
    {bool onResume = false, BuildContext context}) async {
  DocumentReference ref;
  // print('deep link: $deepLink');
  bool isActivity = deepLink.pathSegments.contains('activity');
  if (isActivity) {
    String activityId = deepLink.queryParameters['id'];
    if (activityId != null) {
      ref = Firestore.instance.collection('plan').document(activityId);
      if (onResume) {
        final doc = await ref.get();
        Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => ActivityLink(activity : doc)));
      }
    }
  }
  return ref;
}
