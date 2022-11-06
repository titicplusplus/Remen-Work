
enum TypePerf {
	nb_rep_pdc,
	nb_rep_weights,
	time,
	none,
}

class Exercice {
	String name = "";
	String description = "";

	TypePerf perf = TypePerf.none;
		
	var valuePerf = [];
	// [ [v1, v2, nbrDay, nbrSerie, nbrMax, repos] ]

	Exercice({required this.name, this.description = "",
		required this.perf, this.valuePerf = const []});
}
