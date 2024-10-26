// Made with Amplify Shader Editor v1.9.4
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Diffuse_MR"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_Metallic("Metallic", Range( 0 , 1)) = 0.8
		_Smoothness("Smoothness", Range( 0 , 1)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
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
			float2 uv_texcoord;
		};

		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _Metallic;
		uniform float _Smoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode1 = tex2D( _MainTex, uv_MainTex );
			o.Albedo = tex2DNode1.rgb;
			float clampResult2 = clamp( tex2DNode1.a , 0.0 , 0.5 );
			float temp_output_4_0 = (0.0 + (clampResult2 - 0.0) * (1.0 - 0.0) / (0.5 - 0.0));
			o.Metallic = ( temp_output_4_0 * _Metallic );
			float clampResult3 = clamp( tex2DNode1.a , 0.5001 , 1.0 );
			float temp_output_11_0 = ( ( 1.0 - (0.0 + (clampResult3 - 0.5) * (1.0 - 0.0) / (1.0 - 0.5)) ) * _Smoothness );
			o.Smoothness = temp_output_11_0;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19400
Node;AmplifyShaderEditor.SamplerNode;1;-1168,80;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;0;False;0;False;-1;None;d1e3a0684492d93469e187575a407579;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;3;-784,384;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.5001;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;2;-816,160;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;5;-480,384;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;4;-528,96;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-560,560;Inherit;False;Property;_Smoothness;Smoothness;2;0;Create;True;0;0;0;False;0;False;1;0.876;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;6;-272,368;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-592,272;Inherit;False;Property;_Metallic;Metallic;1;0;Create;True;0;0;0;False;0;False;0.8;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;7;-288,176;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-496,672;Inherit;False;Property;_SmoothnessAdd;SmoothnessAdd;3;0;Create;True;0;0;0;False;0;False;1;0.666;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-64,384;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;112,448;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-16,144;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;256,16;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Diffuse_MR;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;3;0;1;4
WireConnection;2;0;1;4
WireConnection;5;0;3;0
WireConnection;4;0;2;0
WireConnection;6;0;5;0
WireConnection;7;0;4;0
WireConnection;11;0;6;0
WireConnection;11;1;10;0
WireConnection;12;0;11;0
WireConnection;12;1;13;0
WireConnection;8;0;4;0
WireConnection;8;1;9;0
WireConnection;0;0;1;0
WireConnection;0;3;8;0
WireConnection;0;4;11;0
ASEEND*/
//CHKSM=8C980F989FC81CE8BA2922A5C474D3DDE502FB7C