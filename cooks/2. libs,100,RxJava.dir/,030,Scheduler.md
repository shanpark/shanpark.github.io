## Scheduler

---

### 1. Scheduler 개요

scheduler는 observable 객체가 수행하는 발행 작업, observer 객체가 수행하는 수신 작업을 등을 수행할 스레드풀 같은 개념이다.
RxJava의 각종 이벤트 처리가 어떤 스레드에서 수행되는 것인지 살펴보는 것이 이해하는 데 많은 도움이 된다.

RxJava는 기본적으로 몇가지 scheduler를 제공한다. `Schedulers` 클래스가 제공하는 정적 메소드들을 통해서 얻을 수 있다.

* **Schedulers.newThread()**
* **Schedulers.computation()**
* **Schedulers.io()**
* **Schedulers.single()**
* **Schedulers.trampoline()**
* **Schedulers.from(executor)**

### 2. Scheduler 사용

어떤 scheduler를 사용하도록 할 것인지 observable 객체의 subscribeOn, observeOn 메소드를 이용하여 설정한다.
두 메소드는 비숫해 보이지만 상당히 다른 동작을 하며 쓰임새가 명확하므로 정확히 이해하고 사용해야 한다.

#### subscribeOn()

`subscribeOn()`은 observable 객체가 발행 작업을 어느 scheduler에서 ***시작***할 지를 지정한다.
값을 발행하는 observable 객체의 관점에서 scheduler를 지정하는 것이다. 다음과 같은 특성이 있다.

* call chain의 어디서 호출을 하더라도 시작 scheduler를 지정하는 것이므로 효과는 똑같다.
* 여러 번 호출되면 가장 먼저 지정된 scheduler가 우선이다. 그 뒤에 지정된 scheduler는 무시된다.

```java
log("current");

Observable.just(1, 2, 3)
    .doOnNext((val) -> log("doOnNext:" + val))
    .subscribeOn(Schedulers.computation())
    .subscribeOn(Schedulers.io())
    .subscribe(Main::log);
```

```
[main]	| current
[RxComputationThreadPool-1]	| doOnNext:1
[RxComputationThreadPool-1]	| 1
[RxComputationThreadPool-1]	| doOnNext:2
[RxComputationThreadPool-1]	| 2
[RxComputationThreadPool-1]	| doOnNext:3
[RxComputationThreadPool-1]	| 3
```

> * 처음 지정된 **computaion** scheduler에서 전체 작업이 실행된다.
> * call chain에서 `doOnNext()`가 먼저 호출되었더라도 순서와 무관하게 시작 scheduler는 **computation** scheduler이다.
> * 뒤에 지정된 **io** scheduler는 무시된다.

#### observeOn()

`observeOn()`은 observer의 관점에서 수신 작업이 실행될 scheduler를 지정한다. 다음과 같은 특성이 있다.

* call chain의 어딘가에서 호출되면 그 이후의 모든 작업에 영향을 미친다. 따라서 단계별로 다른 scheduler를 지정하는 것도 가능하다.
* `observeOn()`으로 따로 지정하지 않으면 `subscribeOn()`에서 지정된 scheduler에서 실행된다. 물론 아무 scheduler도 지정되지 않았다면 RxJava가 지정한 기본 scheduler가 사용된다.

```java
log("current");

Observable.just(1, 2, 3)
    .doOnNext((val) -> log("doOnNext:" + val))
    .observeOn(Schedulers.io())
    .subscribe(Main::log);
```

```
[main]	| current
[main]	| doOnNext:1
[main]	| doOnNext:2
[RxCachedThreadScheduler-1]	| 1
[RxCachedThreadScheduler-1]	| 2
[main]	| doOnNext:3
[RxCachedThreadScheduler-1]	| 3
```

> * 발행 작업은 현재 스레드인 main에서 시작됐지만 마지막 수신 작업은 `observeOn()`이 지정한 **io** scheduler에서 실행되었다.

```java
log("current");

Observable.just(1, 2, 3)
    .doOnNext((val) -> log("doOnNext:" + val))
    .observeOn(Schedulers.io())
    .subscribeOn(Schedulers.computation())
    .subscribe(Main::log);
```

```
[main]	| current
[RxComputationThreadPool-1]	| doOnNext:1
[RxComputationThreadPool-1]	| doOnNext:2
[RxCachedThreadScheduler-1]	| 1
[RxCachedThreadScheduler-1]	| 2
[RxComputationThreadPool-1]	| doOnNext:3
[RxCachedThreadScheduler-1]	| 3
```

> * `subscribeOn()`이 마지막에 호출되었음에도 `subscribeOn()`에서 지정한 **computation** scheduler에서 시작되는 걸 볼 수 있다.
> * 그럼에도 불구화고 수신 작업은 `observeOn()` 에서 지정한 **io** scheduler에서 실행된다.

