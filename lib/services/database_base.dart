
import 'package:needtalk/model/konusmalar.dart';
import 'package:needtalk/model/mesaj.dart';
import 'package:needtalk/model/user.dart';

abstract class DBbase {
// Yarın öbür gün firebase yerine baska bir şey kullanırsak buradan türeteceğimiz için kodlarımızda eksiklik  oluyor, burası önemli.
  Future<bool> saveUser(User user);
  Future<User> readUser(String userID);
  Future<bool> updateUserName(String userID, String yeniUserName);
  Future<bool> updateProfilFoto(String userID, String profilFotoURL);
  Future<List<User>> getAllUser();
  Future<List<Konusmalar>> getAllConversations(String userID);
  Future<List<Konusmalar>> getAllConversationsT(String terapistID);
  Stream<List<Mesaj>> getMessages(
  String currentUserID, String sohbetEdilenTerapistID);
  Stream<List<Mesaj>> getMessagesT(
  String currentTerapistID, String sohbetEdilenUserID);  
  Future<bool> saveMessage(Mesaj kaydedilecekMesaj);
}
