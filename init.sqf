
diag_log "R3 POI Finder | init";

mapName = worldName;
filePath = format["%1_poi.json", mapName];
data = "";
mountCount = 0;
poiTotalMounts = 0;

[] spawn {
    waitUntil {sleep 1; !isNull player && alive player};

    hint "Now Searching for POI, this will take a while...";

    mapCenter = getArray (ConfigFile >> "CfgWorlds" >> mapName >> "centerPosition");
    mapSize = 2000000;
    mapElevOffset = getElevationOffset;

    //mapSize = mapSize / 2;
    //diag_log format["5R-Location Finder | Map Size (Halved): %1.",mapSize];

    heightTester = createVehicle ["Box_East_Ammo_F",getPos player,[],0,"NONE"];

    {
        poiType = _x;
        loggedPOIMounts = [];

        mapLocations = nearestLocations [mapCenter,[_x],mapSize];

        if(poiType == "Mount") then {
            poiTotalMounts = count mapLocations;
        };

        diag_log format["R3 POI Finder | Number of %1 locations: %2.", poiType, count mapLocations];

        {
            ignorePOI = FALSE;

            poiLabel = text _x;

            if (mountCount % 10 == 0) then {
                hintSilent format["Still working on it... %1/%2 (check map)", mountCount, poiTotalMounts];
            };

            // We don't want thousands of height markers, make sure there is at least 50m distance between them all
            if(poiType == "Mount") then {

                mountCount = mountCount + 1;

                currentPOI = _x;
                {
                    if((getPos currentPOI) distance (getPos _x) < 50) exitWith {ignorePOI = TRUE};
                } forEach loggedPOIMounts;

                heightTester setPos getPos _x;

                private _debugMarker = createMarker [format["Marker%1", mountCount], getPos heightTester];
                _debugMarker setMarkerShape "ICON";
                _debugMarker setMarkerType "hd_dot";
                _debugMarker setMarkerText format["%1", mountCount];

                sleep 0.05;

                poiLabel = round ((getPosASL heightTester) select 2);

                if(mapElevOffset > 0) then {
                    poiLabel = mapElevOffset + poiLabel;
                };
            };

            if(poiType == "Hill" && text _x == "") then {

                heightTester setPos getPos _x;

                sleep 0.05;

                poiLabel = round ((getPosASL heightTester) select 2);

                if(mapElevOffset > 0) then {
                    poiLabel = mapElevOffset + poiLabel;
                };
            };

            if!(ignorePOI) then {

                if (poiType == "Mount") then {
                    loggedPOIMounts pushback _x;
                };

                private _singlePoiData = format['{ "label": "%1", "type": "%2", "x": %3, "y": %4 }',
                    poiLabel,
                    toLower poiType,
                    getPos _x select 0, 
                    getPos _x select 1
                ];

                // We don't want leading commas in our JSON
                private _seperator = if (data == "") then { "" } else { ",\n" };

                // Combine this unit's data with our current running movements data
                data = [[data, _singlePoiData], _seperator] call CBA_fnc_join;

            }
        } forEach mapLocations;
    } forEach ["Name","NameLocal","NameVillage","NameCity","NameCityCapital","Airport","NameMarine","Strategic","StrongPointArea","RockArea","Mount"];
    
    "make_file" callExtension (filePath + "|[" + data + "]"); 

    diag_log format["R3 POI Finder | All locations found and saved to Arma directory -> %1", filePath];

    hint format["Finished! Look for %1 in your Arma directory", filePath];
    sleep 5;

    call BIS_fnc_endMission;
};