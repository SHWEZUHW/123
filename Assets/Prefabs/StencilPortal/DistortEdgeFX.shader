// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Banter/DistortEdgeFX"
{
	Properties
	{
		_Thumb("Thumb", 2D) = "white" {}
		_SpeedNoise("SpeedNoise", Range( 0 , 5)) = 0.21
		_ScaleNoise("ScaleNoise", Range( 0 , 30)) = 0.04
		_Vector0("Vector 0", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma only_renderers d3d11 glcore gles gles3 metal 
		#pragma surface surf Unlit alpha:fade keepalpha noshadow 
		struct Input
		{
			float2 uv2_texcoord2;
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _Thumb;
		uniform float _SpeedNoise;
		uniform float2 _Vector0;
		uniform float _ScaleNoise;
		uniform float4 _Thumb_ST;


		float2 voronoihash24( float2 p )
		{
			p = p - 1 * floor( p / 1 );
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi24( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
			 		float2 o = voronoihash24( n + g );
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
			return F2;
		}


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float mulTime2 = _Time.y * _SpeedNoise;
			float2 uv2_TexCoord5 = i.uv2_texcoord2 + _Vector0;
			float2 panner3 = ( mulTime2 * float2( 1,1 ) + uv2_TexCoord5);
			float time24 = mulTime2;
			float2 voronoiSmoothId24 = 0;
			float2 coords24 = uv2_TexCoord5 * _ScaleNoise;
			float2 id24 = 0;
			float2 uv24 = 0;
			float voroi24 = voronoi24( coords24, time24, id24, uv24, 0, voronoiSmoothId24 );
			float2 uv_Thumb = i.uv_texcoord * _Thumb_ST.xy + _Thumb_ST.zw;
			o.Emission = ( tex2D( _Thumb, ( panner3 + voroi24 ) ) + tex2D( _Thumb, uv_Thumb ) ).rgb;
			o.Alpha = saturate( i.vertexColor ).r;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.Vector2Node;63;-803.4291,-340.2753;Inherit;False;Property;_Vector0;Vector 0;6;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;2;-571.1416,-216.7553;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-867.3895,-214.2167;Inherit;False;Property;_SpeedNoise;SpeedNoise;4;0;Create;True;0;0;0;False;0;False;0.21;0.9;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-694.4628,-110.3247;Inherit;False;Property;_ScaleNoise;ScaleNoise;5;0;Create;True;0;0;0;False;0;False;0.04;7;0;30;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-135.7762,-290.9897;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VertexColorNode;31;181.6125,33.88065;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GrabScreenPosition;68;-692.8555,71.34055;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;44;3.102173,-430.325;Inherit;True;Property;_Thumb;Thumb;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;74;-3.245056,-216.5957;Inherit;True;Property;_Thumb1;Thumb;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;44;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;62;460.2873,-314.408;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.490566,0.490566,0.490566,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;767.052,-331.0935;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Banter/DistortEdgeFX;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;5;d3d11;glcore;gles;gles3;metal;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;2;5;False;;10;False;;4;1;False;;1;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;5;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SaturateNode;76;408.3661,42.54333;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-615.4289,-332.9528;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;3;-344.4293,-359.9528;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VoronoiNode;24;-338.0127,-233.5117;Inherit;False;0;0;1;1;1;True;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;20;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.ScreenColorNode;69;-71.72198,56.10907;Inherit;False;Global;_GrabScreen0;Grab Screen 0;4;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwizzleNode;70;-455.9521,70.27238;Inherit;False;FLOAT4;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;71;-283.6843,78.75067;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;72;-648.1818,254.2234;Inherit;False;Flow;1;;2;acad10cc8145e1f4eb8042bebe2d9a42;2,50,0,51,0;6;5;SAMPLER2D;;False;2;FLOAT2;0,0;False;55;FLOAT;1;False;18;FLOAT2;0,0;False;17;FLOAT2;1,1;False;24;FLOAT;0.1;False;1;COLOR;0
WireConnection;2;0;4;0
WireConnection;22;0;3;0
WireConnection;22;1;24;0
WireConnection;44;1;22;0
WireConnection;62;0;44;0
WireConnection;62;1;74;0
WireConnection;0;2;62;0
WireConnection;0;9;76;0
WireConnection;76;0;31;0
WireConnection;5;1;63;0
WireConnection;3;0;5;0
WireConnection;3;1;2;0
WireConnection;24;0;5;0
WireConnection;24;1;2;0
WireConnection;24;2;23;0
WireConnection;69;0;71;0
WireConnection;70;0;68;0
WireConnection;71;0;70;0
WireConnection;71;1;72;0
ASEEND*/
//CHKSM=373DF277F922D86A5985879B69EE287515F51D83