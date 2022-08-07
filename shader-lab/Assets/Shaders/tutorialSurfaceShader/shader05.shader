Shader "Custom/shader05"
{
       Properties
    {
       _Color("Base Color",Color)=(1,1,1,1)
        _RimColor("RimColor",Color)=(0.5,0.7,0.5,1)
               }
    
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard 
        #pragma target 3.0

        //法線ベクトル（ポリゴンの垂直方向のベクトル）と視線ベクトル（カメラが向いている方向のベクトル）の準備
        struct Input
        {
            float3 worldNormal;
            float3 viewDir;
            };

        fixed4 _Color;
        fixed4 _RimColor;
        
        //視線ベクトルと法線ベクトルから透明度を求める
        //中央は並行、枠線は垂直であることを基に透明度を求める
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
			o.Albedo = _Color;
            //saturateで補間
			float rim = 1 - saturate(dot(IN.viewDir, o.Normal));
            //(両方のベクトルが垂直だったときに)輪郭を光らせる
            o.Emission = _RimColor *pow(rim,1.5);//rim(0~1)
        }
        ENDCG
    }
    FallBack "Diffuse"
}


