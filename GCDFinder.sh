#!/bin/bash

# エラーメッセージ
ERR_MSG_ARG_CNT="引数が2つではありません"
ERR_MSG_ARG_NUM="引数が自然数ではありません"

################################
## [[[[大きいほうを取得する]]]]
## $1: 比較対象1
## $2: 比較対象2
################################
MAX() {
    if [ $1 -ge $2 ]; then
        printf $1
    else
        printf $2
    fi
}

################################
## [[[[小さいほうを取得する]]]]
## $1: 比較対象1
## $2: 比較対象2
################################
MIN() {
    if [ $1 -ge $2 ]; then
        printf $2
    else
        printf $1
    fi
}

################################
## [[[[エラー終了する]]]]
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

# 最大公約数を計算
dividend=$(MAX $1 $2)
divisor=$(MIN $1 $2)
flag=0
while [ ${flag} -eq 0 ]; do
    mod=$(( ${dividend} % ${divisor} ))
    if [ ${mod} -eq 0 ]; then
        flag=1
    else
        dividend=${divisor}
        divisor=${mod}
    fi
done

# 最大公約数を出力
echo ${divisor}

exit 0
