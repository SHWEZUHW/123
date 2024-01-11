// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Banter/Stencil Portal Write"
{
	Properties
	{
		_StencilReference("Stencil Reference", Int) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" }
		Cull Back
		ZWrite Off
		Stencil
		{
			Ref [_StencilReference]
			Comp Always
			Pass Replace
		}
		ColorMask 0
		CGPROGRAM
		#pragma target 3.0
		#pragma exclude_renderers xboxone xboxseries playstation ps4 ps5 switch 
		#pragma surface surf Unlit keepalpha noshadow 
		struct Input
		{
			half filler;
		};

		uniform int _StencilReference;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.IntNode;14;11.30759,-97.80232;Inherit;False;Property;_StencilReference;Stencil Reference;0;0;Create;True;0;0;0;True;0;False;1;1;False;0;1;INT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Half;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Banter/Stencil Portal Write;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;2;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;6;d3d11;glcore;gles;gles3;metal;vulkan;False;False;False;False;0;False;;True;1;True;_StencilReference;255;False;;255;False;;7;False;;3;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;0;4;10;25;False;0.5;False;0;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
ASEEND*/
//CHKSM=8A8E0FD2AF9A86543006B397C72A76A273C6C311