#!/bin/bash

# Function to handle the A option (Register New Patron)
register_patron() {
    clear
    echo "Patron Registration"
    echo "=================="

    read -p "Patron ID (As per TAR UMT format): " patron_id
    read -p "Patron Full Name (As per NRIC): " full_name
    read -p "Contact Number: " contact_number
    read -p "Email Address (As per TAR UMT format): " email_address

    # Store patron details in the patron.txt file
    echo "$patron_id:$full_name:$contact_number:$email_address" >> patron.txt

    echo

    read -p "Register Another Patron? (y)es or (q)uit: " choice
    if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
        register_patron
    else
        main_menu
    fi
}

# Function to handle the B option (Search Patron Details)
search_patron() {
    clear
    echo -e "\e[1;4;49;37m Search Patron Details \e[0m"
    echo

    read -p "Enter Patron ID: " search_id

    echo

    # Search for patron details in the patron.txt file
    patron_details=$(grep "^$search_id:" patron.txt)

    if [[ -n "$patron_details" ]]; then
        patron_name=$(echo "$patron_details" | cut -d: -f2)
        contact_number=$(echo "$patron_details" | cut -d: -f3)
        email_address=$(echo "$patron_details" | cut -d: -f4)

        echo "Full Name (auto display): $patron_name"
        echo "Contact Number (auto display): $contact_number"
        echo "Email Address (auto display): $email_address"
        echo
    else
        echo "Patron ID not found."
    fi

    read -p "Search Another Patron? (y)es or (q)uit: " choice
    if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
        search_patron
    else
        main_menu
    fi
}

# Function to handle the C option (Add New Venue)
# ... (Add your implementation for option C here)

# Function to handle the D option (List Venue)
# ... (Add your implementation for option D here)

# Function to handle the E option (Book Venue)
# ... (Add your implementation for option E here)

# Main menu function
main_menu() {
    clear
    echo "University Venue Management Menu"
    echo
    echo "A – Register New Patron"
    echo "B – Search Patron Details"
    echo "C – Add New Venue"
    echo "D – List Venue"
    echo "E – Book Venue"
    echo
    echo "Q – Exit from Program"
    echo
    read -p "Please select a choice: " choice

    case $choice in
        A|a)
            register_patron
            ;;
        B|b)
            search_patron
            ;;
        C|c)
            # Call the function to handle option C
            # add_venue
            ;;
        D|d)
            # Call the function to handle option D
            # list_venue
            ;;
        E|e)
            # Call the function to handle option E
            # book_venue
            ;;
        Q|q)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please select a valid option."
            read -p "Press Enter to continue..."
            main_menu
            ;;
    esac
}

# Call the main menu function to start the program
main_menu
