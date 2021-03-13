import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:needtalk/app/sign_in/hata_exception.dart';
import 'package:needtalk/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:needtalk/common_widget/social_sign_in_button.dart';
import 'package:needtalk/model/randevusaatleri.dart';
import 'package:needtalk/model/terapist.dart';
import 'package:needtalk/model/user.dart';

class RandevuAlmaSayfasi extends StatefulWidget {
  final User currentUser;
  final Terapist sohbetEdilenTerapist;

  RandevuAlmaSayfasi({this.currentUser, this.sohbetEdilenTerapist});

  @override
  _RandevuAlmaSayfasiState createState() => _RandevuAlmaSayfasiState();
}

class _RandevuAlmaSayfasiState extends State<RandevuAlmaSayfasi> {
  final Firestore _firestore = Firestore.instance;

  List<Color> renklerdeneme = [];
  int yesilinindexi;
  String secilensaat;
  DateTime _currentDate = DateTime(2020, 6, 1);
  Widget saatwidget = Container(
    child: Text("Saat seçebilmek için önce tarih seçin.",style: TextStyle(fontWeight: FontWeight.bold),),
  );

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime _selDate = await showDatePicker(
        context: context,
        initialDate: _currentDate,
        firstDate: DateTime(2020, 6, 1),
        lastDate: DateTime(2020, 6, 14),
        builder: (context, child) {
          return SingleChildScrollView(child: child);
        });

