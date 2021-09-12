# Java

## Console output

많은 print 함수들이 내장되어 있지만 다음 2가지가 가장 많이 사용된다.

### 1. System.out.println()

```java
long num = 3;

System.out.println("Hello World!"); // "Hello World!\n"
System.out.println("The answer is " + num + "."); // "The answer is 3.\n"
```

### 2. System.out.format()

```java
System.out.format("The answer is %d.%n", num); // "The answer is 3.\n"
```

> ❗ 시스템마다 new line 문자를 달리하기 때문에 format()을 사용할 때 new line 문자는 '\n' 보다 %n을 쓴다.

