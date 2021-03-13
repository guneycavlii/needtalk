class RandevuSaatleri {
  bool saat1;
  bool saat2;
  bool saat3;

  RandevuSaatleri.fromMap(Map<String, dynamic> map)
      : saat1 = map['13:00'],
        saat2 = map['15:00'],
        saat3 = map['17:00'];

  @override
  String toString() {
    return 'RandevuSaatleriUygunlukDurumları{13:00: $saat1,15:00: $saat2,17:00: $saat3}';
  }
}
