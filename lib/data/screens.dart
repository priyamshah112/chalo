import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';import '../Activites/all_activities.dart';
import '../Broadcast/broadcast.dart';
import '../Chat/chats.dart';
import '../Explore/explore.dart';
import '../home/home.dart';

class Screen {
  final String title;
  final IconData icon;
  final IconData activeIcon;
  final Widget page;
  final int index;
  const Screen(
      {@required this.index,
      @required this.title,
      @required this.icon,
      @required this.activeIcon,
      @required this.page});
  static final List<Screen> pages = [
    Screen(
        index: 0,
        icon: SimpleLineIcons.location_pin,
        activeIcon: Icons.location_on,
        title: 'Map',
        page: MainMap()),
    Screen(
        index: 1,
        icon: FontAwesomeIcons.list,
        activeIcon: FontAwesomeIcons.list,
        title: 'Activities',
        page: AllActivity()),
    Screen(
        index: 2,
        icon: Icons.wifi_tethering,
        activeIcon: Icons.wifi_tethering,
        title: 'Broadcast',
        page: Broadcast()),
    Screen(
      index: 3,
      icon: Icons.dashboard,
      activeIcon: Icons.dashboard,
      title: 'Explore',
      page: Explore(),
    ),
    Screen(
        index: 4,
        icon: Feather.message_square,
        activeIcon: Icons.chat,
        title: 'Chat',
        page: Chats())
  ];
}
