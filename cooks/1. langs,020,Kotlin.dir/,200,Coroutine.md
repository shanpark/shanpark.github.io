## Coroutine

---

### 1. CoroutineContext

Coroutine은 항상 CoroutineContext 인터페이스로 정의된 어떤 context 안에서 실행된다.

CoroutineContext는 개념적으로는 단순한 것 같지만 코드를 보면 상당히 이해가 힘들다.

CoroutineContext는 여러 요소(Element)들로 이루어져 있으며 이 요소들은 마치 Map처럼 각 요소의 고유한 key값으로 access를 할 수 있도록 되어있다. 

CoroutineContext를 이루는 요소들은 Element 인터페이스를 구현한고 각 타입별로 고유한 key값이 존재한다. 그런데 여기서 특이한 것은 Element 인터페이스는 다시 CoroutineContext interface를 구현하고 있다는 것이다.
즉, CoroutineContext는 자신을 이루는 여러 요소를 갖는데 그 요소들 또한 스스로 CoroutineContext를 이룰 수 있다.

CoroutineContext의 요소는 `CoroutineDispatcher`, `Job`, `CoroutineName`, `CoroutineId` 같은 것들이 있는데 이것들도 모두 `CoroutineContext`(`Element`)를 구현한다.

이렇게 구현된 이유는 각 요소들을 결합하여 새로운 context를 생성하는 방식을 구현하기 위해서이다. CoroutineContext는 plus(+) 연산자를 overloading하여 여러 CoroutineContext를 조합해서 새로운 CoroutineContext를 만들 수 있도록 한다.
종종 특정 CoroutineDispatcher와 Job 또는 CoroutineName 등의 요소를 더해서 CoroutineContext로 넘기는 코드를 볼 수 있는데 바로 이런 특성 때문에 가능한 것이다.

새로 생성된 CoroutineContext는 당연히 더해진 요소들을 가지고 있으며 현재 가진 요소와 plus()의 파라미터로 받은 context의 요소가 중복된다면 파라미터의 요소가 현재 요소보다 우선이다.

아래 샘플 코드는 `Dispatchers.Default`와 `CoroutineName`을 조합한 CoroutineContext를 가지고 `launch()`를 호출하는 샘플 코드이다.

```kotlin
launch(Dispatchers.Default + CoroutineName("test")) {
    println("I'm working in thread ${Thread.currentThread().name}")
}
```

![Coroutine_01.png](Coroutine_01.png)

각각의 요소를 `+` 연산자를 이용해 연결하고 있는데 이는 앞서 설명한 것처럼CoroutineContext가 plus 연산자를 구현하고 있기 때문이며 결국 하나로 병합된 CoroutineContext를 만들어낸다.

위 이미지는 우리가 `GlobalScope.launch()` 를 수행할 때 launch 함수의 첫번째 파라미터인 CoroutineContext에 어떤 값을 넘기는지에 따라서 변화되어 가는 CoroutineContext의 상태를 보여준다.

> 주황색 테두리는 CombinedContext로서 CoroutineContext와 Element를 묶어 하나의 CoroutineContext가 되는 개념이다. 그리고 내부 코드에서 ContinuationInterceptor는 이 병합 작업이 일어날 때 항상 마지막에 위치하도록 고정되는데 이는 인터셉터로의 빠른 접근을 위해서라고 커멘트 되어 있다.

```kotlin
var coroutineContext: CoroutineContext = Dispatchers.Main + Job()
var coroutineContext: CoroutineContext = Dispatchers.Default + CoroutineName("net")
```
위와 같은 방식으로 여러가지 조합으로 얼마든지 CoroutineContext를 생성할 수 있으며 지정되지 않은 요소는

### 2. CoroutineScope

CoroutineScope의 코드를 보면 CoroutineContext 하나만 멤버로 정의하는 interface이다. 이것만으로는 CoroutineContext와 비숫한 것이 아닌가 하여 개념을 잡기가 쉽지않다.

CoroutineScope의 Scope를 개념적으로 간단하게 얘기하자면 coroutine이 실행되는 **시간적인 범위**를 말한다.

launch, async 같은 coroutine 빌더 함수나 coroutineScope, withContext 등의 scope 빌더 함수들은 CoroutineContext가 아니라 CoroutineScope의 확장함수로 정의되어있다. 즉 이 함수들이 coroutine을 생성할 때는 CoroutineScope의 CoroutineContext를 기반으로 생성하고 이 coroutine이 실행되는 동안이 scope가 된다.

