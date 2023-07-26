#!/bin/bash

# Function to check if the email is valid
is_valid_email() {
    local email=$1
    local regex='^[A-Za-z0-9._%+-]+@student\.tarc\.edu\.my$'
    if [[ $email =~ $regex ]]; then
        return 0  # Valid email format
    else
        return 1  # Invalid email format
    fi
}

# Function to handle the A option (Register New Patron)
register_patron() {
    clear
    echo "Patron Registration"
    echo "=================="

    read -p "Patron ID (As per TAR UMT format): " patron_id
    read -p "Patron Full Name (As per NRIC): " full_name
    read -p "Contact Number: " contact_number

    # Validate the email address
    while true; do
        read -p "Email Address (As per TAR UMT format): " email_address
        if is_valid_email "$email_address"; then
            break
        else
            echo "Invalid email format. Please enter a valid email address."
        fi
    done

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
add_new_venue() {
    clear
    echo "Add New Venue"
    echo "=============="

    read -p "Block Name: " block_name
    read -p "Room Number: " room_number
    read -p "Room Type: " room_type
    read -p "Capacity: " capacity
    read -p "Remarks: " remarks

    # Store venue details in the venue.txt file
    echo "$block_name:$room_number:$room_type:$capacity:$remarks:Available" >> venue.txt

    echo
    read -p "Add Another New Venue? (y)es or (q)uit: " choice
    if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
        add_new_venue
    else
        main_menu
    fi
}

# Function to handle the D option (List Venue)
list_venue_details() {
    clear
    echo "List Venue Details"
    echo

    read -p "Enter Block Name: " search_block
    echo "--------------------------------------------------------------------------------------------"
    # Filter and display venue details based on the block name
    printf "%-15s%-25s%-15s%-35s%-15s\n" "Room Number" "Room Type" "Capacity" "Remarks" "Status"
    echo

    grep "^$search_block:" venue.txt | while IFS=':' read -r block_name room_number room_type capacity remarks status; do
        printf "%-15s%-25s%-15s%-35s%-15s\n" "$room_number" "$room_type" "$capacity" "$remarks" "$status"
    done

    echo
    echo "--------------------------------------------------------------------------------------------"
    read -p "Search Another Block Venue? (y)es or (q)uit: " choice
    if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
        list_venue_details
    else
        main_menu
    fi
}

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
            add_new_venue
            ;;
        D|d)
            list_venue_details
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
