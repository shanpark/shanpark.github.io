# JAVA

## Type system

### 1. Primitive types

```java
char ch; // 2 byte unicode point (\u0000 ~ \uffff)

byte by; // 1 byte signed
short sh; // 2 byte signed
int i; // 4 byte signed
long l; // 8 byte signed

float f; // 4 byte floating point
double d; // 8 byte floating point

boolean b; // true, false
```

> ❗ Java는 unsigned integer 타입이 없다.

### 2. Wrapper class

```java
Character ch;

Byte by;
Short sh;
Integer i;
Long l;

Float f;
Double d;

Boolean b;
```

> ❗ Java는 Primitive type이외의 모든 타입은 Reference type이다. 따라서 Wrapper class들도 대응되는 Primitive type들과 자연스러운 상호 변환이 이루어지는 특성이 있지만 `null`을 담을 수 있다는 장점이 있다.

### 3. Collections

#### Array

```java
String[] arr1 = {"foo", "bar"};

String[] arr2 = new String[2];
arr2[0] = "foo";
arr2[1] = "bar";

System.out.println(arr2.length); // 2
```
> ❗Array의 길이는 `length` 속성을 이용한다. 이하 다른 Collection 타입들의 경우 `size()` 메소드를 이용한다.

#### List

```java
List<String> list1 = Arrays.asList("foo", "bar");

List<String> list2 = List.of("foo", "bar"); // Java 9

List<String> list3 = new ArrayList<>();
list3.add("foo");
list3.add("bar");

System.out.println(list1.size()); // 2
```

> ❗ Java에서 `List`는 java.util 패키지의 interface일 뿐이며 위 예에서는 `ArrayList`를 구현체로 사용하고 있다.

#### Map

```java
Map<String, Integer> map1 = Map.of("one",1, "two", 2); // Java 9

Map<String, Integer> map2 = new HashMap<>();
map2.put("one", 1);
map2.put("two", 2);

System.out.println(map2.size()); // 2
```

> ❗ Java에서 `Map`은 java.util 패키지의 interface일 뿐이며 위 예에서는 `HashMap`을 구현체로 사용하고 있다.

#### Set

```java
Set<String> set1 = new HashSet<>(Arrays.asList("foo", "bar"));

Set<String> set2 = Set.of("foo", "bar"); // Java 9

Set<String> set3 = new HashSet<>();
set3.add("foo");
set3.add("bar");

System.out.println(set3.size()); // 2
```

> ❗ Java에서 `Set`은 java.util 패키지의 interface일 뿐이며 위 예에서는 `HashSet`을 구현체로 사용하고 있다.
