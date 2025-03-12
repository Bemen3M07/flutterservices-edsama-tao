
import 'package:empty/ejercicio_2/providers/counter_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  //int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(context.watch<CounterProvider>().counter.toString(), 
              style: const TextStyle(fontSize: 48)),
          ElevatedButton(
            onPressed: (){
              context.read<CounterProvider>().increment();
          }, 
          child: const Text("Sumar"))
        ],
      ), 
    );
  }
}