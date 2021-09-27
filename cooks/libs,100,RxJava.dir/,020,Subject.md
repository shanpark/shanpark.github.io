## Subject

---

### 1. Subject

Subject는 Observable이기도 하고 Observer이기도 한 객체를 구현하기위한 class로서 하나의 source에서 발생하는 값들을 여러 observer에게 multicast하는 용도로 사용한다.

### 2. PublishSubject

가장 직관적인 `Subject`이다. 자신의 `Observable` 객체가 publish한 값을 자신의 `Observer`들에게 그대로 publish한다.

```java
Subject<Integer> subject = PublishSubject.create();

Observable<Integer> source = Observable.create(emitter -> {
    emitter.onNext(100);

    subject.subscribe(data -> System.out.println("Subscriber #1:" + data));
    emitter.onNext(200); // Subscriber #1

    subject.subscribe(data -> System.out.println("Subscriber #2:" + data));
    emitter.onNext(300); // Subscriber #1, #2

    emitter.onComplete();
});

source.subscribe(subject); // publish 시작.
```

> * 최초에 subject에 observer가 하나도 없는 상태에서 publish된 100은 전달할 observer가 없으므로 무시된다.
> * 그 후에 등록된 *Subscriber #1*은 200, 300을 모두 받는다.
> * 200이후에 등록된 *Subscriber #2*은 300만 받는다.
> * 결론적으로 subject에 observer로 등록되면 그 이후에 publish된 값들만 받는다. 가장 직관적인 Subject이다.

### 3. AsyncSubject

자신이 subscribe하는 `Observable` 객체가 publish를 끝내면 즉시 마지막 값을 자신의 `Observer`들에게 publish한다.

```java
// AsyncSubject 생성
Subject<Integer> subject = AsyncSubject.create();

// source observable 생성
Observable<Integer> source = Observable.create(emitter -> {
    emitter.onNext(100); // (2)
    emitter.onNext(200);

    subject.subscribe(data -> System.out.println("Subscriber #1:" + data)); // 완료 전 등록

    emitter.onNext(300);
    emitter.onComplete(); // (3)

    subject.subscribe(data -> System.out.println("Subscriber #2:" + data)); // 완료 후 등록
});

// subject를 source의 observer로 등록.
source.subscribe(subject); // (1)
```

> * data의 원천이 되는 되는 `Observer`(source)와 source를 subscribe할 `Subject`를 생성하고 source에 subject를 observer로 등록한다.(1)
> * subject로 subscribe가 시작(1)되면 source는 값을 publish하기 시작(2)한다.
> * source의 publish가 끝(3)나면 subject는 즉시 마지막 값(300)을 자신의 observer에게 publish한다.
> * source의 publish가 완료되기 전에 등록된 observer도 완료가 된 후에 300을 받고, 완료가 된 후에 등록된 observer도 마지막 값(300)을 받는다. 결국 Subscriber #1, #2 모두 300 수신.

### 4. BehaviorSubject

`PublishSubject`와 비숫하지만 다른 점은 subject에 `Observer`가 새로 등록되면 그 이전에 자신의 `Observable` 객체로부터 수신된 가장 최신 값을 publish해 준다는 것이다. 등록 이후에 수신되는 값들은 `PublishSubject`와 같다. 등록 시에 최신 값이 없는 경우에는 default 값을 publish한다.

```java
Subject<Integer> subject = BehaviorSubject.createDefault(0);

Observable<Integer> source = Observable.create(emitter -> {
    subject.subscribe(data -> System.out.println("Subscriber #0:" + data));

    emitter.onNext(100);
    subject.subscribe(data -> System.out.println("Subscriber #1:" + data));

    emitter.onNext(200);
    subject.subscribe(data -> System.out.println("Subscriber #2:" + data));

    emitter.onNext(300);
    emitter.onComplete();
});

source.subscribe(subject); // publish 시작.
```

> * PublishSubject와 거의 비숫하지만 `createDefault()` 메소드로 default 값을 지정해서 생성한다.
> * *Subscriber #0*의 경우 이전 값이 없으므로 최초에 default 값인 0을 받고 이후 publish되는 모든 값을 받는다.
> * *Subscriber #2*는 200이 publish된 이후에 등록되었지만 이전 마지막 값이 200이므로 최초에 200을 받고 그 이후에 publish된 모든 값을 받는다.
> * Observer가 등록되면 직전 최신 값을 publish해준다는 차이점 말고는 PublishSubject와 같다.

### 5. ReplaySubject

`BehaviorSubject`와 비숫하지만 다른 점은 subject에 `Observer`가 등록되면 가장 최신값 하나만 publish하는 게 아니라 등록되기 전에 publish된 모든 값을 새로 등록된 observer에게 publish해준다는 것이다. 등록 이후에 수신되는 값들은 `PublishSubject`와 같다.

```java
Subject<Integer> subject = ReplaySubject.create();

Observable<Integer> source = Observable.create(emitter -> {
    subject.subscribe(data -> System.out.println("Subscriber #0:" + data));
    emitter.onNext(100);

    subject.subscribe(data -> System.out.println("Subscriber #1:" + data));
    emitter.onNext(200);

    subject.subscribe(data -> System.out.println("Subscriber #2:" + data));
    emitter.onNext(300);

    emitter.onComplete();
});

source.subscribe(subject); // publish 시작.
```

> * *Subscriber #2*는 등록 직후 100, 200을 받고 300은 publish되는 시점에 받는다.
> * 등록 시점에 따라 수신 시점은 다르지만 Subscriber #0, #1, #2 모두 결국에는 100, 200, 300을 모두 수신한다.
