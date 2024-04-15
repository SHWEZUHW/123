// Upgrade NOTE: upgraded instancing buffer 'Earth' to new syntax.

// Made with Amplify Shader Editor v1.9.3.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Earth"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_Lights("Lights", 2D) = "white" {}
		[HDR]_LightCOL("LightCOL", Color) = (1,0.8593202,0,0)
		_Clouds("Clouds", 2D) = "white" {}
		_Hight("Hight", 2D) = "white" {}
		_Atmo_Color("Atmo_Color", Color) = (0,0.7530303,1,0)
		_Clouns_Contrast("Clouns_Contrast", Range( 0.6 , 10)) = 0.8
		_Water_Tex("Water_Tex", 2D) = "white" {}
		_MainNormal("MainNormal", 2D) = "bump" {}
		_Water_Tiling("Water_Tiling", Float) = 1
		_Water_Speed("Water_Speed", Range( 0 , 0.1)) = 0.01
		_Shadow("Shadow", Float) = -1
		_Atmosphere("Atmosphere", Float) = 2
		_ReflectionMap("ReflectionMap", CUBE) = "white" {}
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
		uniform float4 _Atmo_Color;
		uniform sampler2D _Water_Tex;
		uniform sampler2D _Clouds;
		uniform sampler2D _Lights;
		uniform float4 _LightCOL;
		uniform float _Shadow;
		uniform float _Atmosphere;

		UNITY_INSTANCING_BUFFER_START(Earth)
			UNITY_DEFINE_INSTANCED_PROP(float4, _Hight_ST)
#define _Hight_ST_arr Earth
			UNITY_DEFINE_INSTANCED_PROP(float4, _Water_Tex_ST)
#define _Water_Tex_ST_arr Earth
			UNITY_DEFINE_INSTANCED_PROP(float4, _Lights_ST)
