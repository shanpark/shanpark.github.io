## Functions

---

### 1. Funcions

```kotlin
fun add(x: Int, y:Int): Int {
    return x + y
}
```

```kotlin
fun read(
    b: ByteArray,
    off: Int = 0,
    len: Int = b.size, // trailing comma
) { /*...*/ }

fun foo(
    bar: Int = 0,
    baz: Int,
) { /*...*/ }

foo(baz = 1) // named argument
```

> * parameter에 default value를 지정할 수 있다.
> * 마지막 parameter의 뒤에 *trailing comma*를 지원한다.
> * 호출할 때 앞쪽의 parameter에 default value가 있어서 그 parameter를 생략하려면 그 뒤의 parameter는 *named argument* 방식으로 호출해야 한다.
> * 모든 parameter는 *named argument*로 값을 전달할 수 있다.

```kotlin
fun foo(
    bar: Int = 0,
    qux: () -> Unit,
) { /*...*/ }

foo(1) { println("hello") }
```

> * 마지막 parameter가 lambda인 경우 괄호 바깥으로 빼서 뒤에 전달할 수 있다.

```kotlin
fun printHello(name: String?): Unit {
    if (name != null)
        println("Hello $name")
    else
        println("Hi there!")
    // `return Unit` or `return` is optional
}
```

> * return 값이 없는 함수는 `Unit` 타입으로 지정하거나 return type을 지정하지 않는다. (':'도 같이 생략)

```kotlin
fun add(x: Int, y:Int): Int =>  x + y
fun add2(x: Int, y:Int) =>  x + y
```

> * 하나의  expression으로 이루어진 함수는 이런 식으로 정의할 수 있으며 expression의 타입에 따라 return type도 추론 가능한 경우 return type을 생략할 수도 있다.

```kotlin
fun <T> asList(vararg ts: T): List<T> {
    val result = ArrayList<T>()
    for (t in ts) // ts is an Array
        result.add(t)
    return result
}
```

> * parameter의 갯수가 일정하지 않은 경우 `vararg` 키워드를 parameter의 앞에 붙여주면 된다.
> * 한 함수에 두 개 이상의 `vararg` parameter는 불가하다.
> * 일반적으로 `vararg` parameter는 마지막 parameter인 경우가 많지만 반드시 마지막에 두어야 하는 것은 아니다.

```kotlin
infix fun Int.shl(x: Int): Int { ... }

1 shl 2
1.shl(2) // same!
```

> * 클래스의 메소드를 선언할 때 `infix`로 선언하는 경우 호출할 때 '.'과 괄호를 생략하여 호출할 수 있다.
> * 반드시 메소드의 parameter는 한 개여야 한다.

```kotlin
fun <T> someFunc(item: T): List<T> { 
    /*...*/
}

var l = someFunc<Int>(1)
var n = someFunc(1)
```

> * Generic 함수 선언은 위와 같다.
> * 타입 추론이 가능한 경우 Generic의 타입은 생략할 수 있다.

```kotlin
val eps = 1E-10 // "good enough", could be 10^-15

tailrec fun findFixPoint(x: Double = 1.0): Double =
    if (Math.abs(x - Math.cos(x)) < eps) x else findFixPoint(Math.cos(x))
```

> * 재귀 호출을 구현한 함수를 `tailrec` modifier 붙여주면 컴파일러가 stack overflow 걱정없는 loop 형태로 최적화를 해준다.
> * 함수가 자신에 대한 호출을 결과값으로 사용하는 경우에 효율적 변환이 가능하며 그렇지 않은 경우 별로 효과가 없을 수 있다. 
> * `try` / `catch` / `finally` 블록 안에서는 사용할 수 없다.
