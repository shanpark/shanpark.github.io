## Observable - transform

변환 메소드는 대체로 처음 observable 객체를 생성하는 게 아니라 자신이 발행하는 값들을 변환하여 
새로운 observable 객체를 반환하는 메소드들이다. 따라서 일반적으로 정적 메소드가 아니다.

### 1. repeat()

자신이 정의하는 발행 작업을 계속 반복하는 observable 객체를 반환한다.

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

자신이 발행하는 값에 파라미터로 받은 `mapper`를 적용하여 변환된 값을 발행하는 observable 객체를 반환한다.

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

map()과 flatMap()은 전달하는 mapper가 다른데 그 차이점을 보면 이해가 쉽다.

`map()` 메소드는 `mapper`가 `R`타입의 값을 반환하지만 `flatMap()`의 `mapper`는 `ObservableSource<R>`를 반환한다.
즉 `flatMap()`의 `mapper`는 값을 한 개 받아서 여러 개의 값을 발행하는 observable 객체를 반환한다. 

`flatMap()`은 **자신이 발행하는 값들을 위의 mapper를 통해서 observable객체로 변환**하고 
**변환된 각 observable들이 발행하는 값들을 발행하는** observable 객체를 반환한다.

#### Prototype

```java
public final Observable<R> flatMap(Function<T, ObservableSource<R>> mapper)
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
> * 변환된 여러 observable 객체가 발행하는 값들은 지연 없이 즉시 발행된다. 따라서 `mapper`가 반환한 observable 객체가 
비동기로 동작하는 경우 `mapper`에 적용된 순서와 상관없이 발행되는 값들의 순서는 얼마든지 바뀔(섞일) 수 있다.
> * 참고로 flatMap() 메소드는 위에서 설명한 메소드 외에도 여러 overload 메소드가 있다.

### 4. concatMap()

`flatMap()`과 비숫하지만 `concatMap()`은 mapper가 적용된 순서대로 값들이 발행되는 걸 보장한다. 즉 먼저 생성된 
observable 객체가 완료된 후에 다음 생성된 observable 객체가 발행 작업을 시작한다.

#### Prototype

```java
public final Observable<R> concatMap(Function<T, ObservableSource<R>> mapper)
```

#### Example

```java
log("current");

Observable.just(1, 2)
    .concatMap(num ->
        Observable.interval(100L * num, TimeUnit.MILLISECONDS)
            .take(3)
            .map(dummy -> num)
    )
    .subscribe(Main::log);
```

```
[main]	: current
[RxComputationThreadPool-1]	: 1
[RxComputationThreadPool-1]	: 1
[RxComputationThreadPool-1]	: 1
[RxComputationThreadPool-2]	: 2
[RxComputationThreadPool-2]	: 2
[RxComputationThreadPool-2]	: 2
```

> * scheduler는 사용하지 않는다. 예제의 경우에는 생성된 observable 객체가 scheduler를 사용할 뿐이다.
> * mapper가 생성한 observable 객체는 100ms 간격으로 1을 3번, 200ms 간격으로 2를 3번 발행하므로 동시에
진행된다면 1, 2가 섞여야 맞지만 concatMap()은 생성된 observable 객체를 순서대로 실행시킨다.
> * 참고로 concatMap() 메소드는 위에서 설명한 메소드 외에도 여러 overload 메소드가 있다.
> * 위 소스에서 `concapMap`을 `flatMap`으로 바꾸면 아래와 같은 결과가 나온다.

```
[main]	: current
[RxComputationThreadPool-1]	: 1
[RxComputationThreadPool-2]	: 2
[RxComputationThreadPool-1]	: 1
[RxComputationThreadPool-1]	: 1
[RxComputationThreadPool-2]	: 2
[RxComputationThreadPool-2]	: 2
```

### 5. switchMap()

`concatMap()`은 이전에 생성된 observable 객체가 작업을 완료할 때 까지 다음에 생성된 observable의 작업을 시작하지 않지만
`switchMap()`은 mapper가 observable을 생성하면 즉시 이전에 생성된 observabable의 작업을 중단시키고 새로 생성된 
observable의 작업을 실행시킨다.

#### Prototype

```java
public final Observable<R> switchMap(Function<T, ObservableSource<R>> mapper)
```

#### Example

```java
log("current");

Observable.interval(500, TimeUnit.MILLISECONDS)
    .take(2)
    .switchMap(num ->
        Observable.interval(200L * (num+1), TimeUnit.MILLISECONDS)
            .take(3)
            .map(dummy -> num+1)
    )
    .subscribe(Main::log);
