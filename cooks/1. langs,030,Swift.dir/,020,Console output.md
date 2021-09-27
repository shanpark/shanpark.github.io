## Console output

---

### 1. print(_:separator:terminator:)

```swift
public func print(_ items: Any..., separator: String = " ", terminator: String = "\n")
```

> * 콘솔 출력을 위해 print(_:separator:terminator:) 함수를 제공한다. 
> * 함수 선언에서 볼 수 있듯이 여러 파라미터를 받을 수 있고 각 파라미터를 순서대로 출력한다.
> * 출력된 각 파라미터들 사이에는 separator를 출력하고 마지막 파라미터 다음에는 terminator를 출력한다.

```swift
let num = 3

print("Hello World!")
// Hello World!

print("The answer is \(num).")
// The answer is 3.\n

print("The answer is \(num * 2).")
// The answer is 6.\n

print("one", "two", "three", separator: ", ")
// one, two, three\n

print("Ends without new line.", terminator: "")
// Ends without new line.

print("one", "two", "three", separator: ", ", terminator: "!")
// one, two, three!
```

> * separator, terminator는 각각 default 값이 있으므로 생략할 수 있다.
> * Swift는 문자열 중간에 `\(expression)` 형태로 expression을 삽입할 수 있다.
> * C언어의 `printf()` 같은 함수는 없으며 꼭 필요한 경우 `String(format:_:)` 생성자를 이용해서 formatting을 수행한 후 출력한다.
