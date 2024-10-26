---
layout: post
title: Dacon 웹기사 추천 대회 솔루션 공유 (Top 11%)
description: >
    추천시스템 대회
hide_description: false
category: devlife
image:
  path: https://github.com/user-attachments/assets/99fc9c27-4741-4be8-b2b2-1e138dc36771
---

**474명의 참가자 중 13위**
{:.figcaption}

* this unordered seed list will be replaced by the toc
{:toc}


6월 한 달 간 진행했던 추천시스템의 대회를 이제서야 공유하고자 합니다. 왜 이렇게 늦게 적느냐 하면,,,

> * 한창 저 주간이 바빴으며, 코드를 다 정리하고 올리고자 했습니다.
> * 코드 정리가 귀찮았다가 이제야 고쳤습니다..🥸
{:.lead}

이제 어떻게 해서 13위를 기록했고 남들과는 다른 솔루션을 왜 활용했는지를 기록해보겠습니다.

# 🥽 데이터 파악 및 EDA

일단 대회에 앞서 데이터가 어떻게 구성되있고 어떤 특성들을 가지고 있는지를 알아볼까요?

## view_log - train 데이터
> 유저가 기사를 조회한 로그 데이터
{:.lead}

* 학습 데이터이며 해당 데이터에 존재하는 유저만 추천의 대상이 됨
* userID : 유저 고유 ID
* articleID : 기사 고유 ID
* userRegion : 유저가 속한 지역
* userCountry : 유저가 속한 국가

## article_info - meta 데이터
> 기사에 대한 정보
{:.lead}

* articleID : 기사 고유 ID
* Title : 기사의 제목
* Content : 기사의 본문
* Format : 기사의 형식
* Language : 기사가 작성된 언어
* userID : 기사를 작성한 유저 고유 ID
* view_log에 포함되지 않은 유저가 존재할 수 있으며, 해당 유저는 추천의 대상이 되지 않음
* userCountry : 기사를 작성한 유저가 속한 국가
* userRegion : 기사를 작성한 유저가 속한 지역


이제 이 대회의 평가 방식을 알아봅시다.

대회의 평가지표는 `Recall@5` 입니다. 실제 유저가 본 기사 중 모델이 예측한 기사의 비율을 의미하는데요. 뒤에 @5 가 의미하는 것은 실제 유저가 본 모든 기사 중 모델이 추천한 상위 Top 5개의 비율을 의미합니다.

예전에 유튜브 추천시스템 논문을 다뤘을 때 Precision vs Recall 을 비교한 바 있습니다. 뉴스 기사 같은 경우 시시각각 변하는 상황 속에서 `유저가 좋아하는 것을 추천하는 비율`을 높이는 것이 목표가 될 것이기에 
precision 보다는 Recall 을 활용하는 것이 조금 더 낫다고 생각합니다. 

추가로 `이미 조회한 기사`도 추천의 대상이 되는데요. 현실 세계에서는 조금은 거리가 있는 이야기 같습니다. 뉴스 기사의 특성을 생각해본다면 같은 사건을 다룬 여러 기사를 볼 수는 있어도 똑같은 기사를 반복적으로 조회하는 일이 적을 거 같다고
생각합니다,, 하지만 이 역시 데이터를 통해 알아보고자 합니다. 

본격적으로 데이터를 파헤쳐봅시다

## ⭐️ view_log EDA

| userID      | articleID    | userRegion | userCountry |
|-------------|--------------|------------|-------------|
| USER_0000   | ARTICLE_0661 | NY         | US          |
| USER_0000   | ARTICLE_1484 | NY         | US          |
| ...         | ...          | ...        | ...         |
| USER_1420   | ARTICLE_0682 | SP         | BR          |
| USER_1420   | ARTICLE_0030 | SP         | BR          |
| USER_1420   | ARTICLE_2423 | SP         | BR          |

데이터는 이와 같이 구성되어 있습니다. 한 유저가 동일한 기사를 조회할 수 있으며 time stamp와 관련된 정보들은 없습니다. 그나마 유저가 기사를 조회할 때 기록된 국가와 지역 등을 볼 수 있지만 time stamp 관련 정보가 없기에
섣부르게 어느 데이터가 선행하는지는 단정짓기 힘듭니다.

