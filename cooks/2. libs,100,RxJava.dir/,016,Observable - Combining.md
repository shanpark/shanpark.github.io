## Observable - combine

여기서 소개되는 메소드는 2개 이상의 observable 객체를 결합해서 새로운 observable 객체를 생성한다.
대체로 다른 생성 관련 메소드처럼 정적 메소드들이다. 하지만 자기 자신과 다른 observable 객체를 결합하는
메소드들도 있으면 그런 경우에는 물론 정적 메소드가 아니다.

### 1. Observable.zip()

2개 이상의 observable 객체로부터 값을 하나씩 받아서 `zipper` 함수를 적용하여 반환된 값을 발행하는 observable 객체를 생성한다.
source observable 객체중에 하나라도 값을 발행하지 않은 상태이면 발행될 때 까지 대기한다.

#### Prototype

```java
public static Observable<R> zip(
    ObservableSource<T1> source1,
    ObservableSource<T2> source2, 
    BiFunction<T1, T2, R> zipper
)
```

#### Example

```java
log("current");

Observable<Long> src1 = Observable.interval(100, TimeUnit.MILLISECONDS).take(5);
Observable<String> src2 = Observable.just("A", "B", "C", "D", "E");

Observable.zip(src1, src2, (s1, s2) -> s1 + ":" + s2)
    .subscribe(Main::log);
```

```
[main]	: current
[RxComputationThreadPool-1]	: 0:A
[RxComputationThreadPool-1]	: 1:B
[RxComputationThreadPool-1]	: 2:C
[RxComputationThreadPool-1]	: 3:D
[RxComputationThreadPool-1]	: 4:E
```

> * 파라미터로 전달된 2개의 source에서 모두 값이 발행되어야 `zipper`를 적용해서 값을 생성하고 발행한다. 즉 양쪽에서 zipper 함수에 전달할 값을 하나씩 발행해야 값을 생성, 발행한다.
> * 최대 9개까지 결합할 수 있는 overload 메소드들이 준비되어있다.
> * `zip()`은 단순히 여러 source observable 객체로부터 값을 받아서 발행하므로 실행되는 scheduler는 파라미터로 받은 observable 객체에 따라 결정된다.
src1이 `interval()`로 생성되었으므로 `interval()`의 기본 scheduler인 `COMPUTATION`에서 실행되는 걸 볼 수 있다.

### 2. zipWith()

자기 자신과 파라미터로 받은 observable 객체를 대상으로 zip연산을 수행한다. 

#### Prototype

```java
public final Observable<R> zipWith(Iterable<U> other, BiFunction<T, U, R> zipper)
```

#### Example

```java
log("current");

Observable<Long> other = Observable.interval(100, TimeUnit.MILLISECONDS).take(5);
Observable.just("A", "B", "C", "D", "E")
    .zipWith(other, (s1, s2) -> s1 + ":" + s2)
    .subscribe(Main::log);
```

```
[main]	| current
[RxComputationThreadPool-1]	| A:0
[RxComputationThreadPool-1]	| B:1
[RxComputationThreadPool-1]	| C:2
[RxComputationThreadPool-1]	| D:3
[RxComputationThreadPool-1]	| E:4
```

> * 자신이 발행하는 값과 파라미터로 전달된 observable 객체에서 모두 값이 발행되어야 `zipper`를 적용해서 값을 생성하고 발행한다. `zip()` 메소드와 같다.
> * 어떤 scheduler에서 실행될 지는 자기 자신과 파라메터로 전달된 observable 객체에 따라 결정된다.

### 3. Observable.combineLatest()

최초에 source들이 모두 하나 이상의 값을 발행할 때 까지 기다리는 건 zip과 같지만 그 이후부터는 어느 source에서든 값이 발행되면
각 source의 최근 값으로 `combiner` 함수를 적용하여 반환된 값을 발행하는 observable 객체를 생성한다.

#### Prototype

```java
public static Observable<R> combineLatest(
    ObservableSource<T1> source1,
    ObservableSource<T2> source2,
    BiFunction<T1, T2, R> combiner
)
```

