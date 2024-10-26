// Upgrade NOTE: replaced tex2D unity_Lightmap with UNITY_SAMPLE_TEX2D
// Upgrade NOTE: replaced tex2D unity_LightmapInd with UNITY_SAMPLE_TEX2D_SAMPLER

// Made with Amplify Shader Editor v1.9.4
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "B-Standard"
{
	Properties
	{
		_Color("Tint", Color) = (0,0,0,0)
		_MainTex("Albedo", 2D) = "black" {}
		_MetallicGlossMap("Metallic", 2D) = "white" {}
		_GlossyReflections("Smoothness", Range( 0 , 5)) = 1
		_BumpMap("Normal Map", 2D) = "bump" {}
		_EmissionMap("EmissionMap", 2D) = "black" {}
		_EmissionColor("EmissionColor", Color) = (0,0,0,0)
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
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
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float2 uv2_texcoord2;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _BumpMap;
		uniform float4 _BumpMap_ST;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform sampler2D _MetallicGlossMap;
		uniform float4 _MetallicGlossMap_ST;
		uniform float4 _Color;
		uniform sampler2D _EmissionMap;
		uniform float4 _EmissionMap_ST;
		uniform float4 _EmissionColor;
		uniform float _GlossyReflections;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_BumpMap = i.uv_texcoord * _BumpMap_ST.xy + _BumpMap_ST.zw;
			o.Normal = UnpackNormal( tex2D( _BumpMap, uv_BumpMap ) );
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 uv_MetallicGlossMap = i.uv_texcoord * _MetallicGlossMap_ST.xy + _MetallicGlossMap_ST.zw;
			float4 tex2DNode6 = tex2D( _MetallicGlossMap, uv_MetallicGlossMap );
			o.Albedo = ( ( tex2D( _MainTex, uv_MainTex ) * tex2DNode6.g ) * _Color ).rgb;
			float2 uv_EmissionMap = i.uv_texcoord * _EmissionMap_ST.xy + _EmissionMap_ST.zw;
			o.Emission = ( tex2D( _EmissionMap, uv_EmissionMap ) * _EmissionColor ).rgb;
			o.Metallic = tex2DNode6.b;
			float2 staticUV55_g1 = (i.uv2_texcoord2*(unity_LightmapST).xy + (unity_LightmapST).zw);
			float localASEDecodeDirectionalLightmap1_g86 = ( 0.0 );
			float3 inputColor23_g86 = UNITY_SAMPLE_TEX2D( unity_Lightmap, staticUV55_g1 ).rgb;
			float3 Color1_g86 = inputColor23_g86;
			float4 temp_output_2_0_g86 = UNITY_SAMPLE_TEX2D_SAMPLER( unity_LightmapInd,unity_Lightmap, staticUV55_g1 );
			float4 DirTex1_g86 = temp_output_2_0_g86;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 temp_output_71_0_g1 = ase_worldNormal;
			float3 normalWS67_g1 = temp_output_71_0_g1;
			float3 temp_output_4_0_g86 = normalWS67_g1;
			float3 NormalWorld1_g86 = temp_output_4_0_g86;
			{
			Color1_g86 = DecodeDirectionalLightmap( Color1_g86,DirTex1_g86,NormalWorld1_g86);
			}
			#ifdef DIRLIGHTMAP_COMBINED
				float4 staticSwitch226_g1 = float4( Color1_g86 , 0.0 );
			#else
				float4 staticSwitch226_g1 = UNITY_SAMPLE_TEX2D( unity_Lightmap, staticUV55_g1 );
			#endif
			float3 decodeLightMap16 = DecodeLightmap(staticSwitch226_g1);
			o.Smoothness = ( ( ( 1.0 - tex2DNode6.r ) * decodeLightMap16 ) * _GlossyReflections ).x;
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
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
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
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.customPack1.zw = customInputData.uv2_texcoord2;
				o.customPack1.zw = v.texcoord1;
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
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
Version=19400
Node;AmplifyShaderEditor.SamplerNode;6;-976,720;Inherit;True;Property;_MetallicGlossMap;Metallic;5;0;Create;False;0;0;0;False;0;False;-1;None;a4beea55a7dff434e84070175e44c0e7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;15;-784,1056;Inherit;False;Sample Lightmap;1;;1;6976f0f966a01684ca0a6dde441141c2;6,209,0,195,0,196,0,238,0,191,0,249,0;2;71;FLOAT3;0,0,0;False;169;FLOAT3;0,0,0;False;2;COLOR;0;COLOR;178
Node;AmplifyShaderEditor.SamplerNode;1;-845.6369,-151.9438;Inherit;True;Property;_MainTex;Albedo;4;0;Create;False;0;0;0;False;0;False;-1;None;186e26a61b003ea4297e52e35b0af90d;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;14;-592,816;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DecodeLightmapHlpNode;16;-348.109,1034.216;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;3;-783.6369,27.05624;Inherit;False;Property;_Color;Tint;0;0;Create;False;0;0;0;False;0;False;0,0,0,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;5;-835.1166,369.0081;Inherit;True;Property;_EmissionMap;EmissionMap;8;0;Create;True;0;0;0;False;0;False;-1;None;36ee2a0380742b74796f5bbe54d4c3bf;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;7;-760.8038,546.9254;Inherit;False;Property;_EmissionColor;EmissionColor;9;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-538.6369,-21.94379;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-800,944;Inherit;False;Property;_GlossyReflections;Smoothness;6;0;Create;False;0;0;0;False;0;False;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-448,832;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;2;-848.0095,189.74;Inherit;True;Property;_BumpMap;Normal Map;7;0;Create;False;0;0;0;False;0;False;-1;None;3613a17ef9428c245978e3987bc379c0;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-516.0616,490.5836;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-249.0536,44.90845;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-368,720;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-272,848;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-149.331,347.1856;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;B-Standard;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;14;0;6;1
WireConnection;16;0;15;0
WireConnection;4;0;1;0
WireConnection;4;1;6;2
WireConnection;17;0;14;0
WireConnection;17;1;16;0
WireConnection;11;0;5;0
WireConnection;11;1;7;0
WireConnection;12;0;4;0
WireConnection;12;1;3;0
WireConnection;13;0;6;3
WireConnection;10;0;17;0
WireConnection;10;1;9;0
WireConnection;0;0;12;0
WireConnection;0;1;2;0
WireConnection;0;2;11;0
WireConnection;0;3;6;3
WireConnection;0;4;10;0
ASEEND*/
//CHKSM=E60C272DD0733548C9B65261B9B1E5585393DD22