## Observable - conditional

### 1. Observable.amb()

여러 observable 객체들을 원소로 갖는 iterable 객체를 파라미터로 받아서 그 중에 가장 먼저 값을 발행하는 하나만 선택하여
그 객체에서 발행된 값만 발행하는 observable 객체를 생성한다.

다른 생성 메소드처럼 정적 메소드이다.

#### Prototype

```java
public static Observable<T> amb(Iterable<ObservableSource<T>> sources)
```

#### Example

```java
log("current");

Observable<Long> src1 = Observable.interval(0L, 100L, TimeUnit.MILLISECONDS)
    .map(val -> val * 2).take(3);
Observable<Long> src2 = Observable.interval(50L, 100L, TimeUnit.MILLISECONDS)
    .map(val -> (val * 2) + 1).take(3);

List<Observable<Long>> sources = Arrays.asList(src1, src2);
Observable.amb(sources)
    .subscribe(Main::log);
```

```
[main]	: current
[RxComputationThreadPool-1]	: 0
[RxComputationThreadPool-1]	: 2
[RxComputationThreadPool-1]	: 4
```

> * 여러 source중에 가장 먼저 값을 발행하는 하나를 제외하고 나머지는 마치 처음부터 없었던 것처럼 아무런 영향을 미치지 못한다.
따라서 선택된 source의 발행이 끝나면 나머지와 상관없이 onComplete가 발생한다.

### 2. takeUntil()

정적 메소드가 아니며 자신이 발행하는 값을 그대로 발행을 하다가 파라미터로 받은 observable 객체가 첫 번째 값을 발행하면 발행을 끝내는 observable 객체를 반환한다.

#### Prototype

```java
public final Observable<T> takeUntil(ObservableSource<U> other)
```

#### Example

```java
log("current");

Observable<Long> timer = Observable.timer(250L, TimeUnit.MILLISECONDS);

Observable.interval(100L, TimeUnit.MILLISECONDS)
    .takeUntil(timer)
    .subscribe(Main::log);
```

```
[main]	: current
[RxComputationThreadPool-2]	: 0
[RxComputationThreadPool-2]	: 1
```

> * `timer()`로 생성된 observable 객체와 같이 사용하면 좋다.
> * timer 객체가 발행을 하면 즉시 onComplete가 발생한다.

### 3. skipUntil()

takeUntil()과 반대로 동작하는 메소드이다.

자신이 발행하는 값을 파라미터로 받은 observable 객체가 첫 번째 값을 발행할 때 까지 무시하다가 그 이후부터 발행을 시작하는 observable 객체를 반환한다.

#### Prototype

```java
public final Observable<T> skipUntil(ObservableSource<U> other)
```

#### Example

```java
log("current");

Observable<Long> timer = Observable.timer(250L, TimeUnit.MILLISECONDS);

Observable.interval(100L, TimeUnit.MILLISECONDS)
    .take(5)
    .skipUntil(timer)
    .subscribe(Main::log);
```

```
[main]	: current
[RxComputationThreadPool-2]	: 2
[RxComputationThreadPool-2]	: 3
[RxComputationThreadPool-2]	: 4
```

> * `timer()`로 생성된 observable 객체와 같이 사용하면 좋다.

### 4. all()

자신이 발행하는 모든 값이 조건에 맞으면 `true`, 그렇지 않으면 `false`를 발행하는 `Single` 객체를 반환한다.
발행되는 값 중에 조건에 맞지 않는 값이 발견되는 즉시 `false`를 발행하고 바로 끝낸다.

#### Prototype

```java
public final Single<Boolean> all(Predicate<T> predicate)
```

#### Example

```java
log("current");

Observable.interval(100L, TimeUnit.MILLISECONDS)
    .take(3)
    .all(val -> val < 3)
    .subscribe(Main::log);
```

```
[main]	: current
[RxComputationThreadPool-1]	: true
```

```java
log("current");

Observable.interval(100L, TimeUnit.MILLISECONDS)
    .doOnNext(val -> System.out.println("Value: " + val))
    .all(val -> val < 3)
    .subscribe(Main::log);
```

```
[main]	: current
Value: 0
Value: 1
Value: 2
Value: 3
[RxComputationThreadPool-1]	: false
```

> * 두 번째 예제를 보면 3이 발행되는 순간 조건에 맞지 않는 값이 발견되었으므로 즉시 `false`를 발행하고 끝내는 걸 볼 수 있다.
