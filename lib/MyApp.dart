import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Flutter Demo",
      initialRoute: "/", // 名为“/”的路由作为应用的home（首页）
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {//在此，根据笔者经验，建议读者最好统一使用命名路由的管理方式，这将会带来如下好处：
        "/": (context) => MyHomePage(
              title: "Flutter Demo Home Page",
            ), //注册首页路由
        "new_page": (context) => NewRoute(), //不带参数的路由
        "new_page_1": (context) => EchoRoute(),
        "tips": (context) {
          return TipRoute(text: ModalRoute.of(context).settings.arguments);
        }
      },
      onGenerateRoute: (RouteSettings settings){ //注意，onGenerateRoute只会对命名路由生效。
        return MaterialPageRoute(builder: (context){
          String routeName = settings.name;
          //如果访问的路由页需要登录，但当前未登录，则直接返回登录页路由，
          //引导用户登录；其他情况则正常打开路由
        });
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class EchoRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //获取路由参数
    var args = ModalRoute.of(context).settings.arguments;
    return null;
  }
}

class NewRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New route"),
      ),
      body: Center(
        child: Text("This is new route"),
      ),
    );
  }
}

class TipRoute extends StatelessWidget {
  TipRoute({
    Key key,
    @required this.text, //接收一个text参数
  }) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('提示'),
      ),
      body: Padding(
        padding: EdgeInsets.all(18),
        child: Center(
          child: Column(
            children: <Widget>[
              Text(text),
              RaisedButton(
                onPressed: () => Navigator.pop(context, "我是返回值"),
                child: Text("返回"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RouterTestRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        onPressed: () async {
          //打开 ‘TipRoute’,并等待返回结果
          var result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                //路由参数
                return TipRoute(text: "我是提示xxxx");
              },
            ),
          );
          print("路由返回值：$result");
        },
        child: Text("打开提示页"),
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
            FlatButton(
              child: Text("open new route"),
              textColor: Colors.blue,
              onPressed: () {
                //导航到新路由
                //1.0不通过路由表
//                Navigator.push(context, MaterialPageRoute(builder: (context) {
//                  return NewRoute();
//                }));
                //2.0 通过路由表
                Navigator.pushNamed(context, "new_page");
                //3.0通过路由表，带参数
                Navigator.of(context).pushNamed("new_page", arguments: "hi");
              },
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}
