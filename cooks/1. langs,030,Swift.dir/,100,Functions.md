## Functions

---

### 1. Funcion basics

```swift
func hello() {
    print("Hello World")
}
func add(a: Int, b: Int) -> Int {
    return a + b
}
func addWithLabel(left a: Int, right b: Int) -> Int {
    return a + b
}
func addWithNoLabel(_ a: Int, _ b: Int) -> Int {
    a + b
}
func addWithDefault(a: Int = 0, b: Int = 0) -> Int {
    return a + b
}

hello() // Hello World
var simple = add(a: 1, b: 2) // 3
var labeled = addWithLabel(left: 1, right: 2) // 3
var noLabel = addWithNoLabel(1, 2) // 3
var withDefault = addWithDefault(a: 1) // 1. b의 default는 0이다.
```

> * 위 예제는 기본적인 함수의 선언 구문이다.
> * 기본적으로 parameter의 이름은 parameter의 label이기도 하다. 호출할 때는 반드시 label을 지정해주어야 한다.
> * parameter의 이름 말고 다른 label을 지정하려면 이름 앞에 선언해주면 된다.
> * label을 사용하지 않으려면 '_' 문자를 label로 지정한다.
> * `addWithNoLabel()` 함수의 경우 return 문이 없는데, 이렇게 하나의 expression을 이루어진 함수의 경우 return을 생략할 수 있다.
> * parameter에 default 값을 지정할 수 있으며 default가 지정된 parameter는 호출할 때 생략할 수 있다.

#### Multiple return values

```swift
func minMax(array: [Int]) -> (Int, Int) {
    var currentMin = array[0]
    var currentMax = array[0]
    for value in array[1..<array.count] {
        if value < currentMin {
            currentMin = value
        } else if value > currentMax {
            currentMax = value
        }
    }
    return (currentMin, currentMax)
}

let bounds = minMax(array: [8, -6, 2, 109, 3, 71])
print("min is \(bounds.0) and max is \(bounds.1)")
```

> * 위 예제와 같이 여러 개의 값을 return하고자 하면 tuple을 이용한다.
> * 일반적인 tuple처럼 각 필드에 이름을 줄 수 있다. 예를 들어 위 함수의 리턴 타입을 `(min: Int, max: Int)`로 바꿀 수 있다.
당연히 리턴값을 참조할 때도 `bounds.min`, `bounds.max`처럼 이름으로 참조할 수 있다.

#### ***Variadic*** parameter

```swift
func arithmeticMean(_ numbers: Double...) -> Double {
    var total: Double = 0
    for number in numbers {
        total += number
    }
    return total / Double(numbers.count)
}

print(arithmeticMean(1, 2, 3, 4, 5)) // 3.0
print(arithmeticMean(3, 8.25, 18.75)) // 10.0
```

> * parameter 갯수가 정해지지 않은 가변 parameter를 선언하기 위해서 타입 뒤에 `...`을 붙인다.
> * 함수 내에서는 Array 타입의 값으로 사용하면된다. 위 예제에서는 numbers는 [Double] 타입으로 취급된다.

#### ***In-Out*** parameter

```swift
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let temporaryA = a
    a = b
    b = temporaryA
}

var a = 3
var b = 107
swapTwoInts(&a, &b)
print("a is now \(a), and b is now \(b)")
```

> * Swift에서 함수의 parameter는 기본적으로 **pass by value** 방식으로 값을 전달한다. 즉 함수내부에서 다른 값으로 바꿔도 호출한 쪽에서는 바뀌지 않는다. 하지만 **pass by reference** 방식으로 값을 전달할 수도 있다. parameter의 타입 앞에 `inout`을 지정하면 된다.
> * 함수를 호출할 때는 inout parameter의 앞에 '`&`'를 붙여줘야 한다.

#### Function types

```swift
func addTwoInts(_ a: Int, _ b: Int) -> Int {
    return a + b
}
func multiplyTwoInts(_ a: Int, _ b: Int) -> Int {
    return a * b
}

var mathFunction: (Int, Int) -> Int = addTwoInts
print("Result: \(mathFunction(2, 3))") // Result: 5

mathFunction = multiplyTwoInts
print("Result: \(mathFunction(2, 3))") // Result: 6

func printMathResult(_ mathFunction: (Int, Int) -> Int, _ a: Int, _ b: Int) {
    print("Result: \(mathFunction(a, b))")
}
printMathResult(addTwoInts, 3, 5) // Result: 8

func math(_ add: Bool) -> (Int, Int) -> Int {
    return add ? addTwoInts : multiplyTwoInts
}
print("Result: \(math(true)(3, 5))") // Result: 8
```

> * Type system 쪽에서 설명한대로 Swift는 function type이 지원된다.
> * Swift에서는 function도 함수의 parameter나 return 값으로 사용될 수 있으며 여기서도 함수 타입을 사용할 수 있다.

#### Nested function

```swift
func chooseStepFunction(backward: Bool) -> (Int) -> Int {
    func stepForward(input: Int) -> Int { return input + 1 }
    func stepBackward(input: Int) -> Int { return input - 1 }
    return backward ? stepBackward : stepForward
}
```

> * 함수 내부에 함수를 선언할 수 있으면 이런 nested 함수들은 함수 외부에서는 보이지 않는다.
> * 위 예제처럼 함수를 반환하여 외부에서 사용하도록 할 수 있다.