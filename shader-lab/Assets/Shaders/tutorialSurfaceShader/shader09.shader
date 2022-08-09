Shader "Custom/shader09"
{
	//公開するテクスチャプロパティ
	Properties{
		//テクスチャ設定前のべた塗を指定できる(red,white,blakc)
			_MainTex("海テクスチャ", 2D) = "red"{}
	}
		SubShader{
			//描画順を透明度を一番後に（そうしないとバグるため）
			Tags { "RenderType" = "Opaque"  }
			LOD 200

			CGPROGRAM
		
			//fullforwardshadowsはデフォルト設定（物理レンダリング）。
			#pragma surface surf Standard 
			#pragma target 3.0

			//テクスチャを設定するために、uv座標を入手
			struct Input {
				float2 uv_MainTex;
			};

			//2Dテクスチャ＝＝sampler2D
			sampler2D _MainTex;

			void surf(Input IN, inout SurfaceOutputStandard o) {
				fixed2 uv = IN.uv_MainTex;
				uv.x += 5* _Time;
				uv.y += 5* _Time;
				
				o.Albedo = tex2D(_MainTex, uv);
				
			}
			ENDCG
	}
		FallBack "Diffuse"
}

