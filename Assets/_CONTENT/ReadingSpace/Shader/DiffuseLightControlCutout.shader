// Upgrade NOTE: replaced tex2D unity_Lightmap with UNITY_SAMPLE_TEX2D
// Upgrade NOTE: replaced tex2D unity_LightmapInd with UNITY_SAMPLE_TEX2D_SAMPLER
// Upgrade NOTE: upgraded instancing buffer 'DiffuseLightControlCutout' to new syntax.

// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "DiffuseLightControlCutout"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_Darkening("Darkening", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" }
		Cull Off
		AlphaToMask On
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
		};

		uniform sampler2D _MainTex;

		UNITY_INSTANCING_BUFFER_START(DiffuseLightControlCutout)
			UNITY_DEFINE_INSTANCED_PROP(half4, _MainTex_ST)
#define _MainTex_ST_arr DiffuseLightControlCutout
			UNITY_DEFINE_INSTANCED_PROP(half, _Darkening)
#define _Darkening_arr DiffuseLightControlCutout
		UNITY_INSTANCING_BUFFER_END(DiffuseLightControlCutout)

		void surf( Input i , inout SurfaceOutput o )
		{
			half4 _MainTex_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_MainTex_ST_arr, _MainTex_ST);
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST_Instance.xy + _MainTex_ST_Instance.zw;
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
			half3 decodeLightMap2 = DecodeLightmap(staticSwitch226_g1);
			half _Darkening_Instance = UNITY_ACCESS_INSTANCED_PROP(_Darkening_arr, _Darkening);
			half4 lerpResult6 = lerp( tex2D( _MainTex, uv_MainTex ) , half4( ( float3( 0,0,0 ) * decodeLightMap2 ) , 0.0 ) , _Darkening_Instance);
			o.Albedo = lerpResult6.rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Lambert keepalpha fullforwardshadows  

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			AlphaToMask Off
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
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
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
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
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
Version=19202
Node;AmplifyShaderEditor.DecodeLightmapHlpNode;2;-1059.154,169.7832;Inherit;True;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;3;-1400.111,157.6708;Inherit;True;Sample Lightmap;2;;1;6976f0f966a01684ca0a6dde441141c2;6,209,0,195,0,196,0,238,0,191,0,249,0;2;71;FLOAT3;0,0,0;False;169;FLOAT3;0,0,0;False;2;COLOR;0;COLOR;178
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Half;False;True;-1;2;ASEMaterialInspector;0;0;Lambert;DiffuseLightControlCutout;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;False;TransparentCutout;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;True;0;0;False;;-1;0;False;;0;1;;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-563.7351,143.0048;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;6;-232.4493,115.1691;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-688,-59.5;Inherit;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;5;-761.5502,340.8723;Inherit;False;InstancedProperty;_Darkening;Darkening;5;0;Create;True;0;0;0;True;0;False;0;0;0;1;0;1;FLOAT;0
WireConnection;2;0;3;178
WireConnection;0;0;6;0
WireConnection;4;1;2;0
WireConnection;6;0;1;0
WireConnection;6;1;4;0
WireConnection;6;2;5;0
ASEEND*/
//CHKSM=E4749B6AF860D8B2A85CBE78F58CFEED00F92309