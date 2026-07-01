## 2025-05-13 - Guarding UI State Transitions in Editor Plugins
**Vulnerability:** Editor plugins (like Vim keybindings) can transition the UI into an "edit-ready" state (e.g., Insert Mode) even when the underlying editor is in read-only mode.
**Learning:** Checking `editorState.editable` only at the point of mutation is insufficient if the UI state itself implies editability. An inconsistent UI state can lead to user confusion or bypasses if other components rely on the UI state rather than the underlying `editable` flag.
**Prevention:** Centralize all state transitions in plugins and enforce a check against the editor's read-only status before allowing any transition to an "editing" state.
