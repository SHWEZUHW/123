// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Portal1"
{
	Properties
	{
		_Thumbnail("Thumbnail", 2D) = "black" {}
		_NoisePackRGBA("NoisePackRGBA", 2D) = "white" {}
		_InnerGlowThreshold("InnerGlowThreshold", Range( 0 , 1.35)) = 0.03931955
		_Depth("Depth", Range( 0 , 1)) = 0
		_PortalRadius("PortalRadius", Range( 0 , 10)) = 2

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"

			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"
			#define ASE_NEEDS_VERT_POSITION


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float _InnerGlowThreshold;
			uniform float _Depth;
			uniform float _PortalRadius;
			uniform sampler2D _Thumbnail;
			uniform float4 _Thumbnail_ST;
			uniform sampler2D _NoisePackRGBA;
			uniform float4 _NoisePackRGBA_ST;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float2 PurePolarUV265 = v.ase_texcoord.xy;
				float temp_output_624_0 = ( 1.0 - PurePolarUV265.y );
				float temp_output_642_0 = saturate( temp_output_624_0 );
				float smoothstepResult1088 = smoothstep( 0.08 , 0.15 , temp_output_642_0);
				float smoothstepResult639 = smoothstep( 0.0 , 0.1 , temp_output_642_0);
				float temp_output_638_0 = ( smoothstepResult1088 - smoothstepResult639 );
				float smoothstepResult643 = smoothstep( _InnerGlowThreshold , 1.0 , temp_output_638_0);
				float temp_output_640_0 = saturate( smoothstepResult643 );
				float GlowMask672 = temp_output_640_0;
				float AlbedoMask671 = GlowMask672;
				float3 objectToViewPos = UnityObjectToViewPos(v.vertex.xyz);
				float eyeDepth = -objectToViewPos.z;
				float cameraDepthFade1103 = (( eyeDepth -_ProjectionParams.y - 1.0 ) / 5.0);
				float RawPlayerDistance802 = cameraDepthFade1103;
				float temp_output_971_0 = ( 1.0 - RawPlayerDistance802 );
				float temp_output_975_0 = ( temp_output_971_0 * temp_output_971_0 * temp_output_971_0 * temp_output_971_0 );
				float PlayerMaskDepth1009 = temp_output_975_0;
				float3 ase_parentObjectScale = ( 1.0 / float3( length( unity_WorldToObject[ 0 ].xyz ), length( unity_WorldToObject[ 1 ].xyz ), length( unity_WorldToObject[ 2 ].xyz ) ) );
				float temp_output_779_0 = ( 1.0 - saturate( ( RawPlayerDistance802 - _PortalRadius ) ) );
				float PlayerAlbedoMask1037 = temp_output_779_0;
				float smoothstepResult1102 = smoothstep( 0.08 , 0.09 , temp_output_642_0);
				float PlayerMaskScale1011 = smoothstepResult1102;
				float3 temp_output_786_0 = ( ( ( saturate( ( AlbedoMask671 - -0.16 ) ) * ( -( ( PlayerMaskDepth1009 / ase_parentObjectScale ) + ( PlayerMaskDepth1009 * _Depth ) ) * PlayerAlbedoMask1037 ) ) * v.ase_normal ) + ( v.vertex.xyz * PlayerMaskScale1011 ) );
				
				o.ase_texcoord2.x = eyeDepth;
				
				o.ase_texcoord1.xy = v.ase_texcoord1.xy;
				o.ase_texcoord1.zw = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord2.yzw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = temp_output_786_0;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float2 uv2_Thumbnail = i.ase_texcoord1.xy * _Thumbnail_ST.xy + _Thumbnail_ST.zw;
				float2 uv_NoisePackRGBA = i.ase_texcoord1.zw * _NoisePackRGBA_ST.xy + _NoisePackRGBA_ST.zw;
				float mulTime1111 = _Time.y * 0.1;
				float cos1110 = cos( mulTime1111 );
				float sin1110 = sin( mulTime1111 );
				float2 rotator1110 = mul( uv_NoisePackRGBA - float2( 0.5,0.5 ) , float2x2( cos1110 , -sin1110 , sin1110 , cos1110 )) + float2( 0.5,0.5 );
				float4 tex2DNode926 = tex2D( _NoisePackRGBA, rotator1110 );
				float4 OuterTexture1023 = tex2DNode926;
				float2 PurePolarUV265 = i.ase_texcoord1.zw;
				float temp_output_624_0 = ( 1.0 - PurePolarUV265.y );
				float saferPower752 = abs( temp_output_624_0 );
				float smoothstepResult1064 = smoothstep( 0.03 , 0.19 , pow( saferPower752 , 2.2 ));
				float temp_output_755_0 = saturate( smoothstepResult1064 );
				float Alpha673 = temp_output_755_0;
				float4 lerpResult1112 = lerp( float4( uv2_Thumbnail, 0.0 , 0.0 ) , OuterTexture1023 , ( ( 1.0 - Alpha673 ) * 0.1 ));
				float4 tex2DNode683 = tex2D( _Thumbnail, lerpResult1112.rg );
				float4 Thumb711 = tex2DNode683;
				float temp_output_642_0 = saturate( temp_output_624_0 );
				float smoothstepResult1102 = smoothstep( 0.08 , 0.09 , temp_output_642_0);
				float ThumbMask1095 = smoothstepResult1102;
				float4 appendResult1098 = (float4(Thumb711.rgb , ThumbMask1095));
				float eyeDepth = i.ase_texcoord2.x;
				float cameraDepthFade1103 = (( eyeDepth -_ProjectionParams.y - 1.0 ) / 5.0);
				float RawPlayerDistance802 = cameraDepthFade1103;
				float temp_output_779_0 = ( 1.0 - saturate( ( RawPlayerDistance802 - _PortalRadius ) ) );
				float clampResult1036 = clamp( temp_output_779_0 , 0.2 , 1.0 );
				float Test1081 = clampResult1036;
				float4 temp_cast_3 = (Test1081).xxxx;
				float PlayerAlbedoMask1037 = temp_output_779_0;
				float4 temp_output_788_0 = ( Thumb711 * PlayerAlbedoMask1037 * 0.65 );
				float4 lerpResult1097 = lerp( temp_cast_3 , temp_output_788_0 , ThumbMask1095);
				
				
				finalColor = ( appendResult1098 + lerpResult1097 );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	Fallback Off
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.CommentaryNode;1029;-1166.457,272;Inherit;False;2076.157;530.6051;;20;748;1077;1076;1010;1075;1073;786;783;785;687;686;905;1040;1041;749;1012;713;757;693;831;VERTEX OFFSET;0.1840543,0.1194375,0.4150943,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1022;-3909,-450;Inherit;False;1573.174;1023.792;;28;714;1025;1023;927;943;1017;876;926;615;966;967;938;629;866;705;706;937;678;942;707;941;940;868;939;681;715;877;867;SAMPLES;0.7650781,0,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1021;-4009.92,-1282;Inherit;False;1845.239;750.7199;;19;711;1067;1065;601;537;539;708;709;683;704;1008;538;534;1005;740;741;540;1113;1114;TEXTURES;0.02988511,0.2264151,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1020;-2401.201,-454.4999;Inherit;False;1172;371;;11;931;929;723;869;875;722;1006;721;932;934;1034;PORTAL SPEED;1,0.8515098,0.5613208,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1018;-5651.897,-480;Inherit;False;1557.897;1037.81;;40;1036;1033;1032;981;1030;984;979;1007;1003;996;995;991;1009;1015;1031;975;973;971;969;1016;825;817;823;815;816;802;775;771;809;770;784;782;778;779;777;776;895;1037;1042;1081;PLAYER MASKS;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1013;-5474,752;Inherit;False;2116;547;;19;620;624;642;617;639;638;643;886;640;672;752;755;673;1049;1056;1064;1078;1088;1095;PORTAL MASKS;0,0.2732866,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;722;-2353.201,-406.4999;Inherit;False;Property;_RotationSpeed;RotationSpeed;6;0;Create;True;0;0;0;False;0;False;0.1;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;721;-2321.201,-198.5;Inherit;False;Property;_InwardsSpeed;InwardsSpeed;5;0;Create;True;0;0;0;False;0;False;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;934;-2161.201,-342.4999;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;15;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;540;-3602,-928;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;741;-3874,-944;Inherit;False;1;534;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;740;-3842,-816;Inherit;False;Property;_DistortionSpeed;DistortionSpeed;4;0;Create;True;0;0;0;False;0;False;0,0.3;0,0.3;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;1005;-3842,-688;Inherit;False;266;PureTime;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;534;-3394,-944;Inherit;True;Property;_Distortion;Distortion;2;1;[Normal];Create;True;0;0;0;False;0;False;-1;c2c9b234d7873b14ba16c19badf81fd3;c2c9b234d7873b14ba16c19badf81fd3;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;867;-3461,382;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;877;-3845,350;Inherit;False;875;RotSpeed;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;715;-3653,446;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;1,3;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;939;-3861,206;Inherit;False;932;MaxRotSpeed;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;868;-3637,350;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;940;-3653,206;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;941;-3461,206;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;707;-3285,366;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;942;-3285,206;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;678;-3157,350;Inherit;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;708;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;937;-3157,158;Inherit;True;Property;_TextureSample4;Texture Sample 2;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;708;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;705;-3301,-146;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;866;-3493,-146;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;938;-3301,-306;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;967;-3525,-354;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;615;-3157,-130;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;708;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;926;-3157,-386;Inherit;True;Property;_TextureSample3;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;708;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;943;-2837,286;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;927;-2853,-146;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1025;-2549,286;Inherit;False;InnerTexture;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;714;-2693,286;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1034;-2049.201,-198.5;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;661;270,-672;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SwizzleNode;539;-3106,-944;Inherit;False;FLOAT3;0;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;537;-2962,-944;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;876;-3749,-82;Inherit;False;875;RotSpeed;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;538;-3378,-752;Inherit;False;Property;_DistortionStrength;Distortion Strength;3;0;Create;True;0;0;0;False;0;False;0.03;0.02;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;1065;-2788,-1100;Inherit;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;1.05;False;1;COLOR;0
Node;AmplifyShaderEditor.LinearToGammaNode;1067;-2607,-1097;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PosVertexDataNode;785;174,432;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;686;190,332;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;687;-50,429;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;693;-34,335;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;-2,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1040;-242,447;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;905;-242,335;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;757;-418,335;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;-0.16;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;749;-418,447;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1076;-546,447;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;1075;-786,383;Inherit;False;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1077;-786,479;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;748;-1090,607;Inherit;False;Property;_Depth;Depth;11;0;Create;True;0;0;0;False;0;False;0;4.06;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;816;-5026,-432;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;815;-5266,-432;Inherit;False;802;RawPlayerDistance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;823;-4754,-432;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;817;-4882,-432;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.7;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1009;-4418,-64;Inherit;False;PlayerMaskDepth;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1030;-4930,-208;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;981;-5042,-208;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;969;-5362,-32;Inherit;False;802;RawPlayerDistance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;971;-5122,-32;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;973;-4962,-32;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;975;-4802,-64;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1031;-5154,48;Inherit;False;Constant;_depthradius;_depthradius;13;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1037;-4850,240;Inherit;False;PlayerAlbedoMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1007;-4402,-304;Inherit;True;PlayerMaskDistortion;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1016;-4402,-432;Inherit;False;PlayerMaskSpeed;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1033;-5442,-400;Inherit;False;Constant;_speedradius;_speedradius;13;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1032;-5250,-128;Inherit;False;Constant;_distortionradius;_distortionradius;13;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;995;-5090,-305;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1003;-4770,-304;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;996;-4930,-304;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;984;-5282,-208;Inherit;False;802;RawPlayerDistance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexToFragmentNode;1015;-4639,1;Inherit;False;False;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexToFragmentNode;979;-4619,-243;Inherit;False;False;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexToFragmentNode;825;-4603,-377;Inherit;False;False;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;1036;-4850,128;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1042;-5154,224;Inherit;False;Constant;_minportalsize;_minportalsize;13;0;Create;True;0;0;0;False;0;False;0.2;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;779;-5010,128;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;777;-5154,128;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;776;-5298,128;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;782;-5586,240;Inherit;False;Property;_PortalRadius;PortalRadius;12;0;Create;True;0;0;0;False;0;False;2;2;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;770;-5138,368;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TransformPositionNode;809;-4898,368;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LengthOpNode;771;-4674,368;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;640;-3762,944;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;672;-3602,944;Inherit;False;GlowMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;620;-5394,880;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SaturateNode;755;-4642,800;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;1064;-4834,800;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.03;False;2;FLOAT;0.19;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;752;-4978,800;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;2.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;617;-5570,880;Inherit;False;265;PurePolarUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;609;-5218,-864;Inherit;False;PureUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;608;-5426,-864;Inherit;False;1;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;258;-5426,-720;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;266;-5042,-720;Inherit;False;PureTime;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;497;-4898,-1136;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;494;-5426,-1136;Inherit;False;1;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;495;-5218,-1136;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VertexToFragmentNode;1004;-5248,-651;Inherit;False;False;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexToFragmentNode;1001;-4754,-1062;Inherit;False;False;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;991;-5266,-305;Inherit;False;498;Fresnel;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;496;-5058,-1136;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;1,1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;1082;-5034.23,1353.485;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1078;-5032.058,923.4347;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1083;-4856.23,1221.485;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;642;-5000,1080;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1084;-4908.23,1437.485;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;624;-5282,864;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1086;-4664.114,1400.774;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;886;-4290,1040;Inherit;False;Property;_InnerGlowThreshold;InnerGlowThreshold;10;0;Create;True;0;0;0;False;0;False;0.03931955;0.212;0;1.35;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;643;-4009,875;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1087;-3751.245,1068.865;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;671;-3335.327,1013.174;Inherit;False;AlbedoMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectScaleNode;1073;-1007,455;Inherit;False;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SaturateNode;1090;998.27,304.3138;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;1091;1009.907,169.9341;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;626;-641.1997,-992.2;Inherit;False;Property;_OuterColor1;OuterColor1;7;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;0,0.1092456,1.304119,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;625;-364.4,-905.9997;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LinearToGammaNode;1045;-126.6,-926.7999;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;713;-610,335;Inherit;False;671;AlbedoMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1041;-482,543;Inherit;False;1037;PlayerAlbedoMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;601;-2818,-944;Inherit;True;DistortionTexture;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;1093;1235.133,-212.3547;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;673;-4178,800;Inherit;False;Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;1049;-4290,800;Inherit;False;FLOAT;1;0;FLOAT;0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GammaToLinearNode;1056;-4498,752;Inherit;False;1;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCRemapNode;1092;1094.907,-50.06589;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;0;False;3;FLOAT;1;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;706;-3573,78;Inherit;False;601;DistortionTexture;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;681;-3845,446;Inherit;False;265;PurePolarUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;257;-5426,-992;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;265;-5218,-992;Inherit;False;PurePolarUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;498;-4546,-1136;Inherit;True;Fresnel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;683;-3105,-1168;Inherit;True;Property;_Thumbnail;Thumbnail;0;0;Create;True;0;0;0;False;0;False;-1;24530903478a81946a8821282769369c;325032e82e6dda94181685143a53d37a;True;1;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;709;-3999,-1196;Inherit;False;265;PurePolarUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;711;-2402,-1170.313;Inherit;False;Thumb;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;904;-4508.195,1470.021;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.15;False;2;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1085;-4537.23,1335.485;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;639;-4614.727,832.7603;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;1088;-4589.245,981.865;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.08;False;2;FLOAT;0.15;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;1102;-4400.023,1177.043;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.08;False;2;FLOAT;0.09;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1080;757.7232,146.12;Inherit;False;1081;Test;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;666;142,-336;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1061;72,-221;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;788;283.0644,-192;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;885;-90,-60;Inherit;False;Constant;_Float4;Float 4;13;0;Create;True;0;0;0;False;0;False;0.65;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;931;-1649.201,-230.5;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;929;-1841.201,-230.5;Inherit;False;FLOAT2;4;0;FLOAT;0.1;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;723;-1825.201,-406.4999;Inherit;False;FLOAT2;4;0;FLOAT;0.1;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;869;-1649.201,-342.4999;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;932;-1473.201,-230.5;Inherit;False;MaxRotSpeed;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;1006;-1841.201,-310.4999;Inherit;False;266;PureTime;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;875;-1489.201,-342.4999;Inherit;False;RotSpeed;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;627;-637.2997,-802.5999;Inherit;False;Property;_OuterColor2;OuterColor2;8;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;1.94603,7.423744,13.76636,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LinearToGammaNode;1046;-87.59998,-671.2999;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;628;-569.7999,-605.7995;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;632;-889.7999,-605.7995;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;633;-1049.8,-525.7996;Inherit;False;Constant;_Float0;Float 0;8;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;1055;-745.7999,-605.7995;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.9;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1024;-1097.8,-605.7995;Inherit;False;1023;OuterTexture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;902;-274,-272;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;901;-418,-272;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;712;-114,-208;Inherit;False;711;Thumb;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;789;-84,-115;Inherit;False;1037;PlayerAlbedoMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;786;542,336;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;783;382,496;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;1012;126,576;Inherit;False;1011;PlayerMaskScale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;784;-5555,128;Inherit;False;802;RawPlayerDistance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;775;-4522,378;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;1103;-4628.807,498.907;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;5;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;802;-4370,368;Inherit;False;RawPlayerDistance;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;708;-3814,-1226;Inherit;True;Property;_NoisePackRGBA;NoisePackRGBA;1;0;Create;True;0;0;0;False;0;False;-1;46c5f003a8773cc4899579223c874d0b;46c5f003a8773cc4899579223c874d0b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1010;-1026,383;Inherit;False;1009;PlayerMaskDepth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;674;1489.559,-146.3914;Inherit;False;1081;Test;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1081;-4402.716,27.90282;Inherit;False;Test;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;895;-4573,109;Half;False;half1 c1 = 1.70158@$half1 c3 = c1 + 1@$$return 1 + c3 * pow(x - 1, 3) + c1 * pow(x - 1, 2)@;1;Create;1;True;x;FLOAT;0;In;;Inherit;False;easeOutBack;True;False;0;;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexToFragmentNode;778;-4504,242;Inherit;False;True;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;658;-351.4697,-569.6216;Inherit;False;Property;_InnerColor;InnerColor;9;1;[HDR];Create;True;0;0;0;False;0;False;11.44681,14.02013,16.94838,0;11.44681,14.02013,16.94838,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;677;-306,-352;Inherit;False;672;GlowMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1027;-594,-272;Inherit;False;1025;InnerTexture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;484;1034.499,-176.5999;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;1098;868.2754,-523.4237;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1089;1494.403,-382.3795;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;682;647.0315,-397.3307;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;1054;823,-42;Inherit;False;FLOAT;1;0;FLOAT;0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;676;319,-28;Inherit;False;673;Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexToFragmentNode;831;880.8442,498.4142;Inherit;False;True;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;1097;1045.737,-340.0701;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1096;418.669,156.9265;Inherit;False;1095;ThumbMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;1094;-4144.981,1412.548;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;0;False;3;FLOAT;1;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1095;-4022.317,1203.696;Inherit;False;ThumbMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1011;-3760.388,1423.028;Inherit;False;PlayerMaskScale;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;638;-4298,937.892;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1109;1772.548,-127.1442;Float;False;True;-1;2;ASEMaterialInspector;100;5;Portal1;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.GetLocalVarNode;966;-3781,-354;Inherit;False;932;MaxRotSpeed;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;1017;-3093,62;Inherit;False;1016;PlayerMaskSpeed;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;629;-3781,-210;Inherit;False;0;708;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RotatorNode;1110;-3522.841,-491.1981;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1.36;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;747;-3519,-1377;Inherit;False;1;683;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1023;-2618,-152;Inherit;False;OuterTexture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;704;-3553,-1199;Inherit;True;1023;OuterTexture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1008;-3460.4,-664.2001;Inherit;True;1007;PlayerMaskDistortion;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1113;-3355.376,-1137.841;Inherit;True;673;Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1112;-2937.361,-1379.655;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.05660379;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;1114;-3285.147,-1307.773;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1115;-3122.147,-1299.773;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;1111;-3738.716,-499.5673;Inherit;False;1;0;FLOAT;0.1;False;1;FLOAT;0
WireConnection;934;0;722;0
WireConnection;540;0;741;0
WireConnection;540;2;740;0
WireConnection;540;1;1005;0
WireConnection;534;1;540;0
WireConnection;867;0;868;0
WireConnection;867;1;715;0
WireConnection;715;0;681;0
WireConnection;868;0;877;0
WireConnection;940;0;939;0
WireConnection;941;0;940;0
WireConnection;941;1;715;0
WireConnection;707;0;706;0
WireConnection;707;1;867;0
WireConnection;942;0;941;0
WireConnection;942;1;706;0
WireConnection;678;1;707;0
WireConnection;937;1;942;0
WireConnection;705;0;866;0
WireConnection;705;1;706;0
WireConnection;866;0;629;0
WireConnection;866;1;876;0
WireConnection;938;0;967;0
WireConnection;938;1;706;0
WireConnection;967;0;966;0
WireConnection;967;1;629;0
WireConnection;615;1;705;0
WireConnection;926;1;1110;0
WireConnection;943;0;678;2
WireConnection;943;1;937;2
WireConnection;943;2;1017;0
WireConnection;927;0;615;3
WireConnection;927;1;926;3
WireConnection;927;2;1017;0
WireConnection;1025;0;714;0
WireConnection;714;0;943;0
WireConnection;1034;0;721;0
WireConnection;661;0;1045;0
WireConnection;661;1;666;0
WireConnection;539;0;534;0
WireConnection;537;0;539;0
WireConnection;537;1;538;0
WireConnection;537;2;1008;0
WireConnection;1065;1;683;0
WireConnection;1067;0;1065;0
WireConnection;686;0;693;0
WireConnection;686;1;687;0
WireConnection;693;0;905;0
WireConnection;693;1;1040;0
WireConnection;1040;0;749;0
WireConnection;1040;1;1041;0
WireConnection;905;0;757;0
WireConnection;757;0;713;0
WireConnection;749;0;1076;0
WireConnection;1076;0;1075;0
WireConnection;1076;1;1077;0
WireConnection;1075;0;1010;0
WireConnection;1075;1;1073;0
WireConnection;1077;0;1010;0
WireConnection;1077;1;748;0
WireConnection;816;0;815;0
WireConnection;823;0;817;0
WireConnection;817;0;816;0
WireConnection;817;1;1033;0
WireConnection;1009;0;975;0
WireConnection;1030;0;981;0
WireConnection;981;0;984;0
WireConnection;981;1;1032;0
WireConnection;971;0;969;0
WireConnection;973;0;971;0
WireConnection;973;1;1031;0
WireConnection;975;0;971;0
WireConnection;975;1;971;0
WireConnection;975;2;971;0
WireConnection;975;3;971;0
WireConnection;1037;0;779;0
WireConnection;1007;0;1003;0
WireConnection;1016;0;823;0
WireConnection;995;0;991;0
WireConnection;1003;0;996;0
WireConnection;1003;2;1030;0
WireConnection;996;0;995;0
WireConnection;1015;0;975;0
WireConnection;979;0;1003;0
WireConnection;825;0;823;0
WireConnection;1036;0;779;0
WireConnection;1036;1;1042;0
WireConnection;779;0;777;0
WireConnection;777;0;776;0
WireConnection;776;0;784;0
WireConnection;776;1;782;0
WireConnection;809;0;770;0
WireConnection;771;0;809;0
WireConnection;640;0;643;0
WireConnection;672;0;640;0
WireConnection;620;0;617;0
WireConnection;755;0;1064;0
WireConnection;1064;0;752;0
WireConnection;752;0;624;0
WireConnection;609;0;608;0
WireConnection;266;0;258;0
WireConnection;497;0;496;0
WireConnection;495;0;494;0
WireConnection;1004;0;258;0
WireConnection;1001;0;497;0
WireConnection;496;0;495;0
WireConnection;1082;0;624;0
WireConnection;1078;0;624;0
WireConnection;1083;0;642;0
WireConnection;642;0;624;0
WireConnection;1084;0;1083;0
WireConnection;624;0;620;1
WireConnection;1086;0;1083;0
WireConnection;643;0;638;0
WireConnection;643;1;886;0
WireConnection;1087;0;640;0
WireConnection;1087;1;643;0
WireConnection;671;0;672;0
WireConnection;1090;0;1080;0
WireConnection;1091;0;1080;0
WireConnection;625;0;626;0
WireConnection;625;1;627;0
WireConnection;625;2;628;0
WireConnection;1045;0;625;0
WireConnection;601;0;537;0
WireConnection;1093;0;1092;0
WireConnection;673;0;1049;0
WireConnection;1049;0;755;0
WireConnection;1056;0;755;0
WireConnection;1092;0;1080;0
WireConnection;265;0;257;0
WireConnection;498;0;497;0
WireConnection;683;1;1112;0
WireConnection;711;0;683;0
WireConnection;904;0;642;0
WireConnection;1085;0;624;0
WireConnection;1085;1;1086;0
WireConnection;639;0;642;0
WireConnection;1088;0;642;0
WireConnection;1102;0;642;0
WireConnection;666;0;658;0
WireConnection;666;1;677;0
WireConnection;666;2;902;0
WireConnection;1061;0;712;0
WireConnection;1061;1;712;0
WireConnection;788;0;712;0
WireConnection;788;1;789;0
WireConnection;788;2;885;0
WireConnection;931;0;929;0
WireConnection;931;1;1006;0
WireConnection;929;0;934;0
WireConnection;929;1;1034;0
WireConnection;723;0;722;0
WireConnection;723;1;721;0
WireConnection;869;0;723;0
WireConnection;869;1;1006;0
WireConnection;932;0;931;0
WireConnection;875;0;869;0
WireConnection;1046;0;658;0
WireConnection;628;0;1055;0
WireConnection;632;0;1024;0
WireConnection;632;1;633;0
WireConnection;1055;0;632;0
WireConnection;902;0;901;0
WireConnection;901;0;1027;0
WireConnection;786;0;686;0
WireConnection;786;1;783;0
WireConnection;783;0;785;0
WireConnection;783;1;1012;0
WireConnection;775;0;771;0
WireConnection;802;0;1103;0
WireConnection;708;1;709;0
WireConnection;1081;0;1036;0
WireConnection;895;0;1036;0
WireConnection;778;0;895;0
WireConnection;484;0;682;0
WireConnection;484;3;1054;0
WireConnection;1098;0;712;0
WireConnection;1098;3;1096;0
WireConnection;1089;0;1098;0
WireConnection;1089;1;1097;0
WireConnection;682;0;661;0
WireConnection;682;1;788;0
WireConnection;682;2;1093;0
WireConnection;1054;0;676;0
WireConnection;831;0;786;0
WireConnection;1097;0;1080;0
WireConnection;1097;1;788;0
WireConnection;1097;2;1096;0
WireConnection;1094;0;638;0
WireConnection;1095;0;1102;0
WireConnection;1011;0;1102;0
WireConnection;638;0;1088;0
WireConnection;638;1;639;0
WireConnection;1109;0;1089;0
WireConnection;1109;1;786;0
WireConnection;1110;0;629;0
WireConnection;1110;2;1111;0
WireConnection;1023;0;926;0
WireConnection;1112;0;747;0
WireConnection;1112;1;704;0
WireConnection;1112;2;1115;0
WireConnection;1114;0;1113;0
WireConnection;1115;0;1114;0
ASEEND*/
//CHKSM=FBBC92B57C6727B4664FA4CA4CCCC447EE39AEE5