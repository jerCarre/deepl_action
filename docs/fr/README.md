---
lang: fr
title: Deepl Free Action
---

Cette action github permet de traduire un document au sein d'un repo Github. 
Elle est basée sur la version gratuite de l'outil [DeepL](https://www.deepl.com/)

 ## Pré-requis

Vous devez au préalable :

1. Vous enregistrer sur le site Deepl (gratuit) 
2. Générer un token d'API (onglet Compte)
3. Enregistrer ce token dans un secret de votre repo

## Paramètres

Vous devez renseigner les paramètres suivants :

* `input_file` : le fichier markdown à traduire
* `output_file` : le fichier destination contenant la traduction
* `output_lang` : la langue de traduction (voir [Deepl API](https://www.deepl.com/fr/docs-api/translating-documents/uploading/))
* `deepl_free_token` : votre token Deepl

## Exemple

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

