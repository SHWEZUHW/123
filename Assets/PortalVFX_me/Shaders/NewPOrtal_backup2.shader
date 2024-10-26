// Upgrade NOTE: upgraded instancing buffer 'NewPOrtal_backup2' to new syntax.

// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "NewPOrtal_backup2"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_FXTex("FXTex", 2D) = "white" {}
		_Color("Color", Color) = (0.6591351,0.1367925,1,0)
		_uv1VMax("uv1VMax", Float) = 0.35
		_uv1VMin("uv1VMin", Float) = 0.35
		_EdgeOffset("EdgeOffset", Vector) = (0,0,0,0)

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
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

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"
			#define ASE_NEEDS_VERT_COLOR
			#define ASE_NEEDS_VERT_POSITION


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
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
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform sampler2D _MainTex;
			uniform sampler2D _FXTex;
			uniform float2 _EdgeOffset;
			uniform float _uv1VMin;
			uniform float _uv1VMax;
			uniform float4 _Color;
			UNITY_INSTANCING_BUFFER_START(NewPOrtal_backup2)
			UNITY_INSTANCING_BUFFER_END(NewPOrtal_backup2)
			float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
			float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod2D289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}
			

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float4 temp_output_40_0 = saturate( v.color );
				float4 appendResult37 = (float4(0.0 , v.ase_normal.y , v.ase_normal.z , 0.0));
				float3 worldToObj50 = mul( unity_WorldToObject, float4( _WorldSpaceCameraPos, 1 ) ).xyz;
				float temp_output_52_0 = ( sqrt( length( worldToObj50 ) ) * 0.8 );
				float temp_output_57_0 = (-3.0 + (temp_output_52_0 - 0.0) * (-1.0 - -3.0) / (1.0 - 0.0));
				float clampResult59 = clamp( temp_output_57_0 , -1.0 , 0.0 );
				float clampResult54 = clamp( ( 1.0 - temp_output_52_0 ) , -0.6 , 0.0 );
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				o.ase_texcoord1.zw = v.ase_texcoord1.xy;
				o.ase_color = v.color;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = ( ( temp_output_40_0 * ( appendResult37 * clampResult59 ) ) + float4( ( v.vertex.xyz * clampResult54 ) , 0.0 ) ).rgb;
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
				float2 texCoord122 = i.ase_texcoord1.xy * float2( 0.65,1 ) + float2( 0.15,0 );
				float3 worldToObj50 = mul( unity_WorldToObject, float4( _WorldSpaceCameraPos, 1 ) ).xyz;
				float temp_output_52_0 = ( sqrt( length( worldToObj50 ) ) * 0.8 );
				float temp_output_57_0 = (-3.0 + (temp_output_52_0 - 0.0) * (-1.0 - -3.0) / (1.0 - 0.0));
				float clampResult189 = clamp( ( ( 1.0 - temp_output_57_0 ) - 0.5 ) , 0.1 , 1.0 );
				float temp_output_147_0 = ( clampResult189 / 1.0 );
				float2 _Vector1 = float2(0.5,0.5);
				float2 texCoord2 = i.ase_texcoord1.zw * float2( 1,1 ) + _EdgeOffset;
				float2 panner119 = ( _Time.y * float2( 1,0 ) + texCoord2);
				float4 tex2DNode114 = tex2D( _FXTex, panner119 );
				float2 panner123 = ( 0.5 * _Time.y * float2( 0,1 ) + texCoord122);
				float simplePerlin2D120 = snoise( panner123*5.0 );
				simplePerlin2D120 = simplePerlin2D120*0.5 + 0.5;
				float4 temp_output_40_0 = saturate( i.ase_color );
				float4 temp_output_127_0 = ( float4( ( (tex2DNode114).rgb + ( simplePerlin2D120 * 0.015 ) ) , 0.0 ) * ( ( 1.0 - temp_output_40_0 ) + float4( 0.2169811,0.2169811,0.2169811,0 ) ) );
				float smoothstepResult22 = smoothstep( _uv1VMin , _uv1VMax , texCoord2.y);
				float4 appendResult110 = (float4(( tex2D( _MainTex, ( float4( ( ( ( texCoord122 * temp_output_147_0 ) + float2( 0,0 ) ) - ( ( temp_output_147_0 * _Vector1 ) - _Vector1 ) ), 0.0 , 0.0 ) + ( temp_output_127_0 * clampResult189 ) ).rg ) * float4( 1,1,1,0 ) ).rgb , saturate( smoothstepResult22 )));
				float4 appendResult135 = (float4(saturate( ( tex2DNode114 * _Color ) ).rgb , tex2D( _FXTex, panner119 ).r));
				
				
				finalColor = ( appendResult110 + appendResult135 );
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
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;127;-785.6219,-258.5735;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;694.2155,920.4197;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;427.1208,1060.36;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-66.00795,-364.63;Inherit;False;Property;_Float2;Float 2;4;0;Create;True;0;0;0;False;0;False;0;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;88;-71.77046,-291.369;Inherit;False;Property;_Float3;Float 2;5;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;98.33147,-677.689;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;0;False;0;False;-1;None;dc3502c2ef1bb2c439775048c6463b11;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;97;-25.8638,-654.3907;Inherit;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;38;-1961.778,964.7357;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;139;-2005.762,468.3588;Inherit;False;Property;_uv1VMin;uv1VMin;8;0;Create;True;0;0;0;False;0;False;0.35;1.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;134;425.4489,98.74373;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;148;-609.9736,-1228.521;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;149;-664.0986,-1428.26;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;150;-459.8645,-1429.25;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;153;-285.8214,-1427.777;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;156;-447.1516,-1132.337;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;152;-964.8752,-1417.414;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;154;-786.3544,-1112.481;Inherit;False;Constant;_Vector1;Vector 0;0;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleDivideOpNode;147;-790.0654,-1227.907;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;191;-413.2767,235.492;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;49;-1326.841,1299.947;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TransformPositionNode;50;-1057.336,1201.108;Inherit;True;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LengthOpNode;51;-805.3572,1180.17;Inherit;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;143;-936.3576,1612.383;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;2;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;188;-566.558,252.2075;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;155;-1056.013,-1193.892;Inherit;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;25;1664.782,-191.834;Float;False;True;-1;2;ASEMaterialInspector;100;5;NewPOrtal_backup2;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;2;5;False;;10;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;True;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;638376608808780375;0;1;True;False;;False;0
Node;AmplifyShaderEditor.RangedFloatNode;138;-1978.372,589.0219;Inherit;False;Property;_uv1VMax;uv1VMax;7;0;Create;True;0;0;0;False;0;False;0.35;0.45;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;193;1493.212,-280.306;Inherit;False;192;TEST;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;195;-2431.691,-168.4014;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;133;145.4492,172.7437;Inherit;False;Property;_Color;Color;6;0;Create;True;0;0;0;False;0;False;0.6591351,0.1367925,1,0;1,0.4470588,0.9666867,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;53;179.7106,1630.527;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;42;472.9633,1469.154;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SqrtOpNode;144;-630.2936,1170.311;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;140;1335.125,-309.7068;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;44;1496.081,-81.60069;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;754.5793,1498.327;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;54;436.6888,1649.635;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.6;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;16;192.057,-165.7555;Inherit;True;Property;_FXTex;FXTex;1;0;Create;True;0;0;0;False;0;False;-1;None;1ad9b7888055c8740adc124c6aff185b;True;1;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;199;538.6509,-157.92;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;135;712.0458,-88.30357;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;110;1001.434,-625.3939;Inherit;True;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SmoothstepOpNode;22;-58.43628,538.1738;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.49;False;2;FLOAT;0.35;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;201;666.2747,82.24412;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;128;-1516.258,224.1925;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;121;-1060.048,-286.2085;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;120;-1515.224,-344.8703;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;1,1;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;40;-1756.854,945.588;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;205;-1102.605,160.207;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.2169811,0.2169811,0.2169811,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;192;-829.975,366.0781;Inherit;False;TEST;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;104;-374.6613,-401.5322;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;114;-1684.682,-79.33846;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;1ad9b7888055c8740adc124c6aff185b;1ad9b7888055c8740adc124c6aff185b;True;1;False;white;Auto;False;Instance;16;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;119;-2085.315,120.663;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;123;-1747.136,-301.2703;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,1;False;1;FLOAT;0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;99;-1302.15,-64.04473;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;124;-1287.106,-333.5423;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.015;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;209;-2445.52,-484.0081;Inherit;False;Property;_Tiling;Tiling;11;0;Create;True;0;0;0;False;0;False;0,0;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;210;-2439.52,-343.0081;Inherit;False;Property;_Offset;Offset;10;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-439.3723,1168.507;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;189;-277.2482,221.5774;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;122;-2108.794,-300.7094;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.65,1;False;1;FLOAT2;0.15,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;212;-2968.979,384.025;Inherit;False;InstancedProperty;_Spawn;Spawn;12;0;Create;True;0;0;0;False;0;False;0.25;0.796;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;211;-2621.979,346.025;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;145;-2866.286,155.9642;Inherit;False;Property;_EdgeOffset;EdgeOffset;9;0;Create;True;0;0;0;False;0;False;0,0;0,0.48;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-2398.227,123.5843;Inherit;True;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;34;-32.01619,1013.762;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;37;162.4664,999.075;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;58;-234.6036,1432.09;Inherit;False;Property;_DistanceMax;DistanceMax;3;0;Create;True;0;0;0;False;0;False;0;-0.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-256.2942,1337.577;Inherit;False;Property;_DistanceMin;DistanceMin;2;0;Create;True;0;0;0;False;0;False;0;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;57;-12.23032,1184.385;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-3;False;4;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;113;511.5965,-450.0891;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;86;91.4491,-438.82;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.5;False;4;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;108;347.4457,-478.8544;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;59;324.0632,1204.399;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;673.6699,-659.2163;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;1,1,1,0;False;1;COLOR;0
WireConnection;127;0;121;0
WireConnection;127;1;205;0
WireConnection;39;0;40;0
WireConnection;39;1;35;0
WireConnection;35;0;37;0
WireConnection;35;1;59;0
WireConnection;1;1;97;0
WireConnection;97;0;153;0
WireConnection;97;1;104;0
WireConnection;134;0;114;0
WireConnection;134;1;133;0
WireConnection;148;0;147;0
WireConnection;148;1;154;0
WireConnection;149;0;122;0
WireConnection;149;1;147;0
WireConnection;150;0;149;0
WireConnection;153;0;150;0
WireConnection;153;1;156;0
WireConnection;156;0;148;0
WireConnection;156;1;154;0
WireConnection;147;0;189;0
WireConnection;147;1;155;0
WireConnection;191;0;188;0
WireConnection;50;0;49;0
WireConnection;51;0;50;0
WireConnection;188;0;57;0
WireConnection;25;0;140;0
WireConnection;25;1;44;0
WireConnection;53;0;52;0
WireConnection;144;0;51;0
WireConnection;140;0;110;0
WireConnection;140;1;135;0
WireConnection;44;0;39;0
WireConnection;44;1;43;0
WireConnection;43;0;42;0
WireConnection;43;1;54;0
WireConnection;54;0;53;0
WireConnection;16;1;119;0
WireConnection;199;0;134;0
WireConnection;135;0;199;0
WireConnection;135;3;16;0
WireConnection;110;0;109;0
WireConnection;110;3;201;0
WireConnection;22;0;2;2
WireConnection;22;1;139;0
WireConnection;22;2;138;0
WireConnection;201;0;22;0
WireConnection;128;0;40;0
WireConnection;121;0;99;0
WireConnection;121;1;124;0
WireConnection;120;0;123;0
WireConnection;40;0;38;0
WireConnection;205;0;128;0
WireConnection;192;0;127;0
WireConnection;104;0;127;0
WireConnection;104;1;189;0
WireConnection;114;1;119;0
WireConnection;119;0;2;0
WireConnection;119;1;195;0
WireConnection;123;0;122;0
WireConnection;99;0;114;0
WireConnection;124;0;120;0
WireConnection;52;0;144;0
WireConnection;189;0;191;0
WireConnection;211;1;212;0
WireConnection;2;1;145;0
WireConnection;37;1;34;2
WireConnection;37;2;34;3
WireConnection;57;0;52;0
WireConnection;113;0;108;0
WireConnection;86;3;87;0
WireConnection;86;4;88;0
WireConnection;108;0;86;0
WireConnection;59;0;57;0
WireConnection;109;0;1;0
ASEEND*/
//CHKSM=BBD77E65F6CD1999488810BBB0CA482DF55C88A2