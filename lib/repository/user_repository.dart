// Kullanıcı ile işlemlerin yapılacağı yer, gerekli mantıklar burada kurulacak.
// Firebase a mi gideyim yoksa fake'e mi gideyim.. aynı metotlar olması lazım
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:needtalk/locator.dart';
import 'package:needtalk/model/konusmalar.dart';
import 'package:needtalk/model/mesaj.dart';
import 'package:needtalk/model/randevu.dart';
import 'package:needtalk/model/terapist.dart';
import 'package:needtalk/model/user.dart';
import 'package:needtalk/services/auth_base.dart';
import 'package:needtalk/services/fake_auth_service.dart';
import 'package:needtalk/services/firebase_auth_service.dart';
import 'package:needtalk/services/firebase_storage_service.dart';
import 'package:needtalk/services/firestore_db_service.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthenticationService _fakeAuthenticationService =
      locator<FakeAuthenticationService>();
  FireStoreDBService _fireStoreDBService = locator<FireStoreDBService>();
  FirebaseStorageService _firebaseStorageService =
      locator<FirebaseStorageService>();
  AppMode appMode = AppMode
      .RELEASE; // Sadece burayı değiştirerek FAKE-FİREBASE SEÇİMİ YAPABİLİRİZ.

  List<User> tumKullaniciListesi = [];
  List<Terapist> tumTerapistListesi = [];
  List<Randevu> tumRandevuListesi = [];

  Firestore _firestore = Firestore.instance;

  @override
  Future<User> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.currentUser();
    } else {
      User _user = await _firebaseAuthService.currentUser();

      if (await girisYapanDoktormu(_user.email) != null) {
        return null;
      } else {
        bool _sonuc = await _fireStoreDBService.saveUser(_user);
        if (_sonuc) {
          return await _fireStoreDBService.readUser(_user.userID);
        } else {
          return null;
        }
      }
    }
  }

  Future<Terapist> currentTerapist() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.currentTerapist();
    } else {
      Terapist _terapist = await _firebaseAuthService.currentTerapist();

      if (_terapist != null) {
        return await _fireStoreDBService.readTerapist(_terapist.terapistID);
      } else {
        return null;
      }
    }
  }

  @override
  Future<User> signInAnonymously() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.signInAnonymously();
    } else {
      return await _firebaseAuthService.signInAnonymously();
    }
  }

  @override
  Future<bool> signOut() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.signOut();
    } else {
      return await _firebaseAuthService.signOut();
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.signInWithGoogle();
    } else {
      User _user = await _firebaseAuthService.signInWithGoogle();
      bool _sonuc = await _fireStoreDBService.saveUser(_user);
      if (_sonuc) {
        return await _fireStoreDBService.readUser(_user.userID);
      } else {
        return null;
      }
    }
  }

  @override
  Future<User> createUserWithEmailAndPassword(
      String email, String sifre) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.createUserWithEmailAndPassword(
          email, sifre);
    } else {
      User _user = await _firebaseAuthService.createUserWithEmailAndPassword(
          email, sifre);
      bool _sonuc = await _fireStoreDBService.saveUser(_user);
      if (_sonuc) {
        return await _fireStoreDBService.readUser(_user.userID);
      } else {
        return null;
      }
    }
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String sifre) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.signInWithEmailAndPassword(
          email, sifre);
    } else {
      User _user =
          await _firebaseAuthService.signInWithEmailAndPassword(email, sifre);
      return await _fireStoreDBService.readUser(_user.userID);
    }
  }

  Future<Terapist> signInWithEmailAndPasswordforTerapist(
      String email, String sifre) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService
          .signInWithEmailAndPasswordforTerapist(email, sifre);
    } else {
      Terapist _terapist = await _firebaseAuthService
          .signInWithEmailAndPasswordforTerapist(email, sifre);
      return await _fireStoreDBService.readTerapist(_terapist.terapistID);
    }
  }

  Future<bool> updateUserName(String userID, String yeniUserName) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return await _fireStoreDBService.updateUserName(userID, yeniUserName);
    }
  }

  Future<String> uploadFile(
      String userID, String fileType, File profilFoto) async {
    if (appMode == AppMode.DEBUG) {
      return "dosya_indirme_linki";
    } else {
      var profilFotoURL = await _firebaseStorageService.uploadFile(
          userID, fileType, profilFoto);
      await _fireStoreDBService.updateProfilFoto(userID, profilFotoURL);
      return profilFotoURL;
    }
  }
  Future<String> uploadFileT(
      String userID, String fileType, File profilFoto) async {
    if (appMode == AppMode.DEBUG) {
      return "dosya_indirme_linki";
    } else {
      var profilFotoURL = await _firebaseStorageService.uploadFileT(
          userID, fileType, profilFoto);
      await _fireStoreDBService.updateProfilFotoT(userID, profilFotoURL);
      return profilFotoURL;
    }
  }

  Future<List<User>> getAllUser() async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      tumKullaniciListesi = await _fireStoreDBService.getAllUser();
      return tumKullaniciListesi;
    }
  }

  Future<List<Terapist>> getAllTerapist() async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      tumTerapistListesi = await _fireStoreDBService.getAllTerapist();
      return tumTerapistListesi;
    }
  }
  Future<List<Randevu>> getAllRandevus(String terapistID) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      tumRandevuListesi = await _fireStoreDBService.getAllRandevus(terapistID);
      return tumRandevuListesi;
    }
  }


  Stream<List<Mesaj>> getMessages(
      String currentUserID, String sohbetEdilenTerapistID) {
    if (appMode == AppMode.DEBUG) {
      return Stream.empty();
    } else {
      return _fireStoreDBService.getMessages(
          currentUserID, sohbetEdilenTerapistID);
    }
  }
  
  Stream<List<Mesaj>> getMessagesT(
      String currentTerapistID, String sohbetEdilenUserID) {
    if (appMode == AppMode.DEBUG) {
      return Stream.empty();
    } else {
      return _fireStoreDBService.getMessagesT(
          currentTerapistID, sohbetEdilenUserID);
    }
  }

  Future<bool> saveMessage(Mesaj kaydedilecekMesaj) async {
    if (appMode == AppMode.DEBUG) {
      return true;
    } else {
      return _fireStoreDBService.saveMessage(kaydedilecekMesaj);
    }
  }
   Future<bool> saveMessageT(Mesaj kaydedilecekMesaj) async {
    if (appMode == AppMode.DEBUG) {
      return true;
    } else {
      return _fireStoreDBService.saveMessageT(kaydedilecekMesaj);
    }
  }

  Future<List<Konusmalar>> getAllConversations(String userID) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      var konusmaListesi =
          await _fireStoreDBService.getAllConversations(userID);

      for (var oankiKonusma in konusmaListesi) {
        var userListesindekiKullanici =
            listedeUserBul(oankiKonusma.kimle_konusuyor);
        if (userListesindekiKullanici != null) {
          print("VERİLER LOCAL CACHEDEN OKUNDU");
          oankiKonusma.konusulanUserName =
              userListesindekiKullanici.terapistName +
                  " " +
                  userListesindekiKullanici.terapistSurname;
          oankiKonusma.konusulanUserProfilURL =
              userListesindekiKullanici.profilURL;
        }
        // else {
        //   print("VERİLER VERİTABANINDAN OKUNDU");
        //   print(
        //       "Aranılan user daha önceden veri tabanından getirilmemiştir. o yüzden veri tabanından bu değeri okumalıyız.");
        //       var veritabanindanOkunanUser = await _fireStoreDBService.readUser(oankiKonusma.kimle_konusuyor);
        //       oankiKonusma.konusulanUserName = veritabanindanOkunanUser.userName;
        //       oankiKonusma.konusulanUserProfilURL = veritabanindanOkunanUser.profilURL;
        // }
      }
      return konusmaListesi;
    }
  }
    Future<List<Konusmalar>> getAllConversationsT(String terapistID) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      var konusmaListesi =
          await _fireStoreDBService.getAllConversationsT(terapistID);

      for (var oankiKonusma in konusmaListesi) {
        var userListesindekiKullanici =
            listedeTerapistBul(oankiKonusma.kimle_konusuyor);
        if (userListesindekiKullanici != null) {
          print("VERİLER LOCAL CACHEDEN OKUNDU");
          oankiKonusma.konusulanUserName =
              userListesindekiKullanici.userName;
          oankiKonusma.konusulanUserProfilURL =
              userListesindekiKullanici.profilURL;
        }
         else {
           print("VERİLER VERİTABANINDAN OKUNDU");
          print(
              "Aranılan user daha önceden veri tabanından getirilmemiştir. o yüzden veri tabanından bu değeri okumalıyız.");
              var veritabanindanOkunanUser = await _fireStoreDBService.readUser(oankiKonusma.kimle_konusuyor);
             oankiKonusma.konusulanUserName = veritabanindanOkunanUser.userName;
             oankiKonusma.konusulanUserProfilURL = veritabanindanOkunanUser.profilURL;
        }
      }
      return konusmaListesi;
    }
  }

  Terapist listedeUserBul(String terapistID) {
    for (int i = 0; i < tumTerapistListesi.length; i++) {
      if (tumTerapistListesi[i].terapistID == terapistID) {
        return tumTerapistListesi[i];
      }
    }
    return null;
  }
   User listedeTerapistBul(String userID) {
    for (int i = 0; i < tumKullaniciListesi.length; i++) {
      if (tumKullaniciListesi[i].userID == userID) {
        return tumKullaniciListesi[i];
      }
    }
    return null;
  }

  Future<bool> girisYapanDoktormu(String email) async {
    var _emails = await _firestore
        .collection("terapistler")
        .where("email", isEqualTo: email)
        .getDocuments();

    if (_emails.documents.length == 0) {
      return null;
    } else {
      return true;
    }
  }
}
