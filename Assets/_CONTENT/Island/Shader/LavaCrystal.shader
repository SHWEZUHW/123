// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "LavaCrystal"
{
	Properties
	{
		_Video("Video", 2D) = "white" {}
		_Hight("Hight", Float) = 0
		_scale("scale", Float) = 0
		_Main("Main", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
			float3 viewDir;
			INTERNAL_DATA
			float3 worldPos;
			float3 worldNormal;
		};

		uniform sampler2D _Main;
		uniform float _Hight;
		uniform float _scale;
		uniform sampler2D _Video;


		float2 voronoihash13( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi13( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
			 		float2 o = voronoihash13( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.500 * pow( ( pow( abs( r.x ), 1 ) + pow( abs( r.y ), 1 ) ), 1.000 );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			
			 		}
			 	}
			}
			return F2;
		}


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Normal = float3(0,0,1);
			float time13 = _Time.y;
			float2 voronoiSmoothId13 = 0;
			float2 coords13 = i.uv_texcoord * 18.23;
			float2 id13 = 0;
			float2 uv13 = 0;
			float voroi13 = voronoi13( coords13, time13, id13, uv13, 0, voronoiSmoothId13 );
			float2 temp_cast_0 = (voroi13).xx;
			float2 lerpResult15 = lerp( i.uv_texcoord , temp_cast_0 , float2( 0.08,0.05 ));
			float2 panner16 = ( _Time.y * float2( 0,0.05 ) + lerpResult15);
			float2 Offset3 = ( ( _Hight - 1 ) * i.viewDir.xy * _scale ) + panner16;
			float2 Offset17 = ( ( -0.05 - 1 ) * i.viewDir.xy * 0.3 ) + lerpResult15;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV21 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode21 = ( 0.0 + 2.0 * pow( 1.0 - fresnelNdotV21, 1.0 ) );
			float temp_output_22_0 = ( 1.0 - fresnelNode21 );
			float4 lerpResult20 = lerp( tex2D( _Main, Offset3 ) , tex2D( _Video, Offset17 ) , temp_output_22_0);
			o.Emission = ( lerpResult20 * temp_output_22_0 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.RangedFloatNode;11;-1083,273.5;Inherit;False;Property;_scale;scale;2;0;Create;True;0;0;0;False;0;False;0;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-544,-180.5;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;232.7263,-72.31672;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;LavaCrystal;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.TexturePropertyNode;12;-1179,-336.5;Inherit;True;Property;_Main;Main;3;0;Create;True;0;0;0;False;0;False;None;38e077ea0da267f4b8ad9b4327ef347a;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;9;-1482,145.5;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-1611,-202.5;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;14;-1746.346,-4.236952;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;13;-1496.289,-60.38343;Inherit;False;0;4;1;1;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;18.23;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.PannerNode;16;-1080.391,12.17097;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.05;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;2;-562,132.5;Inherit;True;Property;_Video;Video;0;0;Create;True;0;0;0;False;0;False;-1;None;9fcb8cf15a79d7949b513ea805fabad0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;-1088,208.5;Inherit;False;Property;_Hight;Hight;1;0;Create;True;0;0;0;False;0;False;0;-0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ParallaxMappingNode;17;-790.495,298.1573;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;-0.05;False;2;FLOAT;0.3;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ParallaxMappingNode;3;-826,-40.5;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0.48;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;15;-1303.992,-43.72903;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;0.08,0.05;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;20;-206.2202,-0.7167969;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;52.3098,88.25459;Inherit;False;2;2;0;COLOR;0.2202266,0,0.3962264,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;22;-75.52655,201.1555;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;21;-306.5266,237.1555;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;2;False;3;FLOAT;1;False;1;FLOAT;0
WireConnection;1;0;12;0
WireConnection;1;1;3;0
WireConnection;0;2;7;0
WireConnection;13;0;6;0
WireConnection;13;1;14;0
WireConnection;16;0;15;0
WireConnection;16;1;14;0
WireConnection;2;1;17;0
WireConnection;17;0;15;0
WireConnection;17;3;9;0
WireConnection;3;0;16;0
WireConnection;3;1;10;0
WireConnection;3;2;11;0
WireConnection;3;3;9;0
WireConnection;15;0;6;0
WireConnection;15;1;13;0
WireConnection;20;0;1;0
WireConnection;20;1;2;0
WireConnection;20;2;22;0
WireConnection;7;0;20;0
WireConnection;7;1;22;0
WireConnection;22;0;21;0
ASEEND*/
//CHKSM=009CFE5B53E0AAC0C5AE214B3332AC47A1F92BE1