<img width="840" alt="image" src="https://github.com/user-attachments/assets/da9ef1e3-6095-4bb4-aa71-8ef106ede4b0">

**userID, articleID 별 중복 횟수 조회**
{:.figcaption}

그림에서 보다시피 한 유저가 동일한 기사를 많이 조회하는 것을 볼 수 있으며 한 유저가 최대 37번의 동일 기사를 조회한 결과도 볼 수 있습니다. 이로써 위에 가정한 평범한 뉴스 기사 데이터는 아닌 걸로 보입니다.
특히 무한하게 쏟아지는 뉴스 기사 속에서 다음 기사를 추천하는 것이 아닌 한정된 아이템 내에서 추천을 해야한다는 점을 알 수 있습니다.

### Country

기사들은 어디에서 조회될까요? 어디 국가에서 기사들을 보여주고 있는지를 확인해봅시다

![image](https://github.com/user-attachments/assets/a804b465-0a2e-4fea-b883-8be96ce17ec9)

대부분의 경우 압도적으로 브라질에서 조회가 되고 있으며 미국이 그 뒤를 잇고 있습니다. 아까 설명한 데이터의 특성 중 (유저, 기사) pair는 중복될 수 있으나 그 중 그 국가나 지역이 다르면 view_log에 또 다른 데이터로 쌓이게 된다고 했습니다.
이제 제가 알아보고 싶은 건 `기사 별로 어디 국가에서 조회가 많이 됐나`를 따지려 합니다. 이를 통해 특정 기사가 특정 국가에서만 많이 조회되는 국지성 인기 기사임을 알고 추후 방향을 정할 수 있을 것 같습니다.

![image](https://github.com/user-attachments/assets/f4a1cb18-df08-40c6-9a5f-939ef0d7835e)

**기사 별 브라질 조회 비율**
{:.figcaption}

약 절반이상의 기사가 브라질에서만 조회되는 기사임을 알 수 있습니다. 또한 꽤 높은 비율로 브라질에서 주로 기사되는 기사들을 볼 수 있습니다. 여기서 얻을 수 있는 점은 아래와 같습니다.

* 브라질 거주자를 타게팅하여 기사 추천이 이뤄져야 한다.
* 브라질의 언어인 포르투갈어로 쓰인 기사의 특성을 봐야한다.


이후에는 큰 특징이 없어 마무리를 하고 다음 EDA를 진행합니다.

## 📰 article_info EDA

앞선 EDA에서 기사의 메타 정보를 깊게 파악해야 좋은 추천이 이뤄질 것이라는 기대를 할 수 있습니다.

데이터는 아래와 같이 구성되어 있습니다.


| Field        | Value                                                  |
|--------------|--------------------------------------------------------|
| articleID    | ARTICLE_2496                                          |
| Title        | Machine learning is a poor fit for most businesses    |
| Content      | Machine learning is the new battle cry for the...     |
| Format       | HTML                                                  |
| Language     | en                                                    |
| userID       | USER_0222                                             |
| userCountry  | NaN                                                  |
| userRegion   | NaN                                                  |


이제 차근차근 뜯어보겠습니다

### Language

기사가 쓰인 언어를 말합니다. 아래와 같은 분포로 이루어져 있습니다.

![image](https://github.com/user-attachments/assets/1a5281e7-81e0-4e9a-8a37-82979f860784)

총 5개의 unique 한 언어가 있으며 영어로 된 기사가 약 65%이상을 차지하고 있습니다. 브라질 국가에서 많이 조회되어 포르투갈어 기사가 많을 줄 알았으나 두 언어를 혼용해서 쓰는 만큼 그럴 수 있다고 봅니다.

그러면 조금 더 생각을 확장하면 각 언어 별 기사 조회 비율은 어떻게 될까요? 분명 브라질에서 다수의 조회 데이터가 있지만 기사 자체는 영어가 많은 이 경우에서는 비율을 따져볼 필요가 있다고 생각했습니다.

| **Language** | **view_sum** | **count** | **avg_view_per_lang** |
| --- | --- | --- | --- |
| en | 27612 | 2065 | **13.371** |
| es | 6 | 2 | 3.000 |
| ja | 24 | 2 | 12.000 |
| la | 29 | 2 | 14.500 |
| pt | 15046 | 808 | **18.621** |

**view_sum : 해당 언어 조회 기록 합, count : 해당 언어로 쓰여진 기사 수**
{:.figcaption}

역시 포르투갈어의 평균 조회가 더 많은 것을 알 수 있습니다. 이런 경우 기사의 컨텐츠를 text 임베딩을 한다 했을 때, 포르투갈어를 어떻게 처리할지, 영어와 같이 처리할지를 고민하게 됩니다. 
나머지 언어들을 비율만 본다면 낮다고는 할 수 없으나 `count` 절대값이 무시할 수 있는 수준이기에 우선순위를 낮출 수 있을 것 같습니다.

### Content Length

한국의 `3줄 요약 좀` 이 해당 웹 기사 데이터에서도 발견될까요? 텍스트 데이터라면 추천시스템 상에서 그 길이도 중요하게 작용할 것 같습니다. 
제목과 본문의 길이를 파악해봤습니다.

![image](https://github.com/user-attachments/assets/85536711-d659-43c3-8351-a9d4309995c8)

**길이 파악**
{:.figcaption}

제목은 비교적 고르게 분포되어있으나 컨텐츠 길이가 꽤 차이가 나는 것 같네요. 그렇다면 이러한 데이터의 분포가 `기사 클릭`에 영향을 미칠까요?
기사 별 조회 기록 수와 길이의 상관관계를 알아봅시다.

![image](https://github.com/user-attachments/assets/ac17bd50-e3bd-40af-90a8-bf6066a46a5f)

**기사 별 조회 수와 길이의 상관관계 heatmap**
{:.figcaption}


상관관계를 해석할 때 인과관계로 해석하지 말아야 함을 유의합시다. 위와 같은 경우 그 값이 0 부근대로 측정됐으며 이때는 두 피쳐가 서로 아무런 관계가 없다고 판단할 수 있습니다. 메타 정보로 기사의 길이를 쓰는 것은 우선순위를 낮출 수 있을 것 같습니다.

## 🏃‍♂️‍➡️ 중간 정리

위 데이터 분석을 통해 아래와 같은 점을 알 수 있습니다.

> * 시간적 정보가 없기에 validation set을 구성하기가 쉽지 않을 것이다.
>
>     * 보통 마지막으로 본 아이템을 ground truth로 두어 next item prediction 문제로 풀기에
> * 메타 정보가 너무 약하다. 적어도 기사의 카테고리 정보 등이 있었다면 더욱 수월했을 것, 컨텐츠의 길이가 너무 길고 다양한 언어로 작성되있음
> * 유저의 정보가 너무 약하다. 끽해야 알 수 있는 건 유저가 기사를 써본 적 있는지, 유저의 국가 지역 정도
{:.lead}

그렇다면 진행할 수 있는 방법들이 제한됩니다. 

1. 자신이 본 기사들과 유사한 기사들 추천하기
2. 유저 - 기사 간의 조회 수를 관심도로 보고 `Collaborative Filtering` 진행

복잡한 모델은 쓰기가 어렵습니다. 이유는 `시간적 정보`가 부재하기 때문입니다. 여기서 말하는 복잡한 모델이란 Neural 네트워크를 사용하는 모델들입니다. 엄밀히 말하면 풍부한 임베딩을 만드는 모델이겠죠.
추천시스템은 크게 2가지의 갈래길이 있습니다. `Next Item Prediction` 과 `Rating Prediction`. 이 갈래길 안에서 많은 방법론들이 존재하는데요. (아니라면 지적해주세요!) 

이에 제가 활용할 정보는 기사 자체의 Text Embedding을 pretrained 모델을 통해 만들거나, 조회 수 그 자체만을 활용하고자 합니다.

# 🎧 Solution 1: Find Similar <br>Items Using Text Embedding

가장 간단하고 강력한 추천시스템의 솔루션인 Content-Based 추천을 해봅시다. 다만 여기서 한계점은 제가 임베딩을 학습할 수 없다는 것입니다. 이유는 컨텐츠의 라벨을 지정할 수가 없기 때문입니다.
읽는 분들은 word 임베딩을 학습하면 되지 않나? 하실 수도 있는데요. 당연히 그럴 수 있지만 저희가 보유한 데이터 자체가 너무 적고 Multi Lingual 이라는 점을 고려하여 Pretrained 모델을 사용했습니다.

제가 활용한 모델은 `sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2` 이며 [HuggingFace](https://huggingface.co/sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2){:target="_blank"} 에서 찾아볼 수 있습니다.

활용한 이유는 문장 및 문단을 임베딩하며 비슷한 류의 데이터를 묶는 클러스터링에 용이하기 때문입니다. 기사의 특성은 문장 하나하나도 있지만 문단 전체를 보며 그 기사의 성향을 파악할 수 있습니다. 이제 제목과 컨텐츠를 모델을 활용해 임베딩을 해보고 실제로 잘
클러스터링 되는지 확인해보겠습니다.

<img width="1230" alt="image" src="https://github.com/user-attachments/assets/4a339d0d-c1eb-4687-a506-e75bdf9d3709">

**Title-Based Similar Items**
{:.figcaption}

<img width="1220" alt="image" src="https://github.com/user-attachments/assets/506bf539-b003-4ef5-b8eb-ef2c680f4dfe">

**Content-Based Similar Items**
{:.figcaption}


제목을 토대로 한 임베딩, 본문을 토대로 한 임베딩 모두 정성적으로 글을 읽었을 때 비슷한 것을 제대로 준다고 판단할 수 있습니다. 이를 시각화를 해보았습니다.

> * [시각화 : title 기반](https://abit.ly/sb9u1k){:target="_blank"}
> 
> * [시각화 : Content 기반](https://abit.ly/7ioph9){:target="_blank"}
{:.lead}

<img width="1230" alt="image" src="https://github.com/user-attachments/assets/8bca2e3a-6c68-4d26-bce0-383ba5c2b5bf">

그림을 보면 `Github`라는 키워드를 가진 기사들의 3D 차원에서 위와 같이 보이게 됩니다. Github도 서로 다른 내용을 다룰 수 있다는 점을 감안해서 보면 어느정도 거리가 가까워 보입니다. PCA기반으로 한 
차원 축소의 경우 `분산 보존 50.5%` 를 한다고 기록되어 있네요.

이제 유저가 조회했던 기사들의 임베딩을 Summation을 통해 합친 뒤 그와 가장 코사인 유사도가 가장 높은 Top-5의 기사를 추천해보도록 하겠습니다.

> Public Score : 0.023 / Private Score : 0.027
{:.lead}

처참한 기록을 보여줍니다. 주최 측에서 제공한 베이스라인의 점수 0.29인 것을 감안하면 너무나도 낮게 측정되었습니다. 이유가 뭘까요??

## Solution 1 analyze

가장 의심할 수 있는 부분은 `유저들이 실제로 특정 토픽에만 편향을 가지고 기사를 보는가?` 입니다. 사실 기사를 볼 때 자신이 관심있어하는 특정 분야를 많이 보기도 하지만, 실시간으로 일어나는 일들의 기사도 많이 접하게 됩니다.
그렇다면 이를 분석해봐야 할 것 같습니다.

유저들이 조회한 각각의 기사들의 Cosine 유사도를 구하고 이에 대한 분포를 확인해보았습니다.

![image](https://github.com/user-attachments/assets/05e8d5f6-a200-4b67-a088-e39b5c0e10ca)

**유저 별 조회 기사 간의 코사인 유사도 분포**
{:.figcaption}

> * 전체 평균: 0.28
> * 표준 편차: 0.14
> * 분산: 0.02
{:.lead}

을 기록하고 있네요. 코사인 유사도의 값이 0에 가까울수록 두 아이템 간의 관계가 무관하다고 보고 1에 가까워질수록 그 둘의 성향이 비슷하다고 해석할 수 있습니다. 
이때 유저들의 평균 코사인 유사도를 구했을 때, 0에 가까운 값을 가지고 있기에 `특정 토픽에만 편향을 가지고 기사를 보지 않는다.` 라고 볼 수 있을 것 같습니다.

결국 유사도를 통한 추천은 통하지 않음을 알아냈습니다. 다음 방법을 실행해야 됩니다.

# 🏋️ Solution 2 예고.

다음 글에서 제가 성공적으로 점수 획득을 한 솔루션을 공유하겠습니다. 다른 참가자들이 시도하지 않았지만 Robust 한 결과와 합리적인 이유로 진행되는 솔루션을 기대해주세요~

감사합니다.