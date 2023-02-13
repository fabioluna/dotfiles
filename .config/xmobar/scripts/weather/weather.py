import sys
import requests
import json
import wetterXmobarLib as wXL
import time
import sys


# main function to put everything together
def weatherReport() -> None:
    """Main function."""
    weather_URL = "http://wttr.in/"
    city = "Florianópolis"
    weather_report = ""
    # Here I define arrays with the data I collect
    current_weather_temperature = ["temp_C", "FeelsLikeC"]
    current_weather_conditions = [
        "windspeedKmph",
        "humidity",
        "weatherCode",
        "winddir16Point",
    ]
    current_weather_map = {}
    # in the case of errors (either connectivity or JSON parsing)
    # I just put "N/A" message in a yellow color
    try:
        response = requests.get(weather_URL + city + "?format=j1").json()

        for temperature in current_weather_temperature:
            if "-" in response["current_condition"][0][temperature]:
                current_weather_map[temperature] = response["current_condition"][0][
                    temperature
                ]
            else:
                current_weather_map[temperature] = (
                    "+" + response["current_condition"][0][temperature]
                )

        for condition in current_weather_conditions:
            current_weather_map[condition] = response["current_condition"][0][condition]

        current_weather_map["sunrise"] = wXL.convert24(
            response["weather"][0]["astronomy"][0]["sunrise"]
        )

        current_weather_map["sunset"] = wXL.convert24(
            response["weather"][0]["astronomy"][0]["sunset"]
        )

        current_weather_map["windgustKmph"] = wXL.give_wind_gust(response)

        current_weather_map["windspeedMs"] = str(
            int(current_weather_map["windspeedKmph"]) * 10 // 36
        )

        current_weather_map["windgustMs"] = str(
            int(current_weather_map["windgustKmph"]) * 10 // 36
        )
        weather_report = wXL.make_xmobar_weather_string(current_weather_map)
        # weather_report = wX.make_xmobar_weather_string(current_weather_map,
        # weather_colors, wind_colors)

    except requests.RequestException:
        weather_report = "wttr.in unreach"

    except json.decoder.JSONDecodeError:
        weather_report = "wttr.in down"

    print(weather_report)


def main() -> None:
    weatherReport()


if __name__ == "__main__":
    main()
