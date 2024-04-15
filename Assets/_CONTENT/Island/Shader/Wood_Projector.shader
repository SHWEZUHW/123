// Upgrade NOTE: replaced tex2D unity_Lightmap with UNITY_SAMPLE_TEX2D
// Upgrade NOTE: replaced tex2D unity_LightmapInd with UNITY_SAMPLE_TEX2D_SAMPLER
// Upgrade NOTE: upgraded instancing buffer 'BanterWoodProjector' to new syntax.

// Made with Amplify Shader Editor v1.9.3.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Banter/WoodProjector"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "black" {}
		_Gloss1("Gloss", Range( 0 , 1)) = 0
		_Video("Video", 2D) = "white" {}
		_screenprojection("screenprojection", Float) = 0.25
		_terrainlight("terrainlight", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord3( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		struct Input
		{
			float2 uv_texcoord;
			float2 uv2_texcoord2;
			half3 worldNormal;
			float2 uv3_texcoord3;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _MainTex;
		uniform sampler2D _Video;
		uniform half _Gloss1;

		UNITY_INSTANCING_BUFFER_START(BanterWoodProjector)
			UNITY_DEFINE_INSTANCED_PROP(half4, _MainTex_ST)
#define _MainTex_ST_arr BanterWoodProjector
			UNITY_DEFINE_INSTANCED_PROP(half4, _Video_ST)
#define _Video_ST_arr BanterWoodProjector
			UNITY_DEFINE_INSTANCED_PROP(half, _terrainlight)
#define _terrainlight_arr BanterWoodProjector
			UNITY_DEFINE_INSTANCED_PROP(half, _screenprojection)
#define _screenprojection_arr BanterWoodProjector
		UNITY_INSTANCING_BUFFER_END(BanterWoodProjector)

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			half4 _MainTex_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_MainTex_ST_arr, _MainTex_ST);
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST_Instance.xy + _MainTex_ST_Instance.zw;
			half4 tex2DNode74 = tex2D( _MainTex, uv_MainTex );
			half2 staticUV55_g1 = (i.uv2_texcoord2*(unity_LightmapST).xy + (unity_LightmapST).zw);
			float localASEDecodeDirectionalLightmap1_g86 = ( 0.0 );
			half3 inputColor23_g86 = UNITY_SAMPLE_TEX2D( unity_Lightmap, staticUV55_g1 ).rgb;
			float3 Color1_g86 = inputColor23_g86;
			half4 temp_output_2_0_g86 = UNITY_SAMPLE_TEX2D_SAMPLER( unity_LightmapInd,unity_Lightmap, staticUV55_g1 );
			float4 DirTex1_g86 = temp_output_2_0_g86;
			half3 ase_worldNormal = i.worldNormal;
			half3 temp_output_71_0_g1 = ase_worldNormal;
			half3 normalWS67_g1 = temp_output_71_0_g1;
			half3 temp_output_4_0_g86 = normalWS67_g1;
			float3 NormalWorld1_g86 = temp_output_4_0_g86;
			{
			Color1_g86 = DecodeDirectionalLightmap( Color1_g86,DirTex1_g86,NormalWorld1_g86);
			}
			#ifdef DIRLIGHTMAP_COMBINED
				float4 staticSwitch226_g1 = float4( Color1_g86 , 0.0 );
			#else
				float4 staticSwitch226_g1 = UNITY_SAMPLE_TEX2D( unity_Lightmap, staticUV55_g1 );
			#endif
			half3 decodeLightMap35 = DecodeLightmap(staticSwitch226_g1);
			half _terrainlight_Instance = UNITY_ACCESS_INSTANCED_PROP(_terrainlight_arr, _terrainlight);
			half4 lerpResult37 = lerp( ( tex2DNode74 * half4( decodeLightMap35 , 0.0 ) ) , float4( 0,0,0,0 ) , ( _terrainlight_Instance * 2.0 ));
			half4 _Video_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_Video_ST_arr, _Video_ST);
			float2 uv2_Video = i.uv3_texcoord3 * _Video_ST_Instance.xy + _Video_ST_Instance.zw;
			half _screenprojection_Instance = UNITY_ACCESS_INSTANCED_PROP(_screenprojection_arr, _screenprojection);
			o.Emission = ( lerpResult37 + ( ( tex2D( _Video, uv2_Video ) * ( _screenprojection_Instance / 6.0 ) ) * i.vertexColor ) ).rgb;
			half4 temp_cast_6 = (_Gloss1).xxxx;
			o.Smoothness = ( ( 1.0 - tex2DNode74 ) - temp_cast_6 ).r;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 customPack1 : TEXCOORD1;
				float2 customPack2 : TEXCOORD2;
				float3 worldPos : TEXCOORD3;
				float3 worldNormal : TEXCOORD4;
				half4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.customPack1.zw = customInputData.uv2_texcoord2;
				o.customPack1.zw = v.texcoord1;
				o.customPack2.xy = customInputData.uv3_texcoord3;
				o.customPack2.xy = v.texcoord2;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				surfIN.uv2_texcoord2 = IN.customPack1.zw;
				surfIN.uv3_texcoord3 = IN.customPack2.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldNormal = IN.worldNormal;
				surfIN.vertexColor = IN.color;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19302
Node;AmplifyShaderEditor.FunctionNode;34;847.4724,-467.769;Inherit;False;Sample Lightmap;2;;1;6976f0f966a01684ca0a6dde441141c2;6,209,0,195,0,196,0,238,0,191,0,249,0;2;71;FLOAT3;0,0,0;False;169;FLOAT3;0,0,0;False;2;COLOR;0;COLOR;178
Node;AmplifyShaderEditor.RangedFloatNode;31;1034.921,-86.10307;Inherit;False;InstancedProperty;_screenprojection;screenprojection;6;0;Create;True;0;0;0;True;0;False;0.25;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;74;1177.982,-631.9024;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;0;False;0;False;-1;None;0366facf3caa79244a4f1ff4f5457572;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DecodeLightmapHlpNode;35;1169.43,-453.6565;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;38;1291.005,-320.5784;Inherit;False;InstancedProperty;_terrainlight;terrainlight;7;0;Create;True;0;0;0;True;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;27;991.263,-275.9649;Inherit;True;Property;_Video;Video;5;0;Create;True;0;0;0;False;0;False;-1;None;9fcb8cf15a79d7949b513ea805fabad0;True;2;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;78;1290.816,-98.43469;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;6;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;1663.248,-472.8942;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;1438.72,-200.9701;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;21;1578.565,-99.79979;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;1612.339,-331.2922;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;73;1540.47,185.1991;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;1795.436,-252.6843;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;76;1363.459,306.0887;Inherit;False;Property;_Gloss1;Gloss;1;0;Create;True;0;0;0;False;0;False;0;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;37;1827.731,-380.6552;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;75;1738.97,277.6989;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;79;1994.003,-293.7817;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2189.914,-325.0605;Half;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Banter/WoodProjector;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;35;0;34;178
WireConnection;78;0;31;0
WireConnection;41;0;74;0
WireConnection;41;1;35;0
WireConnection;30;0;27;0
WireConnection;30;1;78;0
WireConnection;80;0;38;0
WireConnection;73;0;74;0
WireConnection;72;0;30;0
WireConnection;72;1;21;0
WireConnection;37;0;41;0
WireConnection;37;2;80;0
WireConnection;75;0;73;0
WireConnection;75;1;76;0
WireConnection;79;0;37;0
WireConnection;79;1;72;0
WireConnection;0;2;79;0
WireConnection;0;4;75;0
ASEEND*/
//CHKSM=24379BC4FEE9831F4AB2F9A8CC4B6A3630271601