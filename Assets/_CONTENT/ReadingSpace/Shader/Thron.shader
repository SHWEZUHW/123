// Upgrade NOTE: upgraded instancing buffer 'Thron' to new syntax.

// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Thron"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_LightmapStart("LightmapStart", 2D) = "black" {}
		_LightmapEnd("LightmapEnd", 2D) = "black" {}
		_Blend("Blend", Range( 0 , 1)) = 0
		_InFlight("InFlight", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma surface surf Lambert keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float2 uv2_texcoord2;
		};

		uniform sampler2D _MainTex;
		uniform sampler2D _LightmapStart;
		uniform sampler2D _LightmapEnd;
		uniform half _InFlight;

		UNITY_INSTANCING_BUFFER_START(Thron)
			UNITY_DEFINE_INSTANCED_PROP(half4, _MainTex_ST)
#define _MainTex_ST_arr Thron
			UNITY_DEFINE_INSTANCED_PROP(half4, _LightmapStart_ST)
#define _LightmapStart_ST_arr Thron
			UNITY_DEFINE_INSTANCED_PROP(half4, _LightmapEnd_ST)
#define _LightmapEnd_ST_arr Thron
			UNITY_DEFINE_INSTANCED_PROP(half, _Blend)
#define _Blend_arr Thron
		UNITY_INSTANCING_BUFFER_END(Thron)

		void surf( Input i , inout SurfaceOutput o )
		{
			half4 _MainTex_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_MainTex_ST_arr, _MainTex_ST);
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST_Instance.xy + _MainTex_ST_Instance.zw;
			half4 tex2DNode1 = tex2D( _MainTex, uv_MainTex );
			half4 _LightmapStart_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_LightmapStart_ST_arr, _LightmapStart_ST);
			float2 uv1_LightmapStart = i.uv2_texcoord2 * _LightmapStart_ST_Instance.xy + _LightmapStart_ST_Instance.zw;
			half3 decodeLightMap2 = DecodeLightmap(tex2D( _LightmapStart, uv1_LightmapStart ));
			half4 _LightmapEnd_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_LightmapEnd_ST_arr, _LightmapEnd_ST);
			float2 uv1_LightmapEnd = i.uv2_texcoord2 * _LightmapEnd_ST_Instance.xy + _LightmapEnd_ST_Instance.zw;
			half3 decodeLightMap10 = DecodeLightmap(tex2D( _LightmapEnd, uv1_LightmapEnd ));
			half _Blend_Instance = UNITY_ACCESS_INSTANCED_PROP(_Blend_arr, _Blend);
			half3 lerpResult6 = lerp( decodeLightMap2 , decodeLightMap10 , _Blend_Instance);
			half4 lerpResult13 = lerp( half4( lerpResult6 , 0.0 ) , tex2DNode1 , _InFlight);
			o.Emission = ( tex2DNode1 * lerpResult13 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.SamplerNode;1;-489,-71.5;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;0;False;0;False;-1;None;a4e0f77eed29a0743a3d8b2e6afd1975;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;5;-750,180.5;Inherit;True;Property;_LightmapStart;LightmapStart;1;0;Create;True;0;0;0;False;0;False;-1;None;6ea2897ef92e50e48b1af2bdaeedfaa1;True;1;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;9;-721,413.5;Inherit;True;Property;_LightmapEnd;LightmapEnd;2;0;Create;True;0;0;0;False;0;False;-1;None;d45fc6bedd410064693c78871e76fa3d;True;1;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DecodeLightmapHlpNode;2;-363.521,176.5562;Inherit;True;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DecodeLightmapHlpNode;10;-371,405.5;Inherit;True;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;6;-60,275.5;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-412,632.5;Inherit;False;InstancedProperty;_Blend;Blend;3;0;Create;True;0;0;0;False;0;False;0;0.122;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;623,65;Half;False;True;-1;2;ASEMaterialInspector;0;0;Lambert;Thron;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;294,94.5;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;13;153,228.5;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;11;4,432.5;Inherit;False;Property;_InFlight;InFlight;4;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
WireConnection;2;0;5;0
WireConnection;10;0;9;0
WireConnection;6;0;2;0
WireConnection;6;1;10;0
WireConnection;6;2;7;0
WireConnection;0;2;4;0
WireConnection;4;0;1;0
WireConnection;4;1;13;0
WireConnection;13;0;6;0
WireConnection;13;1;1;0
WireConnection;13;2;11;0
ASEEND*/
//CHKSM=AC441D541DEAEE9756C0788B160492B22A3E863A