## Observable 변환

변환 메소드는 대체로 처음 observable 객체를 생성하는 게 아니라 현재 observable 객체를 변환하여 
새로운 observable 객체를 반환하는 메소드들이다. 따라서 일반적으로 정적 메소드가 아니다.

### 1. repeat()

단순하게 현재 observable 객체의 pusblish sequence를 반복하는 observable 객체를 반환한다.

#### Prototype

```java
public final Observable<T> repeat()
public final Observable<T> repeat(long times)
```

#### Example

```java
log("current");

Observable.range(1, 2)
    .repeat(2)
    .subscribe(Main::log);
```

```
[main]	: current
[main]	: 1
[main]	: 2
[main]	: 1
[main]	: 2
```

> * scheduler는 사용하지 않는다.
> * 횟수(times)를 지정하지 않으면 `Long.MAX_VALUE`만큼 반복한다.
> * 참고로 `repeatUntil()`, `repeatWhen()` 같은 변형된 메소드도 있다.

### 2. map()

현재 observable 객체가 publish하는 값에 파라미터로 받은 `mapper`를 적용하여 반환된 값을 publish하는 observable 객체를 반환한다.

#### Prototype

```java
public final Observable<R> map(Function<T, R> mapper)
```

#### Example

```java
Observable.just(1, 2)
    .map(item -> item + "개")
    .subscribe(Main::log);
```

```
[main]	: current
[main]	: 1개
[main]	: 2개
```

> * scheduler는 사용하지 않는다.
> * 가장 단순한 1:1 변환이다.

### 3. flatMap()

`map()` 메소드는 `mapper`가 `R`타입의 값을 반환하지만 `flatMap()`의 `mapper`는 `ObservableSource<R>`를 반환한다.
즉 `flatMap()`의 `mapper`는 값을 한 개 받아서 여러 개의 값을 publish하는 observable 객체를 반환한다. 

`flatMap()`은 **현재 observable 객체가 publish하는 값들을 위의 mapper를 통해서 observable객체로 변환**하고 
**변환된 각 observable들이 publish하는 값들을 publish하는** observable 객체를 반환한다.

#### Prototype

```java
public final Observable<R> flatMap(Function<T, ObservableSource<R>> mapper)
...
public final Observable<R> flatMap(Function<T, ObservableSource<R>> mapper, boolean delayErrors, int maxConcurrency, int bufferSize)
```

#### Example

```java
log("current");

Observable.just(2, 3)
    .flatMap(item -> 
        Observable.just(item.toString())
            .repeat(item)
    )
    .subscribe(Main::log);
```

```
[main]	: current
[main]	: 2
[main]	: 2
[main]	: 3
[main]	: 3
[main]	: 3
```

> * scheduler는 사용하지 않는다.
> * 변환된 여러 observable 객체가 publish하는 값들은 지연 없이 즉시 publish된다. 따라서 `mapper`가 반환한 observable 객체가 
비동기로 동작하는 경우 `mapper`에 적용된 순서와 상관없이 publish되는 값들의 순서는 얼마든지 바뀔(섞일) 수 있다.
> * 참고로 flatMap() 메소드는 위에서 설명한 메소드 외에 여러 파라미터를 받는 overload된 메소드가 매우 많다. 변형된 기능을 원하는 경우 
살펴보도록 한다.

### 4. reduce()

여기서는 reduce라는 명칭을 사용하였으나 *aggregate*, *accumulate*라는 용어를 많이 사용한다.

현재 observable이 publish하는 모든 값들을 대상으로 다음 작업을 수행한다. 
* 현재 publish된 값과 이전 단계의 `reducer`가 반환한 값으로 다시 `reducer`를 호출하는 작업을 반복하여 최종값이 생성되면 
그 값을 publish하는 observable 객체를 반환한다. 
* `seed`를 받지 않는 `reduce()` 메소드는 첫 번째 값이 `seed`가 되고 2번째 값부터 `reducer`가 적용된다. 따라서 현재 observable이
값을 하나도 publish하지 않는다면 값이 없을 수 있기 때문에 `Maybe` 객체를 반환한다.
* `seed`가 있는 경우에는 값이 하나도 publish되지 않더라도 기본적으로 `seed`값이 있으므로 `Single` 객체를 반환한다.

#### Prototype

```java
public final Maybe<T> reduce(BiFunction<T, T, T> reducer)
public final Single<R> reduce(R seed, BiFunction<R, T, R> reducer)
```

#### Example

```java
log("current");

Observable.range(1, 10)
    .reduce(0, (prev, cur) -> prev + cur)
    .subscribe(Main::log);
```

```
[main]	: current
[main]	: 55
```

> * scheduler는 사용하지 않는다.
> * 첫 단계에서는 이전 단계의 reducer가 반환한 값이 없지만 `seed`가 그 역할을 한다.

### 5. filter()

현재 observable이 publish하는 값들 중 조건에 맞는 값들만 선택적으로 publish하는 observable 객체를 반환한다.

#### Prototype

```java
public final Observable<T> filter(Predicate<T> predicate)
```

#### Example

```java
log("current");

Observable.range(1, 10)
    .filter(value -> (value % 2) == 0)
    .subscribe(Main::log);
```

```
[main]	: current
[main]	: 2
[main]	: 4
[main]	: 6
[main]	: 8
[main]	: 10
```

> * scheduler는 사용하지 않는다.

### 6. first(), last(), take(), takeLast(), skip(), skipLast()

filter() 처럼 몇몇 값들만 선택하는 메소드들이다. 이름만 봐도 어떤 식으로 동작하는 지 가늠할 수 있을 만큼 직관적이다.

#### Prototype

```java
public final Single<T> first(T defaultItem)
public final Single<T> last(T defaultItem)
public final Observable<T> take(long count)
public final Observable<T> takeLast(int count)
public final Observable<T> skip(long count)
public final Observable<T> skipLast(int count)
```

> * `first(default)` - 첫 번째 값만 publish하는 `Single` 객체 반환. 값이 없이 끝나면 `default` 반환.
> * `last(default)` - 마지막 값만 publish하는 `Single` 객체 반환. 값이 없이 끝나면 `default` 반환.
> * `take(count)` - 처음 `count`개의 값만 publish하는 `Observable` 객체 반환.
> * `takeLast(count)` - 마지막 `count`개의 값만 publish하는 `Observable` 객체 반환.
> * `skip(count)` - 처음 `count`개의 값은 버리고 그 이후의 값만 publish하는 `Observable` 객체 반환.
> * `skipLast(count)` - 마지막 `count`개의 값은 버리고 그 이전의 값만 publish하는 `Observable` 객체 반환.