이렇게 보면 CoroutineScope가 별 의미가 없어보이지만 어떤 coroutine내에서 자식 coroutine을 생성했을 때의 동작을 보면 여러가지 의미가 있음을 알 수 있다.

* coroutine 내에서 다른 coroutine을 생성하면 특정 scope를 지정해서 생성하지 않는 한, 생성된 coroutine은 부모 coroutine으로부터 CoroutineScope를 상속받는다.
* 부모 coroutine은 자식 coroutine들이 모두 종료될 때 까지 종료되지 않는다. 즉, 자식 coroutine의 job으로 `join()` 등을 호출하여 기다릴 필요가 없다.
* 부모 coroutine의 job을 `cancel()`하면 그 자식 coroutine들도 모두 같이 `cancel()`된다.

이런 특성으로 인하여 여러 비동기 작업을 특정 객체의 lifecycle에 맞추는 게 매우 간단하게 구현될 수 있다.

```kotlin
class MyActivity : AppCompatActivity(), CoroutineScope {
  lateinit var job: Job
  override val coroutineContext: CoroutineContext
  get() = Dispatchers.Main + job

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    job = Job()
  }
  
  override fun onDestroy() {
    super.onDestroy()
    job.cancel() // Cancel job on activity destroy. After destroy all children jobs will be cancelled automatically
  }

 /*
  * Note how coroutine builders are scoped: if activity is destroyed or any of the launched coroutines
  * in this method throws an exception, then all nested coroutines are cancelled.
  */
  fun loadDataFromUI() = launch { // <- extension on current activity, launched in the main thread
    val ioData = async(Dispatchers.IO) { // <- extension on launch scope, launched in IO dispatcher
      // blocking I/O operation
    }

    // do something else concurrently with I/O
    val data = ioData.await() // wait for result of I/O
    draw(data) // can draw in the main thread
  }
}
```

위 코드에서 MyActivity는 CoroutineScope를 구현하고 있고 따라서 멤버로 CoroutineContext를 갖는다.

CoroutineContext의 job을 activity의 lifecycle과 맞춰서 `onCreate()`와 `onDestroy()`에서 생성과 `cancel()` 을 호출하고 있다. 이렇게 자신의 scope를 제한함으로써 `loadDataFromUI()`의 `launch()`가 생성하는 coroutine이 activity와 운명을 같이할 수 있도록 하고있으며 그 안에서 I/O 작업을 위해 `async()`로 생성된 coroutine도 모두 activity의 lifecycle에 맞춰서 실행이 제한되도록 하고있다.

여기서 한 가지 눈여겨 보아야 할 것은 async로 생성된 coroutine은 `Dispatchers.Main`이 아니라 `Dispatchers.IO`를 사용한다는 것이다. 이렇게 다른 Dispatcher(공간적 범위)를 사용하더라도 상속된 CoroutineScope(시간적 범위)의 제한은 여전히 유효하며 activity의 lifecycle에 맞춰서 실행이 제한 된다.

만약 여기서 자신의 `async()`가 아니라 `GlobalScope.async()`와 같이 다른 scope로 coroutine을 생성했다면 생성된 coroutine의 scope는 GlobalScope이므로 activity가 종료되더라도 coroutine은 계속 살아있게 된다.

CoroutineScope는 위 Activity 예제와 같이 직접 구현할 수도 있고 다음 코드와 같이 CoroutineContext를 만들어서 생성자에 넘겨주어 간단히 생성할 수도 있다.

```kotlin
var coroutineContext: CoroutineContext = Dispatchers.Main + Job()
var coroutineScope = CoroutineScope(CoroutineContext)
var job = coroutineScope.launch {
  ...
}
```

#### GlobalScope

앞에서 언급한 `GlobalScope`는 coroutine 라이브러리에 정의된 singleton 객체로 `EmptyCoroutineContext`를 context 멤버로 가지고 있다. 
* `EmptyCoroutineContext`도 역시 singleton 객체로 어떤 요소(Element)도 가지고 있지 않은 빈 context 객체이다. 

이렇게 빈 context로 실행된 coroutine은 실행을 제한하는 요소가 아무 것도 없으므로 process 전체 lifetime 동안 계속 실행될 수 있다.

많은 문서에서 GlobalScope의 사용을 자제하도록 권고하는데, 이렇게 범위가 특정되지 않고 계속 살아있는 coroutine은 작업을 마치고 나서 제대로 종료되지 않으면 메모리 등의 자원을 점유한 채로 계속 유지가 되기 때문에 process의 자원을 갉아먹는 memory leak의 원인이 된다. 따라서 process가 끝날 때 까지 실행되는 작업이 아니라면 사용을 자제하는 것이 좋다.