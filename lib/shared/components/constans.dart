import 'package:shop_app/modules/shop_login_screen/shop_login_screen.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'components.dart';


void printFullText(String text)
{
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}
String token='';
