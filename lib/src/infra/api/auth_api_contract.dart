import 'package:async/async.dart';
import '../../domain/credential.dart';
import '../../domain/token.dart';

abstract class IAuthApi {
  Future<Result<Token>> signIn(Credential credential);
  Future<Result<Token>> signUp(Credential credential);
}
