#! /bin/bash

#paso 1

grep ^t[ms] titles.cvs > titles2.cvs

var1=$(wc -l < titles.cvs)
var2=$(wc -l < titles2.cvs)
var3=$[(var1 - var2)]

echo "S'han eliminat; $var3 al primer pas"

#paso 2

grep "[^]*,[[:alnum:]]" titles2.cvs > titles3.cvs

grep "[^]*,[[\"#'¿¡]]" titles2.cvs >> titles3.cvs

var4=$(wc -l < titles3.cvs)
var5=$[(var2-var4)]

echo "S'han eliminat; $var5 al segon pas"

#paso 3

sed -n '/MOVIE/p' titles3.cvs > movies.cvs

sed -n '/SHOW/p' titles3.cvs > shows.cvs

var6=$(wc -l < movies.cvs)
var7=$(wc -l < shows.cvs)
var8=$[(var6+var7)]

echo "Tenim $var6 pel·licules i $var7 sèries. La suma de totes dues és $var8"

#paso 4

awk -F, '($12 != "") && ($13 != "") && ($14 != "") && ($15 != "")' movies.cvs > movies2.cvs 

awk -F, '($12 != "") && ($13 != "") && ($14 != "") && ($15 != "")' shows.cvs > shows2.cvs

var9=$(wc -l < movies2.cvs)
var10=$[(var6-var9)]
var11=$(wc -l < shows2.cvs)
var12=$[(var7-var11)]

echo "S'han eliminat $var10 línies en movies.cvs i $var12  en shows.cvs"

#paso 5 
#MOVIES
max_imdb=$(awk -F, 'BEGIN{max=0}{if($13>max)(max=$13)}END{print max}' movies2.cvs)

echo $max_imdb

awk -F, -v calcul=$max_imdb 'BEGIN{OFS=","}{$16=($12*($13/calcul))}{print}' movies2.cvs > movies3.cvs

max_tmdb=$(awk -F, 'BEGIN{max=0}{if($14>max)(max=$14)}END{print max}' movies2.cvs)

echo $max_tmdb

awk -F, -v calcul2=$max_tmdb 'BEGIN{OFS=","}{$17=($15*($14/calcul2))}{print}' movies3.cvs > movies4.cvs

#SHOWS
max_imdb=$(awk -F, 'BEGIN{max=0}{if($13>max)(max=$13)}END{print max}' shows2.cvs)

echo $max_imdb

awk -F, -v calcul=$max_imdb 'BEGIN{OFS=","}{$16=($12*($13/calcul))}{print}' shows2.cvs > shows3.cvs

max_tmdb=$(awk -F, 'BEGIN{max=0}{if($14>max)(max=$14)}END{print max}' shows2.cvs)

echo $max_tmdb

awk -F, -v calcul2=$max_tmdb 'BEGIN{OFS=","}{$17=($15*($14/calcul2))}{print}' shows3.cvs > shows4.cvs

#paso 6
#Quina pel·lícula té la millor puntuació IMDB?
millor_peli=$(awk 'BEGIN { max=0 } $12 > max { max=$12; id=$1; title=$2; production_countries=$9 } END { print id, title, production_countries, max }' FS="," movies4.cvs)
echo "${millor_peli}"

IFS="," read -a millor_peli_data <<< $paso6 #Per si després hem d'utilitzar les dades les hem posat en un array

#Quina sèrie té la millor puntuació IMDB?
millor_serie=$(awk 'BEGIN { max=0 } $12 > max { max=$12; id=$1; title=$2; production_countries=$9 } END { print id, title, production_countries, max }' FS="," shows4.cvs)
echo "${millor_serie}"

#Pel·licula amb més popularitat?
popularity_movie=$(awk 'BEGIN { max=0 } $13 > max { max=$13; id=$1; title=$2; production_countries=$9 } END { print id, title, production_countries, max }' FS="," movies4.cvs)
echo "${popularity_movie}"

#Sèrie més popular?
popularity_show=$(awk 'BEGIN { max=0 } $13 > max { max=$13; id=$1; title=$2; production_countries=$9 } END { print id, title, production_countries, max }' FS="," shows4.cvs)
echo "${popularity_show}"

#Més fiabilitat movie?
fiabilitat_movie=$(awk 'BEGIN { max=0 } $16 > max { max=$16; id=$1; title=$2; production_countries=$9 } END { print id, title, production_countries, max }' FS="," movies4.cvs)
echo "${fiabilitat_movie}"

#Més fiabilitat sèrie?
fiabilitat_show=$(awk 'BEGIN { max=0 } $16 > max { max=$16; id=$1; title=$2; production_countries=$9 } END { print id, title, production_countries, max }' FS="," shows4.cvs)
echo "${fiabilitat_show}"

#TMDB score movie/show?
tmdb_movie=$(awk 'BEGIN { max=0 } $15 > max { max=$15; id=$1; title=$2; production_countries=$9 } END { print id, title, production_countries, max }' FS="," movies4.cvs)
echo "${tmdb_movie}"

tmdb_show=$(awk 'BEGIN { max=0 } $15 > max { max=$15; id=$1; title=$2; production_countries=$9 } END { print id, title, production_countries, max }' FS="," shows4.cvs)
echo "${tmdb_show}"

#TMDB popularity?
popularity_movie=$(awk 'BEGIN { max=0 } $14 > max { max=$14; id=$1; title=$2; production_countries=$9 } END { print id, title, production_countries, max }' FS="," movies4.cvs)
echo "${popularity_movie}"

popularity_shows=$(awk 'BEGIN { max=0 } $14 > max { max=$14; id=$1; title=$2; production_countries=$9 } END { print id, title, production_countries, max }' FS="," shows4.cvs)
echo "${popularity_shows}"

# tmdb_reliability?
reliability_movie=$(awk 'BEGIN { max=0 } $17 > max { max=$17; id=$1; title=$2; production_countries=$9 } END { print id, title, production_countries, max }' FS="," movies4.cvs)
echo "${reliability_movie}"

reliability_shows=$(awk 'BEGIN { max=0 } $17 > max { max=$17; id=$1; title=$2; production_countries=$9 } END { print id, title, production_countries, max }' FS="," shows4.cvs)
echo "${reliability_shows}"




