// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AuroraBoreales"
{
	Properties
	{
		_NoiseScale("NoiseScale", Float) = 2.3
		_NoiseTiling("NoiseTiling", Vector) = (1,1,0,0)
		_NoiseSpeed("NoiseSpeed", Vector) = (0.18,0,0,0)
		_Mask("Mask", 2D) = "white" {}
		_DissolvePower("DissolvePower", Float) = 0
		_Color("Color", Color) = (0,0.9583419,0.2856235,0)
		[Toggle]_RainbowMode("RainbowMode", Float) = 1
		_ColorChangeSpeed("ColorChangeSpeed", Float) = 0.01
		_WobbleSpeed("WobbleSpeed", Float) = 1
		_WobbleFrequency("WobbleFrequency", Float) = 0
		_WobbleDistance("WobbleDistance", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend One One
		AlphaToMask Off
		Cull Off
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


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
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

			uniform float _WobbleSpeed;
			uniform float _WobbleFrequency;
			uniform float _WobbleDistance;
			uniform float _RainbowMode;
			uniform float4 _Color;
			uniform float _ColorChangeSpeed;
			uniform sampler2D _Mask;
			uniform float4 _Mask_ST;
			uniform float _NoiseScale;
			uniform float2 _NoiseTiling;
			uniform float2 _NoiseSpeed;
			uniform float _DissolvePower;
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
					float2 voronoihash11( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi11( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
						 		float2 o = voronoihash11( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = max(abs(r.x), abs(r.y));
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
			

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldPos = mul(unity_ObjectToWorld, float4( (v.vertex).xyz, 1 )).xyz;
				float4 appendResult60 = (float4(( ( sin( ( ( _Time.y * _WobbleSpeed ) + ( ase_worldPos.x * _WobbleFrequency ) ) ) * _WobbleDistance ) + v.ase_normal.x ) , 0.0 , v.ase_normal.z , 0.0));
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = appendResult60.xyz;
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
				float3 hsvTorgb26 = RGBToHSV( _Color.rgb );
				float3 hsvTorgb27 = HSVToRGB( float3(( hsvTorgb26.x + ( _Time.y * _ColorChangeSpeed ) ),hsvTorgb26.y,hsvTorgb26.z) );
				float2 uv_Mask = i.ase_texcoord1.xy * _Mask_ST.xy + _Mask_ST.zw;
				float time11 = 0.0;
				float2 voronoiSmoothId11 = 0;
				float2 texCoord2 = i.ase_texcoord1.xy * _NoiseTiling + ( _NoiseSpeed * _Time.y );
				float2 coords11 = texCoord2 * _NoiseScale;
				float2 id11 = 0;
				float2 uv11 = 0;
				float fade11 = 0.5;
				float voroi11 = 0;
				float rest11 = 0;
				for( int it11 = 0; it11 <2; it11++ ){
				voroi11 += fade11 * voronoi11( coords11, time11, id11, uv11, 0,voronoiSmoothId11 );
				rest11 += fade11;
				coords11 *= 2;
				fade11 *= 0.5;
				}//Voronoi11
				voroi11 /= rest11;
				
				
				finalColor = ( (( _RainbowMode )?( float4( hsvTorgb27 , 0.0 ) ):( _Color )) * ( tex2D( _Mask, uv_Mask ) * ( voroi11 * pow( voroi11 , _DissolvePower ) ) ) );
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
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-799,165.5;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-1137.836,329.5475;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;9;-1373.836,438.5475;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-702,364.5;Inherit;False;Property;_NoiseScale;NoiseScale;0;0;Create;True;0;0;0;False;0;False;2.3;3.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;11;-362.8357,380.5475;Inherit;True;0;3;1;3;2;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.PowerNode;21;-161.9159,434.9233;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;3.35;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-7.415962,350.7234;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;103.0643,141.3473;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RGBToHSVNode;26;-67.95923,-432.0873;Inherit;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.HSVToRGBNode;27;439.0408,-374.0873;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;28;251.0408,-465.0873;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;30;302.6531,-139.4014;Inherit;False;Property;_RainbowMode;RainbowMode;6;0;Create;True;0;0;0;False;0;False;1;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;12;-418.8357,-64.45251;Inherit;True;Property;_Mask;Mask;3;0;Create;True;0;0;0;False;0;False;-1;None;a83277b918604c147bddf4ade99dca94;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;126.0183,-204.7105;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-250.3469,-175.4014;Inherit;False;Property;_ColorChangeSpeed;ColorChangeSpeed;7;0;Create;True;0;0;0;False;0;False;0.01;0.001;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;762.96,1630.465;Inherit;False;2;2;0;FLOAT3;1,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;34;-106.7104,1492.352;Inherit;False;False;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;35;178.9684,1409.516;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-419.2972,1347.829;Float;False;Property;_WindSpeed;Wind Speed;9;0;Create;True;0;0;0;False;0;False;0.01;0.01;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;38;-348.4012,1150.296;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-19.36231,1285.317;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;40;616.0121,1389.041;Inherit;True;Property;_OffsetGuide;Offset Guide;8;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;41;-345.4742,1473.08;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;42;469.7045,1602.684;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;1076.412,1386.563;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;32;425.3887,1758.494;Float;False;Property;_WaveHeight;Wave Height;10;0;Create;True;0;0;0;False;0;False;0.01;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;44;556.6356,1869.053;Inherit;False;World Normal Face;-1;;1;8ad4248928242e14ab87cd99e6913c33;1,86,1;0;1;FLOAT3;30
Node;AmplifyShaderEditor.RangedFloatNode;45;472.4706,899.4879;Inherit;False;Property;_Float0;Float 0;11;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;1049.213,761.6603;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;36;367.5796,1373.617;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;868.4607,496.1724;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;16;223.1172,762.9303;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;49;21.21979,610.6674;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;48;308.4272,601.1819;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1.49;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;51;543.6258,507.8237;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.NormalVertexDataNode;24;178.464,478.0125;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;17;-277.8828,648.9303;Inherit;False;Property;_DissolvePower;DissolvePower;4;0;Create;True;0;0;0;False;0;False;0;1.27;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TransformPositionNode;59;1423.675,576.1139;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;54;1203.809,556.8394;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;64;1161.632,363.7692;Inherit;False;Property;_WobbleFrequency;WobbleFrequency;13;0;Create;True;0;0;0;False;0;False;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;1174.632,277.7692;Inherit;False;Property;_WobbleSpeed;WobbleSpeed;12;0;Create;True;0;0;0;False;0;False;1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;60;2278.279,695.493;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;1353.617,149.4715;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;1511.632,341.7692;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;65;1694.082,250.3222;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;66;1862.199,289.2541;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;2061.641,286.0615;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;68;1798.641,395.0615;Inherit;False;Property;_WobbleDistance;WobbleDistance;14;0;Create;True;0;0;0;False;0;False;0;12.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;25;-363.9592,-436.0873;Inherit;False;Property;_Color;Color;5;0;Create;True;0;0;0;False;0;False;0,0.9583419,0.2856235,0;0.2707355,0.9401911,0.2067434,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;2585.788,-38.15587;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;69;2930.271,226.3613;Float;False;True;-1;2;ASEMaterialInspector;100;5;AuroraBoreales;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;4;1;False;;1;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;2;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.SimpleAddOpNode;57;2012.109,500.2137;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.57;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;70;1682.703,794.5375;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TangentVertexDataNode;71;1702.277,989.4166;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;6;-1170.836,184.5475;Inherit;False;Property;_NoiseTiling;NoiseTiling;1;0;Create;True;0;0;0;False;0;False;1,1;23.04,0.2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;7;-1365.836,320.5475;Inherit;False;Property;_NoiseSpeed;NoiseSpeed;2;0;Create;True;0;0;0;False;0;False;0.18,0;0,-0.08;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
WireConnection;2;0;6;0
WireConnection;2;1;10;0
WireConnection;10;0;7;0
WireConnection;10;1;9;0
WireConnection;11;0;2;0
WireConnection;11;2;4;0
WireConnection;21;0;11;0
WireConnection;21;1;17;0
WireConnection;20;0;11;0
WireConnection;20;1;21;0
WireConnection;13;0;12;0
WireConnection;13;1;20;0
WireConnection;26;0;25;0
WireConnection;27;0;28;0
WireConnection;27;1;26;2
WireConnection;27;2;26;3
WireConnection;28;0;26;1
WireConnection;28;1;29;0
WireConnection;30;0;25;0
WireConnection;30;1;27;0
WireConnection;29;0;9;0
WireConnection;29;1;31;0
WireConnection;33;0;44;30
WireConnection;33;1;32;0
WireConnection;34;0;41;0
WireConnection;35;0;39;0
WireConnection;35;1;34;0
WireConnection;39;0;38;0
WireConnection;39;1;37;0
WireConnection;40;1;36;0
WireConnection;43;0;40;1
WireConnection;43;1;33;0
WireConnection;47;0;40;1
WireConnection;47;1;46;0
WireConnection;46;0;24;0
WireConnection;46;1;16;0
WireConnection;16;0;48;0
WireConnection;16;1;45;0
WireConnection;48;0;49;0
WireConnection;51;0;24;1
WireConnection;51;1;24;2
WireConnection;59;0;54;0
WireConnection;60;0;57;0
WireConnection;60;2;70;3
WireConnection;61;0;9;0
WireConnection;61;1;62;0
WireConnection;63;0;54;1
WireConnection;63;1;64;0
WireConnection;65;0;61;0
WireConnection;65;1;63;0
WireConnection;66;0;65;0
WireConnection;67;0;66;0
WireConnection;67;1;68;0
WireConnection;5;0;30;0
WireConnection;5;1;13;0
WireConnection;69;0;5;0
WireConnection;69;1;60;0
WireConnection;57;0;67;0
WireConnection;57;1;70;1
ASEEND*/
//CHKSM=D202A22D29EA2FC10DCE0FADB9A9E90FF03AD071