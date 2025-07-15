import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_state/provider/count_provider.dart';

class CountExample extends StatefulWidget {
  CountExample({super.key});

  @override
  State<CountExample> createState() => _CountExampleState();
}

class _CountExampleState extends State<CountExample> {
  @override
  Widget build(BuildContext context) {
    final countProvider = Provider.of<CountProvider>(context, listen: false);
    print("working?");
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Counter Example",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Consumer<CountProvider>(
            builder: (context, value, child) {
              return Text(
                countProvider.count.toString(),
                style: TextStyle(fontSize: 40),
              );
            },
          ),
          SizedBox(height: 200),
          Row(
            children: [
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  countProvider.increment();
                },
                child: Text("Increment"),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  countProvider.decrement();
                },
                child: Text("Decrement"),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  countProvider.reset();
                },
                child: Text("Reset"),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
