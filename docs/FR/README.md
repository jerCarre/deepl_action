---
lang: fr
title: Deepl Free Action
---

Cette action github permet de traduire un document au sein d'un repo Github. Les formats de fichier supportés sont : md, rst, docx, pptx, html, pdf ou txt.
Elle est basée sur la version gratuite de l'outil [DeepL](https://www.deepl.com)

> Cette documentation est initialement écrite en [français](/FR/) puis traduite automatiquement en [anglais](/EN-US/) et en [chinois](/ZH/).

## Pré-requis

Vous devez au préalable :

1. Vous enregistrer sur le site Deepl (gratuit) 
2. Générer un token d'API (onglet Compte)
3. Enregistrer ce token dans un secret de votre repo

## Paramètres

Vous devez renseigner les paramètres suivants :

* `input_file` : le fichier à traduire.
* `output_file` : le fichier destination contenant la traduction. Vous pouvez seulement indiquer un dossier (doit finir par `/`), dans ce cas le nom du fichier généré sera le même que `input_file`.
* `output_lang` : la langue de traduction (voir [Deepl API](https://www.deepl.com/fr/docs-api/translating-documents/uploading/))
* `deepl_free_token` : votre token Deepl

En sortie :

* `generated_file` : le chemin vers le fichier traduit

## Exemple

Dans cet exemple on traduit en anglais le fichier example/readme.md et on génère le fichier example/EN-US/readme.md. Puis on l'ajoute au repo.

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
        id: translate
        uses: jerCarre/deepl_action@1.0
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
