# /bin/bash

jv_pg_homeopathie () {

chemin=${PWD}"/plugins_installed/jarvis-homeopathie/homeopathie.txt"
symptome_homeopathie_sed
symptome_homeopathie_identique=""
symptome_homeopathie_totalmots=`echo "$symptome_homeopathie" | grep -o " " | wc -l`
if [[ `echo $symptome_homeopathie | wc -c` -le "3" ]]; then say "je n'ai pas bien saisie ta demande, merci d'essayer de bien prononcer le dernier mot..."; return; fi
ligne_num_homeopathie_total=`grep -i -n "\-$symptome_homeopathie-" $chemin | cut -d: -f1 | wc -w`
ligne_num_homeopathie_total1="1"

homeopathie_test_resulat
if test -n "$symptome_homeopathie_identique"; then 
return; 
fi

if [[ "$ligne_num_homeopathie_total" == "0" ]]; then
say "Désolé, je ne trouve rien pour $order, un problème d'orthographe peut-être de ma part"
say "Essayez peut-être de trouver un synonyme de votre mal-être..."
homeopathie_feuxvert=""
return;
else
homeopathie_feuxvert="Ok"
fi

if [[ "$ligne_num_homeopathie_total" == "1" ]]; then 
dire_homeopathie="J'ai un résultat pour le problème de $symptome_homeopathie avec 1 traitement possible:"
else
dire_homeopathie="J'ai un résultat pour le problème de $symptome_homeopathie il y a $ligne_num_homeopathie_total traitements possible:"
fi

if [[ "$jv_pg_homeopathieSMS" == "" ]]; then 
say "$dire_homeopathie"
else
homeopathie_sms="$dire_homeopathie "
fi

if [[ "$jv_pg_homeopathieSMS" == "" ]]; then 
say "$ligne_num_homeopathie"
else
homeopathie_sms="$homeopathie_sms $ligne_num_homeopathie."
fi


if [[ "$jv_pg_homeopathieSMS" == "" ]]; then
	if [[ "$homeopathie_feuxvert" == "Ok" ]]; then say "A qui j'envoie ce sms ? $(jv_pg_ct_ilyanom) ou personne ?"
	return
	else 
	say "Soignez vous bien..."; 
	return; 
	fi
fi

}

symptome_homeopathie_sed ()  {
symptome_homeopathie=`echo "$order" | sed -e "s/'/ /g" | sed -e "s/Ok/Hoquet/g" | sed -e "s/ok/Hoquet/g" | sed -e "s/ homéopathique//g" | sed -e "s/ homéopathie//g" | sed -e "s/ pour//g" | sed -e "s/ traitement//g"`
}



jv_pg_homeopathie_sms () {

if [[ "$order" =~ "person" ]]; then say "Ok, soignez-vous bien...";
return;
fi

if [[ "$order" =~ "$PNOM" ]]; then 
say "Je fais partir... "; 
else
say "Désolé je n'ai pas reconnu le nom... Annulation..."; 
return; 
fi

jv_pg_homeopathieSMS="1"
order="$memo_homeopathie"
jv_pg_homeopathie
jv_pg_homeopathieSMS=""
commands="$(jv_get_commands)"; jv_handle_order "MESSEXTERNE ; $PNOM ; $homeopathie_sms"; return
return;
}

jv_pg_homeopathie_recommandation1 () {
say "Il y a 3 types de possologie de granule"
say "Premièrement, on emploie une dilution basse 4 ou 5 CH, tubes jaune et vert pour traiter des signes locaux et ponctuels. son action de courte durée, il faudra donc renouveler les prises."
say "Exemple ALLIUM cepa pour un nez qui coule"
say "En second, on emploie une dilution moyenne 7 ou 9 CH tubes rouge et bleu quand on veut traiter des symptômes plus généraux, ce sont les plus courantes et ceux sont celles que l'on peut avoir dans toute pharmacie familliale."
say "On en prend de l'apparition à la disparition des symptômes."
say "Exemple: BELLADONNA pour un état fiévreux."
say "Enfin en troisième, on emploie une dilution haute (15 ou 30 CH) tubes orange et violet quand on s'intéresse au comportement général pour les cas chroniques qui durent dans le temps."
say "Exemple: IGNATIA amara pour un état dépressif. Le plus souvent, on prendra une dose par jour."
} 

jv_pg_homeopathie_recommandation2 () {
say "4 Recommandations concernant les granules homéopathiques."
say "Premièrement, laissez fondre les granules sous la langue. Le principe actif passe alors directement dans la circulation sanguine."
say "En second, ne touchez pas les granules avec les doigts. utiliser les bouchons distributeurs."
say "En troisième, ne consommez pas de menthe dans l’heure qui précède ou qui suit la prise des granules : les saveurs fortes en général annulent l’effet thérapeutique. "
say "L'essentiel étant de n'avoir aucun goût particulier dans la bouche au même moment menthe, café, tabac, alcool, exetera."
say "Enfin en quatrième, la prise de vos granules, se fait au moins un quart d'heure avant les repas ou une heure et demie après, vous pouvez toutefois boire de l’eau claire."
}

