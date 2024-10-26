// Upgrade NOTE: upgraded instancing buffer 'Earth' to new syntax.

// Made with Amplify Shader Editor v1.9.4
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Earth"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_Cloudhight("Cloudhight", Float) = 4
		_Lights("Lights", 2D) = "white" {}
		[HDR]_LightCOL("LightCOL", Color) = (1,0.8593202,0,0)
		_Clouds("Clouds", 2D) = "white" {}
		_Hight("Hight", 2D) = "white" {}
		_Atmo_Color("Atmo_Color", Color) = (0,0.7530303,1,0)
		_Water_Tex("Water_Tex", 2D) = "white" {}
		_Clouns_Contrast("Clouns_Contrast", Range( 0.6 , 10)) = 0.8
		_MainNormal("MainNormal", 2D) = "bump" {}
		_CloudParallax("CloudParallax", Range( -0.1 , 0.1)) = 0
		_Water_Speed("Water_Speed", Range( 0 , 0.1)) = 0.01
		_Shadow("Shadow", Float) = -1
		_lightMin("lightMin", Float) = -0.1
		_Atmosphere("Atmosphere", Float) = 2
		_ReflectionMap("ReflectionMap", CUBE) = "white" {}
		_ReflectionDestortion("ReflectionDestortion", Range( 0 , 1)) = 0
		_Water_Tiling("Water_Tiling", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
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
			float3 viewDir;
			INTERNAL_DATA
			float3 worldNormal;
			float3 worldPos;
			float3 worldRefl;
		};

		uniform sampler2D _MainTex;
		uniform sampler2D _Hight;
		uniform samplerCUBE _ReflectionMap;
		uniform sampler2D _MainNormal;
		uniform float _Water_Speed;
		uniform float _Water_Tiling;
		uniform float _ReflectionDestortion;
		uniform sampler2D _Water_Tex;
		uniform sampler2D _Clouds;
		uniform float _Cloudhight;
		uniform float _CloudParallax;
		uniform sampler2D _Lights;
		uniform float4 _LightCOL;
		uniform float _lightMin;
		uniform float _Shadow;
		uniform float _Atmosphere;
		uniform float4 _Atmo_Color;

		UNITY_INSTANCING_BUFFER_START(Earth)
			UNITY_DEFINE_INSTANCED_PROP(float4, _Hight_ST)
#define _Hight_ST_arr Earth
			UNITY_DEFINE_INSTANCED_PROP(float4, _Water_Tex_ST)
#define _Water_Tex_ST_arr Earth
			UNITY_DEFINE_INSTANCED_PROP(float4, _Clouds_ST)
#define _Clouds_ST_arr Earth
			UNITY_DEFINE_INSTANCED_PROP(float, _Clouns_Contrast)
#define _Clouns_Contrast_arr Earth
		UNITY_INSTANCING_BUFFER_END(Earth)


