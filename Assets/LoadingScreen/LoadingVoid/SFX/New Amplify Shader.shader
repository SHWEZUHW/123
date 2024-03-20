// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "New Amplify Shader"
{
	Properties
	{
		[Enum(Off,0,On,1)]_ZWriteMode1("ZWrite Mode", Int) = 1
		[Enum(Front,2,Back,1,Both,0)]_Cull("Render Face", Int) = 2
		[Enum(UnityEngine.Rendering.BlendOp)]_BlendOpAlpha("Blend Op Alpha", Float) = 0
		[Enum(UnityEngine.Rendering.BlendMode)]_DestinationBlendAlpha("Destination Blend Alpha", Float) = 10
		[Enum(UnityEngine.Rendering.BlendOp)]_BlendOpRGB("Blend Op RGB", Float) = 0
		_Color0("Color 0", Color) = (0,0,0,0)
		[Enum(UnityEngine.Rendering.BlendMode)]_DestinationBlendRGB("Destination Blend RGB", Float) = 10
		_StencilBufferWriteMask("Stencil Buffer Write Mask", Range( 0 , 255)) = 255
		_StencilBufferReadMask("Stencil Buffer Read Mask", Range( 0 , 255)) = 255
		_DepthOffsetFactor("Depth Offset Factor", Float) = 0
		_DepthOffsetUnits("Depth Offset Units", Float) = 0
		_StencilBufferReference("Stencil Buffer Reference", Range( 0 , 255)) = 0
		[Enum(UnityEngine.Rendering.StencilOp)]_StencilBufferFailFront("Stencil Buffer Fail Front", Float) = 0
		[Enum(UnityEngine.Rendering.StencilOp)]_StencilBufferZFailFront("Stencil Buffer ZFail Front", Float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)]_StencilBufferComparison("Stencil Buffer Comparison", Float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)]_ZTestMode("ZTest Mode", Float) = 4
		[Enum(UnityEngine.Rendering.StencilOp)]_StencilBufferPassFront("Stencil Buffer Pass Front", Float) = 0
		[Enum(UnityEngine.Rendering.BlendMode)]_SourceBlendAlpha("Source Blend Alpha", Float) = 1
		[Enum(UnityEngine.Rendering.BlendMode)]_SourceBlendRGB("Source Blend RGB", Float) = 1
		[Enum(Off,0,On,1)]_AlphatoCoverage("Alpha to Coverage", Float) = 0
		[Enum(UnityEngine.Rendering.ColorWriteMask)]_ColorMask("Color Mask", Float) = 15
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			half filler;
		};

		uniform float _ZTestMode;
		uniform float _StencilBufferReference;
		uniform float _StencilBufferReadMask;
		uniform float _StencilBufferWriteMask;
		uniform float _DepthOffsetFactor;
		uniform float _SourceBlendAlpha;
		uniform float _DestinationBlendAlpha;
		uniform float _BlendOpAlpha;
		uniform float _BlendOpRGB;
		uniform float _DestinationBlendRGB;
		uniform float _SourceBlendRGB;
		uniform int _ZWriteMode1;
		uniform float _DepthOffsetUnits;
		uniform float _StencilBufferPassFront;
		uniform float _StencilBufferFailFront;
		uniform float _StencilBufferZFailFront;
		uniform float _ColorMask;
		uniform float _AlphatoCoverage;
		uniform int _Cull;
		uniform float _StencilBufferComparison;
		uniform float4 _Color0;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Albedo = _Color0.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.CommentaryNode;1;-2791.358,-408.496;Inherit;False;2927.101;1479.342;Comment;11;10;9;8;7;6;5;4;3;2;0;53;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;2;-589.2944,-353.9102;Inherit;False;664.4502;496.3013;Depth;8;44;43;36;32;31;30;29;11;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;3;-1400.806,134.1553;Inherit;False;763.2805;512.7705;Stencil;8;52;47;46;45;28;27;26;17;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;4;-1403.664,-355.3761;Inherit;False;761.834;475.7645;Stencil;6;35;34;33;25;24;23;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;5;-2088.403,-357.1542;Inherit;False;639.9348;481.3461;Blend Alpha;6;39;38;37;22;21;18;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;6;-2739.582,-358.4971;Inherit;False;637.5515;488.855;Blend RGB;6;42;41;40;20;19;12;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;7;-2095.259,424.98;Inherit;False;514;253;Color Mask;2;48;13;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;8;-2097.117,151.5309;Inherit;False;510.3333;255;Mask Clip Value;2;49;16;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;9;-2738.536,427.7618;Inherit;False;511;252;Alpha to Coverage;2;50;14;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;10;-2741.358,152.7314;Inherit;False;514;250;Render Face;2;51;15;;0,0,0,1;0;0
