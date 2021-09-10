# JAVA

## while

### 1. while

```
int inx = 0;
while (inx < 10) {
    System.out.println(inx);
    inx++;
}
```

### 2. Infinite loop

```
while (true) {
    ...
}
```

### 3. Using Iterator

```
List<String> list = Arrays.asList("foo", "bar");

Iterator<String> it = list.iterator();
while (it.hasNext()) {
    System.out.println(it.next());
}
```