#define _Lights_ST_arr Earth
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
			float2 OffsetPOM32 = POM( _Hight, i.uv_texcoord, ddx(i.uv_texcoord), ddy(i.uv_texcoord), ase_worldNormal, ase_worldViewDir, i.viewDir, 16, 16, 2, 0.01, 1, _Hight_ST_Instance.xy, float2(0,0), 0 );
			float2 temp_cast_0 = (_Water_Speed).xx;
			float2 temp_cast_1 = (_Water_Tiling).xx;
			float2 uv_TexCoord53 = i.uv_texcoord * temp_cast_1;
			float2 panner42 = ( 1.0 * _Time.y * temp_cast_0 + uv_TexCoord53);
			float2 temp_cast_2 = (-_Water_Speed).xx;
			float2 panner44 = ( 1.0 * _Time.y * temp_cast_2 + uv_TexCoord53);
			float3 decodeLightMap77 = DecodeLightmap(texCUBE( _ReflectionMap, normalize( WorldReflectionVector( i , BlendNormals( UnpackNormal( tex2D( _MainNormal, panner42 ) ) , tex2D( _MainNormal, panner44 ).rgb ) ) ) ));
			float4 _Water_Tex_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_Water_Tex_ST_arr, _Water_Tex_ST);
			float2 uv_Water_Tex = i.uv_texcoord * _Water_Tex_ST_Instance.xy + _Water_Tex_ST_Instance.zw;
			float4 tex2DNode54 = tex2D( _Water_Tex, uv_Water_Tex );
			float4 lerpResult87 = lerp( ( ( float4( decodeLightMap77 , 0.0 ) * ( _Atmo_Color - float4( 0.4811321,0.4811321,0.4811321,0 ) ) ) * tex2DNode54 ) , tex2DNode54 , float4( 0.1792453,0.1792453,0.1792453,0 ));
			float2 Offset35 = ( ( -0.01 - 1 ) * i.viewDir.xy * -0.01 ) + i.uv_texcoord;
			float3 hsvTorgb28 = RGBToHSV( tex2D( _Clouds, Offset35 ).rgb );
			float _Clouns_Contrast_Instance = UNITY_ACCESS_INSTANCED_PROP(_Clouns_Contrast_arr, _Clouns_Contrast);
			float smoothstepResult30 = smoothstep( 0.0 , _Clouns_Contrast_Instance , hsvTorgb28.z);
			float3 hsvTorgb29 = HSVToRGB( float3(hsvTorgb28.x,hsvTorgb28.y,smoothstepResult30) );
			float4 _Lights_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_Lights_ST_arr, _Lights_ST);
			float2 uv_Lights = i.uv_texcoord * _Lights_ST_Instance.xy + _Lights_ST_Instance.zw;
			float smoothstepResult72 = smoothstep( -0.02 , -_Shadow , ase_worldPos.x);
			float smoothstepResult20 = smoothstep( _Shadow , 0.0 , ase_worldPos.x);
			float4 lerpResult19 = lerp( ( ( tex2D( _MainTex, OffsetPOM32 ) + lerpResult87 ) + float4( hsvTorgb29 , 0.0 ) ) , ( ( tex2D( _Lights, uv_Lights ) * _LightCOL ) * smoothstepResult72 ) , ( smoothstepResult20 - 0.01 ));
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
Version=19302
Node;AmplifyShaderEditor.RangedFloatNode;41;-924.7593,1253.161;Inherit;False;Property;_Water_Tiling;Water_Tiling;10;0;Create;True;0;0;0;False;0;False;1;0.24;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-963.9893,1368.545;Inherit;False;Property;_Water_Speed;Water_Speed;11;0;Create;True;0;0;0;False;0;False;0.01;0.0095;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;53;-754.7593,1220.161;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NegateNode;52;-651.5957,1444.396;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;42;-425.7593,1207.161;Inherit;False;3;0;FLOAT2;1,0;False;2;FLOAT2;0.1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;44;-423.7593,1374.161;Inherit;False;3;0;FLOAT2;0,1;False;2;FLOAT2;-0.1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;46;-221.7593,1301.161;Inherit;True;Property;_TextureSample1;Texture Sample 0;9;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;47;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;47;-220.7593,1071.161;Inherit;True;Property;_MainNormal;MainNormal;9;0;Create;True;0;0;0;False;0;False;-1;994e51c46f307ae4d9386e5c8022a40b;4695cdfbbb7dbd54ba973026a03261e8;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendNormalsNode;45;95.24072,1203.161;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldReflectionVector;75;477.6046,1008.608;Inherit;False;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;37;-2048.448,-319.1318;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;33;-1995.469,-636.4399;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;10;163.1775,506.8863;Inherit;False;Property;_Atmo_Color;Atmo_Color;5;0;Create;True;0;0;0;False;0;False;0,0.7530303,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;76;751.1648,962.6005;Inherit;True;Property;_ReflectionMap;ReflectionMap;14;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;LockedToCube;False;Object;-1;Auto;Cube;8;0;SAMPLER2D;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ParallaxMappingNode;35;-1687.959,-138.3096;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;-0.01;False;2;FLOAT;-0.01;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;90;573.6507,690.9623;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0.4811321,0.4811321,0.4811321,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DecodeLightmapHlpNode;77;1101.368,999.446;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;24;-1429.551,-118.515;Inherit;True;Property;_Clouds;Clouds;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;34;-1699.618,-487.1767;Inherit;True;Property;_Hight;Hight;4;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;1085.546,744.2919;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;54;665.0035,301.6433;Inherit;True;Property;_Water_Tex;Water_Tex;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RGBToHSVNode;28;-1132.735,-108.7646;Inherit;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;66;-546.9108,567.8469;Inherit;False;Property;_Shadow;Shadow;12;0;Create;True;0;0;0;False;0;False;-1;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ParallaxOcclusionMappingNode;32;-1243.715,-474.7315;Inherit;False;0;16;False;;16;False;;2;0.01;1;False;1,1;False;0,0;11;0;FLOAT2;0,0;False;1;SAMPLER2D;;False;7;SAMPLERSTATE;;False;2;FLOAT;0.02;False;3;FLOAT3;0,0,0;False;8;INT;0;False;9;INT;0;False;10;INT;0;False;4;FLOAT;0;False;5;FLOAT2;0,0;False;6;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;964.5818,418.3911;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-1407.581,133.2911;Inherit;False;InstancedProperty;_Clouns_Contrast;Clouns_Contrast;6;0;Create;True;0;0;0;True;0;False;0.8;0;0.6;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;2;-617.4046,326.5714;Inherit;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;1;-975.7377,-448.4243;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;30;-955.6965,81.48555;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;14;-495.1703,-58.87194;Inherit;True;Property;_Lights;Lights;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NegateNode;74;-287.2038,435.1161;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;17;-420.625,134.1186;Inherit;False;Property;_LightCOL;LightCOL;2;1;[HDR];Create;True;0;0;0;False;0;False;1,0.8593202,0,0;1,0.8593202,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;87;1228.495,328.4949;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0.1792453,0.1792453,0.1792453,0;False;1;COLOR;0
Node;AmplifyShaderEditor.HSVToRGBNode;29;-815.6513,-73.09271;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;58;-587.4464,-305.2257;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-95.62493,6.518927;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;67;108.3208,314.4074;Inherit;False;Property;_Atmosphere;Atmosphere;13;0;Create;True;0;0;0;False;0;False;2;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;72;-113.7098,229.4885;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;-0.02;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;20;-292.1546,587.9362;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;25;-468.1078,-233.9511;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;3;359.3646,225.5723;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;2;False;3;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;23;-110.9737,370.5261;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;58.09548,12.58474;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;515.0803,482.42;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;19;276.6664,-51.3017;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;21;706.1862,58.70087;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
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
WireConnection;75;0;45;0
WireConnection;76;1;75;0
WireConnection;35;0;33;0
WireConnection;35;3;37;0
WireConnection;90;0;10;0
WireConnection;77;0;76;0
WireConnection;24;1;35;0
WireConnection;82;0;77;0
WireConnection;82;1;90;0
WireConnection;28;0;24;0
WireConnection;32;0;33;0
WireConnection;32;1;34;0
WireConnection;32;3;37;0
WireConnection;78;0;82;0
WireConnection;78;1;54;0
WireConnection;1;1;32;0
WireConnection;30;0;28;3
WireConnection;30;2;27;0
WireConnection;74;0;66;0
WireConnection;87;0;78;0
WireConnection;87;1;54;0
WireConnection;29;0;28;1
WireConnection;29;1;28;2
WireConnection;29;2;30;0
WireConnection;58;0;1;0
WireConnection;58;1;87;0
WireConnection;15;0;14;0
WireConnection;15;1;17;0
WireConnection;72;0;2;1
WireConnection;72;2;74;0
WireConnection;20;0;2;1
WireConnection;20;1;66;0
WireConnection;25;0;58;0
WireConnection;25;1;29;0
WireConnection;3;2;67;0
WireConnection;23;0;20;0
WireConnection;69;0;15;0
WireConnection;69;1;72;0
WireConnection;6;0;3;0
WireConnection;6;1;10;0
WireConnection;19;0;25;0
WireConnection;19;1;69;0
WireConnection;19;2;23;0
WireConnection;21;0;19;0
WireConnection;21;1;6;0
WireConnection;0;2;21;0
ASEEND*/
//CHKSM=327C7E19FB0826845557D78130D11644FF70C5F2