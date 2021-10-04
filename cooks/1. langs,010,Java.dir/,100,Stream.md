## Stream

---

### 1. Stream creating

#### Basics

Java collection으로부터 stream을 얻는 방법은 다음과 같다.
* `stream()` - 각 원소들을 순차적으로 처리하는 일반적인 stream을 생성한다.
* `parallelStream()` - 병렬 처리를 수행하는 stream을 생성한다. 따라서 각 원소에 대한 연산이 독립적일수록 효과적으로 사용할 수 있다.

```java
public class Main {
    public static void log(Object x) {
        System.out.format("%s \t| %s\n", Thread.currentThread().getName(), x.toString());
    }

    public static void main(String[] args) throws Exception {
        List<String> strings = Arrays.asList("abc", "", "bc", "efg", "abcd","", "jkl");

        strings.stream()
                .filter(string -> !string.isEmpty())
                .forEach(Main::log);

        System.out.println("----------------------------------------");

        strings.parallelStream()
                .filter(string -> !string.isEmpty())
                .forEach(Main::log);
    }
}
```

```
main 	| abc
main 	| bc
main 	| efg
main 	| abcd
main 	| jkl
----------------------------------------
ForkJoinPool.commonPool-worker-2 	| abc
ForkJoinPool.commonPool-worker-2 	| efg
ForkJoinPool.commonPool-worker-3 	| jkl
main 	| abcd
ForkJoinPool.commonPool-worker-1 	| bc
```

> * `stream()`으로 생성된 stream은 main 스레드에서 순차적으로 실행되었다.
> * `parallelStream()`으로 생성된 stream은 main 스레드를 포함하여 여러 스레드에서 실행되는 걸 볼 수 있다.

#### Useful creating methods

stream을 생성하는 방법은 매우 많다. 그 중에 유용하게 사용할 만한 것들을 아래 소개한다.

* **Stream.empty()** - 빈 stream을 생성
* **Stream.of()** - 파라미터로 받은 값들의 stream을 생성.
* **Arrays.stream()** - 파라미터로 받은 array의 stream을 생성. 일부분만을 stream으로 생성하는 overload 함수 제공.
* **Stream.<T>builder()** - 정확히 얘기 하자면 stream을 생성하는 builder를 생성한다. 반환된 builder의 build() 메소드를 호출하면 최종 생성된 stream이 반환된다.
* **Stream.generate()** - 파라미터로 전달된 Supplier<T> 객체를 통해서 무한 stream을 생성한다. 
* **Stream.iterate()** - seed값과 반복 함수를 받아서 무한 stream을 생성한다. 첫 번째 원소는 seed 값이 된다.
* ***Primitive*Stream.range()** - IntStream, LongStream 같은 정수형 Primitive stream 객체들의 range() 메소드를 이용하여 특정 구간의 stream을 생성할 수 있다. 비숫한 기능의 다른 메소드가 더 있으므로 문서 참조.
* **ints(), longs(), doubles()** of Random - Random 객체의 ints(), longs(), doubles() 메소드는 각각 IntStream, LongStream, DoubleStream을 생성한다. 여러가지 overload 메소드가 있으므로 문서 참조.
* **splitAsStream()** of Pattern - Pattern 객체의 splitAsStream() 메소드는 패턴으로 문자열을 분리하여 stream으로 변환한다.
* **Files.lines()** - 파라미터로 주어진 path의 파일 내용을 line단위로 분리하여 stream을 생성한다.
* **Stream.concat()** - 파라미터로 받은 2개의 stream을 이어붙인 stream을 반환한다.

```java
Stream<String> stream0 = Stream.empty();

Stream<String> stream1 = Stream.of("ab", "bc", "cd");

String[] arr = {"ab", "bc", "cd"};
Stream<String> stream2 = Arrays.stream(arr);

Stream<String> stream3 = Stream.<String>builder()
    .add("ab")
    .add("bc")
    .add("cd")
    .build();

Stream<String> stream4 = Stream.generate(() -> "value"); // "value", "value", ...

Stream<Integer> stream5 = Stream.iterate(1, n -> n + 1); // 1, 2, 3, ...

IntStream stream6 = IntStream.range(1, 5);

Random random = new Random();
DoubleStream doubleStream = random.doubles(3);

Stream<String> stream7 = Pattern.compile(", ").splitAsStream("a, b, c");

Path path = Paths.get("C:\\data.txt");
Stream<String> stream8 = Files.lines(path, StandardCharsets.UTF_8);
```

> * 단순한 형태의 생성 예제들만 소개했지만 overload 메소드가 많이 제공되므로 적절한 다른 overload 메소드가 있는지 검토를 해보는 게 좋다.

### 2. Stream intermediate operations

#### filtering

filtering 메소드들은 특정 조건에 맞는 원소로만 이루어진 stream을 반환한다. 조건에 맞지 않는 원소는 버린다.

* filter() - 파라미터로 전달된 조건(Predicate)에 맞는 원소만 남긴다.
* distinct() - 이미 포함된 원소와 중복된 원소를 버린다.
* skip() - 지정된 수만큼을 버리고 나머지 원소만 남긴다.
* limit() - 지정된 수만큼의 원소만 남기고 나머지는 버린다.

