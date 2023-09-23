#!/bin/bash

# Author1:  Yong Wei Yuan
# Author2:  Goh Neng Fu
# Date:    14/07/2023
# Course:  BACS2093 Operating Systems
# Purpose: University Venue Management Menu

# Author1:  Yong Wei Yuan
# Task: Add New Patron & Search Existing Patron
# Description: Adding new Patron into text file

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
                echo "*************************************************************"
                echo "Patron ID already exists. Please enter a different Patron ID."
                echo "*************************************************************"
            else
                break
            fi
        else
            echo "*************************************************************"
            echo "Invalid Patron ID format."
            echo "*************************************************************"
        fi
    done
    
    # Validate Patron Full Name (non-empty and no numbers)
    while true; do
        read -p "Patron Full Name (As per NRIC): " full_name
        if [[ -n "$full_name" ]]; then
            if [[ ! "$full_name" =~ [0-9] ]]; then
                break
            else
                echo "*************************************************************"
                echo "Full Name cannot contain numbers. Please enter a valid name."
                echo "*************************************************************"
            fi
        else
            echo "*************************************************************"
            echo "Full Name cannot be empty. Please enter a value."
            echo "*************************************************************"
        fi
    done

    # Validate Contact Number (non-empty and numbers only)
    while true; do
        read -p "Contact Number: " contact_number
        if [[ -n "$contact_number" ]]; then
            if [[ $contact_number =~ ^[0-9]{10,11}$ ]]; then
                break
            else
                echo "*************************************************************"
                echo "Contact Number can only contain numbers and between 10 to 11 digit number. Please enter a valid number."
                echo "*************************************************************"
            fi
        else
            echo "*************************************************************"
            echo "Contact Number cannot be empty. Please enter a value."
            echo "*************************************************************"
        fi
    done

    # Validate the email address
    while true; do
        read -p "Email Address (As per TAR UMT format): " email_address
        if is_valid_email "$email_address"; then
            break
        else
            echo "*************************************************************"
            echo "Invalid email format. Please enter a valid email address."
            echo "*************************************************************"
        fi
    done

    # Store patron details in the patron.txt file
    echo "$patron_id:$full_name:$contact_number:$email_address" >> patron.txt

    echo

    while true; do
    read -p "Register Another Patron? (y)es or (q)uit: " choice
    case "$choice" in
        [Yy])
            register_patron
            ;;
        [Qq])
            main_menu
            ;;
        *)
            echo "*************************************************************"
            echo "Invalid input. Please enter 'y' or 'q'."
            echo "*************************************************************"
            ;;
    esac
done

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
        echo "*************************************************************"
        echo "Patron ID not found."
        echo "*************************************************************"
    fi

    while true; do
    read -p "Search Another Patron? (y)es or (q)uit: " choice
    case "$choice" in
        [Yy])
            search_patron
            ;;
        [Qq])
            main_menu
            ;;
        *)
            echo "*************************************************************"
            echo "Invalid input. Please enter 'y' or 'q'."
            echo "*************************************************************"
            ;;
    esac
done

}

