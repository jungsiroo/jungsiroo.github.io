---
layout: post
title: 백준 - 순열의 순서 Python
description: >
  코딩테스트 준비
hide_description: false
category: algorithm
image:
  path: https://github.com/jungsiroo/jungsiroo.github.io/assets/54366260/389aede4-7099-4fae-903b-c2c8238c47db
---

**해당 썸네일은 `Wonkook Lee` 님이 만드신 [`Thumbnail-Maker`](https://wonkooklee.github.io/thumbnail_maker/){:target="_blank"} 를 이용하였습니다**
{:.figcaption}

요즘 매일 아침 7시마다 코딩테스트 스터디를 진행 중이다. 그냥 문제를 풀고 휘발시키기 아까워 이렇게 블로그에 남겨두려 한다. 이번에 풀 문제는 
[순열의 순서](https://www.acmicpc.net/problem/1722){:target="_blank"} 이다.


* this unordered seed list will be replaced by the toc
{:toc}

### 🍔 문제

>1부터 N까지의 수를 임의로 배열한 순열은 총 N! = N×(N-1)×…×2×1 가지가 있다.
>
>임의의 순열은 정렬을 할 수 있다. 예를 들어  N=3인 경우 {1, 2, 3}, {1, 3, 2}, {2, 1, 3}, {2, 3, 1}, {3, 1, 2}, {3, 2, 1}의 순서로 생각할 수 있다. 첫 번째 수가 작은 것이 순서상에서 앞서며, 첫 번째 수가 같으면 두 번째 수가 작은 것이, 두 번째 수도 같으면 세 번째 수가 작은 것이….
>
>N이 주어지면, 아래의 두 소문제 중에 하나를 풀어야 한다. k가 주어지면 k번째 순열을 구하고, 임의의 순열이 주어지면 이 순열이 몇 번째 순열인지를 출력하는 프로그램을 작성하시오.
{:.lead}

`Mode가 1`이면 모든 순열 중 K 번째인 순열을 나타내면 되고 `Mode 2` 이면 임의의 순열을 입력받고 그것이 몇 번째인지 알아내면 되는 문제이다.

### 🥚 풀이법

해당 문제를 처음 풀 때 `itertools.permutations` 를 이용하여 전체 조합을 구해놓고 풀려한다면 시간복잡도가 O(n!) 이기 때문에 시간초과가 뜰 수 밖에 없다. 

그렇다면 시간을 어떻게 줄이면 될까?

#### Mode 1인 경우

예를 들어 `N=4` 이라고 가정하자. 

만약 K 가 1이라면? `1 2 3 4` 이다. 

만약 K가 7이라면? `2 1 3 4` 이다.

마지막으로 K가 13이라면? `3 1 2 4` 이다.

K에 따라 골라야될 숫자가 정해지게 된다. 어떻게 정해지느냐? `K를 factorial(뽑아야될 숫자 개수-1) 만큼 나누고 몫과 나머지`를 통해 고르게 된다.

말이 어려우니 예시를 보자

K 가 13 이라고 가정했을 때

<pre><code class="python">mok, left = divmod(K, math.factorial(to_pick-1))
# K=13, to_pick = 4
# mok = 2, left = 1

</code></pre>

위와 같은 식을 거치면 `mok이 2가 나오고 left가 1`이 된다. 이 코드의 뜻은 정해질 숫자는 남은 숫자들의 순열의 개수에 따라 범위가 정해지기 때문에 2가 나왔다는 것은 2로 시작하는 순열 중
하나라는 것이다. left 는 그 2로 시작하는 순열 안에서 몇 번째인지를 알려주는 정보이다. 만약 left==0 이라면 2로 시작하는 순열 직전 순열이라는 것이기 때문에 mok-=1 을 해주어야 한다.

해당 과정을 재귀적으로 구현하면 우리가 얻어내야 할 순열을 알 수 있다.

<pre><code class="python">answer = []

def solve_one(arr:list, k:int):
    global answer

    while len(arr) > 0: # 뽑아야될 숫자가 안 남을 때까지
        mok, left = divmod(k, math.factorial(len(arr)-1))

        if left == 0:
            mok -= 1

        answer.append(arr.pop(mok)) # 뽑은 수는 arr에서 제거를 한다.
        solve_one(arr, left)
</code></pre>




#### Mode 2인 경우

mode가 2인 경우는 mode 1 의 역순으로 생각하면 될 것 같다.

여기서 우리가 집중해야 하는 점은 모든 순열을 미리 구해두는 것이 아니라 `구해야 할 범위를 좁혀나가는 것`이다.

> 그러면 범위는 어떻게 줄여나갈까?
{:.lead}

핵심 아이디어는 특정 숫자로 시작하는 순열은 몇번째부터 몇번째까지 존재하느냐를 알면 된다.

예를 들어, N=4일 때 2로 시작하는 순열은 7번 째부터 12번 째까지 존재한다. 이것을 어떻게 알 수 있냐하면 해당 숫자의 정렬되었을 때 순서 정보와 factorial(뽑아야될 숫자-1) 을 알면 구할 수 있다.

<pre><code class="python">sorted_at = sorted(arr).index(NUMBER)+1 # 순서 정보
fac = math.factorial(len(arr)-1)

start, end = fac*(sorted_at-1)+1, fac*sorted_at 
# start = 7, end = 12
</code></pre>

이렇게 범위를 구하면 첫 번째 큰 범위를 정하고 그 다음부터 점점 좁혀나가는 방식으로 구하면 된다. 만약 다음 start, end 가 1,2 이라면 어떻게 해석하면 될까?

7부터 12까지 중 그 안에서 첫 번째와 두 번째 사이라는 것이다. 그렇다면 start 를 계속 sum 해 간다면 정확히 몇번 째인지를 알 수 있다.

<pre><code class="python">def solve_two(arr:list):
    global answer
    answer = 0

    while arr:
        sorted_at = sorted(arr).index(arr[0])+1
        fac = math.factorial(len(arr)-1)

        start, end = fac*(sorted_at-1)+1, fac*sorted_at
        if start == end: # 답에 도달했을 경우
            answer += start
            break
        answer += start-1 # 1을 빼줘야 마지막 답에 도달했을 때 valid 값 나옴 (start 는 1부터 시작하기 때문)
        
        arr.pop(0)
</code></pre>


### 🚥 마무리

수학을 가미한 문제였고 아침에는 못 풀었는데 더 고민해보고 풀 수 있었던 문제이다. 계속 연습하도록 하자!