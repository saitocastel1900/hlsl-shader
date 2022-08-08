# visualstudio-hlsl
シェーダー言語であるHLSLとshaderlabについて学習した際にしたリポジトリです。ご自由にお使いください。  

# HLSL
## C1 絵が表示されるまでの手順
ドローコール(CPU：絵を描け)→レンダリングパイプライン(GPU：手順に沿って(レンダリングパイプライン)絵を描きます)
**レンダリングパイプライン**
-入力アセンブラー(絵を描くために必要なデータを準備する)  
-頂点シェーダ(3Dモデルの頂点座標をスクリーン座標に変換する)  
-ラスタライズ(座標変換された3Dモデルを画面に表示するために塗りつぶす必要があるピクセルを決定する)  
-ピクセルシェーダ(ラスタライズでピクセルの色を決定する)  

## C2 
＊wWinmain()関数はメイン関数(エントリーポイント：プログラムのスタート地点)

### 三角形を表示するための準備
・ルートシグネチャを作成  
・シェーダーをロード（頂点シェーダーとピクセルシェーダーのロード）  
・パイプラインステートを作成（レンダリングパイプラインを詳しく設定）  
・三角形の頂点バッファを作成（表示する三角形の頂点データを作成）  
・三角形のインデックスバッファを作成  
・三角形を表示するためのドローコール　実際に描画する  
### 頂点シェーダー
・すべての頂点に対して行われるプログラム  
・頂点の数だけVSMain()が実行される
・この段階では頂点シェーダは何もしていないので何も表示されない  
```
// 頂点シェーダー
// 1. 引数は変換前の頂点情報（頂点一個分）
//VSInputは入力される頂点データを管理
//VSOutputは出力される頂点データを管理
VSOutput VSMain(VSInput In)
{
    VSOutput vsOut = (VSOutput)0;

    // step-1 入力された頂点座標を出力データに代入する

    // step-2 入力された頂点座標を2倍に拡大する

    // step-3 入力されたX座標を1.5倍、Y座標を0.5倍にして出力

    // 2. 戻り値は変換後の頂点情報
    return vsOut;
}
```
**改造してみる**
・vsOut.pos=In.pos;を追加すると実査に描画される  
・vsOut.pos.x = 2.0f;..で(x,y)座標をそれぞれ倍にしている  
```
VSOutput VSMain(VSInput In)
{
    VSOutput vsOut = (VSOutput)0;

    // step-1 入力された頂点座標を出力データに代入する
    vsOut.pos=In.pos;
    // step-2 入力された頂点座標を2倍に拡大する(x,y)*2
    vsOut.pos.x *= 2.0f;
    vsOut.pos.y *= 2.0f;
    // step-3 入力されたX座標を1.5倍、Y座標を0.5倍にして出力

    // 2. 戻り値は変換後の頂点情報
    return vsOut;
}
```
### 入力頂点構造体
・頂点バッファ（頂点データが頂点数だけ並んだもの）  
・セマンティックで座標が持っている情報(UVとか色とか,,)のうち、座標だけを持って来いと指定している  
・出力頂点構造体ではSV_POSITIONと指定している（UV座標）  
```
// 頂点シェーダーへの入力頂点構造体
struct VSInput
{
    //float4は組込み型　(x,y,z,w)
    //:POSITIONはセマンティック データの扱われ方を定義する
    float4 pos : POSITION;
};
```

### ピクセルシェーダ入門　色塗り
・PSMain()がピクセルシェーダのエントリーポイント  
・頂点シェーダから出力されたデータを使う
・戻り値はカラー(RGBA)  
・ラスタライズが色の補間が自動的に行う  

# ShaderLab
## ShaderLab超入門
### Unityのシェーダで遊んでみよう  
・事前にmaterialとStandard Surface Shaderを作成  
・ゲームオブジェにマテリアルをアタッチして、シェーダーをCustom/シェーダーファイル名に設定（これでシェーダーファイルとマテリアルが紐づけられる）  
・サーフェスシェーダーの流れは頂点情報を処理→色を決める→ライティング  
・VertexとLightingはUnity側でやってくれるので色を決める工程をいじることにする  
・Vertex:頂点座標を処理  
・Surf:オブジェクトの色を決める  
・Lighting:ライティング  
・実際にコードを観てみるとParameters(インスペクタに公開する変数)、Shader Settings(ライティングや透明度を設定)、Surface Shader(ここで色とかを決める)の3つのパートに分かれる
```
        //albedoを書き換える
        //INを受け取り、SurfaceOutputStandardを出力する
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = fixed4(0.1f, 0.1f, 0.1f, 1);
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
```
-ここではオブジェクトの基本色を定義しているAlbedoにRGB(0.1, 0.1, 0.1)を代入することで色を変更している

