import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ViewPage extends StatelessWidget {
  ViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            "Heart Tracker",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height - 150,
                  width: MediaQuery.of(context).size.width,
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 3 / 3,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 10),
                      itemCount: 5,
                      itemBuilder: (BuildContext ctx, index) {
                        return Container(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 120,
                                child: _buildDistanceTrackerExample(),
                              ),
                              Text(
                                "Cihaz 1 ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                              color: Color(0xffeeeeee),
                              borderRadius: BorderRadius.circular(15)),
                        );
                      }),
                ),
              ],
            ),
          ),
        ));
  }

  /// Returns the gauge distance tracker
  SfRadialGauge _buildDistanceTrackerExample() {
    return SfRadialGauge(
      enableLoadingAnimation: true,
      axes: <RadialAxis>[
        RadialAxis(
            showLabels: false,
            showTicks: false,
            radiusFactor: 0.8,
            minimum: 0,
            maximum: 200,
            axisLineStyle: const AxisLineStyle(
              cornerStyle: CornerStyle.startCurve,
              thickness: 6,
            ),
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  angle: 90,
                  positionFactor: 0,
                  widget: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                        child: Icon(
                          Icons.favorite,
                          color: Color(0xffd85755),
                        ),
                      ),
                      Text(
                        '40',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  )),
              GaugeAnnotation(
                angle: 120,
                positionFactor: 1.2,
                widget: Text(
                  '0',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              GaugeAnnotation(
                angle: 60,
                positionFactor: 1.2,
                widget: Text(
                  '240',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
            pointers: <GaugePointer>[
              const RangePointer(
                value: 142,
                width: 12,
                pointerOffset: -4,
                cornerStyle: CornerStyle.bothCurve,
                color: Color(0xFFF67280),
                gradient: SweepGradient(
                    colors: <Color>[Color(0xFFFF7676), Color(0xFFF54EA2)],
                    stops: <double>[0.25, 0.75]),
              ),
              MarkerPointer(
                value: 136,
                color: Colors.white,
                markerType: MarkerType.circle,
              ),
            ]),
      ],
    );
  }
}
