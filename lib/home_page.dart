import 'package:flutter/material.dart';
import 'package:needtalk/app/sign_in/kullanicilar.dart';
import 'package:needtalk/app/sign_in/my_custom_bottom_navi.dart';
import 'app/sign_in/chat.dart';
import 'app/sign_in/profil.dart';
import 'app/sign_in/tab_items.dart';
import 'model/user.dart';

//Burayı sadece oturum açmış kullanıcılar görecektir.
class HomePage extends StatefulWidget {
  
  final User user;

  HomePage({Key key, @required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

//HomePage'in amacı o anki tabı tutmak ve İlgili taba göre hangi sayfanın yükleneceğine karar vermek.
class _HomePageState extends State<HomePage> {
  
  TabItem _currentTab = TabItem.Kullanicilar;

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.Kullanicilar: GlobalKey<NavigatorState>(),
    TabItem.Chat: GlobalKey<NavigatorState>(),
    TabItem.Profil: GlobalKey<NavigatorState>(),
   
  };

//Hangi sayfa açılacaksa onun bilgisini versin.
  Map<TabItem, Widget> tumSayfalar() {
    return {
      TabItem.Kullanicilar: KullanicilarPage(),
      TabItem.Chat: ChatPage(),
      TabItem.Profil: ProfilPage(),
       
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //onWillPop Her geri butonuna bastığımızda tetiklenen bir metottur. True olursa geri butonu çalısır. False geriye gelme demektir.
      onWillPop: () async => !await navigatorKeys[_currentTab]
          .currentState
          .maybePop(), //maybepop bir önceki sayfada sayfa olup olmadığına bakıyor
      child: MyCustomBottomNavigation(
        sayfaOlusturucu: tumSayfalar(),
        navigatorKeys: navigatorKeys,
        currentTab: _currentTab,
        onSelectionTab: (secilenTab) {
          if (secilenTab == _currentTab) {
            navigatorKeys[secilenTab]
                .currentState
                .popUntil((route) => route.isFirst);
          } else {
            setState(() {
              _currentTab = secilenTab;
            });
          }

          debugPrint("Seçilen tab item " + secilenTab.toString());
        },
      ),
    );
  }
}
