// Made with Amplify Shader Editor v1.9.4
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Banter/Water_trans"
{
	Properties
	{
		_MainNormal("MainNormal", 2D) = "white" {}
		_Gloss("Gloss", Range( 0 , 1)) = 0
		_Tiling("Tiling", Float) = 1
		_Speed("Speed", Range( 0 , 0.1)) = 0.01
		_ReflectionTex("ReflectionTex", CUBE) = "white" {}
		_Trans("Trans", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "AlphaTest+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
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
			float3 worldRefl;
			INTERNAL_DATA
			float2 uv_texcoord;
		};

		uniform samplerCUBE _ReflectionTex;
		uniform float _Gloss;
		uniform sampler2D _MainNormal;
		uniform float _Speed;
		uniform float _Tiling;
		uniform float _Trans;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Normal = float3(0,0,1);
			float2 temp_cast_0 = (_Speed).xx;
			float2 temp_cast_1 = (_Tiling).xx;
			float2 uv_TexCoord3 = i.uv_texcoord * temp_cast_1;
			float2 panner1 = ( 1.0 * _Time.y * temp_cast_0 + uv_TexCoord3);
			float2 temp_cast_3 = (-_Speed).xx;
			float cos19 = cos( 0.001 * _Time.y );
			float sin19 = sin( 0.001 * _Time.y );
			float2 rotator19 = mul( uv_TexCoord3 - float2( 0.5,0.5 ) , float2x2( cos19 , -sin19 , sin19 , cos19 )) + float2( 0.5,0.5 );
			float2 panner2 = ( 1.0 * _Time.y * temp_cast_3 + rotator19);
			float3 newWorldReflection35 = WorldReflectionVector( i , ( _Gloss * BlendNormals( tex2D( _MainNormal, panner1 ).rgb , UnpackNormal( tex2D( _MainNormal, panner2 ) ) ) ) );
			float4 texCUBENode33 = texCUBE( _ReflectionTex, newWorldReflection35 );
			float3 decodeLightMap71 = DecodeLightmap(texCUBENode33);
			o.Emission = decodeLightMap71;
			o.Alpha = _Trans;
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
			sampler3D _DitherMaskLOD;
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
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
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
Node;AmplifyShaderEditor.RangedFloatNode;20;-1004,-105.5;Inherit;False;Property;_Tiling;Tiling;3;0;Create;True;0;0;0;False;0;False;1;0.33;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1256,158.5;Inherit;False;Property;_Speed;Speed;4;0;Create;True;0;0;0;False;0;False;0.01;0.0083;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-834,-138.5;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RotatorNode;19;-789,21.5;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;0.001;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;34;-789.8364,176.7351;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;1;-505,-151.5;Inherit;False;3;0;FLOAT2;1,0;False;2;FLOAT2;0.1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;2;-503,15.5;Inherit;False;3;0;FLOAT2;0,1;False;2;FLOAT2;-0.1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;5;-301,-57.5;Inherit;True;Property;_TextureSample1;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Instance;4;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-300,-287.5;Inherit;True;Property;_MainNormal;MainNormal;1;0;Create;True;0;0;0;False;0;False;-1;None;4695cdfbbb7dbd54ba973026a03261e8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendNormalsNode;15;85,-152.5;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;11;63.6681,-208.9182;Inherit;False;Property;_Gloss;Gloss;2;0;Create;True;0;0;0;False;0;False;0;0.295;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;393.2137,-124.9489;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;1,1,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldReflectionVector;35;370.5621,18.05099;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;33;800.8118,34.33899;Inherit;True;Property;_ReflectionTex;ReflectionTex;5;0;Create;True;0;0;0;False;0;False;-1;None;a940d6cd3cca6b948b49f578fb559763;True;0;False;white;LockedToCube;False;Object;-1;Auto;Cube;8;0;SAMPLERCUBE;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;62;275.8159,519.2285;Float;False;Property;_IntersectIntensity;Intersect Intensity;6;0;Create;True;0;0;0;False;0;False;0.2;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;64;858.1096,498.5494;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;63;594.2001,496.6677;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;65;378.565,349.4584;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;69;1150.277,394.2146;Inherit;False;Property;_Trans;Trans;7;0;Create;True;0;0;0;False;0;False;0;0.954;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;70;1006.277,264.2146;Inherit;False;Property;_Float0;Float 0;8;0;Create;True;0;0;0;False;0;False;0;0.13;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DecodeLightmapHlpNode;71;1048.277,-99.7854;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;1321.397,-2.36319;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;72;659.2766,-93.7854;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;74;617.2766,89.2146;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1581.761,25.0692;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Banter/Water_trans;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;True;Transparent;;AlphaTest;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;3;0;20;0
WireConnection;19;0;3;0
WireConnection;34;0;21;0
WireConnection;1;0;3;0
WireConnection;1;2;21;0
WireConnection;2;0;19;0
WireConnection;2;2;34;0
WireConnection;5;1;2;0
WireConnection;4;1;1;0
WireConnection;15;0;4;0
WireConnection;15;1;5;0
WireConnection;53;0;11;0
WireConnection;53;1;15;0
WireConnection;35;0;53;0
WireConnection;33;1;35;0
WireConnection;64;0;63;0
WireConnection;63;1;65;0
WireConnection;63;0;62;0
WireConnection;71;0;33;0
WireConnection;61;0;33;0
WireConnection;61;1;70;0
WireConnection;72;0;35;1
WireConnection;74;0;72;0
WireConnection;74;1;35;2
WireConnection;0;2;71;0
WireConnection;0;9;69;0
ASEEND*/
//CHKSM=90CF087C2F5C8CC73BC1E4374BF518D9B6FAA681