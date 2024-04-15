// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FlyingCat"
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
			float4 transform122 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float4 appendResult98 = (float4(transform122.x , transform122.y , -transform122.z , 0.0));
			float mulTime88 = _Time.y * _WaveSpeed;
			float3 rotatedValue109 = RotateAroundAxis( float3( 0,0,0 ), appendResult98.xyz, float3( 0,0,0 ), sin( ( ( ( 1.0 - ( appendResult98 * float4( 0.1,0,0,0 ) ) ) + frac( mulTime88 ) ) * 6.28318548202515 ) ).x );
			float3 lerpResult114 = lerp( ( rotatedValue109 * _WaveHight ) , float3( 0,0,0 ) , v.color.r);
			v.vertex.xyz += lerpResult114;
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
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;865.1047,1579.766;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RotateAboutAxisNode;109;452.9532,1373.745;Inherit;False;False;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;33;883.4846,1335.648;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;aaf5bc1364857da4cb3b3cc6217d970d;True;0;False;white;LockedToTexture2D;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;46.27077,1307.249;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SinOpNode;95;249.3779,1210.727;Inherit;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;98;-1084.373,1464.567;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;114;1040.922,1679.816;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;122;-1512.824,1432.128;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;113;878.1027,1921.007;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;102;434.4759,1575.744;Inherit;False;Property;_WaveHight;WaveHight;2;0;Create;True;0;0;0;False;0;False;0;0.05;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;128;-64.20349,1429.886;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;119;-1278.695,1549.715;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-809.8429,1285.944;Inherit;False;2;2;0;FLOAT4;0.36,0,0,0;False;1;FLOAT4;0.1,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.OneMinusNode;87;-644.7295,1260.249;Inherit;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-1089.956,1651.868;Inherit;False;Property;_WaveSpeed;WaveSpeed;1;0;Create;True;0;0;0;False;0;False;0;0.97;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;88;-798.0362,1657.685;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;90;-608.7294,1643.249;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;91;-418.7293,1316.249;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WorldPosInputsNode;129;-1932.698,1542.477;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TransformPositionNode;130;-1829.698,1398.477;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1608.62,1365.84;Float;False;True;-1;2;ASEMaterialInspector;0;0;Lambert;FlyingCat;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;131;1094.603,1880.255;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TransformPositionNode;133;1292.614,1782.839;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
WireConnection;101;0;109;0
WireConnection;101;1;102;0
WireConnection;109;1;95;0
WireConnection;109;3;98;0
WireConnection;92;0;91;0
WireConnection;92;1;128;0
WireConnection;95;0;92;0
WireConnection;98;0;122;1
WireConnection;98;1;122;2
WireConnection;98;2;119;0
WireConnection;114;0;101;0
WireConnection;114;2;113;1
WireConnection;119;0;122;3
WireConnection;85;0;98;0
WireConnection;87;0;85;0
WireConnection;88;0;89;0
WireConnection;90;0;88;0
WireConnection;91;0;87;0
WireConnection;91;1;90;0
WireConnection;0;2;33;0
WireConnection;0;11;114;0
WireConnection;131;0;114;0
WireConnection;133;0;114;0
ASEEND*/
//CHKSM=2AD9E09BD21D834C7080D5E4A6FFD5BC34B2C8BD