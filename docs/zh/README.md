---
lang: ZH
title: Deepl Free Action
---

# 自由行动

这个github动作允许你翻译一个文件在一个 Github。它是基于免费版本的工具[DeepL](https://www.deepl.com/)。

你必须首先在Deepl网站上注册（免费）。 然后生成一个API令牌。这个令牌将被储存在一个秘密的 你的 repo。

你必须填写以下参数。

-   `input_file`：要翻译的markdown文件
-   `output_file`: 含有 \"我 \"的目标文件。 翻译
-   `output_lang`: 翻译语言（见[Deepl API](https://www.deepl.com/fr/docs-api/translating-documents/uploading/))
-   `deepl_free_token`: 你的Deepl令牌

使用实例。

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
        uses: ACTION_FULL_PATH
        with:
          input_file: "example/test_fr.md"
          output_file: "example/test_en.md"
          output_lang: "EN-US"
          deepl_free_token: "${{ secrets.TOKEN }}"
      - name: Commit result
        run: |
          git config --global user.name 'your_name'
          git config --global user.email 'your_email@github.com'
          git add example/test_en.md
          git commit -am 'english translation'
          git push
```
