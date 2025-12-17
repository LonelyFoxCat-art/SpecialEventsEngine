function Encounter_Create(Type, Enemy = [], Music = noone) {
    if (Type != ENCOUNTERTYPE.UNDERTALE && Type != ENCOUNTERTYPE.DELTARUNE) return -1;
    
    var EncounterSystem = StorageData.Invoke("Encounter");
    var idx = array_length(EncounterSystem.EncounterList);
    
    var encounter = {
		Type: Type,
        Enemy: Enemy,
		MenuDiglog: "* Test.",
		Music: Music,
		Quick: false,
		Fell: false,
		Soul: [40, 454]
    };
    
    array_push(EncounterSystem.EncounterList, encounter);
    
    return idx;
}