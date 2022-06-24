---
lang: fr
title: Deepl Free Action
---

# Deepl Free Action

Cette action github permet de traduire un document au sein d'un repo Github. 
Elle est basée sur la version gratuite de l'outil [DeepL](https://www.deepl.com/)

Vous devez au préalable, vous enregistrer sur le site Deepl (gratuit) puis générer un token d'API. Ce token sera stocké dans un secret de votre repo.

Vous devez renseigner les paramètres suivants :

* `input_file` : le fichier markdown à traduire
* `output_file` : le fichier destination contenant la traduction
* `output_lang` : la langue de traduction (voir [Deepl API](https://www.deepl.com/fr/docs-api/translating-documents/uploading/))
* `deepl_free_token` : votre token Deepl

Exemple d'utilisation : 

```yaml
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
