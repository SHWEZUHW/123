// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Portal"
{
	Properties
	{
		_Thumbnail("Thumbnail", 2D) = "black" {}
		_NoisePackRGBA("NoisePackRGBA", 2D) = "white" {}
		[Normal]_Distortion("Distortion", 2D) = "bump" {}
		_DistortionStrength("Distortion Strength", Range( 0 , 0.1)) = 0.03
		_DistortionSpeed("DistortionSpeed", Vector) = (0,0.3,0,0)
		_InwardsSpeed("InwardsSpeed", Float) = 0.1
		_RotationSpeed("RotationSpeed", Float) = 0.1
		[HDR]_OuterColor1("OuterColor1", Color) = (1,1,1,0)
		[HDR]_OuterColor2("OuterColor2", Color) = (0,0,0,0)
		[HDR]_InnerColor("InnerColor", Color) = (11.44681,14.02013,16.94838,0)
		_InnerGlowThreshold("InnerGlowThreshold", Range( 0 , 0.35)) = 0.1204973
		_Depth("Depth", Range( 0 , 1)) = 0
		_PortalRadius("PortalRadius", Range( 0 , 10)) = 2

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Transparent" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite Off
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"

			CGPROGRAM

			#define ASE_ABSOLUTE_VERTEX_POS 1


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
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float _Depth;
			uniform float _PortalRadius;
			uniform float4 _OuterColor1;
			uniform float4 _OuterColor2;
			uniform sampler2D _NoisePackRGBA;
			uniform float4 _NoisePackRGBA_ST;
			uniform float _RotationSpeed;
			uniform float _InwardsSpeed;
			uniform sampler2D _Distortion;
			uniform float2 _DistortionSpeed;
			uniform float4 _Distortion_ST;
			uniform float _DistortionStrength;
			uniform float4 _InnerColor;
			uniform float _InnerGlowThreshold;
			uniform sampler2D _Thumbnail;
			uniform float4 _Thumbnail_ST;
			half easeOutBack895( half x )
			{
				half1 c1 = 1.70158;
				half1 c3 = c1 + 1;
				return 1 + c3 * pow(x - 1, 3) + c1 * pow(x - 1, 2);
			}
			

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float2 PurePolarUV265 = v.ase_texcoord.xy;
				float temp_output_624_0 = ( 1.0 - PurePolarUV265.y );
				float temp_output_642_0 = saturate( ( temp_output_624_0 - 0.11 ) );
				float smoothstepResult904 = smoothstep( 0.15 , 0.42 , temp_output_642_0);
				float AlbedoMask671 = smoothstepResult904;
				float3 worldToObj809 = mul( unity_WorldToObject, float4( _WorldSpaceCameraPos, 1 ) ).xyz;
				float RawPlayerDistance802 = ( length( worldToObj809 ) * 0.1 );
				float temp_output_971_0 = ( 1.0 - RawPlayerDistance802 );
				float temp_output_975_0 = ( temp_output_971_0 * temp_output_971_0 * temp_output_971_0 * temp_output_971_0 );
				float PlayerMaskDepth1009 = temp_output_975_0;
				float3 ase_parentObjectScale = ( 1.0 / float3( length( unity_WorldToObject[ 0 ].xyz ), length( unity_WorldToObject[ 1 ].xyz ), length( unity_WorldToObject[ 2 ].xyz ) ) );
				float temp_output_779_0 = ( 1.0 - saturate( ( RawPlayerDistance802 - _PortalRadius ) ) );
				float PlayerAlbedoMask1037 = temp_output_779_0;
				float clampResult1036 = clamp( temp_output_779_0 , 0.2 , 1.0 );
				half x895 = clampResult1036;
				half localeaseOutBack895 = easeOutBack895( x895 );
				float PlayerMaskScale1011 = localeaseOutBack895;
				float3 temp_output_786_0 = ( ( ( saturate( ( AlbedoMask671 - -0.16 ) ) * ( -( ( PlayerMaskDepth1009 / ase_parentObjectScale ) + ( PlayerMaskDepth1009 * _Depth ) ) * PlayerAlbedoMask1037 ) ) * v.ase_normal ) + ( v.vertex.xyz * PlayerMaskScale1011 ) );
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				o.ase_texcoord1.zw = v.ase_texcoord1.xy;
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
				float2 uv_NoisePackRGBA = i.ase_texcoord1.xy * _NoisePackRGBA_ST.xy + _NoisePackRGBA_ST.zw;
				float2 appendResult723 = (float2(_RotationSpeed , _InwardsSpeed));
				float PureTime266 = _Time.y;
				float2 RotSpeed875 = ( appendResult723 * PureTime266 );
				float2 uv2_Distortion = i.ase_texcoord1.zw * _Distortion_ST.xy + _Distortion_ST.zw;
				float2 panner540 = ( PureTime266 * _DistortionSpeed + uv2_Distortion);
				float temp_output_497_0 = length( ( ( i.ase_texcoord1.zw * float2( 2,2 ) ) - float2( 1,1 ) ) );
				float Fresnel498 = temp_output_497_0;
				float3 worldToObj809 = mul( unity_WorldToObject, float4( _WorldSpaceCameraPos, 1 ) ).xyz;
				float RawPlayerDistance802 = ( length( worldToObj809 ) * 0.1 );
				float lerpResult1003 = lerp( ( ( Fresnel498 - 0.1 ) * 10.0 ) , 1.0 , saturate( ( RawPlayerDistance802 + 0.5 ) ));
				float PlayerMaskDistortion1007 = lerpResult1003;
				float3 DistortionTexture601 = ( (UnpackNormal( tex2D( _Distortion, panner540 ) )).xyz * _DistortionStrength * PlayerMaskDistortion1007 );
				float2 appendResult929 = (float2(( _RotationSpeed * 15.0 ) , ( _InwardsSpeed * 5.0 )));
				float2 MaxRotSpeed932 = ( appendResult929 * PureTime266 );
				float temp_output_823_0 = saturate( ( ( 1.0 - RawPlayerDistance802 ) + 0.5 ) );
				float PlayerMaskSpeed1016 = temp_output_823_0;
				float lerpResult927 = lerp( tex2D( _NoisePackRGBA, ( float3( ( uv_NoisePackRGBA + RotSpeed875 ) ,  0.0 ) + DistortionTexture601 ).xy ).b , tex2D( _NoisePackRGBA, ( float3( ( MaxRotSpeed932 + uv_NoisePackRGBA ) ,  0.0 ) + DistortionTexture601 ).xy ).b , PlayerMaskSpeed1016);
				float OuterTexture1023 = lerpResult927;
				float4 lerpResult625 = lerp( _OuterColor1 , _OuterColor2 , saturate( pow( ( OuterTexture1023 * 2.0 ) , 0.9 ) ));
				float3 linearToGamma1045 = LinearToGammaSpace( lerpResult625.rgb );
				float3 linearToGamma1046 = LinearToGammaSpace( _InnerColor.rgb );
				float2 PurePolarUV265 = i.ase_texcoord1.xy;
				float temp_output_624_0 = ( 1.0 - PurePolarUV265.y );
				float temp_output_642_0 = saturate( ( temp_output_624_0 - 0.11 ) );
				float smoothstepResult639 = smoothstep( 0.25 , 0.68 , temp_output_642_0);
				float smoothstepResult643 = smoothstep( _InnerGlowThreshold , 0.35 , ( temp_output_642_0 - smoothstepResult639 ));
				float GlowMask672 = saturate( smoothstepResult643 );
				float2 temp_output_715_0 = ( PurePolarUV265 * float2( 1,3 ) );
				float lerpResult943 = lerp( tex2D( _NoisePackRGBA, ( DistortionTexture601 + float3( ( -RotSpeed875 + temp_output_715_0 ) ,  0.0 ) ).xy ).g , tex2D( _NoisePackRGBA, ( float3( ( -MaxRotSpeed932 + temp_output_715_0 ) ,  0.0 ) + DistortionTexture601 ).xy ).g , PlayerMaskSpeed1016);
				float InnerTexture1025 = ( 1.0 - lerpResult943 );
				float3 gammaToLinear1051 = GammaToLinearSpace( ( linearToGamma1045 + ( linearToGamma1046 * GlowMask672 * saturate( ( InnerTexture1025 - 0.1 ) ) ) ) );
				float2 uv2_Thumbnail = i.ase_texcoord1.zw * _Thumbnail_ST.xy + _Thumbnail_ST.zw;
				float2 appendResult1080 = (float2(( 1.0 - uv2_Thumbnail.x ) , uv2_Thumbnail.y));
				float4 tex2DNode683 = tex2D( _Thumbnail, ( float3( appendResult1080 ,  0.0 ) + DistortionTexture601 ).xy );
				float4 Thumb711 = tex2DNode683;
				float temp_output_779_0 = ( 1.0 - saturate( ( RawPlayerDistance802 - _PortalRadius ) ) );
				float PlayerAlbedoMask1037 = temp_output_779_0;
				float4 temp_output_788_0 = ( ( Thumb711 + Thumb711 ) * PlayerAlbedoMask1037 * 0.65 );
				float smoothstepResult904 = smoothstep( 0.15 , 0.42 , temp_output_642_0);
				float AlbedoMask671 = smoothstepResult904;
				float4 lerpResult682 = lerp( float4( gammaToLinear1051 , 0.0 ) , temp_output_788_0 , AlbedoMask671);
				float saferPower752 = abs( temp_output_624_0 );
				float smoothstepResult1064 = smoothstep( 0.03 , 0.19 , pow( saferPower752 , 2.2 ));
				float Alpha673 = saturate( smoothstepResult1064 );
				float4 appendResult484 = (float4(lerpResult682.rgb , Alpha673));
				
				
				finalColor = appendResult484;
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
Node;AmplifyShaderEditor.CommentaryNode;1022;-4018,-448;Inherit;False;1573.174;1023.792;;28;714;1025;1023;927;943;1017;876;926;615;966;967;938;629;866;705;706;937;678;942;707;941;940;868;939;681;715;877;867;SAMPLES;0.7650781,0,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1021;-4009.92,-1282;Inherit;False;1845.239;750.7199;;18;711;1067;1065;601;537;539;708;709;683;704;703;1008;538;534;1005;740;741;540;TEXTURES;0.02988511,0.2264151,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1020;-2401.201,-454.4999;Inherit;False;1172;371;;11;931;929;723;869;875;722;1006;721;932;934;1034;PORTAL SPEED;1,0.8515098,0.5613208,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1018;-5651.897,-480;Inherit;False;1557.897;1037.81;;40;1036;1033;1032;981;1030;984;979;1007;1003;996;995;991;1009;1015;1031;975;973;971;969;1016;825;817;823;815;816;802;775;771;809;770;784;782;778;779;777;776;1011;895;1037;1042;PLAYER MASKS;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1013;-5474,752;Inherit;False;2116;547;;18;620;624;642;641;617;639;638;643;886;640;672;752;755;673;904;671;1049;1064;PORTAL MASKS;0,0.2732866,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;931;-1649.201,-230.5;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;929;-1841.201,-230.5;Inherit;False;FLOAT2;4;0;FLOAT;0.1;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;723;-1825.201,-406.4999;Inherit;False;FLOAT2;4;0;FLOAT;0.1;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;869;-1649.201,-342.4999;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;722;-2353.201,-406.4999;Inherit;False;Property;_RotationSpeed;RotationSpeed;6;0;Create;True;0;0;0;False;0;False;0.1;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;721;-2321.201,-198.5;Inherit;False;Property;_InwardsSpeed;InwardsSpeed;5;0;Create;True;0;0;0;False;0;False;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;932;-1473.201,-230.5;Inherit;False;MaxRotSpeed;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;934;-2161.201,-342.4999;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;15;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;540;-3602,-928;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;741;-3874,-944;Inherit;False;1;534;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;740;-3842,-816;Inherit;False;Property;_DistortionSpeed;DistortionSpeed;4;0;Create;True;0;0;0;False;0;False;0,0.3;0,0.3;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;1005;-3842,-688;Inherit;False;266;PureTime;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;534;-3394,-944;Inherit;True;Property;_Distortion;Distortion;2;1;[Normal];Create;True;0;0;0;False;0;False;-1;c2c9b234d7873b14ba16c19badf81fd3;c2c9b234d7873b14ba16c19badf81fd3;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;703;-3218,-1168;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;683;-3106,-1168;Inherit;True;Property;_Thumbnail;Thumbnail;0;0;Create;True;0;0;0;False;0;False;-1;24530903478a81946a8821282769369c;325032e82e6dda94181685143a53d37a;True;1;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;867;-3570,384;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;877;-3954,352;Inherit;False;875;RotSpeed;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;715;-3762,448;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;1,3;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;681;-3954,448;Inherit;False;265;PurePolarUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;939;-3970,208;Inherit;False;932;MaxRotSpeed;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;868;-3746,352;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;940;-3762,208;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;941;-3570,208;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;707;-3394,368;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;942;-3394,208;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;678;-3266,352;Inherit;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;708;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;937;-3266,160;Inherit;True;Property;_TextureSample4;Texture Sample 2;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;708;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;706;-3682,80;Inherit;False;601;DistortionTexture;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;705;-3410,-144;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;866;-3602,-144;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;938;-3410,-304;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;967;-3634,-352;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;966;-3890,-352;Inherit;False;932;MaxRotSpeed;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;615;-3266,-128;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;708;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;926;-3266,-384;Inherit;True;Property;_TextureSample3;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;708;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1017;-3202,64;Inherit;False;1016;PlayerMaskSpeed;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;943;-2946,288;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;927;-2962,-144;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1025;-2658,288;Inherit;False;InnerTexture;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;714;-2802,288;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;625;-354,-672;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1034;-2049.201,-198.5;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;682;622,-256;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;661;270,-672;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;628;-562,-416;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;632;-882,-416;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;539;-3106,-944;Inherit;False;FLOAT3;0;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;537;-2962,-944;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;601;-2818,-944;Inherit;True;DistortionTexture;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;633;-1042,-336;Inherit;False;Constant;_Float0;Float 0;8;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;1055;-738,-416;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;484;974,-240;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;788;174,-192;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1061;62,-224;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;711;-2402,-1168;Inherit;False;Thumb;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;1054;913,-23;Inherit;False;FLOAT;1;0;FLOAT;0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;712;-114,-208;Inherit;False;711;Thumb;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1006;-1841.201,-310.4999;Inherit;False;266;PureTime;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;875;-1489.201,-342.4999;Inherit;False;RotSpeed;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;629;-3890,-208;Inherit;False;0;708;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;876;-3858,-80;Inherit;False;875;RotSpeed;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1023;-2674,-144;Inherit;False;OuterTexture;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;704;-3469,-1139;Inherit;True;601;DistortionTexture;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;538;-3378,-752;Inherit;False;Property;_DistortionStrength;Distortion Strength;3;0;Create;True;0;0;0;False;0;False;0.03;0.011;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1008;-3346,-672;Inherit;True;1007;PlayerMaskDistortion;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GammaToLinearNode;1060;336,-272;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;1065;-2788,-1100;Inherit;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;1.05;False;1;COLOR;0
Node;AmplifyShaderEditor.LinearToGammaNode;1067;-2607,-1097;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;1024;-1090,-416;Inherit;False;1023;OuterTexture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LinearToGammaNode;1046;-98,-527;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;658;-354,-528;Inherit;False;Property;_InnerColor;InnerColor;9;1;[HDR];Create;True;0;0;0;False;0;False;11.44681,14.02013,16.94838,0;11.44681,14.02013,16.94838,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;708;-3814,-1226;Inherit;True;Property;_NoisePackRGBA;NoisePackRGBA;1;0;Create;True;0;0;0;False;0;False;-1;46c5f003a8773cc4899579223c874d0b;46c5f003a8773cc4899579223c874d0b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;709;-3999,-1196;Inherit;False;265;PurePolarUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PosVertexDataNode;785;174,432;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;786;542,336;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;687;-50,429;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1040;-242,447;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;905;-242,335;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;757;-418,335;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;-0.16;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;749;-418,447;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1076;-546,447;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;713;-610,335;Inherit;False;671;AlbedoMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;1075;-786,383;Inherit;False;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1077;-786,479;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;748;-1090,607;Inherit;False;Property;_Depth;Depth;11;0;Create;True;0;0;0;False;0;False;0;0.221;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectScaleNode;1073;-1007,455;Inherit;False;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;1010;-1026,383;Inherit;False;1009;PlayerMaskDepth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1041;-482,543;Inherit;False;1037;PlayerAlbedoMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;816;-5026,-432;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;815;-5266,-432;Inherit;False;802;RawPlayerDistance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;823;-4754,-432;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;817;-4882,-432;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.7;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1009;-4418,-64;Inherit;False;PlayerMaskDepth;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1030;-4930,-208;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;981;-5042,-208;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;969;-5362,-32;Inherit;False;802;RawPlayerDistance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;971;-5122,-32;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;975;-4802,-64;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1011;-4338,128;Inherit;False;PlayerMaskScale;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
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
Node;AmplifyShaderEditor.VertexToFragmentNode;778;-4689,168;Inherit;False;True;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexToFragmentNode;979;-4619,-243;Inherit;False;False;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexToFragmentNode;825;-4603,-377;Inherit;False;False;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;895;-4482,128;Half;False;half1 c1 = 1.70158@$half1 c3 = c1 + 1@$$return 1 + c3 * pow(x - 1, 3) + c1 * pow(x - 1, 2)@;1;Create;1;True;x;FLOAT;0;In;;Inherit;False;easeOutBack;True;False;0;;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;1036;-4850,128;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1042;-5154,224;Inherit;False;Constant;_minportalsize;_minportalsize;13;0;Create;True;0;0;0;False;0;False;0.2;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;779;-5010,128;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;777;-5154,128;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;776;-5298,128;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;782;-5586,240;Inherit;False;Property;_PortalRadius;PortalRadius;12;0;Create;True;0;0;0;False;0;False;2;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;784;-5555,128;Inherit;False;802;RawPlayerDistance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;770;-5138,368;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TransformPositionNode;809;-4898,368;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LengthOpNode;771;-4674,368;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;775;-4522,378;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;802;-4370,368;Inherit;False;RawPlayerDistance;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;642;-4834,944;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;641;-4978,944;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.11;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;638;-4290,944;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;640;-3762,944;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;672;-3602,944;Inherit;False;GlowMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;671;-4434,1136;Inherit;False;AlbedoMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;639;-4546,1008;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.25;False;2;FLOAT;0.68;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;620;-5394,880;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.OneMinusNode;624;-5282,864;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;755;-4642,800;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;1049;-4290,800;Inherit;False;FLOAT;1;0;FLOAT;0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SmoothstepOpNode;1064;-4834,800;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.03;False;2;FLOAT;0.19;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;643;-3986,944;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;0.35;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;886;-4290,1040;Inherit;False;Property;_InnerGlowThreshold;InnerGlowThreshold;10;0;Create;True;0;0;0;False;0;False;0.1204973;0.339;0;0.35;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;904;-4610,1136;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.15;False;2;FLOAT;0.42;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;617;-5570,880;Inherit;False;265;PurePolarUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;609;-5218,-864;Inherit;False;PureUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;608;-5426,-864;Inherit;False;1;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexCoordVertexDataNode;257;-5426,-992;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;258;-5426,-720;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;498;-4546,-1136;Inherit;True;Fresnel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;265;-5218,-992;Inherit;False;PurePolarUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;673;-4178,800;Inherit;False;Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;991;-5266,-305;Inherit;False;498;Fresnel;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;266;-4970,-710;Inherit;False;PureTime;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexToFragmentNode;1004;-5224,-645;Inherit;False;False;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;752;-4978,800;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;2.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;973;-4949,-52;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexToFragmentNode;1001;-4747,-1024;Inherit;False;False;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;497;-4898,-1136;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;494;-5426,-1136;Inherit;False;1;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;495;-5218,-1136;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;496;-5058,-1136;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;1,1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;466;1552,-112;Float;False;True;-1;2;ASEMaterialInspector;100;5;Portal;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;2;5;False;;10;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;RenderType=Transparent=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;0;638360090218178677;0;1;True;False;;False;0
Node;AmplifyShaderEditor.VertexToFragmentNode;831;708,501;Inherit;False;True;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;783;382,496;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;1012;126,576;Inherit;False;1011;PlayerMaskScale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;747;-3539,-1417;Inherit;False;1;683;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;1078;-3324.191,-1437.462;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;1080;-3173.191,-1393.462;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;676;474.8039,-4.89972;Inherit;False;673;Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GammaToLinearNode;1048;680.0332,58.90878;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GammaToLinearNode;1051;525,-620;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;686;212.1001,181.1999;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;693;-43.09999,195.9001;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;-2,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;674;206,-64;Inherit;False;671;AlbedoMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;789;-270,-104;Inherit;False;1037;PlayerAlbedoMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;885;-140,45;Inherit;False;Constant;_Float4;Float 4;13;0;Create;True;0;0;0;False;0;False;0.65;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;666;136,-454;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LinearToGammaNode;1045;-103.2,-726.5999;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;1027;-686,-257;Inherit;False;1025;InnerTexture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;901;-491,-254;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;902;-325,-248;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;677;-306,-331;Inherit;False;672;GlowMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;626;-610,-768;Inherit;False;Property;_OuterColor1;OuterColor1;7;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;0,0.08347726,0.9965097,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;627;-610,-592;Inherit;False;Property;_OuterColor2;OuterColor2;8;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;6.388918,12.51163,19.61043,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;931;0;929;0
WireConnection;931;1;1006;0
WireConnection;929;0;934;0
WireConnection;929;1;1034;0
WireConnection;723;0;722;0
WireConnection;723;1;721;0
WireConnection;869;0;723;0
WireConnection;869;1;1006;0
WireConnection;932;0;931;0
WireConnection;934;0;722;0
WireConnection;540;0;741;0
WireConnection;540;2;740;0
WireConnection;540;1;1005;0
WireConnection;534;1;540;0
WireConnection;703;0;1080;0
WireConnection;703;1;704;0
WireConnection;683;1;703;0
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
WireConnection;926;1;938;0
WireConnection;943;0;678;2
WireConnection;943;1;937;2
WireConnection;943;2;1017;0
WireConnection;927;0;615;3
WireConnection;927;1;926;3
WireConnection;927;2;1017;0
WireConnection;1025;0;714;0
WireConnection;714;0;943;0
WireConnection;625;0;626;0
WireConnection;625;1;627;0
WireConnection;625;2;628;0
WireConnection;1034;0;721;0
WireConnection;682;0;1051;0
WireConnection;682;1;788;0
WireConnection;682;2;674;0
WireConnection;661;0;1045;0
WireConnection;661;1;666;0
WireConnection;628;0;1055;0
WireConnection;632;0;1024;0
WireConnection;632;1;633;0
WireConnection;539;0;534;0
WireConnection;537;0;539;0
WireConnection;537;1;538;0
WireConnection;537;2;1008;0
WireConnection;601;0;537;0
WireConnection;1055;0;632;0
WireConnection;484;0;682;0
WireConnection;484;3;1054;0
WireConnection;788;0;1061;0
WireConnection;788;1;789;0
WireConnection;788;2;885;0
WireConnection;1061;0;712;0
WireConnection;1061;1;712;0
WireConnection;711;0;683;0
WireConnection;1054;0;676;0
WireConnection;875;0;869;0
WireConnection;1023;0;927;0
WireConnection;1060;0;788;0
WireConnection;1065;1;683;0
WireConnection;1067;0;1065;0
WireConnection;1046;0;658;0
WireConnection;708;1;709;0
WireConnection;786;0;686;0
WireConnection;786;1;783;0
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
WireConnection;975;0;971;0
WireConnection;975;1;971;0
WireConnection;975;2;971;0
WireConnection;975;3;971;0
WireConnection;1011;0;895;0
WireConnection;1037;0;779;0
WireConnection;1007;0;1003;0
WireConnection;1016;0;823;0
WireConnection;995;0;991;0
WireConnection;1003;0;996;0
WireConnection;1003;2;1030;0
WireConnection;996;0;995;0
WireConnection;1015;0;975;0
WireConnection;778;0;1036;0
WireConnection;979;0;1003;0
WireConnection;825;0;823;0
WireConnection;895;0;1036;0
WireConnection;1036;0;779;0
WireConnection;1036;1;1042;0
WireConnection;779;0;777;0
WireConnection;777;0;776;0
WireConnection;776;0;784;0
WireConnection;776;1;782;0
WireConnection;809;0;770;0
WireConnection;771;0;809;0
WireConnection;775;0;771;0
WireConnection;802;0;775;0
WireConnection;642;0;641;0
WireConnection;641;0;624;0
WireConnection;638;0;642;0
WireConnection;638;1;639;0
WireConnection;640;0;643;0
WireConnection;672;0;640;0
WireConnection;671;0;904;0
WireConnection;639;0;642;0
WireConnection;620;0;617;0
WireConnection;624;0;620;1
WireConnection;755;0;1064;0
WireConnection;1049;0;755;0
WireConnection;1064;0;752;0
WireConnection;643;0;638;0
WireConnection;643;1;886;0
WireConnection;904;0;642;0
WireConnection;609;0;608;0
WireConnection;498;0;497;0
WireConnection;265;0;257;0
WireConnection;673;0;1049;0
WireConnection;266;0;258;0
WireConnection;1004;0;258;0
WireConnection;752;0;624;0
WireConnection;973;0;971;0
WireConnection;973;1;1031;0
WireConnection;1001;0;497;0
WireConnection;497;0;496;0
WireConnection;495;0;494;0
WireConnection;496;0;495;0
WireConnection;466;0;484;0
WireConnection;466;1;786;0
WireConnection;831;0;786;0
WireConnection;783;0;785;0
WireConnection;783;1;1012;0
WireConnection;1078;0;747;1
WireConnection;1080;0;1078;0
WireConnection;1080;1;747;2
WireConnection;1048;0;676;0
WireConnection;1051;0;661;0
WireConnection;686;0;693;0
WireConnection;686;1;687;0
WireConnection;693;0;905;0
WireConnection;693;1;1040;0
WireConnection;666;0;1046;0
WireConnection;666;1;677;0
WireConnection;666;2;902;0
WireConnection;1045;0;625;0
WireConnection;901;0;1027;0
WireConnection;902;0;901;0
ASEEND*/
//CHKSM=44D730EEE3557E6B2AC842308722AFEDEAFB2DF1