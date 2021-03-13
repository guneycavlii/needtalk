import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:needtalk/model/mesaj.dart';
import 'package:needtalk/model/terapist.dart';
import 'package:needtalk/model/user.dart';
import 'package:needtalk/viewmodel/usermodel.dart';
import 'package:provider/provider.dart';

class Konusma extends StatefulWidget {

  final User currentUser;
  final String sohbetEdilenTerapistname;
  final String sohbetEdilenTerapistID;
  final String sohbetEdilenTerapistProfilURL;

  AnimationController controller;

  Konusma({this.currentUser, this.sohbetEdilenTerapistID,this.sohbetEdilenTerapistProfilURL,this.sohbetEdilenTerapistname,this.controller});


  @override
  _KonusmaState createState() => _KonusmaState();
}

class _KonusmaState extends State<Konusma> with TickerProviderStateMixin {
//Alanı kontrol etmek amacıyla controller oluşturuyoruz.
  var _mesajController = TextEditingController();
  ScrollController _scrollController = new ScrollController();

  String get timerString {
    Duration duration = widget.controller.duration * widget.controller.value;
   try{
   if(duration.inMinutes == 0 && duration.inSeconds == 0 && duration.inMilliseconds == 0){
 
 widget.controller.stop();
 
  Navigator.pop(context); 
  
    
         }}catch(e){
           print(e.toString());
         }
   
  //    PlatformDuyarliAlertDialog(baslik: "Hey", icerik: "Hey", anaButonYazisi: "Hey").goster(context).then((a){
  // Navigator.pop(context);
  //    });
  //    Navigator.pop(context);
  //  });

    return '${duration.inMinutes} : ${(duration.inSeconds % 60).toString().padLeft(2, '0')} ';
  }


  @override
  void initState() {
    super.initState();
    widget.controller =
        AnimationController(vsync: this, duration: Duration(minutes: 30));
  }

  @override
  Widget build(BuildContext context) {

    User _currentUser = widget.currentUser;
  AnimationController _animationController = widget.controller;
    String _sohbetEdilenTerapistID = widget.sohbetEdilenTerapistID;

_animationController.reverse(from: _animationController.value == 0.0 ? 1.0 : _animationController.value);

    final _userModel = Provider.of<UserModel>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Sohbet Sayfası"),
      ),
      body: Container(
        color: Colors.teal[50],
        child: Center(
          child: Column(
        children: <Widget>[
          // Text("Current User" + widget.currentUser.userName),
          // Text("Sohbet Edilen User :" + widget.sohbetEdilenUser.userName)
          //Expanded Olabildiğince bütün alanı kaplaması.
           Padding(
        padding: const EdgeInsets.all(7.0),
        child: Column(
          children: <Widget>[
            Container(
              child: Align(
        
                alignment: FractionalOffset.center,
                child: Container(
                  
                  child: Stack(
                    children: <Widget>[
              
                      Positioned.fill(
                 
                        
                        child: AnimatedBuilder(
                            animation: _animationController,
                            builder: (BuildContext context, Widget child) {
                              return new CustomPaint(
                                  painter: TimerPainter(
                                      animation: _animationController,
                                      backgroundColor: Colors.white,
                                      color: Colors.teal));
                            }),
                       ),
                      Align(
                        alignment: FractionalOffset.center,
                        child: Column(

                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            // Text("Count Down"),
                            SizedBox(height: 8,),
                            AnimatedBuilder(
                              animation: _animationController,
                              builder: (BuildContext context, Widget child) {
                                return new Text(timerString,style: TextStyle(fontSize: 12),);
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
//             Container(margin: EdgeInsets.all(8.0),
//             child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: <Widget>[
//               FloatingActionButton(child: AnimatedBuilder(animation: controller,builder: (BuildContext context, Widget child){
//                 return new Icon(controller.isAnimating ? Icons.pause : Icons.play_arrow);
//               },),onPressed: (){

// if(controller.isAnimating){
//   controller.stop();
  
// }else{
//   controller.reverse(from: controller.value == 0.0 ? 1.0 : controller.value);
// }

//               },)
//             ],),)
          ],
        ),
      ),
          Expanded(
              //builder -- streame göre göstereceğimiz widgetları yapıcaz.
              child: StreamBuilder<List<Mesaj>>(
            stream: _userModel.getMessages(
                _currentUser.userID, _sohbetEdilenTerapistID),
            builder: (context, streamMesajlarListesi) {
              if (!streamMesajlarListesi.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                List<Mesaj> tumMesajlar = streamMesajlarListesi.data;
                return ListView.builder(
                    controller: _scrollController,
                    reverse: true, //tersten
                    itemBuilder: (context, index) {
                      return _konusmaBalonuOlustur(tumMesajlar[index]);
                    },
                    itemCount: tumMesajlar.length);
              }
            },
          )),
          Container(
              padding: EdgeInsets.only(bottom: 8, left: 8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _mesajController,
                      cursorColor: Colors.blueGrey,
                      style: new TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Mesajınızı yazınız.",
                        border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                            borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    child: FloatingActionButton(
                      elevation: 0,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.navigation,
                        size: 35,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        //Boş mesaj kontrolü
                        if (_mesajController.text.trim().length > 0) {
                          Mesaj _kaydedilecekMesaj = Mesaj(
                              kimden: _currentUser.userID,
                              kime: _sohbetEdilenTerapistID,
                              bendenMi: true,
                              mesaj: _mesajController.text);

                          var sonuc =
                              await _userModel.saveMessage(_kaydedilecekMesaj);
                          if (sonuc) {
                            _mesajController.clear();
                            _scrollController.animateTo(0.0,
                                duration: const Duration(milliseconds: 50),
                                curve: Curves.easeOut);
                          }
                        }
                      },
                    ),
                  ),
                ],
              ))
        ],
      ))),
    );
  }

  Widget _konusmaBalonuOlustur(Mesaj oankiMesaj) {

    Color gelenMesajRenk = Colors.blue;
    Color gidenMesajRenk = Theme.of(context).primaryColor;

    var saatDakikaDegeri = "";
    try{
      saatDakikaDegeri = _saatDakikaGoster(oankiMesaj.date ?? Timestamp(1,1));
    }catch(e){
      print("Hata var: " + e.toString());
    }

    var _benimMesajimMi = oankiMesaj.bendenMi;
    if (_benimMesajimMi) {
      return Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: gidenMesajRenk),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(4),
                    child: Text(
                      oankiMesaj.mesaj,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Text(saatDakikaDegeri)
              ],
            )
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage:
                      NetworkImage(widget.sohbetEdilenTerapistProfilURL),
                ),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: gelenMesajRenk),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(4),
                    child: Text(oankiMesaj.mesaj),
                  ),
                ),
                Text(saatDakikaDegeri)
              ],
            )
          ],
        ),
      );
    }
  }

  String _saatDakikaGoster(Timestamp date) {
    var _formatter = DateFormat.Hm();
    var _formatlanmisTarih = _formatter.format(date.toDate());
    return _formatlanmisTarih;
  }
}
class TimerPainter extends CustomPainter {
  TimerPainter({this.animation, this.backgroundColor, this.color})
      : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

  // canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    canvas.drawLine(Offset.zero, Offset(0,size.width), paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2;
    canvas.drawLine(Offset.zero, Offset(progress * 200,0), paint);
    // canvas.drawArc(Offset.zero & size, 2, 2, false, paint);
      
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}