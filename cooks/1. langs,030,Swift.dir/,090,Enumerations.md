## Enumerations

---

### 1. Enum basics

```swift
enum Direction {
    case north
    case south
    case east
    case west
}

enum Order {
    case first, second, third
}

var dir: Direction = .north
var order = Order.first

print(dir) // north
print(order) // first

switch (dir) {
case .north:
    print("North !!")
default:
    print("Not north !!")
}
```

### 2. Enum iterating

```swift
enum Beverage: CaseIterable {
    case coffee, tea, juice
}

let numberOfChoices = Beverage.allCases.count // 3

for beverage in Beverage.allCases {
    print(beverage)
}
```

> * enum을 CaseIterable을 구현하도록 하면 모든 case 값을 Array 타입으로 access 할 수 있는 `allCases` 속성이 생긴다. 위 예제에서 `Beverage.allCases`는 [Beverage] 타입이 된다.

### 2. Enum (Raw values)

```swift
enum Beverage: String {
    case coffee, tea, juice = "orange juice"
}

print(Beverage.coffee.rawValue) // coffee
print(Beverage.juice.rawValue) // orange juice

enum Order: Int {
    case first, second, third
}

print(Order.first.rawValue) // 0

enum OrderFromOne: Int {
    case first, second = 10, third
}

print(OrderFromOne.first.rawValue) // 0
print(OrderFromOne.third.rawValue) // 11
```

> * enum을 특정 타입을 상속하도록 선언하여 각 값의 `rawValue` 속성을 갖도록 할 수 있다.
> * 각 enum 값에 상속한 타입의 값을 지정하여 `rawValue` 값을 지정한다.
> * Int, String의 경우에는 값을 직접 지정하지 않아도 암묵적으로 값이 할당된다.
>    * Int - 암묵적으로 0, 1, 2 값이 차례대로 할당된다. 어느 한 enum 값에 Int값이 지정되면 그 뒤의 값들은 차례대로 1씩 증가한 값을 갖는다.
>    * String - 암묵적으로 각 enum 값의 이름을 rawValue로 할당한다.

```swift
enum Order: Int {
    case first, second, third
}

var order = Order(rawValue: 2);
print(order!) // third
```

> * rawValue를 이용하여 enum 값을 가져올 수 있다.

### 3. Enum (Associated values)

```swift
enum AppleDevice {
    case iPhone(model: String, storage: Int) // named tuple
    case iMac(size: Int, model: String, price: Int)
    case macBook(String, Int, Int) // unnamed tuple
}

var gift = AppleDevice.iPhone(model: "X", storage: 256)

switch gift {
// 특정 associated value와 matching
case .iPhone(model: "X", storage: 256):
    print("iPhone X and 256GB")

// 일부 속성만 matching
case .iPhone(model: "X", _):
    print("iPhone X")

// case 내부에서 associated value를 사용할 땐 value binding. `let`, `var` 모두 가능
case .iPhone(let model, let storage):
    print("iPhone \(model) and \(storage)GB")

...

}
```

> * raw value와 달리 각 case 마다 다른 타입을 지정할 수 있고 값도 한 가지 값이 아니라 여러 가지 값을 가질 수 있다.
> * switch문과 함께 다양한 방식으로 matching이 가능하다. 예제에는 없지만 associated value없이 `.iPhone`만 지정하여 사용해도 아무 상관이 없다.

```swift
enum VendingMachineError: Error {
    case invalidSelection
    case insufficientFunds(coinsNeeded: Int)
    case outOfStock
}

func buyFavoriteSnack(person: String, vendingMachine: VendingMachine) throws {
    ...
}

do {
    try buyFavoriteSnack(person: "Alice", vendingMachine: vendingMachine)
    print("Success!")
} catch VendingMachineError.invalidSelection {
    print("Invalid Selection.")
} catch VendingMachineError.outOfStock {
    print("Out of Stock.")
} catch VendingMachineError.insufficientFunds(let coinsNeeded) {
    print("Insufficient funds. Please insert an additional \(coinsNeeded) coins.")
} catch {
    print("Unexpected error: \(error).")
}
```

> * enum을 `Error` 프로토콜을 상속하도록 하여 try-catch 구문으로 에러 처리를 수행하는 패턴으로 흔히 사용한다.