```

```
[main]	: current
[RxComputationThreadPool-2]	: 1
[RxComputationThreadPool-2]	: 1
[RxComputationThreadPool-3]	: 2
[RxComputationThreadPool-3]	: 2
[RxComputationThreadPool-3]	: 2
```

> * scheduler는 사용하지 않는다. 예제의 경우에는 생성된 observable 객체가 scheduler를 사용할 뿐이다.
> * `concatMap()`이라면 1과 2가 세 번씩 출력되어야 하지만 두 번째 observable이 생성되는 시점에 첫 번째 observable은
중단되어 세 번째 1은 출력되지 않고 바로 2가 세 번 출력되는 걸 볼 수 있다.
> * 참고로 switchMap() 메소드는 위에서 설명한 메소드 외에도 여러 overload 메소드가 있다.

### 6. reduce()

여기서는 reduce라는 명칭을 사용하였으나 *aggregate*, *accumulate*라는 용어를 많이 사용한다.

자신이 발행하는 모든 값들을 대상으로 다음 작업을 수행한다. 
* 현재 발행된 값과 이전 단계의 `reducer`가 반환한 값으로 다시 `reducer`를 적용하는 작업을 반복하여 최종값이 생성되면 
그 값을 발행하는 observable 객체를 반환한다.
* `seed`를 받지 않는 `reduce()` 메소드는 첫 번째 값이 `seed`가 되고 2번째 값부터 `reducer`가 적용된다. 
따라서 자신이 값을 하나도 발행하지 않는다면 값이 없을 수 있기 때문에 `Maybe` 객체를 반환한다.
* `seed`가 있는 경우에는 값이 하나도 발행되지 않더라도 기본적으로 `seed`값이 있으므로 `Single` 객체를 반환한다.

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

### 7. scan()

`scan()` 메소드는 `reduce()`와 비숫한 동작을 하지만 최종 값만 발행하는 게 아니라 자신이 새로운 값을 발행할 때마다 
accumulator를 적용하고 그 결과값을 발행하는 observable 객체를 반환한다.
따라서 반환되는 객체는 `Single`이나 `Maybe`가 아니라 `Observable` 객체이다.

#### Prototype

```java
public final Observable<T> scan(BiFunction<T, T, T> accumulator)
public final Observable<R> scan(R initialValue, BiFunction<R, T, R> accumulator)
```

#### Example

```java
log("current");

Observable.range(1, 10)
    .scan(0, (prev, cur) -> prev + cur)
    .subscribe(Main::log);
```

```
[main]	: current
[main]	: 0
[main]	: 1
[main]	: 3
[main]	: 6
[main]	: 10
[main]	: 15
[main]	: 21
[main]	: 28
[main]	: 36
[main]	: 45
[main]	: 55
```

> * scheduler는 사용하지 않는다.
> * 최종값은 `reduce()`와 같다.
> * initialValue가 주어지면 그 값도 발행이 되는 걸 볼 수 있다. initialValue가 없으면 1부터 발행된다.

### 8. groupBy()

`groupBy()` 메소드는 `GroupedObservable` 객체를 발행하는 observable 객체를 반환한다. 
여기서 발행되는 `GroupedObservable` 객체는 자신이 발행하는 값들을 `groupBy()`에 전달된 `keySelector` 함수를 적용하여 
반환되는 값을 기준으로 grouping 했을 때 새로운 group이 만들어지면 `GroupedObservable` 객체를 만들어서 발행하는 것이다. 
현재 observable 객체가 publish하는 값들은 각 `GroupedObservable` 객체를 통해서 publish된다.

여기서 중요한 점은 `groupBy()`는 `GroupedObservable` 객체를 발행하는 observable 객체를 반환한다는 것이다.

예제에서 보듯이 `groupBy()`가 발행하는 것은 `GroupedObservable` 객체이므로 다시 `subscribe()`를 호출해서 값을 받아야 한다. 
이 때 각 값의 group은 `GroupedObservable` 객체의 `getKey()` 메소드를 통해서 알 수 있다.

#### Prototype

```java
public final Observable<GroupedObservable<K, T>> groupBy(Function<T, K> keySelector)
```

#### Example

```java
Observable.range(1, 5)
    .groupBy(value -> (value % 2) == 0? "Even" : "Odd")
    .subscribe(groupedObservable ->
        groupedObservable.subscribe(
            val -> System.out.format("Group: %s, Value: %d\n", groupedObservable.getKey(), val)
        )
    );
```

```
Group: Odd, Value: 1
Group: Even, Value: 2
Group: Odd, Value: 3
Group: Even, Value: 4
Group: Odd, Value: 5
```

> * 예제에서는 표시되지 않았지만 scheduler는 사용하지 않는다.
> * 발행되는 값은 각 group의 observable 객체를 통할 뿐 값이 발행되는 순서는 group에 상관없이 즉시 발행된다.