```java
log("current");

Observable.just(1, 2, 3)
    .observeOn(Schedulers.io())
    .doOnNext((val) -> log("doOnNext:" + val))
    .observeOn(Schedulers.computation())
    .subscribeOn(Schedulers.computation())
    .subscribe(Main::log);
```

```
[main]	| current
[RxCachedThreadScheduler-1]	| doOnNext:1
[RxCachedThreadScheduler-1]	| doOnNext:2
[RxComputationThreadPool-2]	| 1
[RxCachedThreadScheduler-1]	| doOnNext:3
[RxComputationThreadPool-2]	| 2
[RxComputationThreadPool-2]	| 3
```

> * `subscribeOn()`이 **computation** scheduler를 지정했지만 call chain의 맨 앞에 `observeOn()`으로 **io** scheduler를 지정했으므로 `doOnNext`의 작업이 **io** scheduler에서 실행되었다. 결국 `subscribeOn()`은 무시되었다.
> * 두 번째 `observeOn()`으로 **computation** scheduler를 호출함으로써 마지막 수신 작업은 **computaion** scheduler에서 실행되었다.

### 3. Schedulers

#### Schedulers.newThread()

* 작업이 시작될 때 마다 새로운 scheduler 스레드를 생성해서 사용한다.

```java
log("current");

Observable<Integer> source = Observable.just(1, 2, 3)
    .subscribeOn(Schedulers.newThread());

Observable.concat(source, source)
    .subscribe(Main::log);
```

```
[main]	| current
[RxNewThreadScheduler-1]	| 1
[RxNewThreadScheduler-1]	| 2
[RxNewThreadScheduler-1]	| 3
[RxNewThreadScheduler-2]	| 1
[RxNewThreadScheduler-2]	| 2
[RxNewThreadScheduler-2]	| 3
```

> * concat 메소드에 같은 source를 2번 전달했지만 각각 스레드가 생성되는 걸 볼 수 있다.
> * 매번 실행할 때 마다 새로운 스레드가 생성되므로 주의 깊게 사용해야 한다.

#### Schedulers.computation()

* 계산 작업을 위한 scheduler이다. 입출력 작업과 같이 대기 시간이 필요치 않은, 주로 프로세서에서 처리되는 작업을 수행하기 위해서 사용한다.
* 일반적으로 CPU의 코어 갯수 만큼의 스레드를 생성해서 사용한다.

```java
log("current");

Observable.just(1, 2, 3)
    .subscribeOn(Schedulers.computation())
    .subscribe(Main::log);

Observable.just(1, 2, 3)
    .subscribeOn(Schedulers.computation())
    .subscribe(Main::log);
```

```
[main]	| current
[RxComputationThreadPool-2]	| 1
[RxComputationThreadPool-1]	| 1
[RxComputationThreadPool-2]	| 2
[RxComputationThreadPool-1]	| 2
[RxComputationThreadPool-2]	| 3
[RxComputationThreadPool-1]	| 3
```

> * main 스레드가 아닌 **computaion** scheduler의 스레드에서 실행되었다.
> * 두 observable 객체가 각각 다른 스레드에서 실행되었는데 필요에 따라 RxJava가 가용한 스레드를 알아서 선택하므로 어느 스레드인지는 상관없다.

#### Schedulers.io()

* 입출력 작업을 위한 scheduler이다. Networking, File I/O 같은 입출력 작업을 실행할 때 지정해서 사용한다.
* RxJava가 필요한 만큼 알아서 생성해서 사용한다. 

```java
log("current");

Observable.just(1, 2, 3)
    .subscribeOn(Schedulers.io())
    .subscribe(Main::log);

Observable.just(1, 2, 3)
    .subscribeOn(Schedulers.io())
    .subscribe(Main::log);

Thread.sleep( 2000); // 완료 대기
System.out.println("sleep 2000.");

Observable.just(1, 2, 3)
    .subscribeOn(Schedulers.io())
    .subscribe(Main::log);
```

```
[main]	| current
[RxCachedThreadScheduler-2]	| 1
[RxCachedThreadScheduler-2]	| 2
[RxCachedThreadScheduler-2]	| 3
[RxCachedThreadScheduler-1]	| 1
[RxCachedThreadScheduler-1]	| 2
[RxCachedThreadScheduler-1]	| 3
sleep 2000.
[RxCachedThreadScheduler-2]	| 1
[RxCachedThreadScheduler-2]	| 2
[RxCachedThreadScheduler-2]	| 3
```

