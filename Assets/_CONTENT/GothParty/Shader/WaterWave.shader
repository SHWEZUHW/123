// Made with Amplify Shader Editor v1.9.4
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "WaterWave"
{
	Properties
	{
		_MainNormal("MainNormal", 2D) = "white" {}
		_Tiling("Tiling", Float) = 1
		_Speed("Speed", Range( 0 , 0.1)) = 0.01
		_ReflectionProbeTex("ReflectionProbeTex", CUBE) = "white" {}
		_Color("Color", Color) = (0,0,0,0)
		_SmallWaveHight("SmallWaveHight", Float) = 0
		_WaveSpeed("WaveSpeed", Range( 0 , 5)) = 0
		_WaveHight("WaveHight", Range( 0 , 1)) = 0
		_Gloss("Gloss", Float) = 0
		_RippleCentre("RippleCentre", Vector) = (0,0,0,0)

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
			#include "UnityStandardUtils.cginc"
			#define ASE_NEEDS_VERT_COLOR
			#define ASE_NEEDS_FRAG_WORLD_POSITION


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_tangent : TANGENT;
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
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float3 _RippleCentre;
			uniform float _WaveSpeed;
			uniform float _WaveHight;
			uniform sampler2D _MainNormal;
			uniform float _Speed;
			uniform float _Tiling;
			uniform float _SmallWaveHight;
			uniform float _Gloss;
			uniform samplerCUBE _ReflectionProbeTex;
			uniform float4 _Color;
			float4 CalculateContrast( float contrastValue, float4 colorTarget )
			{
				float t = 0.5 * ( 1.0 - contrastValue );
				return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
			}

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldPos = mul(unity_ObjectToWorld, float4( (v.vertex).xyz, 1 )).xyz;
				float4 appendResult98 = (float4(( ase_worldPos.x + _RippleCentre.x ) , ( ase_worldPos.y + _RippleCentre.y ) , ( ase_worldPos.z + _RippleCentre.z ) , 0.0));
				float4 transform97 = mul(unity_WorldToObject,appendResult98);
				float mulTime88 = _Time.y * _WaveSpeed;
				float2 temp_cast_1 = (_Speed).xx;
				float2 temp_cast_2 = (_Tiling).xx;
				float2 texCoord3 = v.ase_texcoord.xyz * temp_cast_2 + float2( 0,0 );
				float2 panner1 = ( 1.0 * _Time.y * temp_cast_1 + texCoord3);
				float2 temp_cast_4 = (-_Speed).xx;
				float cos19 = cos( 0.001 * _Time.y );
				float sin19 = sin( 0.001 * _Time.y );
				float2 rotator19 = mul( texCoord3 - float2( 0.5,0.5 ) , float2x2( cos19 , -sin19 , sin19 , cos19 )) + float2( 0.5,0.5 );
				float2 panner2 = ( 1.0 * _Time.y * temp_cast_4 + rotator19);
				float3 temp_output_15_0 = BlendNormals( tex2Dlod( _MainNormal, float4( panner1, 0, 0.0) ).rgb , tex2Dlod( _MainNormal, float4( panner2, 0, 0.0) ).rgb );
				float3 lerpResult108 = lerp( float3( 0,0,0 ) , ( v.ase_normal * ( ( sin( ( ( ( 1.0 - ( distance( float4( float2( 0.58,1.38 ), 0.0 , 0.0 ) , transform97 ) * 0.1 ) ) + frac( mulTime88 ) ) * 6.28318548202515 ) ) * _WaveHight ) + ( (temp_output_15_0).x * _SmallWaveHight ) ) ) , v.color.r);
				
				float3 ase_worldTangent = UnityObjectToWorldDir(v.ase_tangent);
				o.ase_texcoord2.xyz = ase_worldTangent;
				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord3.xyz = ase_worldNormal;
				float ase_vertexTangentSign = v.ase_tangent.w * ( unity_WorldTransformParams.w >= 0.0 ? 1.0 : -1.0 );
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord4.xyz = ase_worldBitangent;
				
				o.ase_texcoord1.xyz = v.ase_texcoord.xyz;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.w = 0;
				o.ase_texcoord2.w = 0;
				o.ase_texcoord3.w = 0;
				o.ase_texcoord4.w = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = lerpResult108;
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
				float2 temp_cast_0 = (_Speed).xx;
				float2 temp_cast_1 = (_Tiling).xx;
				float2 texCoord3 = i.ase_texcoord1.xyz.xy * temp_cast_1 + float2( 0,0 );
				float2 panner1 = ( 1.0 * _Time.y * temp_cast_0 + texCoord3);
				float2 temp_cast_3 = (-_Speed).xx;
				float cos19 = cos( 0.001 * _Time.y );
				float sin19 = sin( 0.001 * _Time.y );
				float2 rotator19 = mul( texCoord3 - float2( 0.5,0.5 ) , float2x2( cos19 , -sin19 , sin19 , cos19 )) + float2( 0.5,0.5 );
				float2 panner2 = ( 1.0 * _Time.y * temp_cast_3 + rotator19);
				float3 temp_output_15_0 = BlendNormals( tex2D( _MainNormal, panner1 ).rgb , tex2D( _MainNormal, panner2 ).rgb );
				float3 ase_worldTangent = i.ase_texcoord2.xyz;
				float3 ase_worldNormal = i.ase_texcoord3.xyz;
				float3 ase_worldBitangent = i.ase_texcoord4.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 worldRefl35 = normalize( reflect( -ase_worldViewDir, float3( dot( tanToWorld0, temp_output_15_0 ), dot( tanToWorld1, temp_output_15_0 ), dot( tanToWorld2, temp_output_15_0 ) ) ) );
				float3 decodeLightMap105 = DecodeLightmap(texCUBE( _ReflectionProbeTex, -worldRefl35 ));
				
				
				finalColor = ( CalculateContrast(_Gloss,float4( decodeLightMap105 , 0.0 )) * _Color );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	Fallback Off
}
/*ASEBEGIN
Version=19400
Node;AmplifyShaderEditor.Vector3Node;114;-1550.481,910.7037;Inherit;False;Property;_RippleCentre;RippleCentre;9;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,8;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;96;-1550.818,710.8932;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;99;-1163.176,912.9048;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;115;-1235.481,676.7037;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;116;-1208.481,788.7037;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-1004,-105.5;Inherit;False;Property;_Tiling;Tiling;1;0;Create;True;0;0;0;False;0;False;1;0.21;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;98;-1067.176,732.9048;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1256,158.5;Inherit;False;Property;_Speed;Speed;2;0;Create;True;0;0;0;False;0;False;0.01;0.0183;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-834,-138.5;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldToObjectTransfNode;97;-859.8713,751.0027;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;81;-599.0772,696.519;Inherit;False;Constant;_RippleCenter;RippleCenter;7;0;Create;True;0;0;0;False;0;False;0.58,1.38;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RotatorNode;19;-789,21.5;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;0.001;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;34;-789.8364,176.7351;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;82;-407.8741,889.0739;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-393.8176,1167.893;Inherit;False;Property;_WaveSpeed;WaveSpeed;6;0;Create;True;0;0;0;False;0;False;0;0.39;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;1;-505,-151.5;Inherit;False;3;0;FLOAT2;1,0;False;2;FLOAT2;0.1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;2;-503,15.5;Inherit;False;3;0;FLOAT2;0,1;False;2;FLOAT2;-0.1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;88;-89.81763,1134.893;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-202.9313,848.5885;Inherit;False;2;2;0;FLOAT;0.36;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-300,-287.5;Inherit;True;Property;_MainNormal;MainNormal;0;0;Create;True;0;0;0;False;0;False;-1;None;4695cdfbbb7dbd54ba973026a03261e8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;5;-301,-57.5;Inherit;True;Property;_TextureSample1;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;4;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;87;-36.81763,886.8932;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;90;92.18237,1121.893;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;15;80,-144;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;91;305.1824,969.8932;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;113;398.2552,1137.608;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldReflectionVector;35;416,-352;Inherit;False;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;503.1824,972.8932;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;74;672,-352;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;71;128.1271,229.6187;Inherit;False;FLOAT;0;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;102;322.4677,736.9899;Inherit;False;Property;_WaveHight;WaveHight;7;0;Create;True;0;0;0;False;0;False;0;0.305;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;95;705.1824,969.8932;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;72;147.1271,334.6187;Inherit;False;Property;_SmallWaveHight;SmallWaveHight;5;0;Create;True;0;0;0;False;0;False;0;0.19;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;33;864,-368;Inherit;True;Property;_ReflectionProbeTex;ReflectionProbeTex;3;0;Create;True;0;0;0;False;0;False;-1;None;1c5ebe671a85fc14aae41e67283f51eb;True;0;False;white;LockedToCube;False;Object;-1;Auto;Cube;8;0;SAMPLERCUBE;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;340.1271,266.6187;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;657.4677,741.9899;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DecodeLightmapHlpNode;105;1107.546,-477.1336;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;109;1146.493,-282.0302;Inherit;False;Property;_Gloss;Gloss;8;0;Create;True;0;0;0;False;0;False;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;67;228.6054,94.6916;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;78;484.0567,374.3336;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;111;1331.543,-382.668;Inherit;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;66;849.4053,-160.7084;Inherit;False;Property;_Color;Color;4;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;616.6054,193.6916;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.VertexColorNode;59;658.0547,365.6852;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;107;955.4559,495.5789;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;1532.228,-360.2948;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;108;1560.178,-54.97005;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;112;1797.988,-324.8807;Float;False;True;-1;2;ASEMaterialInspector;100;5;WaterWave;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;2;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
WireConnection;99;0;96;3
WireConnection;99;1;114;3
WireConnection;115;0;96;1
WireConnection;115;1;114;1
WireConnection;116;0;96;2
WireConnection;116;1;114;2
WireConnection;98;0;115;0
WireConnection;98;1;116;0
WireConnection;98;2;99;0
WireConnection;3;0;20;0
WireConnection;97;0;98;0
WireConnection;19;0;3;0
WireConnection;34;0;21;0
WireConnection;82;0;81;0
WireConnection;82;1;97;0
WireConnection;1;0;3;0
WireConnection;1;2;21;0
WireConnection;2;0;19;0
WireConnection;2;2;34;0
WireConnection;88;0;89;0
WireConnection;85;0;82;0
WireConnection;4;1;1;0
WireConnection;5;1;2;0
WireConnection;87;0;85;0
WireConnection;90;0;88;0
WireConnection;15;0;4;0
WireConnection;15;1;5;0
WireConnection;91;0;87;0
WireConnection;91;1;90;0
WireConnection;35;0;15;0
WireConnection;92;0;91;0
WireConnection;92;1;113;0
WireConnection;74;0;35;0
WireConnection;71;0;15;0
WireConnection;95;0;92;0
WireConnection;33;1;74;0
WireConnection;69;0;71;0
WireConnection;69;1;72;0
WireConnection;101;0;95;0
WireConnection;101;1;102;0
WireConnection;105;0;33;0
WireConnection;78;0;101;0
WireConnection;78;1;69;0
WireConnection;111;1;105;0
WireConnection;111;0;109;0
WireConnection;68;0;67;0
WireConnection;68;1;78;0
WireConnection;61;0;111;0
WireConnection;61;1;66;0
WireConnection;108;1;68;0
WireConnection;108;2;59;1
WireConnection;112;0;61;0
WireConnection;112;1;108;0
ASEEND*/
//CHKSM=50611629CE79B255CA6B25F9481174A04353906A