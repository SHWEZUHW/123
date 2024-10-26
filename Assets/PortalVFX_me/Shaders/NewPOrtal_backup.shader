// Upgrade NOTE: upgraded instancing buffer 'NewPOrtalBackup' to new syntax.

// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "NewPOrtalBackup"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_FXTex("FXTex", 2D) = "white" {}
		_Float0("Float 0", Float) = 0
		_Float1("Float 0", Float) = 0
		_TimeScale("TimeScale", Float) = 0
		_Float2("Float 2", Float) = 0
		_Float3("Float 2", Float) = 0
		_Distortion("Distortion", Float) = 0
		_Scale("Scale", Range( 0 , 1)) = 0
		_MaskPower("MaskPower", Float) = 5

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
			#include "UnityStandardBRDF.cginc"
			#define ASE_NEEDS_VERT_COLOR
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_FRAG_WORLD_POSITION


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_tangent : TANGENT;
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
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float _Float0;
			uniform float _Float1;
			uniform sampler2D _MainTex;
			uniform sampler2D _FXTex;
			uniform float _Float2;
			uniform float _Float3;
			UNITY_INSTANCING_BUFFER_START(NewPOrtalBackup)
				UNITY_DEFINE_INSTANCED_PROP(float, _Scale)
#define _Scale_arr NewPOrtalBackup
				UNITY_DEFINE_INSTANCED_PROP(float, _Distortion)
#define _Distortion_arr NewPOrtalBackup
				UNITY_DEFINE_INSTANCED_PROP(float, _TimeScale)
#define _TimeScale_arr NewPOrtalBackup
				UNITY_DEFINE_INSTANCED_PROP(float, _MaskPower)
