// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Banter/MaterixPlatform"
{
	Properties
	{
		_WireCol("WireCol", 2D) = "white" {}
		_Falloff("Falloff", 2D) = "white" {}
		_Gradiant("Gradiant", 2D) = "white" {}
		_Code("Code", 2D) = "white" {}
		_ScrollSpeed("ScrollSpeed", Float) = 0
		_Scale("Scale", Float) = 1
		_WireTint("WireTint", Color) = (0,0,0,0)
		_TextTint("TextTint", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord3( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Background+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float2 uv2_texcoord2;
			float2 uv3_texcoord3;
		};

		uniform float4 _TextTint;
		uniform sampler2D _Gradiant;
		uniform float _ScrollSpeed;
		uniform float _Scale;
		uniform sampler2D _Code;
		uniform sampler2D _WireCol;
		uniform float4 _WireTint;
		uniform sampler2D _Falloff;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float mulTime9 = _Time.y * _ScrollSpeed;
			float2 temp_cast_0 = (_Scale).xx;
			float2 uv_TexCoord11 = i.uv_texcoord * temp_cast_0;
			float2 panner8 = ( mulTime9 * float2( 0,1 ) + uv_TexCoord11);
			float4 tex2DNode4 = tex2D( _Gradiant, panner8 );
			float4 temp_output_34_0 = ( ( ( ( ( _TextTint * tex2DNode4.a ) + ( tex2DNode4 * tex2DNode4.a ) ) * ( tex2DNode4.a * tex2D( _Code, uv_TexCoord11 ).a ) ) + ( tex2D( _WireCol, i.uv2_texcoord2 ) * _WireTint ) ) * tex2D( _Falloff, i.uv3_texcoord3 ) );
			o.Emission = temp_output_34_0.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.SimpleTimeNode;9;-783,-293;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;8;-614,-351;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-741,-514;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;-981,-284;Inherit;False;Property;_ScrollSpeed;ScrollSpeed;5;0;Create;True;0;0;0;False;0;False;0;0.36;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-969,-394;Inherit;False;Property;_Scale;Scale;6;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;59.646,-352.1732;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;25;290.7954,-518.3654;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;214.2659,-206.8615;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;311,104;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;89.33185,-509.5846;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;6;-381.1548,-344.6809;Inherit;True;Property;_Code;Code;4;0;Create;True;0;0;0;False;0;False;-1;None;39f0b21eeff696b42b166b040d703503;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-373.0724,-630.6706;Inherit;True;Property;_Gradiant;Gradiant;3;0;Create;True;0;0;0;False;0;False;-1;None;eeeae8b12a74ae74ab4bb9af64f10f1c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;389.7954,-206.3654;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-525,101;Inherit;True;Property;_WireCol;WireCol;0;0;Create;True;0;0;0;False;0;False;-1;None;a3a55c9448512954197a70be7115123e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-182,166;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;361.8342,384.7383;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-818,109;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;13;-891.4836,-125.7976;Inherit;False;Property;_WireTint;WireTint;7;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;36;-319.3657,-100.1617;Inherit;False;Property;_TextTint;TextTint;8;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.07823295,1,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;33;-283.2131,417.8663;Inherit;True;Property;_Falloff;Falloff;1;0;Create;True;0;0;0;False;0;False;-1;None;6ee78ef071246504cbd54732d6a3ff37;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;35;-610.3567,420.1715;Inherit;False;2;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1056.845,-131.1692;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Banter/MaterixPlatform;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;True;Opaque;;Background;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;2;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.LerpOp;37;811.8001,71.25714;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;38;730.8001,280.2571;Inherit;False;Property;_Float0;Float 0;9;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
WireConnection;9;0;10;0
WireConnection;8;0;11;0
WireConnection;8;1;9;0
WireConnection;11;0;18;0
WireConnection;23;0;4;0
WireConnection;23;1;4;4
WireConnection;25;0;24;0
WireConnection;25;1;23;0
WireConnection;21;0;4;4
WireConnection;21;1;6;4
WireConnection;7;0;26;0
WireConnection;7;1;14;0
WireConnection;24;0;36;0
WireConnection;24;1;4;4
WireConnection;6;1;11;0
WireConnection;4;1;8;0
WireConnection;26;0;25;0
WireConnection;26;1;21;0
WireConnection;1;1;2;0
WireConnection;14;0;1;0
WireConnection;14;1;13;0
WireConnection;34;0;7;0
WireConnection;34;1;33;0
WireConnection;33;1;35;0
WireConnection;0;2;34;0
WireConnection;37;0;34;0
WireConnection;37;2;4;4
ASEEND*/
//CHKSM=B19BED24425DAA2D76EDF4AB6F8D4D0FE0E0EE07