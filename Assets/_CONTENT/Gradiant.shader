// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Banter/Gradiant"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_Gradiant("Gradiant", 2D) = "gray" {}
		_Power("Power", Float) = 1
		_ColorA("ColorA", Color) = (0.6687446,0,1,0)
		_ColorB("ColorB", Color) = (0,1,0.6476085,0)
		_Stregth("Stregth", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _MainTex;
		uniform half4 _MainTex_ST;
		uniform half4 _ColorB;
		uniform half _Power;
		uniform sampler2D _Gradiant;
		uniform half4 _Gradiant_ST;
		uniform half4 _ColorA;
		uniform half _Stregth;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			o.Albedo = tex2D( _MainTex, uv_MainTex ).rgb;
			half4 temp_cast_1 = (_Power).xxxx;
			float2 uv_Gradiant = i.uv_texcoord * _Gradiant_ST.xy + _Gradiant_ST.zw;
			half4 tex2DNode3 = tex2D( _Gradiant, uv_Gradiant );
			half4 temp_cast_2 = (_Power).xxxx;
			half4 temp_cast_3 = (( 1.0 / _Power )).xxxx;
			o.Emission = ( pow( ( ( pow( _ColorB , temp_cast_1 ) * ( 1.0 - tex2DNode3 ) ) + ( tex2DNode3 * pow( _ColorA , temp_cast_2 ) ) ) , temp_cast_3 ) * _Stregth ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.SimpleDivideOpNode;14;-160,203;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;13;-59,82;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-434,-174;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;17;-656,-102;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-259,-130;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-578,145;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;16;-604,-235;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;20;-534.2596,337.6384;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-318,315;Inherit;False;Property;_Power;Power;2;0;Create;True;0;0;0;False;0;False;1;0.23;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;5;-792,391;Inherit;False;Property;_ColorA;ColorA;3;0;Create;True;0;0;0;False;0;False;0.6687446,0,1,0;0.1730798,1,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;4;-833,-360;Inherit;False;Property;_ColorB;ColorB;4;0;Create;True;0;0;0;False;0;False;0,1,0.6476085,0;1,0,0.4325923,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-999,-118;Inherit;True;Property;_Gradiant;Gradiant;1;0;Create;True;0;0;0;False;0;False;-1;476bd7a66eea1934b923b222d8c57981;396f38a210576e54e859be3bfc253e2d;True;0;False;gray;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;22;-138.0845,-325.1783;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;0;False;0;False;-1;None;3371e27a5ae8f234e913a075a30a9202;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;514,-99;Half;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Banter/Gradiant;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;202.9155,-14.17828;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;24;35.91553,231.8217;Inherit;False;Property;_Stregth;Stregth;5;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
WireConnection;14;1;15;0
WireConnection;13;0;18;0
WireConnection;13;1;14;0
WireConnection;7;0;16;0
WireConnection;7;1;17;0
WireConnection;17;0;3;0
WireConnection;18;0;7;0
WireConnection;18;1;19;0
WireConnection;19;0;3;0
WireConnection;19;1;20;0
WireConnection;16;0;4;0
WireConnection;16;1;15;0
WireConnection;20;0;5;0
WireConnection;20;1;15;0
WireConnection;0;0;22;0
WireConnection;0;2;23;0
WireConnection;23;0;13;0
WireConnection;23;1;24;0
ASEEND*/
//CHKSM=4554E8A51F20B937726AF33DA4863BD743045923