Shader "Unlit/ShaderSpecular"
{
 Properties
    {
        _MainColor ("Base Color", Color) = (1, 1, 1, 1)
        _MainCustomSpecColor ("Specular Color", Color) = (1, 1, 1, 1)
        _MainAmbientColor("Ambient Color", Color) = (0.5, 0.5, 0.5, 1)
        _MainShininess ("Shininess", Range(1, 128)) = 32
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
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
                float4 pos : SV_POSITION;
                float3 worldNormal : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                float3 viewDir : TEXCOORD2;
            };
            float4 _MainColor;
            float4 _MainCustomSpecColor; 
            float4 _MainAmbientColor;
            float _MainShininess;
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

               
                o.worldNormal = normalize(mul((float3x3)unity_ObjectToWorld, v.normal));
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

                
                o.viewDir = normalize(_WorldSpaceCameraPos - o.worldPos);

                return o;
            }
            float4 frag (v2f i) : SV_Target
            {
                
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float NdotL = max(0, dot(i.worldNormal, lightDir));
                float3 diffuse = _MainColor.rgb * _LightColor0.rgb * NdotL;

              
                float3 reflectDir = reflect(-lightDir, i.worldNormal);
                float specFactor = pow(max(dot(reflectDir, i.viewDir), 0), _MainShininess);
                float3 specular = _MainCustomSpecColor.rgb * specFactor; 
                
                float3 ambient = _MainColor.rgb * _MainAmbientColor.rgb;
               
                float3 color = ambient + diffuse + specular;
                return float4(color, _MainColor.a);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
