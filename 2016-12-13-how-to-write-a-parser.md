1. 初始化stack项目

	> stack new dazuoye

2. .cabal 干掉 executable 和 testsuite

我们先只关心lib

3.
dependency 里添加
	
	,text
	,attoparsec

此时执行

	> stack ghci
	
会需要较长时间去下载和构建这两个依赖。

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

额……干啥的？

	import Data.String
	
	import Data.Text
	
	:set -XOverloadedStrings
	
	t::Text
	t="123"


## attoparsec 库

各种parser大致都是
Input -> Maybe (Result,Input)
Input -> [(Result,Input)] -- 兹瓷歧义文法

而 attoparsec 只支持前一种




import Data.String
import Data.Text
import Data.Attoparsec.Text
:set -XOverloadedStrings

left = char '('

parseOnly left "(123"




trueParser = do
	char 'T'
	char 'r'
	char 'u'
	char 'e'
	
parseOnly trueParser "Tr123"

### 不一个一个字符parse 而是parse字符串

trueParser2 = string "True"

	*Main Lib Data.Text Data.Attoparsec.Text Data.String> parseOnly trueParser2 "Trueorfalse123"
	Right "True"
	*Main Lib Data.Text Data.Attoparsec.Text Data.String> parseOnly trueParser2 "trueorfalse123"
	Left "string"


### 如果要忽略大小写

trueParser3 = asciiCI "True"


现在我们会parse出一个字符串了。

# 定义一些语法结构，以布尔表达式为例

module Lib where

data Expr
	= TrueLit
	| FalseLit
	| Not Expr
	| And Expr Expr
	| Or Expr Expr
	deriring Show
	
	
-- 先定一个顶层目标
exprParser :: Parser Expr
exprParser = undefined 

### 如果只管 "True" 和 "False"

falseParser :: Parser Text
falseParser = string "False"

trueParser :: Parser Text
trueParser = string "True"

### 下面, not 表达式

	notParser :: Parser Expr
	notParser = do
		char '('
		skipspace
		string "not"
		skipspace
		expr <- exprParser -- 绑定到 expr 这个名字
		skipspace
		char ')'
		return (Not expr) -- 使用 Not 这个 data constructor，构造出有利于我们后续处理的（树形）结构
		
这需要改造成

	falseParser :: Parser Expr
	falseParser = string "False" $> FalseLit
	
	-- $> 是啥？
	
	trueParser :: Parser Expr
	trueParser = string "True" $> TrueLit


Applicative 类型类的实例都有的 alternative 操作符 <|>

	p0 <|> p1
含义：先p0解析，如果失败，则用p1解析

所以：

	exprParser :: Parser Expr
	exprParser = falseParser <|> trueParser <|> notParser



### and 和 or 的 parser 

留给读者

### 烦恼：每次手动 skipspace
一般，编译时先lexing，排除注释、空白，把字符串变成token串。而我们的parser省了lexing这一步……

一个解决办法：写一个lexeme。“抽象出去掉空格这个设计模式”。

	lexeme :: Parser a -> Parser a
	lexeme p = do
		skipSpace
		p

	notParser :: Parser Expr
	notParser = do
		lexeme $ char '('
		lexeme $ string "not"
		expr <- exprParser
		lexeme $ char ')'
		return (Not expr) 

---
	{# Language #}
---

还有一个话题：怎样实现一个 REPL 
---