Node;AmplifyShaderEditor.StickyNoteNode;11;-334.4249,16.23053;Inherit;False;356.8342;100;_DepthOffsetUnits;;0,0,0,1;_DepthOffsetUnits;0;0
Node;AmplifyShaderEditor.StickyNoteNode;12;-2483.6,-298.2233;Inherit;False;316.5269;103;_SourceBlendRGB;;0,0,0,1;Unity.Engine Enum Class$UnityEngine.Rendering.BlendMode$;0;0
Node;AmplifyShaderEditor.StickyNoteNode;13;-1930.378,470.2518;Inherit;False;322.8113;100;_ColorMask;;0,0,0,1;Unity.Engine Enum Class$UnityEngine.Rendering.ColorWriteMask;0;0
Node;AmplifyShaderEditor.StickyNoteNode;14;-2525.461,474.1372;Inherit;False;267.303;100;_AlphatoCoverage;;0,0,0,1;Unity.Engine Enum Class$Off,0,On,1;0;0
Node;AmplifyShaderEditor.StickyNoteNode;15;-2569.807,200.9115;Inherit;False;307.4241;100;_Cull;;0,0,0,1;Unity.Engine Enum Class$Front,2,Back,1,Both,0;0;0
Node;AmplifyShaderEditor.StickyNoteNode;16;-1888.304,193.4116;Inherit;False;277.7985;109;Mask Clip Value;;0,0,0,1;;0;0
Node;AmplifyShaderEditor.StickyNoteNode;17;-1086.5,511.9045;Inherit;False;391.59;100;_StencilBufferZFailFront;;0,0,0,1;Unity.Engine Enum Class$UnityEngine.Rendering.StencilOp;0;0
Node;AmplifyShaderEditor.StickyNoteNode;18;-1830.211,-295.2913;Inherit;False;315.1002;102;_SourceBlendAlpha;;0,0,0,1;Unity.Engine Enum Class$UnityEngine.Rendering.BlendMode$;0;0
Node;AmplifyShaderEditor.StickyNoteNode;19;-2481.28,-168.6678;Inherit;False;289.5269;100;_DestinationBlendRGB;;0,0,0,1;Unity.Engine Enum Class$UnityEngine.Rendering.BlendMode$;0;0
Node;AmplifyShaderEditor.StickyNoteNode;20;-2485.28,-40.66789;Inherit;False;285.5269;109.007;_BlendOpRGB;;0,0,0,1;Unity.Engine Enum Class$UnityEngine.Rendering.BlendOp$;0;0
Node;AmplifyShaderEditor.StickyNoteNode;21;-1829.838,-171.5117;Inherit;False;314.2911;100;_DestinationBlendAlpha;;0,0,0,1;Unity.Engine Enum Class$UnityEngine.Rendering.BlendMode$;0;0
Node;AmplifyShaderEditor.StickyNoteNode;22;-1831.807,-45.44975;Inherit;False;312.37;100;_BlendOpAlpha;;0,0,0,1;Unity.Engine Enum Class$UnityEngine.Rendering.BlendOp$;0;0
Node;AmplifyShaderEditor.StickyNoteNode;23;-1084.597,-296.0723;Inherit;False;288.1788;101.1804;_StencilBufferReference;;0,0,0,1;_StencilBufferReference;0;0
Node;AmplifyShaderEditor.StickyNoteNode;24;-1088.14,-188.6441;Inherit;False;292.9004;100;_StencilBufferReadMask;;0,0,0,1;_StencilBufferReadMask;0;0
Node;AmplifyShaderEditor.StickyNoteNode;25;-1089.32,-83.57878;Inherit;False;289.3591;100;_StencilBufferWriteMask;;0,0,0,1;_StencilBufferWriteMask;0;0
Node;AmplifyShaderEditor.StickyNoteNode;26;-1086.032,405.5521;Inherit;False;392.1897;101.1986;_StencilBufferFailFront;;0,0,0,1;Unity.Engine Enum Class$UnityEngine.Rendering.StencilOp;0;0
Node;AmplifyShaderEditor.StickyNoteNode;27;-1082.715,298.3936;Inherit;False;388.594;100;_StencilBufferPassFront;;0,0,0,1;Unity.Engine Enum Class$UnityEngine.Rendering.CompareFunction;0;0
Node;AmplifyShaderEditor.StickyNoteNode;28;-1081.647,192.1327;Inherit;False;390.9911;100;_StencilBufferComparison;;0,0,0,1;Unity.Engine Enum Class$UnityEngine.Rendering.CompareFunction;0;0
Node;AmplifyShaderEditor.StickyNoteNode;29;-334.4289,-200.8689;Inherit;False;356.9634;101.4987;_ZTestMode;;0,0,0,1;Unity.Engine Enum Class$UnityEngine.Rendering.CompareFunction$;0;0
Node;AmplifyShaderEditor.StickyNoteNode;30;-333.4118,-93.08989;Inherit;False;356.7666;100;_DepthOffsetFactor;;0,0,0,1;_DepthOffsetFactor;0;0
Node;AmplifyShaderEditor.StickyNoteNode;31;-332.3948,-307.6313;Inherit;False;350.2935;100;_ZWriteMode;;0,0,0,1;Unity.Engine Enum Class$Off,0,On,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-502.6314,-200.964;Inherit;False;Property;_ZTestMode;ZTest Mode;15;1;[Enum];Create;False;0;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-1367.469,-295.9313;Inherit;False;Property;_StencilBufferReference;Stencil Buffer Reference;11;0;Create;False;0;0;1;UnityEngine.Rendering.BlendMode;True;0;False;0;0;0;255;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-1373.191,-199.9019;Inherit;False;Property;_StencilBufferReadMask;Stencil Buffer Read Mask;8;0;Create;False;0;0;1;UnityEngine.Rendering.BlendMode;True;0;False;255;255;0;255;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-1369.83,-101.0918;Inherit;False;Property;_StencilBufferWriteMask;Stencil Buffer Write Mask;7;0;Create;False;0;0;1;UnityEngine.Rendering.BlendMode;True;0;False;255;255;0;255;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-554.8633,-96.61089;Inherit;False;Property;_DepthOffsetFactor;Depth Offset Factor;9;0;Create;False;0;0;1;UnityEngine.Rendering.BlendMode;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-2049.403,-294.1542;Inherit;False;Property;_SourceBlendAlpha;Source Blend Alpha;17;1;[Enum];Create;False;0;0;1;UnityEngine.Rendering.BlendMode;True;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-2057.104,-171.6548;Inherit;False;Property;_DestinationBlendAlpha;Destination Blend Alpha;3;1;[Enum];Create;False;0;0;1;UnityEngine.Rendering.BlendMode;True;0;False;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-2049.904,-41.75456;Inherit;False;Property;_BlendOpAlpha;Blend Op Alpha;2;1;[Enum];Create;False;0;0;1;UnityEngine.Rendering.BlendOp;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-2707.698,-44.76078;Inherit;False;Property;_BlendOpRGB;Blend Op RGB;4;1;[Enum];Create;False;0;0;1;UnityEngine.Rendering.BlendOp;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-2708.889,-168.8607;Inherit;False;Property;_DestinationBlendRGB;Destination Blend RGB;6;1;[Enum];Create;False;0;0;1;UnityEngine.Rendering.BlendMode;True;0;False;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-2707.5,-296.3443;Inherit;False;Property;_SourceBlendRGB;Source Blend RGB;18;1;[Enum];Create;False;0;0;1;UnityEngine.Rendering.BlendMode;True;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;43;-509.2944,-306.0103;Inherit;False;Property;_ZWriteMode1;ZWrite Mode;0;1;[Enum];Create;False;0;0;1;Off,0,On,1;True;0;False;1;1;False;0;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-542.9974,16.93134;Inherit;False;Property;_DepthOffsetUnits;Depth Offset Units;10;0;Create;False;0;0;1;UnityEngine.Rendering.BlendMode;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-1336.007,297.355;Inherit;False;Property;_StencilBufferPassFront;Stencil Buffer Pass Front;16;1;[Enum];Create;False;0;0;1;UnityEngine.Rendering.StencilOp;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-1326.606,408.1547;Inherit;False;Property;_StencilBufferFailFront;Stencil Buffer Fail Front;12;1;[Enum];Create;False;0;0;1;UnityEngine.Rendering.StencilOp;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-1338.806,513.7552;Inherit;False;Property;_StencilBufferZFailFront;Stencil Buffer ZFail Front;13;1;[Enum];Create;False;0;0;1;UnityEngine.Rendering.StencilOp;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-2080.259,472.9799;Inherit;False;Property;_ColorMask;Color Mask;20;1;[Enum];Create;False;0;0;1;UnityEngine.Rendering.ColorWriteMask;True;0;False;15;15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-2077.117,196.5308;Inherit;False;Constant;_MaskClipValue2;Mask Clip Value;19;0;Create;True;1;;0;0;True;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-2720.536,470.7617;Inherit;False;Property;_AlphatoCoverage;Alpha to Coverage;19;1;[Enum];Create;False;0;0;1;Off,0,On,1;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-1342.108,196.1548;Inherit;False;Property;_StencilBufferComparison;Stencil Buffer Comparison;14;1;[Enum];Create;False;0;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;51;-2726.358,198.7313;Inherit;False;Property;_Cull;Render Face;1;1;[Enum];Create;False;0;0;1;Front,2,Back,1,Both,0;True;0;False;2;2;False;0;1;INT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-203.8936,301.0382;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;New Amplify Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.ColorNode;53;-488.7493,296.2103;Inherit;False;Property;_Color0;Color 0;5;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;0;0;53;0
ASEEND*/
//CHKSM=4C9B4F899B281AC4A551666DD78A3BF93C17FF93