import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(
              title: '首页',
            ),
        '/nativeFunction': (context) => const NativeFuncTestPage(),
        // Define more routes here
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class PageItem {
  String title;
  String routerName;

  PageItem({required this.title, required this.routerName});
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  final List<PageItem> pages = [
    PageItem(
        title: 'Platform Channel-MethodChannel', routerName: "/nativeFunction"),
    PageItem(
        title: 'Platform Channel-EventChannel', routerName: "/nativeFunction"),
    PageItem(
        title: 'Platform Channel-BasicMessageChannel',
        routerName: "/nativeFunction"),
    PageItem(title: 'Platform View Flutter嵌入原生', routerName: "/nativeFunction"),
  ];

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: pages.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(pages[index].title),
            onTap: () {
              Navigator.pushNamed(context, pages[index].routerName);
            },
          );
        },
      ),
    );
  }
}

class NativeFuncTestPage extends StatefulWidget {
  const NativeFuncTestPage({super.key});

  @override
  State<NativeFuncTestPage> createState() => _NativeFuncTestPageState();
}

class _NativeFuncTestPageState extends State<NativeFuncTestPage> {
  String nativeData = 'Flutter初始数据'; // Add a variable to store the native data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Platform Channel-MethodChannel'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                nativeData, // Use the variable to display the native data
              ),
              TextButton(
                onPressed: () async {
                  String? data = await NativeBridge.getNativeData();
                  setState(() {
                    nativeData = data ??
                        ''; // Update the variable with the returned data
                  });
                },
                child: const Text('获取原生数据'),
              ),
            ],
          ),
        ));
  }
}

class NativeBridge {
  static const MethodChannel _channel = MethodChannel('com.example/native');

  static Future<String?> getNativeData() async {
    final String? data = await _channel.invokeMethod('getNativeData');
    print("返回的值为$data");
    return data;
  }
}
