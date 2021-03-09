import 'package:auth/src/domain/credential.dart';
import 'package:auth/src/infra/api/auth_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  MockClient client;
  AuthApi sut; // system under test

  setUp(() {
    client = MockClient();
    sut = AuthApi('http:baseUrl', client);
  });

  group('signIn', () {
    var credential = Credential(
        type: AuthType.email, email: 'email@email.com', password: '12345678');
    test('should return error when status code is not 200', () async {
      // arrange
      when(client.post(any, body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('{}', 404));
      // act
      var result = await sut.signIn(credential);
      // assert
      expect(result, isA<ErrorResult>());
    });

    test('should return error when status code is  200 but malformed json',
        () async {
      // arrange
      when(client.post(any, body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('{}', 200));
      // act
      var result = await sut.signIn(credential);
      // assert
      expect(result, isA<ErrorResult>());
    });
  });
}
