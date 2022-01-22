---
layout: post
title: 2798번 블랙잭 문제
description: >
  백준 완전탐색 문제
hide_description: false
category: algorithm
image:
  path: https://images.unsplash.com/photo-1594692707496-a9dc0498e175?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80
---

***[문제 링크](https://www.acmicpc.net/problem/2798){:target="_blank"}***<br>
***본 문제는 C++17을 이용하여 해결하였다.***
{:.note}

간단한 완전탐색 문제이다. 같이 한번 보자.

* this unordered seed list will be replaced by the toc
{:toc}


{:toc}

## 문제

>카지노에서 제일 인기 있는 게임 블랙잭의 규칙은 상당히 쉽다. 카드의 합이 21을 넘지 않는 한도 내에서, 카드의 합을 최대한 크게 만드는 게임이다. 블랙잭은 카지노마다 다양한 규정이 있다.
>한국 최고의 블랙잭 고수 김정인은 새로운 블랙잭 규칙을 만들어 상근, 창영이와 게임하려고 한다.<br>
>김정인 버전의 블랙잭에서 각 카드에는 양의 정수가 쓰여 있다. 그 다음, 딜러는 N장의 카드를 모두 숫자가 보이도록 바닥에 놓는다. 그런 후에 딜러는 숫자 M을 크게 외친다.
>이제 플레이어는 제한된 시간 안에 N장의 카드 중에서 3장의 카드를 골라야 한다. 블랙잭 변형 게임이기 때문에, 플레이어가 고른 카드의 합은 M을 넘지 않으면서 M과 최대한 가깝게 만들어야 한다.
>N장의 카드에 써져 있는 숫자가 주어졌을 때, M을 넘지 않으면서 M에 최대한 가까운 카드 3장의 합을 구해 출력하시오.

>INPUT1 | INPUT2 | OUTPUT
>:---:|:---:|:---:
>5 21| 5 6 7 8 9 | 21
>10 500| 93 181 245 214 315 36 185 138 216 295 | 497

## <span style="color:#3a8791;">문제 해결</span>

### 문제 해석

난이도가 정말 낮은 문제이다. 블랙잭 기본 룰을 따르되 **21** 이 아닌 딜러가 외치는 **M** 을 넘지만 않으면 된다. <br>
입력 제한에 카드의 개수 **(M)** 가 최대 **100** 개 까지이다. 이 점을 유의하면서 코드를 짰다.

### 코드

짜는데 정말 몇 분 안 걸렸다. 확인해보자.

<pre><code class="C++">void solve(vector&lt;int&gt;& cards, int maxNumb) {
    int ret = 0;

    for(vector&lt;int&gt;::size_type i=0; i < cards.size(); i++) 
        for(vector&lt;int>&gt::size_type j=i+1; j < cards.size();j++) 
            for(vector&lt;int&gt;::size_type k=j+1; k < cards.size(); k++) 
                if(max(ret, cards[i] + cards[j] + cards[k]) <= maxNumb)
                    ret = max(ret, cards[i] + cards[j] + cards[k]);

    cout << ret << endl;
} 


int main() {
    int N, M;
    cin >> N >> M;

    vector&lt;int&gt; cards(N);

    for(int i=0; i<cards.size(); i++)
        cin >> cards[i];

    solve(cards, M);
}
</code></pre>

BlackJack problem Solve
{:.figcaption}

### 코드 설명 

**N** 과 **M** 을 입력받고 **cards** 라는  **벡터** 에 카드들을 넣는다. 그 다음 **solve** 함수를 보면 3개의 ***for*** 문으로 이루어져있는 걸 볼 수 있다.<br>
첫 번째 ***for*** 에서는 **card.size()** 만큼 반복을 한다. 두 번째 ***for*** 문에서는 **i** 다음 인덱스부터 끝까지 ***for*** 문을 돌린다. 3번 째 반복문도 
같은 원리로 돌린다. 이 코드의 핵심은 ***if*** 문에 있다. 그 안을 들어다 보면 기존 **ret** 값과 카드 3장 조합을 더한 것 중 더 큰 값이 딜러가 외친 ***M*** 보다 작거나 같으면 
그제서야 **ret** 값에 대입을 한다. <br><br>

> **주의점 !** <br><br>
> ***for*** 문 안에 쓰인 변수를 보면 단순 ***int*** 형이 아닌 ***vector\<int>::size_type*** 을 볼 수 있다. <br>
> ***vector*** 의 ***size()*** 메소드는 ***int***형을 리턴하지 않고 ***size_type*** 형을 리턴한다. <br>
> ***int*** 형을 써도 값은 제대로 나오나 그래도 항상 정석대로 하자.

## 마무리하며

요즘 완전탐색 문제를 많이 풀고 있다. 책을 읽고 알고리즘에 대한 전반적인 걸 이해하고 문제를 푸는데 이 방법이 꽤 괜찮은 것 같다. 다른 알고리즘들도 공부 열심히 해야겠다.
