---
lang: EN-US
title: Deepl Free Action
---

# Deepl Free Action

This github action allows to translate a document in a Github repo. It is based on the free version of the tool [DeepL](https://www.deepl.com/)

How to use it:

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
            uses: ./
            with:
              input_file: "example/test_en.md"
              output_file: "example/test_en.md"
              output_lang: "EN-US"
              deepl_free_token: "${{ secrets.TOKEN }}"
          - name: Commit result
            run: |
              git config --global user.name 'your_name
              git config --global user.email 'your_email@github.com'
              git add example/test_en.md
              git commit -am "english translation"
              git push
