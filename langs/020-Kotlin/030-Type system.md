# Kotlin

## Type system

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
```

> ❗위 예시는 모두 Nullable하지 않은 타입이며 반드시 초기값이 지정되어야 하지만 설명을 위해 생략하였다. 

> ❗타입 뒤에 ?를 붙이면 Nullable 타입이 된다.

> ❗Java와 달리 unsigned integer 타입이 제공된다.

### 2. Primitive array types

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
```

> ❗ Kotlin에서 Array는 Generic class인 `Array<T>` 형태로 제공되지만 Primitive type에 대해서는 위의 클래스들을 이용하도록 한다.

> ❗Unsigned 타입들에 대한 Array 클래스들은 아직 실험단계로 제공되고 있으며 `@OptIn(ExperimentalUnsignedTypes::class)` annotation을 지정해야 경고가 사라진다.

### 3. Collections

#### Array

```kotlin
String[] arr1 = {"foo", "bar"};

String[] arr2 = new String[2];
arr2[0] = "foo";
arr2[1] = "bar";

System.out.println(arr2.length); // 2
```
> ❗Array의 길이는 `length` 속성을 이용한다. 이하 다른 Collection 타입들의 경우 `size()` 메소드를 이용한다.

#### List

```kotlin
List<String> list1 = Arrays.asList("foo", "bar");

List<String> list2 = List.of("foo", "bar"); // Java 9

List<String> list3 = new ArrayList<>();
list3.add("foo");
list3.add("bar");

System.out.println(list1.size()); // 2
```

> ❗ Java에서 `List`는 java.util 패키지의 interface일 뿐이며 위 예에서는 `ArrayList`를 구현체로 사용하고 있다.

#### Map

```kotlin
Map<String, Integer> map1 = Map.of("one",1, "two", 2); // Java 9

Map<String, Integer> map2 = new HashMap<>();
map2.put("one", 1);
map2.put("two", 2);

System.out.println(map2.size()); // 2
```

> ❗ Java에서 `Map`은 java.util 패키지의 interface일 뿐이며 위 예에서는 `HashMap`을 구현체로 사용하고 있다.

#### Set

```kotlin
Set<String> set1 = new HashSet<>(Arrays.asList("foo", "bar"));

Set<String> set2 = Set.of("foo", "bar"); // Java 9

Set<String> set3 = new HashSet<>();
set3.add("foo");
set3.add("bar");

System.out.println(set3.size()); // 2
```

> ❗ Java에서 `Set`은 java.util 패키지의 interface일 뿐이며 위 예에서는 `HashSet`을 구현체로 사용하고 있다.