#### Example

```java
log("current");

Observable<Long> src1 = Observable.interval(100, TimeUnit.MILLISECONDS).take(5);
Observable<String> src2 = Observable.interval(50, TimeUnit.MILLISECONDS).take(5)
    .map(inx -> "ABCDEF".substring(inx.intValue(), inx.intValue()+1));

Observable.combineLatest(src1, src2, (s1, s2) -> s1 + ":" + s2)
    .subscribe(Main::log);
```

```
[main]	: current
[RxComputationThreadPool-1]	: 0:B
[RxComputationThreadPool-1]	: 0:C
[RxComputationThreadPool-2]	: 0:D
[RxComputationThreadPool-1]	: 1:D
[RxComputationThreadPool-1]	: 1:E
[RxComputationThreadPool-1]	: 2:E
[RxComputationThreadPool-1]	: 3:E
[RxComputationThreadPool-1]	: 4:E
```

> * 파라미터로 전달된 2개의 source에서 모두 값이 발행되면 그 때부터는 어느 쪽이든 값이 발행되면 바로 각 source의 최근값으로 `combiner`를 호출하여 값을 생성, 발행한다.
> * 최대 9개까지 결합할 수 있는 overload 메소드들이 준비되어있다.
> * `combineLatest()`도 `zip()`처럼 여러 source observable 객체로부터 값을 받아서 발행하므로 실행되는 scheduler는 파라미터로 받은 observable 객체에 따라 결정된다.
src1, src2 모두 `interval()`로 생성되었으므로 `interval()`의 기본 scheduler인 `COMPUTATION`에서 실행되는 걸 볼 수 있다.

### 4. Observable.merge()

가장 단순한 형태의 결합 메소드다. 여러 source들로부터 발행되는 값을 아무런 변환없이 그대로 발행하는 observable 객체를 생성한다.
하나의 observable 객체를 통해서 발행되므로 source들은 서로 호환 가능한 타입이어야 한다.

#### Prototype

```java
public static Observable<T> merge(ObservableSource<T> source1, ObservableSource<T> source2)
```

#### Example

```java
log("current");

Observable<Long> src1 = Observable.interval(0L, 100L, TimeUnit.MILLISECONDS)
    .map(val -> val * 2).take(3);
Observable<Long> src2 = Observable.interval(50L, 100L, TimeUnit.MILLISECONDS)
    .map(val -> (val * 2) + 1).take(3);

Observable.merge(src1, src2)
    .subscribe(Main::log);
```

```
[main]	: current
[RxComputationThreadPool-1]	: 0
[RxComputationThreadPool-2]	: 1
[RxComputationThreadPool-1]	: 2
[RxComputationThreadPool-2]	: 3
[RxComputationThreadPool-1]	: 4
[RxComputationThreadPool-2]	: 5
```

> * 각 source로부터 발행되는 값을 함께 결합하거나 변환하는 작업이 없으므로 어느 쪽이든 수신 즉시 그대로 발행한다.
> * 최대 9개까지 결합할 수 있는 overload 메소드들이 준비되어있다.
> * `merge()`도 `zip()`처럼 여러 source observable 객체로부터 값을 받아서 발행하므로 실행되는 scheduler는 파라미터로 받은 observable 객체에 따라 결정된다.
src1, src2 모두 `interval()`로 생성되었으므로 `interval()`의 기본 scheduler인 `COMPUTATION`에서 실행되는 걸 볼 수 있다.

### 5. mergeWith()

자기 자신과 파라미터로 받은 observable 객체를 대상으로 `merge()` 연산을 수행한다.
하나의 observable 객체를 통해서 발행되므로 서로 호환 가능한 타입이어야 한다.

#### Prototype

```java
public final Observable<T> mergeWith(ObservableSource<T> other)
```

#### Example

```java
log("current");

Observable<Long> other = Observable.interval(0L, 100L, TimeUnit.MILLISECONDS)
    .map(val -> val * 2).take(3);
Observable<Long> self = Observable.interval(50L, 100L, TimeUnit.MILLISECONDS)
    .map(val -> (val * 2) + 1).take(3);

self.mergeWith(other)
    .subscribe(Main::log);
```

