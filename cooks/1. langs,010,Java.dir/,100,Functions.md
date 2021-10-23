## Functions

---

Java는 global function의 개념은 없다. 특정 클래스의 메소드로서의 function만이 존재하므로 static 메소드를 정의하여 global function의 처럼 구현이 가능하다.

### 1. Funcions (Methods)

다른 언어대비 Java는 다음과 같은 특징이 있다.
* default parameter를 지원하지 않는다.
* named parameter나 parameter label을 지원하지 않는다.
* Java에서는 method가 일급 객체가 아니기 때문에 함수 타입은 지원하지 않는다.

```java
class SomeCloass {
    public int add(int x, int y) {
        return x + y;
    }

    public <T> void print(T x) {
        System.out.println(x.toString());
    }

    public void printSome(int... vals) {
        for (int val : vals) {
            System.out.println(val);
        }
    }
}
```

> * 일반적인 메소드 선언은 C언어의 함수 모양과 크게 다르지 않다.
> * Generic 메소드의 선언도 가능하다.
> * varargs는 타입 뒤에 `...`을 붙여서 선언하며 parameter를 사용할 때는 array 타입으로 취급된다.
> * 메소드는 1개 이상의 varargs를 가질 수 없고 Varargs는 메소드의 마지막 parameter이어야 한다.