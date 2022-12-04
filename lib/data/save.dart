import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'dart:core';

import 'exercise.dart';
import 'training.dart';


class DataUser {
	List<Exercice> m_exercice = [];
	List<Training> m_training = [];
	/**List<Exercice> m_exercice = [
		Exercice(name: "Bench press", perf: TypePerf.nb_rep_weights, valuePerf: [
			[12, 25, 0, 1, 4, 90],
			[13, 25, 0, 1, 4, 90],
			[13, 25, 0, 1, 4, 90],
			[13, 25, 0, 1, 4, 90],
			[14, 25, 0, 1, 4, 90],
			[18, 25, 0, 1, 4, 90],
		]),
		Exercice(name: "Lateral raising", perf: TypePerf.nb_rep_weights),
		Exercice(name: "Biceps curl", perf: TypePerf.nb_rep_weights),

		Exercice(name: "Crunch", perf: TypePerf.nb_rep_pdc),
		Exercice(name: "Bulgarian clefts", perf: TypePerf.nb_rep_weights),
		Exercice(name: "Calves", perf: TypePerf.nb_rep_pdc),

		Exercice(name: "Pull-ups", perf: TypePerf.nb_rep_pdc, valuePerf: [[10, 0, 1, 4, 90]]),

		Exercice(name: "Dips", perf: TypePerf.nb_rep_pdc),
		Exercice(name: "Australian pull-ups", perf: TypePerf.nb_rep_pdc),

		Exercice(name: "Push-ups", perf: TypePerf.nb_rep_pdc),

		Exercice(name: "Leg raise", perf: TypePerf.nb_rep_pdc),
		Exercice(name: "Sheathing", perf: TypePerf.time),
		Exercice(name: "Squats", perf: TypePerf.nb_rep_weights),

	];

	List<Training> m_training = [Training(
				name: "Full Body Maison",
				exercice: [0, 1, 2, 3, 4, 5, 6],
				infoExercice : [
					InfoExercice(),
					InfoExercice(),
					InfoExercice(),
					InfoExercice(),
					InfoExercice(),
					InfoExercice(),
					InfoExercice(),
				]
			),
			Training(
				name: "Full Body Street Workout",
				exercice: [6, 7, 8, 9, 10, 11, 12, 5],
				infoExercice : [
					InfoExercice(),
					InfoExercice(),
					InfoExercice(),
					InfoExercice(),
					InfoExercice(),
					InfoExercice(),
					InfoExercice(),
					InfoExercice(),
				]
			)
	];**/

	bool onlyOne = false;

	Future<void> getData() async {
		if (onlyOne) {
			return;
		}

		onlyOne = true;

		m_exercice.clear();
		m_training.clear();

		final prefs = await SharedPreferences.getInstance();

		const JsonDecoder decoder = JsonDecoder();

		var exo = decoder.convert(prefs.getString("exercice") ?? "[]");

		for (int i = 0; i < exo.length; i++) {
			print("${i + 1} / ${exo.length} ${exo[i]}");
			m_exercice.add(
					Exercice(name: exo[i]["name"].toString(),
						description: exo[i]["description"].toString(),
						perf: TypePerf.values[exo[i]["type"]],
						valuePerf: exo[i]["type_perf"],
				)
			);
		}

		var tra = decoder.convert(prefs.getString("training") ?? "[]");

		for (int i = 0; i < tra.length; i++) {
			print("${i + 1} / ${tra.length} ${tra[i]}");

			final List<int> exo_l = tra[i]["exercice"].cast<int>();//map((e) => e).toList();

			m_training.add(Training(name: tra[i]["name"], exercice: exo_l));

			for (int j = 0; j < tra[i]["info"].length; j++) {
				m_training[i].infoExercice.add(InfoExercice(pause: tra[i]["info"][j][0], serie: tra[i]["info"][j][1]));
			}
		}

		return;
	}


	Future<void> saveData(bool exo_save, bool tra_save) async {
		String jsonMakerExo = "[";

		if (exo_save) {
			for (int i = 0; i < m_exercice.length; i++) {
				jsonMakerExo += "{\"name\":\"" 		+ m_exercice[i].name 			+ "\",";
				jsonMakerExo +=  "\"description\":\"" 	+ m_exercice[i].description 		+ "\",";
				jsonMakerExo +=  "\"type\":" 		+ m_exercice[i].perf.index.toString()	+ ",";
				jsonMakerExo +=  "\"type_perf\":" 	+ m_exercice[i].valuePerf.toString();// + ",";

				if (i + 1 != m_exercice.length) {
					jsonMakerExo += "},";
				} else {
					jsonMakerExo += "}";
				}
			}

			jsonMakerExo += "]";
		}
		
		String jsonMakerTraining = "[";
		
		if (tra_save) {
			for (int i = 0; i < m_training.length; i++) {
				jsonMakerTraining += "{\"name\":\""	+ m_training[i].name 			+ "\",";
				jsonMakerTraining +=  "\"exercice\":"	+ m_training[i].exercice.toString()	+ ",";
				jsonMakerTraining +=  "\"info\":[";//	+ m_training[i].exercice.toString()

				for (int j = 0; j < m_training[i].infoExercice.length; j++) {
					jsonMakerTraining += "[" + m_training[i].infoExercice[j].pause.toString() + "," + 
							m_training[i].infoExercice[j].serie.toString() + "]";

					if (j + 1 != m_training[i].infoExercice.length) {
						jsonMakerTraining += ",";
					}
				}
						
				jsonMakerTraining += "]";
				
				if (i + 1 != m_training.length) {
					jsonMakerTraining += "},";
				} else {
					jsonMakerTraining += "}";
				}
			}
			
			jsonMakerTraining += "]";
		}

		if (exo_save || tra_save) {
			final prefs = await SharedPreferences.getInstance();

			if (exo_save) {
				await prefs.setString("exercice", jsonMakerExo);
			}

			if (tra_save) {
				await prefs.setString("training", jsonMakerTraining);
			}
		}
	}
}
