// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BlurTestASE"
{
	Properties
	{
		_Texture0("Texture 0", 2D) = "white" {}
		_Blur("Blur", Range( 0 , 0.02)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "Functions/GaussianBlurFunction/GaussianBlurASE.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Texture0;
		uniform float4 _Texture0_ST;
		uniform float _Blur;
		SamplerState sampler_Texture0;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			sampler2D Texture1_g16 = _Texture0;
			float2 uv_Texture0 = i.uv_texcoord * _Texture0_ST.xy + _Texture0_ST.zw;
			float2 UV1_g16 = uv_Texture0;
			float Blur1_g16 = _Blur;
			float Quality1_g16 = 6.0;
			float Directions1_g16 = 32.0;
			SamplerState Sampler1_g16 = sampler_Texture0;
			float TextureAlpha1_g16 = 0.0;
			float4 localGaussianBlurASE1_g16 = GaussianBlurASE_float( Texture1_g16 , UV1_g16 , Blur1_g16 , Quality1_g16 , Directions1_g16 , Sampler1_g16 , TextureAlpha1_g16 );
			o.Emission = localGaussianBlurASE1_g16.xyz;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;33;-160,-48;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;BlurTestASE;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.FunctionNode;32;-448,-48;Inherit;False;GaussianBlur;-1;;16;6765d09d9703cbc4f91a813a22575f6a;0;6;11;SAMPLER2D;0;False;5;FLOAT2;0,0;False;6;FLOAT;0;False;7;FLOAT;6;False;8;FLOAT;32;False;9;SAMPLERSTATE;;False;2;FLOAT4;0;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;21;-800,160;Inherit;False;Property;_Blur;Blur;1;0;Create;True;0;0;0;False;0;False;0;0;0;0.02;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-736,32;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;11;-1024,-48;Inherit;True;Property;_Texture0;Texture 0;0;0;Create;True;0;0;0;False;0;False;None;2c6536772776dd84f872779990273bfc;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerStateNode;25;-704,240;Inherit;False;1;1;1;1;11;None;1;0;SAMPLER2D;;False;1;SAMPLERSTATE;0
WireConnection;33;2;32;0
WireConnection;32;11;11;0
WireConnection;32;5;12;0
WireConnection;32;6;21;0
WireConnection;32;9;25;0
WireConnection;12;2;11;0
ASEEND*/
//CHKSM=E9E3A210B1317936F02C0B048832A8CCD2E8D6F5