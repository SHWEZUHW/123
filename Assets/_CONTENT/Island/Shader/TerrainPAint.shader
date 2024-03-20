// Upgrade NOTE: replaced tex2D unity_Lightmap with UNITY_SAMPLE_TEX2D
// Upgrade NOTE: replaced tex2D unity_LightmapInd with UNITY_SAMPLE_TEX2D_SAMPLER
// Upgrade NOTE: upgraded instancing buffer 'BanterTerrainPaint' to new syntax.

// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Banter/TerrainPaint"
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
		_PaintMask("PaintMask", 2D) = "white" {}
		_Distance("Distance", Float) = 0
		_AffectorCount("Affector Count", Int) = 4
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
			float3 worldPos;
		};

		uniform int _AffectorCount;
		uniform sampler2D _Black;
		uniform sampler2D _Red;
		uniform sampler2D _Splat;
		uniform sampler2D _Green;
		uniform sampler2D _Blue;
		uniform sampler2D _Video;
		uniform sampler2D _PaintMask;
		uniform float4 _Affector;
		uniform half _Distance;

		UNITY_INSTANCING_BUFFER_START(BanterTerrainPaint)
			UNITY_DEFINE_INSTANCED_PROP(half4, _Black_ST)
#define _Black_ST_arr BanterTerrainPaint
			UNITY_DEFINE_INSTANCED_PROP(half4, _Red_ST)
#define _Red_ST_arr BanterTerrainPaint
			UNITY_DEFINE_INSTANCED_PROP(half4, _Splat_ST)
#define _Splat_ST_arr BanterTerrainPaint
			UNITY_DEFINE_INSTANCED_PROP(half4, _Green_ST)
#define _Green_ST_arr BanterTerrainPaint
			UNITY_DEFINE_INSTANCED_PROP(half4, _Blue_ST)
#define _Blue_ST_arr BanterTerrainPaint
			UNITY_DEFINE_INSTANCED_PROP(half4, _Video_ST)
#define _Video_ST_arr BanterTerrainPaint
			UNITY_DEFINE_INSTANCED_PROP(half4, _PaintMask_ST)
#define _PaintMask_ST_arr BanterTerrainPaint
			UNITY_DEFINE_INSTANCED_PROP(half, _terrainlight)
#define _terrainlight_arr BanterTerrainPaint
			UNITY_DEFINE_INSTANCED_PROP(half, _screenprojection)
