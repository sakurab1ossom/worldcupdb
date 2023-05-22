#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WGOALS OGOALS
do
  if [[ $YEAR != "year" ]]
  then
  echo "$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER') ON CONFLICT (name) DO NOTHING;
  INSERT INTO teams(name) VALUES ('$OPPONENT') ON CONFLICT (name) DO NOTHING;
  INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', (SELECT team_id FROM teams WHERE name = '$WINNER'), (SELECT team_id FROM teams WHERE name = '$OPPONENT'), $WGOALS, $OGOALS);")"

    # WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    # if [[ -z $WINNER_ID ]]
    # then
    #   INSERT_WINNER_NAME_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    #   if [[ $INSERT_WINNER_NAME_RESULT == "INSERT 0 1" ]]
    #   then
    #     echo Inserted into teams, $WINNER
    #   fi
    # fi

    # OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # if [[ -z $OPPONENT_ID ]]
    # then
    #   INSERT_OPPONENT_NAME_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    #   if [[ $INSERT_OPPONENT_NAME_RESULT == "INSERT 0 1" ]]
    #   then
    #     echo Inserted into teams, $OPPONENT
    #   fi
    # fi

    # WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    # OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WGOALS', '$OGOALS')")
    # if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
    # then
    #     echo Inserted into games, $YEAR $ROUND
    # fi
  fi
done
