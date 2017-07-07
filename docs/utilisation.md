# Utilisation

## Objet
Cette page décrit brièvement l'utilisation du README et la mise en place avec readthedoc.io


## README-FR.MD
```marckdown
[![English](http://upload.wikimedia.org/wikipedia/commons/e/e1/Union_Jack_22x16.png "English")](README.md)
<h1>
  <span>Titre</span>
  <a href='http://MODIFY_IT.readthedocs.io/en/latest/?badge=latest'>
    <img src='https://readthedocs.org/projects/MODIFY_IT/badge/?version=latest' alt='Documentation Status' />
  </a>
</h1>


## Object
Décrire l'objectif de votre dev.

## Context
Placez le context du besoin

## Description / Explication
Décrivez ou expliquer la marche à suivre pour installer, paramétrer....


## Url vers la documentation complète en anglais...
[Full documentation](http://MODIFY_IT.readthedocs.io/en/latest/)
```

Création des fichiers et répertoires
------------------------------------
### Création du répertoire **docs**
Vous devez à la racine de votre repository créer un répertoire **docs**. Il contiendra les fichier de type __*.md__.

### Les fichiers
Vous devez créer un fichier **mkdocs.yml** à la racine de votre repository. Celui-ci servira d'index pour l'interpreteur markdown de readthedocs.io.
Ensuite, tous les fichiers comportant vos text seront placés dans le répertoire **docs**.

Voici un exemple de fichier mkdocs.yml:
```markdown
site_name: Common files for the docs
site_url: http://www.redbeard-consulting.fr
repo_url: https://github.com/redbeard28/docs_commons
site_description: Build documentation on github.com
site_author: Jeremie CUADRADO aka redbeard28

theme: readthedocs
pages:
  - [ 'index.md', 'Home' ]
  - [ 'utilisation.md', 'Howto', 'Install commons']
  - [ 'license.md', 'About', 'License' ]
  - [ 'about.md', 'About', 'About' ]
```

> L'interpreteur de readthedocs sera trouver les fichiers __*.md__ dans le répertoire docs.


