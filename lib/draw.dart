import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:flutter/services.dart';
class DrawingPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return DrawingPageState();
  }
}

class DrawingPageState extends State<DrawingPage>{
  ByteData _img = ByteData(0);
  var color = Colors.red;
  var strokeWidth = 5.0;
  final _sign = GlobalKey<SignatureState>();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("لوح الرسم"),
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(icon :const Icon(Icons.arrow_back), onPressed: () {
            Navigator.of(context).pop(context);
          },),
          /*actions: [
                IconButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchManagment(widget.userinfo)));
                },
                  icon: const Icon(FontAwesomeIcons.magnifyingGlass),),
              ],*/
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Signature(
                    color: color,
                    key: _sign,
                    onSign: () {
                      final sign = _sign.currentState;
                      debugPrint('${sign?.points.length} points in the signature');
                    },
                    backgroundPainter: _WatermarkPaint("2.0", "2.0"),
                    strokeWidth: strokeWidth,
                  ),
                ),
                color: Colors.black12,
              ),
            ),
            _img.buffer.lengthInBytes == 0 ? Container() : LimitedBox(maxHeight: 200.0, child: Image.memory(_img.buffer.asUint8List())),
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                        color: Colors.green,
                        onPressed: () async {
                          final sign = _sign.currentState;
                          //retrieve image data, do whatever you want with it (send to server, save locally...)
                          final image = await sign?.getData();
                          var data = await image?.toByteData(format: ui.ImageByteFormat.png);
                          sign?.clear();
                          final encoded = base64.encode(data?.buffer.asUint8List() as List<int>);
                          setState(() {
                            _img = data!;
                          });
                          debugPrint("onPressed " + encoded);
                        },
                        child: Text("حفظ")),
                    SizedBox(width: 20,),
                    MaterialButton(
                        color: Colors.grey,
                        onPressed: () {
                          final sign = _sign.currentState;
                          sign?.clear();
                          setState(() {
                            _img = ByteData(0);
                          });
                          debugPrint("تم المحي");
                        },
                        child: Text("محي")),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MaterialButton(
                        onPressed: () {
                          setState(() {
                            color = color == Colors.green ? Colors.red : Colors.green;
                          });
                          debugPrint("تغيير اللون");
                        },
                        child: Text("تغيير اللون")),

                    MaterialButton(
                        onPressed: () {
                          setState(() {
                            int min = 1;
                            int max = 10;
                            num selection = min + (Random().nextInt(max - min));
                            strokeWidth = selection.roundToDouble();
                            debugPrint("change stroke width to $selection");
                          });
                        },
                        child: Text("تغيير عرض الخط")),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
class _WatermarkPaint extends CustomPainter {
  final String price;
  final String watermark;

  _WatermarkPaint(this.price, this.watermark);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 10.8, Paint()..color = Colors.blue);
  }

  @override
  bool shouldRepaint(_WatermarkPaint oldDelegate) {
    return oldDelegate != this;
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is _WatermarkPaint && runtimeType == other.runtimeType && price == other.price && watermark == other.watermark;

  @override
  int get hashCode => price.hashCode ^ watermark.hashCode;
}