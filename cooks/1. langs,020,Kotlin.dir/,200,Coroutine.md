## Coroutine

---

### 1. CoroutineContext

Coroutine은 항상 CoroutineContext 인터페이스로 정의된 어떤 context에서 실행된다. 즉 Coroutine은 항상 자신과 연관된 coroutineContext를 갖는다.

CoroutineContext는 개념적으로도 이해가 힘들지만 이것들을 다루는 코드들을 봐도 상당히 이해가 가지 않는 부분이 많이 있다. 이런 부분에 대해서 
자세한 설명을 하려고 하므로 정확히 이해하도록 하자.

CoroutineContext는 여러 요소(Element)들을 갖는 Map같은 형태로 이루어지는데 CoroutineContext를 이루는 요소들은 AbstractCoroutineContextElement을 상속받으며 
AbstractCoroutineContextElement는 Element 인터페이스를 구현한다. 그런데 여기서 Element는 다시 CoroutineContext interface를 구현하고 있다.
설명이 복잡하지만 간략하게 그려보면 아래 그림과 같다.

[]()

즉, CoroutineContext는 자신을 이루는 여러 요소를 갖는데 그 요소들 또한 스스로 CoroutineContext를 이룰 수 있는 것들이다. 

CoroutineContext의 주요 요소는 CoroutineDispatcher, Job 같은 것들이 있는데 이것들도 모두 AbstractCoroutineContextElement을 상속받고 있으므로 CoroutineContext이기도 하다.

한 가지 요소만 가지고 CoroutineContext로 이용할 수도 있지만 여러 요소를 조합하여 CoroutineContext를 생성한다.

CoroutineContext는 plus(+) 연산자를 overloading하여 여러 CoroutineContext를 조합해서 새로운 CoroutineContext를 만들 수 있도록 한다.
종종 특정 CoroutineDispatcher와 Job 또는 CoroutineName 등을 더해서 새로운 CoroutineContext를 생성하여 사용하는 코드가 보이는 이유는 바로 이런 특성 때문이다.
새로 생성된 CoroutineContext는 당연히 더해진 요소들을 가지고 있다.

다음 코드는 Dispatchers.Default와 CoroutineName을 조합한 CoroutineContext를 가지고 launch()를 호출하는 샘플 코드이다.

```kotlin
launch(Dispatchers.Default + CoroutineName("test")) {
    println("I'm working in thread ${Thread.currentThread().name}")
}
```
