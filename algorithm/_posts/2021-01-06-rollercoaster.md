---
layout: post
title: New Year Chaos - 해커랭크
description: >
  HackerRank 완전탐색 문제
hide_description: false
category: algorithm
comments: true
image:
  path: https://images.unsplash.com/photo-1500052718380-9163749cc2c8?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=2089&q=80
---

***[문제 링크](https://www.hackerrank.com/challenges/new-year-chaos/problem?h_l=interview&playlist_slugs%5B%5D=interview-preparation-kit&playlist_slugs%5B%5D=arrays){:target="_blank"}***<br>
***본 문제는 Java를 이용하여 해결하였다.***<br>
***영어 공부를 위해 문제 원문, 해석본을 같이 첨부한다.***
{:.note}

많이 고민한 완전탐색 문제이다 같이 문제를 살펴보자

* this unordered seed list will be replaced by the toc
{:toc}

## 문제 설명

### English

> It is New Year's Day and people are in line for the Wonderland rollercoaster ride. Each person wears a sticker indicating their initial position in the queue. Initial positions increment by 1 from 1 at the front of the line to ***n*** at the back. <br>
> Any person in the queue can bribe the person directly in front of them to swap positions. If two people swap positions, they still wear the same sticker denoting their original places in line. One person can bribe at most two others. For example, if ***n=8*** and ***Person 5*** bribes ***Person 4***, the queue will look like this: ***1, 2, 3, 5, 4, 6, 7, 8***
> Fascinated by this chaotic queue, you decide you must know the minimum number of bribes that took place to get the queue into its current state. If anyone has bribed more than two people, the line is too chaotic to compute the answer.
> <h4> Return</h4>
> <h5>No value is returned. Print the minimum number of bribes necessary or Too chaotic if someone has bribed more than people.</h5>

### 한국어

> 오늘은 새해의 첫날이고 사람들은 '원더랜드' 롤러코스터를 타기 위해 줄을 서 있습니다. 각각의 사람들은 자신의 원래 위치가 적힌 스티커를 착용하고 있습니다. 원래 위치는 1번부터 시작해 1씩 늘어가 ***n*** 번까지 이어져 있습니다. <br>
> 줄에 있는 어느 사람이든 자기 바로 앞에 있는 사람에게 위치를 바꾸기 위해 뇌물을 줄 수 있습니다. 만약 두 사람이 위치를 바꿨다해도, 그들은 처음에 찼던 원래 위치가 적힌 스티커를 착용하고 있습니다. 한 사람은 최대 2명까지 밖에 뇌물을 줄 수 없습니다. 예를 들어, ***n=8***이고 ***Person 5***가 ***Person 4***에게 뇌물을 줬다면 줄의 순서는 이렇게 되있을 겁니다. : ***1, 2, 3, 5, 4, 6, 7, 8***
> 이런 혼란스러운 큐에 따라, 당신은 이러한 큐를 만들기 위해 필요한 뇌물이 최소 몇개인지 알아내려고 결심했습니다. 다만 만약 누군가 2명보다 많이 뇌물을 준 사람이 있다면 그 대답은 계산하기엔 너무 혼란스러울 것입니다.
> <h4> Return</h4>
> <h5>어떠한 값도 리턴되지 않습니다. 큐를 만들기 위해 필요한 최소의 뇌물을 준 사람의 수를 출력하거나 누군가 2명보다 많이 뇌물을 줬으면 Too chaotic을 출력하십쇼</h5>

## <span style="color:#3a8791;">문제 해결</span>

### 시행착오

처음 이 문제를 해결하려 할 때 꽤 많이 고민했다. 혼란스러운 큐가 주어질 때 그 큐를 **Sorting** 하여 **for문** 을 돌려 하나씩 비교해 소팅된 큐의 **index** 와 혼란스러운 큐의 **index** 의 차이를 구해 그 값을 계속 더해가 출력하려 했다. 다만 이 해법의 문제점은 ***1 2 5 3 7 8 6 4*** 와 같은 큐가 주어질 때 그 차이가 **3** 이상이라면 ***Too chaotic***을 출력하기로 한 로직에 걸려 이상한 답을 출력한다. <br>
다음으로 생각한 방법은 **Sorting**을 시켜놓은 다음 소팅된 큐와 혼란스러운 큐가 같아질 때까지 계속 위치를 바꾸기로 한 것이다. 여기서 문제점은 맨 끝에서부터(즉 라인에서의 꼴찌인 n번) 차근차근 바꿔 나가려했으나 아까와 같은 ***1 2 5 3 7 8 6 4*** 큐에서 8이 맨뒤에 있을 때 2명 앞으로 보내고 다음 7을 보내야 되는데 3명에게 뇌물을 줘야되는 상황이 되기 때문에 실패하게 된다. 

### 해결법

위 시행착오들을 거치고 좀 더 생각을 단순화하기로 한다. 우리가 구해야 할 것은 결국 ***뇌물을 준 사람의 수*** 이다. 그렇다면 괜한 ***Sorting***, ***원 위치로 스왑*** 등을 쓰지 않아도 될 것 같다. 아래의 코드를 보자.

<pre><code class="java">public class Rollercoaster {
    static void minimumBribes(int[] q) {
        int ret = 0;

        for(int i=q.length-1; i>=0; i--) {
            if(q[i] - (i + 1) > 2) { //기저 사례 : 한 사람이 3명에게 뇌물을 줬을 때
                System.out.println("Too chaotic");
                return;
            }
            for (int j = Math.max(0, q[i] - 2); j < i; j++) 
                //인당 최대 2명까지만 뇌물 가능
                if (q[j] > q[i]) ret++;
        }

        System.out.println(ret);
    } 
}
</code></pre>

New Year Choas 문제 해결
{:.figcaption}

### 코드 설명

일단 **q**의 길이만큼 ***for***문을 돌린다. 여기서는 0에서부터가 아닌 **q**의 끝부터 시작한다. ***if*** 안을 보면 기저사례로 한 사람이 2명보다 많이 뇌물을 줬으면 ***Too chaotic***을 출력한다. 그 다음 ***for*** 문을 보면 **0** 과 **q[i]-2** 중 더 큰 값을 시작값으로 **i**까지만큼 돌린다. 왜 **q[i]-2**일까?<br>

>**이유는 간단하다. 한 사람당 매수할 수 있는 최대 2명이기 때문이다.**

이 로직은 2사람 앞 인덱스에서부터 탐색을 현재 자신 위치까지 탐색을 해 만약 **q[j]**가 **q[i]**보다 크면, 즉 뇌물을 줘서 앞으로 갔으면 **ret** 값을 올린다. 그렇다면 **j=q[i]-2**를 하면 됐을텐데 왜 **0** 과 **q[i]-2** 중 더 큰 값을 시작값으로 잡을까?<br>
다음 예를 보자. **2 1 5 3 4** 와 같은 큐가 주어졌다. 현재 **i**가 1이라 가정하면 **q[1]-2**는 **-1**이 된다. 즉 ***IndexOutofbounds Exception*** 이므로 이 오류를 대비하기 위해 최소값 **0**을 설정해준 것이다.

## 마무리하며

이 문제는 옛날에 내가 시도했다가 실패한 문제이다. 군대에서 다시 도전해 푼 문제인만큼 기억에 많이 남을 것 같다. 완전탐색 문제를 좀 더 단순히 생각하여 푸는 방법들도 더욱 연구해봐야겠다.
