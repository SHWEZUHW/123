// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Banter/LoadingCage"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_CageHight("CageHight", Range( 0 , 1)) = 0.3
		_Pano("Pano", CUBE) = "black" {}
		_DisolveGuide("DisolveGuide", 2D) = "white" {}
		_Thumb("Thumb", 2D) = "white" {}
		_ThumbMask("ThumbMask", 2D) = "white" {}
		[Header(Change On Runtime)]_DissolveLoadAmount("Dissolve Load Amount", Range( 0 , 1)) = 0
		_DissolveAmount("Dissolve Amount", Range( 0 , 1)) = 0
		_Hue("Hue", Range( 0 , 1)) = 1
		_Brighness("Brighness", Range( 0 , 1)) = 0.5
		_BurnColor("BurnColor", Color) = (0,0,0,0)
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord3( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Overlay+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		ZTest Always
		CGPROGRAM
		#pragma target 3.0
		#pragma only_renderers d3d11 glcore gles3 vulkan 
		#pragma surface surf Unlit keepalpha noshadow exclude_path:deferred noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
			float2 uv2_texcoord2;
			float2 uv3_texcoord3;
			half3 viewDir;
			INTERNAL_DATA
		};

		uniform samplerCUBE _Pano;
		uniform half _Hue;
		uniform half _Brighness;
		uniform sampler2D _MainTex;
		uniform half4 _MainTex_ST;
		uniform float _CageHight;
		uniform sampler2D _Thumb;
		uniform float _DissolveLoadAmount;
		uniform sampler2D _DisolveGuide;
		uniform half4 _BurnColor;
		uniform sampler2D _ThumbMask;
		uniform float _DissolveAmount;
		uniform float _Cutoff = 0.5;


		half3 HSVToRGB( half3 c )
		{
			half4 K = half4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			half3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		half3 RGBToHSV(half3 c)
		{
			half4 K = half4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
			half4 p = lerp( half4( c.bg, K.wz ), half4( c.gb, K.xy ), step( c.b, c.g ) );
			half4 q = lerp( half4( p.xyw, c.r ), half4( c.r, p.yzx ), step( p.x, c.r ) );
			half d = q.x - min( q.w, q.y );
			half e = 1.0e-10;
			return half3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Normal = float3(0,0,1);
			float3 ase_worldPos = i.worldPos;
			half3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			half3 appendResult18 = (half3(ase_worldViewDir.x , -ase_worldViewDir.y , ase_worldViewDir.z));
			half3 hsvTorgb69 = RGBToHSV( texCUBE( _Pano, appendResult18 ).rgb );
			half3 hsvTorgb70 = HSVToRGB( half3(( hsvTorgb69.x * _Hue ),hsvTorgb69.y,( hsvTorgb69.z * _Brighness )) );
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			half4 tex2DNode5 = tex2D( _MainTex, uv_MainTex );
			half smoothstepResult37 = smoothstep( ( 1.0 - _CageHight ) , 1.0 , ( 1.0 - i.uv2_texcoord2.y ));
			half4 lerpResult9 = lerp( half4( hsvTorgb70 , 0.0 ) , tex2DNode5 , ( tex2DNode5.a * smoothstepResult37 ));
			float2 uv3_TexCoord4 = i.uv3_texcoord3 * float2( 1,1.2 ) + float2( 0,-0.125 );
			half3 appendResult45 = (half3(-i.viewDir.y , -i.viewDir.x , i.viewDir.z));
			half2 Offset44 = ( ( 3.0 - 1 ) * appendResult45.xy * 0.1 ) + uv3_TexCoord4;
			half temp_output_49_0 = ( (-1.0 + (_DissolveLoadAmount - -0.5) * (2.0 - -1.0) / (2.4 - -0.5)) + ( ( 1.0 - uv3_TexCoord4.x ) * ( 1.0 - tex2D( _DisolveGuide, uv3_TexCoord4 ).r ) ) );
			half clampResult61 = clamp( (-20.0 + (temp_output_49_0 - 0.0) * (20.0 - -20.0) / (1.0 - 0.0)) , 0.0 , 1.0 );
			half smoothstepResult68 = smoothstep( 0.45 , 0.5 , temp_output_49_0);
			half4 lerpResult43 = lerp( lerpResult9 , ( tex2D( _Thumb, Offset44 ) + ( ( 1.0 - clampResult61 ) * _BurnColor ) ) , saturate( ( tex2D( _ThumbMask, uv3_TexCoord4 ).r * smoothstepResult68 ) ));
			half temp_output_26_0 = ( (-0.6 + (( 1.0 - _DissolveAmount ) - 0.0) * (0.6 - -0.6) / (1.0 - 0.0)) + ( ( 1.0 - tex2D( _DisolveGuide, i.uv2_texcoord2 ).r ) * i.uv2_texcoord2.x ) );
			half temp_output_80_0 = (-20.0 + (temp_output_26_0 - 0.0) * (20.0 - -20.0) / (1.0 - 0.0));
			half temp_output_78_0 = ( 1.0 - saturate( temp_output_80_0 ) );
			o.Emission = ( lerpResult43 + ( temp_output_78_0 * _BurnColor ) ).rgb;
			o.Alpha = 1;
			clip( temp_output_26_0 - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-465.2849,279.0156;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;25;-657.5927,-40.27557;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.6;False;4;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-878.3889,-256.5548;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;0;False;0;False;-1;None;d67b33fb39fcbf94aa1ed8b032448778;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-148.1389,228.153;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-339.6747,-162.7871;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1226.839,-36.27537;Float;False;Property;_DissolveAmount;Dissolve Amount;9;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;37;-319.1012,7.220459;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.7;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-1241.69,112.2571;Float;False;Property;_CageHight;CageHight;2;0;Create;True;0;0;0;False;0;False;0.3;0.532;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;29;-894.0937,0.7230008;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;39;-886.5146,100.3457;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;43;134.5932,-587.9445;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;475.2531,-419.6386;Half;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Banter/LoadingCage;False;False;False;False;True;True;True;True;True;True;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;7;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;False;0;True;TransparentCutout;;Overlay;ForwardOnly;4;d3d11;glcore;gles3;vulkan;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;0;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.OneMinusNode;28;-603.7439,430.1827;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;40;-478.6864,530.0887;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;47;-2070.754,-1497.661;Inherit;False;932.2314;729.3652;Dissolve - Opacity Mask;6;59;58;56;55;51;49;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;49;-1399.067,-1441.315;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-1466.226,-1234.621;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;45;-1057.306,-1138.981;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;41;-464.7766,-1812.807;Inherit;True;Property;_Thumb;Thumb;6;0;Create;True;0;0;0;False;0;False;-1;None;874af742347cf3944ac9472b15b38d40;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;64;-78.04279,-748.9148;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;56;-1620.767,-1013.142;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;65;-1574.437,-799.5352;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ParallaxMappingNode;44;-692.8353,-1246.637;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;3;False;2;FLOAT;0.1;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-270.821,-1047.717;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-1028.475,-991.1717;Inherit;False;2;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1.2;False;1;FLOAT2;0,-0.125;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;59;-1953.4,-1017.046;Inherit;True;Property;_ThumbDisolveGuide;ThumbDisolveGuide;4;0;Create;True;0;0;0;False;0;False;-1;None;01de44b61b94e274d989066502c32429;True;0;False;white;Auto;False;Instance;22;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;23;-1421.974,474.8136;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;22;-1977.979,-39.54396;Inherit;True;Property;_DisolveGuide;DisolveGuide;4;0;Create;True;0;0;0;False;0;False;-1;None;9727d48ef919e304d9e953a2e7ca9ad6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NegateNode;30;-1067.503,-507.5777;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;16;-1565.275,-445.1999;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;66;-1595.175,-681.7311;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NegateNode;46;-1327.261,-769.1144;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;67;-1289.176,-685.5515;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;68;-1046.675,-1396.544;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.45;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;51;-1726.601,-1432.533;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-0.5;False;2;FLOAT;2.4;False;3;FLOAT;-1;False;4;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;9;20.64999,-314.6;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;6;-769.35,-501.6;Inherit;True;Property;_Pano;Pano;3;0;Create;True;0;0;0;False;0;False;-1;None;94f750385b8cf18479a3ddfa25d49728;True;0;False;black;LockedToCube;False;Object;-1;Auto;Cube;8;0;SAMPLERCUBE;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;18;-928.35,-492.6;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RGBToHSVNode;69;-468.2639,-613.5459;Inherit;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.HSVToRGBNode;70;-150.2639,-570.5459;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;-374.2639,-716.5459;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;-309.2639,-434.5459;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-572.2639,-322.5459;Inherit;False;Property;_Brighness;Brighness;11;0;Create;True;0;0;0;False;0;False;0.5;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-881.0006,-1690.5;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;62;-1714.417,-1903.633;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-183.5644,1013.597;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;77;-880.0624,917.2791;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;78;-1016.98,800.4642;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;50;-202.448,-1501.122;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;35;-658.0906,202.4843;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;81;304.9983,-275.7658;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;76;-678.6306,1299.207;Inherit;True;Property;_BurnRamp1;Burn Ramp;5;0;Create;True;0;0;0;False;0;False;-1;None;96f1785558043bf48bacf57b6511b602;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;79;-1152.007,1124.999;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.8;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;84;-1136.993,964.8915;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;80;-1600.059,984.1041;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-20;False;4;FLOAT;20;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;60;-2145.495,-1719.993;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-20;False;4;FLOAT;20;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;61;-1887.441,-1820.897;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;82;-682.9114,1092.778;Inherit;False;Property;_BurnColor;BurnColor;12;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;72;-690.2639,-712.5459;Inherit;False;Property;_Hue;Hue;10;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;42;-599.6092,-955.0436;Inherit;True;Property;_ThumbMask;ThumbMask;7;0;Create;True;0;0;0;False;0;False;-1;None;667285e80bb9f46468021bb7994d43a9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;58;-2254.721,-1421.202;Float;False;Property;_DissolveLoadAmount;Dissolve Load Amount;8;1;[Header];Create;True;1;Change On Runtime;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
WireConnection;27;0;35;0
WireConnection;27;1;23;1
WireConnection;25;0;29;0
WireConnection;26;0;25;0
WireConnection;26;1;27;0
WireConnection;36;0;5;4
WireConnection;36;1;37;0
WireConnection;37;0;40;0
WireConnection;37;1;39;0
WireConnection;29;0;24;0
WireConnection;39;0;38;0
WireConnection;43;0;9;0
WireConnection;43;1;50;0
WireConnection;43;2;64;0
WireConnection;0;2;81;0
WireConnection;0;10;26;0
WireConnection;28;0;23;1
WireConnection;40;0;23;2
WireConnection;49;0;51;0
WireConnection;49;1;55;0
WireConnection;55;0;65;0
WireConnection;55;1;56;0
WireConnection;45;0;67;0
WireConnection;45;1;46;0
WireConnection;45;2;66;3
WireConnection;41;1;44;0
WireConnection;64;0;63;0
WireConnection;56;0;59;1
WireConnection;65;0;4;1
WireConnection;44;0;4;0
WireConnection;44;3;45;0
WireConnection;63;0;42;1
WireConnection;63;1;68;0
WireConnection;59;1;4;0
WireConnection;22;1;23;0
WireConnection;30;0;16;2
WireConnection;46;0;66;1
WireConnection;67;0;66;2
WireConnection;68;0;49;0
WireConnection;51;0;58;0
WireConnection;9;0;70;0
WireConnection;9;1;5;0
WireConnection;9;2;36;0
WireConnection;6;1;18;0
WireConnection;18;0;16;1
WireConnection;18;1;30;0
WireConnection;18;2;16;3
WireConnection;69;0;6;0
WireConnection;70;0;71;0
WireConnection;70;1;69;2
WireConnection;70;2;73;0
WireConnection;71;0;69;1
WireConnection;71;1;72;0
WireConnection;73;0;69;3
WireConnection;73;1;74;0
WireConnection;48;0;62;0
WireConnection;48;1;82;0
WireConnection;62;0;61;0
WireConnection;75;0;78;0
WireConnection;75;1;82;0
WireConnection;77;0;78;0
WireConnection;78;0;84;0
WireConnection;50;0;41;0
WireConnection;50;1;48;0
WireConnection;35;0;22;1
WireConnection;81;0;43;0
WireConnection;81;1;75;0
WireConnection;76;1;77;0
WireConnection;79;0;80;0
WireConnection;84;0;80;0
WireConnection;80;0;26;0
WireConnection;60;0;49;0
WireConnection;61;0;60;0
WireConnection;42;1;4;0
ASEEND*/
//CHKSM=BD7B6A7F1D6A77B9C15DB399591AAB47D26215D5