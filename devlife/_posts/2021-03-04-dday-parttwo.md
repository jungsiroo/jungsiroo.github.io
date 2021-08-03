---
layout: post
title: React-Native로 디데이 앱 만들기<br>Part.2 (로그인)
description: >
  React-Native
hide_description: true
category: devlife
image:
  path: ../../assets/img/blog/dday.png
---

*이전 글에서 [파이어베이스 세팅](https://alpha-src.github.io/devlife/2021-02-27-dday-partone/){:target="_blank_"} 을 보고 오자!*<br>
*이 글은 [Social App Login & Signup Screen UI Tutorial in React Native](https://www.youtube.com/watch?v=ZxP-0xbz5sg){:target="_blank_"} 을 참고했습니다.* 
{:.note}

<br><br>

오늘은 **_AuthStack_** 에 대해 알아보자. **_AuthStack_** 은 **_AuthProvider_** 에 둘러싸여 있는 **StackNavigator** 이다.
따라서 차근차근 **_AuthProvider_** 와 **_AuthStack_** 을 파해쳐 볼 것이다.

* 
{:toc}

## AuthProvider

[React Native Context](https://ko.reactjs.org/docs/context.html){:target="_blank_"} 을 먼저 읽어보자.