// Made with Amplify Shader Editor v1.9.3.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FireVideo"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_Flipbook("Flipbook", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Off
		Blend One One
		
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _MainTex;
		uniform sampler2D _Flipbook;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 appendResult14 = (float2(( 1.0 - i.uv_texcoord.x ) , i.uv_texcoord.y));
			float2 uv_TexCoord22 = i.uv_texcoord * float2( 1,0.6 );
			// *** BEGIN Flipbook UV Animation vars ***
			// Total tiles of Flipbook Texture
			float fbtotaltiles15 = 8.0 * 8.0;
			// Offsets for cols and rows of Flipbook Texture
			float fbcolsoffset15 = 1.0f / 8.0;
			float fbrowsoffset15 = 1.0f / 8.0;
			// Speed of animation
			float fbspeed15 = _Time[ 1 ] * 30.0;
			// UV Tiling (col and row offset)
			float2 fbtiling15 = float2(fbcolsoffset15, fbrowsoffset15);
			// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
			// Calculate current tile linear index
			float fbcurrenttileindex15 = round( fmod( fbspeed15 + 0.0, fbtotaltiles15) );
			fbcurrenttileindex15 += ( fbcurrenttileindex15 < 0) ? fbtotaltiles15 : 0;
			// Obtain Offset X coordinate from current tile linear index
			float fblinearindextox15 = round ( fmod ( fbcurrenttileindex15, 8.0 ) );
			// Multiply Offset X by coloffset
			float fboffsetx15 = fblinearindextox15 * fbcolsoffset15;
			// Obtain Offset Y coordinate from current tile linear index
			float fblinearindextoy15 = round( fmod( ( fbcurrenttileindex15 - fblinearindextox15 ) / 8.0, 8.0 ) );
			// Reverse Y to get tiles from Top to Bottom
			fblinearindextoy15 = (int)(8.0-1) - fblinearindextoy15;
			// Multiply Offset Y by rowoffset
			float fboffsety15 = fblinearindextoy15 * fbrowsoffset15;
			// UV Offset
			float2 fboffset15 = float2(fboffsetx15, fboffsety15);
			// Flipbook UV
			half2 fbuv15 = uv_TexCoord22 * fbtiling15 + fboffset15;
			// *** END Flipbook UV Animation vars ***
			float4 tex2DNode16 = tex2D( _Flipbook, fbuv15 );
			float smoothstepResult21 = smoothstep( 0.0 , 0.6 , tex2DNode16.r);
			float smoothstepResult25 = smoothstep( 0.5 , 0.5 , tex2DNode16.r);
			float4 lerpResult29 = lerp( ( tex2D( _MainTex, appendResult14 ) * smoothstepResult21 ) , tex2DNode16 , ( smoothstepResult21 - smoothstepResult25 ));
			o.Emission = lerpResult29.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19302
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-2200.669,-139.274;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;22;-2295.003,24.91452;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,0.6;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;13;-1940.669,-129.274;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;15;-2035.436,145.3579;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;8;False;2;FLOAT;8;False;3;FLOAT;30;False;4;FLOAT;0;False;5;FLOAT;1;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode;14;-1781.669,-110.274;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;16;-1719.436,125.3272;Inherit;True;Property;_Flipbook;Flipbook;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-1519.602,-105.6379;Inherit;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;21;-1367.971,211.347;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;25;-1418.092,369.8153;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-985.2856,-89.58342;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;28;-1110.88,356.809;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;29;-834.5665,154.4604;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-328.5657,108.3001;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;FireVideo;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;False;Transparent;;AlphaTest;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;4;1;False;;1;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;13;0;12;1
WireConnection;15;0;22;0
WireConnection;14;0;13;0
WireConnection;14;1;12;2
WireConnection;16;1;15;0
WireConnection;1;1;14;0
WireConnection;21;0;16;1
WireConnection;25;0;16;1
WireConnection;30;0;1;0
WireConnection;30;1;21;0
WireConnection;28;0;21;0
WireConnection;28;1;25;0
WireConnection;29;0;30;0
WireConnection;29;1;16;0
WireConnection;29;2;28;0
WireConnection;0;2;29;0
ASEEND*/
//CHKSM=2C969331E5292341F3868EF8AE55A884F4554D02