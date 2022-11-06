import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import '../data/training.dart';
import '../data/exercise.dart';

import './ptime.dart';

class PageTraining extends StatelessWidget {

	List<Exercice> exercice;
	Training training;

	PageTraining({super.key, required this.exercice, required this.training});

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Remen Work',
			theme: ThemeData(
				primarySwatch: Colors.blue,
			),
			home: SPageTraining(training: training, exercice: exercice),
		);
	}
}

class SPageTraining extends StatefulWidget {
	List<Exercice> exercice;
	final Training training;

	SPageTraining({super.key, required this.exercice, required this.training});

	@override
	State<SPageTraining> createState() => _SPageTrainingState();
}


class _SPageTrainingState extends State<SPageTraining> {

	int cIndexTraining = 0;
	int cSerieTraining = 0;

	TextEditingController v1 = TextEditingController();
	TextEditingController v2 = TextEditingController();

	@override
	void initState() {
		super.initState();
	}



	@override
	Widget build(BuildContext context) {
		final cExo = widget.exercice[widget.training.exercice[cIndexTraining]];
		final cInfo = widget.training.infoExercice[cIndexTraining];

		Widget getPerf = Container(height: 80);

		final buttonTime = TextButton(
			onPressed: () {
				
				Navigator.push(
					context,
					MaterialPageRoute(builder: (context) => PTime(time: cInfo.pause)),
				)..then((value) {
					print(value);

					if (value == 0) {
						cSerieTraining++;
						if (cSerieTraining == cInfo.serie) {
							cSerieTraining = 0;
							cIndexTraining++;
						}
					
						setState(() {});
					}

				});
			},
			child: Text("Next",
				style: TextStyle(
					fontSize: 18,
				),
			),

			style: ButtonStyle(
				side: MaterialStateProperty.all(
					BorderSide(width: 3, color: Colors.blue),
				),
				padding: MaterialStateProperty.all<EdgeInsets>(
					EdgeInsets.all(13),
				),
			),
		);

		if (cExo.perf == TypePerf.nb_rep_pdc) {
			if (cExo.valuePerf.length != 0) {
				v1.text = cExo.valuePerf[0][0].toString();
			} else {
				v1.text = "";
			}

			getPerf = Container(
				margin: const EdgeInsets.only(right: 10),
				child: Row(
					children: <Widget> [
						Spacer(),
						Container(
							margin: const EdgeInsets.only(left: 20, right: 20),
							width: 80,
							child: TextFormField(
								keyboardType: TextInputType.number,
								inputFormatters: [FilteringTextInputFormatter.digitsOnly],
								controller: v1,
								decoration: InputDecoration(
									labelText: "Repetition",
									border: OutlineInputBorder(
										borderSide: BorderSide(),
									),
									contentPadding:
										EdgeInsets.all(10),
								),
							),
						),
						Spacer(),
						buttonTime,
						Spacer(),
					],
				),
			);
		} else if (cExo.perf == TypePerf.nb_rep_weights) {
			if (cExo.valuePerf.length != 0) {
				v1.text = cExo.valuePerf[0][0].toString();
				v2.text = cExo.valuePerf[0][1].toString();
			} else {
				v1.text = "";
				v2.text = "";
			}

			getPerf = Container(
				margin: const EdgeInsets.only(right: 10),
				child: Row(
					children: <Widget> [
						Spacer(),
						Container(
							margin: const EdgeInsets.only(left: 20, right: 20),
							width: 80,
							child: TextFormField(
								keyboardType: TextInputType.number,
								inputFormatters: [FilteringTextInputFormatter.digitsOnly],
								controller: v1,
								decoration: InputDecoration(
									labelText: "Repetition",
									border: OutlineInputBorder(
										borderSide: BorderSide(),
									),
									contentPadding:
										EdgeInsets.all(10),
								),
							),
						),
						Container(
							margin: const EdgeInsets.only(left: 20, right: 20),
							width: 80,
							child: TextFormField(
								keyboardType: TextInputType.number,
								inputFormatters: [FilteringTextInputFormatter.digitsOnly],
								controller: v2,
								decoration: InputDecoration(
									labelText: "Weights",
									border: OutlineInputBorder(
										borderSide: BorderSide(),
									),
									contentPadding:
										EdgeInsets.all(10),
								),
							),
						),
						Spacer(),
						buttonTime,
						Spacer(),
					],
				),
			);
		} else if (cExo.perf == TypePerf.time) {
			getPerf = Container(
			);
		}

		return Scaffold(
			appBar: AppBar(
				title: Text(widget.training.name),
			),
			body: Column(
				children: <Widget> [
					SizedBox(height: 20),
					Container(
  						width: double.infinity,
						child: Text(cExo.name,
							textAlign: TextAlign.center,
							style: TextStyle(
								fontSize: 28,
								fontWeight: FontWeight.bold
							),
						),
					),
					Container(
  						width: double.infinity,
						margin: EdgeInsets.only(bottom: 20),
						child: Text("Series: ${cSerieTraining+1}/${cInfo.serie}",
							textAlign: TextAlign.center,
							style: TextStyle(
								fontSize: 16,
							),
						),
					),
					getPerf,
					SizedBox(height: 20),
					Container(
						margin: EdgeInsets.symmetric(horizontal: 40),
						child: ListView.builder(
							shrinkWrap: true,
							physics: const AlwaysScrollableScrollPhysics(),
							itemCount: (cExo.valuePerf.length + 1)*2 - 1,
							itemBuilder: (BuildContext context, int index) {
								if (index == 0) {
									return Row(
										children: <Widget> [
											const Text("Day"),
											Spacer(),
											const Text("Perfomence"),
											Spacer(),
											const Text("Serie"),
											Spacer(),
											const Text("Pause"),
										],
									);
								} else if (index%2 == 1) {
									return Divider(
										color: Colors.blue,
									);
								}

								var ui = cExo.valuePerf[cExo.valuePerf.length - ((index/2).round() - 1) - 1];
								String cPerf = "";
								int startI = 1;

								if (cExo.perf == TypePerf.nb_rep_pdc) {
									cPerf = ui[0].toString() + " rep";
								} else if (cExo.perf == TypePerf.nb_rep_weights) {
									cPerf = ui[0].toString() + "×" + ui[1].toString() + " kg";
									startI++;
								} else {
								}

								return Row(
									children: <Widget> [
										Text(ui[startI].toString()),
										Spacer(),
										Text(cPerf),
										Spacer(),
										Text(ui[startI + 1].toString() + "/" + ui[startI + 2].toString()),
										Spacer(),
										Text(ui[startI + 3].toString())
									]
								);
							},
						)
					),

					Spacer(),
					Container(
						margin: EdgeInsets.only(bottom: 20),
						child: Row(
							children: <Widget> [
								Spacer(),
								TextButton(
									onPressed: () {},
									child: const Text("Pass this series"),

									style: ButtonStyle(
										side: MaterialStateProperty.all(
											BorderSide(width: 3, color: Colors.blue),
										),
										padding: MaterialStateProperty.all<EdgeInsets>(
											EdgeInsets.all(13),
										),
									),
								),
								Spacer(),
								TextButton(
									onPressed: () {},
									child: const Text("Pass this exercice"),
								
									style: ButtonStyle(
										side: MaterialStateProperty.all(
											BorderSide(width: 3, color: Colors.blue),
										),
										padding: MaterialStateProperty.all<EdgeInsets>(
											EdgeInsets.all(13),
										),
									),
								),
								Spacer(),
							],
						),
					)
				],
			),
		);
	}

}
