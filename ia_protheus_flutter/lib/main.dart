import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ia_protheus/services/fast_api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IA Protheus',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black.withAlpha(130)),
      ),
      home: const MyHomePage(title: 'IA Protheus'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

TextEditingController _textController = TextEditingController();
List<Widget> listUpperScreen = [
      Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 50),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.android, size: 40, color: Colors.black.withAlpha(130),),
              SizedBox(
                width: 300,
                child: Text('Seja bem vindo a IA Protheus', 
                textAlign: TextAlign.center,
                style: 
                GoogleFonts.inter(
                  color: Colors.black.withAlpha(130),
                  fontSize: 22,
                  fontWeight: FontWeight.bold
                ),),
              ),
            ],
          ),
        ),
      )
    ];
    bool isIaReady = true;
    ScrollController _scrollController = ScrollController();
    String questionIa = '';

class _MyHomePageState extends State<MyHomePage> {
  @override
  void dispose() {
    _scrollController.dispose(); // Important for resource management
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var deviceData = MediaQuery.of(context);
    double height_screen = deviceData.size.height;
    double width_screen = deviceData.size.width;
    RagApiService _ragApiService = RagApiService();

    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        backgroundColor: Colors.white,
        title: Text(widget.title),
      ),
      drawer: Drawer(child: ListView(
          children: [
            ListTile(
              leading: Icon(
                Icons.chat,
                color: Colors.black.withAlpha(80),
              ),
              title: const Text('Conversas'),
              onTap: () {
              },
            ),],),),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withAlpha(60)
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: width_screen,
                height: height_screen * 0.7,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Center(
                    child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: listUpperScreen,)
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: width_screen,
                height: height_screen * 0.15,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                  boxShadow: [BoxShadow(
                    color: Colors.grey.withAlpha(130), // Shadow color
                    offset: const Offset(0, -5), // Negative dy for top shadow
                    blurRadius: 10, // Blur effect
                    spreadRadius: 2, // Spread of the shadow
                  ),],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: width_screen,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 12),
                        child: TextFormField(
                          maxLength: 300,
                          maxLines: 1,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Peça a IA Protheus',
                          ),
                          controller: _textController,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isIaReady = false;
                              });
                              if(listUpperScreen.length == 1) {
                                setState(() {
                                  listUpperScreen = [];
                                  listUpperScreen.add(Container());
                                });
                              }
                              setState(() {
                                listUpperScreen.add(
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Container(
                                      width: width_screen * 0.9,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15), bottomLeft: Radius.circular(15)),
                                        color: Colors.white,
                                        boxShadow: [BoxShadow(
                                          color: Colors.grey.withAlpha(130), // Shadow color
                                          offset: const Offset(0, 0), // Negative dy for top shadow
                                          blurRadius: 10, // Blur effect
                                          spreadRadius: 2, // Spread of the shadow
                                        ),],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          width: width_screen * 0.7,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: width_screen * 0.8,
                                                      child: Text(_textController.text,
                                                      style: GoogleFonts.inter(
                                                        color: Colors.black.withAlpha(180),
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                      ),),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text(hourOfMessage())
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ); 
                                questionIa = _textController.text;
                                _textController.text = ''; 
                              });
                              _ragApiService.sendQuestion(questionIa).then((value) {
                                listUpperScreen.add(
                                  Padding(padding: EdgeInsets.only(top: 30, left: 20, right: 20),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.android_rounded, size: 25,color: Colors.blueGrey,),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 12.0),
                                            child: Text('IA Protheus as ${hourOfMessage()}:',style: GoogleFonts.inter(
                                                  color: Colors.black.withAlpha(150),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 8),
                                        child: Divider(
                                          thickness: 1,
                                          color: Colors.black.withAlpha(150),
                                        ),
                                      ),
                                      Text(value,
                                                style: GoogleFonts.inter(
                                                  color: Colors.black.withAlpha(180),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),),
                                    ],
                                  ),),
                                );
                                setState(() {
                                    isIaReady = true;
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                                  });
                                });
                              },);
                            },
                            child: (isIaReady)
                            ? Icon(Icons.add, size: 30,)
                            : Text('Aguarde a IA...'),)
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

String hourOfMessage() {
  int initialHour = DateTime.now().hour;
  int initialMinute = DateTime.now().minute;
  String timeOfInitialMessage = '${(initialHour.toString().length==1)?'0$initialHour':initialHour}:'
                          '${(initialMinute.toString().length==1)?'0$initialMinute':initialMinute}';
  
  return timeOfInitialMessage;
}