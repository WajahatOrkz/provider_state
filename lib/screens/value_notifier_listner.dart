import 'package:flutter/material.dart';

class ValueNotifierListner extends StatelessWidget {
  ValueNotifierListner({super.key});

  @override
  Widget build(BuildContext context) {
    ValueNotifier<int> _count = ValueNotifier<int>(0);
    ValueNotifier<bool> toggle = ValueNotifier<bool>(false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Stateless Widget to Statefull Widget"),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 16),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          ValueListenableBuilder(
            valueListenable: toggle,
            builder: (context, value, child) {
              return TextFormField(
                obscureText: toggle.value,
                obscuringCharacter: "*",
                decoration: InputDecoration(
                  suffixIcon: InkWell(
                    onTap: () {
                      toggle.value = !toggle.value;
                    },
                    child: Icon(
                      toggle.value ? Icons.visibility_off : Icons.visibility,
                      color: Colors.green,
                    ),
                  ),
                  hintText: "Enter ypur password",
                ),
              );
            },
          ),
          SizedBox(height: 20),

          ValueListenableBuilder(
            valueListenable: _count,
            builder: (context, value, child) {
              return Center(
                child: Text(
                  _count.value.toString(),
                  style: TextStyle(fontSize: 30),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _count.value++;
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
