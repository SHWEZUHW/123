// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Banter/RemoteAvatar"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_MainTex("MainTex", 2D) = "white" {}
		_DisolveGuide("Disolve Guide", 2D) = "white" {}
		_DisolveGuide2("Disolve Guide2", 2D) = "white" {}
		_BurnRamp("Burn Ramp", 2D) = "white" {}
		[PerRendererData]_RimCol("RimCol", Color) = (1,1,1,0)
		[PerRendererData]_RimPower("RimPower", Range( 0 , 1)) = 0
		_DissolveAmount("Dissolve Amount", Range( 0 , 1)) = 0
		_TransitionLength("TransitionLength", Float) = 0.5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
		_SafetyDance("SafetyDance", Int) = 1
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
			half3 worldNormal;
			float3 worldPos;
			float eyeDepth;
		};

		uniform float _DissolveAmount;
		uniform half _TransitionLength;
		uniform half _BubbleDiameter;
		uniform int _SafetyDance;
		uniform int _SafetyOn;
		uniform sampler2D _DisolveGuide;
		uniform half4 _DisolveGuide_ST;
		uniform sampler2D _DisolveGuide2;
		uniform half4 _DisolveGuide2_ST;
		uniform sampler2D _MainTex;
		uniform half4 _MainTex_ST;
		uniform half _RimPower;
		uniform half4 _RimCol;
		uniform sampler2D _BurnRamp;
		uniform float _Cutoff = 0.5;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			half cameraDepthFade176 = (( -UnityObjectToViewPos( v.vertex.xyz ).z -_ProjectionParams.y - _BubbleDiameter ) / _TransitionLength);
			half clampResult196 = clamp( ( 1.0 - cameraDepthFade176 ) , 0.0 , 1.0 );
			half lerpResult195 = lerp( 0.0 , clampResult196 , (float)_SafetyDance * (float)_SafetyOn);
			half temp_output_197_0 = ( _DissolveAmount + lerpResult195 );
			half3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			half3 ase_vertexNormal = v.normal.xyz;
			float2 uv_DisolveGuide = v.texcoord * _DisolveGuide_ST.xy + _DisolveGuide_ST.zw;
			float2 uv_DisolveGuide2 = v.texcoord * _DisolveGuide2_ST.xy + _DisolveGuide2_ST.zw;
			half temp_output_73_0 = ( (-0.6 + (temp_output_197_0 - 1.0) * (0.6 - -0.6) / (0.0 - 1.0)) + ( tex2Dlod( _DisolveGuide, float4( uv_DisolveGuide, 0, 1.0) ).r * ( 1.0 - tex2Dlod( _DisolveGuide2, float4( uv_DisolveGuide2, 0, 1.0) ).r ) ) );
			half3 lerpResult200 = lerp( ( temp_output_197_0 * ( ase_worldNormal.y * ( ase_vertexNormal * temp_output_73_0 ) ) ) , float3( 0,0,0 ) , (float)_SafetyDance* (float)_SafetyOn);
			v.vertex.xyz += lerpResult200;
			v.vertex.w = 1;
			o.eyeDepth = -UnityObjectToViewPos( v.vertex.xyz ).z;
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			o.Albedo = tex2D( _MainTex, uv_MainTex ).rgb;
			half3 ase_worldNormal = i.worldNormal;
			float3 ase_worldPos = i.worldPos;
			half3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			half fresnelNdotV157 = dot( ase_worldNormal, ase_worldViewDir );
			half fresnelNode157 = ( 0.0 + _RimPower * pow( max( 1.0 - fresnelNdotV157 , 0.0001 ), 5.0 ) );
			half clampResult172 = clamp( ( ase_worldNormal.y * fresnelNode157 ) , 0.0 , 1.0 );
			half cameraDepthFade176 = (( i.eyeDepth -_ProjectionParams.y - _BubbleDiameter ) / _TransitionLength);
			half clampResult196 = clamp( ( 1.0 - cameraDepthFade176 ) , 0.0 , 1.0 );
			half lerpResult195 = lerp( 0.0 , clampResult196 , (float)_SafetyDance* (float)_SafetyOn);
			half temp_output_197_0 = ( _DissolveAmount + lerpResult195 );
			float2 uv_DisolveGuide = i.uv_texcoord * _DisolveGuide_ST.xy + _DisolveGuide_ST.zw;
			float2 uv_DisolveGuide2 = i.uv_texcoord * _DisolveGuide2_ST.xy + _DisolveGuide2_ST.zw;
			half temp_output_73_0 = ( (-0.6 + (temp_output_197_0 - 1.0) * (0.6 - -0.6) / (0.0 - 1.0)) + ( tex2D( _DisolveGuide, uv_DisolveGuide ).r * ( 1.0 - tex2D( _DisolveGuide2, uv_DisolveGuide2 ).r ) ) );
			half clampResult113 = clamp( (-5.0 + (temp_output_73_0 - 0.0) * (5.0 - -5.0) / (1.0 - 0.0)) , 0.0 , 1.0 );
			half temp_output_130_0 = ( 1.0 - clampResult113 );
			half2 appendResult115 = (half2(temp_output_130_0 , 0.0));
			o.Emission = ( ( clampResult172 * _RimCol ) + ( temp_output_130_0 * tex2D( _BurnRamp, appendResult115 ) ) ).rgb;
			o.Gloss = 0.0;
			o.Alpha = 1;
			half clampResult144 = clamp( temp_output_73_0 , 0.0 , 1.0 );
			clip( clampResult144 - _Cutoff );
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
Version=19202
Node;AmplifyShaderEditor.CommentaryNode;128;-1173.232,560.3851;Inherit;False;932.2314;729.3652;Dissolve - Opacity Mask;5;143;141;140;2;73;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;73;-501.5425,616.7317;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;114;-440.7648,199.8753;Inherit;True;Property;_BurnRamp;Burn Ramp;4;0;Create;True;0;0;0;False;0;False;-1;None;96f1785558043bf48bacf57b6511b602;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;115;-575.7913,222.4798;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;140;-1166.877,1009;Inherit;True;Property;_DisolveGuide2;Disolve Guide2;3;0;Create;True;0;0;0;False;0;False;-1;None;9727d48ef919e304d9e953a2e7ca9ad6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;143;-830.2435,1054.903;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-1166.11,827.3653;Inherit;True;Property;_DisolveGuide;Disolve Guide;2;0;Create;True;0;0;0;False;0;False;-1;None;65f1bcc050f37074ba3d62dafac507a1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;141;-625.7024,849.4251;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;157;-151.0646,-396.7752;Inherit;True;Standard;WorldNormal;ViewDir;False;True;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;172;408.958,31.6335;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;163;236.1104,48.91285;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;126;-162.5617,92.4654;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;130;-703.4545,91.49636;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;113;-916.9163,96.19888;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;112;-1156.614,216.729;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-5;False;4;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;142;867.998,92.21609;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;160;616.6061,15.13137;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;159;379.6627,-295.2092;Inherit;False;Property;_RimCol;RimCol;5;1;[PerRendererData];Create;True;0;0;0;True;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;138;1441.924,17.68553;Half;False;True;-1;2;ASEMaterialInspector;0;0;Lambert;Banter/RemoteAvatar;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Geometry;All;4;d3d11;glcore;gles;gles3;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;173;723.6093,511.4667;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;150;110.5673,542.0553;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;156;450.3019,517.3587;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;164;-18.90224,179.6443;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;175;1250.507,144.8126;Inherit;False;Constant;_Smoothness;Smoothness;8;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;158;-145.7974,-471.3275;Inherit;False;Property;_RimPower;RimPower;6;1;[PerRendererData];Create;True;0;0;0;True;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;78;1100.312,-171.7965;Inherit;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-2072.962,429.4176;Float;False;Property;_DissolveAmount;Dissolve Amount;7;0;Create;True;0;0;0;True;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;187;-2013.558,694.0264;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;196;-1806.339,691.3617;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;144;450.5693,183.9236;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;148;-1250.094,431.6602;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCRemapNode;111;-1281.078,717.513;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;-0.6;False;4;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;197;-1429.339,560.3617;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;195;-1613.339,689.3617;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;200;-43.00913,383.5235;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CameraDepthFade;176;-2278.639,675.0476;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;0.5;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;193;-2503.089,620.3232;Inherit;False;Global;SafetyDance;SafetyDance;8;0;Create;True;0;0;0;False;0;False;1;0;False;0;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode;202;-2517.408,700.7789;Inherit;False;Property;_TransitionLength;TransitionLength;9;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;201;-2494.408,771.7789;Inherit;False;Property;_BubbleDiameter;BubbleDiameter;8;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
WireConnection;73;0;111;0
WireConnection;73;1;141;0
WireConnection;114;1;115;0
WireConnection;115;0;130;0
WireConnection;143;0;140;1
WireConnection;141;0;2;1
WireConnection;141;1;143;0
WireConnection;157;2;158;0
WireConnection;172;0;163;0
WireConnection;163;0;164;2
WireConnection;163;1;157;0
WireConnection;126;0;130;0
WireConnection;126;1;114;0
WireConnection;130;0;113;0
WireConnection;113;0;112;0
WireConnection;112;0;73;0
WireConnection;142;0;160;0
WireConnection;142;1;126;0
WireConnection;160;0;172;0
WireConnection;160;1;159;0
WireConnection;138;0;78;0
WireConnection;138;2;142;0
WireConnection;138;4;175;0
WireConnection;138;10;144;0
WireConnection;138;11;200;0
WireConnection;173;0;164;2
WireConnection;173;1;156;0
WireConnection;156;0;150;0
WireConnection;156;1;73;0
WireConnection;187;0;176;0
WireConnection;196;0;187;0
WireConnection;144;0;73;0
WireConnection;148;0;197;0
WireConnection;148;1;173;0
WireConnection;111;0;197;0
WireConnection;197;0;4;0
WireConnection;197;1;195;0
WireConnection;195;1;196;0
WireConnection;195;2;193;0
WireConnection;200;0;148;0
WireConnection;200;2;193;0
WireConnection;176;0;202;0
WireConnection;176;1;201;0
ASEEND*/
//CHKSM=02EF944A5DA297F2229850F8AE693F14E45BAB4A