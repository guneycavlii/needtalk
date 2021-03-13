import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:needtalk/app/sign_in/tab_items2.dart';


class MyCustomBottomNavigationT extends StatelessWidget {
  const MyCustomBottomNavigationT(
      {Key key,
      @required this.currentTab,
      @required this.onSelectionTab,
      @required this.sayfaOlusturucu,
      @required this.navigatorKeys})
      : super(key: key);

  final TabItem2 currentTab;
  final ValueChanged<TabItem2>
      onSelectionTab; //Tıklanılan sayfanın verisini bir callback ile homepage'e geri yolluyor.
  final Map<TabItem2, Widget> sayfaOlusturucu;
  final Map<TabItem2, GlobalKey<NavigatorState>> navigatorKeys;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          _navItemOlustur(TabItem2.Randevular),
          _navItemOlustur(TabItem2.Chat),
          _navItemOlustur(TabItem2.Profil),
          
        ],
        onTap: (index) => onSelectionTab(TabItem2.values[index]),
      ),
      tabBuilder: (context, index) {
        final gosterilecekItem = TabItem2.values[index];

        return CupertinoTabView(
          navigatorKey: navigatorKeys[gosterilecekItem],
          builder: (context) {
          return sayfaOlusturucu[gosterilecekItem];
        });
      },
    );
  }

  BottomNavigationBarItem _navItemOlustur(TabItem2 tabItem) {
    final olusturulacakTab = TabItemData2.tumTablar[tabItem];

    return BottomNavigationBarItem(
      icon: Icon(olusturulacakTab.icon),
      title: Text(olusturulacakTab.title),
    );
  }
}
