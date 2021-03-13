import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:needtalk/model/konusmalar.dart';
import 'package:needtalk/model/mesaj.dart';
import 'package:needtalk/model/randevu.dart';
import 'package:needtalk/model/terapist.dart';
import 'package:needtalk/model/user.dart';
import 'package:needtalk/services/database_base.dart';

class FireStoreDBService implements DBbase {
  final Firestore _firestore = Firestore.instance;

  @override
  Future<bool> saveUser(User user) async {
    Map _eklenecekUserMap = user.toMap();
    _eklenecekUserMap['createdAt'] = FieldValue.serverTimestamp();
    _eklenecekUserMap['updatedAt'] = FieldValue.serverTimestamp();

    await _firestore
        .collection("users")
        .document(user.userID)
        .setData(_eklenecekUserMap);
//usersa gel ve oku.
    DocumentSnapshot _okunanUser =
        await Firestore.instance.document("users/${user.userID}").get();

    Map _okunanUserBilgileriMapi = _okunanUser.data;
    User _okunanUserBilgileriNesne = User.fromMap(_okunanUserBilgileriMapi);
    print("Okunan user nesnesi: " + _okunanUserBilgileriNesne.toString());

    return true;
  }

  @override
  Future<User> readUser(String userID) async {
    DocumentSnapshot _okunanUser =
        await _firestore.collection("users").document(userID).get();
    Map<String, dynamic> _okunanUserBilgileriMap = _okunanUser.data;

    User _okunanUserNesnesi = User.fromMap(_okunanUserBilgileriMap);
    print("Okunan User Nesnesi: " + _okunanUserNesnesi.toString());
    return _okunanUserNesnesi;
  }

  Future<Terapist> readTerapist(String terapistID) async {
    DocumentSnapshot _okunanTerapist =
        await _firestore.collection("terapistler").document(terapistID).get();
    Map<String, dynamic> _okunanTerapistBilgileriMap = _okunanTerapist.data;
    
    Terapist _okunanTerapistNesnesi =
        Terapist.fromMap(_okunanTerapistBilgileriMap);
    print("Okunan Terapist Nesnesi: " + _okunanTerapistNesnesi.toString());
    return _okunanTerapistNesnesi;
  }

  @override
  Future<bool> updateUserName(String userID, String yeniUserName) async {
    var users = await _firestore
        .collection("users")
        .where("userName", isEqualTo: yeniUserName)
        .getDocuments();
    if (users.documents.length >= 1) {
      return false;
    } else {
      await _firestore
          .collection("users")
          .document(userID)
          .updateData({'userName': yeniUserName});
      return true;
    }
  }

  Future<bool> updateProfilFoto(String userID, String profilFotoURL) async {
    
    await _firestore
        .collection("users")
        .document(userID)
        .updateData({'profilURL': profilFotoURL});
    return true;
  }
  Future<bool> updateProfilFotoT(String userID, String profilFotoURL) async {
    
    await _firestore
        .collection("terapistler")
        .document(userID)
        .updateData({'profilURL': profilFotoURL});
    return true;
  }
  
  @override
  Future<List<Konusmalar>> getAllConversations(String userID) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection("konusmalar")
        .where("konusma_sahibi", isEqualTo: userID)
        .orderBy("olusturulma_tarihi", descending: true)
        .getDocuments();

//HER QUERYSNAPSHOT BİR DOKUMENTSNAPSHOT DÖNDÜRÜR.

    List<Konusmalar> tumKonusmalar = [];

    for (DocumentSnapshot tekKonusma in querySnapshot.documents) {
      Konusmalar _tekKonusma = Konusmalar.fromMap(tekKonusma.data);
      tumKonusmalar.add(_tekKonusma);
    }

    return tumKonusmalar;
  }
    @override
  Future<List<Konusmalar>> getAllConversationsT(String terapistID) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection("konusmalar")
        .where("konusma_sahibi", isEqualTo: terapistID)
        .orderBy("olusturulma_tarihi", descending: true)
        .getDocuments();

