---
layout: post
title: Pandas 를 이용한 CSV 파일 비교
description: >
  Handling pandas in CSV files
hide_description: false
category: devlife
image:
  path: ../../assets/img/thumbnail/csvcompare.png
---

**해당 썸네일은 `Wonkook Lee` 님이 만드신 [`Thumbnail-Maker`](https://wonkooklee.github.io/thumbnail_maker/){:target="_blank"} 를 이용하였습니다**
{:.figcaption}

오늘은 `Naver boostcamp AI Tech` 에서 주관한 `마스크 이미지 분류 대회` 진행 중 활용한
csv 비교 코드에 대해 기록하려 한다. 

* this unordered seed list will be replaced by the toc
{:toc}

## When do we need this?

우리 팀은 대회 중간쯤부터 1위를 기록하기 시작했다. 그때부터 제한된 제출기회로 인해 자신이 새로 학습시킨 모델이
기존 SoTA 모델보다 성능이 얼마나 향상됐는지를 가늠할 수 있는 수단이 필요했다.

## Let's Compare CSV

일단 비교할 CSV 를 살펴보자

```bash
                                            ImageID  ans
0      cbc5c6e168e63498590db46022617123f1fe1268.jpg   14
1      0e72482bf56b3581c081f7da2a6180b8792c7089.jpg    2
2      b549040c49190cedc41327748aeb197c1670f14d.jpg   14
3      4f9cb2a045c6d5b9e50ad3459ea7b791eb6e18bc.jpg   14
4      248428d9a4a5b6229a7081c32851b90cb8d38d0c.jpg   12
...                                             ...  ...
12595  d71d4570505d6af8f777690e63edfa8d85ea4476.jpg    2
12596  6cf1300e8e218716728d5820c0bab553306c2cfd.jpg    5
12597  8140edbba31c3a824e817e6d5fb95343199e2387.jpg    9
12598  030d439efe6fb5a7bafda45a393fc19f2bf57f54.jpg    1
12599  f1e0b9594ae9f72571f0a9dc67406ad41f2edab0.jpg    8
```

`feature` 로는 `ImageID` 와 `ans` 가 있고 데이터의 개수는 총 12600개이다. 

내가 원하는 작업은 `sota.csv` 파일과 `model.csv(학습한 모델)` 의 `ans` 값을 비교해
다른 `prediction` 의 개수와 그 이미지를 보여주는 작업이다.

### Code

```python
df_sota = pd.read_csv("./sota.csv")
df_model = pd.read_csv("./model.csv")
```

`SoTA` 모델과 내가 학습시킨 모델을 **`read_csv`** 를 통해 각각 따로 읽어온다. 

그 다음 각 `ans` 값들을 저장시킬 리스트를 만들어준다.

```python
sota_ans = []
model_ans = []

for ans in df_sota["ans"]:
    sota_ans.append(ans)

for ans in df_model["ans"]:
    model_ans.append(ans)
```

이렇게 담아놓은 리스트들을 기반으로 다른 값들을 있는지 비교하고 새로운 데이터 프레임을 만들어보자

```python
df_model['isSame'] = [sa == ma for sa, ma in zip(sota_ans, model_ans)]

df = df_model.set_index(df_model.isSame, drop=True)
            .drop(['isSame'], axis=1).drop(['ans'], axis=1)

df['sota_ans'] = sota_ans
df['model_ans'] = model_ans
```

코드 한줄 한줄 자세히 봐보자

```df_model['isSame'] = [sa == ma for sa, ma in zip(sota_ans, model_ans)]```은 python 의 
list comprehension 을 이용하여 `sota_ans` 리스트와 `model_ans` 리스트 중 다른 값들만 뽑아낸다. 

그렇게 새롭게 뽑아낸 리스트를 `df_model` 에 새로운 열인 `isSame` 을 만들어낸다.

```python
df = df_model.set_index(df_model.isSame, drop=True)
            .drop(['isSame'], axis=1).drop(['ans'], axis=1)
``` 

은 우리가 만들어낸 `isSame` 열을 `index` 로 설정하고 기존에 있던 열을 `drop=True` 옵션을 통해
삭제한다. 그 다음 `ans` 열도 drop 시켜서 `df` 라는 새로운 데이터프레임을 새로 생성한다.

마지막에는 `df` 에 `sota_ans` 와 `model_ans` 열을 추가해 따로 확인할 수 있게 한다.
만들어진 `df` 를 한번 봐보자

```bash
                                             ImageID  sota_ans  model_ans
isSame                                                                   
False   cbc5c6e168e63498590db46022617123f1fe1268.jpg        14         13
True    0e72482bf56b3581c081f7da2a6180b8792c7089.jpg         2          2
True    b549040c49190cedc41327748aeb197c1670f14d.jpg        14         14
False   4f9cb2a045c6d5b9e50ad3459ea7b791eb6e18bc.jpg        14         13
True    248428d9a4a5b6229a7081c32851b90cb8d38d0c.jpg        12         12
...                                              ...       ...        ...
True    d71d4570505d6af8f777690e63edfa8d85ea4476.jpg         2          2
True    6cf1300e8e218716728d5820c0bab553306c2cfd.jpg         5          5
True    8140edbba31c3a824e817e6d5fb95343199e2387.jpg         9          9
```

데이터프레임을 보면 우리가 원하지 않는 `True` 인 데이터들도 보이므로 `False` 인 데이터들만
뽑아오자.

```python
df = df.loc[False].reset_index().drop(['isSame'], axis=1)
```

최종적으로 만들어진 `df` 는 아래와 같다

```bash
                                           ImageID  sota_ans  model_ans
0     cbc5c6e168e63498590db46022617123f1fe1268.jpg        14         13   
1     4f9cb2a045c6d5b9e50ad3459ea7b791eb6e18bc.jpg        14         13   
2     69ad31adcc3e6e8de7af886e970233fa61699045.jpg         4          5   
3     7665a0a126eec039d2c8baf9c6eedc004738c128.jpg         8          7   
4     91598d7dad0122459e004ecd8a4e745acbd63101.jpg         2          5   
...                                            ...       ...        ...   
1444  caed88568cf4380f515099757cba5693c83002e8.jpg        14         13   
1445  c86b0c90644d6471ffb6ae83a9fa83293c4820dc.jpg         4          3   
1446  f8783757207e48a90273fb479d3ea7c0890ebaf8.jpg        17         16   
1447  5f31f79e422ba9491f499b313b0b3fa33a4a9638.jpg         1          2   
```

지금까지 `pandas` 를 이용하여 csv 파일을 비교하는 법을 알아냈다. 다들 유용하게 
읽었길 바란다.