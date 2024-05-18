// Made with Amplify Shader Editor v1.9.3.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Banter/TerrainSplat"
{
	Properties
	{
		_Splat("Splat", 2D) = "white" {}
		_Black("Black", 2D) = "white" {}
		_Red("Red", 2D) = "white" {}
		_Green("Green", 2D) = "white" {}
		_Blue("Blue", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Lambert keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float2 uv2_texcoord2;
		};

		uniform sampler2D _Black;
		uniform half4 _Black_ST;
		uniform sampler2D _Red;
		uniform half4 _Red_ST;
		uniform sampler2D _Splat;
		uniform half4 _Splat_ST;
		uniform sampler2D _Green;
		uniform half4 _Green_ST;
		uniform sampler2D _Blue;
		uniform half4 _Blue_ST;

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_Black = i.uv_texcoord * _Black_ST.xy + _Black_ST.zw;
			float2 uv_Red = i.uv_texcoord * _Red_ST.xy + _Red_ST.zw;
			float2 uv1_Splat = i.uv2_texcoord2 * _Splat_ST.xy + _Splat_ST.zw;
			half4 tex2DNode48 = tex2D( _Splat, uv1_Splat );
			half4 lerpResult22 = lerp( tex2D( _Black, uv_Black ) , tex2D( _Red, uv_Red ) , tex2DNode48.r);
			float2 uv_Green = i.uv_texcoord * _Green_ST.xy + _Green_ST.zw;
			half4 lerpResult23 = lerp( lerpResult22 , tex2D( _Green, uv_Green ) , tex2DNode48.g);
			float2 uv_Blue = i.uv_texcoord * _Blue_ST.xy + _Blue_ST.zw;
			half4 lerpResult24 = lerp( lerpResult23 , tex2D( _Blue, uv_Blue ) , tex2DNode48.b);
			o.Albedo = lerpResult24.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19302
Node;AmplifyShaderEditor.SamplerNode;19;-456.6293,-600.601;Inherit;True;Property;_Red;Red;2;0;Create;True;0;0;0;False;0;False;-1;None;2115c7e1c47aeb04ebf73124ce80013c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;48;-920.5737,-1040.526;Inherit;True;Property;_Splat;Splat;0;0;Create;True;0;0;0;False;0;False;-1;None;42b70c781a9c0e047a4662320d476205;True;1;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;18;-184.8157,-837.7715;Inherit;True;Property;_Black;Black;1;0;Create;True;0;0;0;False;0;False;-1;None;38e077ea0da267f4b8ad9b4327ef347a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;22;206.3908,-543.6591;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;20;-479.6626,-338.8741;Inherit;True;Property;_Green;Green;3;0;Create;True;0;0;0;False;0;False;-1;None;87965f2573be6e8488ae108b18543ff8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;23;206.5271,-377.7694;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;26;-478.0581,-112.7921;Inherit;True;Property;_Blue;Blue;4;0;Create;True;0;0;0;False;0;False;-1;None;da49e0cea73007c44b2b49ec8236eb66;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;24;241.3498,-197.7768;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;539.9604,-241.1197;Half;False;True;-1;2;ASEMaterialInspector;0;0;Lambert;Banter/TerrainSplat;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;22;0;18;0
WireConnection;22;1;19;0
WireConnection;22;2;48;1
WireConnection;23;0;22;0
WireConnection;23;1;20;0
WireConnection;23;2;48;2
WireConnection;24;0;23;0
WireConnection;24;1;26;0
WireConnection;24;2;48;3
WireConnection;0;0;24;0
ASEEND*/
//CHKSM=EBF3EEA006F7356300F3B73E9A7425AE7E05DA92