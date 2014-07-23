require.config({
  baseUrl: "./js",

  // CDNから読み込む場合
  paths: {
    'jquery': "//code.jquery.com/jquery-1.11.1.min",
    'jquery': "//ajax.aspnetcdn.com/ajax/jQuery/jquery-1.11.1.min",
    'jquery': "//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min",
    'bootstrap': "//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min",
    'confirm_dialog': "confirm_dialog"
  },

  // 依存設定
  shim: {
    "jquery" : {
      exports: '$'
    },
    "bootstrap" : {
      deps: ["jquery"]
    },
    "confirm_dialog": {
      deps: ["bootstrap"]
    }
  }
});
 
// プレイヤ除外用確認ダイアログ
require(["confirm_dialog"]);
