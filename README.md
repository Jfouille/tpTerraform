# Rendu tp noté cloud 
### Gabin Raapoto - Justine Fouillé

Le TP se compose de deux dossiers qui correspondent à chaque partie du TP (partie Docker - partie GKE & Kubernetes)

## Partie 1 - Docker

Placez-vous dans le dossier "Docker" et lancer la commande 

```
terraform init 
```
et ensuite 

```
terraform plan 
```

```
terraform apply 
```

## Partie 2 - GKE & Kubernetes


Créer un fichier ` terraform.tfvars ` avec le template suivant : 

```
project_id = <id_projet>
region = <region>
zone = <zone>
file_path = <chemin_fichier_credential.json>
```

Puis lancer les commandes habituelles pour démarrer le projet :


```
terraform init 
```
et ensuite 

```
terraform plan 
```

puis, pour finir 

```
terraform apply 
```