```java
// Stream<String> stream = Stream.of("ab", "bc", "cd", "ab");

stream1.filter(val -> !val.equals("bc")) // ["ab", "cd", "ab"]
stream2.distinct() // ["ab", "bc", "cd"]
stream3.skip(2) // ["cd", "ab"]
stream4.limit(2) // ["ab", "bc"]
```

#### mapping

* map() - 각 원소에 파람미터로 받은 함수 객체를 적용하여 반환된 값으로 이루진 stream을 반환한다.
* mapTo*Primitive*() - int, long, double 타입으로 변환하는 함수를 파라미터로 받아서 각 원소를 변환하여 변환된 값으로 이루어진 *Primitive*Stream을 반환한다.
* flatMap() - stream의 원소를 받아서 stream으로 변환하는 함수를 파라미터로 받아서 각 원소를 stream으로 변환 한 후 각 stream의 원소들로 이루어진 stream을 반환한다. 즉, 함수가 반환하는 stream을 이어붙인 stream이라고 생각하면 간단하다.
* flatMapTo*Primitive*() - 각 원소를 *Primitive*Stream으로 변환하는 함수를 받는 다는 것이 다를 뿐 flatMap()과 같은 동작을 한다. 반환되는 stream도 *Primitive*Stream이다.

```java
Stream<Integer> stream = Stream.of(1, 2, 3);
Stream<String> stream2 = stream.map(Object::toString); // ["1", "2", "3"]
IntStream stream3 = stream2.mapToInt(Integer::parseInt); // [1, 2, 3]
```

```java
Stream<String> stream = Stream.of("1,2", "3,4");
Stream<String> stream2 = stream.flatMap(
    val -> Arrays.stream(val.split(",")) // ["1", "2"], ["3", "4"]
); // ["1", "2", "3", "4"]

Stream<String> stream3 = Stream.of("1,2", "3,4");
IntStream stream4 = stream3.flatMapToInt( 
    val -> // IntStream을 반환하는 lambda
        Arrays.stream(val.split(",")) // ["1", "2"], ["3", "4"]
            .mapToInt(Integer::parseInt) // [1, 2], [3, 4]
); // [1, 2, 3, 4]
```

#### etc

* sorted() - 원소들을 순서대로 정렬한 stream을 반환한다. 우선적으로 전체 값이 생성되어야 정렬이 가능하므로
무한 stream을 대상으로 실행될 수는 없다.
* peek() - 현재 stream을 그대로 반환한다. 하지만 각 원소에 대해서 파라미터로 받은 action(Consumer)을 수행한다.
forEach()와 확연히 다른 점은 peek()는 terminal operaion이 아니라는 것이다. 따라서 다른 terminal operation이 수행될 때 까지 수행되지 않는다.(lazy)

```java
Stream<Integer> stream = Stream.of(2, 3, 1);
stream.sorted() // [1, 2, 3]. sorted
    .peek(val -> System.out.println(val)) // perform action
    .count(); // 3. terminal operation
```

### 3. Stream terminal operations

* **forEach()** - 각 원소에 대해서 파라미터로 받은 action(Consumer)을 수행한다.
* **min()**, **max()** - stream에서 최소, 최대 값(Optional)을 반환한다. 원소가 없는 경우 empty optional을 반환한다.
* **count()** - stream의 원소의 갯수를 반환한다.
* **anyMatch()**, **allMatch()**, **noneMatch()** - 조건에 맞는 값이 하나라도 있으면, 모든 원소가 조건에 맞으면, 조건에 맞는 원소가 하나도 없으면 true를 반환한다. 원소가 하나도 없는 경우 `allMatch()`, `noneMatch()`는 true, `anyMatch()`는 false이다.
* **findFirst()**, **findAny()** - `findFirst()`는 stream에서 첫 번째 원소(Optional)를 반환, `findAny()`는 순서에 상관없이 stream의 원소 하나(Optional)를 반환한다. findAny()는 병렬 처리 중일 때 의미가 있다. 원소가 없는 경우 empty optional을 반환한다.
* **reduce()** - 이전 단계의 accumulator가 반환한 값과 현재 값으로 다시 accumulator를 적용하는 작업을 반복하여 최종 값을 생성하여 반환한다. 원소가 없는 경우 empty optional을 반환한다.
* **collect()** - 파라미터로 받은 collector를 사용하여 stream의 원소들을 담은 Collection 객체를 생성하여 반환한다.
* **toArray()** - stream을 array로 변환하여 반환한다. Object[]와 T[]를 생성하는 두 가지 overload 메소드가 제공된다.

```java
Stream<String> stream = Stream.of("a", "b", "c");

stream.forEach(System.out::println); // 1, 2, 3
System.out.println(stream.min(String::compareTo)); // Optional[a]
System.out.println(stream.count()); // 3
System.out.println(stream.anyMatch(val -> val.equals("b"))); // true
System.out.println(stream.findFirst()); // Optional[a]
System.out.println(stream.reduce((a, b) -> a + b)); // Optional[abc]

List<String> list = stream.collect(Collectors.toList());

Object[] objArr = stream.toArray();
String[] strArr = stream.toArray(String[]::new);
```

> * 위 코드는 예제일 뿐이며 stream은 한 번 사용되면 다시 사용될 수 없다. 따라서 위 문장들을 테스트하려면 실행문중 하나만 제외하고 모두 주석처리 하여 하나씩 테스트해봐야 한다.