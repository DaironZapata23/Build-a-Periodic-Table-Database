#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ $1 == '' ]]
  then
  echo "Please provide an element as an argument."
  else
  if [[ $1 =~ ^[0-9]+$ ]]
    then
      ELEMENT=$($PSQL "SELECT atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol, name, type FROM properties JOIN elements USING(atomic_number) JOIN types USING(type_id) WHERE elements.atomic_number=$1")
      #echo "Hola. soy numero"
    else
      ELEMENT=$($PSQL "SELECT atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol, name, type FROM properties JOIN elements USING(atomic_number) JOIN types USING(type_id) WHERE elements.name LIKE '$1%' ORDER BY atomic_number LIMIT 1")
      #echo "Hola. no soy numero"
  fi
  if [[ -z $ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else
    echo $ELEMENT | while IFS=\| read A_NUMBER A_MASS MEPC BOPC SY NAME TYPE
    do 
      echo "The element with atomic number $A_NUMBER is $NAME ($SY). It's a $TYPE, with a mass of $A_MASS amu. $NAME has a melting point of $MEPC celsius and a boiling point of $BOPC celsius."
    done
  fi
fi
