---
title: "Comment afficher le cours d'une crypto sur sa page Github ?"

tags: 
  - markdown
  - vega
  - vega-lite
  - docsify
  - github
---

# Comment afficher le cours d'une crypto sur sa page Github ?

Derrière ce titre racoleur, se cache un article sur la création d'un site statique affichant un diagramme avec des données dynamiques (ie. le cours d'une crypto).

## Docsify c'est quoi ?

La publication de sites statiques est de plus en plus à la mode, car leur mise en œuvre est souvent facile et que le langage de rédaction est basique.
Plusieurs outils se partagent l'affiche : [Jekyll](https://jekyllrb.com/), [Hugo](https://gohugo.io/) ... J'en ai choisi un autre : [Docsify](https://docsify.js.org).
Il a comme avantage de prendre en entrée du markdown ( [j'aime le markdown](https://medium.com/@jerome.carre/au-rapport-chef-f186726a7de8) ) et surtout de le traiter en l'état, il ne fait pas de transformation préalable en HTML. 

L'installation de docsify se résume à déposer à la racine du site, un fichier index.html :

```html
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <meta charset="UTF-8">
  <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/docsify@4/themes/vue.css" />
</head>
<body>
  <div id="app"></div>
  <script>
    window.$docsify = {
      name: 'docsify vega',
      repo: 'https://github.com/jerCarre/docsify_vega',
    }
  </script>
  <script src="//cdn.jsdelivr.net/npm/docsify@4"></script>
</body>
</html>
```

 et un fichier de contenu README.md :

```markdown
# README.md

Hello world !

```

> On peut évidemment faire beaucoup plus de choses avec Docsify !

## Pages dans Github

Github propose gratuitement le service Pages pour héberger un site statique reposant sur du HTML, CSS, Javascript. Il fournit aussi une URL pour accéder à ce site.

Pour utiliser Pages, il suffit : 
1. de créer un repo **public**
2. d'aller dans ```Settings->Pages```
3. de choisir la branche hébergeant votre site
4. d'indiquer le chemin vers index.html de docsify. 

En retour Github vous indiquera l'URL d'accès. 

Après quelques secondes, votre site est en ligne !!

![](https://jercarre.github.io/medium_stories/docsify_vega_github/empty.png)

Nous aurons donc les fichiers suivants dans notre repo : 

```text
.
└── /
    ├── index.html
    └── README.md
```

## Vega-Lite forever

[Vega](https://vega.github.io/vega/) est une library javascript permettant d'afficher des diagrammes (courbes, nuages de points, camembert, cartes, ...) . Elle se base sur une grammaire au format json. [Vega-Lite](https://vega.github.io/vega-lite/) est une version allégée de Vega. Vega/Vega-Lite a l'avantage de ne nécessiter que quelques imports pour fonctionner. Vega est prévu pour être embarqué dans d'autres outils. 

Un aperçu de ce que l'on peut dessiner avec dans [ce précédent article](https://medium.com/@jerome.carre/au-rapport-chef-f186726a7de8).

### Vega-Lite et docsify

Docsify permet d'afficher des diagrammes au format Mermaid, pour en intégrer d'autres il faut utiliser des plugins. Aucun plugin n'étant recensé sur [cette page](https://docsify.js.org/#/awesome?id=plugins), j'en ai donc développé un pour Vega/Vega-Lite. Son utilisation est décrite ici https://jercarre.github.io/vega_docsify/#/ 

On a donc notre fichier index.html (avec 4 lignes script en plus à la fin) :

```html
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <meta charset="UTF-8">
  <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/docsify@4/themes/vue.css" />
</head>
<body>
  <div id="app"></div>
  <script>
    window.$docsify = {
      name: 'docsify vega',
      repo: 'https://github.com/jerCarre/docsify_vega',
    }
  </script>
  <script src="//cdn.jsdelivr.net/npm/docsify@4"></script>
  
  <script src="//cdn.jsdelivr.net/npm/vega@5"></script>
  <script src="//cdn.jsdelivr.net/npm/vega-lite@5"></script>
  <script src="//cdn.jsdelivr.net/npm/vega-embed@6"></script>
  <script src="//cdn.jsdelivr.net/gh/jerCarre/vega_docsify@v1.1/lib/docsivega.js"></script>
  
</body>
</html>
```

et le README.md

````markdown
# Hello world !

```vega
https://raw.githubusercontent.com/vega/vega/master/docs/examples/bar-chart.vg.json
```

````

Pour obtenir :

![](https://jercarre.github.io/medium_stories/docsify_vega_github/firstvega.png)

[DEMO](https://jercarre.github.io/medium_stories/#/docsify_vega_github/example?id=simple-vega-chart)

### Une crypto dans Vega-Lite

Vega/Vega-Lite a aussi l'avantage de pouvoir lire ses données depuis une API. Il y a tout de même des contraintes : pas de gestion de header et uniquement en GET. Après quelques recherches, l'API [coingecko](https://www.coingecko.com/en/api) semble être idéale. Ellel permet d'avoir le cours d'une crypto sur les X derniers jours, et ne nécessite pas de token d'accès.

> Dans la mesure ou l'appel vers cette API est réalisé par le navigateur, il sera impossible de masquer le passage d'un token dans l'url.

Pour avoir le cours du bitcoin depuis 24h, on peut donc appeler : https://api.coingecko.com/api/v3/coins/bitcoin/market_chart?vs_currency=eur&days=1 

et avoir en réponse (en raccourci) : 
```json
{"prices":[[1641137007567,41637.83411713587],[1641137244268,41579.072842123],[1641137476057,41578.04595490743],[1641137952530,41504.83017220277],[1641138178298,41502.722548713165],[1641138490632,41572.95862016224],[1641138725476,41664.34163465742],[1641139126440,41696.036160482596],[1641139324313,41706.24565959366],[1641139579229,41690.04405619627],[1641140038186,41750.43550340376],[1641140229278,41811.27689166205],[1641140453839,41735.801954558665],[1641140998579,41769.16264562593]]}
```

> L'élément [0] est le temps (epoch), le [1] est la valeur en €

Plus qu'à mettre ça dans un diagramme :

````markdown
# Hello crypto world !

```vegalite
{
  "$schema": "https://vega.github.io/schema/vega-lite/v5.json",
  "description": "Bitcoin/eur last day evolution",
  "width": 500,
  "height": 300,
  "data": {
    "format": {"type": "json", "property": "prices"},
    "url": "https://api.coingecko.com/api/v3/coins/bitcoin/market_chart?vs_currency=eur&days=1"
  },
  "mark": "line",
  "encoding": {
    "x": {
      "field": "0", 
      "type": "temporal", 
      "axis": {"title": "last day"}
    },
    "y": {
      "field": "1",
      "type": "quantitative",
      "scale": {"zero": false},
      "axis": {"title": "price in €"}
    }    
  }
}
```

````

![](https://jercarre.github.io/medium_stories/docsify_vega_github/firstcryptochart.png)

[DEMO](https://jercarre.github.io/medium_stories/#/docsify_vega_github/example?id=first-crypto-chart)

## et un peu plus ...

On peut enrichir le diagramme avec des réglettes qui se déplacent avec la souris sur la courbe. Aussi avoir la derniere valeur affichée à droite.

![](https://jercarre.github.io/medium_stories/docsify_vega_github/advancedcryptochart.png)

[DEMO](https://jercarre.github.io/medium_stories/#/docsify_vega_github/example?id=advanced-crypto-chart)

Avec ces même données on peut aussi afficher la distribution des prix :

![](https://jercarre.github.io/medium_stories/docsify_vega_github/distributionchart.png)

[DEMO](https://jercarre.github.io/medium_stories/#/docsify_vega_github/example?id=bitcoin-last-60-days-distribution-chart)

## En conclusion

Comme on a pu le voir on peut déployer sur Github en quelques minutes un site staique affichant des données dynamiques, et sans aucune ligne de HTML ni de javascript. On ne se concentre que sur le contenu !

*Quelques liens utiles*

- [Les sources de cet article et des exemples](https://jercarre.github.io/medium_stories/#/)
- [Docsify](https://docsify.js.org)
- [Vega-Lite](https://vega.github.io/vega-lite/)
- [coingecko](https://www.coingecko.com/en/api)
- Une [Github action](https://github.com/philips-software/post-to-medium-action) pour publier automatiquement sur Medium
