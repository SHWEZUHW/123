// VacuumShaders 2019


Shader "Hidden/VacuumShaders/Curved World/Legacy Shader/Additive/Decal" 
{
	Properties 
	{
		[CurvedWorldGearMenu] V_CW_Label_Tag("", float) = 0
		[CurvedWorldLabel] V_CW_Label_UnityDefaults("Default Visual Options", float) = 0


		//Modes
		[CurvedWorldLargeLabel] V_CW_Label_Modes("Modes", float) = 0	
		[CurvedWorldRenderingMode] V_CW_Rendering_Mode("  Rendering", float) = 0	
		[CurvedWorldTextureMixMode] V_CW_Texture_Mix_Mode("  Texture Mix", float) = 0	

		//Albedo
		[CurvedWorldLargeLabel] V_CW_Label_Albedo("Albedo", float) = 0	
		_Color("  Color", color) = (1, 1, 1, 1)
		_MainTex ("  Map (RGB) RefStr, Gloss & Trans (A)", 2D) = "white" {}
		[CurvedWorldUVScroll] _V_CW_MainTex_Scroll("    ", vector) = (0, 0, 0, 0)
		_V_CW_SecondaryTex ("  Decal (RGB) Blend (A)", 2D) = "black" {}
		[CurvedWorldUVScroll] _V_CW_SecondaryTex_Scroll("    ", vector) = (0, 0, 0, 0)


		//Curved World
		[CurvedWorldLabel] V_CW_Label_UnityDefaults("Unity Advanced Rendering Options", float) = 0

		[HideInInspector] _V_CW_IncludeVertexColor("", float) = 0

		[HideInInspector] _V_CW_Rim_Color("", color) = (1, 1, 1, 1)
		[HideInInspector] _V_CW_Rim_Bias("", Range(-1, 1)) = 0.2
		[HideInInspector] _V_CW_Rim_Power("", Range(0.5, 8.0)) = 3

		[HideInInspector] _EmissionMap("", 2D) = "white"{}
		[HideInInspector] [HDR] _EmissionColor("", color) = (1, 1, 1, 1)


		[HideInInspector] _SpecColor ("", Color) = (0.5,0.5,0.5,1)
	    [HideInInspector] _Shininess ("", Range (0.01, 1)) = 0.078125

		[HideInInspector] _V_CW_ReflectColor("", color) = (1, 1, 1, 1)
		[HideInInspector] _V_CW_ReflectStrengthAlphaOffset("", Range(-1, 1)) = 0
		[HideInInspector] _V_CW_Cube("", Cube) = "_Skybox"{}	
		[HideInInspector] _V_CW_Fresnel_Power("", Range(0.5, 8.0)) = 1
		[HideInInspector] _V_CW_Fresnel_Bias("", Range(-1, 1)) = 0

		[HideInInspector] _V_CW_NormalMapStrength("", float) = 1
		[HideInInspector] _V_CW_NormalMap("", 2D) = "bump" {}
		[HideInInspector] _V_CW_NormalMap_UV_Scale ("", float) = 1

		[HideInInspector] _V_CW_SecondaryNormalMap("", 2D) = ""{}
		[HideInInspector] _V_CW_SecondaryNormalMap_UV_Scale("", float) = 1
	}  
	  
	SubShader     
	{     
		Tags { "Queue"="Transparent" 
			   "IgnoreProjector"="True" 
			   "RenderType"="Transparent"  
			   "CurvedWorldTag"="Legacy Shader/Additive/Decal" 
			   "CurvedWorldNoneRemoveableKeywords"=""  
			   "CurvedWorldAvailableOptions"="V_CW_REFLECTIVE;_EMISSION;V_CW_RIM;_NORMALMAP;V_CW_SPECULAR_HD;VERTEX_COLOR;V_CW_RANGE_FADE;" 
			 } 
		LOD 200

		Cull Off Lighting Off ZWrite Off
		Blend One OneMinusSrcColor

		    
		CGPROGRAM 
		#pragma surface surf BlinnPhong vertex:vert noshadow nodirlightmap nodynlightmap
		#pragma target 3.0 
		   
		 
		#pragma shader_feature _ V_CW_REFLECTIVE
		 
		#pragma shader_feature _ _EMISSION
		#pragma shader_feature _ V_CW_RIM

		#pragma shader_feature _ _NORMALMAP
		#pragma shader_feature _ V_CW_SPECULAR

		#pragma shader_feature _ V_CW_RANGE_FADE 

		#define V_CW_DECAL 		 
		#define V_CW_TRANSPARENT
		 
		#include "../cginc/CurvedWorld_Surface.cginc"

				
		ENDCG
	} 
	 
	Fallback "Hidden/VacuumShaders/Curved World/VertexLit/Transparent" 
	CustomEditor "CurvedWorld_Material_Editor"
}
