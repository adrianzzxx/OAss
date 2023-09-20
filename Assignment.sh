#!/bin/bash

# Author1:  Yong Wei Yuan
# Author2:  Goh Neng Fu
# Date:    14/07/2023
# Course:  BACS2093 Operating Systems
# Purpose: University Venue Management Menu



# Author1:  Yong Wei Yuan
# Task: Add New Patron
# Description:Adding new Patron into text file

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

    # Validate Patron ID (7-digit number)
    while true; do
        read -p "Patron ID (As per TAR UMT format): " patron_id
        if [[ $patron_id =~ ^[0-9]{7}$ ]]; then
            # Check if the Patron ID already exists in patron.txt
            if grep -q "^$patron_id:" patron.txt; then
                echo "Patron ID already exists. Please enter a different Patron ID."
            else
                break
            fi
        else
            echo "Invalid Patron ID format."
        fi
    done
    
    # Validate Patron Full Name (non-empty and no numbers)
    while true; do
        read -p "Patron Full Name (As per NRIC): " full_name
        if [[ -n "$full_name" ]]; then
            if [[ ! "$full_name" =~ [0-9] ]]; then
                break
            else
                echo "Full Name cannot contain numbers. Please enter a valid name."
            fi
        else
            echo "Full Name cannot be empty. Please enter a value."
        fi
    done

    # Validate Contact Number (non-empty and numbers only)
    while true; do
        read -p "Contact Number: " contact_number
        if [[ -n "$contact_number" ]]; then
            if [[ $contact_number =~ ^[0-9]{10,11}$ ]]; then
                break
            else
                echo "Contact Number can only contain numbers and between 10 to 11 digit number. Please enter a valid number."
            fi
        else
            echo "Contact Number cannot be empty. Please enter a value."
        fi
    done

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

# Author2       : Goh Neng Fu
# Task          : Add New Venue
# Description   : Adding new venue into text file

