Shader "Custom/Shader12" {
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
        
        float random(fixed2 p)
        {
            //frac：小数点を消す
            //dot：内積をもとめる
            return frac(sin(dot(p, fixed2(12.9898,78.233)))*43758.5453);
        }

        float noise(fixed2 st)
        {
            //ここで代表の一点を決めている
            fixed2 p =floor(st); //小数の整数部分を返す
            //つまり（x,y）
            //floor(1,0,1,0)=>(1,1)の点を代表に
            //floor(1,2,1,4)=>(1,1)の点を代表に
            //floor(1,3,1,9)=>(1,1)の点を代表に
            //なので xが1~2,yが1~2の色が一定に決まる
            return random(p);
        }
        
        void surf(Input IN, inout SurfaceOutputStandard o)
        {
           float c= noise(IN.uv_MainTex*12);
            o.Albedo= fixed4(c,c,c,1);
        }
		ENDCG
	}
	FallBack "Diffuse"
}














