import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:timer_builder/timer_builder.dart';

String timeToHumman(int time, int milli) {
	if (time > 60) {
		if (time > 600) {
			return (time ~/ 60).toString() + ":" + timeToHumman(time%60, milli);
		} else {
			return "0" + (time ~/ 60).toString() + ":" + timeToHumman(time%60, milli);
		}
	}
		
	if (time > 9) {
		return (time%60).toString() + "." + milli.toString() +  "s";
	}
		
	return "0" + (time%60).toString() + "." + milli.toString() +  "s";
}

class PTime extends StatefulWidget {
	int time;
	PTime({super.key, required this.time});

	@override
	State<PTime> createState() => _PTimeState();
}

class _PTimeState extends State<PTime> {
	int cTime = 0;
	int milli = 0;
	bool isSwitched = true;

	Future<void> launch() async {
		if (await Vibration.hasVibrator() ?? false) {
			Vibration.vibrate();
		}
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text("Wait ! Take a break"),
			),

			body: Column(
				children: <Widget> [
					SizedBox(height: 80),
	
					Container(
  						width: double.infinity,
						child: TimerBuilder.periodic(Duration(milliseconds: 100),
							builder: (context) {
								milli++;

								if (milli > 9) {
									milli = 0;
									cTime++;

									if (widget.time == cTime && isSwitched) {
										launch();
									}
								}

								return Text(timeToHumman(cTime, milli),//"${cTime}",
									textAlign: TextAlign.center,
									style: TextStyle(
										fontSize: 45,
										fontWeight: FontWeight.bold,
										color: cTime < widget.time ? Colors.black : Colors.blue,
									),
								);
							}
						),
					),
	
					Container(
  						width: double.infinity,
						child: Text("Time to wait : " + timeToHumman(widget.time, 0),
							textAlign: TextAlign.center,
							style: TextStyle(
								fontSize: 28,
								fontWeight: FontWeight.bold
							),
						),
					),

					Spacer(flex: 2),
					Row(
						children: <Widget> [
							Spacer(),
							Text("Vibrate when it's finished to wait: "),
							Switch(
								value: isSwitched,
								onChanged: (value) {
									setState(() {
										isSwitched = value;
									});
								}
							),
							Spacer(),
						]
					),
					Spacer(flex: 5),

					TextButton(
						child: const Text("Go !",
							style: TextStyle(
								fontSize: 20,
							),
						),
						onPressed: () {
							Navigator.of(context).pop(0);
						},

						style: ButtonStyle(
							side: MaterialStateProperty.all(
								BorderSide(width: 5, color: Colors.blue),
							),
							padding: MaterialStateProperty.all<EdgeInsets>(
								EdgeInsets.symmetric(vertical: 20, horizontal: 40),
							),
						),
					),

					SizedBox(height: 80),
					
				],
			),
		);
	}
}
