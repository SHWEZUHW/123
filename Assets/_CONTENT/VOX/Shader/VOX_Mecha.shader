// Upgrade NOTE: upgraded instancing buffer 'VOX_Mecha' to new syntax.

// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "VOX_Mecha"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_Tint("Tint", Color) = (1,1,1,0)
		_Tint2("Tint2", Color) = (1,1,1,0)
		_Normal("Normal", 2D) = "bump" {}
		_MetallicR("MetallicR", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Normal;
		uniform sampler2D _MainTex;
		uniform float4 _Tint2;
		uniform sampler2D _MetallicR;

		UNITY_INSTANCING_BUFFER_START(VOX_Mecha)
			UNITY_DEFINE_INSTANCED_PROP(float4, _Normal_ST)
#define _Normal_ST_arr VOX_Mecha
			UNITY_DEFINE_INSTANCED_PROP(float4, _MainTex_ST)
#define _MainTex_ST_arr VOX_Mecha
			UNITY_DEFINE_INSTANCED_PROP(float4, _Tint)
#define _Tint_arr VOX_Mecha
			UNITY_DEFINE_INSTANCED_PROP(float4, _MetallicR_ST)
#define _MetallicR_ST_arr VOX_Mecha
		UNITY_INSTANCING_BUFFER_END(VOX_Mecha)

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 _Normal_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_Normal_ST_arr, _Normal_ST);
			float2 uv_Normal = i.uv_texcoord * _Normal_ST_Instance.xy + _Normal_ST_Instance.zw;
			o.Normal = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			float4 _MainTex_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_MainTex_ST_arr, _MainTex_ST);
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST_Instance.xy + _MainTex_ST_Instance.zw;
			float4 tex2DNode2 = tex2D( _MainTex, uv_MainTex );
			float4 _Tint_Instance = UNITY_ACCESS_INSTANCED_PROP(_Tint_arr, _Tint);
			float4 _MetallicR_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_MetallicR_ST_arr, _MetallicR_ST);
			float2 uv_MetallicR = i.uv_texcoord * _MetallicR_ST_Instance.xy + _MetallicR_ST_Instance.zw;
			float4 tex2DNode5 = tex2D( _MetallicR, uv_MetallicR );
			float smoothstepResult13 = smoothstep( 0.2 , 1.0 , tex2DNode5.g);
			float4 lerpResult11 = lerp( ( tex2DNode2 * _Tint_Instance ) , ( tex2DNode2 * _Tint2 ) , smoothstepResult13);
			o.Albedo = lerpResult11.rgb;
			o.Metallic = tex2DNode5.r;
			o.Smoothness = ( 1.0 - tex2DNode5.a );
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-353,-129.5;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2;-649,-159.5;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;0;False;0;False;-1;None;e8da72199b6cb7240a97252809e015f1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;8;-340.6014,-285.9678;Inherit;False;Sample Lightmap;1;;1;6976f0f966a01684ca0a6dde441141c2;6,209,0,195,0,196,0,238,0,191,0,249,0;2;71;FLOAT3;0,0,0;False;169;FLOAT3;0,0,0;False;2;COLOR;0;COLOR;178
Node;AmplifyShaderEditor.DecodeLightmapHlpNode;9;-9.226633,-308.2823;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;366.5999,2.600001;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;VOX_Mecha;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-159.4,-82.40002;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-162.3425,45.29652;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;11;26.15746,-0.2034874;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;4;-588.9575,563.4304;Inherit;True;Property;_Normal;Normal;6;0;Create;True;0;0;0;False;0;False;-1;None;fa4c5c8a41f3cf94a92eb286c5cebca3;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;5;-576.5709,744.9339;Inherit;True;Property;_MetallicR;MetallicR;7;0;Create;True;0;0;0;False;0;False;-1;None;36be7f30bfb168841ba83204ba1d9ec3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;7;-179.6741,935.6799;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;-808,19.5;Inherit;False;InstancedProperty;_Tint;Tint;4;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,0.4481131,0.4481131,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;13;-217.5759,403.0931;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.2;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;12;-448.5759,132.0931;Inherit;False;Property;_Tint2;Tint2;5;0;Create;True;0;0;0;False;0;False;1,1,1,0;0.4470588,0.5764706,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;6;0;2;0
WireConnection;6;1;2;4
WireConnection;9;0;8;0
WireConnection;0;0;11;0
WireConnection;0;1;4;0
WireConnection;0;3;5;1
WireConnection;0;4;7;0
WireConnection;3;0;2;0
WireConnection;3;1;1;0
WireConnection;10;0;2;0
WireConnection;10;1;12;0
WireConnection;11;0;3;0
WireConnection;11;1;10;0
WireConnection;11;2;13;0
WireConnection;7;0;5;4
WireConnection;13;0;5;2
ASEEND*/
//CHKSM=8FB8F373180532DCAFD8F4DB5153EAD5C98E7033