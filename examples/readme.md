## MD to HTML

pandoc -f markdown -t html test_fr.md -o test_fr.html

## translation

curl -X POST https://api-free.deepl.com/v2/document -F "file=@test_fr.html" -F "auth_key=xxx" -F "target_lang=EN" -F "source_lang=FR"

curl https://api-free.deepl.com/v2/document/FBBF17EA2A78037424A8EE32AA97F6F0 -d auth_key=xxx -d document_key=38737E6621256E73D6906222CB12D7EBF7821E259C4F5780E8BE0BABE18EAF1E

curl https://api-free.deepl.com/v2/document/FBBF17EA2A78037424A8EE32AA97F6F0/result -d auth_key=xxx -d document_key=38737E6621256E73D6906222CB12D7EBF7821E259C4F5780E8BE0BABE18EAF1E -o test_en.html

## translated HTML to translated MD

pandoc -t markdown-header_attributes --markdown-headings=atx test_en.html -o test_en.md  

post conversion :
- remove lines starting by :::
- replace lines like : ``` {.sourceCode XXX} by ``` html