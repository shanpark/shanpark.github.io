## switch

---

### 1. switch

```swift
let someCharacter: Character = "z"

switch someCharacter {
case "a", "A":
    print("The first letter of the alphabet")
case "z":
    print("The last letter of the alphabet")
default:
    print("Some other character")
}
// Prints "The last letter of the alphabet"
```

> * C언어와 달리 break문은 필요없다.
> * 하나의 `case`에 여러 개의 값을 지정할 수 있다. 그 중에 하나의 값과 같으면 실행된다.
> * 각 `case`문은 반드시 한 개 이상의 실행문장을 포함해야 한다. 빈 case가 꼭 필요한 경우 break를 넣도록 한다.
> * 숫자, 문자열 등 비교가능한 타입들은 모두 가능하다.

```swift
let approximateCount = 62
let countedThings = "moons orbiting Saturn"
let naturalCount: String

switch approximateCount {
case 0:
    naturalCount = "no"
case 1..<5:
    naturalCount = "a few"
case 5..<12:
    naturalCount = "several"
case 12..<100:
    naturalCount = "dozens of"
case 100..<1000:
    naturalCount = "hundreds of"
default:
    naturalCount = "many"
}

print("There are \(naturalCount) \(countedThings).")
// Prints "There are dozens of moons orbiting Saturn."
```

> * `case`문에 Range 연산자를 사용하여 구간을 지정할 수 있다.

```swift
let somePoint = (1, 1)

switch somePoint {
case (0, 0):
    print("\(somePoint) is at the origin")
case (_, 0):
    print("\(somePoint) is on the x-axis")
case (0, _):
    print("\(somePoint) is on the y-axis")
case (-2...2, -2...2):
    print("\(somePoint) is inside the box")
default:
    print("\(somePoint) is outside of the box")
}
// Prints "(1, 1) is inside the box"
```

> * tuple을 사용하여 다양한 방법으로 matching을 구현할 수 있다.

```swift
let anotherPoint = (2, 0)

switch anotherPoint {
case (let x, 0):
    print("on the x-axis with an x value of \(x)")
case (0, let y):
    print("on the y-axis with a y value of \(y)")
case let (x, y):
    print("somewhere else at (\(x), \(y))")
}
// Prints "on the x-axis with an x value of 2"
```

> * **Value binding**으로 `case` 내에서 유효한 임시 local 상수를 선언할 수 있다. 임시 상수는 matching되는 값으로 초기화된다.

```swift
let yetAnotherPoint = (1, -1)

switch yetAnotherPoint {
case let (x, y) where x == y:
    print("(\(x), \(y)) is on the line x == y")
case let (x, y) where x == -y:
    print("(\(x), \(y)) is on the line x == -y")
case let (x, y):
    print("(\(x), \(y)) is just some arbitrary point")
}
// Prints "(1, -1) is on the line x == -y"
```

> * `case`에 `where` 구문으로 추가적인 조건을 지정할 수 있다.

```swift
let integerToDescribe = 5
var description = "The number \(integerToDescribe) is"

switch integerToDescribe {
case 2, 3, 5, 7, 11, 13, 17, 19:
    description += " a prime number, and also"
    fallthrough
default:
    description += " an integer."
}

print(description)
// Prints "The number 5 is a prime number, and also an integer."
```

> * 다음 case문으로 실행을 이어가도록 강제로 지정하려면 `fallthrough`문을 사용한다.
