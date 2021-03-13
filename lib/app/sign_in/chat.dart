import 'package:flutter/material.dart';
import 'package:needtalk/model/konusmalar.dart';
import 'package:needtalk/viewmodel/usermodel.dart';
import 'package:provider/provider.dart';

import 'konusma.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Terapi Sayfası"),
        ),
        body: Container(
            color: Colors.teal[300],
            child: FutureBuilder<List<Konusmalar>>(
              future: _userModel.getAllConversations(_userModel.user.userID),
              builder: (context, konusmaListesi) {
                if (!konusmaListesi.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  var tumKonusmalar = konusmaListesi.data;
                  if (tumKonusmalar.length == 0) {
                    return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 80,),
                        Image.asset("images/needtalk.png",width: 200,height: 200,),
                        Card(
                          child: Text(
                            "Almış olduğunuz randevu tarihi ve saati geldiğinde \nterapistinizle buradan konuşabileceksiniz.\nRandevu almadıysanız, lütfen randevu alınız.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ));
                  } else {
                    return Padding(
                        padding: const EdgeInsets.all(10),
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            var oankiKonusma = tumKonusmalar[index];

                            return Card(
                                shape: StadiumBorder(
                                    side: BorderSide(
                                        color: Colors.white, width: 3)),
                                elevation: 6,
                                color: Colors.teal[50],
                                child: ListTile(
                                      onTap: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .push(
                                                //rootNavigator - Alt bölümün yok olmasını sağlıyor.
                                                MaterialPageRoute(
                                                  builder: (context) => Konusma(
                                                   currentUser: _userModel.user,
                                                   sohbetEdilenTerapistID: oankiKonusma.kimle_konusuyor,
                                                   sohbetEdilenTerapistProfilURL: oankiKonusma.konusulanUserProfilURL,
                                                   sohbetEdilenTerapistname: oankiKonusma.konusulanUserName,
                                                  ),
                                                ),
                                              );
                                            },
                                    trailing: Icon(
                                      Icons.message,
                                      color: Colors.teal[300],
                                    ),
                                    title:
                                        Text(oankiKonusma.son_yollanan_mesaj),
                                    subtitle:
                                        Text(oankiKonusma.konusulanUserName),
                                    leading: Card(
                                      shape: StadiumBorder(
                                          side: BorderSide(
                                              color: Colors.white, width: 1)),
                                      child: CircleAvatar(
                                        radius: 24,
                                        backgroundImage: NetworkImage(
                                            oankiKonusma
                                                .konusulanUserProfilURL),
                                      ),
                                    )));
                          },
                          itemCount: tumKonusmalar.length,
                        ));
                  }
                }
              },
            )));
  }

  // void _konusmalarimiGetir() async {
  //   final _userModel = Provider.of<UserModel>(context);
  //   var konusmalarim = await Firestore.instance
  //       .collection("konusmalar")
  //       .where("konusma_sahibi", isEqualTo: _userModel.user.userID)
  //       .orderBy("olusturulma_tarihi", descending: true)
  //       .getDocuments();

  //   for (var konusma in konusmalarim.documents) {
  //     print("konusma:" + konusma.data.toString());
  //   }
  // }
}
