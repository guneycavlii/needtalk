import 'package:cloud_firestore/cloud_firestore.dart';

class Mesaj {
//Bir kullanıcı diğerine mesaj attığında lazım olacak alanlar buraya girilecek.

  final String kimden;
  final String kime;
  final bool bendenMi;
  final String mesaj;
  final Timestamp date;

  Mesaj({this.kimden, this.kime, this.bendenMi, this.mesaj, this.date});

  Map<String, dynamic> toMap() {
    return {
      'kimden': kimden,
      'kime': kime,
      'bendenMi': bendenMi,
      'mesaj': mesaj,
      'date': date ?? FieldValue.serverTimestamp(), //Date verilmezse firebase o anki saati verilir.
    };
  }

  Mesaj.fromMap(Map<String, dynamic> map)
      : 
        // User nesnesinin içinde bulunan yapı -- Firebasedeki etiket.
        kimden = map['kimden'],
        kime = map['kime'],
        bendenMi = map['bendenMi'],
        mesaj = map['mesaj'],
        date = map['date'];

  //fromMap Firestoredan verileri çekerken verileri map ile aktarıyoruz ve nesne üreterek geriye yoluyoruz.

  @override
  String toString() {
    return 'Mesaj{kimden: $kimden,kime: $kime,bendenMi: $bendenMi,mesaj: $mesaj,date: $date,}';
  }
}
