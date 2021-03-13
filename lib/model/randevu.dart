import 'package:cloud_firestore/cloud_firestore.dart';

class Randevu{

final String randevuyuAlanUserID;
final String randevuyuAldigiTerapistID;
final String randevuyuAlanUsername;
final String randevuyuAlanUserProfilURL;
Timestamp olusturulma_tarihi;
String randevuTarihi;
String randevuSaati;

  Randevu(this.randevuyuAlanUserID, this.randevuyuAldigiTerapistID,this.randevuyuAlanUsername,this.randevuyuAlanUserProfilURL);


  Map<String, dynamic> toMap() {
    return {
      'olusturulma_tarihi' : olusturulma_tarihi,
      'randevuyuAlanUserID': randevuyuAlanUserID,
      'randevuyuAldigiTerapistID': randevuyuAldigiTerapistID,
      'randevuTarihi': randevuTarihi,
      'randevuSaati': randevuSaati,
      'randevuyuAlanUsername' : randevuyuAlanUsername,
      'randevuyuAlanUserProfilURL' : randevuyuAlanUserProfilURL,
    };
  }

Randevu.fromMap(Map<String, dynamic> map)
            :
      // User nesnesinin içinde bulunan yapı -- Firebasedeki etiket.
              randevuyuAlanUserID = map['randevuyuAlanUserID'],
              randevuyuAldigiTerapistID = map['randevuyuAldigiTerapistID'],
              randevuyuAlanUsername = map['randevuyuAlanUsername'],
              randevuyuAlanUserProfilURL = map['randevuyuAlanUserProfilURL'],
              randevuTarihi = map['randevuTarihi'],
              randevuSaati = map['randevuSaati'];
            



}