## Observable - filter

여기서 소개되는 메소드는 자신이 발행하는 값 중에서 특정 조건으로 부합하는 값들만 걸러서 발행하는 observable 객체를 
반환한다. 

### 1. filter()

자신이 발행하는 값들 중 조건에 맞는 값들만 선택적으로 발행하는 observable 객체를 반환한다.

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

### 2. debounce()

자신이 값을 발행한 후 일정 시간 동안 값을 발행하지 않으면 그 값을 발행하는 observable 객체를 반환한다. 만약 지정 시간 내에 다른 값을 다시 발행되면
이전에 발행된 값을 버리고 다시 타이머를 초기화 한다. 짧은 시간 동안 급격하게 많은 발행이 일어나면 모두 걸러내고 마지막 값만 발행하도록 하는 효과가 있다.

#### Prototype

```java
public final Observable<T> debounce(long timeout, TimeUnit unit)
```

#### Example

```java
log("current");

Observable.interval(100, TimeUnit.MILLISECONDS)
    .take(5)
    .debounce(200, TimeUnit.MILLISECONDS)
    .subscribe(Main::log);
```

```
[main]	| current
[RxComputationThreadPool-1]	| 4
```

> * 0, 1, 2, 3, 4가 100ms 간격으로 발행되었으나 debounce 200ms가 적용돼서 마지막 값인 4만 발행되고 0, 1, 2, 3은  버려진다.

### 3. first(), last(), take(), takeLast(), skip(), skipLast()

filter() 처럼 선택 조건을 받지는 않지만 이름만 봐도 어떤 식으로 동작하는 지 가늠할 수 있을 만큼 직관적이므로
간단히 소개하도록 하겠다.

filtering 관련 메소드 뿐만 아니라 기타 다른 메소드의 이름도 비숫한 naming 방식을 사용하므로 first, last, take, skip 등의
동작이 어떻게 되는 지 익숙해지도록 한다.

#### Prototype

```java
public final Single<T> first(T defaultItem)
public final Single<T> last(T defaultItem)
public final Observable<T> take(long count)
public final Observable<T> takeLast(int count)
public final Observable<T> skip(long count)
public final Observable<T> skipLast(int count)
```

> * `first(default)` - 첫 번째 값만 발행하는 `Single` 객체 반환. 값이 없이 끝나면 `default` 반환.
> * `last(default)` - 마지막 값만 발행하는 `Single` 객체 반환. 값이 없이 끝나면 `default` 반환.
> * `take(count)` - 처음 `count`개의 값만 발행하는 `Observable` 객체 반환.
> * `takeLast(count)` - 마지막 `count`개의 값만 발행하는 `Observable` 객체 반환.
> * `skip(count)` - 처음 `count`개의 값은 버리고 그 이후의 값만 발행하는 `Observable` 객체 반환.
> * `skipLast(count)` - 마지막 `count`개의 값은 버리고 그 이전의 값만 발행하는 `Observable` 객체 반환.