inline float2 POM( sampler2D heightMap, float2 uvs, float2 dx, float2 dy, float3 normalWorld, float3 viewWorld, float3 viewDirTan, int minSamples, int maxSamples, int sidewallSteps, float parallax, float refPlane, float2 tilling, float2 curv, int index )
{
	float3 result = 0;
	int stepIndex = 0;
	int numSteps = ( int )lerp( (float)maxSamples, (float)minSamples, saturate( dot( normalWorld, viewWorld ) ) );
	float layerHeight = 1.0 / numSteps;
	float2 plane = parallax * ( viewDirTan.xy / viewDirTan.z );
	uvs.xy += refPlane * plane;
	float2 deltaTex = -plane * layerHeight;
	float2 prevTexOffset = 0;
	float prevRayZ = 1.0f;
	float prevHeight = 0.0f;
	float2 currTexOffset = deltaTex;
	float currRayZ = 1.0f - layerHeight;
	float currHeight = 0.0f;
	float intersection = 0;
	float2 finalTexOffset = 0;
	while ( stepIndex < numSteps + 1 )
	{
	 	currHeight = tex2Dgrad( heightMap, uvs + currTexOffset, dx, dy ).r;
	 	if ( currHeight > currRayZ )
	 	{
	 	 	stepIndex = numSteps + 1;
	 	}
	 	else
	 	{
	 	 	stepIndex++;
	 	 	prevTexOffset = currTexOffset;
	 	 	prevRayZ = currRayZ;
	 	 	prevHeight = currHeight;
	 	 	currTexOffset += deltaTex;
	 	 	currRayZ -= layerHeight;
	 	}
	}
	int sectionSteps = sidewallSteps;
	int sectionIndex = 0;
	float newZ = 0;
	float newHeight = 0;
	while ( sectionIndex < sectionSteps )
	{
	 	intersection = ( prevHeight - prevRayZ ) / ( prevHeight - currHeight + currRayZ - prevRayZ );
	 	finalTexOffset = prevTexOffset + intersection * deltaTex;
	 	newZ = prevRayZ - intersection * layerHeight;
	 	newHeight = tex2Dgrad( heightMap, uvs + finalTexOffset, dx, dy ).r;
	 	if ( newHeight > newZ )
	 	{
	 	 	currTexOffset = finalTexOffset;
	 	 	currHeight = newHeight;
	 	 	currRayZ = newZ;
	 	 	deltaTex = intersection * deltaTex;
	 	 	layerHeight = intersection * layerHeight;
	 	}
	 	else
	 	{
	 	 	prevTexOffset = finalTexOffset;
	 	 	prevHeight = newHeight;
	 	 	prevRayZ = newZ;
	 	 	deltaTex = ( 1 - intersection ) * deltaTex;
	 	 	layerHeight = ( 1 - intersection ) * layerHeight;
	 	}
	 	sectionIndex++;
	}
	return uvs.xy + finalTexOffset;
}


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		float3 RGBToHSV(float3 c)
		{
			float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
			float4 p = lerp( float4( c.bg, K.wz ), float4( c.gb, K.xy ), step( c.b, c.g ) );
			float4 q = lerp( float4( p.xyw, c.r ), float4( c.r, p.yzx ), step( p.x, c.r ) );
			float d = q.x - min( q.w, q.y );
			float e = 1.0e-10;
			return float3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Normal = float3(0,0,1);
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float4 _Hight_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_Hight_ST_arr, _Hight_ST);
			float2 OffsetPOM32 = POM( _Hight, i.uv_texcoord, ddx(i.uv_texcoord), ddy(i.uv_texcoord), ase_worldNormal, ase_worldViewDir, i.viewDir, 10, 10, 2, 0.01, 1, _Hight_ST_Instance.xy, float2(0,0), 0 );
			float4 tex2DNode1 = tex2D( _MainTex, OffsetPOM32 );
			float2 temp_cast_0 = (_Water_Speed).xx;
			float2 temp_cast_1 = (_Water_Tiling).xx;
			float2 uv_TexCoord53 = i.uv_texcoord * temp_cast_1;
			float2 panner42 = ( 1.0 * _Time.y * temp_cast_0 + uv_TexCoord53);
			float2 temp_cast_2 = (-_Water_Speed).xx;
			float2 panner44 = ( 1.0 * _Time.y * temp_cast_2 + uv_TexCoord53);
			float3 temp_output_92_0 = ( BlendNormals( UnpackNormal( tex2D( _MainNormal, panner42 ) ) , tex2D( _MainNormal, panner44 ).rgb ) * _ReflectionDestortion );
			float3 decodeLightMap77 = DecodeLightmap(texCUBE( _ReflectionMap, normalize( WorldReflectionVector( i , temp_output_92_0 ) ) ));
			float4 _Water_Tex_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_Water_Tex_ST_arr, _Water_Tex_ST);
			float2 uv_Water_Tex = i.uv_texcoord * _Water_Tex_ST_Instance.xy + _Water_Tex_ST_Instance.zw;
			float4 tex2DNode54 = tex2D( _Water_Tex, uv_Water_Tex );
			float4 lerpResult87 = lerp( tex2DNode1 , float4( decodeLightMap77 , 0.0 ) , tex2DNode54.r);
			float2 panner96 = ( 1.0 * _Time.y * float2( 0.00075,0 ) + i.uv_texcoord);
			float4 _Clouds_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_Clouds_ST_arr, _Clouds_ST);
			float2 uv_Clouds = i.uv_texcoord * _Clouds_ST_Instance.xy + _Clouds_ST_Instance.zw;
			float2 Offset143 = ( ( ( tex2D( _Clouds, uv_Clouds ).r * _Cloudhight ) - 1 ) * i.viewDir.xy * _CloudParallax ) + panner96;
			float3 hsvTorgb28 = RGBToHSV( tex2D( _Clouds, Offset143 ).rgb );
			float _Clouns_Contrast_Instance = UNITY_ACCESS_INSTANCED_PROP(_Clouns_Contrast_arr, _Clouns_Contrast);
			float smoothstepResult30 = smoothstep( 0.0 , _Clouns_Contrast_Instance , hsvTorgb28.z);
			float3 hsvTorgb29 = HSVToRGB( float3(hsvTorgb28.x,hsvTorgb28.y,smoothstepResult30) );
			float smoothstepResult72 = smoothstep( _lightMin , -_Shadow , ase_worldPos.x);
			float smoothstepResult20 = smoothstep( _Shadow , 0.0 , ase_worldPos.x);
			float4 lerpResult19 = lerp( ( ( tex2DNode1 + lerpResult87 ) + float4( hsvTorgb29 , 0.0 ) ) , ( ( tex2D( _Lights, OffsetPOM32 ).r * _LightCOL ) * smoothstepResult72 ) , ( smoothstepResult20 - 0.01 ));
			float fresnelNdotV3 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode3 = ( 0.0 + _Atmosphere * pow( 1.0 - fresnelNdotV3, 10.0 ) );
			o.Emission = ( lerpResult19 + ( fresnelNode3 * _Atmo_Color ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows 

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
				float2 customPack1 : TEXCOORD1;
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.worldRefl = -worldViewDir;
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
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
Version=19400
Node;AmplifyShaderEditor.RangedFloatNode;43;-963.9893,1368.545;Inherit;False;Property;_Water_Speed;Water_Speed;12;0;Create;True;0;0;0;False;0;False;0.01;0.0277;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-1125.82,1150.856;Inherit;False;Property;_Water_Tiling;Water_Tiling;19;0;Create;True;0;0;0;False;0;False;1;17.78;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;53;-942.1541,1060.06;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NegateNode;52;-651.5957,1444.396;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;42;-425.7593,1207.161;Inherit;False;3;0;FLOAT2;1,0;False;2;FLOAT2;0.1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;44;-423.7593,1374.161;Inherit;False;3;0;FLOAT2;0,1;False;2;FLOAT2;-0.1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;46;-221.7593,1301.161;Inherit;True;Property;_TextureSample1;Texture Sample 0;10;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;47;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;47;-220.7593,1071.161;Inherit;True;Property;_MainNormal;MainNormal;10;0;Create;True;0;0;0;False;0;False;-1;994e51c46f307ae4d9386e5c8022a40b;994e51c46f307ae4d9386e5c8022a40b;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;33;-3200.469,-37.43988;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;145;-1651.289,116.0533;Inherit;True;Property;_Clouds1;Clouds;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;24;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;118;-2947.149,213.9082;Float;False;Property;_Cloudhight;Cloudhight;1;0;Create;True;0;0;0;False;0;False;4;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;45;95.24072,1203.161;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;93;108.1026,1361.036;Inherit;False;Property;_ReflectionDestortion;ReflectionDestortion;17;0;Create;True;0;0;0;False;0;False;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;121;-2962.732,278.1607;Float;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;144;-2414.834,-0.8155823;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;120;-3048.437,139.646;Float;False;Property;_CloudParallax;CloudParallax;11;0;Create;True;0;0;0;False;0;False;0;0;-0.1;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;384.8713,1220.766;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PannerNode;96;-2965.906,20.38889;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.00075,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ParallaxMappingNode;143;-1930.218,6.975563;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldReflectionVector;75;644.9045,1138.208;Inherit;False;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TexturePropertyNode;34;-1577.618,-438.1767;Inherit;True;Property;_Hight;Hight;5;0;Create;True;0;0;0;False;0;False;None;b7f1e8511cd0a8d40b867f076aa5df3f;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;24;-1690.402,448.2373;Inherit;True;Property;_Clouds;Clouds;4;0;Create;True;0;0;0;False;0;False;-1;None;7de406c534a96b64f99aa86913b1d480;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;76;860.1648,866.6006;Inherit;True;Property;_ReflectionMap;ReflectionMap;16;0;Create;True;0;0;0;False;0;False;-1;None;877867c710cb46841acf721db3bdf5e5;True;0;False;white;LockedToCube;False;Object;-1;Auto;Cube;8;0;SAMPLERCUBE;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ParallaxOcclusionMappingNode;32;-1290.473,-446.6771;Inherit;False;0;10;False;;10;False;;2;0.01;1;False;1,1;False;0,0;11;0;FLOAT2;0,0;False;1;SAMPLER2D;;False;7;SAMPLERSTATE;;False;2;FLOAT;0.02;False;3;FLOAT3;0,0,0;False;8;INT;0;False;9;INT;0;False;10;INT;0;False;4;FLOAT;0;False;5;FLOAT2;0,0;False;6;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RGBToHSVNode;28;-1132.735,-108.7646;Inherit;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;66;-591.9108,628.8469;Inherit;False;Property;_Shadow;Shadow;13;0;Create;True;0;0;0;False;0;False;-1;-1.65;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-1256.249,128.3698;Inherit;False;InstancedProperty;_Clouns_Contrast;Clouns_Contrast;9;0;Create;True;0;0;0;True;0;False;0.8;0.6;0.6;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-906.7377,-519.4243;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;0;False;0;False;-1;None;6be11459ca7625e4da38050567d64876;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DecodeLightmapHlpNode;77;887.368,733.446;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;54;712.9623,310.6273;Inherit;True;Property;_Water_Tex;Water_Tex;8;0;Create;True;0;0;0;False;0;False;-1;None;de9224ace0a0ddd4d95e3b1084c7d84c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;2;-617.4046,326.5714;Inherit;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SmoothstepOpNode;30;-955.6965,81.48555;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;17;-420.625,134.1186;Inherit;False;Property;_LightCOL;LightCOL;3;1;[HDR];Create;True;0;0;0;False;0;False;1,0.8593202,0,0;5.992157,1.34902,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NegateNode;74;-287.2038,435.1161;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-574.951,542.0914;Inherit;False;Property;_lightMin;lightMin;14;0;Create;True;0;0;0;False;0;False;-0.1;-0.95;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;87;1228.495,328.4949;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.1792453;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;14;-912,-336;Inherit;True;Property;_Lights;Lights;2;0;Create;True;0;0;0;False;0;False;-1;None;f77d4c948e0e6fc41bb1dcac309224ec;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.HSVToRGBNode;29;-815.6513,-73.09271;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;58;-587.4464,-305.2257;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-95.62493,6.518927;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;20;-286.1546,558.9362;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;72;-113.7098,229.4885;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;-0.1;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;67;121.8544,282.4185;Inherit;False;Property;_Atmosphere;Atmosphere;15;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;25;-468.1078,-233.9511;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;3;359.3646,225.5723;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;2;False;3;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;23;-110.9737,370.5261;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;58.09548,12.58474;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;10;129.346,362.1628;Inherit;False;Property;_Atmo_Color;Atmo_Color;7;0;Create;True;0;0;0;False;0;False;0,0.7530303,1,0;0.7028302,0.9265816,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;19;276.6664,-51.3017;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;591.0803,220.42;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;173;-3408,144;Inherit;False;Property;_RotationSpeed;RotationSpeed;21;0;Create;True;0;0;0;False;0;False;0.00075;5E-05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;172;-3200,96;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldPosInputsNode;168;-1231.904,347.9595;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;169;-1212.904,487.9598;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;170;-1014.138,409.6431;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CameraDepthFade;156;-1746.805,1013.896;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;10;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;158;-1486.805,994.8961;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;166;-1297.016,923.5206;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;167;-1122.016,951.5206;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;157;-832.8049,941.896;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;10;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;162;-1423.388,797.8297;Inherit;False;Debug;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LogOpNode;159;-1391.503,1221.16;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;165;-1635.768,835.4573;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;161;-1512.894,1126.342;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;149;-365.1452,709.2949;Inherit;True;Property;_Water_Tex2;Water_Tex;8;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;54;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;148;24.01063,575.236;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;153;76.93091,778.7345;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;151;206.8524,845.8973;Inherit;False;Property;_waterParalaxxScale;waterParalaxxScale;20;0;Create;True;0;0;0;False;0;False;0;0.00105;-0.01;0.01;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;155;331.6088,1071.41;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;91;721.637,537.8933;Inherit;True;Property;_Water_Tex1;Water_Tex;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;1088.95,482.8227;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;146;1117.311,611.6359;Inherit;False;Property;_Float1;Float 1;18;0;Create;True;0;0;0;False;0;False;0.2;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;21;706.1862,58.70087;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;106;-1960.508,351.3015;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;107;-1985.543,366.1579;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;108;-1946.542,361.4579;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;109;-1980.508,381.3015;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;125;-2602.511,381.3015;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;126;-2626.146,406.5578;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;127;-2205.51,394.3015;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;95;-3003.697,426.6061;Inherit;True;Property;_Texture0;Texture 0;6;0;Create;True;0;0;0;False;0;False;None;7de406c534a96b64f99aa86913b1d480;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;128;-2569.645,418.7585;Inherit;True;Property;_TextureSample2;Texture Sample 1;9;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;FLOAT2;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;129;-2227.245,417.1579;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ParallaxMappingNode;130;-2175.648,421.7578;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;110;-1960.508,558.3015;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;111;-1984.042,579.7579;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;112;-1947.843,566.8578;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;113;-1978.508,598.3015;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;131;-2568.511,601.3015;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;132;-2607.245,621.2576;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;133;-2192.51,612.3014;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;134;-2558.992,637.3579;Inherit;True;Property;_TextureSample3;Texture Sample 2;9;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;FLOAT2;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;135;-2213.645,644.7577;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ParallaxMappingNode;136;-2171.395,639.9573;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;114;-1961.508,778.3014;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;115;-1976.042,807.6577;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;116;-1940.508,791.3014;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;117;-1963.842,823.4575;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;137;-2553.511,818.3014;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;138;-2597.346,841.3574;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;139;-2196.51,836.3014;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;140;-2209.544,863.1575;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;141;-2555.992,856.3575;Inherit;True;Property;_TextureSample4;Texture Sample 3;9;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;FLOAT2;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ParallaxMappingNode;142;-2168.995,860.3571;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;123;-2572.343,192.245;Inherit;True;Property;_TextureSample0;Texture Sample 0;14;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ParallaxMappingNode;124;-2196.222,159.437;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;152;98.95151,958.2026;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;154;659.4786,1009.927;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;150;-41.35343,429.9412;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ParallaxMappingNode;147;488.5107,423.3362;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;-0.002;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NormalizeNode;160;-1060.104,855.4939;Inherit;False;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;163;1339.204,651.6437;Inherit;False;162;Debug;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;171;-842.3468,434.1006;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1398.504,94.59286;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Earth;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;53;0;41;0
WireConnection;52;0;43;0
WireConnection;42;0;53;0
WireConnection;42;2;43;0
WireConnection;44;0;53;0
WireConnection;44;2;52;0
WireConnection;46;1;44;0
WireConnection;47;1;42;0
WireConnection;45;0;47;0
WireConnection;45;1;46;0
WireConnection;144;0;145;1
WireConnection;144;1;118;0
WireConnection;92;0;45;0
WireConnection;92;1;93;0
WireConnection;96;0;33;0
WireConnection;143;0;96;0
WireConnection;143;1;144;0
WireConnection;143;2;120;0
WireConnection;143;3;121;0
WireConnection;75;0;92;0
WireConnection;24;1;143;0
WireConnection;76;1;75;0
WireConnection;32;0;33;0
WireConnection;32;1;34;0
WireConnection;32;3;121;0
WireConnection;28;0;24;0
WireConnection;1;1;32;0
WireConnection;77;0;76;0
WireConnection;30;0;28;3
WireConnection;30;2;27;0
WireConnection;74;0;66;0
WireConnection;87;0;1;0
WireConnection;87;1;77;0
WireConnection;87;2;54;1
WireConnection;14;1;32;0
WireConnection;29;0;28;1
WireConnection;29;1;28;2
WireConnection;29;2;30;0
WireConnection;58;0;1;0
WireConnection;58;1;87;0
WireConnection;15;0;14;1
WireConnection;15;1;17;0
WireConnection;20;0;2;1
WireConnection;20;1;66;0
WireConnection;72;0;2;1
WireConnection;72;1;105;0
WireConnection;72;2;74;0
WireConnection;25;0;58;0
WireConnection;25;1;29;0
WireConnection;3;2;67;0
WireConnection;23;0;20;0
WireConnection;69;0;15;0
WireConnection;69;1;72;0
WireConnection;19;0;25;0
WireConnection;19;1;69;0
WireConnection;19;2;23;0
WireConnection;6;0;3;0
WireConnection;6;1;10;0
WireConnection;172;0;173;0
WireConnection;170;0;168;0
WireConnection;170;1;169;0
WireConnection;158;0;156;0
WireConnection;166;0;158;0
WireConnection;166;1;158;0
WireConnection;167;0;166;0
WireConnection;167;1;158;0
WireConnection;157;0;53;0
WireConnection;157;1;158;0
WireConnection;162;0;157;0
WireConnection;159;0;158;0
WireConnection;165;0;156;0
WireConnection;161;0;156;0
WireConnection;153;0;149;1
WireConnection;155;0;92;0
WireConnection;91;1;155;0
WireConnection;78;0;91;0
WireConnection;78;1;54;0
WireConnection;21;0;19;0
WireConnection;21;1;6;0
WireConnection;106;0;124;0
WireConnection;107;0;106;0
WireConnection;108;0;124;0
WireConnection;109;0;108;0
WireConnection;125;0;107;0
WireConnection;126;0;125;0
WireConnection;127;0;109;0
WireConnection;128;0;95;0
WireConnection;128;1;126;0
WireConnection;128;7;95;1
WireConnection;129;0;127;0
WireConnection;130;0;129;0
WireConnection;130;1;128;1
WireConnection;130;2;120;0
WireConnection;130;3;121;0
WireConnection;110;0;130;0
WireConnection;111;0;110;0
WireConnection;112;0;130;0
WireConnection;113;0;112;0
WireConnection;131;0;111;0
WireConnection;132;0;131;0
WireConnection;133;0;113;0
WireConnection;134;0;95;0
WireConnection;134;1;132;0
WireConnection;134;7;95;1
WireConnection;135;0;133;0
WireConnection;136;0;135;0
WireConnection;136;1;134;1
WireConnection;136;2;120;0
WireConnection;136;3;121;0
WireConnection;114;0;136;0
WireConnection;115;0;114;0
WireConnection;116;0;136;0
WireConnection;117;0;116;0
WireConnection;137;0;115;0
WireConnection;138;0;137;0
WireConnection;139;0;117;0
WireConnection;140;0;139;0
WireConnection;141;0;95;0
WireConnection;141;1;138;0
WireConnection;141;7;95;1
WireConnection;142;0;140;0
WireConnection;142;1;141;1
WireConnection;142;2;120;0
WireConnection;142;3;121;0
WireConnection;123;0;95;0
WireConnection;123;1;96;0
WireConnection;123;7;95;1
WireConnection;124;0;96;0
WireConnection;124;1;118;0
WireConnection;124;2;120;0
WireConnection;124;3;121;0
WireConnection;152;0;149;1
WireConnection;154;0;92;0
WireConnection;147;0;148;0
WireConnection;147;1;153;0
WireConnection;147;2;151;0
WireConnection;147;3;150;0
WireConnection;160;0;161;0
WireConnection;171;0;170;0
WireConnection;0;2;21;0
ASEEND*/
//CHKSM=27B7D772657A23A9D47EE1EFE06F9E36E447FC43