using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.UIElements;

public class SampleEditorWindow : EditorWindow
{
    [SerializeField] private VisualTreeAsset _mainWindowVisualTree = default;
    [SerializeField] private StyleSheet _mainWindowStyleSheet = default;

    [MenuItem("Banter/Tools/UIKit/SampleEditorWindow")]
    public static void ShowMainWindow() {
        SampleEditorWindow window = GetWindow<SampleEditorWindow>();
        window.minSize = new Vector2(450, 200);
        window.titleContent = new GUIContent("UIKit Sample Editor Window");
    }

    public void OnEnable(){
        VisualElement content = _mainWindowVisualTree.CloneTree();
        content.style.height = new StyleLength(Length.Percent(100));
        rootVisualElement.styleSheets.Add(_mainWindowStyleSheet);
        rootVisualElement.Add(content);
    }
}
