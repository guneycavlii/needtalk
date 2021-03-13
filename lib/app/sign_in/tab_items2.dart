import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TabItem2 { Randevular, Chat, Profil }

class TabItemData2 {
  final String title;
  final IconData icon;

  TabItemData2(this.title, this.icon);
  static Map<TabItem2, TabItemData2> tumTablar = {
    TabItem2.Randevular: TabItemData2("Randevular", Icons.date_range),
    TabItem2.Chat: TabItemData2("Chat", Icons.chat),
    TabItem2.Profil: TabItemData2("Profil", Icons.person),
  };
}