#define _screenprojection_arr BanterTerrainPaint
		UNITY_INSTANCING_BUFFER_END(BanterTerrainPaint)


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


		half3 HSVToRGB( half3 c )
		{
			half4 K = half4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			half3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		half3 RGBToHSV(half3 c)
		{
			half4 K = half4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
			half4 p = lerp( half4( c.bg, K.wz ), half4( c.gb, K.xy ), step( c.b, c.g ) );
			half4 q = lerp( half4( p.xyw, c.r ), half4( c.r, p.yzx ), step( p.x, c.r ) );
			half d = q.x - min( q.w, q.y );
			half e = 1.0e-10;
			return half3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
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
			half _screenprojection_Instance = UNITY_ACCESS_INSTANCED_PROP(_screenprojection_arr, _screenprojection);
			half time70 = _Time.y;
			half2 voronoiSmoothId70 = 0;
			float2 coords70 = i.uv_texcoord * 2.0;
			float2 id70 = 0;
			float2 uv70 = 0;
			float voroi70 = voronoi70( coords70, time70, id70, uv70, 0, voronoiSmoothId70 );
			half4 clampResult68 = clamp( ( (0.5 + (( tex2DNode48.r + tex2DNode48.g + tex2DNode48.b ) - 0.0) * (-0.15 - 0.5) / (1.0 - 0.0)) * ( tex2DNode18 * voroi70 ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			half3 hsvTorgb79 = RGBToHSV( tex2DNode18.rgb );
			half temp_output_81_0 = ( hsvTorgb79.x + ( _Time.y * 0.08 ) );
			half3 hsvTorgb80 = HSVToRGB( half3(temp_output_81_0,( hsvTorgb79.y + 0.5 ),hsvTorgb79.z) );
			half4 _PaintMask_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_PaintMask_ST_arr, _PaintMask_ST);
			float2 uv1_PaintMask = i.uv2_texcoord2 * _PaintMask_ST_Instance.xy + _PaintMask_ST_Instance.zw;
			half4 tex2DNode73 = tex2D( _PaintMask, uv1_PaintMask );
			half4 lerpResult77 = lerp( ( ( ( lerpResult24 * ( tex2D( _Video, uv3_Video ) * _screenprojection_Instance ) ) * i.vertexColor ) + clampResult68 ) , half4( hsvTorgb80 , 0.0 ) , tex2DNode73.r);
			half smoothstepResult78 = smoothstep( 0.0 , 0.05 , tex2DNode73.r);
			half smoothstepResult93 = smoothstep( 0.05 , 0.06 , tex2DNode73.r);
			half3 hsvTorgb98 = HSVToRGB( half3(( 1.0 - temp_output_81_0 ),1.7,1.0) );
			half4 color148 = IsGammaSpace() ? half4(1,0.3443937,0,0) : half4(1,0.09717555,0,0);
			float3 ase_worldPos = i.worldPos;
			half temp_output_141_0 = ( length( ( half4( ase_worldPos , 0.0 ) - _Affector ) ) * _Distance );
			half4 lerpResult146 = lerp( float4( 0,0,0,0 ) , ( lerpResult24 * color148 ) , saturate( ( 1.0 - temp_output_141_0 ) ));
			o.Emission = ( saturate( ( lerpResult77 + half4( ( saturate( ( smoothstepResult78 - smoothstepResult93 ) ) * hsvTorgb98 ) , 0.0 ) ) ) + lerpResult146 ).rgb;
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
				surfIN.worldPos = worldPos;
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
Node;AmplifyShaderEditor.LerpOp;23;206.5271,-377.7694;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;22;206.3908,-543.6591;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;19;-456.6293,-600.601;Inherit;True;Property;_Red;Red;5;0;Create;True;0;0;0;False;0;False;-1;None;2115c7e1c47aeb04ebf73124ce80013c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;20;-479.6626,-338.8741;Inherit;True;Property;_Green;Green;6;0;Create;True;0;0;0;False;0;False;-1;None;87965f2573be6e8488ae108b18543ff8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;26;-478.0581,-112.7921;Inherit;True;Property;_Blue;Blue;7;0;Create;True;0;0;0;False;0;False;-1;None;da49e0cea73007c44b2b49ec8236eb66;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;27;398.1687,-896.7855;Inherit;True;Property;_Video;Video;8;0;Create;True;0;0;0;False;0;False;-1;None;daf2a63a9c1942047861dbc38a46f413;True;3;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;847.1752,120.9901;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;48;-920.5737,-1040.526;Inherit;True;Property;_Splat;Splat;0;0;Create;True;0;0;0;False;0;False;-1;None;42b70c781a9c0e047a4662320d476205;True;1;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;18;-184.8157,-837.7715;Inherit;True;Property;_Black;Black;1;0;Create;True;0;0;0;False;0;False;-1;None;38e077ea0da267f4b8ad9b4327ef347a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;1133.161,-158.9726;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;56;1186.134,-496.3282;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;62;1357.006,-471.0146;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.5;False;4;FLOAT;-0.15;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;1599.77,-386.7841;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;21;1097.405,131.3757;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;1381.646,-82.89948;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;37;2124.757,-375.2314;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;31;410.9495,-284.5104;Inherit;False;InstancedProperty;_screenprojection;screenprojection;9;0;Create;True;0;0;0;True;0;False;0.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;726.161,-358.2863;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;73;773.2618,398.8716;Inherit;True;Property;_PaintMask;PaintMask;10;0;Create;True;0;0;0;False;0;False;-1;None;e350a7062e8f6aa4e80c8c9209580e9d;True;1;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DecodeLightmapHlpNode;35;313.8135,528.9241;Inherit;True;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;34;-71.14127,446.933;Inherit;True;Sample Lightmap;2;;1;6976f0f966a01684ca0a6dde441141c2;6,209,0,195,0,196,0,238,0,191,0,249,0;2;71;FLOAT3;0,0,0;False;169;FLOAT3;0,0,0;False;2;COLOR;0;COLOR;178
Node;AmplifyShaderEditor.SimpleAddOpNode;81;31.37288,279.7338;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;-151.6274,285.7339;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.08;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;83;-425.3656,238.7686;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;94;1769.951,479.6521;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;78;1448.599,349.8131;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;93;1447.999,479.4023;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.05;False;2;FLOAT;0.06;False;1;FLOAT;0
Node;AmplifyShaderEditor.HSVToRGBNode;80;144.3729,51.73351;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RGBToHSVNode;79;-228.6277,34.73355;Inherit;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;84;13.60584,3.969881;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;100;1115.418,636.1198;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.HSVToRGBNode;98;1750.141,592.0474;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1.7;False;2;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;1363.912,-583.4716;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;71;924.912,-749.4716;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;70;1138.912,-743.4716;Inherit;False;0;0;1;0;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;2;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleAddOpNode;67;2050.27,-82.7832;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;38;1799.665,-237.1528;Inherit;False;InstancedProperty;_terrainlight;terrainlight;14;0;Create;True;0;0;0;True;0;False;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;68;1779.199,-27.11185;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;101;1977.007,352.8368;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2759.227,-310.3005;Half;False;True;-1;2;ASEMaterialInspector;0;0;Lambert;Banter/TerrainPaint;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleAddOpNode;142;2624.022,-95.26877;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;102;2468.982,-71.26002;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;24;576.0964,-101.4798;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;77;2182.93,-33.43167;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;95;2341.71,27.45664;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;96;2172.319,264.4046;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;156;2008.87,967.5505;Inherit;False;Property;_Angle;Angle;12;0;Create;True;0;0;0;False;0;False;0;0.29;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;155;2283.002,935.5729;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;163;1304.061,1248.246;Inherit;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexCoordVertexDataNode;164;1298.861,1409.447;Inherit;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;162;1626.461,1295.046;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GlobalArrayNode;157;1477.786,1052.682;Inherit;False;_Affectors;3;20;2;False;False;0;1;False;Object;-1;4;0;INT;0;False;2;INT;0;False;1;INT;0;False;3;INT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.IntNode;160;1496.598,1159.011;Inherit;False;Property;_AffectorCount;Affector Count;13;0;Create;True;0;0;0;True;0;False;4;0;False;0;1;INT;0
Node;AmplifyShaderEditor.CustomExpressionNode;161;1779.598,1111.011;Float;False;float DistanceMaskMY@$$for (int w = 0@ w < _AffectorCount@ w++) {$if(w == 0){$DistanceMaskMY = distance(ParticleCenterCE, _Affectors[w])@$}else{$DistanceMaskMY = min( DistanceMaskMY, distance(ParticleCenterCE, _Affectors[w]) )@	$}$}$DistanceMaskMY = 1.0 - DistanceMaskMY@$return DistanceMaskMY@;1;Create;2;True;ParticleCenterCE;FLOAT4;0,0,0,0;In;;Float;False;True;AffectorsCE;FLOAT4;0,0,0,0;In;;Float;False;CE1;True;False;0;;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;111;1472.032,874.8391;Float;False;Global;_Affector;_Affector;3;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;130;1496.786,730.7145;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;131;1734.086,790.8639;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LengthOpNode;137;1900.837,789.9595;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;141;2079.209,801.3433;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;149;1911.39,882.3315;Inherit;False;Property;_Distance;Distance;11;0;Create;True;0;0;0;False;0;False;0;0.29;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;140;2373.326,781.8882;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;144;2515.199,782.4473;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;148;2257.386,414.7516;Inherit;False;Constant;_Color0;Color 0;16;0;Create;True;0;0;0;False;0;False;1,0.3443937,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;147;2468.386,200.7516;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;146;2640.061,123.9896;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
WireConnection;23;0;22;0
WireConnection;23;1;20;0
WireConnection;23;2;48;2
WireConnection;22;0;18;0
WireConnection;22;1;19;0
WireConnection;22;2;48;1
WireConnection;41;0;24;0
WireConnection;41;1;35;0
WireConnection;46;0;24;0
WireConnection;46;1;30;0
WireConnection;56;0;48;1
WireConnection;56;1;48;2
WireConnection;56;2;48;3
WireConnection;62;0;56;0
WireConnection;57;0;62;0
WireConnection;57;1;65;0
WireConnection;72;0;46;0
WireConnection;72;1;21;0
WireConnection;37;0;24;0
WireConnection;37;1;41;0
WireConnection;37;2;38;0
WireConnection;30;0;27;0
WireConnection;30;1;31;0
WireConnection;35;0;34;178
WireConnection;81;0;79;1
WireConnection;81;1;82;0
WireConnection;82;0;83;0
WireConnection;94;0;78;0
WireConnection;94;1;93;0
WireConnection;78;0;73;1
WireConnection;93;0;73;1
WireConnection;80;0;81;0
WireConnection;80;1;84;0
WireConnection;80;2;79;3
WireConnection;79;0;18;0
WireConnection;84;0;79;2
WireConnection;100;0;81;0
WireConnection;98;0;100;0
WireConnection;65;0;18;0
WireConnection;65;1;70;0
WireConnection;70;1;71;0
WireConnection;67;0;72;0
WireConnection;67;1;68;0
WireConnection;68;0;57;0
WireConnection;101;0;94;0
WireConnection;0;0;37;0
WireConnection;0;2;142;0
WireConnection;142;0;102;0
WireConnection;142;1;146;0
WireConnection;102;0;95;0
WireConnection;24;0;23;0
WireConnection;24;1;26;0
WireConnection;24;2;48;3
WireConnection;77;0;67;0
WireConnection;77;1;80;0
WireConnection;77;2;73;1
WireConnection;95;0;77;0
WireConnection;95;1;96;0
WireConnection;96;0;101;0
WireConnection;96;1;98;0
WireConnection;155;0;141;0
WireConnection;155;1;156;0
WireConnection;162;0;163;3
WireConnection;162;1;164;1
WireConnection;161;1;111;0
WireConnection;131;0;130;0
WireConnection;131;1;111;0
WireConnection;137;0;131;0
WireConnection;141;0;137;0
WireConnection;141;1;149;0
WireConnection;140;0;141;0
WireConnection;144;0;140;0
WireConnection;147;0;24;0
WireConnection;147;1;148;0
WireConnection;146;1;147;0
WireConnection;146;2;144;0
ASEEND*/
//CHKSM=55121BECCF38572F4035377D77900D997D3C9E39