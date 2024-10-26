// Made with Amplify Shader Editor v1.9.4
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Banter/AvatarBox"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "black" {}
		_Gloss("Gloss", Range( 0 , 1)) = 0
		_Metallic("Metallic", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _MainTex;
		uniform half4 _MainTex_ST;
		uniform half _Metallic;
		uniform half _Gloss;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			half4 tex2DNode3 = tex2D( _MainTex, uv_MainTex );
			o.Albedo = ( tex2DNode3 * i.vertexColor ).rgb;
			half temp_output_18_0 = ( 1.0 - tex2DNode3.a );
			half4 temp_output_24_0 = ( temp_output_18_0 * tex2DNode3 );
			half temp_output_30_0 = ( temp_output_18_0 * (0.75 + (_SinTime.w - 0.0) * (1.0 - 0.75) / (1.0 - 0.0)) );
			o.Emission = ( temp_output_24_0 * temp_output_30_0 ).rgb;
			o.Metallic = ( _Metallic * tex2DNode3.a );
			o.Smoothness = ( _Gloss * tex2DNode3.a );
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19400
Node;AmplifyShaderEditor.SinTimeNode;29;-80,304;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-448,-416;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;18;-144,-64;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;32;384,336;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.75;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;23;-400,-224;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;14;-461.0117,135.5932;Inherit;False;Property;_Gloss;Gloss;1;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-409,254.7034;Inherit;False;Property;_Metallic;Metallic;2;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;208,192;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;176,-128;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FractNode;36;126.998,335.2538;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;112,-256;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;64,16;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;31;560,192;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.4;False;2;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;64,112;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;35;144,448;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;128,624;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;50;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;448,-144;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;28;528,48;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;832,-112;Half;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Banter/AvatarBox;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;18;0;3;4
WireConnection;32;0;29;4
WireConnection;30;0;18;0
WireConnection;30;1;32;0
WireConnection;24;0;18;0
WireConnection;24;1;3;0
WireConnection;36;0;29;4
WireConnection;22;0;3;0
WireConnection;22;1;23;0
WireConnection;27;0;14;0
WireConnection;27;1;3;4
WireConnection;31;0;30;0
WireConnection;26;0;20;0
WireConnection;26;1;3;4
WireConnection;35;0;29;4
WireConnection;33;0;29;4
WireConnection;34;0;24;0
WireConnection;34;1;30;0
WireConnection;28;0;24;0
WireConnection;28;1;30;0
WireConnection;0;0;22;0
WireConnection;0;2;34;0
WireConnection;0;3;26;0
WireConnection;0;4;27;0
ASEEND*/
//CHKSM=C4F4A100DEC869A007D4BA406786C9974B21512C