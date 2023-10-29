---
layout: post
description: |
  Optimaztion
category: aistudy
image:
  path: >-
    https://github.com/jungsiroo/jungsiroo.github.io/assets/54366260/e14477f1-ad62-4174-917f-e2ada81c66bf
published: true
title: 목적함수 vs 비용함수 vs 손실함수
---

**해당 썸네일은 `Wonkook Lee` 님이 만드신 [`Thumbnail-Maker`](https://wonkooklee.github.io/thumbnail_maker/){:target="_blank"} 를 이용하였습니다**
{:.figcaption}

Optimization을 공부하는 도중 예전에 내가 공부할 당시, 목적함수 / 비용함수 / 손실함수를 항상 헷갈려했다. 이를 간결하게 정리하고자 한다.

* this unordered seed list will be replaced by the toc
{:toc}

# 목적함수 (Objective Function)

> 가장 큰 범위의 개념이며 모델을 학습하면서 우리가 최적화 해야 할 함수
{:lead}

일반적으로 딥러닝에서 Cost Function을 최소화하기 위해 Optimization을 진행할 수도 있고 이를 목적함수로 봐도 된다. 하지만 MLE(Maximum Likelihood Estimation)를 최적화 해야할 때도 있으므로 목적함수 != 비용함수 이다.

# 비용함수 (Cost Function)

> 전체 데이터셋에 대해 계산되는 loss
{:lead}

이 말이 중요한데 전체 데이터셋에 대해 계산되는 loss 이다. 따라서 이는 다양한 형태의 함수로 계산될 수 있다.

* MSE (Mean Squared Error)
* MAE (Mean Absolute Error)
* BCE (Binary Cross Entropy)

등등과 같이 계산된다.

# 손실함수 (Loss Function)

> 실제 y값에 비해 예측한 추정값이 얼마나 잘 예측됐는지를 평가하는 함수
{:lead}

비용함수와 크게 차이나는 부분은 바로 `값`의 수준에서 이야기된다는 점이다. 쉽게 말해 Single Data 에 적용된다는 말이다.

* AE (Absolute Error)
* SE (Squared Error)
* RSE (Root Squared Error)

한 번 정리하고 나면 우리가 어떤 함수를 최적화해야하고 어떤 문제를 풀어야 할지 선명하게 보인다.
