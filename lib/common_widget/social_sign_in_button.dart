import 'package:flutter/material.dart';

class SocialLogInButton extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final double radius;
  final double yukseklik;
  final Widget buttonIcon;
  final VoidCallback onPressed;

  const SocialLogInButton({
    Key key,
    @required this.buttonText, // Required mutlaka olması gerekiyor.
    this.buttonColor: Colors.blueGrey,
    this.textColor: Colors.white,
    this.radius: 16,
    this.yukseklik: 38,
    this.buttonIcon,
    this.onPressed,
  })  : assert(buttonText != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container( 
     
      margin: EdgeInsets.only(bottom: 8),
      child: SizedBox(
      height: yukseklik,
      child: RaisedButton(
        onPressed: onPressed,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
        color: buttonColor,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            buttonIcon != null ? buttonIcon : Container(),
            Text(
              buttonText,
              style: TextStyle(fontWeight: FontWeight.w700, color: textColor),
            ),
           
             buttonIcon !=null ? Opacity(opacity: 0,child: buttonIcon) : Container(),
          ],
        ))));
  }
}
