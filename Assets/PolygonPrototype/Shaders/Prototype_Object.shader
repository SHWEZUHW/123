// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SyntyStudios/Prototype_Object"
{
	Properties
	{
		_BaseColor("BaseColor", Color) = (0.06228374,0.8320726,0.9411765,0)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Lambert keepalpha addshadow fullforwardshadows 
		struct Input
		{
			half filler;
		};

		uniform float4 _BaseColor;

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 temp_output_9_0 = _BaseColor;
			o.Albedo = temp_output_9_0.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.RangedFloatNode;2;-365.939,248.7368;Float;False;Property;_Falloff;Falloff;3;0;Create;True;0;0;0;False;0;False;50;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;4;-430.7379,-43.00558;Float;True;Property;_Grid;Grid;1;0;Create;True;0;0;0;False;0;False;None;c7c5239ae4b2ace4d8774918a50a940a;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;3;-370.328,165.2742;Float;False;Property;_GridScale;GridScale;2;0;Create;True;0;0;0;False;0;False;5;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;6;-128.2589,26.68451;Inherit;True;Cylindrical;Object;False;Top Texture 0;_TopTexture0;white;2;None;Mid Texture 0;_MidTexture0;white;1;None;Bot Texture 0;_BotTexture0;white;2;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT3;1,1,1;False;3;FLOAT;1;False;4;FLOAT;100;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;5;24.57001,259.4728;Float;False;Property;_OverlayAmount;OverlayAmount;4;0;Create;True;0;0;0;False;0;False;1;0.493;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;16;262,-23.5;Float;False;Constant;_White;White;5;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;9;265,-214.5;Float;False;Property;_BaseColor;BaseColor;0;0;Create;True;0;0;0;False;0;False;0.06228374,0.8320726,0.9411765,0;1,0.724138,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;15;514,126.5;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;707,111.5;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0.2627451,0.7960785,0.572549,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;1;874,-124;Float;False;True;-1;2;ASEMaterialInspector;0;0;Lambert;SyntyStudios/Prototype_Object;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;0;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;4;0
WireConnection;6;1;4;0
WireConnection;6;2;4;0
WireConnection;6;3;3;0
WireConnection;6;4;2;0
WireConnection;15;0;16;0
WireConnection;15;1;6;0
WireConnection;15;2;5;0
WireConnection;10;0;9;0
WireConnection;10;1;15;0
WireConnection;1;0;9;0
ASEEND*/
//CHKSM=8FE3CFDCE809EB2E9EBF112C9031B88FB8C3FFA8