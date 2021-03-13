import 'package:flutter/material.dart';
import 'package:needtalk/model/randevu.dart';
import 'package:needtalk/viewmodel/usermodel.dart';
import 'package:provider/provider.dart';

import 'konusmat.dart';

class RandevularPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // User oankiUserNesnesi;
    UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Randevular"),
        ),
        body: Container(
          color: Colors.teal[300],
          child: FutureBuilder<List<Randevu>>(
          future: _userModel.getAllRandevus(_userModel.terapist.terapistID),
          builder: (context, sonuc) {
            if (sonuc.hasData) {
              var tumRandevular = sonuc.data;

              if (tumRandevular.length > 0) {
                return ListView.builder(
                  itemCount: tumRandevular.length,
                  itemBuilder: (context, index) {
                    var oankiRandevu = sonuc.data[index];
                    return GestureDetector(
                        child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Card(
                        elevation: 4,
                        child: Container(
                        decoration: BoxDecoration(color: Colors.teal[50],borderRadius: BorderRadius.all(Radius.circular(3))),
                        
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ListTile(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true).push(
                                  //rootNavigator - Alt bölümün yok olmasını sağlıyor.
                                  MaterialPageRoute(
                                    builder: (context) => KonusmaT(
                                      currentTerapist: _userModel.terapist,
                                      sohbetEdilenUsername:
                                          oankiRandevu.randevuyuAlanUsername,
                                      sohbetEdilenUserID:
                                          oankiRandevu.randevuyuAlanUserID,
                                      sohbetEdilenUserProfilURL: oankiRandevu
                                          .randevuyuAlanUserProfilURL,
                                    ),
                                  ),
                                );
                              },
                              title: Text(oankiRandevu.randevuyuAlanUsername),
                              subtitle: Text(oankiRandevu.randevuyuAlanUserID,style: TextStyle(fontSize: 12),),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    oankiRandevu.randevuyuAlanUserProfilURL),
                              ),
                              trailing: 
                                Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[

                                  Container(child: Text(oankiRandevu.randevuSaati,style: TextStyle(color: Colors.white),),padding: const EdgeInsets.all(2),decoration: BoxDecoration(color: Colors.teal,borderRadius: BorderRadius.all(Radius.circular(10))),),
                                  Container(child: Text(oankiRandevu.randevuTarihi,style: TextStyle(color: Colors.white),),padding: const EdgeInsets.all(2),decoration: BoxDecoration(color: Colors.teal,borderRadius: BorderRadius.all(Radius.circular(10))),)
                                ],
                              ),
                              
                               ),
                        ],
                      ),
                    ))));
                  },
                );
              } else {
                return Center(
                  child: Text("KAYITLI BİR RANDEVU YOK!"),
                );
              }
            } else {
              return Container();
            }
          },
        )
        // Center(
        //     child: Column(
        //   children: <Widget>[
        //     SizedBox(height: 10,),
        //    Container(
        //         decoration: BoxDecoration(
        //             boxShadow: [
        //               BoxShadow(
        //                   color: Colors.grey,
        //                   blurRadius: 4.0,
        //                   spreadRadius: 1.0,
        //                   offset: Offset(2.0, 2.0))
        //             ],
        //             shape: BoxShape.rectangle,
        //             color: Colors.red,
        //             borderRadius: BorderRadius.only(
        //                 topLeft: Radius.circular(25.0),
        //                 bottomRight: Radius.circular(25.0))),
        //         width: 400,
        //         height: 70,
        //         child: Center(
        //           child: ListTile(
        //       contentPadding: const EdgeInsets.all(8),
        //        title: Text("Gizem Yıldızhan",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
        //       subtitle: Text("Konu: Aile"),
        //     ),
        //         ),
        //       ),
        //        SizedBox(height: 10,),
        //      Container(
        //         decoration: BoxDecoration(
        //             boxShadow: [
        //               BoxShadow(
        //                   color: Colors.grey,
        //                   blurRadius: 4.0,
        //                   spreadRadius: 1.0,
        //                   offset: Offset(2.0, 2.0))
        //             ],
        //             shape: BoxShape.rectangle,
        //             color: Colors.red,
        //             borderRadius: BorderRadius.only(
        //                 topLeft: Radius.circular(25.0),
        //                 bottomRight: Radius.circular(25.0))),
        //         width: 400,
        //         height: 70,
        //         child: Center(
        //           child: ListTile(
        //       contentPadding: const EdgeInsets.all(8),
        //       title: Text("Tuğçe Aslan",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
        //       subtitle: Text("Konu: Aile"),
        //     ),
        //         ),
        //       ),
        //        SizedBox(height: 10,),
        //     Container(
        //         decoration: BoxDecoration(
        //             boxShadow: [
        //               BoxShadow(
        //                   color: Colors.grey,
        //                   blurRadius: 4.0,
        //                   spreadRadius: 1.0,
        //                   offset: Offset(2.0, 2.0))
        //             ],
        //             shape: BoxShape.rectangle,
        //             color: Colors.red,
        //             borderRadius: BorderRadius.only(
        //                 topLeft: Radius.circular(25.0),
        //                 bottomRight: Radius.circular(25.0))),
        //         width: 400,
        //         height: 70,
        //         child: Center(
        //           child: ListTile(
        //       contentPadding: const EdgeInsets.all(8),
        //       title: Text("Zehra Cavlı",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
        //       subtitle: Text("Konu: Aile"),
        //     ),
        //         ),
        //       ),
        //   ],
        // )),
        // Bu sayfada o anki doktordan hangi hastalar randevu almışsa sayfaya listelenicek.
        ));
  }
}
