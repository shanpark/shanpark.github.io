## Observable

---

### 1. Observable 개요

Observer 패턴은 엄격하게 말하면 Pub/Sub 패턴과는 다르지만 `Observable`은 Publisher, `Observer`는 Subscriber와 그 역할이 같다. 그러므로 값을 생성(방출)하고, 값을 수신하는 동작에 대한 용어로는 publish, subscribe라는 용어를 사용하도록 하겠다.

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

> * `Observable` 객체는 데이터를 생성하는 publisher 역할을 하는 객체다.
> * `Observer`는 데이터를 수신하는 subscriber 역할을 하는 객체다.
> * `Observer` 객체를 생성하지 않고 `subscribe()` 메소드에 `onNext`, `onError`, `onComplete` 함수를 직접 전달하는 여러 버전의 `subscribe()`가 제공된다. 이러한 `subscribe()` 메소드는 `Disposable` 객체를 반환한다. 위 예제의 `subscribe()`는 `onSubscribe()`의 파라미터로 전달되므로 `Disposable` 객체를 반환하지 않는다.
> * 전달된(반환된) `Disposable` 객체를 사용하여 언제든지 subscribe를 취소할 수 있다.

### 2. Observable basics

여기서 소개된 모든 예제들은 scheduler 없이 실행되는 것들이다. 즉 모두 현재 스레드에서 실행된다.  
아래 예제에서 fromFuture() 조차도 subscribe에 전달되는 onNext 함수는 현재 스레드에서 실행된다.

#### create()

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

단 한 개의 값만을 publish하는 변형된 observable이다.

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

> * 단 한 개의 값만이 publish되는 경우 사용한다.
> * `Observable`의 `single()` 메소드는 `Single` 객체로 변환해준다.
> * 값이 없는 경우 default 값을 publish한다.
> * 2개 이상의 값을 publish하는 경우 exception이 발생한다.
> * `Single`의 경우 `Observer`가 아니라 `SingleObserver` 객체를 사용하여 subscribe를 한다. 참고로 `SingleObserver`는 `onNext` 대신 `onSuccess`가 사용되며 `onComplete`는 없다. 

### 4. Maybe

* `Single`과 비숫하지만 값을 0개 또는 1개의 값만 publish하는 observable이다. 
* `MaybeObserver` 객체가 observer가 된다. `MaybeObserver`는 `SingleObserver`에 `onComplete`가 더 있다.
* 직접 생성해서 사용할 수 있지만 그런 경우는 드물고 `reduce()` 메소드 같이 0개 또는 1개의 결과를 생성하는 함수가 결과를 반환하기 위한 용도로 사용한다.

### 5. ConnectableObservable

```
ConnectableObservable<Integer> observable = Observable.just(100, 200, 300).publish();
observable.subscribe(data -> System.out.println("Subscriber #1:" + data));
observable.connect(); // begin publishing
```

* 일반적인 `Observable`의 경우 `subscribe()`가 호출되면 publish를 시작한다. 하지만 `ConnectableObservable`은 publish를 시작하지 않고 기다렸다가 `connect()`가 호출되면 시작한다. 
* 모든 observer들이 등록될 때 까지 기다린다던가 특정 observer를 기다리는 동작이 필요한 경우에 사용될 수 있다. 
* `Observable`의 `publish()` 메소드로 생성된다.
* 위 예제는 특별히 `ConnectableObservable`이 필요한 경우는 아니지만 debugger를 통해서 따라가 보면 `connect()` 시점에 publish가 시작되는 걸 볼 수 있다.
