Shader "Banter/GalleryImage"
{
    Properties
    {
        _MainTex ("Image Texture", 2D) = "white" {}
        _LoadingProgress ("Loading Progress", Range(0, 1)) = 0

        [Header(Vertex Animation)]
        _RippleAmplitude ("Ripple Amplitude", Float) = 0.1
        _RippleFrequency ("Ripple Frequency", Float) = 3.0
        _RippleSpeed ("Ripple Speed", Float) = 2.0
        _NoiseScale ("Noise Scale", Float) = 5.0
        _NoiseStrength ("Noise Strength", Float) = 0.05
        _NoiseSpeed ("Noise Speed", Float) = 1.0

        [Header(Face Explosion)]
        _ExplodeAmount ("Explode Amount", Float) = 0.1
        _ShrinkAmount ("Face Shrink", Range(0, 0.5)) = 0.2

        [Header(Scale Gradient)]
        _EdgeScale ("Edge Scale", Range(0.1, 1.0)) = 0.4
        _MidScaleBoost ("Mid Scale Boost", Range(0, 1.0)) = 0.3

        [Header(Edge Glow)]
        _GlowColor ("Glow Color", Color) = (0.2, 0.5, 1, 1)
        _GlowIntensity ("Glow Intensity", Float) = 2.0

        [Header(Border Falloff)]
        _FalloffMin ("Falloff Start", Range(0, 0.5)) = 0.3
        _FalloffMax ("Falloff End", Range(0, 0.5)) = 0.5

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
            #pragma geometry geom
            #pragma fragment frag
            #pragma target 4.0
            #include "UnityCG.cginc"

            // ============================================
            // Simplex Noise Implementation
            // ============================================
            float3 mod289(float3 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
            float4 mod289(float4 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
            float4 permute(float4 x) { return mod289(((x * 34.0) + 1.0) * x); }
            float4 taylorInvSqrt(float4 r) { return 1.79284291400159 - 0.85373472095314 * r; }

            float snoise(float3 v)
            {
                const float2 C = float2(1.0 / 6.0, 1.0 / 3.0);
                const float4 D = float4(0.0, 0.5, 1.0, 2.0);

                float3 i = floor(v + dot(v, C.yyy));
                float3 x0 = v - i + dot(i, C.xxx);

                float3 g = step(x0.yzx, x0.xyz);
                float3 l = 1.0 - g;
                float3 i1 = min(g.xyz, l.zxy);
                float3 i2 = max(g.xyz, l.zxy);

                float3 x1 = x0 - i1 + C.xxx;
                float3 x2 = x0 - i2 + C.yyy;
                float3 x3 = x0 - D.yyy;

                i = mod289(i);
                float4 p = permute(permute(permute(
                    i.z + float4(0.0, i1.z, i2.z, 1.0))
                    + i.y + float4(0.0, i1.y, i2.y, 1.0))
                    + i.x + float4(0.0, i1.x, i2.x, 1.0));

                float n_ = 0.142857142857;
                float3 ns = n_ * D.wyz - D.xzx;

                float4 j = p - 49.0 * floor(p * ns.z * ns.z);

                float4 x_ = floor(j * ns.z);
                float4 y_ = floor(j - 7.0 * x_);

                float4 x = x_ * ns.x + ns.yyyy;
                float4 y = y_ * ns.x + ns.yyyy;
                float4 h = 1.0 - abs(x) - abs(y);

                float4 b0 = float4(x.xy, y.xy);
                float4 b1 = float4(x.zw, y.zw);

                float4 s0 = floor(b0) * 2.0 + 1.0;
                float4 s1 = floor(b1) * 2.0 + 1.0;
                float4 sh = -step(h, float4(0.0, 0.0, 0.0, 0.0));

                float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
                float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;

                float3 p0 = float3(a0.xy, h.x);
                float3 p1 = float3(a0.zw, h.y);
                float3 p2 = float3(a1.xy, h.z);
                float3 p3 = float3(a1.zw, h.w);

                float4 norm = taylorInvSqrt(float4(dot(p0, p0), dot(p1, p1), dot(p2, p2), dot(p3, p3)));
                p0 *= norm.x;
                p1 *= norm.y;
                p2 *= norm.z;
                p3 *= norm.w;

                float4 m = max(0.6 - float4(dot(x0, x0), dot(x1, x1), dot(x2, x2), dot(x3, x3)), 0.0);
                m = m * m;
                return 42.0 * dot(m * m, float4(dot(p0, x0), dot(p1, x1), dot(p2, x2), dot(p3, x3)));
            }

            // ============================================
            // Shader Variables
            // ============================================
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _LoadingProgress;

            float _RippleAmplitude;
            float _RippleFrequency;
            float _RippleSpeed;
            float _NoiseScale;
            float _NoiseStrength;
            float _NoiseSpeed;

            float _ExplodeAmount;
            float _ShrinkAmount;

            float _EdgeScale;
            float _MidScaleBoost;

            float4 _GlowColor;
            float _GlowIntensity;

            float _FalloffMin;
            float _FalloffMax;

            float _EmissionIntensity;

            // ============================================
            // Structs
            // ============================================
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            // Vertex to Geometry
            struct v2g
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            // Geometry to Fragment
            struct g2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float borderMask : TEXCOORD1;
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
            // Vertex Shader (pass-through to geometry)
            // ============================================
            v2g vert(appdata v)
            {
                v2g o;
                o.vertex = v.vertex;
                o.normal = v.normal;
                o.uv = v.uv;
                return o;
            }

            // ============================================
            // Geometry Shader - Explode faces apart
            // ============================================
            [maxvertexcount(3)]
            void geom(triangle v2g input[3], inout TriangleStream<g2f> triStream)
            {
                // Calculate triangle center (in object space)
                float3 center = (input[0].vertex.xyz + input[1].vertex.xyz + input[2].vertex.xyz) / 3.0;
                float2 uvCenter = (input[0].uv + input[1].uv + input[2].uv) / 3.0;

                // Calculate border mask for this triangle
                float borderMask = calculateBorderMask(uvCenter);

                // Calculate displacement for this triangle
                float2 centered = uvCenter - 0.5;
                float dist = length(centered);

                // Ripple - only positive values (abs + offset to keep positive)
                float ripple = sin(dist * _RippleFrequency * 10.0 - _Time.y * _RippleSpeed);
                ripple = (ripple * 0.5 + 0.5); // Remap -1,1 to 0,1

                // Noise - only positive values
                float noise = snoise(float3(uvCenter * _NoiseScale, _Time.y * _NoiseSpeed));
                noise = (noise * 0.5 + 0.5); // Remap -1,1 to 0,1

                // Combined Y offset (always positive - upward only)
                float yOffset = (ripple * _RippleAmplitude + noise * _NoiseStrength) * borderMask * _LoadingProgress;

                // Explosion offset - push triangle upward along +Y
                float explodeOffset = _ExplodeAmount * borderMask * _LoadingProgress;

                // Total upward offset
                float totalYOffset = yOffset + explodeOffset;

                // ============================================
                // Scale Gradient Calculation
                // Edge: smallest, Middle of falloff: biggest, Center: normal
                // ============================================

                // Base scale: shrinks from 1.0 (center) to _EdgeScale (edge)
                float edgeShrinkFactor = lerp(1.0, _EdgeScale, borderMask);

                // Middle boost: sin curve peaks at borderMask = 0.5, zero at 0 and 1
                float midBoost = sin(borderMask * 3.14159) * _MidScaleBoost;

                // Combined scale with loading progress
                float scaleGradient = lerp(1.0, edgeShrinkFactor + midBoost, _LoadingProgress);

                // Process each vertex of the triangle
                for (int i = 0; i < 3; i++)
                {
                    g2f o;

                    float3 vertPos = input[i].vertex.xyz;

                    // Scale triangle from its center
                    float3 fromCenter = vertPos - center;
                    vertPos = center + fromCenter * scaleGradient;

                    // Additional shrink for face disconnection
                    float3 toCenter = center - vertPos;
                    float shrink = _ShrinkAmount * _LoadingProgress * borderMask;
                    vertPos += toCenter * shrink;

                    // Push upward in +Y only (object space)
                    vertPos.y += totalYOffset;

                    o.pos = UnityObjectToClipPos(float4(vertPos, 1.0));
                    o.uv = TRANSFORM_TEX(input[i].uv, _MainTex);
                    o.borderMask = borderMask;

                    triStream.Append(o);
                }

                triStream.RestartStrip();
            }

            // ============================================
            // Fragment Shader
            // ============================================
            fixed4 frag(g2f i) : SV_Target
            {
                // Sample main texture
                float3 texColor = tex2D(_MainTex, i.uv).rgb * _EmissionIntensity;

                // Edge glow effect based on border mask and loading progress
                float glowAmount = i.borderMask * _GlowIntensity * _LoadingProgress;
                float3 glow = _GlowColor.rgb * glowAmount;

                // Final color: texture + glow
                float3 finalColor = texColor + glow;

                return fixed4(finalColor, 1.0);
            }
            ENDCG
        }
    }
    Fallback "Diffuse"
}
