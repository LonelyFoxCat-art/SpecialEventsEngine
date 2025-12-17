function Encounter_Create(Enemy = [], Music = noone, PauseMusic = false) {
    var EncounterSystem = StorageData.Invoke("Encounter");
    var idx = array_length(EncounterSystem.EncounterList);
    
    var encounter = {
		Type: ENCOUNTERTYPE.UNDERTALE,
        Enemy: Enemy,
		MenuDiglog: "* Test.",
		Music: Music,
		PauseMusic: PauseMusic,
		Quick: false,
		Fell: false,
		Soul: [40, 454]
    };
    
    array_push(EncounterSystem.EncounterList, encounter);
    
    return idx;
}