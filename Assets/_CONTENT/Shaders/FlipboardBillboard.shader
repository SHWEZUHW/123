// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FlipboardBillboard"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Columns("Columns", Int) = 0
		_Rows("Rows", Int) = 0
		_Speed("Speed", Float) = 0
		_Tint("Tint", Color) = (0,0,0,0)
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
		};

		uniform sampler2D _TextureSample0;
		uniform int _Columns;
		uniform int _Rows;
		uniform half _Speed;
		uniform half4 _Tint;
		uniform float _Cutoff = 0.5;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			//Calculate new billboard vertex position and normal;
			float3 upCamVec = float3( 0, 1, 0 );
			float3 forwardCamVec = -normalize ( UNITY_MATRIX_V._m20_m21_m22 );
			float3 rightCamVec = normalize( UNITY_MATRIX_V._m00_m01_m02 );
			float4x4 rotationCamMatrix = float4x4( rightCamVec, 0, upCamVec, 0, forwardCamVec, 0, 0, 0, 0, 1 );
			v.normal = normalize( mul( float4( v.normal , 0 ), rotationCamMatrix )).xyz;
			v.tangent.xyz = normalize( mul( float4( v.tangent.xyz , 0 ), rotationCamMatrix )).xyz;
			//This unfortunately must be made to take non-uniform scaling into account;
			//Transform to world coords, apply rotation and transform back to local;
			v.vertex = mul( v.vertex , unity_ObjectToWorld );
			v.vertex = mul( v.vertex , rotationCamMatrix );
			v.vertex = mul( v.vertex , unity_WorldToObject );
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			// *** BEGIN Flipbook UV Animation vars ***
			// Total tiles of Flipbook Texture
			float fbtotaltiles2 = (float)_Columns * (float)_Rows;
			// Offsets for cols and rows of Flipbook Texture
			float fbcolsoffset2 = 1.0f / (float)_Columns;
			float fbrowsoffset2 = 1.0f / (float)_Rows;
			// Speed of animation
			float fbspeed2 = _Time.y * _Speed;
			// UV Tiling (col and row offset)
			float2 fbtiling2 = float2(fbcolsoffset2, fbrowsoffset2);
			// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
			// Calculate current tile linear index
			float fbcurrenttileindex2 = round( fmod( fbspeed2 + 0.0, fbtotaltiles2) );
			fbcurrenttileindex2 += ( fbcurrenttileindex2 < 0) ? fbtotaltiles2 : 0;
			// Obtain Offset X coordinate from current tile linear index
			float fblinearindextox2 = round ( fmod ( fbcurrenttileindex2, (float)_Columns ) );
			// Multiply Offset X by coloffset
			float fboffsetx2 = fblinearindextox2 * fbcolsoffset2;
			// Obtain Offset Y coordinate from current tile linear index
			float fblinearindextoy2 = round( fmod( ( fbcurrenttileindex2 - fblinearindextox2 ) / (float)_Columns, (float)_Rows ) );
			// Reverse Y to get tiles from Top to Bottom
			fblinearindextoy2 = (int)((float)_Rows-1) - fblinearindextoy2;
			// Multiply Offset Y by rowoffset
			float fboffsety2 = fblinearindextoy2 * fbrowsoffset2;
			// UV Offset
			float2 fboffset2 = float2(fboffsetx2, fboffsety2);
			// Flipbook UV
			half2 fbuv2 = i.uv_texcoord * fbtiling2 + fboffset2;
			// *** END Flipbook UV Animation vars ***
			half4 tex2DNode3 = tex2D( _TextureSample0, fbuv2 );
			o.Emission = ( tex2DNode3 + _Tint ).rgb;
			o.Alpha = 1;
			clip( tex2DNode3.a - _Cutoff );
		}

		ENDCG
	}
	Fallback "Mobile/Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-948,-436;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IntNode;6;-950,-314;Inherit;False;Property;_Columns;Columns;2;0;Create;True;0;0;0;False;0;False;0;8;False;0;1;INT;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;2;-659,-195;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;8;False;2;FLOAT;8;False;3;FLOAT;25;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.IntNode;7;-945,-221;Inherit;False;Property;_Rows;Rows;3;0;Create;True;0;0;0;False;0;False;0;8;False;0;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-940,-125;Inherit;False;Property;_Speed;Speed;4;0;Create;True;0;0;0;False;0;False;0;25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;4;-941,-27;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-888.3967,127.36;Inherit;False;Property;_Billboard;Billboard;5;0;Create;True;0;0;0;False;1;Billboard;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-391,-216;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;10b816ca971c6804cad875b9ea9a780a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;270,-138;Half;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;FlipboardBillboard;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;True;Cylindrical;False;True;Relative;0;Mobile/Diffuse;1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleAddOpNode;18;18.60303,-340.64;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;19;-274.397,-447.64;Inherit;False;Property;_Tint;Tint;6;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;2;0;5;0
WireConnection;2;1;6;0
WireConnection;2;2;7;0
WireConnection;2;3;9;0
WireConnection;2;5;4;0
WireConnection;3;1;2;0
WireConnection;0;2;18;0
WireConnection;0;10;3;4
WireConnection;18;0;3;0
WireConnection;18;1;19;0
ASEEND*/
//CHKSM=30B70E1FBD0F66C63AE1AEEE4F72A1E16B3155A0