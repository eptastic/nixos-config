#!/bin/bash

# Your OpenWeatherMap API key
API_KEY=$(< /run/secrets/openweather_api_key)

# Your city and country code (adjust as necessary)
CITY="Brunswick"
COUNTRY_CODE="AU"

CITY_ID="2173741"

LAT="-37.76"
LON="144.96"

# Parts to exclude
PART=""

# API call to OpenWeatherMap
response=$(curl -s "https://api.openweathermap.org/data/2.5/weather?id=${CITY_ID}&appid=${API_KEY}&units=metric")


# Check if the response contains valid temperature data
if [ -n "$response" ]; then
    temperature=$(echo "$response" | jq -r '.main.temp')
    
    if [ "$temperature" != "null" ]; then
        temperature=$(echo "$temperature" | awk '{printf "%.0f", $1}')

        # Determine emoji based on temperature range
        if (( $(echo "$temperature <= 10" | bc -l) )); then
            emoji="🥶"  # Cold emoji
        elif (( $(echo "$temperature < 15" | bc -l) )); then
            emoji="❄️"  # Cool emoji
        elif (( $(echo "$temperature < 25" | bc -l) )); then
            emoji="☀️"  # Warm emoji
        else
            emoji="🔥"  # Hot emoji
        fi

        # Output temperature and emoji
        echo "${temperature}°C $emoji"
    else
        echo "Error: Temperature data not available."
    fi
else
    echo "Error: Unable to fetch weather data from OpenWeatherMap."
fi
