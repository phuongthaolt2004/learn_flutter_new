import 'package:flutter/material.dart';
import 'home_screen.dart';


class WelcomeScreen extends StatelessWidget {
 const WelcomeScreen({super.key});


 @override
 Widget build(BuildContext context) {
   return Scaffold(
     body: Padding(
       padding: const EdgeInsets.all(24),
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           const Spacer(),
           Image.asset('assets/images/to-do-list.webp', height: 250),
           const SizedBox(height: 32),
           const Text(
             'Get started',
             style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
           ),
           const Text('Create tasks · Set reminders · Track progress'),
           const Spacer(),
           ElevatedButton(
             onPressed: () {
               Navigator.pushReplacement(
                 context,
                 MaterialPageRoute(builder: (_) => const HomeScreen()),
               );
             },
             child: const Text('Start'),
           ),
           const SizedBox(height: 20),
         ],
       ),
     ),
   );
 }
}
