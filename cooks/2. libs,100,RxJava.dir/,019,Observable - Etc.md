## Observable - Etc

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

### 3. publish()

`Observable` 객체를 `ConnectableObservable` 객체로 바꿔준다. 즉, `subscribe()`가 호출되어도 발행 작업을 시작하지 않고 기다리다가 
`connect()`가 호출되면 그 때 발행 작업을 시작한다.

`ConnectableObservable` 객체는 `connect()`가 호출되기 전에 여러 observer로 `subscribe()`를 호출한 상태라면 값을 multicast하는 효과가 있다.

#### Prototype

```java
public final ConnectableObservable<T> publish()
```

#### Example

```java
log("current");

ConnectableObservable<Long> src = Observable.interval(100, TimeUnit.MILLISECONDS)
    .take(3)
    .map(val -> {
        System.out.println("map()");
        return val;
    })
    .publish();
src.subscribe(val -> log("Observer 1: " + val));
Thread.sleep(200); // before connect
src.subscribe(val -> log("Observer 2: " + val));
src.connect(); // start !!

Thread.sleep(250); // after connect
System.out.println("sleep 250.");
src.subscribe(val -> log("Observer 3: " + val));
```

```
[main]	| current
map()
[RxComputationThreadPool-1]	| Observer 1: 0
[RxComputationThreadPool-1]	| Observer 2: 0
map()
[RxComputationThreadPool-1]	| Observer 1: 1
[RxComputationThreadPool-1]	| Observer 2: 1
sleep 250.
map()
[RxComputationThreadPool-1]	| Observer 1: 2
[RxComputationThreadPool-1]	| Observer 2: 2
[RxComputationThreadPool-1]	| Observer 3: 2
```

> * 'Observer 1'이 먼저 subscribe를 시작했지만 값이 발행되지 않고 'Observer 2'까지 subscribe한 후에 `connect()`를 호출했기 때문에 
그 이후부터 Observer1, 2가 함께 값을 수신하였다.
> * 여러 observer가 subscribe를 하고 있지만 mappper가 한 번씩만 호출되는 걸 볼 수 있다. (multicast)
> * `connect()`가 호출되어 발행이 시작된 상태에서 중간에 subscribe를 시작한 'Observer 3'는 subscribe() 호출 이후에 발행된 값들부터 수신한다.
> * 물론 발행이 완료된 후에 등록된 observer는 값을 받을 수 없다. 

### 4. refCount()

`ConnectableObservable` 객체를 `Observable` 객체처럼 동작하도록 바꿔서 반환한다. 이름만 봐서는 전혀 알 수 없는 동작이다.

반환된 Observable 객체는 다음과 같이 동작한다.
* 첫 번째 `subscribe()`가 호출되면 발행을 시작한다. (일반적인 observable 객체처럼 보이도록)
* 발행이 완료되기 전에 다른 observer가 수신을 시작하면 그 이후에 발행된 값을 같이 받을 수 있다. (`ConnectableObservable` 객체가 multicast를 수행하는 것과 같다.)
* observer의 수를 count하다가 observer가 하나도 없어지면 발행을 중단한다. (`refCount()`는 여기서 유래된 이름이다.)
* 발행이 완전히 끝난 후에 또 다른 observer가 `subscribe()`를 호출하면 다시 처음부터 발행을 시작한다.

#### Prototype

```java
public Observable<T> refCount()
```

#### Example

```java
log("current");

Observable<Long> src = Observable.interval(100, TimeUnit.MILLISECONDS)
    .take(3)
    .map(val -> {
        System.out.println("map()");
        return val;
    })
    .publish().refCount();
src.subscribe(val -> log("Observer 1: " + val)); // start !!
Thread.sleep(150); // before connect
src.subscribe(val -> log("Observer 2: " + val));

Thread.sleep(500);
System.out.println("wait end.");

src.subscribe(val -> log("Observer 3: " + val)); // restart !!
```

```
[main]	| current
map()
[RxComputationThreadPool-1]	| Observer 1: 0
map()
[RxComputationThreadPool-1]	| Observer 1: 1
[RxComputationThreadPool-1]	| Observer 2: 1
map()
[RxComputationThreadPool-1]	| Observer 1: 2
[RxComputationThreadPool-1]	| Observer 2: 2
wait end.
map()
[RxComputationThreadPool-2]	| Observer 3: 0
map()
[RxComputationThreadPool-2]	| Observer 3: 1
map()
[RxComputationThreadPool-2]	| Observer 3: 2
```

> * 'Observer 1'이 subscribe를 시작하면 즉시 발행을 시작한다. 
> * 2 번째 값이 발행되기 전에 'Observer 2'가 subcribe를 시작했으므로 값 1과 2는 두 Observer가 같이 수신하는 걸 볼 수 있다. (multicast)
> * 마지막 값까지 완전히 발행이 완료된 후에 새로운 observer가 subscribe를 시작하면 발행작업이 다시 시작된다. ('Observer 3')

### 5. share()

이 메소드의 명목상의 내용은 multicast를 수행하는 observable 객체를 반환하는 것이다.
하지만 실질적으로는 `publish().refCount()`와 같다. 공식적으로 `publish().refCount()`의 별칭(alias)라고 소개하고 있다.

example은 refCount()와 같으므로 생략한다.

#### Prototype

```java
public Observable<T> refCount()
```
