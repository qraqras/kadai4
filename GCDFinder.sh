#!/bin/bash

# エラーメッセージ
ERR_MSG_ARG_CNT="引数が2つではありません"
ERR_MSG_ARG_NUM="引数が自然数ではありません"

################################
## エラー終了する
## $1: エラーメッセージ
## $2: エラーコード
################################
EXIT_ERR()  {
    echo "$1" >&2
    exit "$2"
}

# 引数の個数を判定
if [ $# -ne 2 ]; then
    EXIT_ERR ${ERR_MSG_ARG_CNT} 1
fi
# 引数が自然数か判定
for i in "$@"; do
    if [[ $i =~ ^[0-9]+$ ]]; then
        if [ $i -eq 0 ]; then
            EXIT_ERR ${ERR_MSG_ARG_NUM} 1
        fi
    else
        EXIT_ERR ${ERR_MSG_ARG_NUM} 1
    fi
done


exit 0
