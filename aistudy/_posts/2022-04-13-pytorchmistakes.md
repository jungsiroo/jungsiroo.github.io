---
layout: post
title: Pytorch로 학습할 때 시간 아끼는 법
description: >
  
hide_description: false
category: aistudy
image:
  path: https://images.unsplash.com/photo-1585543253202-04d3d9f11961?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80
---

***[원본 유튜브](https://www.youtube.com/watch?v=O2wJ3tkc-TU){:target="_blank"}***<br>
***위 영상을 보고 공유하면 좋다고 생각하여 글로 남깁니다.***
{:.note}

<br>

요즘 정말 바쁘게 지냈다. 네이버 부스트캠프에서 `P-Stage` 안에서 대회들을 진행했고 정말 좋은 팀원들 덕분에 만족스러운 결과를 받았다.
그리고 계속 배우면서 드는 생각은 기록으로 남기지 않으면 내 머릿속에서 지워질 거 같다는 느낌을 받아 이제부터라도 다시 차근차근 블로그에
글을 남기기로 했다. 그러면 본론으로 들어가자

# Can you overfit a single batch?

이 부분을 영상으로 보면서 정말 많이 공감했다. 대회를 진행할 때, 이제 모델링을 다 끝냈고 모든 게 준비됐어! 하고 학습을 시킨다. 
우리는 주로 `Pretrained Model` 을 사용했으므로 `epoch` 을 10 정도로 잡고 데이터셋을 `Dataloader` 에 넣고 학습을 돌리기 시작한다.
이제 `tqdm` 을 통해 예상 학습시간은 1~2시간 정도로 떠 있으면 나는 기도를 했다. `'제발 아무 에러없이 돌아가게 해주세요...'` 잘 돌아가는가 싶더니,,,
에러를 뿜어내기 시작한다. 그러면 나의 process 는 아래와 같았다.

> 에러 발견 → 에러 수정 → 학습 시작 후 10분 정도 기다리기 → 다시 에러 수정,,,

영상에서는 이러한 과정에서 시간을 아낄 수 있는 방법을 제시한다. 말 그대로 `single batch` 에 대해 오버피팅이 가능한가? 코드로 살펴보자

```py
# 코드는 알아보기 쉽게 간소화 했습니다.
epochs = 10
batch_size = 64

train_loader = DataLoader(train_set, batch_size=batch_size)

for epoch in range(epochs):
    # train loop
    for idx, train_batch in enumerate(train_loader):
        inputs, labels = train_batch

        optimizer.zero_grad()

        outs = model(inputs)
        preds = torch.argmax(outs, dim=-1)
        loss = criterion(outs, labels)

        self.backward(loss)
        optimizer.step()

```

아마 대부분이 이러한 비슷한 코드를 가지고 학습을 돌릴 것이다. 근데 우리는 시간을 아끼기 위해 조금의 trick 을 첨가해보자.

## Code with some tricks

```py
epochs = 1000
batch_size = 1

train_loader = DataLoader(train_set, batch_size=batch_size)

# 바뀐 부분
inputs, labels = next(iter(train_loader))

for epoch in range(epochs):
    # train loop
    optimizer.zero_grad()

    outs = model(inputs)
    preds = torch.argmax(outs, dim=-1)
    loss = criterion(outs, labels)

    self.backward(loss)
    optimizer.step()
```

위와 같은 코드로 `Dataloader` 가 주는 하나의 데이터셋으로 loss 값이 줄어드는지 확인하면 된다. 이런 방식으로 본격적으로
학습하기 전에 확인을 해본다면 위에 적어놓은 process의 시간을 획기적으로 줄일 수 있다.

영상에는 더 많은 팁들이 있었지만 나에게는 이 부분이 조금 충격적이어서 이것만 따로 정리하기로 했다. 현재 나는 데이터제작 대회를 진행중인데
역시 어렵다... 내가 배운 것들을 꾸준히 정리해야겠다.