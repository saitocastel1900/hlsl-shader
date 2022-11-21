Shader "Custom/Shader10"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}//煉瓦
        _SubTex ("Sub Texture", 2D) = "white" {}//苔
        _MaskTex ("Mask Texture", 2D) = "white" {}//マスク画像
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
        sampler2D _SubTex;
        sampler2D _MaskTex;

        struct Input
        {
            //テクスチャぺりぺり作業には座標が必要なので入手
            float2 uv_MainTex;
        };
        
        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            //uv座標に対応した画素の色を注入
            fixed4 c1= tex2D(_MainTex,IN.uv_MainTex);
            fixed4 c2= tex2D(_SubTex,IN.uv_MainTex);
            fixed4 p= tex2D(_MaskTex,IN.uv_MainTex);//黒0.0~白1.0
            //Lerp(a,b,v)で上手く合成している
            //vが1の場合はaを返し、vが0の場合がbを返す、それ以外は上手くブレンドされた返されるみたい
            o.Albedo= lerp(c1,c2,p);
        }
        ENDCG
    }
    FallBack "Diffuse"
}












