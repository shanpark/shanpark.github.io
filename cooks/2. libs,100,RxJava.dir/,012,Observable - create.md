## Observable - create

`Observable`을 생성하는 많은 함수들이 있다. observable을 처음 새로 생성하는 메소드는 대체로 정적 메소드이다. 

유용하게 사용할 수 있는 함수와 예제들을 소개한다. 모든 예제는 첫 번째 예제에서 main 코드 부분을 변형한 것이라 가정하여 
변형된 코드 부분만 제공하므로 예제에 없는 코드는 첫 번째 예제를 참고하면 된다.

> 모든 Prototype은 이해를 돕기위해 복잡한 선언 구문들을 간략하게 수정하였다.

### 1. Observable.range()

정수형 값을 `start`부터 `count`개만큼 차례대로 발행한다.

#### Prototype

```java
public static Observable<Integer> range(int start, int count)
public static Observable<Long> rangeLong(long start, long count)
```

#### Example

```java
public class Main {
    public static void log(Object x) {
        System.out.format("[%s]\t: %s\n", Thread.currentThread().getName(), x.toString());
    }

    public static void main(String[] args) throws InterruptedException {
        log("current");

        Observable.range(3, 3)
            .subscribe(Main::log);

        Thread.sleep(10 * 1000L); // 이 경우는 필요없지만 다른 스레드를 위해 대기.
    }
}
```

```
[main]	: current
[main]	: 3
[main]	: 4
[main]	: 5
```

> * scheduler는 사용하지 않는다.
> * `range()`, `rangeLong()`은 각각 `int`, `long` 타입을 사용한다.
> * 참고로 `interval()`과 조합된 `intervalRange()` 메소드도 있다. `long` 타입을 사용한다.

### 2. Observable.interval()

일정 시간(initialDelay) 후부터 일정 간격(period)으로 정수형 값을 0부터 차례대로 무한하게 발행한다.

#### Prototype

```java
public static Observable<Long> interval(long period, TimeUnit unit)
public static Observable<Long> interval(long initialDelay, long period, TimeUnit unit)
public static Observable<Long> interval(long initialDelay, long period, TimeUnit unit, Scheduler scheduler)
```

#### Example

```java
log("current");

Observable.interval(1000L, 1000L, TimeUnit.MILLISECONDS)
    .take(3)
    .subscribe(Main::log);
```

```
[main]	: current
[RxComputationThreadPool-1]	: 0
[RxComputationThreadPool-1]	: 1
[RxComputationThreadPool-1]	: 2
```

> * `initialDelay`는 default로 `period`와 같다. 
> * scheduler는 default로 `COMPUTATION`을 사용한다.
> * 출력 결과에서 보듯이 observer 코드는 다른 스레드에서 실행된다.

### 3. Observable.timer()

일정 시간(delay) 후에 0을 한 번 발행하고 끝낸다.

#### Prototype

```java
public static Observable<Long> timer(long delay, TimeUnit unit)
public static Observable<Long> timer(long delay, TimeUnit unit, Scheduler scheduler)
```

#### Example

```java
log("current");

Observable.timer(2000L, TimeUnit.MILLISECONDS)
    .subscribe(Main::log);
```

```
[main]	: current
[RxComputationThreadPool-1]	: 0
```

> * 0이 발행되지만 의미는 없다.
> * scheduler는 default로 `COMPUTATION`을 사용한다.
> * 출력 결과에서 보듯이 observer 코드는 다른 스레드에서 실행된다.

### 4. Observable.defer()

observer가 subscribe를 할 때 까지 observable 객체의 생성을 지연 시킨다. 풀어서 얘기하자면 다음과 같은 동작을 수행한다.
* 새로운 observer가 subscribe를 시작하면 파라미터로 받은 supplier를 호출해서 observable 객체를 생성하고 생성된 observable 객체를 새로 등록된 observer가 subscribe를 하도록 한다.

#### Prototype

```java
public static Observable<T> defer(Supplier<ObservableSource<T>> supplier)
```

#### Example

```java
log("current");

Supplier<Observable<Long>> supplier = () -> 
    Observable.just(System.currentTimeMillis() / 1000, 
                    System.currentTimeMillis() % 1000);

Observable<Long> source = 
    Observable.defer(supplier)
        .doOnComplete(() -> System.out.println("onComplete"));
source.subscribe(Main::log);

Thread.sleep(1000);
source.subscribe(Main::log);
```

```
[main]	: current
[main]	: 1632800341
[main]	: 736
onComplete
[main]	: 1632800342
[main]	: 743
onComplete
```

> * scheduler는 사용하지 않는다.
> * subscribe를 할 때마다 supplier가 호출되어 생성된 observable 객체를 subscribe한다.
