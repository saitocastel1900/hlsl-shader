Shader "Custom/shader04"
{
       Properties
    {
        _Alpha("Alpha", Range(0,1)) = 0.5
               }
    
    SubShader
    {
        Tags { "Queue" = "Transparent" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        //alpha:fadeで半透明にできる
        #pragma surface surf Standard alpha:fade 
        #pragma target 3.0

        //法線ベクトル（ポリゴンの垂直方向のベクトル）と視線ベクトル（カメラが向いている方向のベクトル）の準備
        struct Input
        {
            float3 worldNormal;
            float3 viewDir;
            };

        float1 _Alpha;

        //視線ベクトルと法線ベクトルから透明度を求める
        //中央は並行、枠線は垂直であることを基に透明度を求める
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
           o.Albedo=fixed4(1,1,1,1);
            //内積からなす角度を求める
            float alpha=1-(abs(dot(IN.viewDir,IN.worldNormal)));
            //_Alphaを掛けて微調整
            o.Alpha=alpha*_Alpha;
        }
        ENDCG
    }
    FallBack "Diffuse"
}


