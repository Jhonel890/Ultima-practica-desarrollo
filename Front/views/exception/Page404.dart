import 'package:flutter/material.dart';

class Page404 extends StatefulWidget {
  const Page404({Key? key}) : super(key: key);

  @override
  _Page404State createState() => _Page404State();
}

class _Page404State extends State<Page404> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Page 404"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Page not found"),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Go back"),
            )
          ],
        ),
      ),
    );
  }
}
