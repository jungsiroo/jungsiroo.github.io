---
layout: post
title: Pytorch - Basic Code in Pytorch
description: >
  Pytorch for AI
hide_description: false
category: aistudy
image:
  path: ../../assets/img/thumbnail/pytorchbasic.png
---

**해당 썸네일은 `Wonkook Lee` 님이 만드신 [`Thumbnail-Maker`](https://wonkooklee.github.io/thumbnail_maker/){:target="_blank"} 를 이용하였습니다**
{:.figcaption}

블로그를 정리하려고 마음 먹으면서 한참 전에 들었던 **Pytorch** 강좌를 다시 보면서 옛날에는 정말 이해가 안됐는데 이제는 조금 익숙해진 것을 
포스팅 하려 한다.

* this unordered seed list will be replaced by the toc
{:toc}

# torch.nn.Module

`pytorch` 내에서 nn 라이브러리는 `Neural Network` 를 구성하는 Layer 의 base class 이다. 기본적으로 nn.Module 은 4가지를
정의해야 하는데 

> input 이 무엇인지<br>
> output 이 무엇인지<br>
> forward 때 일어나는 일이 무엇인지<br>
> backward 때 일어나는 일이 무엇인지

등을 생각해야 한다. 또한 학습의 대상이 되는 `parameter(weights)` 를 정의해주면 `backward` 때 `autograd` 로 처리가 가능해진다.

# torch.nn.Parameter

`Parameter 클래스`는 Tensor 객체의 상속 객체로 `nn.Module` 내에 속성이 될 때는 `required_grad=True` 로 지정되어 
학습 대상이 되는 Tensor 이다. 이 말은 `AutoGrad` 의 대상이 된다는 말과 똑같은 말로 굉장히 핵심 포인트이다. 

다만 우리가 직접 지정할 일은 잘 없는데 그 이유는 대부분의 layer 에는 weights 값들이 지정되어 있기 때문이다. 그래도 중요한 부분이므로 알아둘 필요가 있다.

## Example Model

```py
class MyLinear(nn.Module): #nn.Module 을 상속받는 모습
    def __init__(self, in_features, out_features, bias=True):
        super().__init__()
        self.in_features = in_features
        self.out_features = out_features

         # 실제로 이렇게 Parameter 를 통해 
         # weight 값을 잡아주는 일은 거의 없음

        self.weights = nn.Parameter(
            torch.randn(in_features, out_features)
        )

        self.bias = nn.Parameter(torch.randn(out_features))

    def forward(self, x : Tensor):
        return x @ self.weights + self.bias 
```

위에 짠 네트워크는 정말 저렇게 짤 일이 거의 없다. nn 라이브러리에 내장되있는 다른 `neural network(cnn, rnn 등)` 를 사용할 것이기 때문이다.
그래도 network 의 구조를 파악하기에는 괜찮은 코드일 것이다.

# Backward

각 Layer 들에 숨어있는 weight 들의 미분을 수행하는 역할을 한다. forward 함수를 거쳐 나온 `결과값(Prediction)` 과 
`실제 값(Ground Truth)` 간의 차이(loss) 에 대해 미분을 수행한다. 이렇게 얻어낸 미분값으로 weight 들을 업데이트한다. 
코드를 보면 이해해보자.

## Code

```py
for epoch in range(epochs):

    optimizer.zero_grad()

    """model = MyLinear(3, 7)"""
    outputs = model(inputs) 

    loss = criterion(outputs, labels)
    loss.backward()

    optimizer.step()
```

코드를 차근차근 봐보자.

일단 `optimizer` 는 최적화를 맡는다. 최적화는 각 학습 단계에서 모델의 loss를 줄이기 위해 모델 매개변수를 조정하는 과정이라 볼 수 있다. 
각 epoch 때 마다 각 `layer` 의 `weights` 들의 g`radient` 값을 0으로 재설정한다. 이유는 이전에 학습한 `gradient` 가 이번 학습에서 영향을 주지 않게 하기 위해서이다. 

그 다음 model에 inputs 을 넣으면 outputs(예측값) 이 나올텐데 그것을 실제 label 과 비교하여 loss 값을 구해낸다. 
가장 중요한 backward 함수를 통해 각 loss 에 대한 모든 weights 값을 계산하고 `optimizer.step` 함수를 통해 weight 를 업데이트한다.

이것이 학습의 기본 뼈대이다. 당시에 배울때는 용어 자체도 낯설고 코드도 잘 이해가 안되서 한참 어려워했던 기억이 난다. 딥러닝을 공부하면서 느낀 것은 기초가
탄탄하면 다른 어려운 게 나와도 이해가 빠르다는 점이다. 다들 기초에 충실하도록 하자.
