import 'package:flutter/material.dart';
import 'package:needtalk/app/sign_in/konusma.dart';
import 'package:needtalk/app/sign_in/ornek.dart';
import 'package:needtalk/app/sign_in/randevupage.dart';
import 'package:needtalk/common_widget/social_sign_in_button.dart';
import 'package:needtalk/model/terapist.dart';
import 'package:needtalk/model/user.dart';
import 'package:needtalk/viewmodel/usermodel.dart';
import 'package:provider/provider.dart';

class KullanicilarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    // _userModel.getAllUser();
    _userModel.getAllTerapist();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Terapistler"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              Navigator.of(
                      context) //contextin yanına rootNavigator: true dersem tab bar gözükmez.
                  .push(MaterialPageRoute(
                      // fullscreenDialog: true,
                      builder: (context) =>
                          OrnekPage())); // builderin yanına fullscreenDialog: true (bilgisayyfası gibi)
            },
          )
        ],
      ),
      body: Container(
        color: Colors.teal[300],
        child: FutureBuilder<List<Terapist>>(
          // future: _userModel.getAllUser(),
          future: _userModel.getAllTerapist(),
          builder: (context, sonuc) {
            if (sonuc.hasData) {
              var tumTerapistler = sonuc.data;

              if (tumTerapistler.length - 1 > 0) {
                return ListView.builder(
                  itemCount: tumTerapistler.length,
                  itemBuilder: (context, index) {
                    if (sonuc.data[index].terapistID !=
                        _userModel.user.userID) {
                      var oankiTerapist = sonuc.data[index];

                      return Container(
                          padding: const EdgeInsets.all(4),
                          child: Card(
                              elevation: 4,
                              color: Colors.teal[50],
                              child: GestureDetector(
                                  child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          ListTile(
                                            trailing: Card(
                                              child: Column(
                                                children: <Widget>[
                                                  IconButton(
                                                      icon: Icon(
                                                        Icons.arrow_forward_ios,
                                                        size: 32,
                                                        color: Colors.teal,
                                                      ),
                                                      splashColor: Colors.amber,
                                                      onPressed: null),
                                                ],
                                              ),
                                            ),
                                            // onTap: () {
                                            //   Navigator.of(context,
                                            //           rootNavigator: true)
                                            //       .push(
                                            //     //rootNavigator - Alt bölümün yok olmasını sağlıyor.
                                            //     MaterialPageRoute(
                                            //       builder: (context) => Konusma(
                                            //         currentUser:
                                            //             _userModel.user,
                                            //         sohbetEdilenTerapist:
                                            //             oankiTerapist,
                                            //       ),
                                            //     ),
                                            //   );
                                            // },
                                            title: Card(
                                              elevation: 2,
                                              child: Center(
                                                child: Text(
                                                  "Prof. Dr. " +
                                                      oankiTerapist
                                                          .terapistName +
                                                      " " +
                                                      oankiTerapist
                                                          .terapistSurname,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.teal,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            subtitle: Text(oankiTerapist
                                                    .mezunOlduguOkul +
                                                "\nUzmanlık Alanı: " +
                                                oankiTerapist.uzmanlikAlani +
                                                "\n"),
                                            leading: Card(
                                              shape: StadiumBorder(
                                                  side: BorderSide(
                                                      color: Colors.teal,
                                                      width: 3)),
                                              child: CircleAvatar(
                                                radius: 24,
                                                backgroundImage: NetworkImage(
                                                    oankiTerapist.profilURL),
                                              ),
                                            ),
                                          ),
                                          SocialLogInButton(
                                            buttonText: "Randevu Al",
                                            buttonColor: Colors.blue,
                                            onPressed: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .push(
                                                //rootNavigator - Alt bölümün yok olmasını sağlıyor.
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      RandevuAlmaSayfasi(
                                                    currentUser:
                                                        _userModel.user,
                                                    sohbetEdilenTerapist:
                                                        oankiTerapist,
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                        ],
                                      )))));
                    } else {
                      return Container();
                    }
                  },
                );
              } else {
                return Center(
                  child: Text("Kayıtlı bir terapist yok."),
                );
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
