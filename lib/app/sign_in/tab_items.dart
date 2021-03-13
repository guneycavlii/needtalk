import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TabItem { Kullanicilar, Chat, Profil, Randevular }

class TabItemData {
  final String title;
  final IconData icon;

  TabItemData(this.title, this.icon);
  static Map<TabItem, TabItemData> tumTablar = {
    TabItem.Kullanicilar:
        TabItemData("Kullanicilar", Icons.supervised_user_circle),
    TabItem.Chat: TabItemData("Chat", Icons.chat),
    TabItem.Profil: TabItemData("Profil", Icons.person),
    TabItem.Randevular: TabItemData("Randevular", Icons.date_range)
    
  };
}
