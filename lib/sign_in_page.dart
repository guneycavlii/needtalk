import 'package:flutter/material.dart';
import 'package:needtalk/app/sign_in/emailsifregirisvekayit.dart';
import 'package:needtalk/common_widget/social_sign_in_button.dart';
import 'package:needtalk/viewmodel/usermodel.dart';
import 'package:provider/provider.dart';
import 'model/user.dart';

class SignInPage extends StatelessWidget {

  void _emailVeSifreIleGiris(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => EmailSifreGirisSayfasi(),
      ),
    );
  }

  void _googleIleGiris(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context,listen: false);
    User _user = await _userModel.signInWithGoogle();
    if (_user != null) {
      print("Oturum açan user Id:" + _user.userID.toString());
    } else {
      print("Google ile giriş yapılamadı.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Uygulamanın üst kısmı
        backgroundColor: Colors.teal.shade700,
        title: Text("Do you need to talk?"),
        
        elevation: 5,
      ),
      backgroundColor: Colors.white,
      body: Container(
          color: Colors.teal[300],
          padding: EdgeInsets.all(50.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            // Ortadan yazmaya başlar, yazdıkça yukarı kaydırır.
            children: <Widget>[
              // Yukarıdan aşağı doğru elemanlar sıralanıyor.

              Text(
                "Do you need to talk?",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Colors.white),
              ),

              SizedBox(
                // 8 pixellik boşluk bırakıyor başlığın altına.
                height: 8,
              ),
              SocialLogInButton(
                buttonText: "Email ve Şifre ile Oturum Aç",
                textColor: Colors.white,
                buttonColor: Colors.grey.shade900,
                buttonIcon: Image.asset("images/C.png"),
                onPressed: () => _emailVeSifreIleGiris(context),
                radius: 16,
              ),
              // SocialLogInButton(
              //   buttonText: "Facebook ile Oturum Aç",
              //   textColor: Color(0xFF334D92),
              //   buttonColor: Colors.white,
              //   buttonIcon: Image.asset("images/F.png"),
              //   onPressed: oturumac,
              //   radius: 16,
              // ),
              SocialLogInButton(
                buttonText: "Gmail ile Oturum Aç",
                textColor: Colors.white,
                buttonColor: Colors.grey.shade900,
                buttonIcon: Image.asset("images/G.png"),
                onPressed: () => _googleIleGiris(context),
                radius: 16,
              ),
              // SocialLogInButton(
              //   buttonText: "Misafir Girişi",
              //   textColor: Colors.blue,
              //   buttonColor: Colors.white,
              //   buttonIcon: Icon(
              //     Icons.people,
              //     color: Colors.blue,
              //     size: 28,
              //   ),
              //   onPressed: () => misafirgirisi(context),
              //   radius: 16,
              // )
            ],
          )),
    );
  }

  void oturumac() {}

  void misafirgirisi(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context);
    User _user = await _userModel.signInAnonymously();

    print("Oturum açan user Id:" + _user.userID.toString());
  }
}
