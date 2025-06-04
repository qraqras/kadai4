#!/bin/bash

# エラーメッセージ
ERR_MSG_ARG_CNT="引数が2つではありません"
ERR_MSG_ARG_NUM="引数が自然数ではありません"

################
# エラー終了する
# $1: エラーメッセージ
# $2: エラーコード
################
EXIT_ERR ()  {
    echo "$1" >&2
    exit "$2"
}

# 引数の判定
if [ $# -ne 2 ]; then
    EXIT_ERR ${ERR_MSG_ARG_CNT} 1
fi
if [[ $1 =~ ^[0-9]+$ ]] && [[ $2 =~ ^[0-9]+$ ]] ; then
    if [ $1 -ne 0 ] && [ $2 -ne 0 ]; then
        :
    else
        EXIT_ERR ${ERR_MSG_ARG_NUM} 1
    fi
else
    EXIT_ERR ${ERR_MSG_ARG_NUM} 1
fi

