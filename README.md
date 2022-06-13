---
lang: EN-US
title: Deepl Free Action
---

# Deepl Free Action

This github action allows to translate a document from a repo. It is based on the free version of the tool [DeepL](https://www.deepl.com/)

To use it:

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
              output_lang: "en"
              deepl_free_token: "${{ secrets.TOKEN }}"
          - name: Publish
            uses: actions/upload-artifact@v3
            with:
              name: test_en.md
              path: example/test_en.md
