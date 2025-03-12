
import 'package:empty/ejercicio_2/providers/counter_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Page3 extends StatefulWidget {
  const Page3({super.key});

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(context.watch<CounterProvider>().counter.toString(), 
          style: const TextStyle(fontSize: 50))
    );
  }
}