//HER QUERYSNAPSHOT BİR DOKUMENTSNAPSHOT DÖNDÜRÜR.

    List<Konusmalar> tumKonusmalar = [];

    for (DocumentSnapshot tekKonusma in querySnapshot.documents) {
      Konusmalar _tekKonusma = Konusmalar.fromMap(tekKonusma.data);
      tumKonusmalar.add(_tekKonusma);
    }

    return tumKonusmalar;
  }

  @override
  Future<List<User>> getAllUser() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection("users").getDocuments();

    List<User> tumKullanicilar = [];
    for (DocumentSnapshot tekUser
        in querySnapshot.documents) // Users'a git tek tek gez..
    {
      User _tekUser = User.fromMap(tekUser
          .data); // Veritabanında map oalarak saklanan bu değerli alıp bir User nesnesine dönüştürücek.
      tumKullanicilar.add(_tekUser);
    }

    //MAP METODU İLE
    //tumKullanicilar = querySnapshot.documents.map((tekSatir)=>User.fromMap(tekSatir.data)).toList();
    return tumKullanicilar;
  }

  Future<List<Terapist>> getAllTerapist() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection("terapistler").getDocuments();

    List<Terapist> tumTerapistler = [];

    // List<RandevuTarihleri> tumTarihler = [];
    // List<RandevuSaatleri> tumSaatler = [];

    for (DocumentSnapshot tekTerapist in querySnapshot.documents) {
      Terapist _tekTerapist = Terapist.fromMap(tekTerapist.data);
      tumTerapistler.add(_tekTerapist);

      // RandevuTarihleri _tekTarih = RandevuTarihleri.fromMap(_tekTerapist.available);
      // tumTarihler.add(_tekTarih);
      // print(_tekTarih.toString());
      // RandevuSaatleri _tekSaat = RandevuSaatleri.fromMap(_tekTarih.tarih1);
      // tumSaatler.add(_tekSaat);
      // print(_tekSaat.toString());
     
    }
    
    return tumTerapistler;
  }
Future<List<Randevu>> getAllRandevus(String terapistID) async {
    QuerySnapshot querySnapshot =
        await _firestore.collection("randevular").where("randevuyuAldigiTerapistID",isEqualTo: terapistID).getDocuments();

    List<Randevu> tumRandevular = [];

    // List<RandevuTarihleri> tumTarihler = [];
    // List<RandevuSaatleri> tumSaatler = [];

    for (DocumentSnapshot tekRandevu in querySnapshot.documents) {
      Randevu _tekRandevu = Randevu.fromMap(tekRandevu.data);
      tumRandevular.add(_tekRandevu);

      // RandevuTarihleri _tekTarih = RandevuTarihleri.fromMap(_tekTerapist.available);
      // tumTarihler.add(_tekTarih);
      // print(_tekTarih.toString());
      // RandevuSaatleri _tekSaat = RandevuSaatleri.fromMap(_tekTarih.tarih1);
      // tumSaatler.add(_tekSaat);
      // print(_tekSaat.toString());
     
    }
    
    return tumRandevular;
  }
// Tek bir mesaj dinlemek için;
// @override
//   Stream getMessage(String currentUserID, String konusulanUserID) {
//     var snapshot = _firestore
//         .collection("Konusmalar")
//         .document(currentUserID + " -- " + konusulanUserID)
//         .collection("mesajlar")
//         .document(currentUserID)
//         .snapshots();

