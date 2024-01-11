Shader "Banter/StereoscopicUnlit" 
{
    Properties
    {
        [NoScaleOffset] _MainTex("Stereo Texture", 2D) = "black" {}
        _LR("Left-Right Mode", Range(0,1)) = 1
        _EyeDistance("Eye Distance", Range(0.1, 2)) = 1
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
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                UNITY_VERTEX_OUTPUT_STEREO
            };
 
            v2f vert(appdata_base v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                return o;
            }
 
            sampler2D _MainTex;
            float _LR;
            float _EyeDistance;
 
            fixed4 frag(v2f i) : SV_Target
            {
                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);

                float halfDist = _EyeDistance * 0.5;

                if (_LR > 0.5) {
                    // Left-Right Mode
                    i.uv.x = (unity_StereoEyeIndex == 0) ? i.uv.x * halfDist : halfDist + i.uv.x * halfDist;
                } else {
                    // Top-Bottom Mode
                    i.uv.y = (unity_StereoEyeIndex == 0) ? i.uv.y * halfDist : halfDist + i.uv.y * halfDist;
                }

                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
