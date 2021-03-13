import 'package:flutter/material.dart';
import 'package:needtalk/home_page.dart';
import 'package:needtalk/sign_in_page.dart';
import 'package:needtalk/terapist_home_page.dart';
import 'package:needtalk/viewmodel/usermodel.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    final _userModel = Provider.of<UserModel>(context);

    if (_userModel.state == ViewState.Idle) {

      if (_userModel.user != null) {
// Eğer sisteme kullanıcı giriş yapmışsa HomePage'e, terapist Giriş yapmışsa TerapistHomePage'e önder
        return HomePage(
          // Kullanıcılar için gözükecek sayfa.
          user: _userModel.user,
        );
      } else {
        if (_userModel.terapist != null) {
          return TerapistHomePage(
            terapist: _userModel.terapist,
          );
        } else {
          return SignInPage();
        }
      }
    } else {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
