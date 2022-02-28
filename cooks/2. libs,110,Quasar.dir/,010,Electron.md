## Quasar - Electron

---

## 1. Quasar 프로젝트 생성

- 가장 먼저 Quasar 프로젝트를 하나 생성한다.
- 생성 후에 Electron 지원을 위한 mode를 추가하는 방식이므로 최초 생성은 일반적인 Quasar 프로젝트 생성과 다르지 않다.
- 참고로 Project 폴더가 현재 경로에 생성되고 그 안에 파일들이 생성된다.

```
$ quasar create quasar-electron

  ___
 / _ \ _   _  __ _ ___  __ _ _ __
| | | | | | |/ _` / __|/ _` | '__|
| |_| | |_| | (_| \__ \ (_| | |
 \__\_\\__,_|\__,_|___/\__,_|_|



? Project name (internal usage for dev) quasar-electron
? Project product name (must start with letter if building mobile apps) Quasar Electron Sample App
? Project description Quasar Electron Sample App
? Author shanpark <shanpark@naver.com>
? Pick your CSS preprocessor: SCSS
? Check the features needed for your project: ESLint (recommended), Vuex, Axios, Vue-i18n
? Pick an ESLint preset: Prettier
? Continue to install project dependencies after the project has been created? (recommended) yarn

  Quasar CLI · Generated "quasar-electron".


 [*] Installing project dependencies ...
...
```

## 2. Electron mode 추가

- 이 후 모든 명령은 project root 폴더로 이동해서 수행하도록 한다.
- 생성된 프로젝트에 Electron mode를 추가하기 위해서는 먼저 필요한 node module들이 설치되어야 하므로 생성할 때 dependency를 설치하도록 선택하지 않았다면 아래 명령으로 필요한 node module을 먼저 설치한다.

```bash
$ cd <ProjectRoot>
$ yarn
```

- 다음 명령으로 Electron mode를 추가한다.

```bash
$ quasar mode add electron
```

- electron mode가 추가되면 필요한 electron 관련 dependency들이 추가되고 src-electron 폴더가 생성되며 그 안에 electron main thread 소스 코드들이 생성된다.

## 3. Electron 설정

- 일반적인 Quasar 설정은 모두 quasar.conf.js 파일에서 이루어진다. Electron 설정도 마찬가지이다.
- 대부분 설정은 그대로 사용하고 아래 내용만 설명한다.

```javascript
{
  ...

  // should you wish to change default files
  // (notice no extension, so it resolves to both .js and .ts)
  sourceFiles: {
    electronMain: 'src-electron/electron-main',
    electronPreload: 'src-electron/electron-preload'
  },

}
```

- 기본으로 생성되는 src-electron 폴더의 소스들은 위 설정으로 경로와 이름을 변경할 수 있다. 하지만 가능하면 그대로 사용하도록 하자.

```javascript
{
  ...

  electron: {
    bundler: 'packager', // or 'builder'

    // electron-packager options
    // https://electron.github.io/electron-packager/master/
    packager: {
      //...
    },

    // electron-builder options
    // https://www.electron.build/configuration/configuration
    builder: {
      //...
    },

    ...
  }

}
```

- electron bundler로 `packager`와 `builder` 두 가지 옵션을 선택할 수 있다.
- default로 `packager`가 설정되어 있으며 테스트 결과 추가 설정없이 바로 사용해도 잘 동작한다.
- 문서상으로 `packager`와 `builder`의 차이점은 `packager`가 서명되지 않은 패키지를 생성할 수 있다는 점이다. (builder는 서명되지 않은 패키지를 생성할 수 없다는 뜻?)

## 4. Electron 실행 (개발용)

- 웹 개발 시 개발용 웹서버를 띄워서 작업하는 것처럼 electron 모드로 작업할 때도 아래 명령으로 앱을 띄우고 작업할 수 있다.
- 참고로 아래 명령을 실행하면 electron mode 추가가 안되어 있더라도 자동으로 모드 추가까지 해준다.

```bash
$ quasar dev -m electron

# for Vue Devtools
$ quasar dev -m electron --devtools
```

## 5. Electron 빌드 & 배포

- 아래 명령으로 빌드를 수행한다.
- 빌드 후 `dist` 폴더에 배포 바이너리가 생성된다.
  - 플랫폼마다 생성 결과는 다르지만 dist/electron 폴더 아래에서 찾아보면 적당한 실행 파일을 찾을 수 있다.
  - 참고로 UnPackaged 폴더는 최종 결과를 생성하기 위해 빌드된 파일이 저장된다. 즉, Web 소스 코드 형태로 빌드된 파일들을 볼 수 있다.

```bash
$ quasar build -m electron

# debugging enabled for the UI code
$ quasar build -m electron -d
```

- quasar.conf.js 파일에서 설정한 bundler가 사용된다.
  - '_packager_'는 서명작업은 하지 않으며 Mac에서 작업 시 Mac용 `.app`을 생성한다.
  - '_builder_'는 빌드 작업을 수행하는 장비에 설정된 Apple 개발자 서명을 이용해서 서명을 수행한다.  
    `.app` 뿐만 아니라 `.zip`, `.dmg` 파일까지 생성한다.
    - `.zip`: `.app`을 단순히 압축한 파일이다.
    - `.dmg`: `.app`을 설치하는 설치파일이다. ('Applications 폴더에 끌어 놓기' 설치 파일)
