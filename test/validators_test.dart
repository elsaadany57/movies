import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/core/utils/validators.dart';

void main() {
  test('email accepts real addresses and rejects malformed ones', () {
    expect(Validators.email('ahmed@example.com'), isNull);
    expect(Validators.email('  ahmed@example.co.uk  '), isNull);

    expect(Validators.email(''), isNotNull);
    expect(Validators.email(null), isNotNull);
    expect(Validators.email('ahmed'), isNotNull);
    expect(Validators.email('ahmed@'), isNotNull);
    expect(Validators.email('ahmed@example'), isNotNull);
  });

  test('password requires at least six characters', () {
    expect(Validators.password('secret'), isNull);
    expect(Validators.password('12345'), isNotNull);
    expect(Validators.password(null), isNotNull);
  });

  test('confirmPassword only passes on an exact match', () {
    expect(Validators.confirmPassword('secret', 'secret'), isNull);
    expect(Validators.confirmPassword('secret', 'Secret'), isNotNull);
    expect(Validators.confirmPassword('', 'secret'), isNotNull);
  });

  test('required names the field it is missing', () {
    expect(Validators.required('Ahmed', 'name'), isNull);
    expect(Validators.required('   ', 'name'), contains('name'));
  });

  test('phone rejects anything too short to dial', () {
    expect(Validators.phone('01001234567'), isNull);
    expect(Validators.phone('123'), isNotNull);
  });
}
