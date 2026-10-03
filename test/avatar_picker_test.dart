import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/core/constants/app_assets.dart';
import 'package:movies_app/features/auth/widgets/avatar_picker.dart';

/// Size avatars are shrunk to before comparing. Small enough to ignore the
/// fact that the source files come in different resolutions.
const _probe = 32;

/// Mean difference per colour channel (0-255) below which two avatars count
/// as the same picture. Genuinely different ones measure 26 or more apart;
/// the duplicates that once shipped measured 1 to 4.
const _sameBelow = 12.0;

Future<Uint8List> _pixels(String asset) async {
  final codec = await ui.instantiateImageCodec(
    File(asset).readAsBytesSync(),
    targetWidth: _probe,
    targetHeight: _probe,
  );
  final image = (await codec.getNextFrame()).image;
  final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
  return data!.buffer.asUint8List();
}

double _difference(Uint8List a, Uint8List b) {
  var total = 0;
  for (var i = 0; i < a.length; i++) {
    total += (a[i] - b[i]).abs();
  }
  return total / a.length;
}

void main() {
  group('avatar list', () {
    test('lists every file once', () {
      expect(AppAssets.avatars.toSet().length, AppAssets.avatars.length);
    });

    test('points only at files that exist', () {
      for (final asset in AppAssets.avatars) {
        expect(File(asset).existsSync(), isTrue, reason: asset);
      }
    });

    test('has no stray avatar file the list does not know about', () {
      final onDisk = Directory('assets/images/avatars')
          .listSync()
          .map((entity) => entity.path)
          .toSet();
      expect(onDisk, AppAssets.avatars.toSet());
    });

    test('fills the three-column picker grid with no ragged last row', () {
      expect(AppAssets.avatars.length % 3, 0);
    });

    testWidgets('has no two avatars that are the same picture', (tester) async {
      await tester.runAsync(() async {
        final pictures = {
          for (final asset in AppAssets.avatars) asset: await _pixels(asset),
        };

        final assets = AppAssets.avatars;
        for (var i = 0; i < assets.length; i++) {
          for (var j = i + 1; j < assets.length; j++) {
            final difference = _difference(pictures[assets[i]]!, pictures[assets[j]]!);
            expect(
              difference,
              greaterThan(_sameBelow),
              reason: '${assets[i]} and ${assets[j]} look identical '
                  '(difference $difference)',
            );
          }
        }
      });
    });
  });

  group('default avatar', () {
    test('points at a real avatar', () {
      expect(AvatarPicker.defaultIndex, greaterThanOrEqualTo(0));
      expect(AvatarPicker.defaultIndex, lessThan(AppAssets.avatars.length));
    });

    test('is what the register screen seeds its own state from', () {
      // The carousel opens on this, and the screen saves it if the user never
      // swipes, so a drift between the two would store the wrong avatar.
      expect(AvatarPicker.defaultIndex, AppAssets.defaultAvatar);
    });
  });

  group('avatarAt', () {
    test('returns the avatar at that position', () {
      expect(AppAssets.avatarAt(0), AppAssets.avatars.first);
      expect(AppAssets.avatarAt(8), AppAssets.avatars[8]);
    });

    test('falls back to the nearest one for an index out of range', () {
      // Profiles saved before the picker shrank can hold a larger index.
      expect(AppAssets.avatarAt(11), AppAssets.avatars.last);
      expect(AppAssets.avatarAt(-1), AppAssets.avatars.first);
    });
  });
}
