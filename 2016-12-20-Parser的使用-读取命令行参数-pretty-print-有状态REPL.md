Parser的使用-读取命令行参数-pretty-print-有状态REPL
---

[dazuoye_repl/src](dazuoye_repl/src) 目录下的四个 `Lib*.hs` 分别展示了 parser 的使用效果、怎样读取命令行参数、怎样 pretty-print、怎样实现有状态的 REPL。

实现方式去看 dazuoye_repl 代码咯。这里展示它们各自的效果。


# 0. Tips
若要在 ghci 中测试这几个 Lib （特别是第一个），需要 `import Data.Attoparsec.Text` 使 parseOnly 和 parse 函数可见；并 `:set -XOverloadedStrings` 以使期待接受 `Data.Text.Internal.Text` 类型的参数的 `parseOnly exprParser` 能接受字符串字面量。
	
	➜  dazuoye_repl git:(master) ✗ stack ghci
	省略十几行
	*Main Lib Lib2 Lib3 Lib4> import Data.Attoparsec.Text
	*Main Lib Lib2 Lib3 Lib4 Data.Attoparsec.Text> :set -XOverloadedStrings
	*Main Lib Lib2 Lib3 Lib4 Data.Attoparsec.Text> parseOnly exprParser "(not True)   MORE"
	Right (Not TrueLit)


# 1. parser 的使用效果

这里是只支持了not，没支持and和or的 [exprParser](dazuoye_repl/src/Lib.hs) 。

`Lib.hs` 的 `defMain` 里，尝试了分别使用 `parseOnly` 和 `parse` 函数对 `"(not True)", "(nXXX True)", "(not Tr", "(not True)   MORE"` 这几种输入的 parsing 结果。

另外 `evalWithErrorThrowing` 函数展示了对不合法的输入处理方式中的一种……

## 使用

在 `app/Main.hs` 里

	import Lib

然后

	➜  dazuoye_repl git:(master) ✗ stack build

	➜  dazuoye_repl git:(master) ✗ stack exec dazuoye
	Right (Not TrueLit)
	Done "" (Not TrueLit)
	-------
	Left "string"
	Fail "nXXX True)" [] "string"
	-------
	Left "'(': Failed reading: satisfy"
	Partial _
	-------
	Right (Not TrueLit)
	Done "   MORE" (Not TrueLit)
	--------------
	Right (Not TrueLit)
	Done "" (Not TrueLit)
	-------
	Left "string"
	Fail "nXXX True)" [] "string"
	-------
	Left "'(': Failed reading: satisfy"
	Partial _
	-------
	Right (Not TrueLit)
	Done "   MORE" (Not TrueLit)
	--------------
	"False"
	"not a valid bool expr: '(': Failed reading: satisfy"
	"not a valid bool expr: string"
	"False"

p.s. [Data.Attoparsec.Text](https://hackage.haskell.org/package/attoparsec-0.13.1.0/docs/Data-Attoparsec-Text.html) 提供了 parseOnly, parse, parseWith 和 parseTest 来配合我们写的 Parser 以实现不同的 parsing 需求。

	*Main Lib Data.Attoparsec.Text> :t parseOnly 
	parseOnly
	  :: Parser a
	     -> text-1.2.2.1:Data.Text.Internal.Text -> Either String a

	*Main Lib Data.Attoparsec.Text> :t parse
	parse
	  :: Parser a -> text-1.2.2.1:Data.Text.Internal.Text -> Result a

	*Main Lib Data.Attoparsec.Text> :t parseWith 
	parseWith
	  :: Monad m =>
	     m text-1.2.2.1:Data.Text.Internal.Text
	     -> Parser a -> text-1.2.2.1:Data.Text.Internal.Text -> m (Result a)

	*Main Lib Data.Attoparsec.Text> :t parseTest 
	parseTest
	  :: Show a =>
	     Parser a -> text-1.2.2.1:Data.Text.Internal.Text -> IO ()

# 2. 怎样读取命令行参数

## 使用

在 `app/Main.hs` 里

	import Lib2

然后

	➜  dazuoye_repl git:(master) ✗ stack build

	➜  dazuoye_repl git:(master) ✗ stack exec dazuoye -- --in ArgumentNamedIn.txt --out ArgumentNamedOut.txt
	Just (Option {inPath = "ArgumentNamedIn.txt", outPath = "ArgumentNamedOut.txt"},[])
	➜  dazuoye_repl git:(master) ✗ stack exec dazuoye -- --out ArgumentNamedOut.txt --in ArgumentNamedIn.txt
	Just (Option {inPath = "ArgumentNamedIn.txt", outPath = "ArgumentNamedOut.txt"},[])
	➜  dazuoye_repl git:(master) ✗ stack exec dazuoye -- --out ArgumentNamedOut.txt           
	Nothing
	➜  dazuoye_repl git:(master) ✗ stack exec dazuoye                          
	Nothing

---
# 3. 怎样 pretty-print
## 使用

在 `app/Main.hs` 里

	import Lib3

然后

	➜  dazuoye_repl git:(master) ✗ stack build
	➜  dazuoye_repl git:(master) ✗ stack exec dazuoye
	Cons 5
	     (Cons 4
	           (Cons 3
	                 (Cons 2 (Cons 1 Nil Nil) (Cons 1 Nil Nil))
	                 (Cons 2 (Cons 1 Nil Nil) (Cons 1 Nil Nil)))
	           (Cons 3
	                 (Cons 2 (Cons 1 Nil Nil) (Cons 1 Nil Nil))
	                 (Cons 2 (Cons 1 Nil Nil) (Cons 1 Nil Nil))))
	     (Cons 4
	           (Cons 3
	                 (Cons 2 (Cons 1 Nil Nil) (Cons 1 Nil Nil))
	                 (Cons 2 (Cons 1 Nil Nil) (Cons 1 Nil Nil)))
	           (Cons 3
	                 (Cons 2 (Cons 1 Nil Nil) (Cons 1 Nil Nil))
	                 (Cons 2 (Cons 1 Nil Nil) (Cons 1 Nil Nil))))

---

# 4. 怎样实现有状态的 REPL

## 使用

在 `app/Main.hs` 里

	import Lib4

然后

	➜  dazuoye_repl git:(master) ✗ stack build

	➜  dazuoye_repl git:(master) ✗ stack exec dazuoye
	This is a simple REPL. Be my guest!
	> 1
	unrecognized command!
	> view 1
	variable not found!
	> set 1 li ming
	unrecognized command!
	> set 1 liming
	1 is set to liming
	> set a jenny
	a is set to jenny
	> view 1
	1 = liming
	> view a
	a = jenny
	> set a danny
	a is set to danny
	> view a
	a = danny
	> exit
	Bye~