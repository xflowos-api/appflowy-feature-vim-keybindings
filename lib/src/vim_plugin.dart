import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

enum VimMode { normal, insert, visual }

class VimPlugin {
  VimMode _mode = VimMode.normal;
  VimMode get mode => _mode;

  KeyEventResult onKey(EditorState editorState, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    if (event.logicalKey == LogicalKeyboardKey.escape) {
      _switchMode(editorState, VimMode.normal);
      return KeyEventResult.handled;
    }

    if (_mode == VimMode.normal) {
      return _handleNormalMode(editorState, event);
    }

    return KeyEventResult.ignored;
  }

  void _switchMode(EditorState editorState, VimMode newMode) {
    if (newMode == VimMode.insert && !editorState.editable) {
      // Security: Do not allow entering insert mode if the editor is read-only.
      return;
    }
    _mode = newMode;
  }

  KeyEventResult _handleNormalMode(EditorState editorState, KeyDownEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.keyI) {
      _switchMode(editorState, VimMode.insert);
      return KeyEventResult.handled;
    }

    // Add support for other common insert mode entry points for better coverage
    if (event.logicalKey == LogicalKeyboardKey.keyA ||
        event.logicalKey == LogicalKeyboardKey.keyO ||
        event.logicalKey == LogicalKeyboardKey.keyS) {
      _switchMode(editorState, VimMode.insert);
      return KeyEventResult.handled;
    }

    final selection = editorState.selection;
    if (selection == null) {
      return KeyEventResult.handled;
    }

    // Basic navigation: h, j, k, l
    if (event.logicalKey == LogicalKeyboardKey.keyH) {
      // Left: AppFlowy moveCursorForward is actually left in LTR
      editorState.moveCursorForward(SelectionMoveRange.character);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.keyJ) {
      // Down
      final downPosition = selection.end.moveVertical(editorState, upwards: false);
      if (downPosition != null) {
        editorState.updateSelectionWithReason(
          Selection.collapsed(downPosition),
          reason: SelectionUpdateReason.uiEvent,
        );
      }
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.keyK) {
      // Up
      final upPosition = selection.end.moveVertical(editorState, upwards: true);
      if (upPosition != null) {
        editorState.updateSelectionWithReason(
          Selection.collapsed(upPosition),
          reason: SelectionUpdateReason.uiEvent,
        );
      }
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.keyL) {
      // Right: AppFlowy moveCursorBackward is actually right in LTR
      editorState.moveCursorBackward(SelectionMoveRange.character);
      return KeyEventResult.handled;
    }

    return KeyEventResult.handled; // Swallow keys in normal mode if not handled
  }
}
