// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RaveFloor"
{
	Properties
	{
		_Mask("Mask", 2D) = "black" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv2_texcoord2;
		};

		uniform sampler2D _Mask;
		uniform float4 _Mask_ST;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv1_Mask = i.uv2_texcoord2 * _Mask_ST.xy + _Mask_ST.zw;
			float4 tex2DNode1 = tex2D( _Mask, uv1_Mask );
			o.Emission = tex2DNode1.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.SimpleSubtractOpNode;19;-339.1131,564.5647;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-976.3138,-50.67845;Inherit;False;Property;_Min;Min;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-971.1053,26.9008;Inherit;False;Property;_Max;Max;3;0;Create;True;0;0;0;False;0;False;0;15.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-0.3826294,-71.67618;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;32;-123.2842,236.8578;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleTimeNode;25;-766.7598,286.5769;Inherit;False;1;0;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;20;-607.9111,479.5422;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;21;-606.2111,603.3795;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.05;False;2;FLOAT;0.08;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-94.06421,-452.2445;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;36;-600.4847,-115.4364;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;38;-750.5641,-89.54479;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-1573.695,-363.331;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;4;-1315.536,-246.019;Inherit;False;0;1;1;4;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;7;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.LerpOp;5;-907.3719,-310.8648;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;2;-587.9683,-622.0673;Inherit;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;0;False;0;False;-1;None;9fcb8cf15a79d7949b513ea805fabad0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-314.9846,-320.1943;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;864.8511,18.2686;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;RaveFloor;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;123.5755,400.3097;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.HSVToRGBNode;23;-376.5135,382.2132;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;43;619.2804,150.8619;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;41;515.5627,327.8749;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;16;-320.9868,-42.83029;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;3;FLOAT;40;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;18;232.6615,-354.3492;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-636.2411,123.7811;Inherit;True;Property;_Mask;Mask;0;0;Create;True;0;0;0;False;0;False;-1;None;e350a7062e8f6aa4e80c8c9209580e9d;True;1;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;26;761.8493,8.100582;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
WireConnection;19;0;20;0
WireConnection;19;1;21;0
WireConnection;31;0;16;0
WireConnection;31;1;32;0
WireConnection;32;0;23;0
WireConnection;20;0;1;1
WireConnection;21;0;1;1
WireConnection;37;0;39;0
WireConnection;37;1;2;0
WireConnection;36;0;38;0
WireConnection;38;0;4;0
WireConnection;4;0;3;0
WireConnection;4;1;25;0
WireConnection;5;0;3;0
WireConnection;5;1;4;0
WireConnection;5;2;6;0
WireConnection;2;1;5;0
WireConnection;39;0;36;0
WireConnection;39;1;23;0
WireConnection;0;2;1;0
WireConnection;24;0;19;0
WireConnection;24;1;23;0
WireConnection;23;0;25;0
WireConnection;43;0;31;0
WireConnection;43;1;23;0
WireConnection;43;2;1;1
WireConnection;41;0;2;0
WireConnection;41;1;23;0
WireConnection;16;2;36;0
WireConnection;18;0;31;0
WireConnection;18;1;37;0
WireConnection;18;2;1;1
WireConnection;26;0;18;0
WireConnection;26;1;24;0
ASEEND*/
//CHKSM=43D004F749393043BAA390C4BCB6F25462C88392