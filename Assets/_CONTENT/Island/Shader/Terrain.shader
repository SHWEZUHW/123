// Upgrade NOTE: replaced tex2D unity_Lightmap with UNITY_SAMPLE_TEX2D
// Upgrade NOTE: replaced tex2D unity_LightmapInd with UNITY_SAMPLE_TEX2D_SAMPLER
// Upgrade NOTE: upgraded instancing buffer 'BanterTerrain' to new syntax.

// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Banter/Terrain"
{
	Properties
	{
		_Splat("Splat", 2D) = "white" {}
		_Black("Black", 2D) = "white" {}
		_Red("Red", 2D) = "white" {}
		_Green("Green", 2D) = "white" {}
		_Blue("Blue", 2D) = "white" {}
		_Video("Video", 2D) = "white" {}
		_screenprojection("screenprojection", Float) = 0.25
		_terrainlight("terrainlight", Range( 0 , 2)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord4( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		struct Input
		{
			float2 uv_texcoord;
			float2 uv2_texcoord2;
			half3 worldNormal;
			float2 uv4_texcoord4;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _Black;
		uniform sampler2D _Red;
		uniform sampler2D _Splat;
		uniform sampler2D _Green;
		uniform sampler2D _Blue;
		uniform sampler2D _Video;

		UNITY_INSTANCING_BUFFER_START(BanterTerrain)
			UNITY_DEFINE_INSTANCED_PROP(half4, _Black_ST)
#define _Black_ST_arr BanterTerrain
			UNITY_DEFINE_INSTANCED_PROP(half4, _Red_ST)
#define _Red_ST_arr BanterTerrain
			UNITY_DEFINE_INSTANCED_PROP(half4, _Splat_ST)
#define _Splat_ST_arr BanterTerrain
			UNITY_DEFINE_INSTANCED_PROP(half4, _Green_ST)
#define _Green_ST_arr BanterTerrain
			UNITY_DEFINE_INSTANCED_PROP(half4, _Blue_ST)
#define _Blue_ST_arr BanterTerrain
			UNITY_DEFINE_INSTANCED_PROP(half4, _Video_ST)
#define _Video_ST_arr BanterTerrain
			UNITY_DEFINE_INSTANCED_PROP(half, _terrainlight)
#define _terrainlight_arr BanterTerrain
			UNITY_DEFINE_INSTANCED_PROP(half, _screenprojection)
#define _screenprojection_arr BanterTerrain
		UNITY_INSTANCING_BUFFER_END(BanterTerrain)


		float2 voronoihash70( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi70( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash70( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			
			 		}
			 	}
			}
			return F1;
		}


		void surf( Input i , inout SurfaceOutput o )
		{
			half4 _Black_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_Black_ST_arr, _Black_ST);
			float2 uv_Black = i.uv_texcoord * _Black_ST_Instance.xy + _Black_ST_Instance.zw;
			half4 tex2DNode18 = tex2D( _Black, uv_Black );
			half4 _Red_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_Red_ST_arr, _Red_ST);
			float2 uv_Red = i.uv_texcoord * _Red_ST_Instance.xy + _Red_ST_Instance.zw;
			half4 _Splat_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_Splat_ST_arr, _Splat_ST);
			float2 uv1_Splat = i.uv2_texcoord2 * _Splat_ST_Instance.xy + _Splat_ST_Instance.zw;
			half4 tex2DNode48 = tex2D( _Splat, uv1_Splat );
			half4 lerpResult22 = lerp( tex2DNode18 , tex2D( _Red, uv_Red ) , tex2DNode48.r);
			half4 _Green_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_Green_ST_arr, _Green_ST);
			float2 uv_Green = i.uv_texcoord * _Green_ST_Instance.xy + _Green_ST_Instance.zw;
			half4 lerpResult23 = lerp( lerpResult22 , tex2D( _Green, uv_Green ) , tex2DNode48.g);
			half4 _Blue_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_Blue_ST_arr, _Blue_ST);
			float2 uv_Blue = i.uv_texcoord * _Blue_ST_Instance.xy + _Blue_ST_Instance.zw;
			half4 lerpResult24 = lerp( lerpResult23 , tex2D( _Blue, uv_Blue ) , tex2DNode48.b);
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
			half4 lerpResult37 = lerp( lerpResult24 , ( lerpResult24 * half4( decodeLightMap35 , 0.0 ) ) , _terrainlight_Instance);
			o.Albedo = lerpResult37.rgb;
			half4 _Video_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_Video_ST_arr, _Video_ST);
			float2 uv3_Video = i.uv4_texcoord4 * _Video_ST_Instance.xy + _Video_ST_Instance.zw;
			half4 tex2DNode27 = tex2D( _Video, uv3_Video );
			half _screenprojection_Instance = UNITY_ACCESS_INSTANCED_PROP(_screenprojection_arr, _screenprojection);
			half time70 = _Time.y;
			half2 voronoiSmoothId70 = 0;
			float2 coords70 = i.uv_texcoord * 2.0;
			float2 id70 = 0;
			float2 uv70 = 0;
			float voroi70 = voronoi70( coords70, time70, id70, uv70, 0, voronoiSmoothId70 );
			half4 clampResult68 = clamp( ( (0.5 + (( tex2DNode48.r + tex2DNode48.g + tex2DNode48.b ) - 0.0) * (-0.15 - 0.5) / (1.0 - 0.0)) * ( tex2DNode18 * voroi70 ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			o.Emission = ( ( ( lerpResult24 * ( tex2DNode27 * _screenprojection_Instance ) ) * i.vertexColor ) + clampResult68 ).rgb;
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
				o.customPack2.xy = customInputData.uv4_texcoord4;
				o.customPack2.xy = v.texcoord3;
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
				surfIN.uv4_texcoord4 = IN.customPack2.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldNormal = IN.worldNormal;
				surfIN.vertexColor = IN.color;
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
Node;AmplifyShaderEditor.LerpOp;24;241.3498,-197.7768;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;23;206.5271,-377.7694;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;22;206.3908,-543.6591;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;19;-456.6293,-600.601;Inherit;True;Property;_Red;Red;6;0;Create;True;0;0;0;False;0;False;-1;None;2115c7e1c47aeb04ebf73124ce80013c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;20;-479.6626,-338.8741;Inherit;True;Property;_Green;Green;7;0;Create;True;0;0;0;False;0;False;-1;None;87965f2573be6e8488ae108b18543ff8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;26;-478.0581,-112.7921;Inherit;True;Property;_Blue;Blue;8;0;Create;True;0;0;0;False;0;False;-1;None;da49e0cea73007c44b2b49ec8236eb66;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;27;398.1687,-896.7855;Inherit;True;Property;_Video;Video;9;0;Create;True;0;0;0;False;0;False;-1;None;daf2a63a9c1942047861dbc38a46f413;True;3;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;746.161,-286.2863;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DecodeLightmapHlpNode;35;282.7563,127.7685;Inherit;True;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;34;-58.20076,115.6561;Inherit;True;Sample Lightmap;2;;1;6976f0f966a01684ca0a6dde441141c2;6,209,0,195,0,196,0,238,0,191,0,249,0;2;71;FLOAT3;0,0,0;False;169;FLOAT3;0,0,0;False;2;COLOR;0;COLOR;178
Node;AmplifyShaderEditor.SimpleSubtractOpNode;47;853.116,-8.321899;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;847.1752,120.9901;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;48;-920.5737,-1040.526;Inherit;True;Property;_Splat;Splat;0;0;Create;True;0;0;0;False;0;False;-1;None;42b70c781a9c0e047a4662320d476205;True;1;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;18;-184.8157,-837.7715;Inherit;True;Property;_Black;Black;1;0;Create;True;0;0;0;False;0;False;-1;None;38e077ea0da267f4b8ad9b4327ef347a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;1133.161,-158.9726;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;54;922.6622,-236.3594;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;50;1490.576,-580.8243;Inherit;False;Property;_Gloss;Gloss;5;0;Create;True;0;0;0;False;0;False;0;0.341;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;37;1923.757,-333.2314;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;67;2008.912,-218.4716;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2189.914,-325.0605;Half;False;True;-1;2;ASEMaterialInspector;0;0;Lambert;Banter/Terrain;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleTimeNode;71;1478.912,-762.4716;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;70;1642.912,-785.4716;Inherit;False;0;0;1;0;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;2;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;1811.912,-514.4716;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;64;1369.912,198.5284;Inherit;False;Property;_max;max;12;0;Create;True;0;0;0;False;0;False;0;-0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;1528.912,268.5284;Inherit;False;Property;_min;min;11;0;Create;True;0;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;1564.646,-85.89948;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;21;1173.405,-3.624313;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;68;1780.912,-114.4716;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;56;1186.134,-496.3282;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;28;477.7223,-696.6259;Inherit;True;Property;_Mask;Mask;10;0;Create;True;0;0;0;False;0;False;-1;None;878972c3151f97940b2c53535a0d1ce5;True;3;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;832.9216,-611.2219;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;31;492.9495,-326.5104;Inherit;False;InstancedProperty;_screenprojection;screenprojection;13;0;Create;True;0;0;0;True;0;False;0.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;554.3601,293.8576;Inherit;False;InstancedProperty;_terrainlight;terrainlight;14;0;Create;True;0;0;0;True;0;False;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;62;1357.006,-471.0146;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.5;False;4;FLOAT;-0.15;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;1599.77,-386.7841;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
WireConnection;24;0;23;0
WireConnection;24;1;26;0
WireConnection;24;2;48;3
WireConnection;23;0;22;0
WireConnection;23;1;20;0
WireConnection;23;2;48;2
WireConnection;22;0;18;0
WireConnection;22;1;19;0
WireConnection;22;2;48;1
WireConnection;30;0;27;0
WireConnection;30;1;31;0
WireConnection;35;0;34;178
WireConnection;47;0;24;0
WireConnection;47;1;35;0
WireConnection;41;0;24;0
WireConnection;41;1;35;0
WireConnection;46;0;24;0
WireConnection;46;1;30;0
WireConnection;37;0;24;0
WireConnection;37;1;41;0
WireConnection;37;2;38;0
WireConnection;67;0;72;0
WireConnection;67;1;68;0
WireConnection;0;0;37;0
WireConnection;0;2;67;0
WireConnection;70;1;71;0
WireConnection;65;0;18;0
WireConnection;65;1;70;0
WireConnection;72;0;46;0
WireConnection;72;1;21;0
WireConnection;68;0;57;0
WireConnection;56;0;48;1
WireConnection;56;1;48;2
WireConnection;56;2;48;3
WireConnection;29;0;27;0
WireConnection;29;1;28;0
WireConnection;62;0;56;0
WireConnection;57;0;62;0
WireConnection;57;1;65;0
ASEEND*/
//CHKSM=305A07B73928FB6BC7221C02E0B80A8BC0232C7A