### 【Unityシェーダ入門】20行から始めるUnityミニマルシェーダ
#### Inputで座標を入手
・Vertexで変換された座標を取得する  
・uv＿MainTexとかいろいろな座標を入手できる  
・OutputはAlbedoとNormalを取得できる  
＊色を塗るだけならInputは必要ないが、コンパイルが通らないので一応..  

#### Surfで色を塗る
・SurfaceOutPutStandardからAlbedoを入手して、色を指定  

## surfaceシェーダ入門
#### Albedoを公開してみる
・Propertiesで色を公開  
・スクリプトで色を変えたりもできる  
```
//公開するプロパティ
Properties{
        //Base Colorは公開する色の変数名
        _BaseColor("Base Color",Color)=(1,1,1,1)
        }
        
fixed4 _BaseColor;
        
        //色塗り
 void surf (Input IN, inout SurfaceOutputStandard o)
 {
      //albedoは基本色
      o.Albedo=_BaseColor.rgb;
 }
 
 #Script
 void Start(){
 //_BaseColorは公開されている変数名
 //変数に値を設定
  GetComponent<Renderer>().material.SetColor("_BaseColor",new Color(1,1,1,1));
    }
```
### 【Unityシェーダ入門】透明なシェーダを作る
![スクリーンショット 2022-08-08 004335](https://user-images.githubusercontent.com/96648305/183299178-76c41eca-251f-4808-b270-39f931b82094.png)  
・Tagをsurface surf Standard alpha:fadeに変更  
・#pragmaにalpha:fadeを追加  
・Albedoに透明度を追加  

```
Tags { "Queue" = "Transparent" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard alpha:fade 
        #pragma target 3.0
        
        //色塗り
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            //albedoは基本色
            o.Albedo=fixed4(0.6f, 0.7f, 0.4f, 1);
            o.Alpha=0.5f;
        }
        ENDCG
```
- TagでQueueを指定(半透明なものを描画する際は、後から描画しないとバグるため)   
- alpha:fadeで半透明が可能になる 　　
- 後はA値を設定すれば半透明に  

### 【Unityシェーダ入門】氷のような半透明シェーダを作る
![スクリーンショット 2022-08-08 010018](https://user-images.githubusercontent.com/96648305/183299879-1ab17cbe-5d35-4807-8137-1563cbca290b.png)  
・法線ベクトルと視線ベクトルの追加
・A値の計算式を変更
```
    Properties
    {
        _Alpha("Alpha", Range(0,1)) = 0.5
               }
    
    SubShader
    {
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
```

- 法線ベクトル（ポリゴンの垂直方向のベクトル）と視線ベクトル（カメラが向いている方向のベクトル）を入力
- リムライティングを使って表現
- 中央と輪郭部分の内積の差で表現

### 【Unityシェーダ入門】リムライティングのシェーダを作る
![スクリーンショット 2022-08-08 040655](https://user-images.githubusercontent.com/96648305/183307171-cd74e7c3-3b87-454a-9d62-7c2ef837e48c.png)  


・リムライティングとは、オブジェクトに後ろから光を当てて、輪郭を光らせる事  
・前回の物を流用（Emmisionを色々いじる）  

```
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
            o.Emission = _RimColor *rim;//rim(0~1)
        }
        ENDCG
    }
    FallBack "Diffuse"
```
- おおよそは前回の物  
- o.Emissionにを代入することで、輪郭のみを光らせている

### 【Unityシェーダ入門】テクスチャを表示する
・テクスチャを公開して設定する  
・テクスチャからuv座標で、必要な色を求める(text2D関数)
![スクリーンショット 2022-08-08 152133](https://user-images.githubusercontent.com/96648305/183353463-2c8b304b-103b-478d-9dbb-bb9dd3f0d020.png)  

```
//公開するテクスチャプロパティ
	Properties{
		//テクスチャ設定前のべた塗を指定できる(red,white,blakc)
			_MainTex("テクスチャ", 2D) = "red"{}
	}
		
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
				//tex2D関数で割り当てる色をuv座標から求めて、必要な色を割り当てる
				o.Albedo = tex2D(_MainTex, IN.uv_MainTex);
			}
			ENDCG
```
- fullforwardshadowsにすることで、影のつけ方を増やすことが出来る  

### 【Unityシェーダ入門】ステンドグラスのシェーダを作る
### 【Unityシェーダ入門】uvスクロールで水面を動かす

## 参照資料
https://github.com/shoeisha-books/hlsl-grimoire-sample  
https://nn-hokuson.hatenablog.com/entry/2018/02/15/140037  
https://logicalbeat.jp/blog/11034/  
https://zenn.dev/r_ngtm/books/shadergraph-cookbook  

## 使用モデル元
http://graphics.stanford.edu/data/3Dscanrep/
