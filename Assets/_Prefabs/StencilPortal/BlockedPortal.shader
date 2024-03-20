// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Banter/BlockedPortal"
{
	Properties
	{
		_CloseTexture("CloseTexture", 2D) = "white" {}
		_FarTexture("FarTexture", 2D) = "white" {}
		_Tint("Tint", Color) = (0,0,0,0)
		_SpeedNoise("SpeedNoise", Range( 0 , 5)) = 0.21
		_ScaleNoise("ScaleNoise", Range( 0 , 30)) = 9.680457
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_DisolveGuide("Disolve Guide", 2D) = "white" {}
		_DissolveAmount("Dissolve Amount", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
			float eyeDepth;
		};

		uniform sampler2D _CloseTexture;
		uniform float4 _CloseTexture_ST;
		uniform float4 _Tint;
		uniform float _ScaleNoise;
		uniform float _SpeedNoise;
		uniform sampler2D _FarTexture;
		uniform float4 _FarTexture_ST;
		uniform float _DissolveAmount;
		uniform sampler2D _DisolveGuide;
		uniform float4 _DisolveGuide_ST;
		uniform float _Cutoff = 0.5;


		float2 voronoihash14( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi14( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
			 		float2 o = voronoihash14( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.685 * pow( ( pow( abs( r.x ), 1.83 ) + pow( abs( r.y ), 1.83 ) ), 0.546 );
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


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			o.eyeDepth = -UnityObjectToViewPos( v.vertex.xyz ).z;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_CloseTexture = i.uv_texcoord * _CloseTexture_ST.xy + _CloseTexture_ST.zw;
			float mulTime8 = _Time.y * _SpeedNoise;
			float time14 = mulTime8;
			float2 voronoiSmoothId14 = 0;
			float2 coords14 = i.uv_texcoord * _ScaleNoise;
			float2 id14 = 0;
			float2 uv14 = 0;
			float voroi14 = voronoi14( coords14, time14, id14, uv14, 0, voronoiSmoothId14 );
			float lerpResult21 = lerp( (0.2 + (voroi14 - 0.0) * (2.0 - 0.2) / (1.0 - 0.0)) , voroi14 , saturate( i.vertexColor ).r);
			float2 uv_FarTexture = i.uv_texcoord * _FarTexture_ST.xy + _FarTexture_ST.zw;
			float cameraDepthFade18 = (( i.eyeDepth -_ProjectionParams.y - 2.0 ) / 5.0);
			float4 lerpResult42 = lerp( ( tex2D( _CloseTexture, uv_CloseTexture ) * ( _Tint + lerpResult21 ) ) , tex2D( _FarTexture, uv_FarTexture ) , saturate( cameraDepthFade18 ));
			o.Emission = lerpResult42.rgb;
			o.Alpha = 1;
			float2 uv_DisolveGuide = i.uv_texcoord * _DisolveGuide_ST.xy + _DisolveGuide_ST.zw;
			clip( ( (-0.6 + (_DissolveAmount - 0.0) * (0.6 - -0.6) / (1.0 - 0.0)) + tex2D( _DisolveGuide, uv_DisolveGuide ).r ) - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.VertexColorNode;30;-475.6495,848.743;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;31;-228.3362,864.7332;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;469.7509,246.3733;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;25;-340.57,609.8025;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;21;-52.71344,506.78;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;40;181.8813,197.1374;Inherit;False;Property;_Tint;Tint;2;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;27;-353.8477,406.8414;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.2;False;4;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;14;-744.9877,470.8297;Inherit;False;0;4;1.83;3;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;20;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleTimeNode;8;-997.0369,498.6183;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1094.615,644.7485;Inherit;False;Property;_ScaleNoise;ScaleNoise;4;0;Create;True;0;0;0;False;0;False;9.680457;7;0;30;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1290.264,500.9771;Inherit;False;Property;_SpeedNoise;SpeedNoise;3;0;Create;True;0;0;0;False;0;False;0.21;0.9;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-1019.544,366.6355;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;569.6278,375.807;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;42;753.8268,454.7948;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;998.6869,523.6898;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Banter/BlockedPortal;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;5;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SamplerNode;51;287.383,1251.169;Inherit;True;Property;_DisolveGuide;Disolve Guide;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;54;796.9498,1049.536;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;13.2951,1097.649;Float;False;Property;_DissolveAmount;Dissolve Amount;7;0;Create;True;0;0;0;False;0;False;0;0.229;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;53;469.4148,1058.317;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.6;False;4;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;18;-669.7654,627.345;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;5;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;22;94.57361,659.2941;Inherit;True;Property;_CloseTexture;CloseTexture;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;24;101.4551,864.2695;Inherit;True;Property;_FarTexture;FarTexture;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;31;0;30;0
WireConnection;39;0;40;0
WireConnection;39;1;21;0
WireConnection;25;0;18;0
WireConnection;21;0;27;0
WireConnection;21;1;14;0
WireConnection;21;2;31;0
WireConnection;27;0;14;0
WireConnection;14;0;12;0
WireConnection;14;1;8;0
WireConnection;14;2;10;0
WireConnection;8;0;9;0
WireConnection;38;0;22;0
WireConnection;38;1;39;0
WireConnection;42;0;38;0
WireConnection;42;1;24;0
WireConnection;42;2;25;0
WireConnection;0;2;42;0
WireConnection;0;10;54;0
WireConnection;54;0;53;0
WireConnection;54;1;51;1
WireConnection;53;0;52;0
ASEEND*/
//CHKSM=469E682D995ACD15A8B204B35661BD16D7A6F696