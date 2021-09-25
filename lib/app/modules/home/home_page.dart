import 'package:connectivity_service/app/core/services/connectivity/connectivity_impl/connectivity_service_impl.dart';
import 'package:connectivity_service/app/core/services/connectivity/connectivity_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  late final Future<ConnectivityService> _connectivityServiceFuture;
  ConnectivityService? _connectivityService;

  @override
  void initState() {
    super.initState();
    _connectivityServiceFuture = ConnectivityServiceImpl.getInstance();
  }

  @override
  void dispose() {
    _connectivityService?.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            FutureBuilder(
                future: _connectivityServiceFuture,
                builder: (context, AsyncSnapshot<ConnectivityService> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator.adaptive();
                  }
                  _connectivityService = snapshot.data!;
                  final hasConnection = _connectivityService!.hasConnection;
                  return ValueListenableBuilder<bool>(
                    valueListenable: hasConnection,
                    builder: (context, hasConnection, child) {
                      return ElevatedButton.icon(
                        onPressed: hasConnection
                            ? () async {
                                debugPrint('Habemus conexão! 😎');
                              }
                            : () async {
                                debugPrint('F, sem conexão! 🤪');
                              },
                        icon: hasConnection ? const Icon(Icons.web) : const Icon(Icons.web_asset_off),
                        label: hasConnection ? const Text('Habemus conexão! 😎') : const Text('F, sem conexão! 🤪'),
                        style: ElevatedButton.styleFrom(primary: hasConnection ? Colors.green : Colors.red),
                      );
                    },
                  );
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
