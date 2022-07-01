---
lang: ZH
title: Deepl Free Action
---

这个github动作允许你翻译一个文件在一个 Github。它是基于免费版本的工具[DeepL](https://www.deepl.com)。

> 该文件最初以[法语](/FR/)编写，然后自动翻译成[英文](/EN-US/)和[中文](/ZH/)。

## 先决条件

你必须首先:

1.  在Deepl网站上注册（免费）。
2.  生成一个API令牌（账户标签）。
3.  在你的 repo 的一个秘密中注册这个令牌

## 参数

你必须填写以下参数。

-   `input_file` ：要翻译的markdown文件。
-   `output_file` : 目的地文件，包含 翻译。你只能指定一个文件夹（必须以 `/` ），在这种情况下，生成的文件的名称将与 `input_file` 。
-   `output_lang` : 翻译语言（见[Deepl API](https://www.deepl.com/fr/docs-api/translating-documents/uploading/))
-   `deepl_free_token` : 你的Deepl令牌

退出时:

-   `generated_file` : 翻译文件的路径

## 例子

在这个例子中，我们把example/readme.md文件翻译成英文 并生成 example/EN-US/readme.md 文件。然后我们把它添加到 repo。

``` yaml
on:
  pull_request:
    branches:
      - main
jobs:
  translate2en:
    runs-on: ubuntu-latest
    name: A job to test this action
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: Translate
        id: translate
        uses: ACTION_FULL_PATH
        with:
          input_file: "example/readme.md"
          output_file: "example/EN-US/"
          output_lang: "EN-US"
          deepl_free_token: "${{ secrets.TOKEN }}"
      - name: Commit result
        run: |
          git config --global user.name 'your_name'
          git config --global user.email 'your_email@github.com'
          git pull
          git add  ${{steps.translate.outputs.generated_file}}
          git commit -am 'english translation'
          git push
```
