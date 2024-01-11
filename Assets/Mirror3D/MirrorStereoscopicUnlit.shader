Shader "Banter/MirrorStereoscopicUnlit" 
{
    Properties
    {
        [NoScaleOffset] _ReflectionTexLeft("Left Eye Texture", 2D) = "white" {}
        [NoScaleOffset] _ReflectionTexRight("Right Eye Texture", 2D) = "white" {}
        _StereoMode("Stereo Mode (On/Off)", Float) = 1 // 0 for Off (2D), 1 for On (3D)
    }
    SubShader
    {
        Pass
        {
            Tags {"LightMode" = "Always"}

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct v2f
            {
                float4 screenPos : TEXCOORD0;
                float4 vertex : SV_POSITION;
                UNITY_VERTEX_OUTPUT_STEREO
            };

            v2f vert(appdata_base v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.screenPos = ComputeScreenPos(o.vertex);
                return o;
            }

            sampler2D _ReflectionTexLeft;
            sampler2D _ReflectionTexRight;
            float _StereoMode; // Added stereo mode property

            fixed4 frag(v2f i) : SV_Target
            {
                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);

                // Use screen position as UVs
                float2 uv = i.screenPos.xy / i.screenPos.w;

                fixed4 col;
                if (_StereoMode < 0.5) // If stereo mode is off, use left eye texture for both eyes
                {
                    col = tex2D(_ReflectionTexLeft, uv);
                }
                else // Else, use respective textures for each eye
                {
                    if (unity_StereoEyeIndex == 0)
                    {
                        col = tex2D(_ReflectionTexLeft, uv);
                    }
                    else
                    {
                        col = tex2D(_ReflectionTexRight, uv);
                    }
                }

                return col;
            }
            ENDCG
        }
    }
}
