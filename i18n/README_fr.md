---
lang: fr
title: Deepl Free Action
---

# Deepl Free Action

Cette action github permet de traduire un document d'un repo. Elle est basée sur la version gratuite de l'outil [DeepL](https://www.deepl.com/)

Pour l'utiliser :

````
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
          input_file: "example/test_fr.md"
          output_file: "example/test_en.md"
          output_lang: "en"
          deepl_free_token: "${{ secrets.TOKEN }}"
      - name: Publish
        uses: actions/upload-artifact@v3
        with:
          name: test_en.md
          path: example/test_en.md
````