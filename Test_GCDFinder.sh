#!/bin/bash

tmp=/tmp/$$

################
# テストを実行する
# $1  : テスト失敗時メッセージ
# $2  : 想定結果(標準出力)
# $3  : 想定結果(標準エラー出力)
# $4-N: テスト引数
################
EXECUTE() {
    # 第1引数から第3引数まで取得する
    for i in {1..3}; do
        args[$i]=$1
        shift
    done
    # 想定結果を出力する
    if [ "${args[2]}" = "_" ]; then
        printf "" > ${tmp}-stdout-expected
    else
        printf "${args[2]}\n" > ${tmp}-stdout-expected
    fi
    if [ "${args[3]}" = "_" ]; then
        printf "" > ${tmp}-stderr-expected
    else
        printf "${args[3]}\n" > ${tmp}-stderr-expected
    fi
    # 実行結果を出力する
    ./GCDFinder.sh $@ 1> ${tmp}-stdout-actual 2> ${tmp}-stderr-actual
    # 想定結果と実行結果を比較する
    diff ${tmp}-stdout-expected ${tmp}-stdout-actual || EXIT_ERR ${args[1]}
    diff ${tmp}-stderr-expected ${tmp}-stderr-actual || EXIT_ERR ${args[1]}
}
################
# エラー終了する
# $1: メッセージ
################
EXIT_ERR() {
    # ファイルを削除する
    rm -f ${tmp}-*
    # エラー終了する
    echo fail!: "$1" >&2
    exit 1
}


EXECUTE "test_01" "_" "引数が2つではありません" "1"
EXECUTE "test_02" "_" "引数が2つではありません" "A"
EXECUTE "test_03" "_" "引数が2つではありません" "1" "2" "3"
EXECUTE "test_04" "_" "引数が2つではありません" "A" "2" "3"
EXECUTE "test_05" "_" "引数が自然数ではありません" "1" "A"
EXECUTE "test_06" "_" "引数が自然数ではありません" "1" "1.5"
EXECUTE "test_07" "_" "引数が自然数ではありません" "1" "0"
# EXECUTE "test_0" "" "" ""

# 合格
echo "succeed!"
# ファイルを削除する
rm -f ${tmp}-*