//     return snapshot.map((snapshot)=>Mesaj.fromMap(snapshot.data));
//   }

  @override
  Stream<List<Mesaj>> getMessages(
      String currentUserID, String sohbetEdilenTerapistID) {
    var snapshot = _firestore
        .collection("konusmalar")
        .document(currentUserID + "--" + sohbetEdilenTerapistID)
        .collection("mesajlar")
        .orderBy("date", descending: true)
        .snapshots();

    return snapshot.map((mesajListesi) => mesajListesi.documents
        .map((mesaj) => Mesaj.fromMap(mesaj.data))
        .toList());
  }

   @override
  Stream<List<Mesaj>> getMessagesT(
      String currentTerapistID, String sohbetEdilenUserID) {
    var snapshot = _firestore
        .collection("konusmalar")
        .document(currentTerapistID + "--" + sohbetEdilenUserID)
        .collection("mesajlar")
        .orderBy("date", descending: true)
        .snapshots();

    return snapshot.map((mesajListesi) => mesajListesi.documents
        .map((mesaj) => Mesaj.fromMap(mesaj.data))
        .toList());
  }

  Future<bool> saveMessage(Mesaj kaydedilecekMesaj) async {
//Rastgele document ID Oluştursun ve mesaj ID Ye atasın.
    var _mesajID = _firestore.collection("konusmalar").document().documentID;
    var _myDocID = kaydedilecekMesaj.kimden + "--" + kaydedilecekMesaj.kime;
    var _yourDocID = kaydedilecekMesaj.kime + "--" + kaydedilecekMesaj.kimden;

    var _kaydedilecekMapYapisi = kaydedilecekMesaj.toMap();
    //ANLIK VERİ AKTARIMI
    await _firestore
        .collection("konusmalar")
        .document(_myDocID)
        .collection("mesajlar")
        .document(_mesajID)
        .setData(_kaydedilecekMapYapisi);

    await _firestore.collection("konusmalar").document(_myDocID).setData({
      "konusma_sahibi": kaydedilecekMesaj.kimden,
      "kimle_konusuyor": kaydedilecekMesaj.kime,
      "son_yollanan_mesaj": kaydedilecekMesaj.mesaj,
      "konusma_goruldu": false,
      "olusturulma_tarihi": FieldValue.serverTimestamp()
    });

    _kaydedilecekMapYapisi.update("bendenMi", (deger) => false);

    await _firestore
        .collection("konusmalar")
        .document(_yourDocID)
        .collection("mesajlar")
        .document(_mesajID)
        .setData(_kaydedilecekMapYapisi);

    await _firestore.collection("konusmalar").document(_yourDocID).setData({
      "konusma_sahibi": kaydedilecekMesaj.kime,
      "kimle_konusuyor": kaydedilecekMesaj.kimden,
      "son_yollanan_mesaj": kaydedilecekMesaj.mesaj,
      "konusma_goruldu": false,
      "olusturulma_tarihi": FieldValue.serverTimestamp()
    });

    return true;
  }
  Future<bool> saveMessageT(Mesaj kaydedilecekMesaj) async {
//Rastgele document ID Oluştursun ve mesaj ID Ye atasın.
    var _mesajID = _firestore.collection("konusmalar").document().documentID;
    var _myDocID = kaydedilecekMesaj.kimden + "--" + kaydedilecekMesaj.kime;
    var _yourDocID = kaydedilecekMesaj.kime + "--" + kaydedilecekMesaj.kimden;

    var _kaydedilecekMapYapisi = kaydedilecekMesaj.toMap();
    //ANLIK VERİ AKTARIMI
    await _firestore
        .collection("konusmalar")
        .document(_myDocID)
        .collection("mesajlar")
        .document(_mesajID)
        .setData(_kaydedilecekMapYapisi);

    await _firestore.collection("konusmalar").document(_myDocID).setData({
      "konusma_sahibi": kaydedilecekMesaj.kimden,
      "kimle_konusuyor": kaydedilecekMesaj.kime,
      "son_yollanan_mesaj": kaydedilecekMesaj.mesaj,
      "konusma_goruldu": false,
      "olusturulma_tarihi": FieldValue.serverTimestamp()
    });

    _kaydedilecekMapYapisi.update("bendenMi", (deger) => false);

    await _firestore
        .collection("konusmalar")
        .document(_yourDocID)
        .collection("mesajlar")
        .document(_mesajID)
        .setData(_kaydedilecekMapYapisi);

    await _firestore.collection("konusmalar").document(_yourDocID).setData({
      "konusma_sahibi": kaydedilecekMesaj.kime,
      "kimle_konusuyor": kaydedilecekMesaj.kimden,
      "son_yollanan_mesaj": kaydedilecekMesaj.mesaj,
      "konusma_goruldu": false,
      "olusturulma_tarihi": FieldValue.serverTimestamp()
    });

    return true;
  }
}
