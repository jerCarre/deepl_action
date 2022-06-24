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
关于:
  拉动请求（pull_request:
    分支机构:
      -主要
工作:
  翻译2en:
    运行中:ubuntu-latest
    名称:一个测试该行动的工作
    步骤:
      - 名称:结账
        使用:行动/结账@v3
      - 名称:翻译
        使用:行动_full_path
        与:
          输入_文件: "example/test_en.md"
          output_file: "example/test_en.md"
          输出语言(output_lang): "EN-US"
          许可证: "${{ secrets.TOKEN }}"
      - 名称:承诺结果
        运行: |
         git config --global user.name 'your_name
         git config --global user.email 'your_email@github.com'
         git add example/test_en.md
         git commit -am 'chinese translation
         git push
```
