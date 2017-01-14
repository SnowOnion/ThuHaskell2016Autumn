Project-FAQ
---

# 这是

+ 近些天，同学们关于 Haskell 大作业的提问、助教和老师的解答以及相关的讨论。
+ 重要的信息。如允许使用的 package。

本文档会持续更新。在大作业期间，你可以在 Github 上 watch 本仓库，以在本文档（以及本仓库）被修改时收到邮件通知。

你可以发邮件（snowonionlee@gmail.com）、提 issue、通过微信（snowonion）（不是很喜欢- -）来联系助教。


# (Maybe F)AQ

1. Q: 回家后，在非教育网环境，用 cabal/stack 下载 package 没速度/很慢，怎么办？

	A: 按照 [https://mirror.tuna.tsinghua.edu.cn/help/hackage/](https://mirror.tuna.tsinghua.edu.cn/help/hackage/)，把 cabal 或 stack 配置成使用 TUNA 的镜像源，而非默认的源。

	Windows 10 下的 `~` 默认是 `C:\Users\<用户名>\AppData\Roaming`

	(感谢 LZW 同学)

1. Q:

	A:

1. Q:

	A:

# 已知允许使用的 package

按字典序排列。

不在列表里的不一定不可用。如果你想用的 package 不在这个列表里，请联系助教，取得同意后可以使用。被同意的 package 会更新到这里 :D

```
attoparsec
containers
GenericPretty
haskeline
HUnit
optparse-applicative
pretty
QuickCheck
test-framework
test-framework-hunit
test-framework-quickcheck2
text

```

# 已知不允许使用的 package

按字典序排列。

```
TODO
```

# 程序的行为

## 关于文档里未详细定义的行为

在作业的需求文档里没有良好定义的程序行为，请当做 undefined behavoir，即在出现这样的源程序时，可以用你认为合理的方式处理。

请在交付的文档里写明对这些情形的处理方式。最好有相应的测试用例来明显地体现这些情形。

## 一些参考程序

这里提供一些源程序，以及对它们的期望行为。如果这些期望行为与作业的需求文档有冲突，以作业的需求文档为准。<!--（包括上述的 undefined behavoir）-->

特别是输出格式，仅供参考。

**求值后的结果**：用源程序语法表示。

**求值后的AST（供参考）**：求值结束时的抽象语法树。用 Haskell 语法表示。如果你用了网络学堂里提供的 Simple.hs 和 While.hs，

*P.S. `Simple.hs` 的 `data Result` 漏掉了 `CharResult Char` 这种结点。抱歉。*

**输出（供参考）**：解释执行、在 REPL 中求值该表达式、编译执行 时的期望输出。

### 实现 3.1 所有特性之后

| 源程序 | 求值后的结果 |  求值后的AST（供参考） | 输出（供参考）
| :--------   | :---   | :---- | :---|
|nil|nil|NilResult|nil 或 ()|
|'a'|'a'|CharLit 'a'|a
|"ab"|(cons 'a' (cons 'b' nil))|ConsResult 'a' (ConsResult 'b' NilResult) | (cons 'a' (cons 'b' nil)) 或 ('a' ('b' ()))
|(cons 'a' (cons 'b' nil))|(cons 'a' (cons 'b' nil))| ConsResult 'a' (ConsResult 'b' NilResult)|(cons 'a' (cons 'b' nil))
|(car (cons 'a' (cons 'b' nil)))|'a'|CharResult 'a'|a
|(cdr (cdr (cons 'a' (cons "bcd" nil))))|nil|NilResult|nil
|(cons 1 nil)|1|NumberLit 1|1
|(cons True (cons (/ 2.46 2) False))|(cons True (cons 1.23 False))|ConsResult (BoolResult True) (ConsResult (NumResult 1.23) (BoolResult False)|(cons True (cons 1.23 False))

`TODO`