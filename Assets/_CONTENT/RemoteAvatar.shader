// Made with Amplify Shader Editor v1.9.6.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Banter/RemoteAvatar"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_MainTex("MainTex", 2D) = "white" {}
		_DisolveGuide2("Disolve Guide2", 2D) = "white" {}
		_BurnRamp("Burn Ramp", 2D) = "white" {}
		[PerRendererData]_RimCol("RimCol", Color) = (1,1,1,0)
		[PerRendererData]_RimPower("RimPower", Range( 0 , 1)) = 0
		_DissolveAmount("Dissolve Amount", Range( 0 , 1)) = 0
		_BubbleDiameter("BubbleDiameter", Float) = 1
		_TransitionLength("TransitionLength", Float) = 0.5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			half3 worldNormal;
			float eyeDepth;
		};

		uniform sampler2D _MainTex;
		uniform half4 _MainTex_ST;
		uniform half _RimPower;
		uniform half4 _RimCol;
		uniform float _DissolveAmount;
		uniform half _TransitionLength;
		uniform half _BubbleDiameter;
		uniform int SafetyDance;
		uniform sampler2D _DisolveGuide2;
		uniform half4 _DisolveGuide2_ST;
		uniform sampler2D _BurnRamp;
		uniform float _Cutoff = 0.5;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			o.eyeDepth = -UnityObjectToViewPos( v.vertex.xyz ).z;
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			o.Albedo = tex2D( _MainTex, uv_MainTex ).rgb;
			float3 ase_worldPos = i.worldPos;
			half3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			half3 ase_worldNormal = i.worldNormal;
			half fresnelNdotV230 = dot( ase_worldNormal, ase_worldViewDir );
			half fresnelNode230 = ( 0.0 + _RimPower * pow( max( 1.0 - fresnelNdotV230 , 0.0001 ), 5.0 ) );
			half clampResult233 = clamp( fresnelNode230 , 0.0 , 1.0 );
			half cameraDepthFade208 = (( i.eyeDepth -_ProjectionParams.y - _BubbleDiameter ) / _TransitionLength);
			half clampResult215 = clamp( ( 1.0 - cameraDepthFade208 ) , 0.0 , 1.0 );
			half lerpResult217 = lerp( 0.0 , clampResult215 , (float)SafetyDance);
			float3 ase_objectPosition = UNITY_MATRIX_M._m03_m13_m23;
			float2 uv_DisolveGuide2 = i.uv_texcoord * _DisolveGuide2_ST.xy + _DisolveGuide2_ST.zw;
			half temp_output_225_0 = ( (-0.6 + (( _DissolveAmount + lerpResult217 ) - 1.0) * (0.6 - -0.6) / (0.0 - 1.0)) + ( ( 1.0 - saturate( ( ( ase_worldPos - ase_objectPosition ).y - ( 1.0 - ( _DissolveAmount * 2.0 ) ) ) ) ) * ( 1.0 - tex2D( _DisolveGuide2, uv_DisolveGuide2 ).r ) ) );
			half clampResult227 = clamp( (-5.0 + (temp_output_225_0 - 0.0) * (5.0 - -5.0) / (1.0 - 0.0)) , 0.0 , 1.0 );
			half temp_output_229_0 = ( 1.0 - clampResult227 );
			half2 appendResult231 = (half2(temp_output_229_0 , 0.0));
			o.Emission = ( ( clampResult233 * _RimCol ) + ( temp_output_229_0 * tex2D( _BurnRamp, appendResult231 ) ) ).rgb;
			o.Gloss = 0.0;
			o.Alpha = 1;
			half clampResult238 = clamp( temp_output_225_0 , 0.0 , 1.0 );
			clip( clampResult238 - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma only_renderers d3d11 glcore gles gles3 
		#pragma surface surf Lambert keepalpha fullforwardshadows vertex:vertexDataFunc 

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
				float3 customPack1 : TEXCOORD1;
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
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.customPack1.z = customInputData.eyeDepth;
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
				surfIN.eyeDepth = IN.customPack1.z;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
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
Version=19603
Node;AmplifyShaderEditor.RangedFloatNode;203;-2960,336;Float;False;Property;_DissolveAmount;Dissolve Amount;6;0;Create;True;0;0;0;True;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;204;-2400,432;Inherit;False;Property;_TransitionLength;TransitionLength;8;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;205;-2384,512;Inherit;False;Property;_BubbleDiameter;BubbleDiameter;7;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;206;-2320,672;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ObjectPositionNode;207;-2304,816;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CameraDepthFade;208;-2128,432;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;0.5;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;209;-2016,704;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;210;-1968,864;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;211;-1840,416;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;212;-1760,848;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;213;-1776,688;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.IntNode;214;-1664,592;Inherit;False;Global;SafetyDance;SafetyDance;8;0;Create;True;0;0;0;False;0;False;1;0;False;0;1;INT;0
Node;AmplifyShaderEditor.ClampOpNode;215;-1632,416;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;216;-1616,720;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;217;-1328,432;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;218;-1408,720;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;219;-1552,960;Inherit;True;Property;_DisolveGuide2;Disolve Guide2;2;0;Create;True;0;0;0;False;0;False;-1;None;1a876be4ca47d5341b674ae6ba5cfabe;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleAddOpNode;220;-1136,352;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;221;-1232,688;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;222;-1168,1008;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;223;-944,352;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;-0.6;False;4;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;224;-944,656;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;225;-672,464;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;226;-448,256;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-5;False;4;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;227;-208,240;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;228;208,-128;Inherit;False;Property;_RimPower;RimPower;5;1;[PerRendererData];Create;True;0;0;0;True;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;229;16,240;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;230;208,-48;Inherit;True;Standard;WorldNormal;ViewDir;False;True;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;231;240,336;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;232;560,-128;Inherit;False;Property;_RimCol;RimCol;4;1;[PerRendererData];Create;True;0;0;0;True;0;False;1,1,1,0;1,1,1,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ClampOpNode;233;608,112;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;234;464,304;Inherit;True;Property;_BurnRamp;Burn Ramp;3;0;Create;True;0;0;0;False;0;False;-1;None;a70d563a91813a64ab9f363c60f6a8b6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;235;848,144;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;236;816,240;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;175;1250.507,144.8126;Inherit;False;Constant;_Smoothness;Smoothness;8;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;78;1100.312,-171.7965;Inherit;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleAddOpNode;237;1136,240;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;238;848,464;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;138;1441.924,17.68553;Half;False;True;-1;2;ASEMaterialInspector;0;0;Lambert;Banter/RemoteAvatar;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Geometry;All;4;d3d11;glcore;gles;gles3;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;208;0;204;0
WireConnection;208;1;205;0
WireConnection;209;0;206;0
WireConnection;209;1;207;0
WireConnection;210;0;203;0
WireConnection;211;0;208;0
WireConnection;212;0;210;0
WireConnection;213;0;209;0
WireConnection;215;0;211;0
WireConnection;216;0;213;1
WireConnection;216;1;212;0
WireConnection;217;1;215;0
WireConnection;217;2;214;0
WireConnection;218;0;216;0
WireConnection;220;0;203;0
WireConnection;220;1;217;0
WireConnection;221;0;218;0
WireConnection;222;0;219;1
WireConnection;223;0;220;0
WireConnection;224;0;221;0
WireConnection;224;1;222;0
WireConnection;225;0;223;0
WireConnection;225;1;224;0
WireConnection;226;0;225;0
WireConnection;227;0;226;0
WireConnection;229;0;227;0
WireConnection;230;2;228;0
WireConnection;231;0;229;0
WireConnection;233;0;230;0
WireConnection;234;1;231;0
WireConnection;235;0;233;0
WireConnection;235;1;232;0
WireConnection;236;0;229;0
WireConnection;236;1;234;0
WireConnection;237;0;235;0
WireConnection;237;1;236;0
WireConnection;238;0;225;0
WireConnection;138;0;78;0
WireConnection;138;2;237;0
WireConnection;138;4;175;0
WireConnection;138;10;238;0
ASEEND*/
//CHKSM=EAE23E54536896F47912BCA1C116441E192D8E59