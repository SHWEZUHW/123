// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AllNodes"
{
	Properties
	{
		[HideInInspector]_Mask2("_Mask2", 2D) = "white" {}
		[HideInInspector]_Mask0("_Mask0", 2D) = "white" {}
		[HideInInspector]_Mask1("_Mask1", 2D) = "white" {}
		[HideInInspector]_Mask3("_Mask3", 2D) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "Amplify" = "True"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
		#pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
		#pragma multi_compile _ _FORWARD_PLUS
		#include "TerrainEngine.cginc"
		#pragma multi_compile_local __ _ALPHATEST_ON
		#pragma shader_feature_local _MASKMAP
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			half filler;
		};

		uniform sampler2D _Mask2;
		uniform sampler2D _Mask0;
		uniform sampler2D _Mask1;
		uniform sampler2D _Mask3;
		uniform float4 _MaskMapRemapScale0;
		uniform float4 _MaskMapRemapOffset2;
		uniform float4 _MaskMapRemapScale2;
		uniform float4 _MaskMapRemapScale1;
		uniform float4 _MaskMapRemapOffset1;
		uniform float4 _MaskMapRemapScale3;
		uniform float4 _MaskMapRemapOffset3;
		uniform float4 _MaskMapRemapOffset0;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color338 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			o.Albedo = color338.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.CameraDepthFade;1;-469,-400;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CameraWorldClipPlanes;2;-20,-412;Inherit;False;Left;0;1;FLOAT4;0
Node;AmplifyShaderEditor.ComputeGrabScreenPosHlpNode;3;-539,-235;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ComputeScreenPosHlpNode;4;-237,-271;Inherit;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;5;-538,-113;Inherit;False;Device Depth;-1;;1;406db1e975d44e5438890badc39ee7cf;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DitheringNode;6;-282,-150;Inherit;False;0;False;4;0;FLOAT;0;False;1;SAMPLER2D;;False;2;FLOAT4;0,0,0,0;False;3;SAMPLERSTATE;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;7;-1,-190;Inherit;False;Global;_GrabScreen0;Grab Screen 0;0;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GrabScreenPosition;8;-501,-22;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OrthoParams;9;-200,-27;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CameraProjectionNode;10;-490,181;Inherit;False;unity_CameraProjection;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.ProjectionParams;11;-186,143;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenDepthNode;12;-190,-41;Inherit;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenParams;13;-119,-170;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenPosInputsNode;14;-329,-84;Inherit;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;15;-165,-221;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceCameraPos;16;-421,-187;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ZBufferParams;17;-281,-285;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;18;-455,322;Inherit;False;Constant;_Color0;Color 0;0;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DiffusionProfileNode;19;-214,348;Float;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;0;False;0;False;0;0;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-622,462;Inherit;False;Constant;_Float1;Float 1;1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GlobalArrayNode;21;-315,487;Inherit;False;MyGlobalArray;0;1;0;False;False;0;1;False;Object;-1;4;0;INT;0;False;2;INT;0;False;1;INT;0;False;3;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GradientNode;22;-486,443;Inherit;False;0;2;2;1,1,1,0;1,1,1,1;1,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.IntNode;23;-340,529;Inherit;False;Constant;_Int0;Int 0;1;0;Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.Matrix3X3Node;24;-441,506;Inherit;False;Constant;_Matrix0;Matrix 0;1;0;Create;True;0;0;0;False;0;False;1,0,0,0,1,0,0,0,1;0;1;FLOAT3x3;0
Node;AmplifyShaderEditor.Matrix4X4Node;25;-225,518;Inherit;False;Constant;_Matrix1;Matrix 1;1;0;Create;True;0;0;0;False;0;False;1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.PiNode;26;-347,528;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;27;-440,557;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;28;-299,534;Inherit;False;0;0;;Shader;False;0;5;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;29;-237,554;Inherit;False;Constant;_Vector0;Vector 0;1;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector3Node;30;-390,546;Inherit;False;Constant;_Vector1;Vector 1;1;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector4Node;31;-376,575;Inherit;False;Constant;_Vector2;Vector 2;1;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;33;-75,833;Inherit;False;BlinnPhongLightWrap;-1;;3;139fed909c1bc1a42a96c42d8cf09006;0;5;1;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;44;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;34;-375,907;Inherit;False;BoxMask;-1;;4;9dce4093ad5a42b4aa255f0153c4f209;0;4;1;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;10;FLOAT3;0,0,0;False;17;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;36;-22,1102;Inherit;False;Color Mask;-1;;6;eec747d987850564c95bde0e5a6d1867;0;4;1;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;37;-371,1328;Inherit;False;ConstantBiasScale;-1;;7;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;38;35,1320;Inherit;False;CoolWave;-1;;8;a4ec317493edf3b439fcd463a40eca0d;0;6;35;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;39;-168,1515;Inherit;False;CotangentFrame;-1;;9;62ce0f00f1417804bb4f2b38501ba0d0;0;3;4;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT3x3;5
Node;AmplifyShaderEditor.FunctionNode;40;146,1482;Inherit;False;Custom Screen Position;-1;;10;35530643343074e4bb5fb02a7011bd50;2,9,0,12,0;2;6;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;41;-214,1681;Inherit;False;Decode Directional Lighmap;-1;;11;8132441d5c7c63f479ea1c42855420a8;0;3;3;FLOAT3;0,0,0;False;2;FLOAT4;0,0,0,0;False;4;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;42;118,1618;Inherit;False;DepthMaskedRefraction;-1;;12;c805f061214177c42bca056464193f81;2,40,0,103,0;2;35;FLOAT3;0,0,0;False;37;FLOAT;0.02;False;1;FLOAT2;38
Node;AmplifyShaderEditor.FunctionNode;43;-250,1868;Inherit;False;Derive Tangent Basis;-1;;13;fee816718ad753c4f9b25822c0d67438;0;1;5;FLOAT2;0,0;False;2;FLOAT3x3;0;FLOAT3x3;6
Node;AmplifyShaderEditor.FunctionNode;44;105,1873;Inherit;False;Detail Albedo;69;;14;29e5a290b15a7884983e27c8f1afaa8c;0;3;12;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;9;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;45;354,1839;Inherit;False;Dielectric Specular;66;;15;cf90616a2350c5c4cba1069366c98fa1;1,1,0;2;2;FLOAT;0;False;9;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;46;-215,1994;Inherit;False;FetchHDColorPyramid;-1;;16;e17d5b1cd6898394dbe1f30e05022025;0;2;3;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;47;121,1999;Inherit;False;FetchLightmapValue;64;;17;43de3d4ae59f645418fdd020d1b8e78e;0;0;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;48;374,1963;Inherit;False;HDRP Decal UVs;-1;;18;5e2643b1c5c9c214d8c438e23555b8af;1,4,1;1;12;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;49;-182,2099;Inherit;False;Height-based Blending;-1;;19;31c0084e26e17dc4c963d2f60261c022;0;6;13;COLOR;0,0,0,0;False;12;COLOR;0,0,0,0;False;4;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;2;COLOR;15;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;50;89,2087;Inherit;False;Lerp White To;-1;;20;047d7c189c36a62438973bad9d37b1c2;0;2;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;51;230,2109;Inherit;False;Lightmap UV;-1;;21;1940f027d0458684eb0ad486f669d7d5;1,1,0;0;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;52;-149,2328;Inherit;False;MaskingFunction;-1;;22;571aab6f8c08f1c4d9bd4012d2958d88;0;3;21;FLOAT;0;False;30;FLOAT;0;False;25;FLOAT;0;False;3;FLOAT;0;FLOAT;32;FLOAT;28
Node;AmplifyShaderEditor.FunctionNode;53;282,2284;Inherit;False;Midtones Control;-1;;23;1862d12003a80d24ab048da83dc4e4d5;0;4;25;SAMPLER2D;0.0;False;26;FLOAT;0;False;27;FLOAT;0;False;28;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;54;-156,2478;Inherit;False;Non Stereo Screen Pos;-1;;24;1731ee083b93c104880efc701e11b49b;0;1;23;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;55;206,2457;Inherit;False;NormalCreate;62;;25;e12f7ae19d416b942820e3932b56220f;0;4;1;SAMPLER2D;;False;2;FLOAT2;0,0;False;3;FLOAT;0.5;False;4;FLOAT;2;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;56;-143,2625;Inherit;False;Normal From Height;-1;;26;1942fe2c5f1a1f94881a33d532e4afeb;0;2;20;FLOAT;0;False;110;FLOAT;1;False;2;FLOAT3;40;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;57;207,2634;Inherit;False;Normal From Texture;-1;;27;9728ee98a55193249b513caf9a0f1676;13,149,0,147,0,143,0,141,0,139,0,151,0,137,0,153,0,159,0,157,0,155,0,135,0,108,0;4;87;SAMPLER2D;0;False;85;FLOAT2;0,0;False;74;SAMPLERSTATE;0;False;91;FLOAT;1.5;False;2;FLOAT3;40;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;58;8,2354;Inherit;False;OrientationBasedSprite;-1;;28;1da8bc02c5f4ead4bb2f573150575751;1,46,1;6;40;SAMPLER2D;0.0;False;43;FLOAT2;0,0;False;48;FLOAT;0;False;41;FLOAT;1;False;45;FLOAT;1;False;42;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;59;177,2218;Inherit;False;PerturbNormal;-1;;29;c8b64dd82fb09f542943a895dffb6c06;1,26,0;1;6;FLOAT3;0,0,0;False;4;FLOAT3;9;FLOAT;28;FLOAT;29;FLOAT;30
Node;AmplifyShaderEditor.FunctionNode;60;-32,2220;Inherit;False;PerturbNormalHQ;-1;;31;45dff16e78a0685469fed8b5b46e4d96;0;4;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;61;181,2162;Inherit;False;PreparePerturbNormalHQ;-1;;32;ce0790c3228f3654b818a19dd51453a4;0;1;1;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT3;4;FLOAT3;6;FLOAT;9
Node;AmplifyShaderEditor.FunctionNode;62;-26,2304;Inherit;False;RadialUVDistortion;-1;;33;051d65e7699b41a4c800363fd0e822b2;0;7;60;SAMPLER2D;0.0;False;1;FLOAT2;1,1;False;11;FLOAT2;0,0;False;65;FLOAT;1;False;68;FLOAT2;1,1;False;47;FLOAT2;1,1;False;29;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;63;30,2189;Inherit;False;Sample Lightmap;59;;34;6976f0f966a01684ca0a6dde441141c2;6,209,0,195,0,196,0,238,0,191,0,249,0;2;71;FLOAT3;0,0,0;False;169;FLOAT3;0,0,0;False;2;COLOR;0;COLOR;178
Node;AmplifyShaderEditor.FunctionNode;64;136,2306;Inherit;False;Shadow Mask;-1;;87;b50f5becdd6b8504a861ba5b9b861159;0;1;3;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;65;29,2225;Inherit;False;Simple HUE;-1;;89;32abb5f0db087604486c2db83a2e817a;0;1;1;FLOAT;0;False;4;FLOAT3;6;FLOAT;7;FLOAT;5;FLOAT;8
Node;AmplifyShaderEditor.FunctionNode;66;134,2400;Inherit;False;SobelIntensity;76;;90;69cd4268d38569b4883384f82af06450;0;4;12;FLOAT;0;False;13;FLOAT;0;False;11;FLOAT2;0,0;False;1;SAMPLER2D;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;67;204,2360;Inherit;False;SobelIntensity;76;;91;69cd4268d38569b4883384f82af06450;0;4;12;FLOAT;0;False;13;FLOAT;0;False;11;FLOAT2;0,0;False;1;SAMPLER2D;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;68;223,2374;Inherit;False;SobelMain;35;;92;481788033fe47cd4893d0d4673016cbc;0;4;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT2;0,0;False;1;SAMPLER2D;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;69;134,2362;Inherit;False;SphereMask;-1;;101;988803ee12caf5f4690caee3c8c4a5bb;0;3;15;FLOAT3;0,0,0;False;14;FLOAT;0;False;12;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;70;117,2392;Inherit;False;SRP Additional Light;-1;;102;6c86746ad131a0a408ca599df5f40861;7,6,0,9,0,23,0,25,0,24,0,26,0,27,0;6;2;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;15;FLOAT3;0,0,0;False;14;FLOAT3;1,1,1;False;18;FLOAT;0.5;False;32;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;71;91,2373;Inherit;False;Stereo Screen Pos;-1;;105;855e05b95c44ab9408194955b1347bed;0;1;2;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;72;-2,2355;Inherit;False;Terrain Wind Animate Vertex;-1;;106;3bc81bd4568a7094daabf2ccd6a7e125;0;3;2;FLOAT4;0,0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;73;259,2445;Inherit;False;Terrain Wind Value;-1;;107;c7f50c5b53423ac408959a9a25532d8c;0;0;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;74;223,2426;Inherit;False;Twirl;-1;;108;90936742ac32db8449cd21ab6dd337c8;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT;0;False;4;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;75;250,2395;Inherit;False;UI-Sprite Effect Layer;52;;109;789bf62641c5cfe4ab7126850acc22b8;18,74,0,204,0,191,0,225,0,242,0,237,0,249,0,186,0,177,0,182,0,229,0,92,0,98,0,234,0,126,0,129,1,130,0,31,0;18;192;COLOR;1,1,1,1;False;39;COLOR;1,1,1,1;False;37;SAMPLER2D;;False;218;FLOAT2;0,0;False;239;FLOAT2;0,0;False;181;FLOAT2;0,0;False;75;SAMPLER2D;;False;80;FLOAT;1;False;183;FLOAT2;0,0;False;188;SAMPLER2D;;False;33;SAMPLER2D;;False;248;FLOAT2;0,0;False;233;SAMPLER2D;;False;101;SAMPLER2D;;False;57;FLOAT4;0,0,0,0;False;40;FLOAT;0;False;231;FLOAT;1;False;30;FLOAT;1;False;2;COLOR;0;FLOAT2;172
Node;AmplifyShaderEditor.FunctionNode;76;202,2480;Inherit;False;URP Tangent To World Normal;-1;;110;e73075222d6e6944aa84a1f1cd458852;0;1;14;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;77;117,2484;Inherit;False;Volumetric Sphere;-1;;111;21b394060dee4e24d99ea8f6db991160;2,164,1,154,1;3;3;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;1;False;7;FLOAT;97;FLOAT;178;FLOAT;88;FLOAT;0;FLOAT3;68;FLOAT3;75;INT;53
Node;AmplifyShaderEditor.FunctionNode;78;174,2498;Inherit;False;Waving Vertex;-1;;112;872b3757863bb794c96291ceeebfb188;0;3;1;FLOAT3;0,0,0;False;12;FLOAT;0;False;13;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendOpsNode;79;-110,2809;Inherit;False;ColorBurn;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.DesaturateOpNode;80;215,2820;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GammaToLinearNode;81;-62,2898;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCGrayscale;82;225,2911;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.HSVToRGBNode;83;-94,2976;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LinearToGammaNode;84;249,2980;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LuminanceNode;85;-3,3114;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosterizeNode;86;321,3068;Inherit;False;1;2;1;COLOR;0,0,0,0;False;0;INT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RGBToHSVNode;87;60,3179;Inherit;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleContrastOpNode;88;300,3191;Inherit;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;89;-164,3525;Inherit;False;Blinn-Phong Light;31;;113;cf814dba44d007a4e958d2ddd5813da6;0;3;42;COLOR;0,0,0,0;False;52;FLOAT3;0,0,0;False;43;COLOR;0,0,0,0;False;2;COLOR;0;FLOAT;57
Node;AmplifyShaderEditor.FogAndAmbientColorsNode;90;344,3605;Inherit;False;UNITY_LIGHTMODEL_AMBIENT;0;1;COLOR;0
Node;AmplifyShaderEditor.FogParamsNode;91;-52,3723;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;92;250,3765;Inherit;False;Lambert Light;29;;115;9be9b95d80559e74dac059ac0a4060cf;0;2;42;COLOR;0,0,0,0;False;52;FLOAT3;0,0,0;False;2;COLOR;0;FLOAT;57
Node;AmplifyShaderEditor.LightColorNode;93;-174,3929;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.FunctionNode;94;94,3916;Inherit;False;Metal Reflectance;-1;;116;55ea54ba7a9d52c4a8bf7b3e01e6ae77;1,38,0;0;1;FLOAT3;0
Node;AmplifyShaderEditor.ObjSpaceLightDirHlpNode;95;-38,4053;Inherit;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ObjSpaceLightDirHlpNode;96;275,4091;Inherit;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ShadeVertexLightsHlpNode;97;-89,4167;Inherit;False;4;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;98;204,4153;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightPos;99;61,4208;Inherit;False;0;3;FLOAT4;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.AllOpNode;100;774.1021,132.6917;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;101;961.2435,124.655;Inherit;False;And;-1;;117;50f923f3b90822e47953386ea346e02f;0;2;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AnyOpNode;102;798.2123,250.9467;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;103;949.7625,245.2061;Inherit;False;0;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCCompareWithRange;104;671.9207,276.205;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwitchNode;105;854.4696,322.1293;Inherit;False;0;2;8;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;106;914.1711,407.0892;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCIf;107;1041.611,302.6115;Inherit;False;6;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.MaterialQualityNode;108;705.2158,379.5346;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;109;709.8082,332.4622;Inherit;False;Or;-1;;118;dcfde22f80031984b87bcc46a052ad1f;0;2;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;110;837.248,252.0948;Inherit;False;Property;_Keyword3;Keyword 3;78;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassSwitchNode;111;839.5442,291.1304;Inherit;False;0;0;1;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;112;685.6979,422.0145;Inherit;False;Property;_ToggleSwitch0;Toggle Switch0;79;0;Create;True;0;0;0;False;0;False;0;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;113;826.915,745.7805;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;114;1084.091,675.746;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CeilOpNode;115;956.651,712.4854;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;116;961.2435,752.6692;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;117;934.837,689.5233;Inherit;False;ComputeFilterWidth;-1;;119;326bea850683cca44ae7af083d880d70;0;1;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DdxOpNode;118;1008.316,692.9676;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DdyOpNode;119;984.2056,691.8195;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;120;934.837,713.6335;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ExpOpNode;121;1032.426,678.0422;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Exp2OpNode;122;1104.757,704.4487;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;123;1171.347,802.0377;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FmodOpNode;124;1135.756,802.0377;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;125;1018.649,796.2972;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FWidthOpNode;126;880.876,886.9976;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;127;997.9829,820.4075;Inherit;False;Inverse Lerp;-1;;120;09cbe79402f023141a4dc1fddd4c9511;0;3;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;128;968.1321,931.7738;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LogOpNode;129;1002.575,763.0021;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Log10OpNode;130;1105.905,777.9275;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Log2OpNode;131;1053.092,815.8149;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;132;1095.572,853.7025;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMinOpNode;133;1185.124,869.776;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;134;1073.758,884.7014;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;135;1125.423,862.8873;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;136;1150.681,873.2203;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;137;1027.834,889.2938;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ReciprocalOpNode;138;1061.129,907.6636;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleRemainderNode;139;1148.385,945.551;Inherit;False;2;0;INT;0;False;1;INT;0;False;1;INT;0
Node;AmplifyShaderEditor.TFHCRemapNode;140;1046.203,939.8105;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RoundOpNode;141;1050.796,958.1802;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RSqrtOpNode;142;1121.978,997.2158;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;143;968.1321,967.3651;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode;144;1143.792,1013.289;Inherit;False;1;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;145;1084.091,1006.401;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SignOpNode;146;1000.279,1035.103;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimplifiedFModOpNode;147;1101.313,1060.362;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;148;923.356,1070.695;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SqrtOpNode;149;1001.427,1070.695;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;150;1061.129,1072.991;Inherit;False;Square;-1;;121;fea980a1f68019543b2cd91d506986e8;0;1;2;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StepOpNode;151;1087.535,1099.397;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;152;1217.271,1129.248;Inherit;False;Step Antialiasing;-1;;122;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;153;929.0966,1068.398;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TruncOpNode;154;736.2146,1059.214;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DeterminantOpNode;155;916.4674,1320.982;Inherit;False;1;0;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT;0
Node;AmplifyShaderEditor.InverseOpNode;156;1142.644,1272.761;Inherit;False;1;0;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT4x4;0
Node;AmplifyShaderEditor.MatrixFromVectors;157;1234.493,1256.688;Inherit;False;FLOAT3x3;True;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.PosFromTransformMatrix;158;1164.458,1262.428;Inherit;False;1;0;FLOAT4x4;1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TransposeOpNode;159;1133.46,1271.613;Inherit;False;1;0;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT4x4;0
Node;AmplifyShaderEditor.VectorFromMatrixNode;160;1140.348,1341.648;Inherit;False;Row;0;1;0;FLOAT4x4;1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CameraToWorldMatrix;161;1001.427,1681.487;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.TransformVariables;162;962.3916,1643.6;Inherit;False;UNITY_MATRIX_MVP;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.InverseTranspMVMatrixNode;163;1078.35,1630.97;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.InverseViewMatrixNode;164;1056.536,1657.377;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.MMatrixNode;165;1094.424,1650.488;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.MVMatrixNode;166;1049.648,1635.563;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.MVPMatrixNode;167;1126.571,1663.117;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.ObjectToWorldMatrixNode;168;979.6132,1675.747;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.ProjectionMatrixNode;169;1102.461,1713.634;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.UnityProjectorClipMatrixNode;170;1193.161,1686.079;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.UnityProjectorMatrixNode;171;1073.758,1675.747;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.TransposeMVMatrix;172;1138.052,1732.004;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.ViewMatrixNode;173;1285.01,1723.967;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.ViewProjectionMatrixNode;174;1196.605,1754.966;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.WorldToCameraMatrix;175;1086.387,1750.373;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.WorldToObjectMatrix;176;1047.351,1763.003;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.WorldToTangentMatrix;177;985.3537,1773.336;Inherit;False;0;1;FLOAT3x3;0
Node;AmplifyShaderEditor.FunctionNode;178;915.3191,2056.918;Inherit;False;Bacteria;-1;;123;c4b8e21d0aca1b04d843e80ebaf2ba67;0;2;2;FLOAT2;5,5;False;5;FLOAT;560;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;179;1171.347,2023.623;Inherit;False;Bacteria Smoothstep;-1;;124;d36a59c7990768542a8760d627324096;0;3;65;FLOAT2;0,0;False;67;FLOAT2;0.2,0.15;False;71;FLOAT2;0.1,0.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.BillboardNode;180;1190.865,2038.548;Inherit;False;Cylindrical;False;True;0;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;181;1242.53,2052.325;Inherit;False;Bricks Pattern;-1;;125;7d219d3a79fd53a48987a86fa91d6bac;0;4;15;FLOAT2;2,4;False;14;FLOAT;0.65;False;16;FLOAT;0.5;False;17;FLOAT2;0,1;False;2;FLOAT;0;FLOAT;3
Node;AmplifyShaderEditor.FunctionNode;182;1213.827,2052.325;Inherit;False;Checkerboard;-1;;128;43dad715d66e03a4c8ad5f9564018081;0;4;1;FLOAT2;0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClipNode;183;1203.494,2081.028;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorSpaceDouble;184;1090.979,2092.509;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CustomExpressionNode;185;931.3926,2141.878;Inherit;False; ;1;Create;1;True;In0;FLOAT;0;In;;Inherit;False;My Custom Expression;True;False;0;;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DecodeDepthNormalNode;186;1077.202,2147.618;Inherit;False;1;0;FLOAT4;0,0,0,0;False;2;FLOAT;0;FLOAT3;1
Node;AmplifyShaderEditor.DecodeFloatRGHlpNode;187;1201.198,2141.878;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DecodeFloatRGBAHlpNode;188;1171.347,2163.692;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DecodeLightmapHlpNode;189;1028.982,2148.766;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DecodeViewNormalStereoHlpNode;190;1076.054,2192.395;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DiffuseAndSpecularFromMetallicNode;191;1042.759,2213.061;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;3;FLOAT3;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.DistanceBasedTessNode;192;1046.203,2236.022;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;193;941.7256,2234.875;Inherit;False;Dots Pattern;-1;;129;7d8d5e315fd9002418fb41741d3a59cb;1,22,0;5;21;FLOAT2;0,0;False;3;FLOAT2;8,8;False;2;FLOAT;0.9;False;4;FLOAT;0.5;False;5;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.EdgeLengthTessNode;194;1084.091,2258.985;Inherit;False;1;0;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.EdgeLengthCullTessNode;195;1162.162,2271.614;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;196;1143.792,2242.911;Inherit;False;Ellipse;-1;;131;3ba94b7b3cfd5f447befde8107c04d52;0;3;2;FLOAT2;0,0;False;7;FLOAT;0.5;False;9;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.EncodeDepthNormalNode;197;1235.641,2385.276;Inherit;False;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.EncodeFloatRGHlpNode;198;1089.831,2355.426;Inherit;False;1;0;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.EncodeFloatRGBAHlpNode;199;988.7979,2361.166;Inherit;False;1;0;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.EncodeViewNormalStereoHlpNode;200;1152.977,2393.313;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;201;1205.79,2324.427;Inherit;False;Flow;26;;132;acad10cc8145e1f4eb8042bebe2d9a42;2,50,0,51,0;6;5;SAMPLER2D;;False;2;FLOAT2;0,0;False;55;FLOAT;1;False;18;FLOAT2;0,0;False;17;FLOAT2;1,1;False;24;FLOAT;0.2;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;202;1174.791,2315.242;Inherit;False;Four Splats First Pass Terrain;2;;133;37452fdfb732e1443b7e39720d05b708;2,102,1,85,0;7;59;FLOAT4;0,0,0,0;False;60;FLOAT4;0,0,0,0;False;61;FLOAT3;0,0,0;False;57;FLOAT;0;False;58;FLOAT;0;False;201;FLOAT;0;False;62;FLOAT;0;False;7;FLOAT4;0;FLOAT3;14;FLOAT;56;FLOAT;45;FLOAT;200;FLOAT;19;FLOAT;17
Node;AmplifyShaderEditor.GetLocalVarNode;203;1134.608,2346.241;Inherit;False;-1;;1;0;OBJECT;;False;1;OBJECT;0
Node;AmplifyShaderEditor.GradientSampleNode;204;1105.905,2322.13;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;205;1128.867,2314.094;Inherit;False;Grid;-1;;134;a9240ca2be7e49e4f9fa3de380c0dbe9;0;3;5;FLOAT2;8,8;False;6;FLOAT2;0,0;False;2;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.HDEmissionNode;206;1108.201,2346.241;Inherit;False;Luminance;False;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;207;1203.494,2417.423;Inherit;False;Herringbone;-1;;136;dbdb22f3b40ddf6459baf32842f7168a;0;3;7;FLOAT2;6,6;False;9;FLOAT;0.2;False;8;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.LayeredBlendNode;208;1082.943,2394.461;Inherit;False;6;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LinearDepthNode;209;1146.089,2455.311;Inherit;False;0;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LODFadeNode;210;1088.683,2451.867;Inherit;False;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;211;1159.866,2529.938;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;212;973.8726,2462.199;Inherit;False;Noise Sine Wave;-1;;137;a6eff29f739ced848846e3b648af87bd;0;2;1;FLOAT;0;False;2;FLOAT2;-0.5,0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.OutlineNode;213;1126.571,2611.453;Inherit;False;0;True;None;0;0;Front;True;True;True;True;0;False;;3;0;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;214;1070.313,2554.048;Inherit;False;Polygon;-1;;138;6906ef7087298c94c853d6753e182169;0;4;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;215;925.6521,2636.712;Inherit;False;Random Range;-1;;139;7b754edb8aebbfb4a9ace907af661cfc;0;3;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;216;1092.128,2202.728;Inherit;False;Reconstruct World Position From Depth;-1;;140;e7094bcbcc80eb140b2a3dbe6a861de8;0;0;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;217;1178.236,2224.542;Inherit;False;Rectangle;-1;;142;6b23e0c975270fb4084c354b2c83366a;0;3;1;FLOAT2;0,0;False;2;FLOAT;0.5;False;3;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ReflectionProbeNode;218;1167.903,2249.8;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;219;1101.312,2225.689;Inherit;False;myVarName;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;220;1186.272,2283.095;Inherit;False;1;0;OBJECT;;False;1;OBJECT;0
Node;AmplifyShaderEditor.FunctionNode;221;1100.164,2287.687;Inherit;False;Replace Color;-1;;143;896dccb3016c847439def376a728b869;1,12,0;5;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;222;1035.87,2311.798;Inherit;False;Rounded Rectangle;-1;;144;8679f72f5be758f47babb3ba1d5f51d3;0;4;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;223;1053.092,2353.129;Inherit;False;Sawtooth Wave;-1;;145;289adb816c3ac6d489f255fc3caf5016;0;1;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;224;1204.642,2382.98;Inherit;False;Smooth Wave;-1;;146;45d5b33902fbc0848a1166b32106db74;1,3,1;3;17;FLOAT2;1,1;False;16;FLOAT;0.5;False;18;FLOAT;0.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;225;1023.241,2376.092;Inherit;False;Spiral;-1;;148;310c5f1537fa4c44699ebaf10a65d8a2;1,2,1;5;7;FLOAT2;3,3;False;8;FLOAT2;1.5,1.5;False;9;FLOAT;1;False;10;FLOAT;0.6;False;11;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;226;1121.978,2404.794;Inherit;False;Square Wave;-1;;151;6f8df4c09ccca5d42b0d3d422aad9cbd;0;1;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BakedGINode;227;999.1309,2427.756;Inherit;False;True;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StickyNoteNode;228;1226.456,2457.607;Inherit;False;150;100;New Note;;1,1,1,1;;0;0
Node;AmplifyShaderEditor.FunctionNode;229;979.6131,2392.165;Inherit;False;Stripes;-1;;152;8e73a71cdf24db740864b4c3f3357e7f;0;4;5;FLOAT;6;False;4;FLOAT;0;False;3;FLOAT;0.5;False;12;FLOAT;45;False;1;FLOAT;0
Node;AmplifyShaderEditor.SummedBlendNode;230;1217.271,2477.125;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwitchByFaceNode;231;1158.718,2456.459;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwitchBySRPVersionNode;232;1312.564,2513.864;Inherit;False;9;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;233;1050.796,2427.756;Inherit;False;Triangle Wave;-1;;154;51ec3c8d117f3ec4fa3742c3e00d535b;0;1;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;234;1061.129,2423.164;Inherit;False;Truchet;-1;;155;600b4e63537aa56498ba8983340930ed;0;5;25;FLOAT2;8,8;False;6;FLOAT;3;False;33;FLOAT;0.7;False;34;FLOAT;0.1;False;19;FLOAT;163;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexToFragmentNode;235;1095.572,2464.496;Inherit;False;False;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;236;1243.678,2512.716;Inherit;False;0;0;1;0;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.WeightedBlendNode;237;1239.085,2535.678;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;238;723.5853,2496.643;Inherit;False;Whirl;-1;;156;7d75aee9e4d352a4299928ac98404afc;2,26,0,25,1;6;27;FLOAT2;0,0;False;1;FLOAT2;1,1;False;7;FLOAT2;0.5,0.5;False;16;FLOAT;8;False;21;FLOAT;2;False;10;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;239;616.8114,2369.203;Inherit;False;Zig Zag;-1;;159;8cd734fbcae021148a58931ed7d68679;2,24,0,17,1;4;19;FLOAT2;0,0;False;22;FLOAT2;1,1;False;15;FLOAT;0.5;False;16;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ObjSpaceViewDirHlpNode;240;955.5028,2897.332;Inherit;False;1;0;FLOAT4;0,0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.UnityObjToClipPosHlpNode;241;1149.533,2864.037;Inherit;False;1;0;FLOAT3;0,0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.UnityObjToViewPosHlpNode;242;1158.718,2920.294;Inherit;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;243;1211.531,3004.106;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TransformPositionNode;244;1121.978,2968.514;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceViewDirHlpNode;245;1028.982,2974.255;Inherit;False;1;0;FLOAT4;0,0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceViewDirHlpNode;246;1119.682,3032.808;Inherit;False;1;0;FLOAT4;0,0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldToObjectTransfNode;247;1147.237,3031.66;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldTransformParams;248;979.613,2988.032;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FaceVariableNode;249;993.3904,3301.466;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.TwoSidedSign;250;1195.457,3271.615;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;251;976.1688,3463.349;Inherit;False;Blinn-Phong Half Vector;-1;;162;91a149ac9d615be429126c95e20753ce;0;0;1;FLOAT3;0
Node;AmplifyShaderEditor.DepthFade;252;1178.235,3464.497;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;254;1050.796,3475.978;Inherit;False;Half Lambert Term;-1;;163;86299dc21373a954aa5772333626c9c1;0;1;3;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SurfaceDepthNode;255;1172.495,3516.162;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateFragmentDataNode;256;1235.641,3539.124;Inherit;False;0;0;;0;5;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateLocalVarsNode;257;1143.792,3547.16;Inherit;False;0;0;;0;5;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexBinormalNode;258;1108.201,3575.863;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;259;1142.644,3605.714;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FunctionNode;260;1178.235,3591.937;Inherit;False;World Normal Face;-1;;164;8ad4248928242e14ab87cd99e6913c33;1,86,1;0;1;FLOAT3;30
Node;AmplifyShaderEditor.WorldPosInputsNode;261;1296.49,3627.528;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldReflectionVector;262;1329.786,3622.936;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.VertexTangentNode;263;1243.678,3602.27;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FunctionNode;264;1177.087,4017.885;Inherit;False;Bicubic Precompute;-1;;165;818835145cc522e4da1f9915d8b8a984;0;2;5;FLOAT2;0,0;False;55;FLOAT4;0,0,0,0;False;2;FLOAT4;34;FLOAT2;54
Node;AmplifyShaderEditor.FunctionNode;265;1301.083,4084.475;Inherit;False;Bicubic Sample;-1;;166;ce0e14d5ad5eac645b2e5892ab3506ff;2,92,0,72,0;7;99;SAMPLER2D;0;False;91;SAMPLER2DARRAY;0;False;93;FLOAT;0;False;97;FLOAT2;0,0;False;198;FLOAT4;0,0,0,0;False;199;FLOAT2;0,0;False;94;SAMPLERSTATE;0;False;5;COLOR;86;FLOAT;84;FLOAT;85;FLOAT;82;FLOAT;83
Node;AmplifyShaderEditor.BlendNormalsNode;266;1374.562,4062.661;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.HeightMapBlendNode;267;1409.005,4115.474;Inherit;False;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;268;1295.342,4120.066;Inherit;False;Procedural Sample;-1;;167;f5379ff72769e2b4495e5ce2f004d8d4;2,157,0,315,0;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.SamplerStateNode;269;1369.969,4172.879;Inherit;False;0;0;0;1;-1;None;1;0;SAMPLER2D;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.TexelSizeNode;270;1309.12,4184.36;Inherit;False;-1;1;0;SAMPLER2D;;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;271;1361.933,4207.322;Inherit;True;Property;_TextureSample24;Texture Sample 24;80;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;272;1089.831,4064.957;Inherit;True;Property;_Texture0;Texture 0;81;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureTransformNode;273;1161.014,4176.323;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.TriplanarNode;274;1285.01,4163.694;Inherit;True;Spherical;World;False;Top Texture 0;_TopTexture0;white;0;None;Mid Texture 0;_MidTexture0;white;-1;None;Bot Texture 0;_BotTexture0;white;-1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.UnpackScaleNormalNode;275;1287.306,4195.841;Inherit;False;Tangent;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.VirtualTextureObject;276;1163.31,4164.842;Inherit;True;Property;_Texture1;Texture 1;82;0;Create;True;0;0;0;False;0;False;-1;None;None;False;white;Auto;Unity5;0;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.CosTime;277;1296.49,4785.969;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DeltaTime;278;1421.634,4759.562;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinTimeNode;279;1386.043,4704.453;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;280;1431.967,4691.824;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;281;1271.232,4604.568;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ACosOpNode;282;1259.352,5104.442;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ASinOpNode;283;1418.352,5114.442;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ATanOpNode;284;1638.352,5180.442;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ATan2OpNode;285;1521.352,5193.442;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode;286;1477.352,5273.442;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CoshOpNode;287;1500.352,5326.442;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DegreesOpNode;288;1578.352,5346.442;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;289;1565.352,5341.442;Inherit;False;Normal Reconstruct Z;-1;;168;63ba85b764ae0c84ab3d698b86364ae9;0;1;1;FLOAT2;0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;290;1507.352,5359.442;Inherit;False;Polar Coordinates;-1;;169;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;1;False;4;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;291;1510.352,5362.442;Inherit;False;Radial Shear;-1;;170;c6dc9fc7fa9b08c4d95138f2ae88b526;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RadiansOpNode;292;1481.352,5346.442;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;293;1456.352,5349.442;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinhOpNode;294;1547.352,5402.442;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;295;1398.352,5299.442;Inherit;False;Spherize;-1;;171;1488bb72d8899174ba0601b595d32b07;0;4;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TanOpNode;296;1469.352,5319.442;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TanhOpNode;297;1449.352,5314.442;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;298;1520.352,5837.442;Inherit;False;Bidirectional Parallax Mapping;-1;;172;ab457a4ccb6d8f745b63ef50e1417242;1,34,1;5;11;SAMPLER2D;0.0;False;32;SAMPLERSTATE;;False;10;FLOAT;0;False;9;FLOAT;0;False;25;INT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;299;1651.352,5869.442;Inherit;False;Flipbook;-1;;173;53c2488c220f6564ca6c90721ee16673;6,161,0,71,0,68,0,164,1,162,1,163,1;10;51;SAMPLER2D;0.0;False;167;SAMPLERSTATE;0;False;13;FLOAT2;0,0;False;24;FLOAT;0;False;4;FLOAT;3;False;5;FLOAT;3;False;130;FLOAT;0;False;2;FLOAT;0;False;55;FLOAT;0;False;70;FLOAT;0;False;5;COLOR;53;FLOAT2;0;FLOAT;47;FLOAT;48;FLOAT;62
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;300;1532.352,5831.442;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;301;1509.352,5881.442;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ParallaxMappingNode;302;1594.352,5908.442;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ParallaxOcclusionMappingNode;303;1596.352,5922.442;Inherit;False;0;8;False;;16;False;;2;0.02;0;False;1,1;False;0,0;8;0;FLOAT2;0,0;False;1;SAMPLER2D;;False;7;SAMPLERSTATE;;False;2;FLOAT;0.02;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT2;0,0;False;6;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ParallaxOffsetHlpNode;304;1628.352,5932.442;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCPixelate;305;1710.352,5951.442;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RotatorNode;306;1688.352,5981.442;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;307;1664.352,5914.442;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;308;1728.352,6301.442;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ComponentMaskNode;309;1747.352,6320.442;Inherit;False;True;True;True;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;310;1761.352,6345.442;Inherit;False;Create Orthogonal Vector;-1;;174;83358ef05db30f04ba825a1be5f469d8;0;2;25;FLOAT3;1,0,0;False;26;FLOAT3;0,1,0;False;3;FLOAT3;0;FLOAT3;1;FLOAT3;2
Node;AmplifyShaderEditor.CrossProductOpNode;311;1813.352,6379.442;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DistanceOpNode;312;1703.352,6373.442;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;313;1820.352,6401.442;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;314;1855.352,6438.442;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;315;1767.352,6434.442;Inherit;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;316;1742.352,6452.442;Inherit;False;Projection;-1;;175;3249e2c8638c9ef4bbd1902a2d38a67c;0;2;5;FLOAT4;0,0,0,0;False;6;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ReflectOpNode;317;1744.352,6476.442;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RefractOpVec;318;1746.352,6496.442;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;319;1733.352,6493.442;Inherit;False;Rejection;-1;;176;ea6ca936e02c9e74fae837451ff893c3;0;2;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RotateAboutAxisNode;320;1747.352,6523.442;Inherit;False;False;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;321;1748.352,6485.442;Inherit;False;FLOAT;1;0;FLOAT;0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SwizzleNode;322;1619.352,6375.442;Inherit;False;FLOAT4;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TransformDirectionNode;323;1752.352,6459.442;Inherit;False;Object;World;False;Fast;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.BlendIndicesNode;324;1817.338,6921.723;Inherit;False;0;5;FLOAT4;0;UINT;1;UINT;2;UINT;3;UINT;4
Node;AmplifyShaderEditor.BlendWeightsNode;325;1929.338,6931.723;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.InstanceIdNode;326;1919.338,6972.723;Inherit;False;False;0;1;INT;0
Node;AmplifyShaderEditor.ObjectScaleNode;327;1866.338,6999.723;Inherit;False;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PrimitiveIDVariableNode;328;1853.338,7018.723;Inherit;False;0;1;INT;0
Node;AmplifyShaderEditor.TemplateVertexDataNode;329;1807.338,7033.723;Inherit;False;0;0;;0;5;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BitangentVertexDataNode;330;1887.338,7059.723;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.VertexColorNode;331;1842.338,7072.723;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexIdVariableNode;332;1850.338,7058.723;Inherit;False;0;1;INT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;333;1860.338,7093.723;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;334;1839.338,7083.723;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TangentVertexDataNode;335;1911.338,7126.723;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TangentSignVertexDataNode;336;1946.338,7122.723;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;337;1923.338,7030.723;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;325,53;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;AllNodes;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.FunctionNode;32;-63,710;Inherit;False;Blackbody;-1;;2;e2cbc0474cd946f4ea11e89cfd2c903a;0;1;2;FLOAT;1000;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;35;-367,799;Inherit;False;Burn Effect;73;;5;e412e392e3db9574fbf6397db39b4c51;0;2;12;FLOAT;0;False;14;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;253;160.3036,546.7067;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;338;121.3997,126.9885;Inherit;False;Constant;_Color3;Color 3;29;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;0;0;338;0
ASEEND*/
//CHKSM=C352BC1550CE0E58F074F05F0F54BBC90DACC20E