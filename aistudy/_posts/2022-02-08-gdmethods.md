---
layout: post
title: Deep Learning Basic <br>- Gradient Descent Methods
description: >
  Naver boostcamp AI Tech - Deep Learning Basic
hide_description: false
category: aistudy
image:
  path: ../../assets/img/thumbnail/gdmethods.png
---

**해당 썸네일은 `Wonkook Lee` 님이 만드신 [`Thumbnail-Maker`](https://wonkooklee.github.io/thumbnail_maker/){:target="_blank"} 를 이용하였습니다**
{:.figcaption}

**DL BASIC** 강좌를 들으면서 배운 것 중 `Gradient Descent Methdos` 에 대해 포스팅하려 한다. 

* this unordered seed list will be replaced by the toc
{:toc}

# Optimize parameters

경사 하강법이 필요한 이유는 무엇일까? 신경망 학습의 목적은 손실 함수의 값을 가능한 한 낮추는 `매개변수(parameters)` 를 찾는 것이다. 
이러한 문제를 푸는 것이 `최적화(Optimize)` 라 한다. 이 최적의 매개변수 값을 찾는 단서로 매개변수의 `기울기(gradient)` 을 이용하는 것이다. 

이 기울기를 구해, 기울어진 방향으로 매개변수 값을 갱신하는 일을 반복하여 점점 최적의 값에 다가가는 것이 목표이다. 그렇다면 어떤 방법을 통해 최적의 값으로 
향하는 것이 좋을까?

## Stochastic Gradient Descent

확률적 경사하강법은 데이터셋 중 일부만 사용하는 `Mini-batch` 를 활용해 최적의 파라미터를 찾아간다. 수식을 한번 보자 

$$
\mathbf{W} \leftarrow \mathbf{W}-\eta \frac{\partial L}{\partial \mathbf{W}}
$$

밑바닥부터 시작하는 딥러닝1
{:.figcaption}

여기서 `W`는 갱신할 가중치 매개변수이고 $$\frac{\partial L}{\partial \mathbf{W}}$$
는 `W` 에 대한 손실 함수의 기울기이고 $$\eta$$ 는 학습률을 의미한다. 이 식의 해석은 기울어진 방향으로 일정 거리만 이동하겠다는 단순한 방법을 채택하고 있다. 

### SGD 의 단점

꽤나 구현이 간단하고 단순하지만, 가끔 비효율적일 때가 있다. 간단한 예시로 아래와 같은 상황이 있다. 

![IMG_0007](https://user-images.githubusercontent.com/54366260/153097805-f06438d6-5a66-41e6-b65c-a3a67bb0f0f7.jpg)

밑바닥부터 시작하는 딥러닝1
{:.figcaption}

위 그림을 보면 최적의 값을 찾아가면서 많이 꿈틀대면서 가는 것을 볼 수 있다. 이렇게 지그재그로 가는 근본적인 이유는 기울어진 방향이 본래의 최솟값과 
다른 방향을 가르켜서라는 점도 있다. 그렇다면 조금 더 괜찮은 방법은 없을까?

## Momentum

`momentum` 은 운동량을 뜻한다. 수식 먼저 보도록 하자.

$$
\begin{gathered}
\mathbf{v} \leftarrow \alpha \mathbf{v}-\eta \frac{\partial L}{\partial \mathbf{W}} \\
\mathbf{W} \leftarrow \mathbf{W}+\mathbf{v}
\end{gathered}
$$

밑바닥부터 시작하는 딥러닝1
{:.figcaption}

수식을 이해하기 전에 `momentum` 의 컨셉을 보자면 위에서 `momentum` 은 운동량을 뜻한다고 하였다. 그 뜻은 기울기 방향으로 
힘을 받아 물체가 가속된다는 컨셉을 가지고 있다. 즉 기울기가 크다면 가속이 높아지고 아니라면 그에 맞춰 가속이 줄어든다는 것이다. 

수식에서 `W` 는 SGD 와 같은 의미를 지닌다. 다만 `v` 는 물리에서 속도를 뜻하는 변수를 말한다. $$\alpha \mathbf{v}$$ 항은 물체가 아무런 힘을 받지 않을 때
서서히 하강시키는 역할을 해주는 항이고 나머지는 SGD 와 똑같은 의미를 지닌다. $$\alpha \mathbf{v}$$ 항이 `momentum` 에서 핵심 항인데 움직임을 제한하는 역할을 하여
SGD 와 다르게 큰 폭의 움직임을 제한해준다. 

![IMG_55B072DDC76F-1](https://user-images.githubusercontent.com/54366260/153099660-ffcb25c7-eff3-4175-a74d-d53f31ff3857.jpeg)

밑바닥부터 시작하는 딥러닝1
{:.figcaption}


$$\alpha$$ 는 기본적으로 0.9 값을 선택한다.
{:.note}

## AdaGrad

신경망 학습에서는 학습률을 정하는 것은 꽤 중요한 일이다. 값이 너무 작으면 학습 시간이 너무 길어지고,
반대로 너무 크면 학습이 제대로 이뤄지지 않는다. `Hyperparameter` 인 학습률은 어떻게 조정하면 좋을까?

이를 정하는데 효과적인 기술로 `Learning Rate Decay` 방법이 있다. 학습을 진행하면서 학습률을 점차 줄여가는 방법이다. 
이를 발전시킨 것이 `AdaGrad` 이다. 각각의 매개변수에 맞춤형 값을 만들어준다. 

AdaGrad 는 `Adaptive Gradient` 로 개별 매개변수에 적응적으로 학습률을 조정하면서 학습을 진행합니다. 수식을 한번 같이 보자.

$$
\begin{aligned}
&\mathbf{h} \leftarrow \mathbf{h}+\frac{\partial L}{\partial \mathbf{W}} \odot \frac{\partial L}{\partial \mathbf{W}} \\
&\mathbf{W} \leftarrow \mathbf{W}-\eta \frac{1}{\sqrt{\mathbf{h}+\epsilon}} \frac{\partial L}{\partial \mathbf{W}}
\end{aligned}
$$

밑바닥부터 시작하는 딥러닝1
{:.figcaption}

$$\epsilon$$ 는 0으로 나눠지는 것을 방지하기 위해 더해준다.
{:.note}

여기서 `h` 라는 변수가 새로 등장하는데 이는 기존 기울기 값을 제곱하여 계속 더해준다. 매개변수를 갱신할 때는 $$\frac{1}{\sqrt{\mathbf{h}}}$$ 을 곱해
학습률을 조정한다. 

### Key Point

`h` 값은 기울기 값에 비례한다. 그렇게 갱신된 `h` 는 가중치를 갱신할 때 기울기를 나눠주는 역할을 하는데 그 의미는 아래와 같다
> 많이 변화된(크게 갱신된) 가중치에는 학습률을 낮춘다는 뜻 <br>
> 학습을 진행할수록 갱신 강도가 약해짐

### Optimization Visual Log

![IMG_92091F4B1811-1](https://user-images.githubusercontent.com/54366260/153756400-35559974-8866-49fc-ac14-d31b7db0bcfd.jpeg)

밑바닥부터 시작하는 딥러닝1
{:.figcaption}

그림을 보면 최솟값을 향해 위에 두 방법들보다 효율적으로 움직이는 것을 볼 수 있다. 큰 움직임에 비례해 갱신 정도도 큰 폭으로 작아지도록 조정된다.

## Adam

이 기법은 `momentum` 과 `AdaGrad` 를 융합한 기술이다. `Adam` 에서는 기울기 값과 기울기의 제곱값의 지수이동평균을 활용하여 step 변화량을 조절한다.

수식을 함께 보자

$$
\begin{aligned}
m_{t} &=\beta_{1} m_{t=1}+\left(1-\beta_{1}\right) g_{t} \\
v_{t} &=\beta_{2} v_{t-1}+\left(1-\beta_{2}\right) g_{t}^{2} \\
W_{t+1} &=W_{t}-\frac{\eta}{\sqrt{v_{t}+\epsilon}} \frac{\sqrt{1-\beta_{2}^{t}}}{1-\beta_{1}^{t}} m_{t}
\end{aligned}
$$

위 식에서는 `EMA` 기법이 적용된 것을 볼 수 있다. `EMA` 란 `Learning Rate` 의 계속되는 감소를 방지하기 위해 `exponential moving average` 라는 뜻이다. 

> $$\mathbf{y}$$ 와 $$\mathbf{1-y}$$를 통해 값을 update하는 방식

이 기법의 특징으로는 하이퍼파라미터의 **편향보정** 이 진행된다는 점이다. `Adam` 은 하이퍼파라미터를 3개 설정한다. 하나는 학습률, 나머지 두 개는 일차 모멘텀용
$$\beta_{1}$$ 과 이차 모멘텀용 $$\beta_{2}$$ 이다. 논문에 따르면 기본 설정값은 $$\beta_{1}$$ 0.9, $$\beta_{2}$$ 는 0.999로 설정하면 좋은 값을 얻을 수 있다고 전해진다.

### Optimization Visual Log

![IMG_F4321803BFDA-1](https://user-images.githubusercontent.com/54366260/153757980-4f7e7595-f4bc-43d2-a6dc-7d5491e02727.jpeg)

밑바닥부터 시작하는 딥러닝1
{:.figcaption}

그림에서 보면 `momentum` 과 비슷하게 바닥을 구르듯 갱신 과정이 일어난다. 단 좌우 흔들림이 적은 것을 볼 수 있는데 이는 `Adagrad` 에서 
학습률 갱신을 적응적으로 하는 것을 융합했기 때문이다. 

## 글 마무리

어떤 최적화 기법을 쓰는지는 문제마다 상황마다 다르다. 각자의 장단점이 있기 때문에 그에 맞는 기법을 선택해야된다. 다만 요즘 연구에는 `Adam` 을 많이
쓰고 있다는 것을 알아두면 좋을 것 같다. 

