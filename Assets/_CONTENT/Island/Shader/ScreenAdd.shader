// Upgrade NOTE: upgraded instancing buffer 'ScreenAdd' to new syntax.

// Made with Amplify Shader Editor v1.9.3.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ScreenAdd"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_Mask("Mask", 2D) = "white" {}
		_softedge("softedge", Range( 0 , 0.3)) = 0
		_videocontrast("videocontrast", Range( -1 , 0)) = 0
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
			

			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
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

			uniform sampler2D _MainTex;
			uniform float _softedge;
			uniform sampler2D _Mask;
			UNITY_INSTANCING_BUFFER_START(ScreenAdd)
				UNITY_DEFINE_INSTANCED_PROP(float4, _MainTex_ST)
#define _MainTex_ST_arr ScreenAdd
				UNITY_DEFINE_INSTANCED_PROP(float4, _Mask_ST)
#define _Mask_ST_arr ScreenAdd
				UNITY_DEFINE_INSTANCED_PROP(float, _videocontrast)
#define _videocontrast_arr ScreenAdd
			UNITY_INSTANCING_BUFFER_END(ScreenAdd)
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

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
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
				float4 _MainTex_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_MainTex_ST_arr, _MainTex_ST);
				float2 uv_MainTex = i.ase_texcoord1.xy * _MainTex_ST_Instance.xy + _MainTex_ST_Instance.zw;
				float3 hsvTorgb9 = RGBToHSV( tex2D( _MainTex, uv_MainTex ).rgb );
				float _videocontrast_Instance = UNITY_ACCESS_INSTANCED_PROP(_videocontrast_arr, _videocontrast);
				float3 hsvTorgb10 = HSVToRGB( float3(hsvTorgb9.x,hsvTorgb9.y,(_videocontrast_Instance + (hsvTorgb9.z - 0.0) * (( 1.0 - _videocontrast_Instance ) - _videocontrast_Instance) / (1.0 - 0.0))) );
				float4 _Mask_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_Mask_ST_arr, _Mask_ST);
				float2 uv_Mask = i.ase_texcoord1.xy * _Mask_ST_Instance.xy + _Mask_ST_Instance.zw;
				float smoothstepResult18 = smoothstep( -0.0001 , _softedge , tex2D( _Mask, uv_Mask ).r);
				
				
				finalColor = float4( saturate( ( hsvTorgb10 * smoothstepResult18 ) ) , 0.0 );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	Fallback Off
}
/*ASEBEGIN
Version=19302
Node;AmplifyShaderEditor.SamplerNode;1;-798,-312.5;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;0;False;0;False;-1;None;9fcb8cf15a79d7949b513ea805fabad0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;5;-802.7328,-9.408203;Inherit;False;InstancedProperty;_videocontrast;videocontrast;3;0;Create;True;0;0;0;True;0;False;0;0;-1;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RGBToHSVNode;9;-507,-433.5;Inherit;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;15;-464,46.5;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-119,-155.5;Inherit;True;Property;_Mask;Mask;1;0;Create;True;0;0;0;False;0;False;-1;None;f4bbe2a5c741af640b7f81dfdd5119fb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;12;-295,-266.5;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-108.476,31.2179;Inherit;False;Property;_softedge;softedge;2;0;Create;True;0;0;0;True;0;False;0;0.3;0;0.3;0;1;FLOAT;0
Node;AmplifyShaderEditor.HSVToRGBNode;10;-66,-409.5;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SmoothstepOpNode;18;187.524,-130.7821;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;-0.0001;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;379.524,-187.7821;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;13;529,-188.5;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;4;677,-191;Float;False;True;-1;2;ASEMaterialInspector;100;5;ScreenAdd;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;4;1;False;;1;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;2;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
WireConnection;9;0;1;0
WireConnection;15;0;5;0
WireConnection;12;0;9;3
WireConnection;12;3;5;0
WireConnection;12;4;15;0
WireConnection;10;0;9;1
WireConnection;10;1;9;2
WireConnection;10;2;12;0
WireConnection;18;0;2;1
WireConnection;18;2;17;0
WireConnection;19;0;10;0
WireConnection;19;1;18;0
WireConnection;13;0;19;0
WireConnection;4;0;13;0
ASEEND*/
//CHKSM=BDA2CB6AAE9D9F22AAE00363806647A8A8F61765