```
[main]	| current
[RxComputationThreadPool-2]	| 0
[RxComputationThreadPool-1]	| 1
[RxComputationThreadPool-2]	| 2
[RxComputationThreadPool-1]	| 3
[RxComputationThreadPool-2]	| 4
[RxComputationThreadPool-1]	| 5
```

> * 각 source로부터 발행되는 값을 함께 결합하거나 변환하는 작업이 없으므로 어느 쪽이든 수신 즉시 그대로 발행한다.
> * `merge()`와 마찬가지로 자신과 파라미터로 받은 observable 객체에 의해 기본 scheduler가 결정된다.

### 6. Observable.concat()

파라메터로 받은 source들을 순서대로 이어붙인 observable객체를 반환한다.
앞에 나오는 source의 `onComplete`가 발생해야 그 다음 source의 발행이 시작된다.

참고로 `concatMap()`은 자신이 발행하는 값으로 여러 observable 객체를 생성한 후 모두 이어 붙인 observable 객체를 반환하지만
`concat()`은 파라미터로 받은 observable 객체를 이어 붙인 observable 객체를 생성한다.

#### Prototype

```java
public static Observable<T> concat(ObservableSource<T> source1, ObservableSource<T> source2)
```

#### Example

```java
log("current");

Observable<Long> src1 = Observable.interval(0L, 100L, TimeUnit.MILLISECONDS)
    .map(val -> val * 2).take(3);
Observable<Long> src2 = Observable.interval(50L, 100L, TimeUnit.MILLISECONDS)
    .map(val -> (val * 2) + 1).take(3);

Observable.concat(src1, src2)
    .subscribe(Main::log);
```

```
[main]	: current
[RxComputationThreadPool-1]	: 0
[RxComputationThreadPool-1]	: 2
[RxComputationThreadPool-1]	: 4
[RxComputationThreadPool-2]	: 1
[RxComputationThreadPool-2]	: 3
[RxComputationThreadPool-2]	: 5
```

> * 앞쪽의 source부터 차례대로 발행 작업을 수행한다. 앞의 source가 끝나야 다음 source가 시작된다.
> * 최대 9개까지 결합할 수 있는 overload 메소드들이 준비되어있다.
> * `concat()`도 `zip()`처럼 여러 source observable 객체로부터 값을 받아서 발행하므로 실행되는 scheduler는 파라미터로 받은 observable 객체에 의해 결정된다.
src1, src2 모두 `interval()`로 생성되었으므로 `interval()`의 기본 scheduler인 `COMPUTATION`에서 실행되는 걸 볼 수 있다.

### 7. concatWith()

자기 자신의 뒤에 파라메터로 받은 observable 객체를 이어붙인 observable객체를 반환한다. `concat()`과 같은 방식으로 동작한다.
자기 자신의 발행이 끝나야(`onComplete`) 그 다음 파라미터로 받는 observable 객체의 발행이 시작된다.

#### Prototype

```java
public final Observable<T> concatWith(ObservableSource<T> other)
```

#### Example

```java
log("current");

Observable<Long> other = Observable.interval(0L, 100L, TimeUnit.MILLISECONDS)
    .map(val -> val * 2).take(3);
Observable<Long> self = Observable.interval(50L, 100L, TimeUnit.MILLISECONDS)
    .map(val -> (val * 2) + 1).take(3);

self.concatWith(other)
    .subscribe(Main::log);
```

```
[main]	| current
[RxComputationThreadPool-1]	| 1
[RxComputationThreadPool-1]	| 3
[RxComputationThreadPool-1]	| 5
[RxComputationThreadPool-2]	| 0
[RxComputationThreadPool-2]	| 2
[RxComputationThreadPool-2]	| 4
```

> * 자신의 발행 작업이 끝난 다음에 파라미터로 받은 observable 객체의 발행이 시작된다.
> * 마찬가지로 자신과 파라미터로 받은 observable 객체에 의해 기본 scheduler가 결정된다.












