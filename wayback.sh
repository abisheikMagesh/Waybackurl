#!/bin/bash

# Default values
DOMAINS_FILE=""
DOMAIN=""
SAVE_PATH=""
OUTPUT_DIR=""

# Parse command-line arguments
while getopts "u:l:p:" opt; do
  case ${opt} in
    u )
      DOMAIN="$OPTARG"
      ;;
    l )
      DOMAINS_FILE="$OPTARG"
      ;;
    p )
      SAVE_PATH="$OPTARG"
      ;;
    \? )
      echo "Usage: waybac.sh [-u <domain_name> | -l <domain_list_file>] [-p <output_file_path>]"
      exit 1
      ;;
  esac
done

# Check if either -u or -l is provided
if [[ -z $DOMAIN && -z $DOMAINS_FILE ]]; then
  echo "Usage: waybac.sh [-u <domain_name> | -l <domain_list_file>] [-p <output_file_path>]"
  exit 1
fi

# Check if both -u and -l are provided
if [[ ! -z $DOMAIN && ! -z $DOMAINS_FILE ]]; then
  echo "Error: Please provide either -u <domain_name> or -l <domain_list_file>, not both."
  exit 1
fi

# Set URL_TEMPLATE based on the provided input
if [[ ! -z $DOMAIN ]]; then
  URL_TEMPLATE="https://web.archive.org/cdx/search/cdx?url=*.${DOMAIN}/*&output=text&fl=original&collapse=urlkey"
elif [[ ! -z $DOMAINS_FILE ]]; then
  URL_TEMPLATE="https://web.archive.org/cdx/search/cdx?url=*.DOMAIN/*&output=text&fl=original&collapse=urlkey"
fi

# Check if the output file path is provided
if [[ -z $SAVE_PATH ]]; then
  OUTPUT_DIR="$(date +'%Y-%m-%d_%H-%M-%S_%s')"
  mkdir "$OUTPUT_DIR"

  if [[ ! -z $DOMAIN ]]; then
    echo "Using single domain: $DOMAIN"
    url="${URL_TEMPLATE//DOMAIN/$DOMAIN}"
    curl -sS -k "$url" > "$OUTPUT_DIR/${DOMAIN}.txt"
  elif [[ ! -z $DOMAINS_FILE ]]; then
    echo "Using domain list file: $DOMAINS_FILE"
    while IFS= read -r domain; do
      url="${URL_TEMPLATE//DOMAIN/$domain}"
      curl -sS -k "$url" >> "$OUTPUT_DIR/${domain}.txt"
    done < "$DOMAINS_FILE"
  fi
else
  if [[ ! -z $DOMAIN ]]; then
    echo "Using single domain: $DOMAIN"
    url="${URL_TEMPLATE//DOMAIN/$DOMAIN}"
    curl -sS -k "$url" > "$SAVE_PATH"
  elif [[ ! -z $DOMAINS_FILE ]]; then
    echo "Using domain list file: $DOMAINS_FILE"
    while IFS= read -r domain; do
      url="${URL_TEMPLATE//DOMAIN/$domain}"
      curl -sS -k "$url" >> "$SAVE_PATH"
    done < "$DOMAINS_FILE"
  fi
fi
