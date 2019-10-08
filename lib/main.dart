import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Card extends StatelessWidget {
  Color _color = Color.fromARGB(255, 0, 0, 0);

  Card(){
    Random rand = new Random();
    _color = Color.fromARGB(255, rand.nextInt(255), rand.nextInt(255), rand.nextInt(255));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _color,
      width: 200,
      height: 320,
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {

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

      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: DraggableCardStack()
      ),
    );
  }

}

class DraggableCardStack extends StatefulWidget {
  List<Widget> _cards = [];
  Widget _widgetWhenEmpty = Container();
  List<Object> _cardData = [];

  DraggableCardStack(){
    addCardAtBottom(Card(), 0);
  }

  void addCardAtBottom(Widget card, cardData){
    _cards.insert(0, card);
    _cardData.insert(0, cardData);
  }

  void removeTopCard(){
    _cards.removeLast();
    _cardData.removeLast();
  }

  void setEmptyWidget(Widget widget){
    _widgetWhenEmpty = widget;
  }

  @override
  _DraggableCardStackState createState() => _DraggableCardStackState();
}

class _DraggableCardStackState extends State<DraggableCardStack> {
  Offset _dragStartPosition = Offset(0.0, 0.0);
  Offset _topCardPosition = Offset(0.0, 0.0);

  void _onSwipeRight(){
    setState(() {
      _dragStartPosition = Offset(0.0, 0.0);
      _topCardPosition = Offset(0.0, 0.0);
      widget.removeTopCard();
    });
  }

  void _onSwipeLeft(){
    setState(() {
      _dragStartPosition = Offset(0.0, 0.0);
      _topCardPosition = Offset(0.0, 0.0);
      widget.removeTopCard();
    });
  }
  @override
  Widget build(BuildContext context) {

    List<Widget> children = [];

    children.add(widget._widgetWhenEmpty);
    for(int i = 0; i < widget._cards.length; i++){
      if(i == widget._cards.length-1){
        Size size = MediaQuery.of(context).size;

        children.add(GestureDetector(
            onPanStart: (details){

              _dragStartPosition = details.globalPosition;
            },
            onPanUpdate: (details){
              setState(() {
                _topCardPosition = details.globalPosition;

              });
            },

            onPanEnd: (details){
              Offset movedOffset = _dragStartPosition - _topCardPosition;
              if(movedOffset.dx/size.width > 0.2){
                print('hier');
                _onSwipeRight();
              }else if(movedOffset.dx/size.width < -0.2){
                _onSwipeLeft();
              }else{
                print('back');
                setState(() {
                  _dragStartPosition = Offset(0.0, 0.0);
                  _topCardPosition = Offset(0.0, 0.0);
                });
              }

            },

            child: Transform(
              origin: _dragStartPosition,
              transform: Matrix4.translationValues(_topCardPosition.dx - _dragStartPosition.dx, _topCardPosition.dy - _dragStartPosition.dy, 0),
              child: widget._cards[i],
            ),
          )
        );
      }else{
        children.add(widget._cards[i]);
      }
    }

    return Stack(
      alignment: Alignment.center,
      children: children,
    );
  }
}
