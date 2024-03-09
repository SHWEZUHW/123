// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "WaterRipples2"
{
	Properties
	{
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_RainSpeed("Rain Speed", Range( 0 , 50)) = 0
		_RainDrops_Tile("RainDrops_Tile", Float) = 1
		_Mask("Mask", 2D) = "white" {}
		_DropPower("DropPower", Float) = 100
		[HideInInspector] _texcoord3( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#pragma target 3.0
		#pragma surface surf StandardCustomLighting keepalpha noshadow noforwardadd 
		struct Input
		{
			float2 uv3_texcoord3;
			float2 uv2_texcoord2;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform sampler2D _TextureSample1;
		uniform float _RainDrops_Tile;
		uniform float _RainSpeed;
		uniform sampler2D _Mask;
		uniform float4 _Mask_ST;
		uniform float _DropPower;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			c.rgb = 0;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
			float2 temp_cast_0 = (_RainDrops_Tile).xx;
			float2 uv3_TexCoord6 = i.uv3_texcoord3 * temp_cast_0;
			float2 appendResult12 = (float2(frac( uv3_TexCoord6.x ) , frac( uv3_TexCoord6.y )));
			// *** BEGIN Flipbook UV Animation vars ***
			// Total tiles of Flipbook Texture
			float fbtotaltiles10 = 6.0 * 5.0;
			// Offsets for cols and rows of Flipbook Texture
			float fbcolsoffset10 = 1.0f / 6.0;
			float fbrowsoffset10 = 1.0f / 5.0;
			// Speed of animation
			float fbspeed10 = _Time[ 1 ] * _RainSpeed;
			// UV Tiling (col and row offset)
			float2 fbtiling10 = float2(fbcolsoffset10, fbrowsoffset10);
			// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
			// Calculate current tile linear index
			float fbcurrenttileindex10 = round( fmod( fbspeed10 + 0.0, fbtotaltiles10) );
			fbcurrenttileindex10 += ( fbcurrenttileindex10 < 0) ? fbtotaltiles10 : 0;
			// Obtain Offset X coordinate from current tile linear index
			float fblinearindextox10 = round ( fmod ( fbcurrenttileindex10, 6.0 ) );
			// Multiply Offset X by coloffset
			float fboffsetx10 = fblinearindextox10 * fbcolsoffset10;
			// Obtain Offset Y coordinate from current tile linear index
			float fblinearindextoy10 = round( fmod( ( fbcurrenttileindex10 - fblinearindextox10 ) / 6.0, 5.0 ) );
			// Reverse Y to get tiles from Top to Bottom
			fblinearindextoy10 = (int)(5.0-1) - fblinearindextoy10;
			// Multiply Offset Y by rowoffset
			float fboffsety10 = fblinearindextoy10 * fbrowsoffset10;
			// UV Offset
			float2 fboffset10 = float2(fboffsetx10, fboffsety10);
			// Flipbook UV
			half2 fbuv10 = appendResult12 * fbtiling10 + fboffset10;
			// *** END Flipbook UV Animation vars ***
			float2 uv1_Mask = i.uv2_texcoord2 * _Mask_ST.xy + _Mask_ST.zw;
			float temp_output_45_0 = ( (tex2D( _TextureSample1, fbuv10 )).r * tex2D( _Mask, uv1_Mask ).r );
			float smoothstepResult83 = smoothstep( 0.0 , 0.2 , temp_output_45_0);
			float temp_output_87_0 = pow( smoothstepResult83 , _DropPower );
			float3 temp_cast_1 = (temp_output_87_0).xxx;
			o.Emission = temp_cast_1 + 1E-5;
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
Node;AmplifyShaderEditor.ColorNode;39;-454.2513,-348.3549;Inherit;False;Property;_Tint;Tint;6;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.571783,0.4593537,0.681,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FractNode;8;-1324.647,-67.84705;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;7;-1319.167,12.98457;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;12;-1179.423,-47.29669;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;11;-464.4127,-51.7894;Inherit;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;0;False;0;False;-1;None;b2c64ee6108286548b258226badf1fcc;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-1550.434,-157.6591;Inherit;False;2;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;10;-785.7009,-92.89935;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;6;False;2;FLOAT;5;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SwizzleNode;82;-55.83203,-89.20172;Inherit;False;FLOAT;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;183.2882,78.41622;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;83;-21.05577,-707.6283;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;84;219.6459,-810.7042;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;436.6459,-769.7042;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;5;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;23;-440.7103,162.3121;Inherit;True;Property;_Mask;Mask;5;0;Create;True;0;0;0;False;0;False;-1;None;60d224affeaecf84ead5a8b24c6c9995;True;1;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;67;922.9061,-930.6478;Inherit;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;True;0;0;0;False;0;False;-1;None;2ac11307bb2782746a48b75e742c2850;True;0;False;white;LockedToCube;False;Object;-1;Auto;Cube;8;0;SAMPLERCUBE;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldReflectionVector;69;676.6564,-915.9358;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PowerNode;87;332.3085,-960.5967;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1542.128,-706.9147;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;WaterRipples2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleAddOpNode;80;1308.53,-708.6587;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;86;275.6459,-652.7042;Inherit;False;Property;_DropPower;DropPower;7;0;Create;True;0;0;0;False;0;False;100;0.1;0;0;0;1;FLOAT;0
WireConnection;40;0;45;0
WireConnection;40;1;39;0
WireConnection;8;0;6;1
WireConnection;7;0;6;2
WireConnection;12;0;8;0
WireConnection;12;1;7;0
WireConnection;11;1;10;0
WireConnection;6;0;5;0
WireConnection;10;0;12;0
WireConnection;10;3;9;0
WireConnection;82;0;11;0
WireConnection;45;0;82;0
WireConnection;45;1;23;1
WireConnection;83;0;45;0
WireConnection;84;0;83;0
WireConnection;84;1;83;0
WireConnection;84;2;83;0
WireConnection;85;0;84;0
WireConnection;85;1;86;0
WireConnection;67;1;69;0
WireConnection;69;0;87;0
WireConnection;87;0;83;0
WireConnection;87;1;86;0
WireConnection;0;2;80;0
WireConnection;0;15;87;0
WireConnection;80;0;67;0
WireConnection;80;1;40;0
ASEEND*/
//CHKSM=856C26EA63DECE6A6FB1A0EF3DE28218ED718C9A