# Author2       : Goh Neng Fu
# Task          : Add New Venue & Search Existing Venue
# Description   : Adding new venue into text file & search the existing venue

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
            echo "********************************************************************"
            echo "Invalid input. Block Name should contain alphabets only."
            echo "********************************************************************"
        fi
    done

    # Input validation for Room Number
    while true; do
        read -p "Room Number (combination of alphabet and numbers, no space): " room_number
        if [[ $room_number =~ ^[[:alnum:]]+$ && ! $room_number =~ ^[0-9]+$ ]]; then
            # Check if the room number already exists
            if grep -q "$room_number:" venue.txt; then
                echo "********************************************************************"
                echo "Room Number already exists. Please enter a different Room Number."
                echo "********************************************************************"
            else
                break
            fi
        else
            echo "**********************************************************************************************************************"
            echo "Invalid input. Room Number should contain a combination of alphabets and numbers, with no spaces, and not all numeric."
            echo "**********************************************************************************************************************"
        fi
    done

    # Input validation for Room Type
    while true; do
        read -p "Room Type (Lecture Hall, Tutorial Room, Practical Lab): " room_type
        if [[ "$room_type" == "Lecture Hall" || "$room_type" == "Tutorial Room" || "$room_type" == "Practical Lab" ]]; then
            break
        else
            echo "********************************************************************"
            echo "Invalid input. Room Type should contain alphabets and spaces only."
            echo "********************************************************************"
        fi
    done

    # Input validation for Capacity
    while true; do
        read -p "Capacity (numeric only): " capacity
        if [[ $capacity =~ ^[0-9]+$ ]]; then
            break
        else
            echo "********************************************************************"
            echo "Invalid input. Capacity should contain numeric digits only."
            echo "********************************************************************"
        fi
    done

    # Input validation for Remarks
    read -p "Remarks (optional): " remarks

    # Check if remarks is empty and set it to "NULL" if it is
    if [ -z "$remarks" ]; then
        remarks="NULL"
    fi

    # Input validation for Status
    while true; do
        read -p "Status (Available/Unavailable): " status
        if [[ "$status" == "Available" || "$status" == "Unavailable" || "$status" == "available" || "$status" == "unavailable" ]]; then
            break
        else
            echo "********************************************************************"
            echo "Invalid input. Status should be 'Available' or 'Unavailable'."
            echo "********************************************************************"
        fi
    done

    # Check if the room number already exists
    if grep -q "$room_number:" venue.txt; then
        echo "********************************************************************"
        echo "Room Number already exists. Please enter a different Room Number."
        echo "********************************************************************"
    else
        # Store venue details in the venue.txt file
        echo "$block_name:$room_number:$room_type:$capacity:$remarks:$status" >> venue.txt

        echo
        while true; do
            read -p "Add Another New Venue? (y)es or (q)uit: " choice
            case "$choice" in
                [Yy])
                    add_new_venue
                    break
                    ;;
                [Qq])
                    main_menu
                    break
                    ;;
                *)
                    echo "********************************************************************"
                    echo "Invalid input. Please enter 'y' to add another venue or 'q' to quit."
                    echo "********************************************************************"
                    ;;
            esac
        done
    fi
}

# Function to handle the D option (List Venue)
list_venue_details() {
    clear
    echo "List Venue Details"
    echo

    # Input validation for Block Name
    while true; do
        read -p "Enter Block Name (alphabet only): " search_block
        if [[ $search_block =~ ^[[:alpha:]]+$ ]]; then
            break
        else
            echo "********************************************************************"
            echo "Invalid input. Block Name should contain alphabets only."
            echo "********************************************************************"
        fi
    done

    # Check if the block name exists in the venue.txt file
    if grep -q "^$search_block:" venue.txt; then
        echo "--------------------------------------------------------------------------------------------"
        # Filter and display venue details based on the block name
        echo -e "Room Number\tRoom Type\t\tCapacity\tStatus\t\t\tRemarks"
        echo

        grep "^$search_block:" venue.txt | while IFS=':' read -r block_name room_number room_type capacity remarks status; do
            echo -e "$room_number\t\t$room_type\t\t$capacity\t\t$status\t\t$remarks"
        done

        echo
        echo "--------------------------------------------------------------------------------------------"
        echo "Options:"
        echo "1 - Change Room Status to Unavailable"
        echo "2 - Change Room Status to Available"
        echo "3 - Search Another Block"
        echo "4 - Back to University Venue Management Menu"
        echo
        read -p "Select an option: " option

        case $option in
            1)
                change_room_status "Unavailable"
                ;;
            2)
                change_room_status "Available"
                ;;
            3)
                list_venue_details
                ;;
            4)
                main_menu
                ;;
            *)
                echo "********************************************************************"
                echo "Invalid option. Please select a valid option."
                echo "********************************************************************"
                read -p "Press Enter to continue..."
                list_venue_details
                ;;
        esac
    else
        echo "********************************************************************"
        echo "Block not found. Please enter a valid Block Name."
        echo "********************************************************************"
        list_venue_details  # Allow the user to enter the block name again
    fi
}

# Function to change room status while keeping other details unchanged
change_room_status() {
    local new_status=$1

    read -p "Enter the Room Number to change status: " room_number

    # Check if the room exists
    if grep -q "^.*:$room_number:" venue.txt; then
        # Get the existing room details
        existing_details=$(grep "^.*:$room_number:" venue.txt)
        old_status=$(echo "$existing_details" | cut -d: -f6)  # Get the old status
        new_line="${existing_details/$old_status/$new_status}"  # Replace old status with new status
        sed -i "s|$existing_details|$new_line|" venue.txt
        echo "Room status changed to $new_status."
    else
        echo "********************************************************************"
        echo "Room not found. Please enter a valid room number."
        echo "********************************************************************"
    fi

    read -p "Press Enter to continue..."
    list_venue_details
}

