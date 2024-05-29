// Made with Amplify Shader Editor v1.9.4
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Bedtime/Clouds"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,0)
		_Affector("_Affector", Vector) = (0,0,0,0)
		_Distance("Distance", Float) = 0
		[HideInInspector] _texcoord3( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv3_texcoord3;
			float2 uv2_texcoord2;
			float3 worldPos;
		};

		uniform float4 _Color;
		uniform float4 _Affector;
		uniform float _Distance;


float2 voronoihash18( float2 p )
{
	
	p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
	return frac( sin( p ) *43758.5453);
}


float voronoi18( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
	 		float2 o = voronoihash18( n + g );
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


float2 voronoihash28( float2 p )
{
	
	p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
	return frac( sin( p ) *43758.5453);
}


float voronoi28( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
	 		float2 o = voronoihash28( n + g );
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
	return (F2 + F1) * 0.5;
}


float2 voronoihash39( float2 p )
{
	
	p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
	return frac( sin( p ) *43758.5453);
}


float voronoi39( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
	 		float2 o = voronoihash39( n + g );
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
	return (F2 + F1) * 0.5;
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

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float smoothstepResult9 = smoothstep( 0.15 , 1.25 , ( 1.0 - i.uv3_texcoord3.y ));
			float mulTime20 = _Time.y * 0.1;
			float time18 = mulTime20;
			float2 voronoiSmoothId18 = 0;
			float2 coords18 = i.uv2_texcoord2 * 8.0;
			float2 id18 = 0;
			float2 uv18 = 0;
			float voroi18 = voronoi18( coords18, time18, id18, uv18, 0, voronoiSmoothId18 );
			float smoothstepResult22 = smoothstep( -0.2 , 1.0 , voroi18);
			float temp_output_21_0 = ( smoothstepResult9 * smoothstepResult22 );
			float time28 = 0.0;
			float2 voronoiSmoothId28 = 0;
			float2 coords28 = i.uv2_texcoord2 * 3.0;
			float2 id28 = 0;
			float2 uv28 = 0;
			float voroi28 = voronoi28( coords28, time28, id28, uv28, 0, voronoiSmoothId28 );
			float time39 = 87.69;
			float2 voronoiSmoothId39 = 0;
			float2 panner40 = ( mulTime20 * float2( 0,5 ) + i.uv2_texcoord2);
			float2 coords39 = panner40 * 3.0;
			float2 id39 = 0;
			float2 uv39 = 0;
			float voroi39 = voronoi39( coords39, time39, id39, uv39, 0, voronoiSmoothId39 );
			float smoothstepResult29 = smoothstep( 0.1 , 0.15 , ( voroi28 * voroi39 ));
			float3 hsvTorgb54 = RGBToHSV( _Color.rgb );
			float3 hsvTorgb55 = HSVToRGB( float3(hsvTorgb54.x,1.0,hsvTorgb54.z) );
			float4 lerpResult49 = lerp( ( temp_output_21_0 * _Color ) , float4( ( saturate( ( ( smoothstepResult9 * smoothstepResult29 ) * sin( ( mulTime20 * 60.0 ) ) ) ) * hsvTorgb55 ) , 0.0 ) , smoothstepResult9);
			float3 ase_worldPos = i.worldPos;
			float smoothstepResult66 = smoothstep( 0.0 , 5.0 , length( ( float4( ase_worldPos , 0.0 ) - _Affector ) ));
			float temp_output_63_0 = saturate( ( 1.0 - ( smoothstepResult66 * _Distance ) ) );
			float4 color65 = IsGammaSpace() ? float4(1.498039,0.7294118,0,0) : float4(2.433049,0.4910209,0,0);
			float4 lerpResult67 = lerp( float4( 0,0,0,0 ) , ( temp_output_63_0 * color65 ) , temp_output_63_0);
			o.Emission = ( lerpResult49 + lerpResult67 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19400
Node;AmplifyShaderEditor.SimpleTimeNode;20;-864,736;Inherit;False;1;0;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;19;-864,544;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;60;-992,-752;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector4Node;61;-1008,-608;Float;False;Property;_Affector;_Affector;4;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;40;-592,704;Inherit;False;3;0;FLOAT2;1,0;False;2;FLOAT2;0,5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;56;-752,-688;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;14;-704,432;Inherit;False;2;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;28;-400,656;Inherit;False;0;0;1;3;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;3;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.VoronoiNode;39;-400,768;Inherit;False;0;0;1;3;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;87.69;False;2;FLOAT;3;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.LengthOpNode;57;-592,-704;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;15;-432,432;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-208,688;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-576,-608;Inherit;False;Property;_Distance;Distance;7;0;Create;True;0;0;0;False;0;False;0;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;66;-384,-528;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;29;-16,656;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;0.15;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-688,848;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;60;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;9;-304,304;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.15;False;2;FLOAT;1.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-400,-688;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;18;-448,512;Inherit;False;0;0;1;0;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;8;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;176,656;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;33;-496,848;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;8;-384,-128;Inherit;False;Property;_Color;Color;2;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;62;-256,-688;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;22;-240,496;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;-0.2;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;80,512;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RGBToHSVNode;54;-192,-48;Inherit;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SaturateNode;63;-112,-688;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;65;-336,-1040;Inherit;False;Constant;_Color0;Color 0;16;1;[HDR];Create;True;0;0;0;False;0;False;1.498039,0.7294118,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;52;-192,128;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.HSVToRGBNode;55;112,48;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-16,304;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-96,-1040;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-103,-174.5;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;272,-64;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;67;112,-912;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;49;192,-288;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;70;-48,-288;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;416,384;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;26;464,480;Inherit;False;Property;_Offset;Offset;6;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;27;449.9155,179.7276;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;6;-912,192;Inherit;False;Property;_Tiling;Tiling;1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;5;-1072,-48;Inherit;True;Property;_Clouds;Clouds;0;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TriplanarNode;3;-784,-48;Inherit;True;Spherical;World;False;Top Texture 0;_TopTexture0;white;0;None;Mid Texture 0;_MidTexture0;white;-1;None;Bot Texture 0;_BotTexture0;white;-1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;11;-592,208;Inherit;False;Property;_Max;Max;3;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-601,-166.5;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;608,336;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SinTimeNode;30;-752,1172;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;128,1216;Inherit;False;Property;_Min;Min;5;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;23;672,112;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;68;284.9923,-448.946;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalizeNode;71;-96.40741,-458.4902;Inherit;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.NegateNode;72;-64,-400;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;48,-544;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;544,-720;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Bedtime/Clouds;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;40;0;19;0
WireConnection;40;1;20;0
WireConnection;56;0;60;0
WireConnection;56;1;61;0
WireConnection;28;0;19;0
WireConnection;39;0;40;0
WireConnection;57;0;56;0
WireConnection;15;0;14;2
WireConnection;44;0;28;0
WireConnection;44;1;39;0
WireConnection;66;0;57;0
WireConnection;29;0;44;0
WireConnection;32;0;20;0
WireConnection;9;0;15;0
WireConnection;58;0;66;0
WireConnection;58;1;59;0
WireConnection;18;0;19;0
WireConnection;18;1;20;0
WireConnection;35;0;9;0
WireConnection;35;1;29;0
WireConnection;33;0;32;0
WireConnection;62;0;58;0
WireConnection;22;0;18;0
WireConnection;31;0;35;0
WireConnection;31;1;33;0
WireConnection;54;0;8;0
WireConnection;63;0;62;0
WireConnection;52;0;31;0
WireConnection;55;0;54;1
WireConnection;55;2;54;3
WireConnection;21;0;9;0
WireConnection;21;1;22;0
WireConnection;64;0;63;0
WireConnection;64;1;65;0
WireConnection;7;0;21;0
WireConnection;7;1;8;0
WireConnection;53;0;52;0
WireConnection;53;1;55;0
WireConnection;67;1;64;0
WireConnection;67;2;63;0
WireConnection;49;0;7;0
WireConnection;49;1;53;0
WireConnection;49;2;9;0
WireConnection;70;0;9;0
WireConnection;24;0;27;0
WireConnection;24;1;21;0
WireConnection;3;0;5;0
WireConnection;3;3;6;0
WireConnection;25;0;24;0
WireConnection;25;1;26;0
WireConnection;68;0;49;0
WireConnection;68;1;67;0
WireConnection;69;0;67;0
WireConnection;0;2;68;0
ASEEND*/
//CHKSM=E52E6C75720D8915BD5704E2C650FA4C77719288