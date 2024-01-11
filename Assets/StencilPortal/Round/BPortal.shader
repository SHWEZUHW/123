// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BPortal"
{
	Properties
	{
		_Depth("Depth", Range( 0 , 1)) = 0
		_PortalRadius("PortalRadius", Range( 0 , 10)) = 2
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
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _Depth;
		uniform float _PortalRadius;


		half easeOutBack306( half x )
		{
			half1 c1 = 1.70158;
			half1 c3 = c1 + 1;
			return 1 + c3 * pow(x - 1, 3) + c1 * pow(x - 1, 2);
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 PurePolarUV166 = v.texcoord.xy;
			float temp_output_328_0 = ( 1.0 - PurePolarUV166.y );
			float temp_output_320_0 = saturate( ( temp_output_328_0 - 0.11 ) );
			float smoothstepResult335 = smoothstep( 0.15 , 0.42 , temp_output_320_0);
			float AlbedoMask325 = smoothstepResult335;
			float3 worldToObj315 = mul( unity_WorldToObject, float4( _WorldSpaceCameraPos, 1 ) ).xyz;
			float RawPlayerDistance318 = ( length( worldToObj315 ) * 0.1 );
			float temp_output_288_0 = ( 1.0 - RawPlayerDistance318 );
			float temp_output_290_0 = ( temp_output_288_0 * temp_output_288_0 * temp_output_288_0 * temp_output_288_0 );
			float PlayerMaskDepth284 = temp_output_290_0;
			float3 ase_parentObjectScale = (1.0/float3( length( unity_WorldToObject[ 0 ].xyz ), length( unity_WorldToObject[ 1 ].xyz ), length( unity_WorldToObject[ 2 ].xyz ) ));
			float temp_output_309_0 = ( 1.0 - saturate( ( RawPlayerDistance318 - _PortalRadius ) ) );
			float PlayerAlbedoMask293 = temp_output_309_0;
			float3 ase_vertexNormal = v.normal.xyz;
			float3 ase_vertex3Pos = v.vertex.xyz;
			float clampResult307 = clamp( temp_output_309_0 , 0.2 , 1.0 );
			half x306 = clampResult307;
			half localeaseOutBack306 = easeOutBack306( x306 );
			float PlayerMaskScale291 = localeaseOutBack306;
			float3 temp_output_264_0 = ( ( ( saturate( ( AlbedoMask325 - -0.16 ) ) * ( -( ( PlayerMaskDepth284 / ase_parentObjectScale ) + ( PlayerMaskDepth284 * _Depth ) ) * PlayerAlbedoMask293 ) ) * ase_vertexNormal ) + ( ase_vertex3Pos * PlayerMaskScale291 ) );
			v.vertex.xyz += temp_output_264_0;
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 PurePolarUV166 = i.uv_texcoord;
			float temp_output_328_0 = ( 1.0 - PurePolarUV166.y );
			float saferPower336 = abs( temp_output_328_0 );
			float smoothstepResult332 = smoothstep( 0.03 , 0.19 , pow( saferPower336 , 2.2 ));
			float3 temp_cast_0 = (saturate( smoothstepResult332 )).xxx;
			half3 gammaToLinear330 = temp_cast_0;
			gammaToLinear330 = half3( GammaToLinearSpaceExact(gammaToLinear330.r), GammaToLinearSpaceExact(gammaToLinear330.g), GammaToLinearSpaceExact(gammaToLinear330.b) );
			float Alpha351 = gammaToLinear330.x;
			float temp_output_239_0 = Alpha351;
			float3 temp_cast_1 = (temp_output_239_0).xxx;
			o.Emission = temp_cast_1;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.DynamicAppendNode;1;189.5546,-405.4793;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;3;-282.5857,-414.5203;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;4;-267.5857,-222.5203;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;1.55464,-474.4793;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;33.55464,-252.4794;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-562.5853,-523.5204;Float;False;Property;_X;X;7;0;Create;True;0;0;0;False;0;False;1.65;1.65;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-550.5853,-413.5204;Inherit;False;Property;_Y;Y;9;0;Create;True;0;0;0;False;0;False;0.9;0.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-391.5853,-92.52037;Inherit;False;Property;_YM;YM;15;0;Create;True;0;0;0;False;0;False;0.55;0.55;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-68.1037,127.3582;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;14;-472.1812,68.68219;Inherit;False;Property;_Tint;Tint;10;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.5,0.5,0.5,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;8;-320.5853,-488.5204;Float;False;Property;_XM;XM;13;0;Create;True;0;0;0;False;0;False;0.3;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;20;62,-638.5;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.5,1;False;1;FLOAT2;0.25,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;19;384,-405.5;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BreakToComponentsNode;2;-623.4454,-334.4794;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;21;202,-246.5;Inherit;False;Property;_Float0;Float 0;16;0;Create;True;0;0;0;False;0;False;0;0.83;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;10;254.9132,-161.8884;Inherit;True;Property;_CloseTexture;CloseTexture;1;0;Create;True;0;0;0;False;0;False;-1;None;f78c047cec8090f4aa10cd3030f07d06;True;0;False;white;LockedToTexture2D;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RotateAboutAxisNode;56;1010.664,-131.6071;Inherit;False;False;4;0;FLOAT3;0,0,0;False;1;FLOAT;0.78;False;2;FLOAT3;0.5,0.5,0.5;False;3;FLOAT3;1,1,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleTimeNode;58;846.8693,-306.2827;Inherit;False;1;0;FLOAT;6;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode;59;640.8693,-224.2827;Inherit;False;1;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;30;368.5462,100.9985;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;11;-874.6296,-340.2199;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;49;691.728,-98.57647;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;734.9106,213.4284;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CameraDepthFade;13;-653.2251,225.4837;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;10;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;15;-349.5415,252.9205;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;17;-60.82552,231.9563;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;154;-2287.14,-368.0282;Inherit;False;PureUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;155;-2495.14,-368.0282;Inherit;False;1;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexCoordVertexDataNode;156;-2495.14,-496.0282;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;157;-2495.14,-224.0282;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;159;-1967.14,-640.0282;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;160;-2495.14,-640.0282;Inherit;False;1;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;161;-2287.14,-640.0282;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;162;-2127.14,-640.0282;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;1,1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;163;-1615.14,-640.0282;Inherit;True;Fresnel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexToFragmentNode;165;-1823.14,-566.0282;Inherit;False;False;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;166;-2287.14,-496.0282;Inherit;False;PurePolarUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VertexToFragmentNode;164;-2317.14,-155.0282;Inherit;False;False;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;158;-2111.14,-224.0282;Inherit;False;PureTime;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;167;666.3953,3097.932;Inherit;False;2076.157;530.6051;;20;319;279;278;277;276;275;274;273;272;271;270;269;268;267;266;265;264;263;262;241;VERTEX OFFSET;0.1840543,0.1194375,0.4150943,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;168;-2185.148,2377.932;Inherit;False;1573.174;1023.792;;28;246;245;244;212;211;210;209;208;207;206;205;204;203;202;201;200;199;198;197;196;195;194;193;192;191;190;189;188;SAMPLES;0.7650781,0,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;169;-2177.068,1543.932;Inherit;False;1845.239;750.7199;;19;261;260;254;253;250;249;248;247;236;229;228;227;187;186;185;184;183;182;181;TEXTURES;0.02988511,0.2264151,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;170;-568.3486,2371.432;Inherit;False;1172;371;;11;243;242;221;180;179;178;177;176;175;174;173;PORTAL SPEED;1,0.8515098,0.5613208,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;171;-3819.045,2345.932;Inherit;False;1557.897;1037.81;;40;352;318;317;316;315;314;313;312;311;310;309;308;307;306;305;304;303;302;301;300;299;298;297;296;295;294;293;292;291;290;289;288;287;286;285;284;283;282;281;280;PLAYER MASKS;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;172;-3641.148,3577.932;Inherit;False;2116;547;;18;351;336;335;334;333;332;331;330;329;328;327;326;325;324;323;322;321;320;PORTAL MASKS;0,0.2732866,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;173;183.6512,2595.432;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;174;-8.348755,2595.432;Inherit;False;FLOAT2;4;0;FLOAT;0.1;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;175;7.651245,2419.432;Inherit;False;FLOAT2;4;0;FLOAT;0.1;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;176;183.6512,2483.432;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;177;-520.3486,2419.432;Inherit;False;Property;_RotationSpeed;RotationSpeed;17;0;Create;True;0;0;0;False;0;False;0.1;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;178;-488.3486,2627.432;Inherit;False;Property;_InwardsSpeed;InwardsSpeed;14;0;Create;True;0;0;0;False;0;False;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;179;359.6512,2595.432;Inherit;False;MaxRotSpeed;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;180;-328.3486,2483.432;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;15;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;181;-1769.148,1897.932;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;182;-2041.148,1881.932;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;183;-2009.148,2009.932;Inherit;False;Property;_DistortionSpeed;DistortionSpeed;12;0;Create;True;0;0;0;False;0;False;0,0.3;0,0.3;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;184;-2009.148,2137.932;Inherit;False;158;PureTime;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;185;-1561.148,1881.932;Inherit;True;Property;_Distortion;Distortion;8;1;[Normal];Create;True;0;0;0;False;0;False;-1;c2c9b234d7873b14ba16c19badf81fd3;c2c9b234d7873b14ba16c19badf81fd3;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;186;-1385.148,1657.932;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;187;-1273.148,1657.932;Inherit;True;Property;_Thumbnail;Thumbnail;0;0;Create;True;0;0;0;False;0;False;-1;24530903478a81946a8821282769369c;325032e82e6dda94181685143a53d37a;True;1;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;188;-1737.148,3209.932;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;189;-2121.148,3177.932;Inherit;False;243;RotSpeed;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;190;-1929.148,3273.932;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;1,3;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;191;-2121.148,3273.932;Inherit;False;166;PurePolarUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;192;-2137.148,3033.932;Inherit;False;179;MaxRotSpeed;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;193;-1913.148,3177.932;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;194;-1929.148,3033.932;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;195;-1737.148,3033.932;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;196;-1561.148,3193.932;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;197;-1561.148,3033.932;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;198;-1433.148,3177.932;Inherit;True;Property;_TextureSample2;Texture Sample 2;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;199;-1433.148,2985.932;Inherit;True;Property;_TextureSample4;Texture Sample 2;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;200;-1849.148,2905.932;Inherit;False;229;DistortionTexture;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;201;-1577.148,2681.932;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;202;-1769.148,2681.932;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;203;-1577.148,2521.932;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;204;-1801.148,2473.932;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;205;-2057.148,2473.932;Inherit;False;179;MaxRotSpeed;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;206;-1433.148,2697.932;Inherit;True;Property;_TextureSample1;Texture Sample 1;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;207;-1433.148,2441.932;Inherit;True;Property;_TextureSample3;Texture Sample 1;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;208;-1369.148,2889.932;Inherit;False;295;PlayerMaskSpeed;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;209;-1113.148,3113.932;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;210;-1129.148,2681.932;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;211;-825.1477,3113.932;Inherit;False;InnerTexture;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;212;-969.1477,3113.932;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;213;1526.852,2473.932;Inherit;False;324;GlowMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;214;1558.852,2553.932;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;215;1414.852,2553.932;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;216;1238.852,2553.932;Inherit;False;211;InnerTexture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;217;1222.852,2233.932;Inherit;False;Property;_OuterColor2;OuterColor2;19;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;1.94603,7.423744,13.76636,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;218;1222.852,2057.932;Inherit;False;Property;_OuterColor1;OuterColor1;18;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;0,0.1092456,1.304119,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;219;1478.852,2153.932;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;220;1782.852,2697.932;Inherit;False;293;PlayerAlbedoMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;221;-216.3486,2627.432;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;222;2454.852,2569.932;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;223;2102.852,2153.932;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;224;1270.852,2409.932;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;225;1974.852,2489.932;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;226;950.8523,2409.932;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;227;-1273.148,1881.932;Inherit;False;FLOAT3;0;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;228;-1129.148,1881.932;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;229;-985.1477,1881.932;Inherit;True;DistortionTexture;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;230;790.8523,2489.932;Inherit;False;Constant;_Float1;Float 0;8;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;231;1094.852,2409.932;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;232;2806.852,2585.932;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;233;2006.852,2633.932;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;234;1830.852,2761.932;Inherit;False;Constant;_Float4;Float 4;13;0;Create;True;0;0;0;False;0;False;0.65;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;235;1894.852,2601.932;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;236;-569.1477,1657.932;Inherit;False;Thumb;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;237;2038.852,2761.932;Inherit;False;325;AlbedoMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;238;2745.852,2802.932;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;240;1718.852,2617.932;Inherit;False;236;Thumb;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;242;-8.348755,2515.432;Inherit;False;158;PureTime;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;243;343.6512,2483.432;Inherit;False;RotSpeed;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;244;-2057.148,2617.932;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;245;-2025.148,2745.932;Inherit;False;243;RotSpeed;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;246;-841.1477,2681.932;Inherit;False;OuterTexture;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;247;-1652.148,1548.932;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;248;-1636.148,1686.932;Inherit;True;229;DistortionTexture;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;249;-1545.148,2073.932;Inherit;False;Property;_DistortionStrength;Distortion Strength;11;0;Create;True;0;0;0;False;0;False;0.03;0.011;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;250;-1513.148,2153.932;Inherit;True;294;PlayerMaskDistortion;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GammaToLinearNode;252;2168.852,2553.932;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;253;-955.1477,1725.932;Inherit;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;1.05;False;1;COLOR;0
Node;AmplifyShaderEditor.LinearToGammaNode;254;-774.1477,1728.932;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;255;742.8523,2409.932;Inherit;False;246;OuterTexture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LinearToGammaNode;256;1729.652,2099.333;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GammaToLinearNode;257;2252.852,2207.932;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LinearToGammaNode;258;1734.852,2298.932;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;259;1478.852,2297.932;Inherit;False;Property;_InnerColor;InnerColor;20;1;[HDR];Create;True;0;0;0;False;0;False;11.44681,14.02013,16.94838,0;11.44681,14.02013,16.94838,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;260;-1981.148,1599.932;Inherit;True;Property;_NoisePackRGBA;NoisePackRGBA;2;0;Create;True;0;0;0;False;0;False;-1;46c5f003a8773cc4899579223c874d0b;46c5f003a8773cc4899579223c874d0b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;261;-2166.148,1629.932;Inherit;False;166;PurePolarUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;262;2214.852,3321.932;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PosVertexDataNode;263;2006.852,3257.932;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;264;2374.852,3161.932;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;265;2022.852,3157.932;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;266;1782.852,3254.932;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;267;1798.852,3160.932;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;-2,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;268;1590.852,3272.932;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;269;1590.852,3160.932;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;270;1414.852,3160.932;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;-0.16;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;271;1414.852,3272.932;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;272;1286.852,3272.932;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;273;1222.852,3160.932;Inherit;False;325;AlbedoMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;274;1046.852,3208.932;Inherit;False;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;275;1046.852,3304.932;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;276;742.8523,3432.932;Inherit;False;Property;_Depth;Depth;22;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectScaleNode;277;825.8523,3280.932;Inherit;False;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;278;806.8523,3208.932;Inherit;False;284;PlayerMaskDepth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;279;1350.852,3368.932;Inherit;False;293;PlayerAlbedoMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;280;-3193.148,2393.932;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;281;-3433.148,2393.932;Inherit;False;318;RawPlayerDistance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;282;-2921.148,2393.932;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;283;-3049.148,2393.932;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.7;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;284;-2585.148,2761.932;Inherit;False;PlayerMaskDepth;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;285;-3097.148,2617.932;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;286;-3209.148,2617.932;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;287;-3529.148,2793.932;Inherit;False;318;RawPlayerDistance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;288;-3289.148,2793.932;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;289;-3129.148,2793.932;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;290;-2969.148,2761.932;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;291;-2505.148,2953.932;Inherit;False;PlayerMaskScale;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;292;-3321.148,2873.932;Inherit;False;Constant;_depthradius;_depthradius;13;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;293;-3017.148,3065.932;Inherit;False;PlayerAlbedoMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;294;-2569.148,2521.932;Inherit;True;PlayerMaskDistortion;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;295;-2569.148,2393.932;Inherit;False;PlayerMaskSpeed;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;296;-3609.148,2425.932;Inherit;False;Constant;_speedradius;_speedradius;13;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;297;-3417.148,2697.932;Inherit;False;Constant;_distortionradius;_distortionradius;13;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;298;-3257.148,2520.932;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;299;-2937.148,2521.932;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;300;-3097.148,2521.932;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;301;-3449.148,2617.932;Inherit;False;318;RawPlayerDistance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexToFragmentNode;302;-2806.148,2826.932;Inherit;False;False;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexToFragmentNode;303;-2856.148,2993.932;Inherit;False;True;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexToFragmentNode;304;-2786.148,2582.932;Inherit;False;False;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexToFragmentNode;305;-2770.148,2448.932;Inherit;False;False;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;306;-2649.148,2953.932;Half;False;half1 c1 = 1.70158@$half1 c3 = c1 + 1@$$return 1 + c3 * pow(x - 1, 3) + c1 * pow(x - 1, 2)@;1;Create;1;True;x;FLOAT;0;In;;Inherit;False;easeOutBack;True;False;0;;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;307;-3017.148,2953.932;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;308;-3321.148,3049.932;Inherit;False;Constant;_minportalsize;_minportalsize;13;0;Create;True;0;0;0;False;0;False;0.2;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;309;-3177.148,2953.932;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;310;-3321.148,2953.932;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;311;-3465.148,2953.932;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;312;-3753.148,3065.932;Inherit;False;Property;_PortalRadius;PortalRadius;23;0;Create;True;0;0;0;False;0;False;2;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;313;-3722.148,2953.932;Inherit;False;318;RawPlayerDistance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;314;-3305.148,3193.932;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TransformPositionNode;315;-3065.148,3193.932;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LengthOpNode;316;-2841.148,3193.932;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;317;-2689.148,3203.932;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;318;-2537.148,3193.932;Inherit;False;RawPlayerDistance;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;319;1958.852,3401.932;Inherit;False;291;PlayerMaskScale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;320;-3001.148,3769.932;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;321;-3145.148,3769.932;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.11;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;322;-2457.148,3769.932;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;323;-1929.148,3769.932;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;324;-1769.148,3769.932;Inherit;False;GlowMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;325;-2601.148,3961.932;Inherit;False;AlbedoMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;326;-2713.148,3833.932;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.25;False;2;FLOAT;0.68;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;327;-3561.148,3705.932;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.OneMinusNode;328;-3449.148,3689.932;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;329;-2809.148,3625.932;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GammaToLinearNode;330;-2665.148,3625.932;Inherit;False;1;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;331;-2457.148,3625.932;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SmoothstepOpNode;332;-3001.148,3625.932;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.03;False;2;FLOAT;0.19;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;333;-2153.148,3769.932;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;0.35;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;334;-2457.148,3865.932;Inherit;False;Property;_InnerGlowThreshold;InnerGlowThreshold;21;0;Create;True;0;0;0;False;0;False;0.1204973;0.097;0;0.35;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;335;-2777.148,3961.932;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.15;False;2;FLOAT;0.42;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;336;-3145.148,3625.932;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;2.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;337;-3737.148,3705.932;Inherit;False;166;PurePolarUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;338;-3385.148,1961.932;Inherit;False;PureUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;339;-3593.148,1961.932;Inherit;False;1;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexCoordVertexDataNode;340;-3593.148,1833.932;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;341;-3593.148,2105.932;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;342;-3209.148,2105.932;Inherit;False;PureTime;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;343;-3065.148,1689.932;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;344;-3593.148,1689.932;Inherit;False;1;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;345;-3385.148,1689.932;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;346;-3225.148,1689.932;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;1,1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;347;-2713.148,1689.932;Inherit;True;Fresnel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexToFragmentNode;348;-3415.148,2174.932;Inherit;False;False;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexToFragmentNode;349;-2921.148,1763.932;Inherit;False;False;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;350;-3385.148,1833.932;Inherit;False;PurePolarUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;351;-2345.148,3625.932;Inherit;False;Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;352;-3433.148,2520.932;Inherit;False;163;Fresnel;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexToFragmentNode;241;2504.852,3161.932;Inherit;False;True;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2986.15,3060.999;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;BPortal;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.GammaToLinearNode;251;2521.852,2795.932;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;239;2326.852,2793.932;Inherit;False;351;Alpha;1;0;OBJECT;;False;1;FLOAT;0
WireConnection;1;0;5;0
WireConnection;1;1;6;0
WireConnection;1;2;2;2
WireConnection;3;0;2;0
WireConnection;3;1;7;0
WireConnection;4;0;2;1
WireConnection;4;1;9;0
WireConnection;5;0;3;0
WireConnection;5;1;8;0
WireConnection;6;0;4;0
WireConnection;6;1;12;0
WireConnection;16;0;10;0
WireConnection;16;1;14;0
WireConnection;19;0;1;0
WireConnection;19;1;20;0
WireConnection;19;2;21;0
WireConnection;2;0;11;0
WireConnection;10;1;49;0
WireConnection;56;0;20;0
WireConnection;56;1;58;0
WireConnection;49;0;19;0
WireConnection;49;1;56;0
WireConnection;49;2;30;0
WireConnection;31;0;30;0
WireConnection;31;1;17;0
WireConnection;15;0;13;0
WireConnection;17;0;10;0
WireConnection;17;1;16;0
WireConnection;17;2;15;0
WireConnection;154;0;155;0
WireConnection;159;0;162;0
WireConnection;161;0;160;0
WireConnection;162;0;161;0
WireConnection;163;0;159;0
WireConnection;165;0;159;0
WireConnection;166;0;156;0
WireConnection;164;0;157;0
WireConnection;158;0;157;0
WireConnection;173;0;174;0
WireConnection;173;1;242;0
WireConnection;174;0;180;0
WireConnection;174;1;221;0
WireConnection;175;0;177;0
WireConnection;175;1;178;0
WireConnection;176;0;175;0
WireConnection;176;1;242;0
WireConnection;179;0;173;0
WireConnection;180;0;177;0
WireConnection;181;0;182;0
WireConnection;181;2;183;0
WireConnection;181;1;184;0
WireConnection;185;1;181;0
WireConnection;186;0;247;0
WireConnection;186;1;248;0
WireConnection;187;1;186;0
WireConnection;188;0;193;0
WireConnection;188;1;190;0
WireConnection;190;0;191;0
WireConnection;193;0;189;0
WireConnection;194;0;192;0
WireConnection;195;0;194;0
WireConnection;195;1;190;0
WireConnection;196;0;200;0
WireConnection;196;1;188;0
WireConnection;197;0;195;0
WireConnection;197;1;200;0
WireConnection;198;1;196;0
WireConnection;199;1;197;0
WireConnection;201;0;202;0
WireConnection;201;1;200;0
WireConnection;202;0;244;0
WireConnection;202;1;245;0
WireConnection;203;0;204;0
WireConnection;203;1;200;0
WireConnection;204;0;205;0
WireConnection;204;1;244;0
WireConnection;206;1;201;0
WireConnection;207;1;203;0
WireConnection;209;0;198;2
WireConnection;209;1;199;2
WireConnection;209;2;208;0
WireConnection;210;0;206;3
WireConnection;210;1;207;3
WireConnection;210;2;208;0
WireConnection;211;0;212;0
WireConnection;212;0;209;0
WireConnection;214;0;215;0
WireConnection;215;0;216;0
WireConnection;219;0;218;0
WireConnection;219;1;217;0
WireConnection;219;2;224;0
WireConnection;221;0;178;0
WireConnection;222;0;257;0
WireConnection;222;1;233;0
WireConnection;222;2;237;0
WireConnection;223;0;256;0
WireConnection;223;1;225;0
WireConnection;224;0;231;0
WireConnection;225;0;258;0
WireConnection;225;1;213;0
WireConnection;225;2;214;0
WireConnection;226;0;255;0
WireConnection;226;1;230;0
WireConnection;227;0;185;0
WireConnection;228;0;227;0
WireConnection;228;1;249;0
WireConnection;228;2;250;0
WireConnection;229;0;228;0
WireConnection;231;0;226;0
WireConnection;232;0;222;0
WireConnection;232;3;238;0
WireConnection;233;0;235;0
WireConnection;233;1;220;0
WireConnection;233;2;234;0
WireConnection;235;0;240;0
WireConnection;235;1;240;0
WireConnection;236;0;187;0
WireConnection;238;0;251;0
WireConnection;243;0;176;0
WireConnection;246;0;210;0
WireConnection;252;0;233;0
WireConnection;253;1;187;0
WireConnection;254;0;253;0
WireConnection;256;0;219;0
WireConnection;257;0;223;0
WireConnection;258;0;259;0
WireConnection;260;1;261;0
WireConnection;262;0;263;0
WireConnection;262;1;319;0
WireConnection;264;0;265;0
WireConnection;264;1;262;0
WireConnection;265;0;267;0
WireConnection;265;1;266;0
WireConnection;267;0;269;0
WireConnection;267;1;268;0
WireConnection;268;0;271;0
WireConnection;268;1;279;0
WireConnection;269;0;270;0
WireConnection;270;0;273;0
WireConnection;271;0;272;0
WireConnection;272;0;274;0
WireConnection;272;1;275;0
WireConnection;274;0;278;0
WireConnection;274;1;277;0
WireConnection;275;0;278;0
WireConnection;275;1;276;0
WireConnection;280;0;281;0
WireConnection;282;0;283;0
WireConnection;283;0;280;0
WireConnection;283;1;296;0
WireConnection;284;0;290;0
WireConnection;285;0;286;0
WireConnection;286;0;301;0
WireConnection;286;1;297;0
WireConnection;288;0;287;0
WireConnection;289;0;288;0
WireConnection;289;1;292;0
WireConnection;290;0;288;0
WireConnection;290;1;288;0
WireConnection;290;2;288;0
WireConnection;290;3;288;0
WireConnection;291;0;306;0
WireConnection;293;0;309;0
WireConnection;294;0;299;0
WireConnection;295;0;282;0
WireConnection;298;0;352;0
WireConnection;299;0;300;0
WireConnection;299;2;285;0
WireConnection;300;0;298;0
WireConnection;302;0;290;0
WireConnection;303;0;307;0
WireConnection;304;0;299;0
WireConnection;305;0;282;0
WireConnection;306;0;307;0
WireConnection;307;0;309;0
WireConnection;307;1;308;0
WireConnection;309;0;310;0
WireConnection;310;0;311;0
WireConnection;311;0;313;0
WireConnection;311;1;312;0
WireConnection;315;0;314;0
WireConnection;316;0;315;0
WireConnection;317;0;316;0
WireConnection;318;0;317;0
WireConnection;320;0;321;0
WireConnection;321;0;328;0
WireConnection;322;0;320;0
WireConnection;322;1;326;0
WireConnection;323;0;333;0
WireConnection;324;0;323;0
WireConnection;325;0;335;0
WireConnection;326;0;320;0
WireConnection;327;0;337;0
WireConnection;328;0;327;1
WireConnection;329;0;332;0
WireConnection;330;0;329;0
WireConnection;331;0;330;0
WireConnection;332;0;336;0
WireConnection;333;0;322;0
WireConnection;333;1;334;0
WireConnection;335;0;320;0
WireConnection;336;0;328;0
WireConnection;338;0;339;0
WireConnection;342;0;341;0
WireConnection;343;0;346;0
WireConnection;345;0;344;0
WireConnection;346;0;345;0
WireConnection;347;0;343;0
WireConnection;348;0;341;0
WireConnection;349;0;343;0
WireConnection;350;0;340;0
WireConnection;351;0;331;0
WireConnection;241;0;264;0
WireConnection;0;2;239;0
WireConnection;0;11;264;0
WireConnection;251;0;239;0
ASEEND*/
//CHKSM=893C24154B7EDA7D8C71E715CC64712DB72CA74D