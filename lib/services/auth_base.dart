import 'package:needtalk/model/terapist.dart';
import 'package:needtalk/model/user.dart';

abstract class AuthBase{

// Future<Terapist> currentTerapist();
Future<User> currentUser();
Future<User> signInAnonymously();
Future<bool> signOut();
Future<User> signInWithGoogle();
Future<User> signInWithEmailAndPassword(String email, String sifre);
Future<Terapist> signInWithEmailAndPasswordforTerapist(String email, String sifre);
Future<User> createUserWithEmailAndPassword(String email, String sifre);


}