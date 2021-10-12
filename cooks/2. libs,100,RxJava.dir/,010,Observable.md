## Observable

---

### 1. Observable 개요

Observer 패턴은 엄격하게 말하면 Pub/Sub 패턴과는 다르지만 `Observable`은 Publisher, `Observer`는 Subscriber와 그 역할이 같다.
그러므로 값을 발생(publish) 시키고, 값을 받는(subscribe) 동작에 대해서 값을 **발행**과 **수신**이라는 용어를 사용하도록 하겠다.

observable 객체는 `subscribe()`가 호출되기 전에는 값을 발행하는 작업을 하지 않는다. 즉, `subscribe()`가 호출되기 전에는 그저 값을 어떻게 발행할 
것인지를 정의하는 과정일 뿐이고 `subscribe()`가 호출되면 그 때부터 정의된 작업이 시작된다. 함수형 프로그래밍 기법에서는 이 개념이 중요하다.

따라서 이미 `subscribe()`를 호출한 observable 객체를 다시 `subscribe()`해도 똑같은 작업이 다시 시작될 뿐 아무 문제가 없다.
이미 시작된 작업을 중지 시키려면 `subscribe()`가 반환하는 `Disposable` 객체의 `dispose()` 메소드를 호출한다.

```java
Observer<Integer> observer = new Observer<>() {
    @Override
    public void onSubscribe(@NonNull Disposable d) {
        System.out.println("onSubscribe !!");
    }

    @Override
    public void onNext(@NonNull Integer integer) {
        System.out.println(integer);
    }

    @Override
    public void onError(@NonNull Throwable e) {
        System.out.println(e.getLocalizedMessage());
    }

    @Override
    public void onComplete() {
        System.out.println("onComplete !!");
    }
};

Observable
    .just(100, 200, 300)
    .subscribe(observer);
```

> * `Observable` 객체는 데이터를 발행하는 publisher 역할을 하는 객체다.
> * `Observer`는 데이터를 수신하는 subscriber 역할을 하는 객체다.
> * `Observer` 객체를 생성하지 않고 `subscribe()` 메소드에 `onNext`, `onError`, `onComplete` 함수를 직접 전달하는 
여러 버전의 `subscribe()`가 제공된다. 이러한 `subscribe()` 메소드는 `Disposable` 객체를 반환한다. 하지만 위 예제의 `subscribe()`는 `onSubscribe()`의 파라미터로 `Disposable` 객체가 전달되므로 `Disposable` 객체를 반환하지 않는다.
> * 전달된(반환된) `Disposable` 객체를 사용하여 언제든지 발행/수신 작업을 중단시킬 수 있다.

### 2. Observable basics

여기서 소개된 모든 예제들은 scheduler 없이 실행되는 것들이다. 즉 모두 현재 스레드에서 실행된다.
아래 예제에서 fromFuture() 조차도 observer의 onNext 함수는 현재 스레드에서 실행된다.

Observable 클래스는 다양한 메소드를 가지고 있다. 아래 링크 참조.

