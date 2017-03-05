[Hackage](http://hackage.haskell.org), [Stackage](https://www.stackage.org) 和 Stackage 提供的 Haskell 项目构建工具 stack
---

授课：[Canto Ostinato](https://github.com/terrorjack) [（或这里）](https://zhuanlan.zhihu.com/p/21798264#!)

Licence：暂时 all rights reserved。取决于 Canto Ostinato 的授权。

# [Hackage](http://hackage.haskell.org)
Hackage 是 Haskell 的一个中心化包仓库。这种形式在成熟语言里蛮常见，比如 Java 的 Maven。

## 使用 Hackage

比如，搜 `base`，可找到 [base package](http://hackage.haskell.org/package/base)，

里面的 Data.List, Data.Maybe 等，都是 module。可以看它们的文档。

文档的重要信息：[该类型是哪些类型类的instance](http://hackage.haskell.org/package/base-4.9.0.0/docs/Data-Maybe.html#t:Maybe)；[函数的类型签名、功能描述](http://hackage.haskell.org/package/base-4.9.0.0/docs/Data-List.html#v:iterate)；[源代码](http://hackage.haskell.org/package/base-4.9.0.0/docs/src/GHC.List.html#iterate)（通过文档里的source链接进入）

形如 Data.Vector 的module的目录结构是怎样的？

```
vector-0.6.2\
 src\
  Data\
     Vector.hs -- Data.Vector
```


# [Stackage](https://www.stackage.org) 和 stack

以前，有包管理器cabal。

stack约为cabal改进版。推荐stack。一个明显的优势是 snapshot。

## Stackage Snapshot

在项目使用多个第三方 package 时，存在一些package依赖问题。

比如菱形依赖问题：

	项目需要用 d 这个package的 1.0 版本。
	d-1.0 依赖 b-1.0 和 c-1.0, 
	b-1.0 依赖 a-1.0, c-1.0 却依赖 a-2.0, 
	a-1.0 和 a-2.0 不能并存，冲突了。

怎么办呢？

一个 Stackage snapshot 含有一堆 package 并指定了 package 版本。如 [lts-7.12](https://www.stackage.org/lts-7.12) 的：

	Package	Synopsis
	abstract-deque-0.3	Abstract, parameterized interface to mutable Deques
	abstract-par-0.3.3	Type classes generalizing the functionality of the 'monad-par' library
	AC-Vector-2.3.2	Efficient geometric vectors and transformations
	accelerate-0.15.1.0	An embedded language for accelerated array processing
	……


每个版本的snapshot在release之前已经分析好了，里面的package都是兼容的。（在集群上跑的分析）解决了上述菱形依赖问题。

（有点像spacemacs的layer？TODO）

### snapshot 分成两类

+ LTS = Long Time Support
+ nighty 频繁更新

### 提供了搜索工具 Hoogle 来搜一个snapshot
[比如这个](https://www.stackage.org/lts-7.12/hoogle?q=random)

啊！所以hoogle并不特指 [https://www.haskell.org/hoogle/](https://www.haskell.org/hoogle/) ……

+ 用函数名、类型名、类型类名、module名搜索
+ 用类型签名搜索

# stack 用法

## 新建项目

	> stack new some-package

也可以指定使用哪个 snapshot。如果不指定，如今默认是 lts-7.12

	> stack new some-package [--resolver nightly-2016-12-04]
	> stack new some-package [--resolver lts-7.12]

这会产生目录 some-package/

```
➜  some-package tree
.
├── LICENSE
├── Setup.hs
├── app
│   └── Main.hs
├── some-package.cabal
├── src
│   └── Lib.hs
├── stack.yaml
└── test
    └── Spec.hs
```

## some-package.cabal 配置文件

修改用这个配置文件来配置：

+ 一些metadata，如项目主页，项目许可证 etc.

+ library 
	+ hs-source-dirs 源文件目录
	+ exposed-modules 暴露出哪些module 
	+ build-depends 所有的依赖

+ executable some-package-exe 定义了名为 some-package-exe 的可执行目标
	+ hs-source-dirs
	+ main-hs 程序入口，即Haskell程序所必需的顶层module

+ test-suite some-package-test 定义了名为 some-package-test 的测试集

 
etc.

## src/Lib.hs

	module Lib
	    ( someFunc
	    ) where

这使得本 module 里定义的 someFunc 函数对其他 module 不可见。实现了一些细节隐藏。

## app/Main.hs

入口程序，里面有 main 函数，main :: IO ()。

## test/Spec.hs

通过让 main 返回不同的值来说明测试用例是否通过。具体写法需参考文档。 TODO

## 初始化

	> cd some-package
	> stack init
## Setup

	> cd some-package
	> stack setup
会安装所需要的 GHC 版本，等。
## 构建

	> cd some-package
	> stack build

（会追踪修改，只编译需要编译的部分。）

## 执行

因为 some-package.cabal 里配置了
`executable some-package-exe`, 其中`hs-source-dirs:      app` `main-is: Main.hs`，

所以

	> cd some-package
	> stack exec some-package-exe
	someFunc

会执行 app/Main.hs 里的 main 函数。

## 测试

因为 some-package.cabal 里配置了 test-suite some-package-test，`hs-source-dirs:      test` `main-is:             Spec.hs`
所以

	> cd some-package
	> stack test
	
会把test/Spec.hs的main函数作为测试用例执行。

## 调试

还是主要用 ghci。

	> cd some-package
	> stack ghci
	*Main Lib> main
	someFunc
	*Main Lib> :r
	Ok, modules loaded: Lib, Main.

### ghci 调试技巧

+ 小例子
	+ 用 data 定义新的类型之后，没有实现为 Show 类型类实例，也没有 deriving Show，却想在ghci里打印该类型的表达式。
		+ 看到报错去修改啦……

+ 多行定义

```
ghci > :{
ghci | class MyEq a where
ghci |   myEqual :: a -> a -> Bool
ghci > :}
```

+ `:i MyDataType`

+ `:t MyDataType`

+ 想把 ghci 里临时写的定义保存下来？
	+ hhh并不是在ghci里写完再保存，而是把想在ghci里写的东西写在 *.ghci 文件里

```
-- some-package/script.ghci start --
:{
class MyEq a where
	myEqual :: a -> a -> Bool
:}
-- some-package/script.ghci end --
```
然后

	ghci > :script script.ghci

+ 不退出 ghci，执行外面的shell的命令

ghci > :! 外面的shell的命令
如 Windows
`ghci > :!cls`
，Linux/Mac
`ghci > :!clear`

+ ghci也有断点调试


