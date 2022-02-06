---
layout: post
title: Pytorch - Dataloader collate_fn 
description: >
  Naver boostcamp AI Tech - Pytorch for AI
hide_description: false
category: aistudy
image:
  path: ../../assets/img/thumbnail/collatefn.png
---

**해당 썸네일은 `Wonkook Lee` 님이 만드신 [`Thumbnail-Maker`](https://wonkooklee.github.io/thumbnail_maker/){:target="_blank"} 를 이용하였습니다**
{:.figcaption}

**Pytorch** 강좌를 수강하면서 이해 안됐던 `collate_fn` 에 대해 포스팅하려 한다.

* this unordered seed list will be replaced by the toc
{:toc}

# What is Dataloader?

[`Pytorch 공식문서`](https://pytorch.org/docs/stable/data.html#torch.utils.data.DataLoader){:target="_blank"} 를 확인해보자

> Data loader. Combines a dataset and a sampler, and provides an iterable over the given dataset.
> The DataLoader supports both map-style and iterable-style datasets with single- or multi-process loading, customizing loading order and optional automatic batching (collation) and memory pinning.

위 정의를 해석하자면 데이터셋과 샘플러를 합치고 주어진 데이터셋에 대한 반복 가능한 기능을 제공한다. 또한 `collation` 기능과 `memory pinnin` 기능을 제공한다고 나와있다.
그럼 `collation` 은 무엇일까?

## What is Collation?

공식문서의 정의에서는 아래와 같이 나와있다.

> Merges a list of samples to form a mini-batch of Tensor(s). Used when using batched loading from a map-style dataset.

`map-style` 데이터셋에서 샘플 리스트를 미니배치 단위로 바꾸기 위해 필요한 기능이다. 그럼 어떨 때 쓴다는건가,,,?<br>

**`데이터 사이즈를 미니배치 사이즈만큼 맞추기 위해 사용`**

간단한 예시를 통해 익혀보자

## Example using of collate_fn

아래와 같이 주어진 데이터셋이 있다고 하자. 해당 데이터셋을 배치 사이즈를 **1** 로 설정해둔 `Dataloader` 로 가져오면 아래와 같이 문제없이 가져온다.

```python
tensor([[0.]])
tensor([[1., 1.]])
tensor([[2., 2., 2.]])
tensor([[3., 3., 3., 3.]])
tensor([[4., 4., 4., 4., 4.]])
tensor([[5., 5., 5., 5., 5., 5.]])
tensor([[6., 6., 6., 6., 6., 6., 6.]])
tensor([[7., 7., 7., 7., 7., 7., 7., 7.]])
tensor([[8., 8., 8., 8., 8., 8., 8., 8., 8.]])
tensor([[9., 9., 9., 9., 9., 9., 9., 9., 9., 9.]])
```

하지만 배치 사이즈를 2 이상으로 해버리면 아래와 같은 오류가 뜬다.

```python
RuntimeError: stack expects each tensor to be equal size ~~
```

간단하게 보면 배치 사이즈를 **2** 로 했을 때 `[0, ]` 과 `[1., 1.]` 의 길이가 다르므로 배치 사이즈로 묶을 수 없다는 에러이다. 
그렇다면 임시적인 해결법으로 길이에 맞춰 **0** 을 채워넣는다고 가정하자. 이 해결법을 사용하기 위해 `collate_fn` 을 사용한다. <br>

#### Solution

해당 문제를 풀기 위해 키워드가 있다면 `batch size` 에 맞게 `0으로 채워넣는다` 이다. 그래서 생각해보면 배치 사이즈만큼 묶인 데이터셋들 중에서
가장 길이가 긴 텐서의 길이를 알아낸 다음 `max_len - 나머지 각 텐서들의 길이` 만큼 **0** 으로 채워주면 될 것 같다

그래서 **0** 으로 어떻게 채워주면 좋을까 찾아보다가 `TORCH.NN.FUNCTIONAL` 의 `pad` 함수를 이용하면 좋을 거 같았다. 
[`공식문서`](https://pytorch.org/docs/stable/generated/torch.nn.functional.pad.html?highlight=pad#torch.nn.functional.pad){:target="_blank"}

공식문서를 보면 어떻게 쓰면 되어있는지 잘 나와있다. 읽으면 
> to pad only the last dimension of the input tensor, then pad has the form (padding_left,padding_right)

이라는 것을 읽을 수 있다. 우리는 마지막, 즉 오른쪽에만 0을 채우면 된다. 아래 코드를 보자.

#### code

```python
def my_collate_fn(samples):
    collate_X = []

    max_len = max([len(sample['X']) for sample in samples]) 
    # 배치 사이즈만큼 묶인 데이터들 중 가장 긴 데이터셋 길이

    for _x in [sample['X'] for sample in samples]:
      tensor_len = _x.size(dim=0) # 텐서 길이
      p2d = (0, max_len - tensor_len)
      # right 에만 max_len - tensor_len 만큼 0으로 채워줄 것이다.

      _x = F.pad(_x, p2d)

      collate_X.append(_x)

    return {'X': torch.stack(collate_X)}
```

`pad` 함수를 사용해 간결하게 해결할 수 있었다. 0으로 채워야 될 개수를 `max_len - tensor_len` 로 알아내 자동으로 채울 수 있었다.

#### Result

위에서 짠 `my_collate_fn` 를 파라미터로 넘기고 배치 사이즈를 **3** 으로 설정했을 때 아래와 같은 결과값이 나온다.

```python
tensor([[0., 0., 0.],
        [1., 1., 0.],
        [2., 2., 2.]])
tensor([[3., 3., 3., 3., 0., 0.],
        [4., 4., 4., 4., 4., 0.],
        [5., 5., 5., 5., 5., 5.]])
tensor([[6., 6., 6., 6., 6., 6., 6., 0., 0.],
        [7., 7., 7., 7., 7., 7., 7., 7., 0.],
        [8., 8., 8., 8., 8., 8., 8., 8., 8.]])
tensor([[9., 9., 9., 9., 9., 9., 9., 9., 9., 9.]])
```

원하는대로 배치 사이즈 **3** 만큼 데이터들을 묶은 모습을 보이고 마지막 텐서만 남아있는 결과값이 보인다. 이렇게 마지막 배치만 덩그러니 남을 경우가 있다.
따라서 이럴 때는 `Dataloader` 의 `drop_last` 옵션을 `True` 로 설정해두면 해결할 수 있다. 

# What I learned?

사실 강의를 들을 때 많은 부분들을 이해를 못했다. 인공지능 분야 공부가 처음이라 조금 벅찼는데 `밑바닥부터 시작하는 딥러닝` 책을 읽어가면서
이해하고 강의를 많이 돌려보니 이해되는 부분들이 많았다. 기본기를 소홀히 하지 말자!
