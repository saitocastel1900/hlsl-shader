Shader "Custom/shader02"
{
    //インスペクタに公開するプロパティ
    Properties{
        _BaseColor("Base Color",Color)=(1,1,1,1)
        }
    SubShader
    {
        //不透明なシェーダーを指定
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        //頂点座標を入手
        struct Input
        {
            //uv座標
            float2 uv_MainTex;
        };

        //宣言してみる
        fixed4 _BaseColor;
        
        //色塗り
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            //albedoは基本色
            o.Albedo=_BaseColor.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