    if (_selDate != null) {
      setState(() {
        _currentDate = _selDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String _dateformat = DateFormat('dd.MM.yyyy').format(_currentDate);

    User _currentUser = widget.currentUser;
    Terapist _sohbetEdilenTerapist = widget.sohbetEdilenTerapist;

    return Scaffold(
        appBar: AppBar
        (
          centerTitle: true,
          title: Text("Randevu Al")),
        body: Container(
          color: Colors.teal[300],
          child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Card(
                 shape: StadiumBorder( side: BorderSide(color: Colors.white,width: 3)),
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        NetworkImage(_sohbetEdilenTerapist.profilURL)),),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Doktor Bilgileri",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 6,
                  margin: const EdgeInsets.all(8),
                  color: Colors.teal[50],
                  child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    enabled: false,
                  
                    initialValue: _sohbetEdilenTerapist.terapistName +
                        " " +
                        _sohbetEdilenTerapist.terapistSurname,
                    readOnly:
                        true, // Kullanıcı tarafından değiştirilmesi engellendi.
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.teal),
                      labelText: "Prof. Doktor",
                      hintText: "Doktor",
                    ),
                  ),
                ),),
                Card(
                  elevation: 6,
                  margin: const EdgeInsets.all(8),
                  color: Colors.teal[50],
                  child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    enabled: false,
                  
                    initialValue: _sohbetEdilenTerapist.mezunOlduguOkul,
                    readOnly:
                        true, // Kullanıcı tarafından değiştirilmesi engellendi.
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.teal),
                      labelText: "Mezun Olduğu Üniversite",
                      hintText: "Üniversite",
                    ),
                  ),
                ),),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 4.0,
                                    spreadRadius: 1.0,
                                    offset: Offset(2.0, 2.0))
                              ],
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16)),
                          width: 130,
                          height: 100,
                          child: Center(
                              child: Column(
                            children: <Widget>[
                              SizedBox(height: 10),
                              Text(
                                "Randevu Tarihi Seç",
                                style: TextStyle(color: Colors.teal),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.calendar_today,
                                  color: Colors.teal,
                                  size: 32,
                                ),
                                onPressed: () async {
                                  renklerdeneme.clear();
                                  await _selectDate(context);
                                  String _dateformatt = DateFormat('dd.MM.yyyy')
                                      .format(_currentDate);
                                  List<bool> _saatlerim =
                                      await showAvailableTimes(
                                          _dateformatt.toString(),
                                          _sohbetEdilenTerapist.terapistID);

                                  saatlerigoster(_saatlerim);
                                },
                              ),
                              Text(_dateformat.toString(),
                                  style: TextStyle(
                                      color: Colors.teal, fontSize: 15)),
                            ],
                          )),
                        ),
                      ),
                    ),
                    // Padding(
                    //     padding: const EdgeInsets.all(12),
                    //     child: Container(
                    //       width: 180,
                    //       height: 160,
                    //       child: Column(
                    //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //         // children: <Widget>[
                    //         //   TextFormField(
                    //         //     initialValue: "",
                    //         //     readOnly: false,
                    //         //     decoration: InputDecoration(
                    //         //       labelText: "Konu",
                    //         //       hintText: "Aile,arkadaşlık,aşk vs.",
                    //         //     ),
                    //         //   ),
                    //         //   TextFormField(
                    //         //     initialValue: "",
                    //         //     readOnly: false,
                    //         //     decoration: InputDecoration(
                    //         //       labelText: "Yaş",
                    //         //       hintText: "",
                    //         //     ),
                    //         //   )
                    //         // ],
                    //       ),
                    //     )),
                  ],
                ),
                saatwidget,
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: SocialLogInButton(
                    buttonText: "Randevu oluştur",
                    buttonColor: Colors.teal[600],
                    onPressed: () async {
                      if (secilensaat == null) {
                        PlatformDuyarliAlertDialog(
                                baslik: "HATA",
                                icerik:
                                    "Randevu oluşturabilmek için önce saat seçiniz.",
                                anaButonYazisi: "Tamam")
                            .goster(context);
                      } else {
                        updateDoktorDB(_sohbetEdilenTerapist.terapistID,
                            _dateformat, secilensaat);
                        try {
                          if (await randevuOlustur(
                                  _currentUser,
                                  _sohbetEdilenTerapist.terapistID,
                                  _dateformat,
                                  secilensaat) !=
                              null) {
                            PlatformDuyarliAlertDialog(
                                    baslik: "Randevu Bilgisi",
                                    icerik: "Randevunuz Oluşturuldu",
                                    anaButonYazisi: "Tamam")
                                .goster(context)
                                .then((a) {

                                  Navigator.pop(context);
                                });
                          }
                        } catch (e) {
                          PlatformDuyarliAlertDialog(
                                  baslik: "Randevu Bilgisi",
                                  icerik: "Randevu Oluşturulamadı.",
                                  anaButonYazisi: "Tamam")
                              .goster(context);
                          return null;
                        }
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        )));
  }

  Future<List<bool>> showAvailableTimes(String tarih, String terapistID) async {
    List<bool> tumSaatler = [];
    String a = tarih.replaceAll(".", "-");
    await _firestore
        .collection("terapistler")
        .document(terapistID)
        .get()
        .then((datasnapshot) {
      RandevuSaatleri randevuSaatleri =
          RandevuSaatleri.fromMap(datasnapshot.data["available"]['$a']);
      tumSaatler.add(randevuSaatleri.saat1);
      tumSaatler.add(randevuSaatleri.saat2);
      tumSaatler.add(randevuSaatleri.saat3);
      print(tumSaatler.toString());
    });
    return tumSaatler;
  }

  Widget saatlerigoster(List<bool> saatler) {
    Widget b = Container(
        height: 45,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: saatler.length,
              itemBuilder: (context, index) {
                List olagansaatler = ["13:00", "15:00", "17:00"];

                if (renklerdeneme.length < 3) {
                  if (saatler[index] == true) {
                    renklerdeneme.add(Colors.red);
                  } else {
                    renklerdeneme.add(Colors.grey);
                  }
                }
                print(renklerdeneme);

                return Container(
                  width: 60,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (renklerdeneme[index] == Colors.grey) {
                          print("Bu saat seçilemez.");
                          print("Seçilen saat değişmedi." +
                              secilensaat.toString());
                          if (secilensaat == null) {
                            PlatformDuyarliAlertDialog(
                                    baslik: "HATA",
                                    icerik: "Lütfen geçerli bir saat seçin.",
                                    anaButonYazisi: "Tamam")
                                .goster(context);
                          }
                        } else {
                          if (renklerdeneme.contains(Colors.green)) {
                            renklerdeneme[yesilinindexi] = Colors.red;
                            renklerdeneme[index] = Colors.green;
                            yesilinindexi = renklerdeneme.indexOf(Colors.green);
                            secilensaat = olagansaatler[index];
                            print("Seçilen saat: " + secilensaat);
                          } else {
                            renklerdeneme[index] = Colors.green;
                            yesilinindexi = renklerdeneme.indexOf(Colors.green);
                            secilensaat = olagansaatler[index];
                            print("Seçilen saat: " + secilensaat);
                            print("Yeşilin index'i : $yesilinindexi");
                          }
                        }

                        // if (renklerdeneme.contains(Colors.green)) {
                        //   renklerdeneme.remove(Colors.green);
                        //   renklerdeneme.add(Colors.red);
                        //   renklerdeneme[index] = Colors.green;
                        // } else {
                        //   renkler[index] = Colors.green;
                        // }
                        //  renkler[index]=Colors.green;

                        // secilensaat = olagansaatler[index];
                        // print("Seçilen saat: $secilensaat ");

                        //Rengi yeşil olanın saati kaç onu al.

                        // String secilensaat = olagansaatler[index];
                        // print("Saat seçildi: $secilensaat");
                        return saatlerigoster(saatler);
                      });
                    },
                    child: Card(
                      child: Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 4.0,
                                  spreadRadius: 1.0,
                                  offset: Offset(2.0, 2.0))
                            ],
                            shape: BoxShape.rectangle,
                            color: renklerdeneme[index],
                            borderRadius: BorderRadius.circular(4)),
                        child: Center(
                          child: Text(
                            olagansaatler[index],
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ));

    // Widget b = new Container(
    //   height: 100,
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.end,
    //     children: <Widget>[
    //       ListView.builder(
    //         scrollDirection: Axis.horizontal,
    //         shrinkWrap: true,
    //         itemCount: saatler.length,
    //         itemBuilder: (context, index) {
    //           List olagansaatler = ["13:00", "15:00", "17:00"];
    //           bool _saatler = saatler[index];

    //           return Padding(
    //             padding: const EdgeInsets.all(8),
    //             child: ListView(
    //               children: <Widget>[
    //                 Padding(
    //                   padding: const EdgeInsets.all(12),
    //                   child: Center(
    //                     child: Container(
    //                       decoration: BoxDecoration(
    //                           boxShadow: [
    //                             BoxShadow(
    //                                 color: Colors.grey,
    //                                 blurRadius: 4.0,
    //                                 spreadRadius: 1.0,
    //                                 offset: Offset(2.0, 2.0))
    //                           ],
    //                           shape: BoxShape.rectangle,
    //                           color:
    //                               _saatler == false ? Colors.grey : Colors.red,
    //                           borderRadius: BorderRadius.circular(16)),
    //                       width: 50,
    //                       height: 35,
    //                       child: Center(
    //                           child: Column(
    //                         mainAxisAlignment: MainAxisAlignment.center,
    //                         children: <Widget>[
    //                           Expanded(
    //                             child: Text(
    //                               olagansaatler[index],
    //                               style: TextStyle(color: Colors.white),
    //                             ),
    //                           ),
    //                         ],
    //                       )),
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           );
    //         },
    //       ),
    //     ],
    //   ),
    // );

    // Widget b = ListView.builder(
    //     physics: ClampingScrollPhysics(),
    //     scrollDirection: Axis.horizontal,
    //     shrinkWrap: true,
    //     itemCount: saatler.length,
    //     itemBuilder: (context, index) {
    //       List olagansaatler = ["13:00", "15:00", "17:00"];
    //       bool _saatler = saatler[index];

    //       return GestureDetector(
    //         child: Padding(
    //           padding: const EdgeInsets.all(8),
    //           child: ListView(

    //             children: <Widget>[
    //               Padding(
    //                 padding: const EdgeInsets.all(12),
    //                 child: Center(
    //                   child: Container(
    //                     decoration: BoxDecoration(
    //                         boxShadow: [
    //                           BoxShadow(
    //                               color: Colors.grey,
    //                               blurRadius: 4.0,
    //                               spreadRadius: 1.0,
    //                               offset: Offset(2.0, 2.0))
    //                         ],
    //                         shape: BoxShape.rectangle,
    //                         color: _saatler == false ? Colors.grey : Colors.red,
    //                         borderRadius: BorderRadius.circular(16)),
    //                     width: 50,
    //                     height: 35,
    //                     child: Center(
    //                         child: Column(
    //                       mainAxisAlignment: MainAxisAlignment.center,
    //                       children: <Widget>[
    //                         Text(
    //                           olagansaatler[index],
    //                           style: TextStyle(color: Colors.white),
    //                         ),
    //                       ],
    //                     )),
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       );
    //     });

    if (b != null) {
      setState(() {
        saatwidget = b;
      });
    }
    return b;
  }

  Future<bool> randevuOlustur(User currentUser, String terapistID,
      String dateformat, String secilensaat) async {
    var _myDocID = terapistID + "--" + currentUser.userID;

    await _firestore.collection("randevular").document(_myDocID).setData({
      "randevuyuAlanUserProfilURL": currentUser.profilURL,
      "randevuyuAlanUsername": currentUser.userName,
      "randevuyuAlanUserID": currentUser.userID,
      "randevuyuAldigiTerapistID": terapistID,
      "randevuTarihi": dateformat,
      "randevuSaati": secilensaat,
      "olusturulma_tarihi": FieldValue.serverTimestamp()
    },merge: true);

    return true;
  }

  Future<bool> updateDoktorDB(
      String terapistID, String secilentarih, String secilensaat) async {
    String uyumlutarih = secilentarih.replaceAll(".", "-");
    await _firestore
        .collection("terapistler")
        .document(terapistID)
        .updateData({"available.$uyumlutarih.$secilensaat": false});
    return true;
  }
}
// Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Center(
//               child: Container(
//                 decoration: BoxDecoration(
//                     boxShadow: [
//                       BoxShadow(
//                           color: Colors.grey,
//                           blurRadius: 4.0,
//                           spreadRadius: 1.0,
//                           offset: Offset(2.0, 2.0))
//                     ],
//                     shape: BoxShape.rectangle,
//                     color: randevuSaatleri.saat1 == true ? Colors.red : Colors.grey,
//                     borderRadius: BorderRadius.circular(16)),
//                 width: 50,
//                 height: 35,
//                 child: Center(
//                     child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Text(
//                       "13:00",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ],
//                 )),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Center(
//               child: Container(
//                 decoration: BoxDecoration(
//                     boxShadow: [
//                       BoxShadow(
//                           color: Colors.grey,
//                           blurRadius: 4.0,
//                           spreadRadius: 1.0,
//                           offset: Offset(2.0, 2.0))
//                     ],
//                     shape: BoxShape.rectangle,
//                      color: randevuSaatleri.saat2 == true ? Colors.red : Colors.grey,
//                     borderRadius: BorderRadius.circular(16)),
//                 width: 50,
//                 height: 35,
//                 child: Center(
//                     child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Text(
//                       "15:00",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ],
//                 )),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Center(
//               child: Container(
//                 decoration: BoxDecoration(
//                     boxShadow: [
//                       BoxShadow(
//                           color: Colors.grey,
//                           blurRadius: 4.0,
//                           spreadRadius: 1.0,
//                           offset: Offset(2.0, 2.0))
//                     ],
//                     shape: BoxShape.rectangle,
//                      color: randevuSaatleri.saat3 == true ? Colors.red : Colors.grey,
//                     borderRadius: BorderRadius.circular(16)),
//                 width: 50,
//                 height: 35,
//                 child: Center(
//                     child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Text(
//                       "17:00",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ],
//                 )),
//               ),
//             ),
//           ),
//         ],
//       );
