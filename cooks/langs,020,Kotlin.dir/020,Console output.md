## Console output

---

많은 print 함수들이 내장되어 있지만 다음 함수가 가장 많이 사용된다.

### 1. println()

```kotlin
val num = 3

println("Hello World!") // "Hello World!\n"
println("The answer is $num.") // "The answer is 3.\n"
println("The answer is ${num * 2}.") // "The answer is 6.\n"
```

> * Kotlin은 문자열에 `$name`, `${expression}` 형태로 값을 삽입할 수 있다. 
> * C언어의 `printf()` 같은 함수는 없으며 꼭 필요한 경우 `String.format()` 메소드를 이용하여 formatting을 수행한 후 출력한다.
