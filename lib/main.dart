import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'data/training.dart';
import 'data/exercise.dart';

import 'exo/ptraining.dart';

void main() {
	runApp(const MyApp());
}

class MyApp extends StatelessWidget {
	const MyApp({super.key});

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Remen Work',
			theme: ThemeData(
				primarySwatch: Colors.blue,
			),
			home: const MyHomePage(title: 'Choose your training program'),
		);
	}
}

class MyHomePage extends StatefulWidget {
	const MyHomePage({super.key, required this.title});

	final String title;

	@override
	State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
	
	List<Exercice> m_exercice = [
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
	];


	List<int> m_selectedTraining = [];


	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				leading: m_selectedTraining.length == 0 ? Container(width: 0)
				: IconButton(
					icon: Icon(Icons.arrow_back),
					onPressed: () {
						m_selectedTraining.clear();
						setState(() {});
					},
				),

				title: Text(
					m_selectedTraining.length < 1 ? widget.title
					: "${m_selectedTraining.length} training selected",
				),

				actions: <Widget> [
					m_selectedTraining.length == 0 ? Container()
					: IconButton(
				      		icon: Icon(Icons.delete),
				      		onPressed: () {
							print("Remove !!");
						},
				  	),
				]
			),
			body: (m_training.length == 0) ?
				Center(
					child: Text(
						"You have no training plan, you can add one",
						textAlign: TextAlign.center,
						style: TextStyle(fontSize: 18),
					)
				)
			: ListView.builder(
				itemCount: m_training.length,
				itemBuilder: (context, index) {
					String subtitle = "";

					for (int i = 0; i < m_training[index].exercice.length - 1; ++i) {
						subtitle += m_exercice[m_training[index].exercice[i]].name + ", ";
					}

					subtitle += m_exercice[
						m_training[index].exercice[m_training[index].exercice.length - 1]
					].name;

					return GestureDetector(
						onLongPress: () {
							if (m_selectedTraining.indexOf(index) == -1) {
								m_selectedTraining.add(index);
							} else {
								m_selectedTraining.remove(index);
							}

							setState(() {});
						},
						onTap: (){
							if (m_selectedTraining.length != 0) {
								if (m_selectedTraining.indexOf(index) == -1) {
									m_selectedTraining.add(index);
								} else {
									m_selectedTraining.remove(index);
								}
							
								setState(() {});
							} else {
						runApp(PageTraining(training: m_training[index], exercice: m_exercice)); 
							}

							print(index);
						},
						child: Opacity(
							opacity: m_selectedTraining.indexOf(index) == -1 ? 1 : 0.5,
							child: Card(
								elevation: 6,
								margin: const EdgeInsets.all(10),
								child: ListTile(
									leading: CircleAvatar(
										backgroundColor: Colors.blue,
										child: const Icon(Icons.sports_martial_arts),
									),
									title: Text(m_training[index].name),
									subtitle: Text(subtitle),
								)
							)
						)
					);
				}
			),
			
			floatingActionButton: FloatingActionButton(
				onPressed: () {},
				tooltip: 'Add new Training',
				child: const Icon(Icons.add),
			), // This trailing comma makes auto-formatting nicer for build methods.
		);
	}
}
