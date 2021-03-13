import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User {
  final String userID;
  String email;
  String userName;
  String profilURL;
  DateTime createdAt;
  DateTime updateAt;
  int seviye;

  User({@required this.userID, @required this.email});

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'email': email,
      'userName': userName ?? email.substring(0,email.indexOf('@')) + randomSayiUret(),
            'profilURL': profilURL ?? "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
            'createdAt': createdAt ?? FieldValue.serverTimestamp(),
            'updateAt': updateAt ?? FieldValue.serverTimestamp(),
            'seviye': seviye ?? 1,
          };
        }
      
        User.fromMap(Map<String, dynamic> map)
            :
      // User nesnesinin içinde bulunan yapı -- Firebasedeki etiket.
              userID = map['userID'],
              email = map['email'],
              userName = map['userName'],
              profilURL = map['profilURL'],
              createdAt = (map['createdAt'] as Timestamp).toDate(),
              updateAt = (map['updateAt'] as Timestamp).toDate(),
              seviye = map['seviye'];
        @override
        String toString() {
          return 'User{userID: $userID,email: $email,userName: $userName,profilURL: $profilURL,createdAt: $createdAt,updateAt: $updateAt,seviye: $seviye}';
        }
      
        String randomSayiUret() {
int rastgeleSayi = Random().nextInt(999999);
return rastgeleSayi.toString();

        }
}
