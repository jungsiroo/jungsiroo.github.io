---
layout: post
title: 파이썬 itertools 안 쓰고 순열 및 조합 구현하기 (feat.backtracking)
description: >
  코딩테스트 준비
hide_description: false
category: algorithm
image:
  path: https://user-images.githubusercontent.com/54366260/230066497-a3b0495c-e56d-44da-861d-7ec26b78dded.png
---

**해당 썸네일은 `Wonkook Lee` 님이 만드신 [`Thumbnail-Maker`](https://wonkooklee.github.io/thumbnail_maker/){:target="_blank"} 를 이용하였습니다**
{:.figcaption}

요즘 BFS/DFS 및 백트래킹을 공부하면서 알고리즘을 공부 중이다. 오늘은 백트래킹에 대해서 배우는데 예전에 썼던 
[부분조합](https://jungsiroo.github.io/algorithm/2021-12-29-subset/){:target="_blank"} 문제를 파이썬으로 구현하기 위해 이 글을 쓴다.


* this unordered seed list will be replaced by the toc
{:toc}

## 🔌 기존에 쓰던 방법

원래는 파이썬 내장 라이브러리인 `itertools` 에 있는 `combinations` 및 `permutation` 을 사용하여 손 쉽게 쓰곤 했다. 아래는 사용법이다.

<pre><code class="python">from itertools import permutations, combinations

arr = [1,2,3]
k = 2

npr = list(permutations(arr, 2))
# [(1, 2), (1, 3), (2, 1), (2, 3), (3, 1), (3, 2)]

ncr = list(combinations(arr, 2))
# [(1, 2), (1, 3), (2, 3)]
</code></pre>

이처럼 간단하게 쓸 수 있지만 삼성 코딩테스트 같은 itertools 가 사용불가 라이브러리이다. 또한 너무 라이브러리에 종속되면 구현 방법을 모를 수 있으니 이 참에 적어보려 한다.

## 🚀 백트래킹을 이용한 방법

아래는 라이브러리를 사용하지 않고 구현한 방법이다.

<pre><code class="python">array = [1,2,3]
k = 2
used = [False for i in range(len(array))]

def backtrack_perm(arr):
    if len(arr)==k:
        print(arr, end=" ")
        return arr

    for i in range(len(array)):
        if used[i]==False:
            used[i] = True
            backtrack_perm(arr+[array[i]])
            used[i] = False

def backtrack_comb(idx, arr):
    if len(arr)==k:
        print(arr, end=" ")
        return arr

    for i in range(idx+1, len(array)):
        if used[i]==False:
            used[i] = True
            backtrack_comb(i, arr+[array[i]])
            used[i] = False

backtrack_perm([])
# [1, 2] [1, 3] [2, 1] [2, 3] [3, 1] [3, 2]

backtrack_comb(-1, [])
# [1, 2] [1, 3] [2, 3] 

</code></pre>

라이브러리를 사용하지 않은 코드
{:.figcaption}

순열같은 겨우 간단하게 재귀함수를 통해 매개변수에 하나씩 원소를 더해주고 길이가 우리가 원하는 길이만큼 달성됐다면 `arr` 을 리턴해주게 된다.`used` 라는 방문 체크 배열이 필요하다. 

조합은 순서를 고려하지 않기에 중복을 제거해줘야 한다. 그럼 순열에서 중복만 피해주면 되기에 idx 라는 매개변수를 하나 더 추가했다. 앞에꺼는 무시하고 그 다음 것부터 배열을 만드는 것이다. 따라서
`for i in range(idx+1, len(array))` 가 핵심이라 볼 수 있다. 그리고 처음으로 호출할 때는 -1 부터 호출해야 0부터 시작하는 것을 간과하지 말자.

---

간단하게 구현을 마무리해보았다. 이 글이 많은 이들에게 도움이 됐으면 한다.
