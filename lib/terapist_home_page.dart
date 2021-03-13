import 'package:flutter/material.dart';
import 'app/sign_in/my_terapist_bottom_navi.dart';
import 'app/sign_in/randevular.dart';
import 'app/sign_in/tab_items2.dart';
import 'app/sign_in/terapist_chat.dart';
import 'app/sign_in/terapist_profil.dart';
import 'model/terapist.dart';

class TerapistHomePage extends StatefulWidget {
  
  final Terapist terapist;

  TerapistHomePage({Key key, this.terapist}) : super(key: key);

  @override
  _TerapistHomePageState createState() => _TerapistHomePageState();
}

class _TerapistHomePageState extends State<TerapistHomePage> {

  TabItem2 _currentTab = TabItem2.Randevular;

  Map<TabItem2, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem2.Randevular: GlobalKey<NavigatorState>(),
    TabItem2.Chat: GlobalKey<NavigatorState>(),
    TabItem2.Profil: GlobalKey<NavigatorState>(),
  };

//Hangi sayfa açılacaksa onun bilgisini versin.
  Map<TabItem2, Widget> tumSayfalar() {
    return {
      TabItem2.Randevular: RandevularPage(),
      TabItem2.Chat: TerapistChatPage(),
      TabItem2.Profil: TerapistProfilPage(),
    };
  }

  @override
  Widget build(BuildContext context) {
     return WillPopScope(
      //onWillPop Her geri butonuna bastığımızda tetiklenen bir metottur. True olursa geri butonu çalısır. False geriye gelme demektir.
      onWillPop: () async => !await navigatorKeys[_currentTab]
          .currentState
          .maybePop(), //maybepop bir önceki sayfada sayfa olup olmadığına bakıyor
      child: MyCustomBottomNavigationT(
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
