import 'exercise.dart';

class InfoExercice {
	int pause;
	int serie;

	InfoExercice({this.pause = 90, this.serie = 4});
}

class Training {
	String name = "";
	List<int> exercice = [];
	List<InfoExercice> infoExercice = [];

	//Training({this.name = "", this.exercice = const [], this.infoExercice = const []});
	Training({this.name = "", this.exercice = const []});
}
