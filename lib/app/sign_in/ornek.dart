//görsel düzeni görebilmeniz için debugPaintSizeEnabled öğesi true olarak ayarlanmış olarak görüntülenir
import 'package:flutter/material.dart';


class OrnekPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "INFO",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Container(
        child: Text("Bu bir bilgilendirme sayfasıdır."),
      ),


    );
  }
}
