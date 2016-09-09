# Arma 3 After Action Replay *POI Finder* Component

Export POI for Arma 3 maps

This is used for adding your own maps to the R3 [web component](https://github.com/alexcroox/R3).

### Usage

1. Download `@R3_Poi_Export` and place the folder in your mods folder (usually the root of your Arma directory)
2. Add `@R3_Poi_Export` to your list of mods to launch Arma with
3. Create a new mission on your desired map, place a single unit and save
4. Place the `init.sqf` from this repo into the new mission folder, next to `mission.sqm`
5. Click `Play Scenario` in the editor
6. Wait for the export script to run, you can check the map for debug progress, the mission will end when it has finished
7. Look for the generated `mapname.json` file in the root of your Arma directory
8. Coming soon...