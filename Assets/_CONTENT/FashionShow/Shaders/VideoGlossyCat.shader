// Made with Amplify Shader Editor v1.9.4
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Banter/FashionShow/VideoGlossyCat"
{
	Properties
	{
		_Rougness("Rougness", 2D) = "white" {}
		_Metallic("Metallic", Float) = 0
		_Roughness("Roughness", Float) = 0
		_Float1("Float 0", Float) = 0
		_Color("Color", Color) = (0,0,0,0)
		_Emission("Emission", 2D) = "white" {}
		_ParaScale("ParaScale", Float) = 0
		_ParaHight("ParaHight", Float) = 0
		_Emitt("Emitt", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 viewDir;
		};

		uniform float4 _Color;
		uniform sampler2D _Emission;
		uniform float _Float1;
		uniform float _ParaHight;
		uniform float _ParaScale;
		uniform float _Emitt;
		uniform float _Metallic;
		uniform sampler2D _Rougness;
		uniform float4 _Rougness_ST;
		uniform float _Roughness;


float2 voronoihash29( float2 p )
{
	
	p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
	return frac( sin( p ) *43758.5453);
}


float voronoi29( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
	 		float2 o = voronoihash29( n + g );
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
	return (F2 + F1) * 0.5;
}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Albedo = _Color.rgb;
			float mulTime30 = _Time.y * 0.5;
			float time29 = mulTime30;
			float2 voronoiSmoothId29 = 0;
			float2 coords29 = i.uv_texcoord * 2.0;
			float2 id29 = 0;
			float2 uv29 = 0;
			float voroi29 = voronoi29( coords29, time29, id29, uv29, 0, voronoiSmoothId29 );
			float2 temp_cast_1 = (voroi29).xx;
			float2 lerpResult31 = lerp( i.uv_texcoord , temp_cast_1 , _Float1);
			float2 Offset20 = ( ( _ParaHight - 1 ) * i.viewDir.xy * _ParaScale ) + lerpResult31;
			o.Emission = ( tex2D( _Emission, Offset20 ) * _Emitt ).rgb;
			o.Metallic = _Metallic;
			float2 uv_Rougness = i.uv_texcoord * _Rougness_ST.xy + _Rougness_ST.zw;
			o.Smoothness = ( tex2D( _Rougness, uv_Rougness ) * _Roughness ).r;
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
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
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
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = worldViewDir;
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
Node;AmplifyShaderEditor.TextureCoordinatesNode;24;-787.9643,-221.3924;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;30;-1225.544,-115.2231;Inherit;False;1;0;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-823.9025,315.1817;Inherit;False;Property;_Float1;Float 0;10;0;Create;True;0;0;0;False;0;False;0;0.22;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;29;-541.9023,-143.8182;Inherit;False;0;0;1;3;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;2;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RangedFloatNode;22;-537.5181,353.9979;Inherit;False;Property;_ParaScale;ParaScale;13;0;Create;True;0;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-462.5203,194.8364;Inherit;False;Property;_ParaHight;ParaHight;14;0;Create;True;0;0;0;False;0;False;0;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;31;-611.9027,87.1819;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;21;-442.7741,411.7802;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ParallaxMappingNode;20;-246.8353,146.9276;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;1;-243.8294,-166.9978;Inherit;True;Property;_Rougness;Rougness;0;0;Create;True;0;0;0;False;0;False;-1;None;7df057ffc4bf9f54492e3c240eb5025c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-184.8294,44.0022;Inherit;False;Property;_Roughness;Roughness;6;0;Create;True;0;0;0;False;0;False;0;0.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;23;0.4002173,120.1287;Inherit;True;Property;_Emission;Emission;12;0;Create;True;0;0;0;False;0;False;-1;None;ee87daf71cd3798419a79901465787fb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;28;265.8798,354.9246;Inherit;False;Property;_Emitt;Emitt;15;0;Create;True;0;0;0;False;0;False;0;0.04;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-188.8294,-236.9977;Inherit;False;Property;_Metallic;Metallic;5;0;Create;True;0;0;0;False;0;False;0;0.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;62.17061,-87.99783;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;19;205.5289,-307.4029;Inherit;False;Property;_Color;Color;11;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.226415,0.226415,0.226415,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;6;-1103.879,475.0682;Inherit;True;Property;_Video;Video;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldReflectionVector;8;-1561.879,777.068;Inherit;False;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-1175.879,712.0679;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;11;-1823.879,570.0679;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;16;-1457.754,143.1138;Inherit;False;2;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-1724.879,744.068;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-633.6705,570.748;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-915.6706,741.748;Inherit;False;Property;_EmittStrength;EmittStrength;8;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;387.2799,96.11563;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VoronoiNode;14;-1698.879,144.0681;Inherit;False;0;0;1;4;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;8.6;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleTimeNode;17;-1930.521,211.6632;Inherit;False;1;0;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;15;-1316.879,414.0682;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-1528.879,642.068;Inherit;False;Property;_Float0;Float 0;9;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-2078.777,-505.4337;Inherit;False;Property;_Tiling;Tiling;4;0;Create;True;0;0;0;False;0;False;1;0.24;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;34;-1579.779,-551.4337;Inherit;False;3;0;FLOAT2;1,0;False;2;FLOAT2;0.1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-2330.777,-241.4338;Inherit;False;Property;_Speed;Speed;7;0;Create;True;0;0;0;False;0;False;0.01;0.0095;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;36;-1577.779,-384.4339;Inherit;False;3;0;FLOAT2;0,1;False;2;FLOAT2;-0.1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BlendNormalsNode;37;-989.7786,-552.4337;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;38;-1375.779,-457.4339;Inherit;True;Property;_TextureSample1;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;39;-1374.779,-687.4337;Inherit;True;Property;_MainNormal;MainNormal;1;0;Create;True;0;0;0;False;0;False;-1;None;4695cdfbbb7dbd54ba973026a03261e8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RotatorNode;40;-1863.779,-378.4339;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;0.001;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-681.5646,-524.8826;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;1,1,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-1011.111,-608.8519;Inherit;False;Property;_Gloss;Gloss;2;0;Create;True;0;0;0;False;0;False;0;0.322;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;43;-1864.615,-223.1987;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;44;-1908.779,-538.4337;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldReflectionVector;45;-539.2162,-303.8829;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;9;-1892.879,348.0682;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;620.2408,-170.8297;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Banter/FashionShow/VideoGlossyCat;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;29;0;24;0
WireConnection;29;1;30;0
WireConnection;31;0;24;0
WireConnection;31;1;29;0
WireConnection;31;2;32;0
WireConnection;20;0;31;0
WireConnection;20;1;26;0
WireConnection;20;2;22;0
WireConnection;20;3;21;0
WireConnection;23;1;20;0
WireConnection;3;0;1;0
WireConnection;3;1;4;0
WireConnection;6;1;15;0
WireConnection;13;0;9;0
WireConnection;13;1;10;0
WireConnection;11;0;9;0
WireConnection;10;0;14;0
WireConnection;10;1;9;0
WireConnection;7;0;6;0
WireConnection;7;1;5;0
WireConnection;27;0;23;0
WireConnection;27;1;28;0
WireConnection;14;0;9;0
WireConnection;14;1;17;0
WireConnection;15;0;16;0
WireConnection;15;1;14;0
WireConnection;15;2;12;0
WireConnection;34;0;44;0
WireConnection;34;2;35;0
WireConnection;36;0;40;0
WireConnection;36;2;43;0
WireConnection;37;0;39;0
WireConnection;37;1;38;0
WireConnection;38;1;36;0
WireConnection;39;1;34;0
WireConnection;40;0;44;0
WireConnection;41;0;42;0
WireConnection;41;1;37;0
WireConnection;43;0;35;0
WireConnection;44;0;33;0
WireConnection;45;0;24;0
WireConnection;0;0;19;0
WireConnection;0;2;27;0
WireConnection;0;3;2;0
WireConnection;0;4;3;0
ASEEND*/
//CHKSM=F05A1CF9CEC6BA1CD186C183DFF131929AA94171