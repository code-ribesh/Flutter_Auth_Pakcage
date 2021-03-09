import './token.dart';
import 'package:async/async.dart';

abstract class IAuthService {
  Future<Result<Token>> signIn();
  Future<void> signOut();
}
