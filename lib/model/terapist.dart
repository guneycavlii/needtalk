
class Terapist{

final String terapistID;
final  String email;
  String terapistName;
  String terapistSurname;
  String mezunOlduguOkul;
  String profilURL;
  String uzmanlikAlani;
  Map available;

 
 
  Terapist({this.email, this.terapistID});

 Terapist.fromMap(Map<String, dynamic> map)
            :
      // User nesnesinin içinde bulunan yapı -- Firebasedeki etiket.
              terapistID = map['terapistID'],
              email = map['email'],
              terapistName = map['terapistName'],
              terapistSurname = map['terapistSurname'],
              mezunOlduguOkul = map['mezunOlduguOkul'],
              profilURL = map['profilURL'],
              available = map['available'],
              uzmanlikAlani = map['uzmanlikAlani'];
              
              
        @override
        String toString() {
          return 'Terapist{terapistID: $terapistID,email: $email,terapistName: $terapistName,terapistSurname: $terapistSurname,mezunOlduguOkul: $mezunOlduguOkul,profilURL: $profilURL,available: $available,uzmanlikAlani: $uzmanlikAlani}';
        }



}