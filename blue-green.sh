#!/bin/sh

export DOMAIN_URL="bluegreen.apps.wsjeong.ocp4.local"
export CONTEXT="demo"

export BLUE_COUNT=1
export GREEN_COUNT=1

printf "%s\n" "------------------------------------------------------------------------------"
printf "\e[1;34m %-10s\e[0m \n" "## canary deployment test ##"
printf "%s\n" "------------------------------------------------------------------------------"


for i in {1..20};
do 
RESULT_1=`curl ${DOMAIN_URL}/${CONTEXT}/ 2>&1  | egrep "GREEN APP|BLUE APP"` ;
RESUT_2=`echo "${RESULT_1}" | sed 's/<\/p>//g' | sed 's/>/\n/g' | egrep "GREEN APP|BLUE APP"`;

if [[ ${RESUT_2} == "BLUE APP" ]];
   then 
      let BLUE_COUNT=$BLUE_COUNT+1
      printf " %-2s | %-25s | \e[1;34m %s\e[0m\n" "$i" "http://${DOMAIN_URL}/${CONTEXT}" "${RESUT_2}" ;
   else
      let GREEN_COUNT=$GREEN_COUNT+1
      printf " %-2s | %-25s | \e[1;32m %s\e[0m\n" "$i" "http://${DOMAIN_URL}/${CONTEXT}" "${RESUT_2}" ;

fi
done

printf "%s\n" "------------------------------------------------------------------------------"

printf "\e[1;34m %-3s\e[0m | %-2s\n" "BLUE" "${BLUE_COUNT}"
printf "\e[1;32m %-3s\e[0m | %-2s\n" "GREEN" "${GREEN_COUNT}"

printf "%s\n" "------------------------------------------------------------------------------"


