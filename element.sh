#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM properties WHERE atomic_number = $1")

# if not empty
if [[ ! -z $ATOMIC_NUMBER ]]
then
  #define symbol and name
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $1")
  NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $1")
else
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol = '$1'")

  # if not empty
  if [[ ! -z $SYMBOL ]]
  then
    #define atomic number and name
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1'")
    NAME=$($PSQL "SELECT name FROM elements WHERE symbol = '$1'")
  else
    NAME=$($PSQL "SELECT name FROM elements WHERE name = '$1'")

    # if not empty
    if [[ ! -z $NAME ]]
    then
      #define atomic number and symbol
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1'")
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name = '$1'")
    fi
  fi
fi
# get property variables
ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
MELT_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
BOIL_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
TYPE=$($PSQL "SELECT type FROM types t JOIN properties p ON p.type_id = t.type_id WHERE atomic_number = $ATOMIC_NUMBER")

# Output
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo "I could not find that element in the database."
  else
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELT_POINT celsius and a boiling point of $BOIL_POINT celsius."
  fi
fi
