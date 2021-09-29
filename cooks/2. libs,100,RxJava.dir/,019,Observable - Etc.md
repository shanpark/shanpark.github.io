## Observable - Etc

Observable는 엄청나게 많은 수의 메소드를 가지고 있다. 여기서는 분류없이

### 1. delay()

자신이 발행하는 값들을 일정 시간 delay 시킨 후 발행하는 observable 객체를 반환한다.

#### Prototype

```java
public final Observable<T> delay(long time, TimeUnit unit)
```

#### Example

```java
long start = System.currentTimeMillis();
Observable.interval(100L, TimeUnit.MILLISECONDS)
    .take(3)
    .doOnNext(val -> System.out.format("Pub Time: %d, Value: %s\n", System.currentTimeMillis() - start, val))
    .delay(1000L, TimeUnit.MILLISECONDS)
    .subscribe(val -> System.out.format("Sub Time: %d, Value: %s\n", System.currentTimeMillis() - start, val));
```

```
Pub Time: 206, Value: 0
Pub Time: 306, Value: 1
Pub Time: 402, Value: 2
Sub Time: 1214, Value: 0
Sub Time: 1311, Value: 1
Sub Time: 1404, Value: 2
```

> * 원본 source로부터 값이 발행된 시간과 delay() 이후에 수신된 시간의 차이를 보면 대략 1000ms 차이가 있는 걸 볼 수 있다.

### 2. timeInterval()

이전 값이 발행된 이후에 얼마나 시간이 흘렀는 지를 알 수 있는 시간 값(Timed객체)을 발행하는 observable 객체를 반환한다.

#### Prototype

```java
public final Observable<Timed<T>> timeInterval()
```

#### Example

```java
log("current");

Observable.interval(100L, TimeUnit.MILLISECONDS)
    .take(3)
    .timeInterval()
    .subscribe(Main::log);
```

```
[main]	: current
[RxComputationThreadPool-1]	: Timed[time=103, unit=MILLISECONDS, value=0]
[RxComputationThreadPool-1]	: Timed[time=99, unit=MILLISECONDS, value=1]
[RxComputationThreadPool-1]	: Timed[time=100, unit=MILLISECONDS, value=2]
```

> * 발행된 Timed 객체는 직전의 발행 이후 흐른 시간 정보와 발행된 값을 모두 가지고 있다. Timed::value 필드를 통해 발행된 값을 알 수 있다.