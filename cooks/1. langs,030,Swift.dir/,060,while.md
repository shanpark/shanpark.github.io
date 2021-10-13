## while

---

### 1. while

```swift
var inx = 0
while inx < 10 {
    print(inx)
    inx += 1
}
```

> * 참고로 Swift는 버전 3부터 `++`, `--` 연산자가 없다.

### 2. repeat while

```swift
var inx = 0
repeat {
    print(inx)
    inx += 1
} while (inx < 10)
```

> * Swift는 대부분의 언어와 달리 `do`-`while이` 아니라 `repeat`-`while`이다. 