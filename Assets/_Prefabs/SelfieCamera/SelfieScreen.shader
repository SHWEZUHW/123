// Upgrade NOTE: upgraded instancing buffer 'SelfieScreen' to new syntax.

// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SelfieScreen"
{
	Properties
	{
		_Shutter("Shutter", Range( 0 , 1)) = 0
		_MainTex("MainTex", 2D) = "white" {}
		_Mirror("Mirror", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _MainTex;
		uniform float _Shutter;

		UNITY_INSTANCING_BUFFER_START(SelfieScreen)
			UNITY_DEFINE_INSTANCED_PROP(float, _Mirror)
#define _Mirror_arr SelfieScreen
		UNITY_INSTANCING_BUFFER_END(SelfieScreen)

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float _Mirror_Instance = UNITY_ACCESS_INSTANCED_PROP(_Mirror_arr, _Mirror);
			float lerpResult22 = lerp( i.uv_texcoord.x , ( 1.0 - i.uv_texcoord.x ) , _Mirror_Instance);
			float2 appendResult21 = (float2(lerpResult22 , i.uv_texcoord.y));
			float smoothstepResult3 = smoothstep( 0.8 , 1.0 , i.uv_texcoord.x);
			float smoothstepResult10 = smoothstep( 0.0 , 0.2 , i.uv_texcoord.x);
			float smoothstepResult4 = smoothstep( 0.8 , 1.0 , i.uv_texcoord.y);
			float smoothstepResult11 = smoothstep( 0.0 , 0.2 , i.uv_texcoord.y);
			float clampResult15 = clamp( saturate( ( ( smoothstepResult3 + ( 1.0 - smoothstepResult10 ) ) + ( smoothstepResult4 + ( 1.0 - smoothstepResult11 ) ) ) ) , 0.0 , _Shutter );
			o.Emission = ( tex2D( _MainTex, appendResult21 ) + clampResult15 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.OneMinusNode;6;-748.4938,359.4666;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-557.0847,255.2675;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;5;-764.3499,60.46069;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-1209.585,66.29559;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;3;-892.3304,-191.1632;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.8;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-563.8809,33.2784;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;10;-896.8641,-41.47301;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;11;-920.6477,375.3231;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;4;-910.0547,199.8756;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.8;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;262.7625,-10.19338;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;SelfieScreen;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-358.8805,171.4552;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;2.417933,9.49366;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;12;-221.8367,163.5271;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;15;-38.35553,225.8197;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-254.6817,354.9359;Inherit;False;Property;_Shutter;Shutter;0;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-294.8562,-270.362;Inherit;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;0;True;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;21;-482.05,-275.2723;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;19;-943.05,-342.2723;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;20;-699.05,-354.2723;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;22;-541.05,-468.2723;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-873.05,-480.2723;Inherit;False;InstancedProperty;_Mirror;Mirror;2;0;Create;True;0;0;0;True;0;False;0;0;0;1;0;1;FLOAT;0
WireConnection;6;0;11;0
WireConnection;8;0;4;0
WireConnection;8;1;6;0
WireConnection;5;0;10;0
WireConnection;3;0;2;1
WireConnection;7;0;3;0
WireConnection;7;1;5;0
WireConnection;10;0;2;1
WireConnection;11;0;2;2
WireConnection;4;0;2;2
WireConnection;0;2;13;0
WireConnection;9;0;7;0
WireConnection;9;1;8;0
WireConnection;13;0;1;0
WireConnection;13;1;15;0
WireConnection;12;0;9;0
WireConnection;15;0;12;0
WireConnection;15;2;16;0
WireConnection;1;1;21;0
WireConnection;21;0;22;0
WireConnection;21;1;19;2
WireConnection;20;0;19;1
WireConnection;22;0;19;1
WireConnection;22;1;20;0
WireConnection;22;2;23;0
ASEEND*/
//CHKSM=55A18C30CA3A8FC777BB1BBD3ABB99F8AC7E78D2