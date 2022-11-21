Shader "Custom/shader06"
{
	//公開するテクスチャプロパティ
	Properties{
		//テクスチャ設定前のべた塗を指定できる(red,white,blakc)
			_MainTex("テクスチャ", 2D) = "red"{}
	}
		SubShader{
			Tags { "RenderType" = "Opaque" }
			LOD 200

			CGPROGRAM
		//fullforwardshadowsにすれば影が色々着く
			#pragma surface surf Standard fullforwardshadows
			#pragma target 3.0

			//テクスチャを設定するために、uv座標を入手
			struct Input {
				float2 uv_MainTex;
			};

	//2Dテクスチャ＝＝sampler2D
	sampler2D _MainTex;

	void surf(Input IN, inout SurfaceOutputStandard o) {
		//tex2D関数でテクスチャに割り当てる色をuv座標から求めて、必要な色を割り当てる
		o.Albedo = tex2D(_MainTex, IN.uv_MainTex);
	}
	ENDCG
	}
		FallBack "Diffuse"
}

