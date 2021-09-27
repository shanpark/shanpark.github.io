## switch

---

### 1. switch (Integer, String)

```java
int num = 2;
String numStr = "";

switch (num) {
    case 1:
        numStr = "one";
        break;
    case 2:
        numStr = "two";
        break;
    default:
        numStr = "big number.";
        break;
}
```

### 2. switch (Enum)

```java
enum Num {
    ONE, TWO, THREE
}

...

Num num = Num.ONE;
String numStr = "";
switch (num) {
    case ONE:
        numStr = "one";
        break;
    case TWO:
        numStr = "two";
        break;
    default:
        numStr = "big number.";
        break;
}
```