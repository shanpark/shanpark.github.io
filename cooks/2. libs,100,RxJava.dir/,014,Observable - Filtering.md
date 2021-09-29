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

### 2. first(), last(), take(), takeLast(), skip(), skipLast()

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