> * main 스레드가 아닌 **io** scheduler의 스레드에서 실행되었다.
> * 'RxCachedThreadScheduler-*n*'가 **io** schduler가 사용하는 스레드의 이름이다.
> * **io** scheduler는 필요한 만큼 스레드를 생성하지만 재사용 가능한 스레드가 있으면 재사용한다. 예제에서 첫 번째, 두 번째 작업은 동시 실행되기 때문에 각각의 스레드에서 실행되지만 세 번째 작업은 2번 스레드를 재사용하고 있음을 볼 수 있다.


#### Schedulers.single()

* RxJava는 **single** scheduler용으로 스레드를 하나만 생성해서 사용한다.
* 여러 작업이 생성되더라도 하나의 스레드에서만 실행이 되기 때문에 이벤트 루프같은 로직을 구현하거나 동기화 문제가 발생할 여지가 있어서 순차적 실행이 필요할 때 사용을 고려해볼 수 있다.
* interval() 같이 기본 scheduler가 현재 스레드에서 실행되는 경우가 아닌 경우 subscribeOn()으로 발행 작업을 지정해도 효과가 없다. 
하지만 observeOn()으로 지정하면 수신 작업은 **single** scheduler에서 실행되도록 지정할 수 있다.

```java
log("current");

Observable<Long> sync = Observable.rangeLong(1, 3);
Observable<Long> async = Observable.intervalRange(1, 3, 100, 100, TimeUnit.MILLISECONDS);

sync.subscribeOn(Schedulers.single())
    .subscribe(Main::log);
async.subscribeOn(Schedulers.single()) // not work.
    .subscribe(Main::log);

Thread.sleep(2000);
System.out.println("sleep 2000.");

async.observeOn(Schedulers.single()) // work.
    .subscribe(Main::log);
```

```
[main]	| current
[RxSingleScheduler-1]	| 1
[RxSingleScheduler-1]	| 2
[RxSingleScheduler-1]	| 3
[RxComputationThreadPool-1]	| 1
[RxComputationThreadPool-1]	| 2
[RxComputationThreadPool-1]	| 3
sleep 2000.
[RxSingleScheduler-1]	| 1
[RxSingleScheduler-1]	| 2
[RxSingleScheduler-1]	| 3
```

> * 'RxSingleScheduler-1' 스레드는 하나만 존재한다.
> * `sync` 객체의 작업은 `subscribeOn()`으로 지정해도 **single** scheduler에서 정상적으로 실행 되었다.
> * `async` 객체의 작업은 `subscribeOn()`으로 지정한 **single** scheduler에서 실행되지 않고 default scheduler에서 실행되었다.
> * `async` 객체라도 `observeOn()`으로 지정하여 수신 작업을 **single** scheduler에서 실행되도록 지정할 수 있다.

#### Schedulers.trampoline()

* 현재 스레드에 작업 큐를 만들어 작업을 큐에 넣고 하나씩 실행하는 scheduler이다. 
* 어차피 비동기 작업들은 scheduler를 따로 지정하지 않아도 현재 스레드에서 작업이 진행되고 
`interval()` 같은 비동기 작업들은 trampoline() 으로 설정해도 효과가 없다. 
* 실제로는 `repeat()`, `retry()` 같은 재귀적인 동작을 구현하기 위해서 사용되는 scheduler이며
일반적으로는 거의 사용할 일이 없다. (RxJava 개발자가 직접 한 얘기임.) 인터넷 상의 예제들도 trampoline()을 지정하지 않아도 그대로 동작하는 것들 뿐이다.

#### Schedulers.from(executor)

* Java의 Executor 객체를 scheduler로 사용하도록 한다. 
* 이미 사용중인 Executor 객체를 재사용하는 경우에는 의미가 있지만 기본 제공하는 scheduler만으로 충분하기 때문에 특별히 사용할 일은 없다.

```java
log("current");

Executor executor = Executors.newFixedThreadPool(4);

Observable<Long> src1 = Observable.interval(0L, 100L, TimeUnit.MILLISECONDS)
    .map(val -> val * 2).take(3);
Observable<Long> src2 = Observable.interval(50L, 100L, TimeUnit.MILLISECONDS)
    .map(val -> (val * 2) + 1).take(3);

src1.observeOn(Schedulers.from(executor))
    .subscribe(Main::log);
src2.observeOn(Schedulers.from(executor))
    .subscribe(Main::log);
```

```
[main]	| current
[pool-1-thread-1]	| 0
[pool-1-thread-2]	| 1
[pool-1-thread-3]	| 2
[pool-1-thread-4]	| 3
[pool-1-thread-1]	| 4
[pool-1-thread-2]	| 5
```

> * 스레드풀에 생성된 4개의 스레드 중에 어떤 스레드와 특별히 연관성 없이 고르게 사용된다.
