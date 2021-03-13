// Gelen veriye veya kullanıcın isteklerine göre arayüzün güncellenmesi setState'ten bizi kurtaracak olan yapı.
// Acaba hangi durumlarda arayüzümü güncellemek isterim?
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:needtalk/locator.dart';
import 'package:needtalk/model/konusmalar.dart';
import 'package:needtalk/model/mesaj.dart';
import 'package:needtalk/model/randevu.dart';
import 'package:needtalk/model/terapist.dart';
import 'package:needtalk/model/user.dart';
import 'package:needtalk/repository/user_repository.dart';
import 'package:needtalk/services/auth_base.dart';

enum ViewState { Idle, Busy }

class UserModel with ChangeNotifier implements AuthBase {
  
  ViewState _state = ViewState.Idle;
  UserRepository _userRepository = locator<UserRepository>();

  User _user;
  Terapist _terapist;

  String emailHataMesaji;
  String sifreHataMesaji;

  ViewState get state => _state;

  User get user => _user;
  Terapist get terapist => _terapist;


//State o anki kullanıcının verisi.

  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  UserModel()   {


    currentUser();
    currentTerapist();

  }

  // Artık Widgettan istekleri alıp bu usermodeli kullanarak repositorye yollayabilirim.
  // ve burda  olan işlemlere göre arayüzü güncelleyebilirim.

  @override
  Future<User> currentUser() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.currentUser();
      return _user;
    } catch (e) {
      debugPrint("VievModeldeki CurrentUser'da hata" + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }
  
 
  Future<Terapist> currentTerapist() async {
    try {
      state = ViewState.Busy;
      _terapist = await _userRepository.currentTerapist();
      return _terapist;
    } catch (e) {
      debugPrint("VievModeldeki CurrentTerapist'de hata" + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }



  @override
  Future<User> signInAnonymously() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.signInAnonymously();
      return _user;
    } catch (e) {
      debugPrint("VievModeldeki CurrentUser'da hata" + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      state = ViewState.Busy;
      bool sonuc = await _userRepository.signOut();
      _user = null;
      return sonuc;
    } catch (e) {
      debugPrint("VievModeldeki CurrentUser'da hata" + e.toString());
      return false;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.signInWithGoogle();
      return _user;
    } catch (e) {
      debugPrint("VievModeldeki CurrentUser'da hata" + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<User> createUserWithEmailAndPassword(
      String email, String sifre) async {
    if (_emailSifreKontrol(email, sifre)) {
      try {
        state = ViewState.Busy;
        _user =
            await _userRepository.createUserWithEmailAndPassword(email, sifre);

        return _user;
      } finally {
        state = ViewState.Idle;
      }
    } else
      return null;
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String sifre) async {
    if (_emailSifreKontrol(email, sifre)) {
      try {
        state = ViewState.Busy;
        _user = await _userRepository.signInWithEmailAndPassword(email, sifre);

        return _user;
      } finally {
        state = ViewState.Idle;
      }
    } else
      return null;
  }

   @override
  Future<Terapist> signInWithEmailAndPasswordforTerapist(String email, String sifre) async {
   if (_emailSifreKontrol(email, sifre)) {
      try {
        state = ViewState.Busy;
        _terapist = await _userRepository.signInWithEmailAndPasswordforTerapist(email, sifre);

        return _terapist;
      } finally {
        state = ViewState.Idle;
      }
    } else
      return null;
  }

  bool _emailSifreKontrol(String email, String sifre) {
    var sonuc = true;

    if (sifre.length < 6) {
      sifreHataMesaji = "Şifreniz en az 6 karakter olmalıdır.";
      sonuc = false;
    } else {
      sifreHataMesaji = null;
    }
    if (!email.contains('@')) {
      emailHataMesaji = "Geçersiz email adresi.";
      sonuc = false;
    } else {
      emailHataMesaji = null;
    }

    return sonuc;
  }

  Future<bool> updateUserName(String userID, String yeniUserName) async {
    var sonuc = await _userRepository.updateUserName(userID, yeniUserName);
    if (sonuc) {
      _user.userName = yeniUserName;
    }
    return sonuc;
  }

  Future<String> uploadFile(
      String userID, String fileType, File profilFoto) async {
    var indirmeLinki =
        await _userRepository.uploadFile(userID, fileType, profilFoto);
    return indirmeLinki;
  }

   Future<String> uploadFileT(
      String userID, String fileType, File profilFoto) async {
    var indirmeLinki =
        await _userRepository.uploadFileT(userID, fileType, profilFoto);
    return indirmeLinki;
  }

  Future<List<User>> getAllUser() async {
    var tumKullaniciListesi = await _userRepository.getAllUser();
    return tumKullaniciListesi;
  }
  Future<List<Terapist>> getAllTerapist() async {
    var tumTerapistListesi = await _userRepository.getAllTerapist();
    return tumTerapistListesi;
  }
   Future<List<Randevu>> getAllRandevus(String terapistID) async {
    var tumRandevuListesi = await _userRepository.getAllRandevus(terapistID);
    return tumRandevuListesi;
  }

  Stream<List<Mesaj>> getMessages(
      String currentUserID, String sohbetEdilenTerapistID) {
    return _userRepository.getMessages(currentUserID, sohbetEdilenTerapistID);
  }
  Stream<List<Mesaj>> getMessagesT(
  String currentTerapistID, String sohbetEdilenUserID
  ){
    return _userRepository.getMessagesT(currentTerapistID,sohbetEdilenUserID);
  }

  Future<bool> saveMessage(Mesaj kaydedilecekMesaj) async {
     return await _userRepository.saveMessage(kaydedilecekMesaj);
  }
  Future<bool> saveMessageT(Mesaj kaydedilecekMesaj) async {
     return await _userRepository.saveMessageT(kaydedilecekMesaj);
  }

  Future<List<Konusmalar>>getAllConversations(String userID) async {

return await _userRepository.getAllConversations(userID);

  }
   Future<List<Konusmalar>>getAllConversationsT(String terapistID) async {

return await _userRepository.getAllConversationsT(terapistID);

  }


 

 
}
