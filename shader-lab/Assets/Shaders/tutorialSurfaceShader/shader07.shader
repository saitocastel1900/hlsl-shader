Shader "Custom/shader07"
{
	//公開するテクスチャプロパティ
	Properties{
		//テクスチャ設定前のべた塗を指定できる(red,white,blakc)
			_MainTex("テクスチャ", 2D) = "red"{}
	}
		SubShader{
			//描画順を透明度を一番後に（そうしないとバグるため）
			Tags { "Queue" = "Transparent"  }
			LOD 200

			CGPROGRAM
		
			//alpha:fadeと指定する事で、オブジェクトを透明になる
			#pragma surface surf Standard  alpha:fade
			#pragma target 3.0

			//テクスチャを設定するために、uv座標を入手
			struct Input {
				float2 uv_MainTex;
			};

			//2Dテクスチャ＝＝sampler2D
			sampler2D _MainTex;

			void surf(Input IN, inout SurfaceOutputStandard o) {
				//tex2D関数でテクスチャの色を得る
				fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
				o.Albedo=c.rgb;
				//グレースケール化して、明度から黒かそれ以外かを求める(黒:1(0.2以下は黒付近),それ以外:0.5)
				o.Alpha=(c.r*0.3 + c.g*0.6 + c.b*0.1 < 0.2) ? 1 : 0.5;
			}
			ENDCG
	}
		FallBack "Diffuse"
}

