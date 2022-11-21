Shader "Custom/Shader11"
{
     Properties
    {
        _MainTex ("Albedo（RGB）", 2D) = "white" {}//ここに白黒ガビガビ画像
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"//不透明度
        }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            //テクスチャぺりぺり作業には座標が必要なので入手
            float2 uv_MainTex;
        };

        //ランダムではないけどね..
        float random(fixed2 p)
        {
            //frac：小数点を消す
            //dot：内積をもとめる
            return frac(sin(dot(p, fixed2(12.9898,78.233)))*43758.5453);
        }
        
        void surf(Input IN, inout SurfaceOutputStandard o)
        {
           float c= random(IN.uv_MainTex);
            o.Albedo= fixed4(c,c,c,1);
        }
        ENDCG
    }
    FallBack "Diffuse"
}










