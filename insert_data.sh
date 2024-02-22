#!/bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $YEAR != 'year' ]]
then
  #Get Winner Team ID
  GET_WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
  echo '1'
  #Enter New Winner Team ID
  if [[ -z $GET_WINNER_ID ]]
  then
  #If not found insert new team
    INSERT_WINNER_ID=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
    if [[ $INSERT_WINNER_ID == "INSERT 0 1" ]]
    then
      echo "Inserted $WINNER into Teams"
      GET_WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    fi
  fi
  GET_OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
  if [[ -z $GET_OPPONENT_ID ]]
  then
  #If not found insert new team
    INSERT_OPPONENT_ID=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
    if [[ $INSERT_OPPONENT_ID == 'INSERT 0 1' ]]
    then
      echo "Inserted $OPPONENT into Teams"
      GET_OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    fi
  fi
 #Get Team ID
 #Get New Team ID
  POPULATE_GAMES_TABLE=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $GET_WINNER_ID, $GET_OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  if [[ $POPULATE_GAMES_TABLE = 'INSERT 0 1' ]]
  then
    echo "Inserted new row into games table"
  fi
fi
done