#define _MaskPower_arr NewPOrtalBackup
			UNITY_INSTANCING_BUFFER_END(NewPOrtalBackup)
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
				float temp_output_52_0 = ( sqrt( length( worldToObj50 ) ) * 0.65 );
				float clampResult59 = clamp( (_Float0 + (temp_output_52_0 - 0.0) * (_Float1 - _Float0) / (1.0 - 0.0)) , -1.0 , 0.0 );
				float clampResult54 = clamp( ( 1.0 - temp_output_52_0 ) , -0.5 , 0.0 );
				
				float3 ase_worldTangent = UnityObjectToWorldDir(v.ase_tangent);
				o.ase_texcoord2.xyz = ase_worldTangent;
				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord3.xyz = ase_worldNormal;
				float ase_vertexTangentSign = v.ase_tangent.w * ( unity_WorldTransformParams.w >= 0.0 ? 1.0 : -1.0 );
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord4.xyz = ase_worldBitangent;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				o.ase_texcoord1.zw = v.ase_texcoord1.xy;
				o.ase_color = v.color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord2.w = 0;
				o.ase_texcoord3.w = 0;
				o.ase_texcoord4.w = 0;
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
				float2 texCoord122 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float3 ase_worldTangent = i.ase_texcoord2.xyz;
				float3 ase_worldNormal = i.ase_texcoord3.xyz;
				float3 ase_worldBitangent = i.ase_texcoord4.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_tanViewDir =  tanToWorld0 * ase_worldViewDir.x + tanToWorld1 * ase_worldViewDir.y  + tanToWorld2 * ase_worldViewDir.z;
				ase_tanViewDir = Unity_SafeNormalize( ase_tanViewDir );
				float4 appendResult94 = (float4(( ( ase_tanViewDir.x + 0.75 ) * 0.75 ) , ( ase_tanViewDir.y + 0.5 ) , 0.0 , 0.0));
				float _Scale_Instance = UNITY_ACCESS_INSTANCED_PROP(_Scale_arr, _Scale);
				float4 lerpResult125 = lerp( float4( texCoord122, 0.0 , 0.0 ) , ( 1.0 - appendResult94 ) , _Scale_Instance);
				float2 texCoord2 = i.ase_texcoord1.zw * float2( 1,1 ) + float2( 0,0 );
				float2 panner119 = ( 0.7 * _Time.y * float2( 2,0 ) + texCoord2);
				float2 panner123 = ( 0.5 * _Time.y * float2( 0,1 ) + texCoord122);
				float simplePerlin2D120 = snoise( panner123*8.54 );
				simplePerlin2D120 = simplePerlin2D120*0.5 + 0.5;
				float4 temp_output_40_0 = saturate( i.ase_color );
				float _Distortion_Instance = UNITY_ACCESS_INSTANCED_PROP(_Distortion_arr, _Distortion);
				float3 worldToObj50 = mul( unity_WorldToObject, float4( _WorldSpaceCameraPos, 1 ) ).xyz;
				float temp_output_52_0 = ( sqrt( length( worldToObj50 ) ) * 0.65 );
				float clampResult113 = clamp( ( 1.0 - (_Float2 + (temp_output_52_0 - 0.0) * (_Float3 - _Float2) / (1.0 - 0.0)) ) , 0.25 , 1.0 );
				float4 appendResult110 = (float4(( tex2D( _MainTex, ( lerpResult125 + float4( ( ( ( (tex2D( _FXTex, panner119 )).rgb + ( simplePerlin2D120 * 0.015 ) ) * (0.1 + ((( 1.0 - temp_output_40_0 )).r - 0.0) * (1.0 - 0.1) / (1.0 - 0.0)) ) * _Distortion_Instance ) , 0.0 ) ).xy ) * clampResult113 ).rgb , 1.0));
				float _TimeScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_TimeScale_arr, _TimeScale);
				float mulTime46 = _Time.y * _TimeScale_Instance;
				float2 panner41 = ( mulTime46 * float2( 2,0 ) + texCoord2);
				float4 tex2DNode16 = tex2D( _FXTex, panner41 );
				float smoothstepResult22 = smoothstep( 0.0 , 0.35 , texCoord2.y);
				float _MaskPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_MaskPower_arr, _MaskPower);
				float4 lerpResult20 = lerp( appendResult110 , ( tex2DNode16 + tex2DNode16 ) , ( 1.0 - pow( smoothstepResult22 , _MaskPower_Instance ) ));
				
				
				finalColor = lerpResult20;
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
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;25;1133.782,-163.834;Float;False;True;-1;2;ASEMaterialInspector;100;5;NewPOrtalBackup;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;2;5;False;;10;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;True;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;638376608808780375;0;1;True;False;;False;0
Node;AmplifyShaderEditor.SimpleAddOpNode;44;1308.081,183.3993;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-2197.492,166.134;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;127;-785.6219,-258.5735;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;100;-564.0918,-227.3138;Inherit;False;InstancedProperty;_Distortion;Distortion;7;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;119;-1900.851,83.19951;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;2,0;False;1;FLOAT;0.7;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;20;941.0832,-166.2363;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;125;-640.9218,-668.8497;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;126;-927.8797,-529.6858;Inherit;False;InstancedProperty;_Scale;Scale;8;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;92;-841.5771,-798.7209;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;96;-1161.847,-913.7567;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.75;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;93;-1272.873,-914.7299;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.75;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;95;-1163.605,-815.6093;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;94;-1021.342,-909.0855;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;91;-1451.356,-905.2732;Inherit;False;Tangent;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;122;-2011.794,-355.7094;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;114;-1705.45,61.7212;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;1;False;white;Auto;False;Instance;16;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwizzleNode;99;-1415.988,78.21318;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PannerNode;123;-1766.136,-235.2703;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,1;False;1;FLOAT;0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;120;-1536.024,-177.1705;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;1,1;False;1;FLOAT;8.54;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;124;-1283.601,-137.6537;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.015;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;121;-1063.048,-161.2085;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;48;781.5629,-65.00774;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-88.06073,77.04385;Inherit;False;InstancedProperty;_TimeScale;TimeScale;4;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;41;262.65,6.23185;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;2,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;46;73.59737,76.54766;Inherit;False;1;0;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;16;462.6001,10.45322;Inherit;True;Property;_FXTex;FXTex;1;0;Create;True;0;0;0;False;0;False;-1;None;1f546a765e64ba148956ce50a709f3c0;True;1;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;694.2155,920.4197;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;34;30.98381,1031.762;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;427.1208,1060.36;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;37;243.4664,1034.075;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ClampOpNode;59;258.0632,1196.399;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;57;-12.23032,1184.385;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.5;False;4;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;49;-1115.861,1327.378;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TransformPositionNode;50;-800.3554,1351.539;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LengthOpNode;51;-585.3758,1352.601;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-201.2942,1268.577;Inherit;False;Property;_Float0;Float 0;2;0;Create;True;0;0;0;False;0;False;0;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;58;-218.6036,1343.09;Inherit;False;Property;_Float1;Float 0;3;0;Create;True;0;0;0;False;0;False;0;-0.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;53;-173.7508,1451.502;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;42;497.5321,1250.781;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;720.8184,1389.302;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;54;466.307,1421.228;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.5;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;23;631.7192,283.3379;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;32;437.9793,299.2358;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;22;203.7681,355.1258;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.35;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;132;227.3448,475.6459;Inherit;False;InstancedProperty;_MaskPower;MaskPower;9;0;Create;True;0;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;110;832.4344,-427.3939;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;111;675.5704,-378.9748;Inherit;False;Constant;_Float4;Float 4;8;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;658.9255,-496.4147;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;113;511.5965,-448.5908;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.25;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;108;364.6277,-445.8544;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;86;91.4491,-438.82;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.5;False;4;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-66.00795,-364.63;Inherit;False;Property;_Float2;Float 2;5;0;Create;True;0;0;0;False;0;False;0;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;88;-71.77046,-291.369;Inherit;False;Property;_Float3;Float 2;6;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;98.33147,-677.689;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;0;False;0;False;-1;None;325032e82e6dda94181685143a53d37a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;97;-25.8638,-654.3907;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;104;-386.6613,-325.5322;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCRemapNode;130;-1033.645,86.53233;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;131;-1198.355,205.1955;Inherit;False;FLOAT;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;128;-1396.658,256.6927;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;38;-1961.778,964.7357;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;40;-1756.854,977.7619;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SqrtOpNode;133;-456.8545,1466.976;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-458.5721,1261.807;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.65;False;1;FLOAT;0
WireConnection;25;0;20;0
WireConnection;25;1;44;0
WireConnection;44;0;39;0
WireConnection;44;1;43;0
WireConnection;127;0;121;0
WireConnection;127;1;130;0
WireConnection;119;0;2;0
WireConnection;20;0;110;0
WireConnection;20;1;48;0
WireConnection;20;2;23;0
WireConnection;125;0;122;0
WireConnection;125;1;92;0
WireConnection;125;2;126;0
WireConnection;92;0;94;0
WireConnection;96;0;93;0
WireConnection;93;0;91;1
WireConnection;95;0;91;2
WireConnection;94;0;96;0
WireConnection;94;1;95;0
WireConnection;114;1;119;0
WireConnection;99;0;114;0
WireConnection;123;0;122;0
WireConnection;120;0;123;0
WireConnection;124;0;120;0
WireConnection;121;0;99;0
WireConnection;121;1;124;0
WireConnection;48;0;16;0
WireConnection;48;1;16;0
WireConnection;41;0;2;0
WireConnection;41;1;46;0
WireConnection;46;0;47;0
WireConnection;16;1;41;0
WireConnection;39;0;40;0
WireConnection;39;1;35;0
WireConnection;35;0;37;0
WireConnection;35;1;59;0
WireConnection;37;1;34;2
WireConnection;37;2;34;3
WireConnection;59;0;57;0
WireConnection;57;0;52;0
WireConnection;57;3;36;0
WireConnection;57;4;58;0
WireConnection;50;0;49;0
WireConnection;51;0;50;0
WireConnection;53;0;52;0
WireConnection;43;0;42;0
WireConnection;43;1;54;0
WireConnection;54;0;53;0
WireConnection;23;0;32;0
WireConnection;32;0;22;0
WireConnection;32;1;132;0
WireConnection;22;0;2;2
WireConnection;110;0;109;0
WireConnection;110;3;111;0
WireConnection;109;0;1;0
WireConnection;109;1;113;0
WireConnection;113;0;108;0
WireConnection;108;0;86;0
WireConnection;86;0;52;0
WireConnection;86;3;87;0
WireConnection;86;4;88;0
WireConnection;1;1;97;0
WireConnection;97;0;125;0
WireConnection;97;1;104;0
WireConnection;104;0;127;0
WireConnection;104;1;100;0
WireConnection;130;0;131;0
WireConnection;131;0;128;0
WireConnection;128;0;40;0
WireConnection;40;0;38;0
WireConnection;133;0;51;0
WireConnection;52;0;133;0
ASEEND*/
//CHKSM=901520A326F98DD0902EEBCB4A6FC74C98A51B31