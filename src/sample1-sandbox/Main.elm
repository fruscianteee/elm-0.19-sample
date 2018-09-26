module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (Html, div, input, text)
import Html.Attributes exposing (placeholder, value)
import Html.Events exposing (onInput)



{-
   外部通信を必要としない、sandboxというElmアーキテクチャのサンプルソース
   最初に読み込む箇所を作成する。
   型の意味:Flagを持たず、Model型のモデルを持ち、Msg型のメッセージを実行するプログラムである。
   補足:()は何もないという意味。ModelやMsgはどこから出てきたかはすぐ下を見ればtype宣言しているのが分かる。その型を参照している。

   init   -- 初回処理を実行したいものをセットする。主にモデルの初期化など。
   update -- この画面で使用する動作をセットする。ボタンクリックや入力時のイベントなど。
   view   -- 実際にHTMLになる部分。Elm特有の書き方をすることでHTMLを簡略して書くことが出来る。
          -- コンパイルすると、ここが実際のHTMLとして展開される。
-}


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }



{-
   [MODEL]
     Elmの各関数はJavaScriptの「let hoge = 1;」のような状態を保持しない仕組みである。
     そのため、モデルという所を作成し、そこに状態保持を任せている。
     そのおかげで、各関数は純粋な関数として作成できる。

     モデルの型を宣言する。例ではModelにしているが、Hogeでも何でもOK
     この型を基準とする。上のmain関数の型としての役割もある。
     補足：type aliasは特定のオブジェクトのような構造を任意の名前で型宣言したという意味。
     複雑な構造(レコード)に名前を付けることで型の表記を簡単にできる。
     でないと、すぐ下の
     init : Model
     が
     init : {content : String}
     と書かなければいけなくなり、名前を付けないと、なぜその型なのか意味もわからなくなってしまう。
-}


type alias Model =
    { content : String
    }



{-
   初期化する処理を実行する。ここでは空文字に初期化している。
   モデルとして管理するために、上のmain関数のinitにセットしている。
   その際に、initの型とmainの型がModelで統一していなければ、コンパイルで怒られる。
   普通はやらないが、補足として、Modelでなく、HogeHogeという型でもモデルの型の中身が同じ({ content : String})であれば、一応コンパイルは通る。
-}


init : Model
init =
    { content = ""
    }



{-
   [UPDATE]
     モデルを更新する処理は全てupdateに書く。
     Msg(メッセージ)という言葉は馴染みがないが、最初は「Msg = アクション」という解釈の方が分かりやすいかもしれない。
     が、実際理解が深くなっていくと、アクションというより、「何かしら処理したいための識別タグ」のようなものの方がしっくりくると思う。
     つまり、InputContent自体は処理がなく、ただの識別に使う名前と思えば良いと思う。
     以上を理解したら、次の文章の意味もスッと入ってくるはずだ。
     「どこからかInputContentというメッセージが送られてきた場合は、必ずStringの文字列がくっ付いて送られていくる。
     そのメッセージを受け取ったら、Updateにあるケース文でどれかを特定し、その処理をする」
-}


type Msg
    = InputContent String



{-
   モデルを更新する処理を書く。
   処理するメッセージとモデルを引数にして、何かしらの処理をし、戻り値としてモデルを返し、反映するという仕組み。
-}


update : Msg -> Model -> Model
update msg model =
    {-
       ケース文。メッセージを判別する。Msgと型宣言しているので、
       ここに入ってくるmsgは必ずtype Msgで宣言したものしか入ってこれないようになっている。
       補足：Msgは型です。msgは引数の名前です。全く違うものなので、
       「Msgとmsgがあって何で大文字小文字で使い分けているの！？」と変な混乱しないように注意すること。
    -}
    case msg of
        InputContent newContent ->
            {-
               modelのレコードを更新するには以下の書き方をする。
               {更新対象のレコード | 指定したフィールド = 更新したい内容}
               つまり、contentのフィールドの中身を任意の文字に更新するという意味を表している。
            -}
            { model | content = newContent }



{-
   [VIEW]
     HTMLへ変換する箇所。
     HTMLを表す要素(element)は、
       関数 第一引数 第二引数
     で構成されていて、各引数は配列になっている。
     第一引数の配列には、属性やイベントを表している。複数属性は、カンマ区切りにする。
     第二引数の配列には、要素の中身を表している。複数の中身はカンマ区切りにする。

     例：
     <div id="main" class="style" onClick="hoge()">test</div>
     であれば、
     div [id "main", class "style", onClick hoge] [text "test"]
     という風になる。

     このサンプルでは、入力ボックスにテキストを入力すると、
     onInputの処理が動作し、modelのcontentにデータをセットする。
     セットしたデータ参照するために、value属性にmodelのcontentを表示するようにする。
     また div [] [ text model.content ]というところで改めて表示している。
     こういった入力が即時反映されている状態を双方向データバインディングと呼んだりするが、特に呼び名は気にしなくていい。

-}


view : Model -> Html Msg
view model =
    div []
        [ input [ placeholder "何かを入力してください", value model.content, onInput InputContent ] []
        , div [] [ text "入力した物は以下にも表示されます。" ]
        , div [] [ text model.content ]
        ]
