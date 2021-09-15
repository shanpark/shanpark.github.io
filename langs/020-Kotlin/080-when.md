## when

---

### 1. when

Kotlin의 `when`은 다른 언어의 switch와 비슷한 기능을 하지만 매우 간결하며 독특하고 다양한 기능을 제공한다.

```kotlin
var s = "5"
val x = 2

when (x) {
    1 -> println("x == 1")
    2 -> println("x == 2")
    3, 4 -> {
        println("x == 3")
        println("x == 4")
    }
    s.toInt() -> println("x == 5")
    in 6..10 -> println("x is in [6, 10]")
    !in 11..20 -> println("x is not in [11, 20]")
    else -> println("none")
}
```

> * 다른 언어의 switch와 달리 `break` 문은 필요없다.

```kotlin
var a = 3
var b = 5

when { // no argument
    a > b -> println("a > b")
    a < b -> println("a < b")
    else -> println("same")
}
```

> * argument 없이 사용하면 `if` ~ `else` 문을 대체하는 용도로 사용할 수 있다.

```kotlin
var comp = when { // no argument
    a > b -> 1
    a < b -> -1
    else -> 0
}
```

> * `when`도 `if`와 마찬가지로 expression이다. 따라서 항상 평가되어 결과값을 반환한다.

```kotlin
var i: Any = 1

when (i) {
    is Int -> println("Int")
    is String -> println("String")
    else -> println("Some")
}
```

> * `is` 연산자와 함께 타입 체크 로직을 구현할 수 있다.

```
fun Request.getBody() =
    when (val response = executeRequest()) {
        is Success -> response.body
        is HttpError -> throw HttpException(response.status)
    }
```

> * `when`문 범위 안에서 유효한 임시 변수를 선언하여 함수(`executeRequest()`)의 결과를 캡쳐해서 사용하는 것도 가능하다.

### 2. switch (Enum)

```kotlin
enum class Num {
    ONE, TWO, THREE
}

...

var num = Num.ONE;
when (num) {
    Num.ONE -> println("one")
    Num.TWO -> println("two")
    else -> println("else")
}
```

> * `when`에서 enum 타입을 사용할 때는 모든 enum 값을 처리하지 않으면 경고를 발생시킨다.
