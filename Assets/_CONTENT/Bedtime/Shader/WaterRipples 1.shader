// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "WaterRipples"
{
	Properties
	{
		_TextureSample1("Texture Sample 1", 2D) = "bump" {}
		_RainSpeed("Rain Speed", Range( 0 , 50)) = 0
		_RainDrops_Power("RainDrops_Power", Float) = 1
		_TextureSample0("Texture Sample 0", CUBE) = "white" {}
		_Mask("Mask", 2D) = "white" {}
		_Tint("Tint", Color) = (0,0,0,0)
		[HideInInspector] _texcoord3( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow 
		struct Input
		{
			float3 worldRefl;
			INTERNAL_DATA
			float2 uv3_texcoord3;
			float2 uv2_texcoord2;
		};

		uniform samplerCUBE _TextureSample0;
		uniform sampler2D _TextureSample1;
		uniform float _RainSpeed;
		uniform float _RainDrops_Power;
		uniform sampler2D _Mask;
		uniform float4 _Mask_ST;
		uniform float4 _Tint;


		float2 voronoihash96( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi96( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
			 		float2 o = voronoihash96( n + g );
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


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Normal = float3(0,0,1);
			float2 appendResult12 = (float2(frac( i.uv3_texcoord3.x ) , frac( i.uv3_texcoord3.y )));
			// *** BEGIN Flipbook UV Animation vars ***
			// Total tiles of Flipbook Texture
			float fbtotaltiles10 = 8.0 * 8.0;
			// Offsets for cols and rows of Flipbook Texture
			float fbcolsoffset10 = 1.0f / 8.0;
			float fbrowsoffset10 = 1.0f / 8.0;
			// Speed of animation
			float fbspeed10 = _Time[ 1 ] * _RainSpeed;
			// UV Tiling (col and row offset)
			float2 fbtiling10 = float2(fbcolsoffset10, fbrowsoffset10);
			// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
			// Calculate current tile linear index
			float fbcurrenttileindex10 = round( fmod( fbspeed10 + 0.0, fbtotaltiles10) );
			fbcurrenttileindex10 += ( fbcurrenttileindex10 < 0) ? fbtotaltiles10 : 0;
			// Obtain Offset X coordinate from current tile linear index
			float fblinearindextox10 = round ( fmod ( fbcurrenttileindex10, 8.0 ) );
			// Multiply Offset X by coloffset
			float fboffsetx10 = fblinearindextox10 * fbcolsoffset10;
			// Obtain Offset Y coordinate from current tile linear index
			float fblinearindextoy10 = round( fmod( ( fbcurrenttileindex10 - fblinearindextox10 ) / 8.0, 8.0 ) );
			// Reverse Y to get tiles from Top to Bottom
			fblinearindextoy10 = (int)(8.0-1) - fblinearindextoy10;
			// Multiply Offset Y by rowoffset
			float fboffsety10 = fblinearindextoy10 * fbrowsoffset10;
			// UV Offset
			float2 fboffset10 = float2(fboffsetx10, fboffsety10);
			// Flipbook UV
			half2 fbuv10 = appendResult12 * fbtiling10 + fboffset10;
			// *** END Flipbook UV Animation vars ***
			float3 tex2DNode11 = UnpackScaleNormal( tex2D( _TextureSample1, fbuv10 ), _RainDrops_Power );
			float2 uv1_Mask = i.uv2_texcoord2 * _Mask_ST.xy + _Mask_ST.zw;
			float4 tex2DNode23 = tex2D( _Mask, uv1_Mask );
			float3 lerpResult24 = lerp( float3( 0,0,0 ) , tex2DNode11 , tex2DNode23.rgb);
			float time96 = _Time.y;
			float2 voronoiSmoothId96 = 0;
			float2 coords96 = i.uv3_texcoord3 * 0.5;
			float2 id96 = 0;
			float2 uv96 = 0;
			float voroi96 = voronoi96( coords96, time96, id96, uv96, 0, voronoiSmoothId96 );
			float smoothstepResult89 = smoothstep( -0.5 , 0.5 , voroi96);
			float lerpResult93 = lerp( ( ( 1.0 - tex2DNode11.b ) * tex2DNode23.r ) , 0.0 , smoothstepResult89);
			o.Emission = ( texCUBE( _TextureSample0, WorldReflectionVector( i , lerpResult24 ) ) + ( lerpResult93 * _Tint ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.RangedFloatNode;9;-1126.639,79.83501;Float;False;Property;_RainSpeed;Rain Speed;1;0;Create;True;0;0;0;False;0;False;0;16;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1792.63,-76.21014;Float;False;Property;_RainDrops_Tile;RainDrops_Tile;2;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-805.1091,170.2744;Float;False;Property;_RainDrops_Power;RainDrops_Power;3;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;558.7487,-229.3549;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;67;783.9061,-875.6478;Inherit;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;True;0;0;0;False;0;False;-1;None;2ac11307bb2782746a48b75e742c2850;True;0;False;white;LockedToCube;False;Object;-1;Auto;Cube;8;0;SAMPLERCUBE;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldReflectionVector;69;529.6564,-910.9358;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;80;1182.53,-682.6587;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FractNode;8;-1324.647,-67.84705;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;7;-1319.167,12.98457;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;12;-1179.423,-47.29669;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-1550.434,-157.6591;Inherit;False;2;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;11;-465.4127,-13.7894;Inherit;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;0;False;0;False;-1;None;72f51b7dac3dfb9489ea4ea2ea147aaf;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;10;-785.7009,-92.89935;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;8;False;2;FLOAT;8;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;23;-267.6666,485.1079;Inherit;True;Property;_Mask;Mask;5;0;Create;True;0;0;0;False;0;False;-1;None;60d224affeaecf84ead5a8b24c6c9995;True;1;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;82;-441.4188,207.9993;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1446.684,-628.4656;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;WaterRipples;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.OneMinusNode;92;30.00281,-105.4163;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;93;322.3033,440.8679;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;86;-1016.114,475.8266;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;0.75;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;90;-664.1641,582.1124;Inherit;False;myVarName;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;97;-1299.971,313.0162;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;96;-971.0002,294.1287;Inherit;False;0;0;1;0;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SmoothstepOpNode;89;-668.6615,270.5367;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;-0.5;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;39;-209.767,-398.9378;Inherit;False;Property;_Tint;Tint;6;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.571783,0.4593537,0.681,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;91;1245.297,-285.649;Inherit;False;90;myVarName;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;24;238.3722,-82.55194;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;232.1478,232.6341;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
WireConnection;40;0;93;0
WireConnection;40;1;39;0
WireConnection;67;1;69;0
WireConnection;69;0;24;0
WireConnection;80;0;67;0
WireConnection;80;1;40;0
WireConnection;8;0;6;1
WireConnection;7;0;6;2
WireConnection;12;0;8;0
WireConnection;12;1;7;0
WireConnection;11;1;10;0
WireConnection;11;5;13;0
WireConnection;10;0;12;0
WireConnection;10;3;9;0
WireConnection;82;0;11;0
WireConnection;82;2;89;0
WireConnection;0;2;80;0
WireConnection;92;0;11;3
WireConnection;93;0;45;0
WireConnection;93;2;89;0
WireConnection;86;0;6;0
WireConnection;90;0;89;0
WireConnection;96;0;6;0
WireConnection;96;1;97;0
WireConnection;89;0;96;0
WireConnection;24;1;11;0
WireConnection;24;2;23;0
WireConnection;45;0;92;0
WireConnection;45;1;23;1
ASEEND*/
//CHKSM=C52106F5088BC34F7D12C72D12E843F1B3A72376