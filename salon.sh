#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "\nWelcome to My Salon, how can I help you?\n" 

MAIN_MENU () {
 if [[ $1 ]]
 then
  echo -e "\n$1"
  fi

  SERVICES_AVAILABLE=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
  echo "$SERVICES_AVAILABLE" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done
    echo -e "7) exit"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    [1-6]) SERVICE_MENU ;;
    7) EXIT ;;
    *) MAIN_MENU "I could not find that service. What would you like today?\n" ;;
  esac

}

SERVICE_MENU () {
  SERVICE_SELECTED=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  echo -e "\nYou selected$SERVICE_SELECTED"
  echo  -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")


  # if customer isn't in system.
  if [[ -z $CUSTOMER_NAME ]]
  then
  # get new customer name
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
  # insert new customer
    INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  fi

  # Set time of appointment
  echo -e "\nWhat time would you like your$SERVICE_SELECTED,$CUSTOMER_NAME?"
  read SERVICE_TIME
  
  # get customer_id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  # insert appointment
  INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  echo -e "\nI have put you down for a$SERVICE_SELECTED at $SERVICE_TIME,$CUSTOMER_NAME."
}

EXIT() {
  echo -e "\nThank you for stopping in.\n"
}

MAIN_MENU




