import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/core/constants/app_assets.dart';
import 'package:movies_app/features/auth/widgets/avatar_picker.dart';

void main() {
  test('defaultIndex points at a real avatar, centred in the carousel', () {
    expect(AvatarPicker.defaultIndex, greaterThanOrEqualTo(0));
    expect(AvatarPicker.defaultIndex, lessThan(AppAssets.avatars.length));
    // The register screen seeds its own state from this, so a drift between
    // the centred avatar and the saved index would be silent.
    expect(AvatarPicker.defaultIndex, AppAssets.avatars.length ~/ 2);
  });
}