# Call the main menu function to start the program
main_menu

# Author1 & 2   : Yong Wei Yuan & Goh Neng Fu
# Task          : Book Venue
# Description   : Make a booking for venue

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
        echo "*************************************************************"
        echo "Booking hours are from 8am to 8pm only."
        echo "*************************************************************"
        return 1
    fi
}

# Function to check if a booking time overlaps with existing bookings
is_time_overlap() {
    local booking_date="$1"
    local time_from="$2"
    local time_to="$3"

    # Convert time to minutes since midnight
    time_from_minutes=$((10#${time_from:0:2} * 60 + 10#${time_from:3:2}))
    time_to_minutes=$((10#${time_to:0:2} * 60 + 10#${time_to:3:2}))

    # Read existing bookings for the specified date
    existing_bookings=$(grep "^.*:$booking_date:" booking.txt | cut -d: -f5-6)

    for booking in $existing_bookings; do
        existing_time_from=$(echo "$booking" | cut -d: -f1)
        existing_time_to=$(echo "$booking" | cut -d: -f2)
        existing_time_from_minutes=$((10#${existing_time_from:0:2} * 60 + 10#${existing_time_from:3:2}))
        existing_time_to_minutes=$((10#${existing_time_to:0:2} * 60 + 10#${existing_time_to:3:2}))

        # Check for overlap in booking times
        if ((time_from_minutes < existing_time_to_minutes && time_to_minutes > existing_time_from_minutes)); then
            return 0  # Overlapping time found
        fi
    done

    return 1  # No overlapping time found
}


# Function to generate a booking receipt
generate_booking_receipt() {
    local patron_id="$1"
    local patron_name="$2"
    local room_number="$3"
    local booking_date="$4"
    local time_from="$5"
    local time_to="$6"
    local reasons="$7"

    # Define the receipt filename based on patron_id, room_number, and booking_date
    local receipt_filename="${patron_id}_${room_number}_${booking_date//\//-}.txt"

    # Create the receipt file and write booking details to it
    echo "Venue Booking Receipt" > "$receipt_filename"
    echo "Patron ID: $patron_id" >> "$receipt_filename"
    echo "Patron Name: $patron_name" >> "$receipt_filename"
    echo "Room Number: $room_number" >> "$receipt_filename"
    echo "Booking Date: $booking_date" >> "$receipt_filename"
    echo "Time From: $time_from" >> "$receipt_filename"
    echo "Time To: $time_to" >> "$receipt_filename"
    echo "Reason for Booking: $reasons" >> "$receipt_filename"
    echo >> "$receipt_filename"
    echo "This is a computer-generated receipt with no signature required." >> "$receipt_filename"
    echo >> "$receipt_filename"
    echo "Printed on $(date '+%m-%d-%Y %I:%M%p')." >> "$receipt_filename"

    echo "Booking Successful! Receipt saved as $receipt_filename"
}

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
                echo "*************************************************************************"
                echo "Invalid choice. Please enter 'n' to proceed or 'q' to return to the menu."
                echo "*************************************************************************"
            fi
        done

        clear
        echo "Booking Venue"
        echo "=============="

        room_exists=false

        while [ "$room_exists" == false ]; do
            read -p "Please enter the Room Number(example: K001A): " room_number

            # Use grep to search for the room number and read its details into variables
            room_details=$(grep "$room_number:" venue.txt)

            if [[ "$room_details" ]]; then
                room_type=$(echo "$room_details" | cut -d: -f3)
                capacity=$(echo "$room_details" | cut -d: -f4)
                remarks=$(echo "$room_details" | cut -d: -f5)
                status=$(echo "$room_details" | cut -d: -f6)

                if [[ "$status" == "Available" ]]; then
                    echo "Room Type (auto display): $room_type"
                    echo "Capacity (auto display): $capacity"
                    echo "Remarks (auto display): $remarks"
                    echo "Status (auto display): $status"

                    room_exists=true  # Set to true to exit the loop
                else
                    echo "*************************************************************************"
                    echo "Room is not available for booking. Please enter a different room number."
                    echo "*************************************************************************"
                fi
            else
                echo "*************************************************************************"
                echo "Room not found. Please enter a valid room number."
                echo "*************************************************************************"
            fi
        done

        # Additional input validations
        valid_date=false
        while [ "$valid_date" == false ]; do
            read -p "Booking Date (mm/dd/yyyy): " booking_date

            # Get the current date in the same format
            current_date=$(date +'%m/%d/%Y')

            # Calculate the timestamp for the booking date and one day in advance
            booking_date_timestamp=$(date -d "$booking_date" +%s)
            one_day_in_advance_timestamp=$(date -d "$current_date + 1 day" +%s)

            if [[ "$booking_date_timestamp" -ge "$one_day_in_advance_timestamp" ]]; then
                valid_date=true
            else
                echo "***************************************************************************************************"
                echo "Invalid date. Booking date should be at least one day in advance from today's date ($current_date)."
                echo "***************************************************************************************************"
            fi
        done

        valid_time=false

        while [ "$valid_time" == false ]; do
            read -p "Time From (hh:mm): " time_from

            if [[ "$time_from" =~ ^[0-9]{2}:[0-5][0-9]$ ]]; then
                # Check if time_from is greater than or equal to 08:00
                if [[ "$time_from" < "08:00" ]]; then
                    echo "***************************************************"
                    echo "Invalid time. 'Time From' should be 08:00 or later."
                    echo "***************************************************"
                else
                    # Prompt for Time To
                    read -p "Time To (hh:mm): " time_to
                    
                    if [[ "$time_to" =~ ^[0-9]{2}:[0-5][0-9]$ ]]; then
                        # Check if time_to is less than 2000
                        if [[ "$time_to" > "20:00" ]]; then
                            echo "***************************************************"
                            echo "Invalid time. 'Time To' should be 20:00 or earlier."
                            echo "***************************************************"
                        # Check if the time interval is at least 30 minutes
                        elif (( $(date -d "$time_to" +%s) - $(date -d "$time_from" +%s) < 1800 )); then
                            echo "*****************************************************************"
                            echo "Invalid time interval. The booking should be at least 30 minutes."
                            echo "*****************************************************************"
                        else
                            # Check for overlapping bookings
                            if is_time_overlap "$booking_date" "$time_from" "$time_to"; then
                                valid_time=true
                            else
                                # Overlapping booking found, ask the user to enter a different time
                                echo "******************************************************************************************"
                                echo "Please choose a different time slot. The room is already booked during the requested time."
                                echo "******************************************************************************************"
                            fi
                        fi
                    else
                        echo "******************************************************************************************"
                        echo "Invalid time format. Please use hh:mm format (e.g., 08:30) for 'Time To'."
                        echo "******************************************************************************************"
                    fi
                fi
            else
                echo "******************************************************************************************"
                echo "Invalid time format. Please use hh:mm format (e.g., 08:30) for 'Time From'."
                echo "******************************************************************************************"
            fi
        done


        valid_reason=false
        while [ "$valid_reason" == false ]; do
            read -p "Reason for Booking: " reasons

            # Check if reasons contain only numeric characters
            if [[ ! "$reasons" =~ ^[0-9]+$ ]]; then
                valid_reason=true
            else
                echo "******************************************************************************************"
                echo "Invalid reason. Please provide a valid reason for booking."
                echo "******************************************************************************************"
            fi
        done
        echo "$patron_id:$patron_name:$room_number:$booking_date:$time_from:$time_to:$reasons" >> booking.txt

        # Generate the booking receipt
        generate_booking_receipt "$patron_id" "$patron_name" "$room_number" "$booking_date" "$time_from" "$time_to" "$reasons"

        # After booking successfully, allow the user to choose whether to quit or return to the menu
        valid_choice=false
        while [ "$valid_choice" == false ]; do
            read -p "Press (q) to return to University Venue Management Menu or (x) to quit: " choice
            choice=${choice,,}  # Convert to lowercase

            if [[ "$choice" == "q" ]]; then
                main_menu
            elif [[ "$choice" == "x" ]]; then
                exit 0
            else
                echo "******************************************************************************************"
                echo "Invalid choice. Please enter 'q' to return to the menu or 'x' to quit."
                echo "******************************************************************************************"
            fi
        done

        

    else
        echo "********************"
        echo "Patron ID not found."
        echo "********************"
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
            echo "*********************************************"
            echo "Invalid choice. Please select a valid option."
            echo "*********************************************"
            read -p "Press Enter to continue..."
            main_menu
            ;;
    esac
}

# Call the main menu function to start the program
main_menu