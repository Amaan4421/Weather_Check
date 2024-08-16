import 'package:flutter/material.dart';

class AddCityScreen extends StatefulWidget {
  
  final Function(String) onCityAdded;

  const AddCityScreen({super.key, required this.onCityAdded});

  @override
  // ignore: library_private_types_in_public_api
  _AddCityScreenState createState() => _AddCityScreenState();
}

class _AddCityScreenState extends State<AddCityScreen> {

  final TextEditingController newCityName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add City',
          style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
          ),
        backgroundColor: const Color.fromARGB(255, 39, 116, 107),
      ),
      backgroundColor: const Color.fromARGB(255, 153, 250, 233),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Which city you want to add?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 142, 200, 204).withOpacity(0.7),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: newCityName,
                decoration: InputDecoration(
                hintText: 'Enter City Name Here...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  filled: true,
                  fillColor: Colors.transparent,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                  isDense: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final cityName = newCityName.text.trim();
                if (cityName.isNotEmpty) {
                  widget.onCityAdded(cityName);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 39, 116, 107),
              ),
              child: const Text(
                'Add City',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
