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

> * 일반적으로 문자열에 `$name`, `${expression}` 형태로 값을 삽입하여 출력하기 때문에 따로 Java의 `System.out.format()` 같은 함수는 없다. 그럼에도 불구하고 출력되는 값의 format을 지정해야 하는 경우에는 `String.format()` 메소드를 이용하여 format된 문자열을 `println()`으로 출력한다.
