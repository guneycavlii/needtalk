class Hatalar { // Bütün hatalarımı içeren yapı

static String goster(String hatakodu){

switch(hatakodu){
  case 'ERROR_EMAIL_ALREADY_USE':
  return "Bu mail adresi zaten kullanımda, lütfen farklı bir mail adresi kullanınız.";

  case 'ERROR_USER_NOT_FOUND' :
  return "Kullanıcı bulunamadı, lütfen kullanıcı oluşturunuz.";

  default:
  return "Bir hata oluştu.";
}

}


}