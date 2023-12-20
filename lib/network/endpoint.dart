import 'package:cme/model/bnb_item.dart';
import 'package:cme/network/coach/request.dart';

String verifyEmailAndPhoneUrl = "${baseUrl}api/auth/verifyemailandphone";
String signUpUrl = "${baseUrl}api/auth/signup";
String logInUrl = "${baseUrl}api/auth/signin";

String mapApiKey = "AIzaSyA8yJNzxGxkpgdB67cJvgQxND0Re-TP-WQ";
String photoUrl = "";//baseUrl + "assets/"; //no longer needed.

String stripeSecretKey =
    "sk_test_51HWpuBIQUPfpoAtIOb3lUHpfRfVUoeToymBRzA600YwqbaG1fQLEEwQ5YsN4HJwv6WImjUIW6v8dJHMnHgwa0hXY00CYImnMeH";

String stripePublicKey =
    "pk_test_51HWpuBIQUPfpoAtIFJT8bOy0KOpztMTUUlqJIXGQKl9rshhKcqXBkHNuFxBEop38TeiJD6zsyonQv1uoY7zs6K1J00Fz1ZrzVo";

class SignInDetals {
  static Map accountMap = {};
  static String ageGroup = "18+";
  static List<String?> selectedSports = [];
  static List<String> selectedExperiences = [];
  static List<BNBItem> sportExperience = [];
}