jv_pg_homeopathie_recommandation3 () {
say "A savoir : Votre trousse d’urgence"
say "Plus les symptômes sont traités rapidement, plus l’homéopathie est efficace. Mieux vaut donc toujours garder près de vous les remèdes essentiels :"
say "Pour le rhume de cerveau avec nez qui coule et yeux qui pleurent,"
say "piqûres d’insectes, brûlures, coups de soleil, urticaire."
say "courbatures, crampes, hématomes, bosses."
say "fièvre avec transpiration."
say "douleurs dentaires, surtout chez les nourrissons."
say "grosse fatigue suite à une infection, un accouchement."
say "mal des transports, toux quinteuse, trac, difficultés d’endormissement."
say "indigestion, crise de foie, gueule de bois."
say "états grippaux, allergies."
say "courbatures après l’effort."
say "Puis je vous envoyer le nom des granules par sms à $(jv_pg_ct_ilyanom) ou personne ?"
}

jv_pg_homeopathie_recommandation3_sms() {
if [[ "$order" =~ "person" ]]; then say "Ok, soignez-vous bien...";
return;
fi

if [[ "$order" =~ "$PNOM" ]]; then 
say "Je fais partir... "; 
else
say "Désolé je n'ai pas reconnu le nom... Annulation..."; 
return; 
fi

homeopathie_urgence="Allium cepa 9 CH -Apis mellifica 7 CH - Arnica montana 7 CH - Belladona 9 CH - Chamomilla 9 CH - China 9 CH - Cocculine - Drosera 9 CH - Gelsemium 9 CH - Nux vomica 7 CH -Oscillococcinum 200 -Poumon histamine 9 CH - Rhus toxicodendron 9 CH"
commands="$(jv_get_commands)"; jv_handle_order "MESSEXTERNE ; $PNOM ; $homeopathie_urgence"; return
}

homeopathie_test_resulat () {

symptome_homeopathie_trouve="-$symptome_homeopathie-"
if [[ `echo "$symptome_homeopathie" | cut -c1` == " " ]]; then
symptome_homeopathie=`echo "\-$symptome_homeopathie-" | cut -c2-`
fi

if [[ `echo "$symptome_homeopathie" | tail -c 1` == " " ]]; then
symptome_homeopathie=`echo "\-$symptome_homeopathie-" | sed "s/.$//"`
fi

# jv_success "Recherche avec ces mots:.....$symptome_homeopathie..pour....$symptome_homeopathie_trouve..."

symptome_homeopathie1=$symptome_homeopathie

ligne_num_homeopathie_total=`grep -i -n "\-$symptome_homeopathie-"  $chemin | cut -d: -f1 | wc -w`

if [[ "$ligne_num_homeopathie_total" -ge "1" ]]; then
ligne_num_homeopathie=`grep -i "\-$symptome_homeopathie-"  $chemin | cut -d"-" -f1 | sort | uniq | paste -s -d ","`
return
fi
	if [[ "$ligne_num_homeopathie_total" == "0" ]]; then
	symptome_homeopathie=`echo $symptome_homeopathie | cut -d" " -f2-`
	ligne_num_homeopathie_total=`grep -i -n "\-$symptome_homeopathie-"  $chemin | cut -d: -f1 | wc -w`
	fi



	if [[ "$symptome_homeopathie" == "$symptome_homeopathie1" ]]; then 
	symptome_homeopathie="$symptome_homeopathie"
	symptome_homeopathie_trouve="-$symptome_homeopathie-"
	ligne_num_homeopathie=`grep -i "\-$symptome_homeopathie-"  $chemin | cut -d"-" -f1 | sort | uniq | paste -s -d ","`
	
	homeopathie_test_resulat1
	return;
	else

	homeopathie_test_resulat
	return
	fi

symptome_homeopathie="$symptome_homeopathie"
symptome_homeopathie_trouve="-$symptome_homeopathie-"
ligne_num_homeopathie=`grep -i "\-$symptome_homeopathie-"  $chemin | cut -d"-" -f1 | sort | uniq | paste -s -d ","`
homeopathie_test_resulat


}

homeopathie_test_resulat1 () {
symptome_homeopathie_trouve="-$symptome_homeopathie"
if [[ `echo "$symptome_homeopathie" | cut -c1` == " " ]]; then
symptome_homeopathie=`echo "$symptome_homeopathie" | cut -c2-`
fi

if [[ `echo "$symptome_homeopathie" | tail -c 1` == " " ]]; then
symptome_homeopathie=`echo "$symptome_homeopathie" | sed "s/.$//"`
fi

# jv_success "Recherche N° 2 avec ces mots:.....$symptome_homeopathie....."

symptome_homeopathie1=$symptome_homeopathie

ligne_num_homeopathie_total=`grep -i -n "\-$symptome_homeopathie"  $chemin | cut -d: -f1 | wc -w`

if [[ "$ligne_num_homeopathie_total" == "0" ]]; then
symptome_homeopathie=`echo $symptome_homeopathie | cut -d" " -f2-`
ligne_num_homeopathie_total=`grep -i -n "\-$symptome_homeopathie"  $chemin | cut -d: -f1 | wc -w`
# if [[ "$symptome_homeopathie" == "-" ]]; then return; fi
fi

if [[ "$symptome_homeopathie" == "$symptome_homeopathie1" ]]; then 
if [[ "$ligne_num_homeopathie_total" -ge "1" ]]; then
say "j'ai bien trouvé quelque chose mais il me faut plus de précision..."
symptome_homeopathie_identique=`grep -ino "\-$symptome_homeopathie.*\.*" $chemin | cut -d- -f2 | sort | uniq | paste -s -d "," | sed -e "s/,/ ou /g"`
say "veuillez reformuler votre requette avec simplement:"
say "Quel traitement homéopathique pour la $symptome_homeopathie_identique"
return
fi
return
fi
homeopathie_test_resulat1
}


