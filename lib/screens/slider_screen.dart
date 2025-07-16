import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_state/provider/slider_provider.dart';

class SliderScreen extends StatefulWidget {
  const SliderScreen({super.key});

  @override
  State<SliderScreen> createState() => _SliderScreenState();
}

class _SliderScreenState extends State<SliderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Slider Screen"),
        titleTextStyle: TextStyle(fontSize: 20, color: Colors.white),
        backgroundColor: Colors.green,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Consumer<SliderProvider>(
            builder: (context, value, child) {
              return Slider(
                min: 0,
                max: 1,
                value: value.opacity,
                onChanged: (val) {
                  value.setSlider(val);
                },
              );
            },
          ),

          SizedBox(height: 20),
          Consumer<SliderProvider>(
            builder: (context, value, child) {
              return Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(value.opacity),
                      ),
                      child: Center(
                        child: Text(
                          "Imran ",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(value.opacity),
                      ),
                      child: Center(
                        child: Text(
                          "Khan",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
