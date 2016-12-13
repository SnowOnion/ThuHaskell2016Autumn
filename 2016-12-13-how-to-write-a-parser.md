1.
> stack new dazuoye

2.
.cabal 干掉 executable 和 testsuite
我们先只关心lib

3.
dependency 里添加

,text
,attoparsec

此时执行
> stack ghci
会需要较长时间去下载和构建这两个依赖

4.
## 替代IDE的 基于ghci的 ghcid

> cd dazuoye
> stack install ghcid

5. 
(在 dazuoye 目录下)
> ghcid

6. 
在屏幕的一边儿编辑 Lib.hs
另一边儿开着 ghcid

每次一保存 Lib.hs，ghcid就即时检查错误，报错或显式 all good。
……这很敏捷

## text 库


IsString

import Data.String
:set -XOverloadedStrings

t::Text


## attoparsec 库

各种parser大致都是
Input -> Maybe (Result,Input)
Input -> [(Result,Input)] -- 兹瓷歧义文法

而 atto

