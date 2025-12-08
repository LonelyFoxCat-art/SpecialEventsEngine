function Encounter_Invoke(id, Name, Value = undefined){
	var Encounter = global.structure.Invoke("Encounter");
	if (id < 0 && id > array_length(Encounter.EncounterList)) return false;
	var EncounterDate = Encounter.EncounterList[id];
	
	if (is_undefined(Value)) return EncounterDate[$ Name];
	
	EncounterDate[$ Name] = Value;
	return true;
}