---
layout: post
title: 위장
description: >
  프로그래머스 해시 문제
hide_description: false
category: algorithm
image:
  path: https://images.unsplash.com/photo-1495576596703-e0063a132b6e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80
---

***[문제 링크](https://programmers.co.kr/learn/courses/30/lessons/42578){:target="_blank"}***<br>
***본 문제는 C++를 이용하여 해결하였다.***
{:.note}

문제가 어렵다기보다 수학적 사고 능력을 요구하는 문제이다. 한번 같이 보자.

* this unordered seed list will be replaced by the toc
{:toc}

## 문제 설명
> 스파이들은 매일 다른 옷을 조합하여 입어 자신을 위장합니다.
> 예를 들어 스파이가 가진 옷이 아래와 같고 오늘 스파이가 동그란 안경, 긴 코트, 파란색 티셔츠를 입었다면 다음날은 청바지를 추가로 
> 입거나 동그란 안경 대신 검정 선글라스를 착용하거나 해야 합니다.

종류|이름
:---|:---:
얼굴|동그란 안경
상의|파란색 티셔츠
하의|청바지
겉옷|긴 코트

>스파이가 가진 의상들이 담긴 2차원 배열 clothes가 주어질 때 서로 다른 옷의 조합의 수를 return 하도록 solution 함수를 작성해주세요.

> 제한사항
> * clothes의 각 행은 [의상의 이름, 의상의 종류]로 이루어져 있습니다.
> * 스파이가 가진 의상의 수는 1개 이상 30개 이하입니다.
> * 같은 이름을 가진 의상은 존재하지 않습니다.
> * clothes의 모든 원소는 문자열로 이루어져 있습니다.
> * 모든 문자열의 길이는 1 이상 20 이하인 자연수이고 알파벳 소문자 또는 '_' 로만 이루어져 있습니다.
> * 스파이는 하루에 최소 한 개의 의상은 입습니다.

### 입출력 예

clothes|return
:---|:---:
[["yellowhat", "headgear"], ["bluesunglasses", "eyewear"], ["green_turban", "headgear"]]|5
[["crowmask", "face"], ["bluesunglasses", "face"], ["smoky_makeup", "face"]]|3

<hr>


## <span style="color:#3a8791;">문제 해결</span>

### 문제 해석

첫번째 입출력 예를 보면 `return` 값은 5라고 나와있다. 그 이유를 알아보자.<br>
스파이들은 들키지 않기 위해 위장을 한다고 한다. `headegear` 라는 카테고리 안에 `yellowhat`과 `green_truban`  패션 아이템들이 있고
`eyewear` 라는 카테고리 안에 `bluesunglasses` 라는 패션 아이템이 있다. 스파이는 최소 한 개 이상의 의상은 입어야 한다는 제한사항도 
잘 기억해두자. <br>

그렇다면 5가지가 나오는 과정은 
>`yellowhat` 만 착용했을 경우 + `green_turban` 만 착용했을 경우 + `bluesunglasses` 만 착용했을 경우 + `yellowhat` 과 `bluesunglasses` 를 착용했을 경우 + `green_turban` 과 `bluesunglasses` 를 착용했을 경우

해서 5가지가 나온다. 입출력 예제 2도 똑같은 원리다.

### 수학적 계산

코드는 어떻게 짜야될지 감이 왔다. 다만 수많은 테스트 케이스들을 어떻게 커버할 지 일반화된 수식이 필요했다.<br>
고민을 해보자... 이 문제는 옷을 어떻게 입을 수 있는지 모든 조합의 경우의 수를 구하는 문제이다. 그 생각을 계속 하고 있으면 이런 공식이 떠오른다.<br>

$$
\begin{aligned}
  (x+1)(y+1) = xy + x + y + 1
\end{aligned}
$$


간단한 공식
{:.figcaption}

모든 조합의 수를 구할 수 있는 공식이다. 다만 여기서 `-1` 을 해줘야 하는데 그 이유는 최소 1개 이상의 의상은 
착용하고 있어야 한다고 나와있기 때문이다. 따라서 아무것도 안 입고 있는 상태를 빼줘야한다.

### 코드 

해당 문제의 핵심은 스파이가 무슨 의상을 가지고 있는지는 관심이 없다는 것이다. 우리가 관심있는 것은 어떤 카테고리 안에 몇 개의 의상이
준비되어 있는지 그 개수만 알면 된다. 따라서 2차원 배열로 주어지는 의상 중에서 <br> `clothes[x][1]` 만 따와 그 카테고리에 포함되는 의상의 개수를 
알아내면 될 것이다. 


<pre><code class="C++">using namespace std;

map&lt;string, int> getHash(vector&lt;vector&lt;string>> clothes) {
    map&lt;string, int> ret;
    
    for(int i=0; i&lt;clothes.size(); i++) {
        auto itr = ret.find(clothes[i][1]);
        
        if(itr == ret.end()) {
            ret.insert(pair&lt;string, int>(clothes[i][1], 1));
        } else {
            itr->second++;
        }
    }
    
    
    return ret;
}

int solution(vector<&ltvector&lt;string>> clothes) {
    map&lt;string, int>::iterator itr;
    map&lt;string, int> ret = getHash(clothes);
    
    int answer = 1;
    
    for (itr = ret.begin(); itr != ret.end(); ++itr) {
        answer *= (itr->second+1);
    }
    
    return answer-1;
}
</code></pre>

### 코드 설명

각 카테고리 안에 의상의 개수가 몇 개인지 알아내기 위해 `Map` 컨테이너를 이용하였다.
`getHash` 함수를 보면 `ret` 변수에서 `clothes[i][1]` (카테고리) 를 찾아와 해당 카테고리에 해당되는 옷의 개수를 계속 더해줘가는
알고리즘을 보여준다. `itr==ret.end()` 라는 것은 `ret` 에서 해당 카테고리를 끝까지 찾지 못했을 때라는 뜻이다.<br>
이제 `solution` 함수를 보면 위에 적어놓은 수학 공식을 적용한 모습이다.
> 카테고리 수가 몇 개이더라도 저 공식을 유지해주면 된다.
> 예를 들어 카테고리가 `headgear`, `eyegear`, `outer` 총 3개가 있고 각 카테고리에 해당하는 의상의 개수들을 `x, y, z` 라고 했을 때

$$
    (x+1)(y+1)(z+1) = xyz + xy + xz + yz + x + y + z + 1
$$

> 이므로 모든 조합의 경우의 수를 찾을 수 있다.


마지막으로 구한 `answer` 에서 1을 빼주면 맞는 결과가 나오게 된다. 

<hr>

## 마무리하며 & 근황

코테 문제 리뷰를 정말 오랜만에 한다. 그 이유는... <br>
**전역을 했기 때문이다!!!**<br>

전역하고 m1 맥미니도 구입하고 데스크 셋업하느라 꽤 정신없는 나날들을 보냈다.
전역한지는 이제 1달이 되가는데 이제부터 알고리즘 문제 푸는 것에 박차를 가해야겠다. 길다면 길고 짧다면 짧은 군생활을
무사히 마쳐 다행이다. 
>얼른 복학하고 싶다...

