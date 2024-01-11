// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BPortalEdge"
{
	Properties
	{
		_Color0("Color 0", Color) = (0,0,0,0)
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Spin("Spin", Float) = 2
		_Spin2("Spin2", Float) = 0
		_Swirl("Swirl", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Back
		Blend One One
		
		AlphaToMask On
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _Swirl;
		uniform sampler2D _TextureSample0;
		uniform float _Spin;
		uniform float _Spin2;
		uniform float4 _Color0;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float cameraDepthFade26 = (( -UnityObjectToViewPos( v.vertex.xyz ).z -_ProjectionParams.y - 3.0 ) / 10.0);
			float temp_output_42_0 = (0.0 + (cameraDepthFade26 - 0.0) * (-1.0 - 0.0) / (1.0 - 0.0));
			float clampResult60 = clamp( temp_output_42_0 , -0.5 , 0.0 );
			float3 ase_vertex3Pos = v.vertex.xyz;
			v.vertex.xyz += ( clampResult60 * ase_vertex3Pos );
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 appendResult62 = (float2(3.0 , 0.0));
			float2 panner61 = ( 1.0 * _Time.y * appendResult62 + i.uv_texcoord);
			float4 appendResult25 = (float4(_Spin , _Spin2 , 0.0 , 0.0));
			float2 panner7 = ( 1.0 * _Time.y * appendResult25.xy + i.uv_texcoord);
			float2 panner20 = ( 1.0 * _Time.y * appendResult25.xy + i.uv_texcoord);
			float4 temp_output_4_0 = ( ( tex2D( _TextureSample0, panner7 ) * _Color0 ) + tex2D( _TextureSample0, panner20 ) );
			float4 lerpResult52 = lerp( tex2D( _Swirl, panner61 ) , temp_output_4_0 , saturate( i.vertexColor ));
			o.Emission = lerpResult52.rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows vertex:vertexDataFunc 

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
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
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
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
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
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1;-250.9283,-24.68735;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;4;-121.9283,158.3127;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;19;-721.8452,-248.5074;Inherit;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;0;0;0;False;0;False;-1;None;8c638151065c70f488bbd09a8a0cf72f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;5;-657.9283,-15.68735;Inherit;True;Property;_MainTex1;MainTex;5;0;Create;True;0;0;0;False;0;False;-1;None;1a5216cca5eaf194ba63631d36fd848c;True;0;False;white;Auto;False;Instance;19;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;22;-290.8452,457.4926;Inherit;False;Property;_Float0;Float 0;6;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;7;-936.7863,-241.1877;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;2,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;27;-1350.565,-422.4819;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-1351.222,-341.7886;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-1477.845,-248.5074;Inherit;False;Property;_Spin;Spin;7;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-1454.222,-178.7886;Inherit;False;Property;_Spin2;Spin2;8;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-1197.786,-140.1877;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;233,347;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;BPortalEdge;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;True;Opaque;;AlphaTest;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;4;1;False;;1;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;2;-1;-1;-1;0;True;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-83.22205,306.2114;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;36;-1102.024,697.8983;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;35;-1215.366,514.4324;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;47;-1352.314,766.119;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldToObjectTransfNode;46;-1101.081,894.8876;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;43;-529.2128,951.228;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector2Node;10;-2163.316,161.4086;Inherit;False;Property;_Vector0;Vector 0;4;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;14;-1495.665,210.6942;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;-1975.317,168.7311;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;16;-1693.319,158.7311;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;11;-1931.03,284.9284;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-2227.277,287.4669;Inherit;False;Property;_SpeedNoise;SpeedNoise;1;0;Create;True;0;0;0;False;0;False;0.21;0.4;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-2054.351,391.3584;Inherit;False;Property;_ScaleNoise;ScaleNoise;3;0;Create;True;0;0;0;False;0;False;0.04;20;0;30;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;17;-1697.902,268.172;Inherit;False;0;0;1;1;1;True;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;20;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.VertexColorNode;30;-648.222,379.2114;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;53;-460.7643,532.0157;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;54;-461.7643,634.0157;Inherit;True;Property;_Swirl;Swirl;9;0;Create;True;0;0;0;False;0;False;-1;None;7e9aaf50679c8764aa96279329f0ffa3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;52;-86.76428,472.0157;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;1,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;55;-108.7643,652.0157;Inherit;False;Constant;_Color1;Color 1;10;0;Create;True;0;0;0;False;0;False;0.01126397,1,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;38;-858.3893,1006.43;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ObjectScaleNode;45;-907.0808,1515.888;Inherit;False;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PosFromTransformMatrix;49;-971.314,1335.119;Inherit;False;1;0;FLOAT4x4;1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TransformPositionNode;48;-1150.314,1108.119;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;59;-870.5898,480.2325;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RotatorNode;58;-650.5898,598.2325;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TransformPositionNode;50;403.8169,1312.699;Inherit;False;Object;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FunctionNode;57;213.8357,1245.516;Inherit;False;Spiral;-1;;1;310c5f1537fa4c44699ebaf10a65d8a2;1,2,1;5;7;FLOAT2;3,3;False;8;FLOAT2;1.5,1.5;False;9;FLOAT;1;False;10;FLOAT;0.6;False;11;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-228.5658,1122.531;Inherit;False;2;2;0;FLOAT;1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;44;-629.9127,1322.728;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;51;-433.9675,1321.102;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;56;275.4357,991.0158;Inherit;False;Constant;_Color2;Color 1;10;0;Create;True;0;0;0;False;0;False;1,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;60;-323.6585,910.4445;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;-0.5;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;20;-912.8455,-23.60741;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;4,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;25;-1125.845,-328.5074;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0.12;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.PannerNode;61;-865.7592,283.8441;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;4,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;42;-832,672;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;63;-1341.039,72.59122;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;26;-1658.878,-392.0953;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;10;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;65;-1657.541,-183.3531;Inherit;False;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;39;-1519.575,38.67708;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;62;-1047.532,360.7862;Inherit;False;FLOAT2;4;0;FLOAT;3;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;2;-614.9283,186.3127;Inherit;False;Property;_Color0;Color 0;0;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0.6459694,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;1;0;19;0
WireConnection;1;1;2;0
WireConnection;4;0;1;0
WireConnection;4;1;5;0
WireConnection;19;1;7;0
WireConnection;5;1;20;0
WireConnection;7;0;6;0
WireConnection;7;2;25;0
WireConnection;27;0;26;0
WireConnection;29;0;27;0
WireConnection;29;1;23;0
WireConnection;0;2;52;0
WireConnection;0;11;37;0
WireConnection;31;0;30;0
WireConnection;31;1;4;0
WireConnection;35;0;27;0
WireConnection;46;0;47;0
WireConnection;43;0;38;0
WireConnection;43;1;42;0
WireConnection;14;0;16;0
WireConnection;14;1;17;0
WireConnection;15;1;10;0
WireConnection;16;0;15;0
WireConnection;16;1;11;0
WireConnection;11;0;12;0
WireConnection;17;0;15;0
WireConnection;17;1;11;0
WireConnection;17;2;13;0
WireConnection;53;0;30;0
WireConnection;54;1;61;0
WireConnection;52;0;54;0
WireConnection;52;1;4;0
WireConnection;52;2;53;0
WireConnection;48;0;38;0
WireConnection;58;0;59;0
WireConnection;37;0;60;0
WireConnection;37;1;38;0
WireConnection;44;0;38;0
WireConnection;51;0;38;0
WireConnection;51;1;42;0
WireConnection;60;0;42;0
WireConnection;20;0;6;0
WireConnection;20;2;25;0
WireConnection;25;0;23;0
WireConnection;25;1;32;0
WireConnection;61;0;6;0
WireConnection;61;2;62;0
WireConnection;42;0;26;0
WireConnection;63;0;26;0
WireConnection;65;0;26;0
WireConnection;39;0;65;0
ASEEND*/
//CHKSM=5B3A65FCA4562FD8B3A346011D4036D1D407690F