#!/bin/bash

# テスト用ディレクトリ
tmp=/tmp/$$

################################
## [[[[テストを実行する]]]]
## $1  : テスト失敗時のメッセージ
## $2  : 想定結果[標準出力]       (出力なしの場合は"_"、比較しない場合は"*"とする)
## $3  : 想定結果[標準エラー出力] (出力なしの場合は"_"、比較しない場合は"*"とする)
## $4-N: テスト実行時の引数
################################
EXECUTE() {
    expected[1]=${tmp}-stdout-expected # 標準出力の想定結果
    expected[2]=${tmp}-stderr-expected # 標準エラー出力の想定結果
    actual[1]=${tmp}-stdout-actual     # 標準出力の想定結果
    actual[2]=${tmp}-stderr-actual     # 標準エラー出力の想定結果
    # 第1引数から第3引数まで取得する
    for i in {1..3}; do
        args[$(expr $i - 1)]=$1
        shift
    done
    # 想定結果をファイル出力する
    for i in {1..2}; do
        # "_"のときは空ファイルにする
        if [ "${args[$i]}" = "_" ]; then
            printf "" > ${expected[$i]}
        else
            printf "${args[$i]}\n" > ${expected[$i]}
        fi
    done
    # 実行結果をファイル出力する
    ./GCDFinder.sh $@ 1> ${actual[1]} 2> ${actual[2]}
    # 標準出力と標準エラー出力の内容を比較する
    for i in {1..2}; do
        #
        if [ "${args[$i]}" != "*" ]; then
            diff ${expected[$i]} ${actual[$i]} >/dev/null || EXIT_ERR ${args[0]}
        fi
    done
}

################################
## [[[[終了する]]]]
## $1: 終了コード
################################
EXIT() {
    # ファイルを削除する
    rm -f ${tmp}-*
    exit $1
}

################################
## [[[[エラー終了する]]]]
## $1: エラーメッセージ
################################
EXIT_ERR() {
    echo "fail($1)" >&2
    EXIT 1
}


# 引数のテスト(正常系)
EXECUTE "test_00"    "*"    "_"                             "1"    "1"
# 引数のテスト(異常系)
EXECUTE "test_01"    "_"    "引数が2つではありません"       "1"
EXECUTE "test_02"    "_"    "引数が2つではありません"       "A"
EXECUTE "test_03"    "_"    "引数が2つではありません"       "1"    "2"    "3"
EXECUTE "test_04"    "_"    "引数が2つではありません"       "0"    "2"    "3"
EXECUTE "test_05"    "_"    "引数が自然数ではありません"    "1"    "A"
EXECUTE "test_06"    "_"    "引数が自然数ではありません"    "1"    "0"
EXECUTE "test_07"    "_"    "引数が自然数ではありません"    "1"    "-1"
EXECUTE "test_08"    "_"    "引数が自然数ではありません"    "1"    "1.0"
# 最大公約数のテスト(正常系)
EXECUTE "test_09"    "1"    "_"    "1"    "2"
EXECUTE "test_10"    "1"    "_"    "2"    "1"
EXECUTE "test_11"    "1"    "_"    "3"    "4"
EXECUTE "test_12"    "1"    "_"    "5"    "2"
EXECUTE "test_13"    "2"    "_"    "2"    "4"
EXECUTE "test_14"    "4"    "_"    "4"    "4"
EXECUTE "test_15"    "11"   "_"    "121"  "209"
EXECUTE "test_16"    "19"   "_"    "133"  "228"
EXECUTE "test_17"    "28"   "_"    "112"  "252"
EXECUTE "test_18"    "238"  "_"    "714"  "1666"
EXECUTE "test_19"    "1"    "_"    "9967" "9973"


# すべて合格
echo "succeed!"
EXIT 0
