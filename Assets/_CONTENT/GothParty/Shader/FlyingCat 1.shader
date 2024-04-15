// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FlyingCat1"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_WaveSpeed("WaveSpeed", Range( 0 , 5)) = 0
		_WaveHight("WaveHight", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Lambert keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform float _WaveSpeed;
		uniform float _WaveHight;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;


		float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
		{
			original -= center;
			float C = cos( angle );
			float S = sin( angle );
			float t = 1 - C;
			float m00 = t * u.x * u.x + C;
			float m01 = t * u.x * u.y - S * u.z;
			float m02 = t * u.x * u.z + S * u.y;
			float m10 = t * u.x * u.y + S * u.z;
			float m11 = t * u.y * u.y + C;
			float m12 = t * u.y * u.z - S * u.x;
			float m20 = t * u.x * u.z - S * u.y;
			float m21 = t * u.y * u.z + S * u.x;
			float m22 = t * u.z * u.z + C;
			float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
			return mul( finalMatrix, original ) + center;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float4 appendResult98 = (float4(-ase_worldPos.x , ase_worldPos.y , -ase_worldPos.z , 0.0));
			float4 transform97 = mul(unity_WorldToObject,appendResult98);
			float mulTime88 = _Time.y * _WaveSpeed;
			float3 rotatedValue109 = RotateAroundAxis( float3( 0,0,0 ), transform97.xyz, float3( 0,0,0 ), sin( ( ( ( 1.0 - ( transform97 * float4( 0.1,0,0,0 ) ) ) + frac( mulTime88 ) ) * 6.28318548202515 ) ).x );
			float3 lerpResult114 = lerp( ( rotatedValue109 * _WaveHight ) , float3( 0,0,0 ) , v.color.r);
			float4 transform121 = mul(unity_ObjectToWorld,float4( lerpResult114 , 0.0 ));
			v.vertex.xyz += transform121.xyz;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			o.Emission = tex2D( _TextureSample0, uv_TextureSample0 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1317.351,1345.753;Float;False;True;-1;2;ASEMaterialInspector;0;0;Lambert;FlyingCat1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.VertexColorNode;113;836.1027,1801.007;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;114;1040.922,1679.816;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;865.1047,1579.766;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;102;585.7015,1646.503;Inherit;False;Property;_WaveHight;WaveHight;2;0;Create;True;0;0;0;False;0;False;0;0.028;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RotateAboutAxisNode;109;452.9532,1373.745;Inherit;False;False;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;33;883.4846,1335.648;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;aaf5bc1364857da4cb3b3cc6217d970d;True;0;False;white;LockedToTexture2D;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldToObjectTransfNode;97;-1117.754,1475.688;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;98;-1325.06,1457.59;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WorldPosInputsNode;96;-1739.702,1401.578;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NegateNode;119;-1499.104,1566.715;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;120;-1485.104,1423.715;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;87;-493.7295,1221.249;Inherit;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleTimeNode;88;-546.7293,1469.249;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;90;-364.7294,1456.249;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-850.7289,1502.249;Inherit;False;Property;_WaveSpeed;WaveSpeed;1;0;Create;True;0;0;0;False;0;False;0;0.79;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;46.27077,1307.249;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TauNode;104;-81.6364,1436.491;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;91;-212.7293,1285.249;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-659.8429,1181.944;Inherit;False;2;2;0;FLOAT4;0.36,0,0,0;False;1;FLOAT4;0.1,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SinOpNode;95;249.3779,1210.727;Inherit;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;121;1164.25,1893.255;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;0;2;33;0
WireConnection;0;11;121;0
WireConnection;114;0;101;0
WireConnection;114;2;113;1
WireConnection;101;0;109;0
WireConnection;101;1;102;0
WireConnection;109;1;95;0
WireConnection;109;3;97;0
WireConnection;97;0;98;0
WireConnection;98;0;120;0
WireConnection;98;1;96;2
WireConnection;98;2;119;0
WireConnection;119;0;96;3
WireConnection;120;0;96;1
WireConnection;87;0;85;0
WireConnection;88;0;89;0
WireConnection;90;0;88;0
WireConnection;92;0;91;0
WireConnection;92;1;104;0
WireConnection;91;0;87;0
WireConnection;91;1;90;0
WireConnection;85;0;97;0
WireConnection;95;0;92;0
WireConnection;121;0;114;0
ASEEND*/
//CHKSM=6478C8F8C6D8358E1D71EFE48DE4F8826A19B9AC