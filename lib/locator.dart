import 'package:get_it/get_it.dart';
import 'package:needtalk/repository/user_repository.dart';
import 'package:needtalk/services/fake_auth_service.dart';
import 'package:needtalk/services/firebase_auth_service.dart';
import 'package:needtalk/services/firebase_storage_service.dart';
import 'package:needtalk/services/firestore_db_service.dart';


GetIt locator = GetIt.instance;

void setupLocator(){ 
locator.registerSingleton<FireStoreDBService>(FireStoreDBService());
locator.registerSingleton<FirebaseAuthService>(FirebaseAuthService());
locator.registerSingleton<FakeAuthenticationService>(FakeAuthenticationService());
locator.registerSingleton<FirebaseStorageService>(FirebaseStorageService());
locator.registerSingleton<UserRepository>(UserRepository());

}