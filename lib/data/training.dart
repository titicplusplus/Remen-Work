import 'exercise.dart';

class InfoExercice {
	final int pause;
	final int serie;

	const InfoExercice({this.pause = 90, this.serie = 4});
}

class Training {
	String name = "";
	List<int> exercice = [];
	List<InfoExercice> infoExercice = [];

	Training({this.name = "", this.exercice = const [], this.infoExercice = const []});
}
