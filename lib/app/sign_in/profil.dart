import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:needtalk/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:needtalk/common_widget/social_sign_in_button.dart';
import 'package:needtalk/viewmodel/usermodel.dart';
import 'package:provider/provider.dart';

class ProfilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  TextEditingController _controllerUserName;
  File _profilFoto;
  @override
  void initState() {
    super.initState();
    _controllerUserName = TextEditingController();
  }

  @override
  void dispose() {
    _controllerUserName.dispose();
    super.dispose();
  }

  void _kameradanFotoCek() async {
    var profilfoto = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _profilFoto = profilfoto;
      Navigator.of(context).pop();
    });
  }

  void _galeridenResimSec() async {
    var profilfoto = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _profilFoto = profilfoto;
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    _controllerUserName.text = _userModel.user.userName;

    print("Profil sayfasındaki User Değerleri: " + _userModel.user.toString());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Profil"), actions: <Widget>[
        FlatButton(
          onPressed: () => _cikisIcinOnayIste(context),
          child: Text("Çıkış Yap", style: TextStyle(color: Colors.white)),
        )
      ]),
      body: SingleChildScrollView(
        child: Container(
         height: 800,
          color: Colors.teal[300],
          child: Padding(
          padding: const EdgeInsets.all(15),
          child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              height: 160,
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    leading: Icon(Icons.camera),
                                    title: Text("Kameradan çek"),
                                    onTap: () {
                                      _kameradanFotoCek();
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.image),
                                    title: Text("Galeriden seç"),
                                    onTap: () {
                                      _galeridenResimSec();
                                    },
                                  )
                                ],
                              ),
                            );
                          });
                    },
                    child: Card(
                      shape: StadiumBorder( side: BorderSide(color: Colors.white,width: 3)),
                      child: CircleAvatar(
                      radius: 90,
                      backgroundColor: Colors.white,
                      backgroundImage: _profilFoto == null
                          ? NetworkImage(_userModel.user.profilURL)
                          : FileImage(_profilFoto),
                    )),
                  )),
              Card(
               
                color: Colors.teal[50],
                child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  
                  enabled: false,
                  initialValue: _userModel.user.email,
                  readOnly:
                      true, // Kullanıcı tarafından değiştirilmesi engellendi.
                  decoration: InputDecoration(
                    labelText: "Emailiniz",
                    hintText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),),
              Card(
            
                color: Colors.teal[50],
                child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _controllerUserName,
                  decoration: InputDecoration(
                    labelText: "Nickname",
                    hintText: "Nickname",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SocialLogInButton(
                  buttonColor: Colors.teal[600],
                  buttonText: "Değişiklikleri Kaydet",
                  onPressed: () {
                    _userNameGuncelle(context);
                    _profilFotoGuncelle(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),),),
    );
  }

  Future<bool> _cikisyap(BuildContext context) async {

    final _userModel = Provider.of<UserModel>(context, listen: false);
    bool sonuc = await _userModel.signOut();
    return sonuc;
  }

  Future _cikisIcinOnayIste(BuildContext context) async {
    final sonuc = await PlatformDuyarliAlertDialog(
      baslik: "Emin misiniz?",
      icerik: "Çıkmak istediğinizden emin misiniz?",
      anaButonYazisi: "Evet",
      iptalButonYazisi: "Hayır",
    ).goster(context);

    if (sonuc == true) {
      _cikisyap(context);
    }
  }

  void _userNameGuncelle(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);

    if (_userModel.user.userName != _controllerUserName.text) {
      var updateResult = await _userModel.updateUserName(
          _userModel.user.userID, _controllerUserName.text);
      if (updateResult == true) {
        PlatformDuyarliAlertDialog(
          baslik: "Başarılı",
          icerik: "Username Değiştirildi.",
          anaButonYazisi: "Tamam",
        ).goster(context);
      } else {
        _controllerUserName.text = _userModel.user.userName;
        PlatformDuyarliAlertDialog(
          baslik: "Hata",
          icerik: "Username zaten kullanımda,farklı bir Username deneyiniz.",
          anaButonYazisi: "Tamam",
        ).goster(context);
      }
    }
  }

  void _profilFotoGuncelle(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (_profilFoto != null) {
      var url = await _userModel.uploadFile(
          _userModel.user.userID, "profil_foto", _profilFoto);

      print("gelen url:" + url);

      if (url != null) {
        PlatformDuyarliAlertDialog(
          //snackbar tostmesaj
          baslik: "Başarılı",
          icerik: "Profil fotoğrafınız güncellendi.",
          anaButonYazisi: "Tamam",
        ).goster(context);
      }
    }
  }
}
