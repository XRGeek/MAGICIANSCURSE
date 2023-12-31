﻿using UnityEditor;


namespace AmazingAssets.AdvancedDissolveEditor.ShaderGraph
{
    public class DefaultShaderGraphGUI : ShaderGUI
    {
        public override void OnGUI(UnityEditor.MaterialEditor materialEditor, MaterialProperty[] properties)
        {
            if (AmazingAssets.AdvancedDissolveEditor.MaterialEditor.DrawDefaultOptionsHeader("Exposed Properties", null, null))
                base.OnGUI(materialEditor, properties);


            //AmazingAssets
            AmazingAssets.AdvancedDissolveEditor.MaterialEditor.Init(properties);

            //AmazingAssets
            AmazingAssets.AdvancedDissolveEditor.MaterialEditor.DrawDissolveOptions(materialEditor, true, true, false, true, true);
        }
    }
}