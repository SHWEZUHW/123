Shader "Banter/GalleryImageOcclusion"
{
    Properties
    {
        _MainTex ("Image Texture", 2D) = "white" {}
        _LoadingProgress ("Loading Progress", Range(0, 1)) = 0

        [Header(Parallax Occlusion)]
        _ParallaxStrength ("Parallax Strength", Range(0, 1)) = 0.3
        _ParallaxSteps ("Parallax Steps", Range(4, 32)) = 8

        [Header(Edge Glow)]
        _GlowTint ("Glow Tint", Color) = (1, 1, 1, 1)
        _GlowIntensity ("Glow Intensity", Float) = 1.0
        _GlowSaturationBoost ("Glow Saturation Boost", Range(1, 3)) = 1.5

        [Header(Border Falloff)]
        _FalloffMin ("Falloff Start", Range(0, 0.5)) = 0.1
        _FalloffMax ("Falloff End", Range(0, 0.5)) = 0.25

        [Header(General)]
        _EmissionIntensity ("Emission Intensity", Float) = 1.0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Geometry" }
        Cull Off
        ZWrite On
        ZTest LEqual

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0
            #include "UnityCG.cginc"

            // ============================================
            // Shader Variables
            // ============================================
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _LoadingProgress;

            float _ParallaxStrength;
            float _ParallaxSteps;

            float4 _GlowTint;
            float _GlowIntensity;
            float _GlowSaturationBoost;

            float _FalloffMin;
            float _FalloffMax;

            float _EmissionIntensity;

            // ============================================
            // Structs
            // ============================================
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float borderMask : TEXCOORD1;
                float3 viewDirTangent : TEXCOORD2;
            };

            // ============================================
            // Border Falloff Mask Function
            // ============================================
            float calculateBorderMask(float2 uv)
            {
                float distFromLeft = uv.x;
                float distFromRight = 1.0 - uv.x;
                float distFromBottom = uv.y;
                float distFromTop = 1.0 - uv.y;

                float edgeDist = min(min(distFromLeft, distFromRight), min(distFromBottom, distFromTop));

                return 1.0 - smoothstep(_FalloffMin, _FalloffMax, edgeDist);
            }

            // ============================================
            // Vertex Shader
            // ============================================
            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.borderMask = calculateBorderMask(v.uv);

                // Calculate tangent space view direction for parallax
                float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                float3 worldViewDir = normalize(_WorldSpaceCameraPos - worldPos);

                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                float3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
                float3 worldBinormal = cross(worldNormal, worldTangent) * v.tangent.w;

                // Transform view dir to tangent space
                o.viewDirTangent.x = dot(worldViewDir, worldTangent);
                o.viewDirTangent.y = dot(worldViewDir, worldBinormal);
                o.viewDirTangent.z = dot(worldViewDir, worldNormal);

                return o;
            }

            // ============================================
            // Parallax Occlusion Mapping
            // ============================================
            float2 ParallaxOcclusionMapping(float2 uv, float3 viewDir, float strength, int numSteps)
            {
                float layerDepth = 1.0 / numSteps;
                float currentLayerDepth = 0.0;

                // Calculate UV offset per layer
                float2 P = viewDir.xy / viewDir.z * strength;
                float2 deltaUV = P / numSteps;

                float2 currentUV = uv;
                float currentHeight = tex2Dlod(_MainTex, float4(currentUV, 0, 0)).r;

                // Ray march through layers
                [loop]
                for (int i = 0; i < numSteps; i++)
                {
                    if (currentLayerDepth >= currentHeight)
                        break;

                    currentUV -= deltaUV;
                    currentHeight = tex2Dlod(_MainTex, float4(currentUV, 0, 0)).r;
                    currentLayerDepth += layerDepth;
                }

                // Get previous values for interpolation
                float2 prevUV = currentUV + deltaUV;
                float afterDepth = currentHeight - currentLayerDepth;
                float beforeDepth = tex2Dlod(_MainTex, float4(prevUV, 0, 0)).r - currentLayerDepth + layerDepth;

                // Interpolate for smoother result
                float weight = afterDepth / (afterDepth - beforeDepth);
                float2 finalUV = prevUV * weight + currentUV * (1.0 - weight);

                return finalUV;
            }

            // ============================================
            // Helper: Boost saturation of a color
            // ============================================
            float3 boostSaturation(float3 color, float boost)
            {
                float grey = dot(color, float3(0.299, 0.587, 0.114));
                return lerp(float3(grey, grey, grey), color, boost);
            }

            // ============================================
            // Fragment Shader - Parallax Occlusion Effect
            // ============================================
            fixed4 frag(v2f i) : SV_Target
            {
                float3 viewDir = normalize(i.viewDirTangent);

                // Calculate parallax strength based on border mask and loading progress
                float parallaxAmount = _ParallaxStrength * i.borderMask * _LoadingProgress;

                // Apply POM - lerp between original UV and parallax UV
                float2 parallaxUV = ParallaxOcclusionMapping(i.uv, viewDir, parallaxAmount, (int)_ParallaxSteps);
                float2 finalUV = lerp(i.uv, parallaxUV, i.borderMask * _LoadingProgress);

                // Sample texture with parallax-offset UV
                float3 texColor = tex2D(_MainTex, finalUV).rgb * _EmissionIntensity;

                // ============================================
                // Edge Glow
                // ============================================
                // Sample texture at high mip level to get average/dominant color
                float3 avgColor = tex2Dlod(_MainTex, float4(0.5, 0.5, 0, 8)).rgb;

                // Boost saturation to make the glow more vibrant
                float3 glowBaseColor = boostSaturation(avgColor, _GlowSaturationBoost);

                // Apply tint on top
                glowBaseColor *= _GlowTint.rgb;

                // Glow at borders
                float glowAmount = i.borderMask * _GlowIntensity * _LoadingProgress;
                float3 glow = glowBaseColor * glowAmount;

                // Final color: parallax texture + glow
                float3 finalColor = texColor + glow;

                return fixed4(finalColor, 1.0);
            }
            ENDCG
        }
    }
    Fallback "Diffuse"
}
