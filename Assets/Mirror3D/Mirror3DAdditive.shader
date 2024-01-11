// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Banter/MirrorsQIslandAdditive"
{
	Properties
	{
		[NoScaleOffset]_ReflectionTexLeft("ReflectionTexLeft", 2D) = "white" {}
		[NoScaleOffset]_ReflectionTexRight("ReflectionTexRight", 2D) = "white" {}
		_StereoMode("StereoMode", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "AlphaTest+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend One One
		BlendOp Add
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
		};

		uniform sampler2D _ReflectionTexLeft;
		uniform sampler2D _ReflectionTexRight;
		uniform float _StereoMode;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_ReflectionTexLeft20 = i.uv_texcoord;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float localStereoEyeIndex1 = ( unity_StereoEyeIndex );
			float4 lerpResult18 = lerp( tex2D( _ReflectionTexLeft, ase_screenPosNorm.xy ) , tex2D( _ReflectionTexRight, ase_screenPosNorm.xy ) , localStereoEyeIndex1);
			float4 lerpResult21 = lerp( tex2D( _ReflectionTexLeft, uv_ReflectionTexLeft20 ) , lerpResult18 , _StereoMode);
			o.Emission = lerpResult21.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.SamplerNode;17;-367.0444,156.3838;Inherit;True;Property;_ReflectionTexRight;ReflectionTexRight;2;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;16;-373.6302,-36.8933;Inherit;True;Property;_ReflectionTexLeft;ReflectionTexLeft;0;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;18;56.48535,110.1633;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;19;61.87159,243.9144;Inherit;False;Property;_StereoMode;StereoMode;3;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;22;-695.8109,5.968435;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;21;250.178,60.65364;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;20;-369.0817,-234.6689;Inherit;True;Property;_ReflectionTexLeft1;ReflectionTexLeft;0;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;16;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;33;-579.2545,-282.414;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GrabScreenPosition;34;-899.8099,-313.4491;Inherit;False;1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CustomExpressionNode;35;-881.8196,-141.1975;Float;False;unity_StereoEyeIndex;1;Create;0;unity_StereoEyeIndex;True;False;0;;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;36;-930.5504,-65.37391;Float;False;#if UNITY_SINGLE_PASS_STEREO$1$#else$0$#endif;1;Create;0;UNITY_SINGLE_PASS_STEREO;True;False;0;;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;1;-221.0432,362.3607;Float;False;unity_StereoEyeIndex;1;Create;0;StereoEyeIndex;True;False;0;;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;663.278,13.9514;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Banter/MirrorsQIslandAdditive;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;False;0;False;Transparent;;AlphaTest;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;4;1;False;;1;False;;0;0;False;;0;False;;1;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;17;1;22;0
WireConnection;16;1;22;0
WireConnection;18;0;16;0
WireConnection;18;1;17;0
WireConnection;18;2;1;0
WireConnection;21;0;20;0
WireConnection;21;1;18;0
WireConnection;21;2;19;0
WireConnection;33;0;34;0
WireConnection;33;1;35;0
WireConnection;33;2;36;0
WireConnection;0;2;21;0
ASEEND*/
//CHKSM=5D54148089B9F290D1AF6823F0838A581DA18DE0