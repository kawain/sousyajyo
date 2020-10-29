import strutils
import tables


# 逆ポーランド記法
proc rpn(str: string): float =
  let arr = str.strip().split(" ")
  var stack: seq[float]
  for v in arr:
    try:
      stack.add(v.parseFloat)
    except ValueError:
      let n2 = stack.pop()
      let n1 = stack.pop()
      case v
      of "+":
        stack.add(n1 + n2)
      of "-":
        stack.add(n1 - n2)
      of "*":
        stack.add(n1 * n2)
      of "/":
        stack.add(n1 / n2)
  stack[0]


# 操車場アルゴリズム
proc calc(input: var string) =
  # スペースを削除
  input = input.replace(" ", "")
  # 記号の前後にスペース追加
  input = input.replace("+", " + ")
  input = input.replace("-", " - ")
  input = input.replace("*", " * ")
  input = input.replace("/", " / ")
  input = input.replace("(", " ( ")
  input = input.replace(")", " ) ")
  # スペース2個を1個に置換
  input = input.replace("  ", " ")
  # 文字列を配列に分割
  let arr = input.split(" ")
  # 記号スタック
  var stack: seq[string]
  # 出力文字列
  var str = ""
  # 優先度
  let map = {
    "+": 2,
    "-": 2,
    "*": 3,
    "/": 3,
  }.toTable
  # 配列ループ
  for v in arr:
    try:
      # 数値の場合、それを出力キューに追加
      str.add($v.parseFloat & " ")
    except ValueError:
      # 数値でない
      case v
      of "+", "-", "*", "/":
        while true:
          if len(stack) == 0:
            break
          let o2 = stack[^1]
          if map.hasKey(o2):
            if map[v] <= map[o2]:
              str.add(stack.pop() & " ")
            else:
              break
          else:
            break
        stack.add(v)
      of "(":
        stack.add(v)
      of ")":
        while true:
          if len(stack) == 0:
            break
          let p = stack.pop()
          if p == "(":
            break
          str.add(p & " ")
      else:
        discard

  # 残りを追加
  while true:
    if len(stack) == 0:
      break
    str.add(stack.pop() & " ")

  # 計算結果
  echo rpn(str)


proc main() =
  while true:
    stdout.write "式を入力："
    var input = readLine(stdin)
    calc(input)


main()
