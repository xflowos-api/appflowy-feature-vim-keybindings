import 'package:flutter_test/flutter_test.dart';
import 'package:appflowy_feature_vim_keybindings/appflowy_feature_vim_keybindings.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

void main() {
  test('Vim Plugin Mode Switch Test', () {
    final plugin = VimPlugin();
    expect(plugin.mode, VimMode.normal);

    const iKey = KeyDownEvent(
      logicalKey: LogicalKeyboardKey.keyI,
      physicalKey: PhysicalKeyboardKey.keyI,
      timeStamp: Duration.zero,
    );

    plugin.onKey(EditorState.blank(), iKey);
    expect(plugin.mode, VimMode.insert);

    const escKey = KeyDownEvent(
      logicalKey: LogicalKeyboardKey.escape,
      physicalKey: PhysicalKeyboardKey.escape,
      timeStamp: Duration.zero,
    );

    plugin.onKey(EditorState.blank(), escKey);
    expect(plugin.mode, VimMode.normal);
  });
}
