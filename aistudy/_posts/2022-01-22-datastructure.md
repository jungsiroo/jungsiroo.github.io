---
layout: post
title: 파이썬의 기본 자료구조
description: >
  Naver boostcamp AI Tech - Python Basics for AI
hide_description: false
category: aistudy
image:
  path: ../../assets/img/thumbnail/pythonstructure.png
---

**해당 썸네일은 `Wonkook Lee` 님이 만드신 [`Thumbnail-Maker`](https://wonkooklee.github.io/thumbnail_maker/){:target="_blank"} 를 이용하였습니다**
{:.figcaption}

오늘부터 네이버 boostcamp AI Tech 에서 들은 강의들을 정리해서 올리려고 한다. 첫번째 포스팅은 `Python Basics for AI` 강좌 중 `자료구조` 에 대해 다뤄보겠다.

* this unordered seed list will be replaced by the toc
{:toc}

> **Stack & Queue with list**
> 

> **Tuple & Set**
> 

> **Dictionary**
> 

> **Collection module**
> 

# 🧐 &nbsp;Stack

- 나중에 넣은 데이터를 먼저 반환하도록 설계된 메모리 구조
- LIFO
- 데이터의 입력을 Push, 출력을 Pop

<pre><code class="python">a = [1,2,3,4,5]

a.append(10)
a.append(20)

a.pop() #20
a.pop() #10
</code></pre>

# 🧮  &nbsp;Queue

- 먼저 넣은 데이터를 먼저 반환하도록 설계된 메모리 구조
- FIFO
- Stack 과 반대되는 개념

<pre><code class="python">a = [1,2,3,4,5]

a.append(10)
a.append(20)

# put 을 append(), get 을 pop(0)
a.pop(0) #1
a.pop(0) #2
</code></pre>

# ⚡️ &nbsp;Tuple

- `값의 변경이 불가능한 리스트`
- 선언 시 `[ ]` 가 아닌 `( )` 를 사용
- 리스트의 연산, 인덱싱, 슬라이싱 등을 동일하게 활용

<pre><code class="python">t = (1,2,3)
print(t+t, t*2) #(1,2,3,1,2,3) (1,2,3,1,2,3)

t[1] = 5        # Error 발생
</code></pre>

## Why use tuple?

- 프로그램을 작동하는 동안 변경되지 않은 데이터의 저장
    - 학번
    - 이름
    - 우편번호 등등
- 함수의 반환 값등 사용자의 실수에 의한 에러를 사전에 방지

<pre><code class="python">t = (1)  #1
t = (1,) #(1,) 값이 하나인 tuple 은 반드시 "," 를 붙여야 함
</code></pre>

# 🎷 &nbsp;Set

- 값을 순서없이 저장, 중복 불허 하는 자료형
- set 객체 선언을 이용하여 객체 생성

<pre><code class="python">s = set([1,2,3,1,2,3])
s # {1,2,3}

s.add(1)
s #{1,2,3}

s.remove(1)
s #{2,3}

s.update([1,4,5,6,7])
s #{1,2,3,4,5,6,7} 
</code></pre>

## 집합의 연산

<pre><code class="python">s1 = set([1,2,3,4,5])
s2 = set([3,4,5,6,7])

s1.union(s2)    # s1과 s2 의 합집합
{1,2,3,4,5,6,7}
s1 | s2

s1.intersection(s2) # s1과 s2 의 교집합
{3,4,5}
s1 & s2

s1.difference(s2)  # s1과 s2 의 차집합
{1,2}
s1 - s2
</code></pre>

# 🗿 &nbsp;Dict

- 데이터를 저장할 때는 구분 지을 수 있는 값을 함께 저장
    - 주민등록 번호
    - 제품 모델 번호
- 구분을 위한 데이터 고유 값을 `Identifier` 또는 `Key` 라고 함
- Key 값을 활용하여, 데이터 값(`value`) 를 관리함

<pre><code class="python">student_info = {20140012:'sungchul', 20140059:'jiyong', 20140058:'jaehong'}

student_info[20140012] #sungchul
student_info[20140012] = 'janhuk'
student_info[20140012] #janhuk
student_info[20140039] = 'wonchul'
</code></pre>

| Key | Valule |
| --- | --- |
| 20140012 | janhuk |
| 20140059 | jiyong |
| 20140058 | jaehong |
| 20140039 | wonchul |

# ⚙️ &nbsp;Collection

- List, Tuple, Dict 에 대한 `Python Built-in` 확장 자료 구조(모듈)
- 편의성, 실행 효율 등을 사용자에게 제공함
- 아래의 모듈이 존재함

<pre><code class="python">from collections import deque
from collections import Counter
from collections import OrderedDict
from collections import defaultdict
from collections import namedtuple
</code></pre>

## deque

<pre><code class="python">from collections import deque

deque_list = deque()
for i in range(5):
	deque_list.append(i)

print(deque_list) #0 1 2 3 4

deque_list.appendleft(10)
print(deque_list) #10 0 1 2 3 4

deque_list.rotate(1)
print(deque_list) # 4 10 0 1 2 3
</code></pre>

- rotate, reverse 등 Linked List 의 특성을 지워함
- 기존 list 형태의 함수를 모두 지원함
- general list 보다 훨씬 더 효율적

## defaultdict

<pre><code class="python">from collections import defaultdict

d = defaultdict(lambda : 0)
d["fisrt"] #0
</code></pre>

- 딕셔너리 `value` 를 정해진 값으로 설정

## Counter

 - 시퀀스 타입의 `data element` 들의 개수를 dict 형태로 반환

<pre><code class="python">from collections import Counter

c = Counter()
c = Counter("gallahad")
print(c) # Counter({'a':3, 'l':2, 'g':1, 'd':1, 'h':1})
</code></pre>


<hr>

이상 강의를 들으면서 정리한 내용들을 포스팅해보았다. 기본적인 것 위주니까 더 심화된 과정들도 찾아오겠다.