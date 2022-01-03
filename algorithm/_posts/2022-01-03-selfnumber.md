---
layout: post
title: 백준 셀프넘버(4673)
description: >
    백준 브루트포스
hide_description: false
category: algorithm
image:
  path: https://images.unsplash.com/photo-1620856516969-6b6f1c1e780b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80
---

***본 알고리즘 유형은 C++를 이용하여 해결한다.***
{:.note}

* this unordered seed list will be replaced by the toc
{:toc}

오늘 풀어볼 문제는 백준의 4673번 문제인 셀프넘버 문제이다. 같이 보자

## 문제 설명

>셀프 넘버는 1949년 인도 수학자 D.R. Kaprekar가 이름 붙였다. 양의 정수 n에 대해서 d(n)을 n과 n의 각 자리수를 더하는 함수라고 정의하자. 예를 들어, d(75) = 75+7+5 = 87이다. <br>
>양의 정수 n이 주어졌을 때, 이 수를 시작해서 n, d(n), d(d(n)), d(d(d(n))), ...과 같은 무한 수열을 만들 수 있다. <br>
>예를 들어, 33으로 시작한다면 다음 수는 33 + 3 + 3 = 39이고, 그 다음 수는 39 + 3 + 9 = 51, 다음 수는 51 + 5 + 1 = 57이다. 이런식으로 다음과 같은 수열을 만들 수 있다. <br>
>33, 39, 51, 57, 69, 84, 96, 111, 114, 120, 123, 129, 141, ... <br>
>n을 d(n)의 생성자라고 한다. 위의 수열에서 33은 39의 생성자이고, 39는 51의 생성자, 51은 57의 생성자이다. 생성자가 한 개보다 많은 경우도 있다. 예를 들어, 101은 생성자가 2개(91과 100) 있다. <br>
>생성자가 없는 숫자를 셀프 넘버라고 한다. 100보다 작은 셀프 넘버는 총 13개가 있다. 1, 3, 5, 7, 9, 20, 31, 42, 53, 64, 75, 86, 97 <br>
>10000보다 작거나 같은 셀프 넘버를 한 줄에 하나씩 출력하는 프로그램을 작성하시오. 

시간 제한|메모리 제한
:---|---:
1 초|256MB

## 문제 해결

이 문제의 관건은 반복문의 시작을 어디로 할지 정하는 것이다. 어떤 숫자가 셀프넘버인지 확인하려면 그 전에 숫자들부터 d(n) 을 확인하여 그 숫자인지 확인해야하는 
과정을 거쳐야되는데 그 전에 숫자 시작위치를 1로 잡아버리면 무조건 시간 제한에 걸리게 된다. 그래서 나는 그 구간을 좁히기로 하였다.<br>
그 구간을 어떻게 줄일 것이냐면 각 자리수들에서 9를 더한 값들의 합을 구한 다음에 해당 값에서 그 합한 값을 뺀다. 말이 어려우므로 예시를 통해 보자. <br>

> n = 1234 라고 가정.<br>
> 각 자리수들은 1, 2, 3, 4 이다.<br>
> 그렇다면 각 자리수들에서 9를 더하면 10, 11, 12, 13 이다.<br>
>  10, 11, 12, 13 의 합은 46이므로 1234에서 46을 뺀 1188 에서 부터 셀프넘버가 되는지 검사한다.<br>
> 다만 한자리수일 경우 구간 시작은 0으로 고정한다.

이제 코드를 보도록 하자

### 코드

``` c++
#include <bits/stdc++.h>
using namespace std;

int d(int N) {
    string toStr = to_string(N);

    vector<char> num;

    for(int i =0;i<toStr.length();++i) 
        num.push_back(toStr[i]);

    int sum =0;

    for(const auto &p : num) 
        sum += (p-'0');

    return N + sum;
}


bool isSelfNum(int n) {
    string toStr = to_string(n);
    vector<char> val;
    int sum=0;

    for(int i=0;i<toStr.length();++i) 
        val.push_back(toStr[i]);
    
    for(const auto &p : val) 
        sum += (p-'0')+9;
    
    int start, end;
    
    start = max(n-sum, 0);
    end = n;

    for(int i= start;i<=end;++i)
        if(d(i) == n) return false;

    return true;
}

void printSelfNum() {
    for(int i = 1; i<=10000; ++i)
        if(isSelfNum(i))
            cout << i << endl;
}

int main(int argc, char *argv[]) {
    printSelfNum();
    return 0;
}
```

### 코드 설명

위에 설명한 로직 그대로이다. 10000 이하의 숫자들이 셀프넘버인지 확인하기 위해 문자열 타입으로 변환을 한 다음 각 자리수 별로 나눠준다. 변환한 char 형 변수들을
다시 int 형으로 변환해 9를 더한 sum 값을 구한다. 구간을 `start` 부터 `end` 까지 잡았다면 그 구간들에서 `d(n)` 함수를 거치면 해당 숫자가 되는 숫자가 있는지 확인하고
없다면 그 숫자는 셀프넘버임을 출력해준다.

## 마무리하며 

원래는 `프로그래머스` 문제들 위주로 풀었는데 많은 문제가 있는 `백준` 문제들도 풀어보려고 노력하는 중이다. 더 많이 풀어보자!