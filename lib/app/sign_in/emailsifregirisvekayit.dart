import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:needtalk/app/sign_in/hata_exception.dart';
import 'package:needtalk/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:needtalk/common_widget/social_sign_in_button.dart';
import 'package:needtalk/model/terapist.dart';
import 'package:needtalk/model/user.dart';
import 'package:needtalk/viewmodel/usermodel.dart';
import 'package:provider/provider.dart';

enum FormType { Register, LogIn }

class EmailSifreGirisSayfasi extends StatefulWidget {
  @override
  _EmailSifreGirisSayfasiState createState() => _EmailSifreGirisSayfasiState();
}

class _EmailSifreGirisSayfasiState extends State<EmailSifreGirisSayfasi> {
  Firestore _firestore = Firestore.instance;

  String _email, _sifre;
  String _butonText, _linkText;

  var _formType = FormType.Register;
  final _formKey = GlobalKey<FormState>();

  void _formSubmit(BuildContext context) async {
    _formKey.currentState.save();
    debugPrint("Email ve Şifre " + _email + "  " + _sifre);

    final _userModel = Provider.of<UserModel>(context, listen: false);

    if (_formType == FormType.LogIn) {
      try {
        if (await girisYapanDoktormu(_email) != null) {
          Terapist _girisYapanTerapist = await _userModel
              .signInWithEmailAndPasswordforTerapist(_email, _sifre);

          if (_girisYapanTerapist != null)
            print("Oturum açan Terapist ID: " + _girisYapanTerapist.terapistID);
        } else {
          User _girisYapanUser =
              await _userModel.signInWithEmailAndPassword(_email, _sifre);

          if (_girisYapanUser != null)
            print("Oturum açan kullanıcı ID: " +
                _girisYapanUser.userID.toString());
        }
      } on PlatformException catch (e) {
        PlatformDuyarliAlertDialog(
          baslik: "Oturum Açma Hata",
          icerik: Hatalar.goster(e.code),
          anaButonYazisi: "Tamam",
        ).goster(context);
      }
    } else {
      try {
        User _kayitOlanUser =
            await _userModel.createUserWithEmailAndPassword(_email, _sifre);
        if (_kayitOlanUser != null)
          print("Kayıt olan kullanıcı ID: " + _kayitOlanUser.userID.toString());
      } on PlatformException catch (e) {
        // Hatanın cinsini yazmak detay verir.
        PlatformDuyarliAlertDialog(
          baslik: "Kullanıcı Oluşturma Hata",
          icerik: Hatalar.goster(e.code),
          anaButonYazisi: "Tamam",
        ).goster(context);
        // Dışarıya basınca kaybolup kaybolmayacağı true-false
      }
    }
  }

  void _degistir() {
    // Formun tipini değiştirmek istiyorum.
    setState(() {
      _formType =
          _formType == FormType.LogIn ? FormType.Register : FormType.LogIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    final _userModel = Provider.of<UserModel>(context, listen: true);

    if (_userModel.user != null) {
      Future.delayed(Duration(milliseconds: 80), () {
        Navigator.of(context).pop();
      });
      // Gösterdiğimiz diyalogu göstermememizi sağlıyor.
    }
    if (_userModel.terapist != null) {
      Future.delayed(Duration(milliseconds: 80), () {
        Navigator.of(context).pop();
      });
      // Gösterdiğimiz diyalogu göstermememizi sağlıyor.
    }

    _butonText = _formType == FormType.LogIn ? "Giriş Yap" : "Kayıt Ol";
    _linkText = _formType == FormType.LogIn
        ? "Hesabınız yok mu? Kayıt Olun."
        : "Hesabınız var mı? Giriş Yapın.";

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.teal.shade700,
          title: Text("Giriş / Kayıt"),
        ),
        //SingleChildScrollView eğer fazla ekleme yaparsam kaymalar olmasın diye.
        body: _userModel.state == ViewState.Idle
            ? Center(child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      Image.asset("/images/needtalk.png",width: 200,height: 200,),
                      SizedBox(height: 10,),
                      TextFormField(
                        // Kullanıcıdan veri alma işlemleri burada yapılır.
                        keyboardType: TextInputType
                            .emailAddress, //@ işareti gibi .. lazım olan klavyeyeyi getirir.
                        decoration: InputDecoration(
                          errorText: _userModel.emailHataMesaji != null
                              ? _userModel.emailHataMesaji
                              : _userModel.emailHataMesaji = null,
                          prefixIcon: Icon(Icons.mail),
                          hintText: "E-mail",
                          labelText: "E-mail",
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        ),
                        onSaved: (String girilenEmail) {
                          _email = girilenEmail;
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        // Kullanıcıdan veri alma işlemleri burada yapılır.
                        obscureText:
                            true, //Şifre alanının gizli olmasını sağlar.
                        decoration: InputDecoration(
                          errorText: _userModel.sifreHataMesaji != null
                              ? _userModel.sifreHataMesaji
                              : _userModel.sifreHataMesaji = null,
                          prefixIcon: Icon(Icons.lock),
                          hintText: "Şifre",
                          labelText: "Şifre",
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        ),
                        onSaved: (String girilenSifre) {
                          _sifre = girilenSifre;
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      SocialLogInButton(
                        buttonText: _butonText,
                        buttonColor: Theme.of(context).primaryColor,
                        onPressed: () => _formSubmit(context),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //FLATBUTTON TIKLANILABİLİR YAZI
                      FlatButton(
                          onPressed: () => _degistir(), child: Text(_linkText)),
                    ]),
                  ),
                ),
              ))
            : Center(child: CircularProgressIndicator()));
  }

  Future<bool> girisYapanDoktormu(String email) async {
    var _emails = await _firestore
        .collection("terapistler")
        .where("email", isEqualTo:email)
        .getDocuments();

    if ( _emails.documents.length == 0) {
      return null;
    } else {
      return true;
    }
  }
}
