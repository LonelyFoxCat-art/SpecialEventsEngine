function Encounter_InvokeID(id = undefined){
	var Encounter = global.structure.Invoke("Encounter");
	
	if (is_undefined(id)) return Encounter.Encounter;
	
	Encounter.Encounter = id;
	
	return true;
}