# Function to handle the C option (Add New Venue)
add_new_venue() {
    clear
    echo "Add New Venue"
    echo "=============="

    # Input validation for Block Name
    while true; do
        read -p "Block Name (alphabet only): " block_name
        if [[ $block_name =~ ^[[:alpha:]]+$ ]]; then
            break
        else
            echo "Invalid input. Block Name should contain alphabets only."
        fi
    done

    # Input validation for Room Number
    while true; do
        read -p "Room Number (e.g., AB123): " room_number
        if [[ $room_number =~ ^[[:alpha:]]{2}[0-9]+$ ]]; then
            break
        else
            echo "Invalid input. Room Number should start with 2 alphabets followed by numbers."
        fi
    done

    # Input validation for Room Type
    while true; do
        read -p "Room Type (alphabet only): " room_type
        if [[ $room_type =~ ^[[:alpha:]]+$ ]]; then
            break
        else
            echo "Invalid input. Room Type should contain alphabets only."
        fi
    done

    # Input validation for Capacity
    while true; do
        read -p "Capacity (numeric only): " capacity
        if [[ $capacity =~ ^[0-9]+$ ]]; then
            break
        else
            echo "Invalid input. Capacity should contain numeric digits only."
        fi
    done

    # Input validation for Remarks
    while true; do
        read -p "Remarks (non-numeric): " remarks
        if [[ $remarks =~ ^[[:alpha:][:space:]]+$ ]]; then
            break
        else
            echo "Invalid input. Remarks should not contain all numeric characters."
        fi
    done

    # Store venue details in the venue.txt file
    echo "$room_number:$block_name:$room_type:$capacity:$remarks:Available" >> venue.txt

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
    echo -e "Room Number\tRoom Type\tCapacity\tRemarks\t\t\tStatus"
    echo

    grep "^$search_block:" venue.txt | while IFS=':' read -r block_name room_number room_type capacity remarks status; do
        echo -e "$room_number\t\t$room_type\t\t$capacity\t\t$remarks\t\t\t$status"
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

# Call the main menu function to start the program
main_menu

# Function to check if a room is available for booking
is_room_available() {
    local room_number=$1
    local booking_date=$2
    local time_from=$3
    local time_to=$4

    # Convert time to minutes since midnight
    time_from_minutes=$((10#${time_from:0:2} * 60 + 10#${time_from:3:2}))
    time_to_minutes=$((10#${time_to:0:2} * 60 + 10#${time_to:3:2}))

    # Check if booking is within available hours (8am to 8pm)
    if [[ $time_from_minutes -ge 480 && $time_to_minutes -le 1200 ]]; then
        # Read existing bookings for the specified room on the given date
        existing_bookings=$(grep "^.*:$room_number:$booking_date:" booking.txt | cut -d: -f5-6)

        for booking in $existing_bookings; do
            existing_time_from=$(echo "$booking" | cut -d: -f1)
            existing_time_to=$(echo "$booking" | cut -d: -f2)
            existing_time_from_minutes=$((10#${existing_time_from:0:2} * 60 + 10#${existing_time_from:3:2}))
            existing_time_to_minutes=$((10#${existing_time_to:0:2} * 60 + 10#${existing_time_to:3:2}))

            # Check for overlap in booking times
            if ((time_from_minutes < existing_time_to_minutes && time_to_minutes > existing_time_from_minutes)); then
                echo "Room is already booked during the requested time."
                return 1
            fi
        done

        return 0
    else
        echo "Booking hours are from 8am to 8pm only."
        return 1
    fi
}

# Author1 & 2   : Yong Wei Yuan & Goh Neng Fu
# Task          : Book Venue
# Description   : Make a booking for venue

# Function to handle the E option (Book Venue)
book_venue() {
    clear
    echo "Patron Details Validation"
    echo "========================="

    read -p "Please enter the Patron’s ID Number: " patron_id
    patron_details=$(grep "^$patron_id:" patron.txt)

    if [[ -n "$patron_details" ]]; then
        patron_name=$(echo "$patron_details" | cut -d: -f2)
        echo "Patron Name (auto display): $patron_name"
        echo
        valid_choice=false

        while [ "$valid_choice" == false ]; do
            read -p "Press (n) to proceed Book Venue or (q) to return to University Venue Management Menu: " choice
            choice=${choice,,}  # Convert to lowercase

            if [[ "$choice" == "n" ]]; then
                valid_choice=true
            elif [[ "$choice" == "q" ]]; then
                main_menu
            else
                echo "Invalid choice. Please enter 'n' to proceed or 'q' to return to the menu."
            fi
        done

        clear
        echo "Booking Venue"
        echo "=============="

        room_exists=false

        while [ "$room_exists" == false ]; do
            read -p "Please enter the Room Number: " room_number

            # Perform a case-insensitive search for the full room number
            room_details=$(grep -i "^$room_number:" venue.txt)

            if [[ -n "$room_details" ]]; then
                room_type=$(echo "$room_details" | cut -d: -f3)
                capacity=$(echo "$room_details" | cut -d: -f4)
                remarks=$(echo "$room_details" | cut -d: -f5)

                echo "Room Type (auto display): $room_type"
                echo "Capacity (auto display): $capacity"
                echo "Remarks (auto display): $remarks"
                echo "Status:"

                room_exists=true  # Set to true to exit the loop
            else
                echo "Room not found. Please enter a valid room number."
            fi
        done

        # Additional input validations
        valid_date=false
        while [ "$valid_date" == false ]; do
            read -p "Booking Date (mm/dd/yyyy): " booking_date

            # Get the current date in the same format
            current_date=$(date +'%m/%d/%Y')

            if [[ "$(date -d "$booking_date" +%s)" -ge "$(date -d "$current_date" +%s)" ]]; then
                valid_date=true
            else
                echo "Invalid date. Booking date should not be earlier than today's date ($current_date)."
            fi
        done

        valid_time=false
        while [ "$valid_time" == false ]; do
            read -p "Time From (hh:mm): " time_from
            read -p "Time To (hh:mm): " time_to

            if [[ "$time_from" < "$time_to" ]]; then
                valid_time=true
            else
                echo "Invalid time. 'Time To' should be later than 'Time From'."
            fi
        done

        valid_reason=false
        while [ "$valid_reason" == false ]; do
            read -p "Reason for Booking: " reasons

            # Check if reasons contain only numeric characters
            if [[ ! "$reasons" =~ ^[0-9]+$ ]]; then
                valid_reason=true
            else
                echo "Invalid reason. Please provide a valid reason for booking."
            fi
        done

        # Rest of the booking process remains unchanged

        # After booking successfully, allow the user to choose whether to quit or return to the menu
        valid_choice=false
        while [ "$valid_choice" == false ]; do
            read -p "Booking Successful! Press (q) to return to University Venue Management Menu or (x) to quit: " choice
            choice=${choice,,}  # Convert to lowercase

            if [[ "$choice" == "q" ]]; then
                main_menu
            elif [[ "$choice" == "x" ]]; then
                exit 0
            else
                echo "Invalid choice. Please enter 'q' to return to the menu or 'x' to quit."
            fi
        done

    else
        echo "Patron ID not found."
        read -p "Press Enter to continue..."
        main_menu
    fi
}


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
            book_venue
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