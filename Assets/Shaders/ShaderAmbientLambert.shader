Shader "Unlit/ShaderAmbientLambert"
{
    Properties
    {
       _MainColor("BaseColor",Color) = (1,1,1,1)
          _MainAmbientColor("AmbientColor",Color) = (0.5,0.5,0.5,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos :  SV_POSITION;
                float3 worldNormal : TEXCOORD0;
            };

            fixed4 _MainColor;
            fixed4 _MainAmbientColor;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.worldNormal = normalize(mul((float3x3)unity_ObjectToWorld, v.normal));
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
             
                float3 ambient = _MainColor.rgb * _MainAmbientColor.rgb;

                
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float NdotL = max(0, dot(i.worldNormal, lightDir));
                float3 diffuse = _MainColor.rgb * _LightColor0.rgb * NdotL;
                float3 finalColor = ambient + diffuse;

                return float4(finalColor, _MainColor.a);
            }
            ENDCG
        }
    }
     FallBack "Diffuse"
}
