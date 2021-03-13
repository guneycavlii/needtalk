import 'package:flutter/material.dart';
import 'package:needtalk/model/konusmalar.dart';
import 'package:needtalk/viewmodel/usermodel.dart';
import 'package:provider/provider.dart';


import 'konusmat.dart';
class TerapistChatPage extends StatefulWidget {
  @override
  _TerapistChatPageState createState() => _TerapistChatPageState();
}

class _TerapistChatPageState extends State<TerapistChatPage> {
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

          future: _userModel.getAllConversationsT(_userModel.terapist.terapistID),
          
          builder: (context, konusmaListesi) {
            if (!konusmaListesi.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {

              
              var tumKonusmalar = konusmaListesi.data;
              if(tumKonusmalar.length == 0) {
 return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Card(
                          child: Text(
                            "Herhangi bir konuşmanız bulunmamaktadır.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ));
              } else{
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
                    title: Text(oankiKonusma.son_yollanan_mesaj),
                     subtitle: Text( oankiKonusma.konusulanUserName),
                     leading: CircleAvatar(backgroundImage: NetworkImage(oankiKonusma.konusulanUserProfilURL),),
                     onTap: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .push(
                                                //rootNavigator - Alt bölümün yok olmasını sağlıyor.
                                                MaterialPageRoute(
                                                  builder: (context) => KonusmaT(
                                                   currentTerapist: _userModel.terapist,
                                                   sohbetEdilenUsername: oankiKonusma.konusulanUserName,
                                                   sohbetEdilenUserProfilURL: oankiKonusma.konusulanUserProfilURL,
                                                   sohbetEdilenUserID: oankiKonusma.kimle_konusuyor,
                                                  ),
                                                ),
                                              );
                                            },
                  ));
                },
                itemCount: tumKonusmalar.length,
              ));
              }
             
            }
          },
        )));
  }



}