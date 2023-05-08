---
layout: post
title: 논문 리뷰 - Youtube Recommendations
description: >
  Deep Neural Networks for YouTube Recommendations
hide_description: false
category: aistudy
image:
  path: https://user-images.githubusercontent.com/54366260/236671882-f30bfdd7-d042-4019-9aff-61f0dc46db06.png
---

**해당 썸네일은 `Wonkook Lee` 님이 만드신 [`Thumbnail-Maker`](https://wonkooklee.github.io/thumbnail_maker/){:target="_blank"} 를 이용하였습니다**
{:.figcaption}

논문 스터디를 시작하고 첫 발표를 어떤 논문을 리뷰해야될지 고민하다가 딥러닝을 이용한 유튜브의 추천 시스템 논문을 하기로 하였다. 추천시스템을 공부하려면
거의 필수 논문이라고 생각되는만큼 조금 더 재밌고 이해하기 쉽게 리뷰할 생각이다. 

이 논문을 통해 전반적인 추천시스템의 방향, 딥러닝은 어떻게 추천시스템에 활용되는지 보면 좋을 것 같다. 2016년에 나온 논문이지만 올드하지 않다고 생각된다.

* this unordered seed list will be replaced by the toc
{:toc}

# ⌚️ Abstract

유튜브는 추천시스템 상에서 큰 규모와 정교함을 대표하는 시스템 중 하나이다. 이 논문에서는 `high level` 위주로 해당 시스템을 설명하며 딥러닝을 사용하여 드라마틱하게 향상된 성능에 대해
집중하고자 한다. 논문의 흐름을 크게 2개로 나눌 수 있는데 하나는 **`deep candidate generation model`** 과 다른 하나는 **`deep ranking model`** 으로 나눌 수 있다. 

이 두 가지를 집중적으로 보고 이들이 이런 시스템을 구축할 때 얻은 insight 와 practical 한 교훈을 같이 보도록 하자.

# ⚙️ Introduction

유튜브 추천은 수억명의 유저에게 점점 늘어나는 방대한 양의 비디오 속에서 개인화된 추천을 해야하는 의무가 있다. 이 논문에서는 딥러닝이 추천에 미친 막대한 영향에 대해 포커싱하려 한다. 
유튜브 비디오 추천은 크게 3가지의 관점에서 큰 challenge 들이 존재한다.

> * Scale : 작은 스케일에서 작동이 잘 되는 수 많은 추천 알고리즘은 유튜브와 같이 큰 스케일에서는 작동하지 않음.
> 그에 따라 고도화된 분산된 학습 알고리즘과 serving system 이 요구됨
>
> * Freshness: 유튜브는 굉장히 다이나믹한 corpus 를 가진 방대한 양의 비디오가 존재함. 추천시스템은 새로운 컨텐츠와 유저의 최근 행동에도 반응성이 뛰어나야 함.
> 잘 알려진 동영상과 새로운 컨텐츠의 균형을 맞추는 것이 요구됨 
> 
> * Noise: 희소성과 관측 불가능한 외부 요인으로 인해 과거 유저의 행동을 예측하기 어려움. 그에 따라 사용자 만족도에 대한 ground truth 데이터를 거의 확보하지 못함.<br>
> 그 대신 노이즈가 많은 implicit 피드백 시그널을 모델링함. 나아가, 컨텐츠와 관련된 메타데이터는 잘 정의된 온톨로지 없이는 제대로 구조화되지 않음.
> 그렇기에 학습 데이터의 특성에 맞게 알고리즘을 강력히 설계해야 함.
{:.lead}

활발히 진행되는 `MF(Matrix Factorization)` 연구와 달리 `deep neural networks` 를 활용한 연구는 추천시스템에서 찾기 힘들다. 또한 `CF(Collaborative Filter)` 같은 경우
몇몇 연구에서 deep neural network 와 autoencoder 로 활용되기도 하였다.

이제부터 유튜브는 `deep neural network` 를 어떻게 활용했는지, 무엇을 얻었는지 설명한다.

# 🚲 System Overview

![image](https://user-images.githubusercontent.com/54366260/236681386-f08255e1-f65e-4096-b55b-358f677c3335.png)

Overall Structure of Recommendation System
{:.figcaption}

위 그림은 전체적인 추천시스템을 보여주는 그림이다. 그림에서 볼 수 있듯 총 2단계로 `후보 생성 모델`과 `랭킹 모델` 로 이어져있다. 

## Candidate Generation Model

해당 모델은 유저의 유튜브 활동 기록을 input 으로 사용하여 100 개 정도의 비디오를 받아오게 된다. 이러한 후보들은 사용자와 관련성과 정밀도가 높다. 

`candidate generation model` 은 오로지 `Collaborative Filtering` 을 통하여 광범위한 개인화 추천을 해주게된다. 
또한 유저간의 유사도는 영상 시청 ID, 검색 쿼리 토큰과 demographic 정보를 통해서 표현이 된다.


## Ranking Model

소수의 최적의 추천을 하기 위해서는 후보들 중 `높은 recall`의 세분화된 수준의 표현이 필요하다. 이러한 작업을 위해 `ranking model` 이 존재한다.

랭킹 네트워크는 영상과 사용자를 설명하는 다양한 기능을 사용하여 원하는 목적 함수에 따라 각 동영상에 점수를 할당하게 된다. 이를 내림차순으로 정렬하여 최종적으로 유저에게 추천이 된다.

## Precision vs. Recall

`candidate generation model` 은 `high precision` 을, `ranking model` 에서는 `high recall` 을 기준으로 나뉘게 된다. 그 이유를 알아보자.

Precision 은 정밀도를 뜻하면 간단하게 `모델이 True라고 분류한 것 중에서 실제 True인 것의 비율` 이다. 후보 생성 모델에서는 말 그대로 후보를 먼저 뽑아내야 하기에 
모델이 `나의 추천 중 괜찮은 영상을 줄게` 와 같다고 볼 수 있다. 

반면 Recall 은 반대로 `실제 True인 것 중에서 모델이 True라고 예측한 것의 비율` 이다. 랭킹 모델은 후보들 중 유저에게 더 알맞은 영상을 높은 랭킹을 부여해야하므로
모델이 `실제 답 중 나의 추천이랑 똑같은 영상을 추천해줄게` 라고 해석하면 편할 것 같다.

## Overall

이러한 파이프라인은 추후 다른 소스로부터 만들어진 후보를 Blending 할 수 있다는 점에서 이점이 있다.

저자는 이 파이프라인을 개발하면서 다양한 오프라인 메트릭을 사용하여 점진적으로 그 성능을 올려갔다고 한다. 다만 해당 알고리즘과 모델을 평가할 때는 
실제 환경에서 A/B 테스트에 의존하였다고 한다. Online 테스트 같은 경우 CTR, 시청 시간, 유저의 작용을 측정할 수 잇는 메트릭 등을 활용하였다고 한다. 이 부분은 추천시스템에서 
어찌보면 기본이 되는 것인데 오프라인 테스트와 온라인 테스트는 꼭 상호관계가 있지 않기 때문이다.

# 💊 Candidate Generation

이제 본격적으로 하나하나 뜯어서 살펴보자. 처음으로는 후보 생성 단계이다. 후보 생성 단계에서는 엄청난 양의 영상 중 100 개 정도의 후보를 만든다. 
이 논문이 나오기 전은 `rank loss` 아래 훈련된 `Matrix Factorization` 이었다. 초반 단계에서는 유튜브의 추천 모델은 얇은 네트워크를 통해 이를 모방하였는데
여기서 네트워크는 단순히 유저의 이전 시청 기록을 임베딩한 것이다. 

이러한 관점에서 보면 이들의 접근법은 어찌보면 Factorization 의 비선형 일반화로 볼 수 있다.

## Recommendation as Classification

저자들은 추천을 극도의 classfication 문제로 바꾸어서 생각했음. 그 방식은 아래와 같음

유저 $$U$$ 가 특정 시간 $$t$$ 에 가지고 있는 $$Context\,c$$ 를 이용해 어떤 영상을 볼지 
즉 $$i$$ 클래스를 맞추는 문제이다. 아래의 수식을 보면 softmax 수식임을 알 수 있다.

$$
P\left(w_{t}=i \mid U, C\right)=\frac{e^{v_{i} u}}{\sum_{j \in V} e^{v_{j} u}}
$$

여기서 사용된 임베딩 벡터들은 단순히 희소 entities 를 매핑하여 얻어진 dense 한 벡터이다. 여기서 deep neural network 이 할 일은 
`softmax classifier` 를 이용하여 영상을 구분하는데 유용한 유저의 히스토리 및 컨텍스트의 함수로서 유저 임베딩 $$u$$ 를 학습하는 것이다.

`explicit 피드백 메커니즘`이 유튜브에 존재하기는 하나, 이들은 `implicit feedback` 을 통해 모델을 학습시켰다. 여기서 영상을 끝까지 본 샘플을 positive example 로 썼다 한다.
이러한 선택은 사용 가능한 implicit 기록이 훨씬 더 많기 때문에 explicit 피드백이 극히 드문 tail 부분에 대한 추천을 생성할 수 있다고 한다.

![image](https://user-images.githubusercontent.com/54366260/236688144-80f3df55-3acb-40e5-873d-ca67e46487bf.png)

About Long-Tail
{:.figcaption}


### _Efficient Extreme Multiclass_

수백만 개의 클래스를 가진 모델을 훈련시킬 때의 문제점을 `Negative Sampling` 을 통해 해결했다고 한다. 
Softmax classification 에서 클래스의 갯수가 늘어날때의 문제점은, 가능한 모든 클래스에 대해 내적을 수행하기 때문에 계산량이 기하급수적으로 증가한다는 데에 있다. 
하지만 샘플링을 통해 기존 softmax 보다 약 100배 가량 스피드를 올릴 수 있다고 한다. 

또한 `Seving Latency` 도 고려를 해야하는데 사용자에게 표시할 상위 N개를 선택하려면 가장 가능성이 높은 N개의 클래스(영상)를 계산해야 한다.
유튜브 시스템은 해싱에 의존했으며, 여기에 설명된 분류 방식도 유사한 접근 방식을 사용한다. 

소프트맥스 출력 레이어에서 보정된 가능성 은 서빙 시점에 필요하지 않으므로, scoring 문제는 라이브러리를 사용할 수 있을만큼의 도트 프로덕트 공간에서 가장 가까운 이웃 검색으로 축소된다.

이들은 이는 A/B 테스트 상에서 크게 민감하지 않았다는 것을 밝혔다.

## Model Architecture

후보 생성의 모델의 아키텍쳐를 먼저 그림으로 본 뒤 설명을 하도록 하겠다.
<br>

![image](https://user-images.githubusercontent.com/54366260/236689068-51ba8ede-4c46-44ee-abc4-d05ef959c4d6.png)

Deep candidate generation model architecture
{:.figcaption}

CBoW 모델에 영감을 받은 이 모델은 각 영상의 고차원 임베딩을 고정 어휘로 학습하고 이를 neural network 에 feed 해준다. 저기서 `video watches` 와 `search tokens` 는
유저 한 명의 시청 이력과 검색 기록이다. 이러한 고차원의 임베딩 벡터는 각 영상을 고정된 vocabulary 들을 통해 학습이 진행된다.

그림에서 볼 수 있듯 저자는 모델에 feeding을 하기 위한 많은 전략 중 평균을 내는 것이 가장 좋은 성능을 냈기에 averaging 방법을 택했다고 한다. 
이러한 임베딩은 다른 모델 파라미터와 함께 업데이트가 진행된다. 

## Heterogeneous Signals

Matrix Factorization의 일반화 버전인 deep neural network 의 장범은 `임의의 연속 및 범주형 특징을 모델에 쉽게 추가할 수 있다는 것` 이다. 검색 기록은 시청 기록과 비슷하게 
처리된다. 검색 쿼리는 unigram 과 bigram 으로 토큰화되고 임베딩된다. averaged 가 되고나면 이러한 임베딩 쿼리는 요약된 고밀도의 검색 기록으로 나타나게 된다.

추천시스템이 해결하고자 하는 `cold start` 문제는 `demographic` 정보를 통해 해결을 한다고 한다. 지리적 특성 및 기기 정보가 임베딩 되어있으며 그 두개는 이어져있다고 한다.
또한 성별, 로그인 상태, 나이같은 경우는 0과 1 사이로 normalized 되어 input 으로 들어간다고 한다.

여기서 구글의 demographic 정보가 강력하다는 것을 알 수 있다. 단순 demographic 정보만으로 cold start user 에게 적절한 영상을 추천 해줄 수 있는 것이 신기하다.

### _Example Age Feature_

유튜브는 새롭게 올라온 (Fresh) 한 영상을 추천하는 것이 굉장히 중요하다고 한다. 그들에 의하면 유저들은 자신과 연관있지 않더라도 새로운 영상을 선호한다고 한다.

하지만 머신러닝 시스템은 과거의 데이터를 통해 미래를 예측하는 것이기에 종종 과거에 대한 결과를 보여주는 경향이 있다. 이러한 것을 해결하기 위해 각 트레이닝 샘플의
나이를 새로운 피쳐를 추가해주었다고 한다. 그 결과 아래와 같이 baseline 대비 엄청난 성능 향상의 폭을 보여주게 되었다. 

![image](https://user-images.githubusercontent.com/54366260/236691814-5e25674b-172c-443a-b3a4-8978efd2ff84.png)
Example age 를 추가한 모델의 경우 최신 영상(0-10 사이의 영상)이 많이 추천되는 것을 볼 수 있다.
{:.figcaption}

## Label and Context Selection

추천시스템 같은 경우 `surrogate problem` 을 해결해야 하는 상황이 있으며 이를 위해 특정 context 로 변환해야하는 경우가 있다.
그 예시로는 영화 추천에서 볼 수 있는데 영화의 평점을 예측하는 문제를 풀어 높은 평점을 가진 영화를 추천하는 것이 성공적인 추천으로 이어지는 경우가 있다.

> surrogate problem : 추천시스템의 경우 유저의 피드백을 통해 그 성능을 가늠해야 하지만 그것을 얻기 힘들기에
> mAP, RMSE 와 같은 메트릭을 활용하여 그 성능을 평가하는 것
{:.lead}

해당 논문에서 사용된 데이터는 자신들이 추천한 것뿐만이 아닌 당연하게도 모든 종류의 유튜브 시청 기록을 이용한다. 그렇지 않을 경우 추천한 영상에 대해서만
기울어지는 편향 문제가 발생할 수 있기 때문이다.

또한 추천을 통하지 않은 영상을 봤을 경우, `Collaborative Filtering` 을 통해 다른 유저에게도 이를 적용한다고 한다. 

추가적으로 각 유저마다 한정된 개수만큼의 샘플을 사용하는데 그 이유는 작은 그룹의 헤비 유저의 데이터에 의해 편향된 결과를 초래할 수 있기 때문이다. 

본 논문에서는 `Taylor Swift` 를 검색했을 때를 예시로 든다. 추천의 주요 목적은 `다음에 볼 영상을 추천`하는 것이다. 
그렇다면 과연 다음에 볼 영상을 `Taylor Swift` 영상을 추천하는 것이 옳은 추천일까? 논문에서는 마지막 쿼리를 기반으로 한 추천같은 경우, 성능이 굉장히
안 좋다고 언급한다.

그렇다면 그 이유는 무엇일까? 유저의 소비 패턴은 굉장히 비대칭적이기 때문이다. 예를 들면 시리즈로 이루어진 영상을 보았을 경우, 그때는 계속 이어서 볼 가능성이 높다.
하지만 단일 영상에 대해서는 한번 보고마는, 혹은 한 번 검색해본 경우일 수도 있다. 

유튜브는 이와 같은 비대칭 문제를 해결하기 위해 유튜브는 랜덤에 관해 prediction 을 진행하는 것보다 next prediction 을 통해 위와 같은 비대칭 문제를 해결하였다고 한다. 이는 글보다 그림을 통해 보면 이해가 더욱 빠르다.

<br>

![image](https://user-images.githubusercontent.com/54366260/236729083-67641d1b-0e8a-4b59-be93-8dc5ef9110d2.png)

random prediction인 (a)와 다르게 이전 시점만을 input 으로 사용한 next prediction (b)
{:.figcaption}

여타 기존 `Collaborative Filter` 같은 경우 모든 아이템들을 펼쳐놓고 유저의 이력을 이용하여 그 중 추천할만한 아이템을 찾는 것이다. 이는
미래 정보에 대한 leakage 가 발생하며 또한 비대칭 소비 패턴을 무시하는 경향이 있다. 이것을 해결하고자 `b 방법`을 채택하였다고 한다.

<br>

# ☄ Ranking

랭킹 모델같은 경우 만들어진 후보군 중에서 유저가 정말 볼 것 같은 영상의 랭킹을 메기는 간단한 deep 네트워크이다.

![image](https://user-images.githubusercontent.com/54366260/236730268-641bc103-c416-44b4-b96f-72f2aabfbf21.png)

Deep ranking network architecture
{:.figcaption}

그림에서 볼 수 있듯 네트워크의 레이어는 `Candidate Generation Model` 과 비슷하다. 하지만 사용하는 피쳐가 수백개 정도라 한다.
해당 논문에서는 단순 CTR 을 통해 랭킹을 계산하지 않는다고 한다. 그 이유는 썸네일과 같은 이유로 `Click bait` 가 일어날 수 있는 영상이 많을텐데 이는
proper 한 메트릭이 아니게 된다. 

그래서 저자들은 `impression 에 따른 시청 시간`을 예측하는 식으로 랭킹을 계산한다고 한다. 이제 어떠한 사고방식을 통해 feature engineering 을 거치는지,
또한 categorical features 와 continuous features 를 어떻게 다루는지 살펴봐자.

## Feature Representation

이들이 사용하는 피쳐는 수백가지 정도가 된다. 이러한 수많은 피쳐들은 `categorical features` 와 `continuous features` 로 나뉘게 된다. 
그 중 `categorical features` 의 예로는 binary 인 로그인 상태, 유저의 마지막 검색 쿼리, impression 스코어를 부여할 영상ID, 마지막 N 개의 시청 기록등이 있다.

이러한 방대한 categorical features 를 어떻게 다루는걸까?

### Feature Engineering

비록 deep learning 같은 경우 피쳐 엔지니어링의 부담을 덜어준다는 장점이 있지만, 유튜브가 가지고 있는 raw data 를 그대로 넣기에는 무리가 있다.
따라서 유저와 영상의 유용한 피쳐들을 결국 뽑아내야 한다는 것이다. 해당 문제에서의 핵심은 유저의 액션을 특정 시퀀스로 표현하고 그 액션과 스코어될 영상간의 관계를 찾아내는 것에 있다.

이들이 발견한 가장 중요한 시그널은 `특정 아이템과의 유저의 과거 행동 이력` 이라고 말한다. 아래와 같은 부분들을 고민할 수 있다고 한다.

> * 해당 채널에서 유저는 얼마나 많은 영상을 보았는가?
> 
> * 해당 토픽과 관련하여 마지막으로 본 영상은 언제인가?
{:.lead}

해당 정보는 어떠한 아이템이라도 그 유저의 과거 행동을 일반화하는데 강력한 continuous 피쳐가 된다고 한다. 또 다른 중요한 포인트로는 candidate generation 모델로부터
온 정보이다.

> * 어떤 candidate generation 에서 왔는가?
> 
> * 후보 모델에서 몇 점의 스코어를 받았는가?
{:.lead}

### Embedding Categorical Features

`candidate generation` 과 비슷하게 굉장히 희소한 성격의 categorical features 를 dense한 임베딩 벡터로 매핑한다고 한다. 해당 논문에서는
방대한 categorical features 를 어떤 과정으로 임베딩 벡터로 매핑하는지는 세세하게 안 나와있어 이해가 조금 어려웠다. [참고자료](https://yamalab.tistory.com/124) 를 통해 이해가 수월해졌다.

간단하게 설명하면 impression 클릭 빈도수에 따라 오로지 상위 N개를 사용하여 임베딩을 진행하고, N개에 포함되지 않은 `Out-of-vocabulary` 들은 zero-embedding 으로 매핑이 된다고 한다.

또한 추가적으로 동일한 영상에 관해서는 그 영상에 대한 `global embedding` 을 활용한다고 한다. 위 그림에서 볼 수 있는 `video embedding` 이 그것이다. 
이 `video embedding` 같은 경우 `impression 영상ID, 마지막으로 유저가 본 영상ID, 해당 추천을 해준 seed 영상ID` 를 활용하여 만들어진 것이다. 

`global embedding` 은 공유하면서 개별적인 feature를 덧붙여 사용하면 일반화 성능에서의 이점과 훈련 속도 및 메모리 관점에서 이득을 볼 수 있다고 한다. 

### Normalizing Continuous Features

NN 은 일반적으로 의사결정 트리와 달리 스케일링과 분포에 예민한 편이다. 그렇기에 적절한 스케일링이 중요한데 해당 논문에서는 0과 1 사이로 스케일링을 거치며 $$x^2$$ 과
$$\sqrt{x}$$ 를 새로운 피쳐를 넣어준다고 한다. 이러한 인풋은 super & sub linear 함을 모델이 쉽게 배울 수 있도록 하기 위함이라고 한다.

## Modeling Expected Watch Time

초반에서 말했듯 이들의 목표는 영상 시청 시간을 예측하는 것이었다. 그 속에서 `Positive(노출된 영상 클릭)` 과 `Negative(클릭하지 않음)` 을 이용하여 훈련을 한다고 한다.
여기서 중요한 점은 Positive 샘플에서 유저가 해당 영상을 얼마나 봤는지를 같이 활용한다고 한다. 이를 `Weighted Logistic Regression` 을 통해 예측을 한다.

모델은 `cross-entropy loss` 아래 훈련이 된다. 여기서 positive 샘플들은 시청 시간에 따라 가중치가 부여되며 negative 샘플들은 모두 단위 가중치만 부여된다. 

# 🧨 Conclusion

이 논문에서 중요 포인트라면 비대칭적인 문제를 next prediction 을 통해 해결한 점, freshness 가 중요한 유튜브의 생태계 속에서 example age 를 통해 이러한 점을 극복한 것, 
피쳐 엔지니어링을 통해 중요한 피쳐를 활용하여 기존 linear 모델에서는 찾지 못한 non-linear 한 특성을 DL 을 통해 찾아낸 것이라고 볼 수 있다.
마지막으로 CTR 기반의 메트릭이 아닌 시청 시간을 통한 메트릭으로 A/B 테스트에서 큰 성능 향상을 이뤄낸 것이 주목할만한 포인트라고 생각한

