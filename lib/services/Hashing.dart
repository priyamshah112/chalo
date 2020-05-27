import 'package:steel_crypt/steel_crypt.dart';

class Hashing {
  static final hasher = HashCrypt('SHA-3/512'); 
  static String encrypt(String text){
    return hasher.hash(text);
  }
}
