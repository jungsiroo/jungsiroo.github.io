---
layout: post
title: Dacon 웹기사 추천 대회 솔루션 공유 - 2
description: >
    추천시스템 대회
hide_description: false
category: devlife
image:
  path: https://github.com/user-attachments/assets/99fc9c27-4741-4be8-b2b2-1e138dc36771
---

**474명의 참가자 중 13위**
{:.figcaption}

{% include hits.md %}

* this unordered seed list will be replaced by the toc
{:toc}

이전 포스팅에서 임베딩 기반 유사도 솔루션이 큰 작용을 하지 못했던 것을 볼 수 있었습니다. 이에 따라 많은 레퍼런스들을 찾아보았습니다.

# 🤽‍♂️ Validation 고민

[A Mixed-Methods Approach to Offline Evaluation of News Recommender Systems](https://towardsdatascience.com/a-mixed-methods-approach-to-offline-evaluation-of-news-recommender-systems-7dc7e9f0b501){:target="_blank"} 
의 글을 보면 기사 추천시스템을 구축할 때 평가 지표에 대해 굉장히 고민한 흔적을 볼 수 있었다. 글에서 소개하고 있는 `뉴스 기사 추천`이 어려운 이유를 요약하면 아래와 같다.

> * 뉴스 기사의 수명이 짧음
> * 독자의 선호드는 빠르게 변하여 클릭 데이터만으로는 현재 독자가 선호하는 기사를 예측하기 어려움
> * 인기 기사에 편향되는 경향이 강함
{:.lead}

이후의 글은 해당 대회에 적용하기 어려워 생략하도록 하겠습니다. 이 글을 읽으면서 느낀 점은 `Validation` 을 어떻게 구성해야할까 였습니다. 

데이터는 적고 타임스탬프 기록이 없어 validation set을 구하기 애매한 상황입니다. 하지만 모델을 만들고 평가하기 위해서는 평가 지표가 필요합니다.
결국 제가 선택한 건 제출한 점수를 `Validation` 으로 보기로 했습니다. 실험의 방향은 전적으로 제출 성적으로 정해집니다. 제가 참여했던 대회들 같은 경우 `train / test` 데이터를
제공하여 검증을 할 수 있었지만 이번 대회는 없기에 어쩔 수 없을 것 같았습니다.

그렇다면 추천 알고리즘을 어떻게 짜야할지 고민했습니다. 위에서 나열한 어려운 이유들이 이 대회에서는 마지막 사유말고는 크게 작용되지 않습니다. 그 이유는 `실시간 추천`이 아니며,
독자의 선호도가 변하는 과도기 시점 만큼의 데이터양이 아닙니다. 이 대회에서 어려운 점은 `데모그라픽 정보 부재`, `기사 메타 정보 부족` 이 가장 큽니다. 결국 `클릭 수`에 중점을 두고 이 문제를 풀어나가야 합니다.

# ⛷️ Pointwise Mutual Information

어떻게 알고리즘을 구성해야 할까 깊이 고민하던 중 발견한 2020년 네이버 Deview 발표 자료를 첨부합니다. 
[📎 Collaborative Filtering Meets the Item Embedding](https://deview.kr/data/deview/session/attach/1600_T1_%EC%A0%84%EC%98%81%ED%99%98_%EB%8B%B9%EC%8B%A0%20%EC%B7%A8%ED%96%A5%EC%9D%98%20%EB%A7%9B%EC%A7%91%EC%9D%84%20%EC%B6%94%EC%B2%9C%ED%95%B4%EB%93%9C%EB%A6%BD%EB%8B%88%EB%8B%A4_%EC%9E%A5%EC%86%8C%20%EA%B0%9C%EC%9D%B8%ED%99%94%20%EC%B6%94%EC%B2%9C%EC%8B%9C%EC%8A%A4%ED%85%9C%EC%9D%98%20%EB%B9%84%EB%B0%80.pdf){:target="_blank"}

당시 네이버 장소 추천에서 고민하던 점은 아래와 같습니다.

* User의 맛집 취향을 어떻게 잘 이해할 수 있을까?
* 장소를 장소답게 추천하려면 어떻게 해야할까?

<br>

어떻게 보면 뉴스 기사 추천과 비슷해 보입니다.

<br>

* User의 뉴스 기사 취향을 어떻게 잘 이해할 수 있을까?
* 기사를 기사답게 추천하려면 어떻게 해야할까?

<br>

여기서 제가 집중한 것은 `User의 뉴스 기사 취향을 어떻게 잘 이해할 수 있을까?` 였습니다. 발표 자료에서는 이 문제를 `유저의 클릭 수`를 가장 큰 중점으로 두고 풀어나갑니다. 

> IF User가 포인트 A에 대해 Click을 했다. → User는 A에 대해 관심이 있다!
{:.lead}

합리적인 가정이며 많은 추천시스템에서 당연히 활용하는 방법입니다. 네이버는 이를 `Click Based Preference` 라 칭했으며 이를 바탕으로 `Matrix Factorization` 을 진행합니다.

![image](https://github.com/user-attachments/assets/644146fe-cca9-4563-a87d-c3bcfe71e9f5)

**Naver Deview 발표자료**
{:.figcaption}

해당 방법을 통해 학습했을 때 어떤 문제가 발생했을까요?

> * 인기 맛집으로의 편향
> * Accuracy가 낮은 현상
{:.lead}

저 역시 똑같은 문제를 겪었습니다. 특히 인기 기사의 편향이 심했는데요. 아래는 조회 수 Top 5 기사입니다.

![image](https://github.com/user-attachments/assets/1daf1424-610f-4e36-bf53-a85ca9bcdd6e)

보시다시피 1415명의 유저가 있으나 가장 많이 조회 수가 기록된 기사는 281회로 인기 기사 편향 추천에 큰 기여를 합니다.
Accuracy 같은 경우는 당연히 데이터가 너무 sparse 하기에 나타나는 반응입니다. 이러한 문제는 저희가 클릭 수에만 의존하기 때문에 일어나는 일이기도 합니다.

하지만 앞서 말씀드렸듯 `Side Information` 이 너무 부족합니다. 그렇다고 기사 임베딩을 쓰기에는 너무 다른 취향의 기사들을 보는 경향이 있어 선뜻 사용하기 쉽지 않았습니다.
이에 따라 저는 `어떤 기사가 특정 기사와 함께 많이 등장한다. → 따라서 두 개의 기사는 서로 유사하다` 라는 아이디어를 활용할 수 있도록 `PMI(Pointwise Mutual Information)` 을 활용하기로 하였습니다.

기사의 동시등장 확률을 계산하여 `Item x Item` 의 임베딩을 만들며 `User-User CF` 모델과 `Item-Item CF` 모델을 동시에 활용하기로 하였습니다. 

[네이버 뉴스 추천  알고리즘에 대해 (Part2)](https://blog.naver.com/naver_search/222439504418){:target="_blank"} 에서도 다루듯 이미 네이버 뉴스 기사 추천시스템에서는 PMI를 활용한 CF 
모델을 통해 추천 후보 기사풀을 생성하고 있습니다. 이 대회 자체의 데이터 크기가 작은 점은, 결국 추천 후보 기사를 추출하는 것과 같다고 생각하였고 이 방법을 활용하기로 굳혔습니다.
더 나아가 아까처럼의 인기 편향을 막기 위해 Normalize 를 진행한 `NPMI` 를 구현하였습니다. 

## NPMI 구현

구현한 NPMI는 `사용자 ui가 소비한 각 뉴스 기사 vj 와 소비하지 않은 뉴스 기사들 vk 간의 PMI 점수, PMI (vj, vk)` 를 Normalize 한 것입니다. 아래는 그것을 구현한 코드입니다.

<pre><code class="python">user_article_matrix = view_log.groupby(['userID', 'articleID'])
                                    .size()
                                    .unstack(fill_value=0)

# PMI 계산을 위해 user별 view, total_view 계산
article_counts = user_article_matrix.sum(axis=0)
total_views = article_counts.sum()

# 개별 기사 별 조회 비율 계산
P_vj = article_counts / total_views 

# 동시 조회 확률 계산을 위해 co_view_matrix 생성 후 자기 자신은 제외
co_view_matrix = user_article_matrix.T.dot(user_article_matrix)
np.fill_diagonal(co_view_matrix.values, 0)  

# vj, vk 의 동시등장 확률 계산
P_vj_vk = co_view_matrix / total_views  
P_vj_vk_matrix = coo_matrix(P_vj_vk)

# pmi 수식 참고 : https://blog.naver.com/naver_search/222439504418
pmi_matrix = np.log(P_vj_vk / (P_vj.values[:, None] * P_vj.values[None, :]))
pmi_matrix = np.nan_to_num(pmi_matrix, nan=0.0, posinf=0.0, neginf=0.0)  
pmi_sparse_matrix = coo_matrix(pmi_matrix)

# Normalize 진행 (헤비 유저의 영향 최소화)
with np.errstate(divide='ignore', invalid='ignore'):  
    npmi_values = pmi_sparse_matrix.data / -np.log(P_vj_vk_matrix.data)

# log(0)과 같은 INF 처리
npmi_values = np.nan_to_num(npmi_values, nan=0.0, posinf=0.0, neginf=0.0)

npmi_sparse_matrix = coo_matrix(
                              (npmi_values, 
                              (pmi_sparse_matrix.row, pmi_sparse_matrix.col)), 
                              shape=pmi_sparse_matrix.shape
                              )
    
user_similarity = cosine_similarity(user_article_matrix)
item_similarity = npmi_sparse_matrix.toarray()

return [user_article_matrix, user_similarity, item_similarity, view_log]
</code></pre>

**https://github.com/jungsiroo/article_recsys/blob/main/modules/data/dataset.py**
{:.figcaption}

위 코드를 통해 NPMI를 구하며 이를 코사인 유사도를 거쳐 최종적으로 `item_similarity`를 얻을 수 있습니다. 다른 참가자들 같은 경우 TF-IDF, Pretrained Language Model을 통해 이를 
구하지만 TF-IDF 같은 경우 해당 Document 에서 중요한 Term 들을 구한다는 점에서 이전에서 다룬 Embedding 모델과 크게 다를 바 없다고 판단했습니다.

제가 집중한 아이디어는 `관련성 없는 아이템 목록에서 Next Prediction 찾기` 였습니다. 그렇기에 PMI 임베딩에 집중하였습니다. 이제 데이터를 준비했으니 모델을 알아보도록 하겠습니다.

# ⭐️ User / Item CF

저는 `Memory Based Collaborative Filtering` 을 활용하여 문제를 풀어나갔습니다. 이유는 아래와 같습니다

> * 보유한 메타데이터가 너무 적기에 클릭 데이터를 가장 잘 활용할 수 있는 모델
> * Domain Free 이기에 가장 접근이 쉬운 점
{:.lead}

![image](https://github.com/user-attachments/assets/d6780ba8-0960-41a5-b53c-3d455c4270aa)

**CF 설명**
{:.figcaption}

제목에 썼듯 두 개의 CF 모델을 합치는 방식으로 문제를 해결했습니다. User-User 간의 Click 데이터 기반의 CF 모델과 Item-Item 간의 PMI 기반 CF 모델을 만들었습니다.
이후 유저가 클릭한 기사들을 나타내는 User-Article 상호작용 행렬을 내적하여 그 가중치를 업데이트하여 최종적인 추천이 이뤄지게 됩니다.

<pre><code class="python">user_predicted_scores = self.user_similarity.dot(self.user_article_matrix)
item_predicted_scores = self.user_article_matrix.dot(self.item_similarity)

predicted_scores = self.cfg.alpha * user_predicted_scores + 
                  (1-self.cfg.alpha) * item_predicted_scores
predicted_scores.columns = self.user_article_matrix.columns
</code></pre>

> * user_predicted_scores : User CF 모델
> * item_predicted_scores : Item CF 모델
> * 최종 활용 모델 : User CF 모델과 Item CF 모델의 적절한 Summation
{:.lead}

보시다시피 모델을 굉장히 간단한 편이었으며 데이터를 어떻게 처리할 지가 관건이었습니다. 

# 📀 후기

직장을 다니면서 참가한 대회인만큼 시간도 부족했고 특히 데이터에서 많이 뽑아낼 수 없는 것이 아쉬운 대회였습니다. 하지만 그런 한계 속에서도
적절한 데이터 처리 방법과 Clean Code의 중요성을 다시 한 번 느낄 수 있었습니다.

작성했던 모든 코드는 [Github](https://github.com/jungsiroo/article_recsys){:target="_blank"} 에서 찾아볼 수 있습니다.


