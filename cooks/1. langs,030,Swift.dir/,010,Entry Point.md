## Main(Entry) Function

---

### 1. main.swift

* swift에서는 *main.swift* 라고 명명된 파일이 entry point 역할을 수행한다. main.swift 파일의 첫 번째 코드가 암묵적으로 entry point가 된다.
* main.swift 파일을 제외한 다른 파일에서는 top level 코드를 포함할 수 없다.
* iOS용 프로젝트같은 경우 일반적인 swift 파일에 `@UIApplicationMain` 또는 `@main` 같은 annotation을 붙임으로써 컴파일러가 알아서 main entry point를 합성(synthesize)할 수 있도록 한다.
