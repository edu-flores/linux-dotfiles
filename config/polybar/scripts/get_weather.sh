#!/bin/bash

# Load environment variables
source ~/.env

# OpenWeatherMap API URL
url="https://api.openweathermap.org/data/2.5/weather?id=${LOCATION_ID}&appid=${API_KEY}&units=metric"

# Get the weather data from the API
if ping -q -c 1 -W 1 google.com &> /dev/null; then
    weather_data=$(curl -s $url)

    # Extract temperature and icon from the JSON response
    temp_raw=$(echo $weather_data | grep -o '"temp":[^,]*' | cut -d: -f2)
    temp_rounded=$(printf "%.0f" $temp_raw)
    icon=$(echo $weather_data | grep -o '"icon":"[^"]*' | cut -d'"' -f4)

    # Convert the icon code to a corresponding symbol
    case $icon in
        "01d") weather_icon="󰖨 ";;  # Clear sky (day)
        "02d") weather_icon=" ";;  # Few clouds (day)
        "03d") weather_icon=" ";;  # Scattered clouds (day)
        "04d") weather_icon=" ";;  # Broken clouds (day)
        "09d") weather_icon=" ";;  # Shower rain (day)
        "10d") weather_icon=" ";;  # Rain (day)
        "11d") weather_icon=" ";;  # Thunderstorm (day)
        "13d") weather_icon=" ";;  # Snow (day)
        "50d") weather_icon="󰍜 ";;  # Mist (day)
        "01n") weather_icon="󰽧 ";;  # Clear sky (night)
        "02n") weather_icon=" ";;  # Few clouds (night)
        "03n") weather_icon=" ";;  # Scattered clouds (night)
        "04n") weather_icon=" ";;  # Broken clouds (night)
        "09n") weather_icon=" ";;  # Shower rain (night)
        "10n") weather_icon=" ";;  # Rain (night)
        "11n") weather_icon=" ";;  # Thunderstorm (night)
        "13n") weather_icon=" ";;  # Snow (night)
        "50n") weather_icon="󰍜 ";;  # Mist (night)
        *) weather_icon=" ";;
    esac

    # Display the result
    echo "$weather_icon $temp_rounded°C"
else
    # No internet connection
    echo " "
fi
