class RandevuTarihleri {

  Map tarih1,tarih2,tarih3,tarih4,tarih5,tarih6,tarih7,tarih8,tarih9,tarih10,tarih11,tarih12,tarih13,tarih14;


  RandevuTarihleri.fromMap(Map<String, dynamic> map)
  :
        tarih1 = map['01-06-2020'],
        tarih2 = map['02-06-2020'],
        tarih3 = map['03-06-2020'],
        tarih4 = map['04-06-2020'],
        tarih5 = map['05-06-2020'],
        tarih6 = map['06-06-2020'],
        tarih7 = map['07-06-2020'],
        tarih8 = map['08-06-2020'],
        tarih9 = map['09-06-2020'],
        tarih10 = map['10-06-2020'],
        tarih11 = map['11-06-2020'],
        tarih12 = map['12-06-2020'],
        tarih13 = map['13-06-2020'],
        tarih14 = map['14-06-2020'];
      

  @override
  String toString() {
    return 'RandevuTarihleri';
  }
}
