// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Banter/MaterixPlatform"
{
	Properties
	{
		_WireCol("WireCol", 2D) = "white" {}
		_Gradiant("Gradiant", 2D) = "white" {}
		_Code("Code", 2D) = "white" {}
		_ScrollSpeed("ScrollSpeed", Float) = 0
		_Scale("Scale", Float) = 1
		_WireTint("WireTint", Color) = (0,0,0,0)
		_TextTint("TextTint", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Background+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float2 uv2_texcoord2;
		};

		uniform float _ScrollSpeed;
		uniform float _Scale;
		uniform float4 _TextTint;
		uniform sampler2D _Gradiant;
		uniform sampler2D _Code;
		uniform sampler2D _WireCol;
		uniform float4 _WireTint;


		float2 voronoihash37( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi37( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
			 		float2 o = voronoihash37( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			
			 		}
			 	}
			}
			return F1;
		}


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

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			float mulTime9 = _Time.y * _ScrollSpeed;
			float time37 = mulTime9;
			float2 voronoiSmoothId37 = 0;
			float2 temp_cast_0 = (_Scale).xx;
			float2 uv_TexCoord11 = v.texcoord.xy * temp_cast_0;
			float2 coords37 = uv_TexCoord11 * 1.0;
			float2 id37 = 0;
			float2 uv37 = 0;
			float voroi37 = voronoi37( coords37, time37, id37, uv37, 0, voronoiSmoothId37 );
			v.vertex.xyz += ( ase_vertexNormal * voroi37 );
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 hsvTorgb44 = RGBToHSV( _TextTint.rgb );
			float mulTime9 = _Time.y * _ScrollSpeed;
			float temp_output_46_0 = ( mulTime9 / 10.0 );
			float3 worldToObj49 = mul( unity_WorldToObject, float4( _WorldSpaceCameraPos, 1 ) ).xyz;
			float3 hsvTorgb43 = HSVToRGB( float3(( hsvTorgb44.x + temp_output_46_0 ),hsvTorgb44.y,( hsvTorgb44.z * ( sqrt( length( worldToObj49 ) ) * 0.1 ) )) );
			float2 temp_cast_1 = (_Scale).xx;
			float2 uv_TexCoord11 = i.uv_texcoord * temp_cast_1;
			float2 panner8 = ( mulTime9 * float2( 0,1 ) + uv_TexCoord11);
			float4 tex2DNode4 = tex2D( _Gradiant, panner8 );
			float3 hsvTorgb40 = RGBToHSV( _WireTint.rgb );
			float3 hsvTorgb41 = HSVToRGB( float3(( hsvTorgb40.x + temp_output_46_0 ),hsvTorgb40.y,hsvTorgb40.z) );
			float4 temp_output_7_0 = ( ( ( float4( ( hsvTorgb43 * tex2DNode4.a ) , 0.0 ) + ( tex2DNode4 * tex2DNode4.a ) ) * ( tex2DNode4.a * tex2D( _Code, uv_TexCoord11 ).a ) ) + ( tex2D( _WireCol, i.uv2_texcoord2 ) * float4( hsvTorgb41 , 0.0 ) ) );
			o.Emission = temp_output_7_0.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.SimpleTimeNode;9;-783,-293;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-981,-284;Inherit;False;Property;_ScrollSpeed;ScrollSpeed;5;0;Create;True;0;0;0;False;0;False;0;0.36;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;59.646,-352.1732;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;25;290.7954,-518.3654;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;214.2659,-206.8615;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;311,104;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;89.33185,-509.5846;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;6;-381.1548,-344.6809;Inherit;True;Property;_Code;Code;4;0;Create;True;0;0;0;False;0;False;-1;None;39f0b21eeff696b42b166b040d703503;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-373.0724,-630.6706;Inherit;True;Property;_Gradiant;Gradiant;3;0;Create;True;0;0;0;False;0;False;-1;None;eeeae8b12a74ae74ab4bb9af64f10f1c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;389.7954,-206.3654;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;897.4999,-99.30003;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Banter/MaterixPlatform;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;True;Opaque;;Background;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;2;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SamplerNode;33;-212.7657,397.7386;Inherit;True;Property;_Falloff;Falloff;1;0;Create;True;0;0;0;False;0;False;-1;None;6ee78ef071246504cbd54732d6a3ff37;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-182,166;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;361.8342,384.7383;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VoronoiNode;37;322.9441,516.5558;Inherit;False;0;0;1;0;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.NormalVertexDataNode;38;306.7098,652.7877;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;567.7098,568.7877;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;35;-519.8788,647.2631;Inherit;False;2;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-799.6585,105.2255;Inherit;True;Property;_WireCol;WireCol;0;0;Create;True;0;0;0;False;0;False;-1;None;a3a55c9448512954197a70be7115123e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-1092.658,113.2255;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;18;-1197,-462;Inherit;False;Property;_Scale;Scale;6;0;Create;True;0;0;0;False;0;False;1;6.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-1031,-546;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;8;-650,-537;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;13;-1582.732,-68.36568;Inherit;False;Property;_WireTint;WireTint;7;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.9583333,0.2321428,1,0.6941177;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.HSVToRGBNode;41;-650.3215,-92.72144;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RGBToHSVNode;40;-1183.322,-80.72144;Inherit;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;42;-881.3215,-130.7214;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.HSVToRGBNode;43;-682.2238,389.7897;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RGBToHSVNode;44;-1215.224,401.7897;Inherit;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;45;-913.2236,351.7897;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;36;-1483.318,357.8914;Inherit;False;Property;_TextTint;TextTint;8;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,1,0.8980393,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;46;-1011.823,-206.1117;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-770.473,565.9954;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;48;-1911.536,748.874;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TransformPositionNode;49;-1642.031,650.035;Inherit;True;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LengthOpNode;50;-1390.052,629.097;Inherit;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SqrtOpNode;51;-1214.988,619.238;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-1026.726,655.7227;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
WireConnection;9;0;10;0
WireConnection;23;0;4;0
WireConnection;23;1;4;4
WireConnection;25;0;24;0
WireConnection;25;1;23;0
WireConnection;21;0;4;4
WireConnection;21;1;6;4
WireConnection;7;0;26;0
WireConnection;7;1;14;0
WireConnection;24;0;43;0
WireConnection;24;1;4;4
WireConnection;6;1;11;0
WireConnection;4;1;8;0
WireConnection;26;0;25;0
WireConnection;26;1;21;0
WireConnection;0;2;7;0
WireConnection;0;11;39;0
WireConnection;33;1;35;0
WireConnection;14;0;1;0
WireConnection;14;1;41;0
WireConnection;34;0;7;0
WireConnection;34;1;33;0
WireConnection;37;0;11;0
WireConnection;37;1;9;0
WireConnection;39;0;38;0
WireConnection;39;1;37;0
WireConnection;1;1;2;0
WireConnection;11;0;18;0
WireConnection;8;0;11;0
WireConnection;8;1;9;0
WireConnection;41;0;42;0
WireConnection;41;1;40;2
WireConnection;41;2;40;3
WireConnection;40;0;13;0
WireConnection;42;0;40;1
WireConnection;42;1;46;0
WireConnection;43;0;45;0
WireConnection;43;1;44;2
WireConnection;43;2;52;0
WireConnection;44;0;36;0
WireConnection;45;0;44;1
WireConnection;45;1;46;0
WireConnection;46;0;9;0
WireConnection;52;0;44;3
WireConnection;52;1;53;0
WireConnection;49;0;48;0
WireConnection;50;0;49;0
WireConnection;51;0;50;0
WireConnection;53;0;51;0
ASEEND*/
//CHKSM=A58B0EE1243B1924692D94FEE2AED3CB93313E13