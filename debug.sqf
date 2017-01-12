diag_log "R3 POI Finder | Init";

private _mapName = worldName;
private _data = "";
private _mapCenter = getArray (ConfigFile >> "CfgWorlds" >> _mapName >> "centerPosition");
private _mapSize = 2000000;

{
    private _poiType = _x;
    private _mapLocations = nearestLocations [_mapCenter, [_x], _mapSize];
    diag_log format["R3 POI Finder | Number of %1 locations: %2.", _poiType, count _mapLocations];

    {
        private _singlePoiData = format['{"label":"%1","type":"%2","x":%3,"y":%4}',
            text _x,
            toLower _poiType,
            getPos _x select 0, 
            getPos _x select 1
        ];

        private _seperator = if (_data == "") then { "" } else { "," };
        _data = [[_data, _singlePoiData], _seperator] call CBA_fnc_join;

    } forEach _mapLocations;

} forEach ["Name","NameLocal","NameVillage","NameCity","NameCityCapital","Airport","NameMarine","Strategic","StrongPointArea"];

copyToClipboard _data; 

diag_log "R3 POI Finder | All locations found and saved to clipboard";

null = [] spawn {
    hint "Finished! The data is in your clipboard, paste it into the R3 tiler website!";
    sleep 5;
    call BIS_fnc_endMission;
};