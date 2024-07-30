// Made with Amplify Shader Editor v1.9.4
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Banter/KeyboardBackSH"
{
	Properties
	{
		_Unlit("Unlit", 2D) = "black" {}
		_RouhnessMetallic("Rouhness/Metallic", 2D) = "black" {}
		_SecondaryColor("Secondary Color", Color) = (0.6687446,0,1,0)
		_PrimearyColor("Primeary Color", Color) = (0,1,0.6476085,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
		};

		uniform half4 _SecondaryColor;
		uniform half4 _PrimearyColor;
		uniform sampler2D _Unlit;
		uniform half4 _Unlit_ST;
		uniform sampler2D _RouhnessMetallic;
		uniform half4 _RouhnessMetallic_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Albedo = ( ( _SecondaryColor * i.vertexColor.r ) + ( _PrimearyColor * i.vertexColor.g ) ).rgb;
			float2 uv_Unlit = i.uv_texcoord * _Unlit_ST.xy + _Unlit_ST.zw;
			o.Emission = tex2D( _Unlit, uv_Unlit ).rgb;
			float2 uv_RouhnessMetallic = i.uv_texcoord * _RouhnessMetallic_ST.xy + _RouhnessMetallic_ST.zw;
			half4 tex2DNode29 = tex2D( _RouhnessMetallic, uv_RouhnessMetallic );
			o.Metallic = tex2DNode29.a;
			o.Smoothness = saturate( tex2DNode29 ).r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19400
Node;AmplifyShaderEditor.VertexColorNode;25;-256,0;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;5;-64,-96;Inherit;False;Property;_SecondaryColor;Secondary Color;2;0;Create;True;0;0;0;False;0;False;0.6687446,0,1,0;0.1730798,1,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;4;-48,176;Inherit;False;Property;_PrimearyColor;Primeary Color;3;0;Create;True;0;0;0;False;0;False;0,1,0.6476085,0;1,0,0.4325923,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;176,-48;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;192,96;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;29;-112,544;Inherit;True;Property;_RouhnessMetallic;Rouhness/Metallic;1;0;Create;True;0;0;0;False;0;False;-1;None;3371e27a5ae8f234e913a075a30a9202;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;28;368,16;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;22;-96,352;Inherit;True;Property;_Unlit;Unlit;0;0;Create;True;0;0;0;False;0;False;-1;None;3371e27a5ae8f234e913a075a30a9202;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;30;240,384;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;592,16;Half;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Banter/KeyboardBackSH;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;26;0;5;0
WireConnection;26;1;25;1
WireConnection;27;0;4;0
WireConnection;27;1;25;2
WireConnection;28;0;26;0
WireConnection;28;1;27;0
WireConnection;30;0;29;0
WireConnection;0;0;28;0
WireConnection;0;2;22;0
WireConnection;0;3;29;4
WireConnection;0;4;30;0
ASEEND*/
//CHKSM=0778A4A7D45ABE2A45C8902FBCE5BC898362D773