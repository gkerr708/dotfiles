#!/bin/bash
# Weather for waybar (JSON) from wttr.in, pinned to Halifax. Prints nothing when offline (module hides).
j=$(curl -sf -m 10 'https://wttr.in/Halifax,Nova+Scotia?format=j1') || exit 0
code=$(echo "$j" | jq -r '.current_condition[0].weatherCode')
IFS='|' read -r rise set < <(echo "$j" | jq -r '.weather[0].astronomy[0] | "\(.sunrise)|\(.sunset)"')
now=$(date +%H%M); day=1
[ "$now" -lt "$(date -d "$rise" +%H%M)" ] || [ "$now" -ge "$(date -d "$set" +%H%M)" ] && day=0

# WWO weather codes -> short condition labels
case $code in
  113) icon=SU ;;                                                # sunny
  116) icon=PC ;;                                                # partly cloudy
  119|122|143|248|260) icon=CL ;;                                # cloudy / overcast / fog
  200|386|389|392|395) icon=ST ;;                                # storm
  179|182|185|227|230|281|284|311|314|317|320|323|326|329|332|335|338|350|362|365|368|371|374|377) icon=SN ;;  # snow / sleet / ice
  *) icon=RN ;;                                                  # rain / drizzle
esac
[ $day = 0 ] && case $icon in SU|PC|CL) icon=NT ;; esac        # clear or cloudy at night

echo "$j" | jq -c --arg icon "$icon" '.current_condition[0] as $c | (.nearest_area[0].areaName[0].value // "") as $a | {
  text: ($icon + " " + $c.temp_C + "C"),
  tooltip: "\($a)\n\($c.weatherDesc[0].value | rtrimstr(" "))\nFeels like \($c.FeelsLikeC)°C\nHumidity \($c.humidity)%\nWind \($c.windspeedKmph) km/h"
}'
