## Type system

---

### 1. Primitive types

```kotlin
var ch: Char // unicode point '\u0000'

var by: Byte // 1 byte signed
var sh: Short // 2 byte signed
var i: Int // 4 byte signed
var l: Long // 8 byte signed

var uby: UByte // 1 byte unsigned
var ush: UShort // 2 byte unsigned
var ui: UInt // 4 byte unsigned
var ul: ULong // 8 byte unsigned

var f: Float // 4 byte floating point
var d: Double // 8 byte floating point

var b: Boolean // true, false

var str: String // string
```

> * 위 예시는 모두 Nullable하지 않은 타입이며 반드시 초기값이 지정되어야 하지만 설명을 위해 생략하였다. 
> * 타입 뒤에 ?를 붙이면 Nullable 타입이 된다.
> * Java와 달리 모두 Reference 타입이기 때문에 Wrapper 클래스는 제공되지 않으며 필요도 없다.
> * Java와 달리 unsigned integer 타입이 제공된다.

### 2. Primitive type arrays

```kotlin
var cha: CharArray = charArrayOf('A', 'B')

var bya: ByteArray = byteArrayOf(1, 2)
var sha: ShortArray = shortArrayOf(1, 2)
var ia: IntArray = intArrayOf(1, 2)
var la: LongArray = longArrayOf(1, 2)

var ubya: UByteArray = ubyteArrayOf(1u, 2u)
var usha: UShortArray = ushortArrayOf(1u, 2u)
var uia: UIntArray = uintArrayOf(1u, 2u)
var ula: ULongArray = ulongArrayOf(1u, 2u)

var fa: FloatArray = floatArrayOf(1.0f, 3.0f)
var da: DoubleArray = doubleArrayOf(1.0, 2.0)

var ba: BooleanArray = booleanArrayOf(true, false)

val stra: Array<String> = arrayOf("foo", "bar") // String은 일반 클래스의 array를 이용한다.
```

> * Kotlin에서 Array는 Generic class인 `Array<T>` 형태로 제공되지만 Primitive type에 대해서는 위의 클래스들을 이용하도록 한다.
> * Unsigned 타입들에 대한 Array 클래스들은 아직 실험단계로 제공되고 있으며 `@OptIn(ExperimentalUnsignedTypes::class)` annotation을 지정해야 경고가 사라진다.

### 3. Collections

#### Array

```kotlin
val iarr: IntArray = intArrayOf(100, 200)
iarr[0] = 110
println("first element: ${iarr[0]}") // first element: 110

val arr: Array<String> = arrayOf("foo", "bar")
arr[0] = "baz"
println("size: ${arr.size}") // size: 2
```

> * 모든 `Array` 타입은 생성될 때 그 크기가 지정되며 한 번 생성되면 바꿀 수 없다.
> * Mutable 타입이 따로 없고 크기는 불변이지만 각 원소는 Read / Write가 가능하다.
> * Kotlin의 모든 Collection 들은 그 크기를 `size` 속성을 통해서 알 수 있다.

#### List

```kotlin
val iList: List<Int> = listOf(100, 200)
println("size: ${iList.size}") // size: 2

val imList: MutableList<Int> = mutableListOf(100, 200)

imList[0] = 110
println("first element: ${imList[0]}") // first element: 110

imList.add(300)
println("size: ${imList.size}") // size: 3
```

> * Kotlin에서 `List`는 kotlin.collections 패키지의 interface일 뿐이며 listOf() 함수를 통해서 기본 구현체를 생성한다.
> * `List`는 기본적으로 immutable 이며 변경이 가능한 `MutableList` 타입이 따로 존재한다.

#### Map

```kotlin
val map1: Map<String, String> = mapOf("one" to "foo", "two" to "bar")
val map2: Map<String, String> = mapOf(Pair("one", "foo"), Pair("two", "bar"))

val mmap: MutableMap<String, String> = mutableMapOf(Pair("one", "foo"), Pair("two", "bar"))
mmap["three"] = "baz" // == mmap.put("three", "baz")
println("size: ${mmap.size}") // size: 3
println("mmap[three]: ${mmap["three"]}") // mmap[three]: baz
```

> * Kotlin에서 `Map`은 kotlin.collections 패키지의 interface일 뿐이며 mapOf() 함수를 통해서 기본 구현체를 생성한다.
> * `Map`은 기본적으로 immutable 이며 변경이 가능한 `MutableMap` 타입이 따로 존재한다.

#### Set

```kotlin
val set: Set<String> = setOf("foo", "bar")

val mset: MutableSet<String> = mutableSetOf("foo", "bar")
mset.add("baz")
println("size: ${mset.size}") // size: 3
```

> * Kotlin에서 `Set`은 kotlin.collections 패키지의 interface일 뿐이며 setOf() 함수를 통해서 기본 구현체를 생성한다.
> * `Set`은 기본적으로 immutable 이며 변경이 가능한 `MutableSet` 타입이 따로 존재한다.
