---
layout: post
title: 군대에서 React-Native 개발하기
description: >
  React-Native-Cli
hide_description: true
category: devlife
image:
  path: https://miro.medium.com/max/1000/1*ub1DguhAtkCLvhUGuVGr6w.png
---

React-Native를 군대에서...
{:.figcaption}

## React-Native 를 Emulator 없이?

군입대를 하기 전에 전에 글에 써놨듯이 앱 개발 수업을 들었었다. 그때 쓴 언어는 **_Java_** 로 **Android Studio** 를 이용하였다.
그때 개발을 하면서 **_Flutter_** 나 **_React-Native_** 가 있다는 것만 인지했지 배워볼 용기도 시간도 없었다.<br><br>
그렇게 군입대를 하고 지내던 중 **국방오픈소스아카데미** 에서 열린 해커톤에서 **_React-Native_**를 사용해볼 기회가 생겼다. 그래서 난 당연히 에뮬레이터를 이용하여
개발을 하면서 **_Hot Reload_** 기능을 사용할 줄 알았으나 아니었다... <br>

<div align="center"><iframe src="https://giphy.com/embed/zIZevuVNIEXsc7bcZZ" width="480" height="343" frameBorder="0" class="giphy-embed" allowFullScreen></iframe></div>

## React-Native-Cli 로 시작하기

해커톤이 시작되고 **국방오픈소스아카데미** 에서 공지를 올렸다. 바로 어떻게 개발해야 하는지에 대한 가이드를 올린 것이다. 그때는 정말 헤매고
이해가 안됐지만 다시 해보는 입장에서 너무 쉽고 간단하기 때문에 포스팅을 하려한다.

### Codespace에 초기 세팅하기

- `Codespace` 에는 nodejs, npm, jdk, gradle이 설치되어 있다.
- `Android SDK` 설치 및 환경 설정이 필요하다.
- 기기를 데스크톱에 연결할 수 없는 경우, APK 파일을 `Git` 저장소에 업로드해야 한다.

#### <span style="color:#7caecf">Android commandlinetools 다운로드 받기</span>

<br>`터미널`을 열고 아래의 명령어를 입력하자.

```bash
$ sudo npm install -g react-native-cli
```

그 다음 자신이 만들 앱을 포함하는 폴더가 보이는 경로로 간다.

```bash
$ react-native init MyAppFolder/
```

이제 우리는 android-sdk 가 필요하다. 이것을 에뮬레이터 없이 가질려면 **_commandlinetools_** 가 필요하다.
더 자세한 사항은 공식 문서를 확인해보자. [공식문서](https://developer.android.com/studio/command-line?hl=ko){:target="\_blank"}
이제 다운로드를 해보자.

다운로드 링크 : [commandlinetools](https://developer.android.com/studio?hl=ko#command-tools){:target="\_blank"}
<br>

위에서 맞는 Linux 에 있는 링크를 복사해온 다음 `wget` 을 이용해 다운 받는다.

```bash
$ cd ~ && wget https://dl.google.com/android/repository/commandlinetools-linux6609375_latest.zip
```

다운 받은 `commandlinetools` 를 알맞은 경로에 위치하자.

```bash
$ unzip sdk-tools-linux-4333796.zip && rm sdk-tools-linux-4333796.zip
$ mkdir android-sdk && mv tools android-sdk/tools
```

#### <span style="color:#7caecf">PATH 설정</span>

이제 **PATH** 설정을 해주자.

```bash
$ sudo vim ~/.bashrc
```

위 명령어를 통해 `bashrc` 파일을 연다. 파일에 아래 내용을 추가해주자.

```bash
export ANDROID_HOME=$HOME/android-sdk
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
```

수정한 `bashrc` 를 적용시켜주자.

```bash
$ source ~/.bashrc
```

#### <span style="color:#7caecf">SDK 설치</span>

자신이 원하는 안드로이드 SDK 를 설치해주는 과정이다. 군대에서 개발이다 보니 iOS 는 조금 제한이 될 수 있다.(github 에 올린 APK 파일을 확인하면서 개발하기 때문)
아래 명령어를 입력하자

```bash
$ sdkmanager --sdk_root=${ANDROID_HOME} "platform-tools" "platforms;android-28"
//28 버전이 아닌 다른 버전도 가능
```

#### <span style="color:#7caecf">Apk 빌드 및 생성</span>

빌드 세팅을 위해 해야 할 절차가 있다. 터미널을 열어 프로젝트 폴더를 들어가 아래 명령어를 입력하자.

```bash
$ mkdir android/app/src/main/assets
```

다음 `package.json` 파일을 수정해야 한다. `scripts` 부분을 아래와 같이 수정하자.

```json
"scripts": {"bundle": "react-native bundle --platform android --dev false --
entry-file index.js --bundle-output
android/app/src/main/assets/index.android.bundle --assets-dest
android/app/src/main/res" },
```

이제 다 됐다. 빌드를 해보자.

```bash
$ npm run bundle && cd android/ && ./gradlew assembleDebug
```

위의 빌드 과정을 통해 `Apk` 파일은 `/android/app/build/outputs/apk/debug/` 에 생성된다. 이 파일을 Github 나 다운받을 수 있는 어디든 올려 폰에 다운받고
설치하면 된다.

### 사용기

![react-native]

실제 Codespace 에서 개발하고 있는 나의 Dday 알림 앱
{:.figcaption}

쓰면서 느낀 장점은 에뮬레이터 없이도 개발을 할 수 있다는 제일 큰 장점이다. 그리고 군대에서 `React-native` 를 이용하여 앱 개발을 할 수 있다는 점에서도 큰 장점을 가진다.
다만 제일 큰 장점은 에뮬레이터가 없어 항상 `apk` 파일을 빌드하여 업로드하고 폰에 다운로드 받아서 확인하는게 너무 귀찮다...

<br><br>
그러다 찾은 해결책!!

### Snack expo

[React-Native-Editor](https://snack.expo.io/){:target="\_blank"}

![snackexpo]

snack expo
{:.figcaption}

위 사이트를 들어가면 `snack` 을 생성하고 `react-native`로 짠 코드를 실시간으로 볼 수 있다. **_Snack expo_** 는 설명할 필요없는
직관적인 UI 와 쓰기 편하니 다들 이용해보기를 바란다.

### 마무리하며

군대에서 앱 개발을 할 수 있다는 사실에 정말 감사할 따름이다. 요즘은 **_react-native_** 를 이용한 앱 개발에 빠져
블로그 포스팅 하는 것에 조금 게을러졌다. 두 마리 토끼를 잡을 수 있었으면 좋겠다.

[react-native]: ../../assets/img/blog/react.png
[snackexpo]: ../../assets/img/blog/snackexpo.png
