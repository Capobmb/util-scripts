#!/usr/bin/env julia

module PasswordGenerator

const VOWELS = ['a', 'e', 'i', 'o', 'u']
const CHARACTERS = 'a':'z'
const DIGITS = '0':'9'

# ランダムに大文字または小文字の文字を返す関数
function randcasechar()::Char
    char = rand(CHARACTERS)
    return rand() > 0.75 ? uppercase(char) : char
end

# パスワード生成
"""
    randpassword()::String

ランダムなパスワード`password`を生成する。

`password`: `unitrepeat` の 中の unit の頭文字をランダムに数字に置き換えた文字列  
`unitrepeat`: '{`unit`}-{`unit`}-{`unit`}'  
`unit`: '{`char`}{`vowel`}{`char`}{`char`}{`vowel`}{`char`}'  
`char`: アルファベット大文字または小文字  
`vowel`: 母音小文字  

"""
function randpassword()::String
    password = Char[]  # Char型の空配列を初期化
    numunits = 3
    unitlen = 6

    for i in 1:numunits
        for j in 1:unitlen
            if j == 2 || j == 5
                # 2番目と5番目は母音
                push!(password, rand(VOWELS))
            else
                # それ以外はアルファベットで50%の確率で大文字にする
                push!(password, randcasechar())
            end
        end
        if i != numunits
            push!(password, '-')
        end
    end

    password[1+(rand(1:numunits)-1)*(unitlen+1)] = rand(DIGITS)  # ランダムな位置に数字を挿入

    join(password)  # Char配列をString型に変換して返す
end

end  # module PasswordGenerator

# メイン処理

PasswordGenerator.randpassword() |> println