* [https://reactivex.io/documentation/operators.html](https://reactivex.io/documentation/operators.html)

#### create()

가장 기본이 되는 생성 메소드이다. 다른 메소드들이 내부적으로 어떤 식으로 구현될 지 가늠할 수 있으므로 명확하게 이해하도록 하자.
파라미터로 emitter를 전달 받아서 `onNext()`로 값을 발행하고 완료가 되면 `onComplete()`를 호출해줘야 한다.

가장 기본적인 메소드인 만큼 다른 observable 생성 메소드들은 create() 메소드를 이용해서 만들 수 있다. 
`subscribeOn()`으로 특정 scheduler를 지정하지 않는 한 create에 지정된 함수 객체는 현재 스레드에서 실행된다.
즉, `subscribeOn()`으로 지정된 scheduler에서 create에 지정한 함수 객체가 실행된다는 뜻이며
observable의 시작 스레드와 `subscribeOn()` 메소드의 연관 관계와 동작 방식을 여기서 유추해 볼 수 있다.

```java
Observable.create(emitter -> {
        emitter.onNext(100);
        emitter.onNext(200);
        emitter.onNext(300);
        emitter.onComplete();
    })
    .subscribe(System.out::println);
```

#### just()

```java
Observable.just(100, 200, 300)
    .subscribe(System.out::println);
```

#### fromArray()

```java
Integer[] arr = {100, 200, 300};

Observable.fromArray(arr)
    .subscribe(System.out::println);
```

#### fromIterable()

```java
List<Integer> list = Arrays.asList(100, 200, 300);

Observable.fromIterable(list)
    .subscribe(System.out::println);
```

#### fromCallable()

```java
Callable<Integer> callable = () -> {
    Thread.sleep(3000L);
    return 100;
};

Observable.fromCallable(callable)
    .subscribe(System.out::println);
```

#### fromFuture()

```java
Future<Integer> future = Executors.newSingleThreadExecutor().submit(() -> {
    Thread.sleep(3000L);
    return 100;
});

Observable.fromFuture(future)
    .subscribe(System.out::println);
```

#### fromPublisher()

```java
Publisher<Integer> publisher = (s) -> {
    s.onNext(100);
    s.onComplete();
};

Observable.fromPublisher(publisher)
    .subscribe(System.out::println);
```

### 3. Single

단 한 개의 값만을 발행하는 observable 객체이다.

```java
Single.just("hello")
    .subscribe(System.out::println);

Observable.just("one", "two")
    .take(1)
    .single("default")
    .subscribe(System.out::println);

Observable.empty()
    .single("default")
    .subscribe(System.out::println);
```

> * 단 한 개의 값만이 발행되는 경우 사용한다.
> * `Observable`의 `single()` 메소드는 `Single` 객체로 변환해준다.
> * 값이 없는 경우 default 값을 발행한다.
> * 2개 이상의 값을 발행하려고 하는 경우 exception이 발생한다.
> * `Single`의 경우 subscriber로 `Observer`가 아니라 `SingleObserver` 객체를 사용한다. 
참고로 `SingleObserver`는 `onNext` 대신 `onSuccess`가 사용되며 `onComplete`는 없다. `onSuccess`, `onError` 둘 중에 하나가 발생하면 무조건 '완료'이기 때문이다.

### 4. Maybe

* `Single`과 비숫하지만 값을 0개 또는 1개의 값만 발행하는 observable이다. 
* `MaybeObserver` 객체가 observer가 된다. `MaybeObserver`는 `SingleObserver`에 `onComplete`가 더 있다. 값이 없는 경우에 바로 `onComplete`가 발생한다.
* 직접 생성해서 사용할 수 있지만 그런 경우는 드물고 `reduce()` 메소드 같이 0개 또는 1개의 결과를 생성하는 함수가 결과를 반환하기 위한 용도로 사용한다.

### 5. ConnectableObservable

```
ConnectableObservable<Integer> observable = Observable.just(100, 200, 300).publish();
observable.subscribe(data -> System.out.println("Subscriber #1:" + data));
observable.connect(); // begin publishing
```

* 일반적인 `Observable`의 경우 `subscribe()`가 호출되면 발행 작업을 시작한다. 하지만 `ConnectableObservable`은 `subscribe()` 호출돼도 작업을 시작하지 않고 기다렸다가 `connect()`가 호출되면 시작한다. 
* 모든 observer들이 등록될 때 까지 기다린다던가 특정 observer를 기다리는 동작이 필요한 경우에 사용될 수 있다. 
* `Observable`의 `publish()` 메소드로 생성된다.
* 위 예제는 특별히 `ConnectableObservable`이 필요한 경우는 아니지만 debugger를 통해서 따라가 보면 `connect()` 시점에 발행이 시작되는 걸 볼 수 있다.
