// Made with Amplify Shader Editor v1.9.4
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "LobbyBreathingCeiling"
{
	Properties
	{
		_Float0("Float 0", Float) = 0
		_MainTex("MainTex", 2D) = "white" {}
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
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float _Float0;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;


float2 voronoihash7( float2 p )
{
	
	p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
	return frac( sin( p ) *43758.5453);
}


float voronoi7( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
	 		float2 o = voronoihash7( n + g );
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


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			float time7 = _Time.y;
			float2 voronoiSmoothId7 = 0;
			float2 coords7 = v.texcoord.xy * 5.0;
			float2 id7 = 0;
			float2 uv7 = 0;
			float voroi7 = voronoi7( coords7, time7, id7, uv7, 0, voronoiSmoothId7 );
			v.vertex.xyz += ( ( ( ase_vertexNormal * voroi7 ) * _Float0 ) * v.color.r );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color14 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float time7 = _Time.y;
			float2 voronoiSmoothId7 = 0;
			float2 coords7 = i.uv_texcoord * 5.0;
			float2 id7 = 0;
			float2 uv7 = 0;
			float voroi7 = voronoi7( coords7, time7, id7, uv7, 0, voronoiSmoothId7 );
			float4 lerpResult13 = lerp( color14 , ( tex2D( _MainTex, uv_MainTex ) * voroi7 ) , i.vertexColor.r);
			o.Emission = lerpResult13.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19400
Node;AmplifyShaderEditor.TextureCoordinatesNode;9;-1296,144;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;11;-1264,272;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;6;-1024,0;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;7;-1024,192;Inherit;False;0;0;1;0;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;5;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RangedFloatNode;5;-768,272;Inherit;False;Property;_Float0;Float 0;0;0;Create;True;0;0;0;False;0;False;0;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-768,176;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;16;-352,-432;Inherit;True;Property;_MainTex;MainTex;2;0;Create;True;0;0;0;False;0;False;-1;None;9fcb8cf15a79d7949b513ea805fabad0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;1;-576,320;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-624,176;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;14;-608,-336;Inherit;False;Constant;_Color0;Color 0;1;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.634798,0,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-400,-64;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;12;-656,-160;Inherit;False;Property;_Color;Color;1;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.2517202,0,0.3962264,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-350.0511,221.1519;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;13;-176,-144;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;304,-160;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;LobbyBreathingCeiling;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;7;0;9;0
WireConnection;7;1;11;0
WireConnection;10;0;6;0
WireConnection;10;1;7;0
WireConnection;4;0;10;0
WireConnection;4;1;5;0
WireConnection;15;0;16;0
WireConnection;15;1;7;0
WireConnection;2;0;4;0
WireConnection;2;1;1;1
WireConnection;13;0;14;0
WireConnection;13;1;15;0
WireConnection;13;2;1;1
WireConnection;0;2;13;0
WireConnection;0;11;2;0
ASEEND*/
//CHKSM=D4557B676D923BF05158D52F51F5AEBB6CCE5A26