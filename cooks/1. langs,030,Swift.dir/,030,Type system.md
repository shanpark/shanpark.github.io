## Type system

---

Swift는 type을 크게 Named type과 Compound type으로 나눈다.

* Named type - 일반적인 class, struct, enum, interface 등과 같이 사용자가 정의한 이름이 주어진 type.
* Compound type - function type, tuple type 같이 언어 자체적으로 정의된 type.

### 1. Built-in Data types

```swift
var i8: Int8 // 1 byte signed
var ui8: UInt8 // 1 byte unsigned
var i16: Int16 // 2 byte signed
var ui16: UInt16 // 2 byte unsigned
var i32: Int32 // 4 byte signed
var ui32: UInt32 // 4 byte unsigned
var i64: Int64 // 8 byte signed
var ui64: UInt64 // 8 byte unsigned

var i: Int // 4 or 8 byte signed, platform dependent
var ui: UInt // 4 or 8 byte unsigned, platform dependent

var f: Float // 4 byte floating point
var d: Double // 8 byte floating point

var b: Bool // true, false

var ch: Character // single character string, "C"
var str: String // string
```

> * 다른 언어의 Primitive type의 역할을 하지만 이 type들도 모두 Named type이며 일반적인 `struct`로 구현된다.
> * Character 타입 리터럴을 선언할 때 문자열 처럼 쌍따옴표(")를 사용한다. 즉 한 글자 짜리 문자열로 선언한다.
> * 위 예시는 모두 `nil` 값을 가질 수 없는 타입이며 뒤에 ?를 붙이면 Optional 타입이 된다. (Nullable과 같다.)

### 2. Compound types

```swift
// Tuple types: (type, type, ...)
var tuple = ("one", "two", "three")
var someTuple = (top: 10, bottom: 12) // someTuple is of type (top: Int, bottom: Int)
someTuple = (top: 4, bottom: 42)   // OK: names match
someTuple = (9, 99)                // OK: names are inferred
// someTuple = (left: 5, right: 5) // Error: names don't match

print(tuple) // ("one", "two", "three")
var (first, second, _) = tuple // decompose
print(tuple.0, second) // one two

print(someTuple) // (top: 9, bottom: 99)
print(someTuple.top, someTuple.1) // 9 99

// Function types: (parameter types) -> return type
var f1: (Int, Int) -> Int               // OK
var f2: (_ lhs: Int, _ rhs: Int) -> Int // OK
// var f3: (lhs: Int, rhs: Int) -> Int  // Error: parameter labels
```

> * Tuple type은 괄호 안에 0개 또는 2개 이상의 type들을 지정한 타입이다. 지정된 type이 0개인 empty tuple은 `Void` 타입으로 type alias 되어있다.
> * tuple을 decompose해서 사용하거나 각 원소를 index로 access할 수 있다.
> * tuple의 원소에 name이 있더라도 index로 access할 수 있다.
> * Function type의 parameter는 label을 지정할 수 없다.

### 3. Collections

#### Array (List)

```swift
// Array<type> = [type]
var someArr1: Array<String> = ["Alex", "Brian", "Dave"]
var someArr2: [String] = ["Alex", "Brian", "Dave"] // 위와 동일
let emptyArr: [Int] = []
var arr3D: [[[Int]]] = [[[1, 2], [3, 4]], [[5, 6], [7, 8]]]

someArr2[0] = "Mike"
print("first: \(someArr2[0])") // first: Mike

// append
someArr2.append("Hi")
print("count: \(someArr2.count)") // count: 4

var d1 = Array(repeating: 1.5, count: 3)
var d2 = Array(repeating: 2.5, count: 3)
var d3 = d1 + d2
print("count: \(d3.count)") // count: 6

d3 += [3.5] // adding single element array. (like append)
print("count: \(d3.count)") // count: 7

// range replace
d3[1...3] = [1.0, 1.0] // replace range
print(d3) // [1.5, 1.0, 1.0, 2.5, 2.5, 3.5]

// remove
var removed = d3.remove(at:0)
print("removed: \(removed), array:\(d3)") // removed: 1.5, array:[1.0, 1.0, 2.5, 2.5, 3.5]

// iterating
for item in d3 {
    ...
}
```

> * 많은 언어들이 array와 list를 구분하지만 Swift의 Array는 다른 언어의 list와 기능적으로 같다. 따라서 immutable(`let`)로 선언된 게 아니라면 크기도 얼마든지 바뀔 수 있다.
> * Array는 그 크기를 `count` 속성을 통해 알 수 있다.
> * `+` 연산자를 이용하면 두 arrary가 병합된 새로운 array를 생성할 수 있다.

#### Set

```swift
// Set<type>
var set1: Set<String> = ["Rock", "Classical", "Hip hop"]
var set2: Set = ["Rock", "Classical", "Hip hop"] // 위와 동일

print("count: \(set2.count)") // count: 3

// insert
set2.insert("Jazz")
set2.insert("Jazz") // 중복
print("count: \(set2.count)") // count: 4

// remove
set2.remove("Jazz") 
print("count: \(set2.count)") // count: 3

// iterating
for genre in set2 {
    ...
}

// set operations
let oddDigits: Set = [1, 3, 5, 7, 9]
let evenDigits: Set = [0, 2, 4, 6, 8]
let singleDigitPrimeNumbers: Set = [2, 3, 5, 7]

var s = oddDigits.union(evenDigits).sorted()
print(s) // [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
s = oddDigits.intersection(evenDigits).sorted()
print(s) // []
s = oddDigits.subtracting(singleDigitPrimeNumbers).sorted()
print(s) // [1, 9]
s = oddDigits.symmetricDifference(singleDigitPrimeNumbers).sorted()
print(s) // [1, 2, 9]

let houseAnimals: Set = ["개", "고양이"]
let farmAnimals: Set = ["소", "닭", "양", "개", "고양이"]
let cityAnimals: Set = ["참새", "쉬"]

var b = houseAnimals.isSubset(of: farmAnimals)
print(b) // true
b = farmAnimals.isSuperset(of: houseAnimals)
print(b) // true
b = farmAnimals.isDisjoint(with: cityAnimals)
print(b) // true
```

> * Array literal을 이용하여 Set을 생성하기 때문에 type을 생략하면 Array로 추론된다. 따라서 반드시 Set을 지정해야 한다. 하지만 element의 type은 추론이 된다.
> * Set은 그 크기를 `count` 속성을 통해 알 수 있다.
> * 다양한 집합 연산이 구현되어있다.

#### Dictionary

```swift
// [type: type]
var empty: [Int: String] = [:]
var dic1: [String: String] = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]
var dic2  = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]

print("size: \(dic2.count)") // size: 2

// insert
dic2["LHR"] = "London"
print("size: \(dic2.count)") // size: 3

// update
dic2["LHR"] = "London Heathrow"
print("size: \(dic2.count), LHR:\(dic2["LHR"])") // size: 3, LHR:Optional("London Heathrow")

if let oldValue = dic2.updateValue("Dublin Airport", forKey: "DUB") {
    print("The old value for DUB was \(oldValue).")
}

// remove
dic2["LHR"] = nil // remove using subscript syntax !!
print("size: \(dic2.count)") // size: 2

if let removedValue = dic2.removeValue(forKey: "DUB") {
    print("The removed airport's name is \(removedValue).")
} else {
    print("The airports dictionary doesn't contain a value for DUB.")
}

// to array
let airportCodes = [String](dic2.keys)
print("airportCodes is \(airportCodes)") // airportCodes is ["YYZ"]
let airportNames = [String](dic2.values)
print("airportNames is \(airportNames)") // airportNames is ["Toronto Pearson"]

// iterating
for (airportCode, airportName) in dic2 {
    ...
}

for airportCode in dic2.keys {
    ...
}

for airportName in dic2.values {
    ...
}
```

> * map과 같은 기능을 하는 collection이지만 Swift는 map 대신 dictionary라는 용어를 사용한다.
> * subscript syntax(`[]`)를 사용하여 **`nil`을 지정하면 해당 항목이 삭제**된다. Value의 type이 Optional일 지라도 `nil`값이 assign되는 게 아니고 항목이 삭제된다.
