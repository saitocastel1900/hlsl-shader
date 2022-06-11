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

## 参照資料
https://github.com/shoeisha-books/hlsl-grimoire-sample  
https://nn-hokuson.hatenablog.com/entry/2018/02/15/140037  
