import 'package:flutter_test/flutter_test.dart';
import 'package:appflowy_feature_vim_keybindings/appflowy_feature_vim_keybindings.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/services.dart';

void main() {
  test('Vim Plugin should not enter insert mode if editor is read-only', () {
    final plugin = VimPlugin();
    final editorState = EditorState.blank();
    editorState.editable = false;

    expect(plugin.mode, VimMode.normal);

    const iKey = KeyDownEvent(
      logicalKey: LogicalKeyboardKey.keyI,
      physicalKey: PhysicalKeyboardKey.keyI,
      timeStamp: Duration.zero,
    );

    plugin.onKey(editorState, iKey);

    // This is expected to FAIL before the fix
    expect(plugin.mode, VimMode.normal);
  });
}
