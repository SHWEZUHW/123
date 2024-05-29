// Upgrade NOTE: replaced tex2D unity_Lightmap with UNITY_SAMPLE_TEX2D

// Made with Amplify Shader Editor v1.9.4
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Pillar"
{
	Properties
	{
		_Color("Tint", Color) = (0,0,0,0)
		_MainTex("MainTex", 2D) = "black" {}
		_MainTex1("Detail", 2D) = "black" {}
		_GlossyReflections("Smoothness", Range( 0 , 1)) = 1
		_BumpMap("Normal Map", 2D) = "bump" {}
		_Distance("Distance", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float2 uv2_texcoord2;
			float2 vertexToFrag10_g1;
			float3 worldPos;
		};

		uniform sampler2D _BumpMap;
		uniform float4 _BumpMap_ST;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float4 _Color;
		uniform sampler2D _MainTex1;
		uniform float4 _MainTex1_ST;
		uniform float4 _Affector;
		uniform float _Distance;
		uniform float _GlossyReflections;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			o.vertexToFrag10_g1 = ( ( v.texcoord1.xy * (unity_LightmapST).xy ) + (unity_LightmapST).zw );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_BumpMap = i.uv_texcoord * _BumpMap_ST.xy + _BumpMap_ST.zw;
			o.Normal = UnpackNormal( tex2D( _BumpMap, uv_BumpMap ) );
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode1 = tex2D( _MainTex, uv_MainTex );
			float2 uv1_MainTex1 = i.uv2_texcoord2 * _MainTex1_ST.xy + _MainTex1_ST.zw;
			float4 tex2DNode11 = tex2D( _MainTex1, uv1_MainTex1 );
			float4 lerpResult12 = lerp( tex2DNode1 , _Color , tex2DNode11.r);
			o.Albedo = lerpResult12.rgb;
			float4 tex2DNode7_g1 = UNITY_SAMPLE_TEX2D( unity_Lightmap, i.vertexToFrag10_g1 );
			float3 decodeLightMap6_g1 = DecodeLightmap(tex2DNode7_g1);
			float3 decodeLightMap34 = DecodeLightmap(float4( decodeLightMap6_g1 , 0.0 ));
			float3 ase_worldPos = i.worldPos;
			float smoothstepResult61 = smoothstep( 0.0 , 100.0 , length( ( float4( ase_worldPos , 0.0 ) - _Affector ) ));
			float temp_output_26_0 = saturate( ( 1.0 - ( smoothstepResult61 * _Distance ) ) );
			float4 color29 = IsGammaSpace() ? float4(1.498039,0.7294118,0,0) : float4(2.433049,0.4910209,0,0);
			float4 temp_output_37_0 = ( temp_output_26_0 * color29 );
			float4 lerpResult47 = lerp( float4( 0,0,0,0 ) , temp_output_37_0 , temp_output_26_0);
			float4 temp_output_49_0 = ( float4( decodeLightMap34 , 0.0 ) + lerpResult47 );
			o.Emission = ( lerpResult12 * temp_output_49_0 ).rgb;
			o.Smoothness = ( tex2DNode1.a + _GlossyReflections );
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19400
Node;AmplifyShaderEditor.WorldPosInputsNode;30;-1057.188,883.1626;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector4Node;31;-1081.942,1027.288;Float;False;Global;_Affector;_Affector;3;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;21;-819.8879,943.312;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LengthOpNode;22;-653.1368,942.4076;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-642.5837,1034.78;Inherit;False;Property;_Distance;Distance;9;0;Create;True;0;0;0;False;0;False;0;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;61;-424.8934,1136.911;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-474.7649,953.7913;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;25;-327.5575,951.4759;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;26;-185.6849,952.035;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;29;-401.3105,593.596;Inherit;False;Constant;_Color0;Color 0;16;1;[HDR];Create;True;0;0;0;False;0;False;1.498039,0.7294118,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;40;-641.2336,501.4342;Inherit;False;FetchLightmapValue;1;;1;43de3d4ae59f645418fdd020d1b8e78e;0;0;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-168.2108,590.4848;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-635.8669,-643.7817;Inherit;True;Property;_MainTex;MainTex;3;0;Create;False;0;0;0;False;0;False;-1;None;771bd95da091bc24e9c41a51c05dc94e;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;11;-697.4715,-425.8089;Inherit;True;Property;_MainTex1;Detail;4;0;Create;False;0;0;0;False;0;False;-1;None;42d4255e88e7e9b4ebf85273865a8c4d;True;1;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;2;-671.4783,-222.7962;Inherit;False;Property;_Color;Tint;0;0;Create;False;0;0;0;False;0;False;0,0,0,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DecodeLightmapHlpNode;34;-359.9352,367.867;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;47;48,720;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-824.5196,262.205;Inherit;False;Property;_GlossyReflections;Smoothness;5;0;Create;False;0;0;0;False;0;False;1;0.029;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;12;66.03912,-117.8055;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;49;236.1227,175.6811;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;3;-767.6177,27.60506;Inherit;True;Property;_BumpMap;Normal Map;6;0;Create;False;0;0;0;False;0;False;-1;None;c4e8ca8997c130a40a229e410068c5a5;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;18;-62.91436,-600.714;Inherit;False;Property;_Float0;Float 0;7;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-34.22156,-516.6859;Inherit;False;Property;_Float1;Float 0;8;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-388.7305,218.7012;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;15;250.9662,-465.2684;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;16;128.5588,-358.3237;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;14;-200.8337,-469.2812;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-108.0385,-2.923004;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-179.059,162.3473;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;290.788,546.9034;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;471.3217,67.73195;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;44;585.9793,190.1621;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;48;584.0406,390.3964;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;-21.93102,408.0173;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;283.0577,279.488;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;735.701,-38.56234;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Pillar;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;21;0;30;0
WireConnection;21;1;31;0
WireConnection;22;0;21;0
WireConnection;61;0;22;0
WireConnection;23;0;61;0
WireConnection;23;1;24;0
WireConnection;25;0;23;0
WireConnection;26;0;25;0
WireConnection;37;0;26;0
WireConnection;37;1;29;0
WireConnection;34;0;40;0
WireConnection;47;1;37;0
WireConnection;47;2;26;0
WireConnection;12;0;1;0
WireConnection;12;1;2;0
WireConnection;12;2;11;1
WireConnection;49;0;34;0
WireConnection;49;1;47;0
WireConnection;10;0;1;4
WireConnection;10;1;8;0
WireConnection;15;0;12;0
WireConnection;15;1;11;1
WireConnection;16;0;11;1
WireConnection;16;1;18;0
WireConnection;16;2;19;0
WireConnection;14;0;12;0
WireConnection;14;1;11;1
WireConnection;9;0;12;0
WireConnection;9;1;11;0
WireConnection;20;0;1;4
WireConnection;20;1;8;0
WireConnection;27;0;34;0
WireConnection;27;1;37;0
WireConnection;43;0;12;0
WireConnection;43;1;49;0
WireConnection;44;0;12;0
WireConnection;44;1;47;0
WireConnection;39;0;34;0
WireConnection;39;1;37;0
WireConnection;41;0;49;0
WireConnection;41;1;47;0
WireConnection;0;0;12;0
WireConnection;0;1;3;0
WireConnection;0;2;43;0
WireConnection;0;4;20;0
ASEEND*/
//CHKSM=9186BF15688590A19BE8FA47EEBC7BA1C558058A