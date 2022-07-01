---
lang: EN-US
title: Deepl Free Action
---

This github action allows to translate a document in a Github repo. It is based on the free version of the tool [DeepL](https://www.deepl.com)

> This documentation is initially written in [French](/FR/) and then automatically translated into [English](/EN-US/) and [Chinese](/ZH/).

## Prerequisites

You must first:

1.  Register on the Deepl website (free)
2.  Generate an API token (Account tab)
3.  Register this token in a secret of your repo

## Parameters

You must fill in the following parameters:

-   `input_file` : the markdown file to translate.
-   `output_file` : the destination file containing the translation. You can only specify a folder (must end with `/` ), in this case the name of the generated file will be the same as `input_file` .
-   `output_lang` : the translation language (see [Deepl API](https://www.deepl.com/fr/docs-api/translating-documents/uploading/))
-   `deepl_free_token` : your Deepl token

On exit:

-   `generated_file` : the path to the translated file

## Example

In this example we translate the file example/readme.md and generate the file example/EN-US/readme.md. Then we add it to the repo.

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
