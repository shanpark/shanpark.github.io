## while

---

### 1. while

```java
int inx = 0;
while (inx < 10) {
    System.out.println(inx);
    inx++;
}
```

### 2. do while

```java
int inx = 0;
do {
    System.out.println(inx);
    inx++;
} while (inx < 10);
```

### 3. Using Iterator

```java
List<String> list = Arrays.asList("foo", "bar");

Iterator<String> it = list.iterator();
while (it.hasNext()) {
    System.out.println(it.next());
}
```
