Shader "Custom/shader03"
{
    SubShader
    {
        //描画優先度を指定(半透明なものを描画する際は、後から描画しないとバグるため)
        //Transparentは透明
        //Tags { "RenderType"="Opaque" }
        Tags { "Queue" = "Transparent" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        //alpha:fadeで半透明にできる
        #pragma surface surf Standard alpha:fade 
        #pragma target 3.0

        //頂点座標を入手(実はいらない)
        struct Input
        {float2 uv_MainTex;//uv座標
            };

        //宣言してみる
        fixed4 _BaseColor;
        
        //色塗り
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            //albedoは基本色
            o.Albedo=fixed4(0.6f, 0.7f, 0.4f, 1);
            //後はA値を設定すれば半透明に
            o.Alpha=0.5f;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
