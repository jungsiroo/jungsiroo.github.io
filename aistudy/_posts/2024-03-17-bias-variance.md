---
layout: post
description: |
  Deep dive into data
category: aistudy
image:
  path: >-
    https://github.com/jungsiroo/jungsiroo.github.io/assets/54366260/06063187-8c5d-4813-be72-1bd888bdf0fa
published: true
title: Bias vs Variance
---

**해당 썸네일은 `Wonkook Lee` 님이 만드신 [`Thumbnail-Maker`](https://wonkooklee.github.io/thumbnail_maker/){:target="_blank"} 를 이용하였습니다**
{:.figcaption}

{% include hits.md %}
{:.figcaption}


요즘 가장 많이 드는 생각은 개발을 너무 못하고 있다는 생각이다. 은행 업무를 하다보니 숙지해야될 업무들이 많아지고 이에 따라서 프로젝트나 어떤 공부를 하기가 참 어렵다는 생각이 들었다.
그렇게 퇴근하면서 종종 테크 관련 유튜브들을 보는데 요즘 흥미롭게 본 채널은 [`CODER X DOX`](https://www.youtube.com/@coderxdox){:target="_blank"} 라는 분이다. 
(이럴 때 또 한번 유튜브의 추천이 대단하다고 느낀다... [`Youtube Recommendations`](https://jungsiroo.github.io/aistudy/2023-05-07-youtube-rec-sys/){:target="_blank"} 논문 리뷰도 같이 보면 좋다!)

이분은 Meta의 ML 엔지니어이신데 `Leetcode` 해설과 ML에 관한 영상을 많이 찍어주신다. 그 중 조금 재미있게 봤던 내용이 `모델의 편향과 분산` 을 다룬 내용이었다. 
나도 공부를 할 때 뭔가 표면적으로만 당연하지~ 했던 내용이었지만 곱씹을수록 중요하다는 생각을 많이 했었다. 특히 ML은 데이터가 더욱 중요한 분야인만큼 한 번 짚고 가려한다.

공부할 당시 헷갈렸던 내용, 왜 trade-off 관계인지 같이 보도록 하자.

* this unordered seed list will be replaced by the toc
{:toc}

# 🪖 What is Bias?

Bias는 한국어로 편향을 뜻한다. 해당 영상에서는 좀 더 구체적으로 데이터에서의 Bias / 모델에서의 Bias를 설명해주신다. 보통 Bias를 말할 때는 `모델` 관점에서 이야기를 하지만 데이터의 bias도 알아보자

## Data Bias

이건 예시를 통해 설명하면 이해하기 쉽다.
우리가 음식 사진을 분류하는 태스크를 맡았다고 하자. 근데 확보한 데이터셋을 보니 고기 관련 사진이 주를 이룬다면 모델은 무엇을 학습할까?
그렇다. 바로 고기의 특징점들을 학습해서 고기 사진은 기똥차게 잘 맞추지만 된장찌개, 김치찌개 등... 이런 것들을 못 맞출 확률이 커지는 것을 말한다.

직관적으로 `데이터가 고기에 편향되있다.` 라고 해석할 수 있다.

## Model Bias

그렇다면 `모델에서의 편향되있다` 라는 말은 어떤 의미일까? 영상에서 설명하는 한 줄 요약은 `모델이 정확하지 않다` 라고 말씀을 하신다. 우리가 Bias & Variance 를 공부할 때 꼭 보는 그림이 있다.
그건 바로 과녁에서의 그림인데 사실 이번 글에서는 그 그림을 안 넣고 설명하려 한다. 그림을 안봐도 바로 이해가 될 수 있기 때문이다.

Bias가 높다는 것은 지금 일반화 성능이 잘 나오지 않아 답을 못 맞추고 있는 상태라고 볼 수 있다. 이것의 원인으로는 모델의 가정을 잘못하여 일어난 것이고 이는 데이터에 과소적합되는 이유이다. 

그렇다면 어떻게 Bias를 낮춰 우리의 모델의 성능을 올릴 수 있을까? 그건 바로 `모델의 복잡도 증가` 로 해결할 수 있다. 모델의 파라미터 complexity가 낮아 데이터를 undefitting 하게 학습을 하였기에 complexity 를 높여
해당 데이터에 잘 맞는 모델을 만들 수 있다.

# 🕶️ What is Variance?

그렇다면 Variance 는 무엇일까? 한국어로는 분산을 뜻하며 모델의 Complexity 를 말한다. 여기서 Variance 가 높다는 뜻은 모델의 복잡도가 높다는 뜻과 일맥상통한다. 그렇다면 High Variance 의 경우는 주어진 데이터에만
너무 알맞는 함수를 만들었다는 뜻이고 이는 곧 일반화 성능이 안 좋은 모델로 해석할 수 있다.

## Variance 줄이기

우리가 원하는 것은 일반화 성능이 좋은, 즉 어떤 데이터에도 답을 제대로 말할 수 있는 모델이 필요한데 이를 위해서는 어떻게 해야할까? 바로 모델의 복잡도를 줄이거나 어려운 훈련 데이터를 주는 방법이 있다. 이 글을 읽다보면
뭔가 이상할 것이다. **`엥? 아까는 모델의 복잡도를 올려서 Bias를 줄이라 했는데 이번에는 Variance를 줄이기 위해서 복잡도를 줄이라고 하네?`** 그렇다면 아주 잘 이해한 것이다. 여기서 ML의 핵심, `Bias & Variance Trade-off` 가 나온다.

# 👝 Trade-off

방금 예시를 통해서 설명을 하긴 했지만 정석을 짚고 넘어가야 더 좋은 자료가 될 것 같다.

![iomage](https://github.com/jungsiroo/jungsiroo.github.io/assets/54366260/45215f68-e9fc-45d5-a653-576e46678d7f)

실제로 공부했던 내용
{:.figcaption}

우리가 줄일려고 노력하는 Cost(Error) 는 사실 $$Bias^2 + Variance + noise$$ 로 계산이 된다. 여기서 $$noise$$ 는 줄일 수 없는 오차, 즉 말 그대로 데이터 자체에 있는 잡음을 뜻하며 이를 없앨 수 있는 방법은 잡음을 제거하는 방법 뿐이다.
(사실 이 말이 되게 웃긴데 그만큼 이 잡음을 없애는게 쉽지 않다는 것이다. 특히 real world data 라면 더더욱!)

또한 Bias와 Variance 가 Trade-off 관계임을 알았기에 우리가 이제 집중해야할 문제는 `낮은 Bias를 가져가되 어느 정도의 Variance로 맞춰야할까?` 로 바뀌게 된다. 그렇기에 후속으로 나오는 이론들이 `규제가 있는 모델`, `Early Stopping` 과
 같은 내용들이 나오는 것이다. 나중에 이것과 관련하여서도 한번 다뤄보도록 하겠다!


# 👑 Conclusion

이 개념이 사실 엄청 어렵지도 않지만 현업이 가장 고민하는 문제라 생각한다. 우리가 원하는 모델은 아무래도 처음 보는 데이터여도 답을 잘 맞추는, 즉 일반화가 굉장히 잘된 모델을 원하지만 그 이면에는 Trade-off 가 있기에 이를 잘 타협하는 것이 
중요하다 생각한다. 

다음에는 조금 더 풍부한 내용을 가지고 돌아오겠다!
