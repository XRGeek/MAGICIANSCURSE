using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using System.Linq;
#if UNITY_EDITOR
using UnityEditor;
#endif

namespace Lovatto.SceneLoader
{
    public class bl_ButtonSceneLoad : MonoBehaviour, IPointerClickHandler
    {
        public bool byName = true;
        public string sceneName;
        public int sceneID = 0;
        public bool interactable = true;

        public void ResetInteractable()
        {
            interactable = true;
        }
        public void OnPointerClick(PointerEventData eventData)
        {
            if (interactable)
                LoadScene();
        }

        public void LoadScene()
        {
            /*
            if (bl_SceneLoaderManager.Instance.List[sceneID].SceneName == sceneName)           
                return;
            */
            if (byName)
            {
                if (string.IsNullOrEmpty(sceneName)) return;
                bl_SceneLoaderUtils.GetLoader.LoadLevel(sceneName);
                
                interactable = false;
            }
            else
            {
                sceneName = bl_SceneLoaderManager.Instance.List[sceneID].SceneName;
                bl_SceneLoaderUtils.GetLoader.LoadLevel(sceneName);
                interactable = false;
            }
        }
    }

#if UNITY_EDITOR
    [CustomEditor(typeof(bl_ButtonSceneLoad))]
    public class bl_ButtonSceneLoadEditor : Editor
    {
        bl_ButtonSceneLoad script;
        string[] sceneNames;

        private void OnEnable()
        {
            script = (bl_ButtonSceneLoad)target;
            sceneNames = bl_SceneLoaderManager.Instance.GetSceneNames();
        }

        public override void OnInspectorGUI()
        {
            EditorGUI.BeginChangeCheck();

            EditorGUILayout.BeginVertical("box");
            {
                script.byName = EditorGUILayout.ToggleLeft("By Name", script.byName, EditorStyles.toolbarButton);
                GUILayout.Space(2);
                if (script.byName)
                {
                    script.sceneName = EditorGUILayout.TextField("Scene Name", script.sceneName);
                }
                else
                    script.sceneID = EditorGUILayout.Popup("Scene", script.sceneID, sceneNames, EditorStyles.toolbarPopup);
            }
            GUILayout.Space(2);
            EditorGUILayout.EndVertical();

            if (EditorGUI.EndChangeCheck())
            {
                serializedObject.ApplyModifiedProperties();
                EditorUtility.SetDirty(target);
            }
        }
    }
#endif
}