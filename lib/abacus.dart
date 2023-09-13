import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class Abacus extends StatefulWidget {
  @override
  _AbacusState createState() => _AbacusState();
}

class _AbacusState extends State<Abacus> {
  List<double> _yPositions = [0.0, 0.0, 0.0, 0.0];
  List<double> _yPositions2 = [0.0, 0.0, 0.0, 0.0];
  List<double> _yPositions3 = [0.0, 0.0, 0.0, 0.0];
  List<double> _yPositions4 = [0.0, 0.0, 0.0, 0.0];
  List<double> _yPositions5 = [0.0, 0.0, 0.0, 0.0];
  List<double> _yPositions6 = [0.0, 0.0, 0.0, 0.0];
  List<double> _RPositions1 = [0.0];
  List<double> _RPositions2 = [0.0];
  List<double> _RPositions3 = [0.0];
  List<double> _RPositions4 = [0.0];
  List<double> _RPositions5 = [0.0];
  List<double> _RPositions6 = [0.0];
  List<double> _originalYPositions = [0.0, 0.0, 0.0, 0.0];
  List<double> _originalYPositions1 = [0.0];
  final double maxAllowedY = -30.0;
  final double maxAllowedY2 = 20.0;
  final double minAllowedY = 0.0;
  final int numberOfContainers = 4;
  void _resetContainers() {
    setState(() {
      _yPositions = List.from(_originalYPositions);
      _yPositions2 = List.from(_originalYPositions);
      _yPositions3 = List.from(_originalYPositions);
      _yPositions4 = List.from(_originalYPositions);
      _yPositions5 = List.from(_originalYPositions);
      _yPositions6 = List.from(_originalYPositions);
      _RPositions1  = List.from(_originalYPositions1);
      _RPositions2  = List.from(_originalYPositions1);
      _RPositions3  = List.from(_originalYPositions1);
      _RPositions4  = List.from(_originalYPositions1);
      _RPositions5  = List.from(_originalYPositions1);
      _RPositions6  = List.from(_originalYPositions1);
      FirebaseFirestore.instance
          .collection('positions') // اسم المجموعة في Firebase
          .doc('position1') // اسم الوثيقة في Firebase
          .update({'yPosition': 0});
      FirebaseFirestore.instance
          .collection('positions') // اسم المجموعة في Firebase
          .doc('position2') // اسم الوثيقة في Firebase
          .update({'yPosition': 0});
      FirebaseFirestore.instance
          .collection('positions') // اسم المجموعة في Firebase
          .doc('position3') // اسم الوثيقة في Firebase
          .update({'yPosition': 0});
      FirebaseFirestore.instance
          .collection('positions') // اسم المجموعة في Firebase
          .doc('position4') // اسم الوثيقة في Firebase
          .update({'yPosition': 0});
      FirebaseFirestore.instance
          .collection('positions') // اسم المجموعة في Firebase
          .doc('position5') // اسم الوثيقة في Firebase
          .update({'yPosition': 0});
      FirebaseFirestore.instance
          .collection('positions') // اسم المجموعة في Firebase
          .doc('position6') // اسم الوثيقة في Firebase
          .update({'yPosition': 0});
    });
  }
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('positions')
        .doc('position1')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        var newY = snapshot.data()?['yPosition'];
        setState(() {
          _RPositions1[0] = newY;
        });
      }
    });
    FirebaseFirestore.instance
        .collection('positions')
        .doc('position2')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        var newY = snapshot.data()?['yPosition'];
        setState(() {
          _RPositions2[0] = newY;
        });
      }
    });
    FirebaseFirestore.instance
        .collection('positions')
        .doc('position3')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        var newY = snapshot.data()?['yPosition'];
        setState(() {
          _RPositions3[0] = newY;
        });
      }
    });
    FirebaseFirestore.instance
        .collection('positions')
        .doc('position4')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        var newY = snapshot.data()?['yPosition'];
        setState(() {
          _RPositions4[0] = newY;
        });
      }
    });
    FirebaseFirestore.instance
        .collection('positions')
        .doc('position5')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        var newY = snapshot.data()?['yPosition'];
        setState(() {
          _RPositions5[0] = newY;
        });
      }
    });
    FirebaseFirestore.instance
        .collection('positions')
        .doc('position6')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        var newY = snapshot.data()?['yPosition'];
        setState(() {
          _RPositions6[0] = newY;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
    builder: (_ , child) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("الأباكوس"),
            backgroundColor: Theme
                .of(context)
                .primaryColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back), onPressed: () {
              Navigator.of(context).pop(context);
            },),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 20.sp,
                  width: 15.sp,
                  color: Colors.black87,
                  margin: EdgeInsets.only(left: 200.sp),
                  child: InkWell(
                    onTap: _resetContainers,
                    splashColor: Colors.blue,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.sp),
                  width: 500.sp,
                  height: 200.sp,
                  decoration: BoxDecoration(
                      border: Border.all(width: 10.sp, color: Colors.black87),
                      borderRadius: BorderRadius.all(Radius.circular(20.sp))
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onPanStart: (details) {},
                            onPanUpdate: (details) async {
                              double newY = _RPositions1[0].sp + details.delta.dy;
                              if (newY <= maxAllowedY2 && newY >= minAllowedY) {
                                setState(() {
                                  _RPositions1[0] = newY;
                                });
                                await FirebaseFirestore.instance
                                    .collection(
                                    'positions') // اسم المجموعة في Firebase
                                    .doc('position1') // اسم الوثيقة في Firebase
                                    .update({'yPosition': newY});
                              }
                            },
                            onPanEnd: (details) {},
                            child: Transform.translate(
                              offset: Offset(0.sp, _RPositions1[0].sp),
                              child: Container(
                                width: 35.sp,
                                height: 20.sp,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    border: Border.all(width: 1.sp),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(25.sp))
                                ),),),),
                          SizedBox(width: 20.sp,),
                          GestureDetector(
                            onPanStart: (details) {},
                            onPanUpdate: (details) async {
                              double newY = _RPositions2[0].sp + details.delta.dy.sp;
                              if (newY <= maxAllowedY2 && newY >= minAllowedY) {
                                setState(() {
                                  _RPositions2[0] = newY;
                                });
                                await FirebaseFirestore.instance
                                    .collection(
                                    'positions') // اسم المجموعة في Firebase
                                    .doc('position2') // اسم الوثيقة في Firebase
                                    .update({'yPosition': newY});
                              }
                            },
                            onPanEnd: (details) {},
                            child: Transform.translate(
                              offset: Offset(0.sp, _RPositions2[0].sp),
                              child: Container(
                                width: 35.sp,
                                height: 20.sp,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    border: Border.all(width: 1.sp),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(25.sp))
                                ),),),),
                          SizedBox(width: 20.sp,),
                          GestureDetector(
                            onPanStart: (details) {},
                            onPanUpdate: (details) async {
                              double newY = _RPositions3[0].sp + details.delta.dy.sp;
                              if (newY <= maxAllowedY2 && newY >= minAllowedY) {
                                setState(() {
                                  _RPositions3[0] = newY;
                                });
                                await FirebaseFirestore.instance
                                    .collection(
                                    'positions') // اسم المجموعة في Firebase
                                    .doc('position3') // اسم الوثيقة في Firebase
                                    .update({'yPosition': newY});
                              }
                            },
                            onPanEnd: (details) {},
                            child: Transform.translate(
                              offset: Offset(0.sp, _RPositions3[0].sp),
                              child: Container(
                                width: 35.sp,
                                height: 20.sp,
                                decoration: BoxDecoration(
                                    color: Colors.yellow,
                                    border: Border.all(width: 1.sp),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(25.sp))
                                ),),),),
                          SizedBox(width: 20.sp,),
                          GestureDetector(
                            onPanStart: (details) {},
                            onPanUpdate: (details) async {
                              double newY = _RPositions4[0].sp + details.delta.dy.sp;
                              if (newY <= maxAllowedY2 && newY >= minAllowedY) {
                                setState(() {
                                  _RPositions4[0] = newY;
                                });
                                await FirebaseFirestore.instance
                                    .collection(
                                    'positions') // اسم المجموعة في Firebase
                                    .doc('position4') // اسم الوثيقة في Firebase
                                    .update({'yPosition': newY});
                              }
                            },
                            onPanEnd: (details) {},
                            child: Transform.translate(
                              offset: Offset(0.sp, _RPositions4[0].sp),
                              child: Container(
                                width: 35.sp,
                                height: 20.sp,
                                decoration: BoxDecoration(
                                    color: Colors.deepPurpleAccent,
                                    border: Border.all(width: 1.sp),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(25.sp))
                                ),),),),
                          SizedBox(width: 20.sp,),
                          GestureDetector(
                            onPanStart: (details) {},
                            onPanUpdate: (details) async {
                              double newY = _RPositions5[0].sp + details.delta.dy.sp;
                              if (newY <= maxAllowedY2 && newY >= minAllowedY) {
                                setState(() {
                                  _RPositions5[0] = newY;
                                });
                                await FirebaseFirestore.instance
                                    .collection(
                                    'positions') // اسم المجموعة في Firebase
                                    .doc('position5') // اسم الوثيقة في Firebase
                                    .update({'yPosition': newY});
                              }
                            },
                            onPanEnd: (details) {},
                            child: Transform.translate(
                              offset: Offset(0.sp, _RPositions5[0].sp),
                              child: Container(
                                width: 35.sp,
                                height: 20.sp,
                                decoration: BoxDecoration(
                                    color: Colors.deepOrange,
                                    border: Border.all(width: 1.sp),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.sp))
                                ),),),),
                          SizedBox(width: 20.sp,),
                          GestureDetector(
                            onPanStart: (details) {},
                            onPanUpdate: (details) async {
                              double newY = _RPositions6[0].sp + details.delta.dy.sp;
                              if (newY <= maxAllowedY2 && newY >= minAllowedY) {
                                setState(() {
                                  _RPositions6[0] = newY;
                                });
                                await FirebaseFirestore.instance
                                    .collection(
                                    'positions') // اسم المجموعة في Firebase
                                    .doc('position6') // اسم الوثيقة في Firebase
                                    .update({'yPosition': newY});
                              }
                            },
                            onPanEnd: (details) {},
                            child: Transform.translate(
                              offset: Offset(0.sp, _RPositions6[0].sp),
                              child: Container(
                                width: 35.sp,
                                height: 20.sp,
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    border: Border.all(width: 1.sp),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(25.sp))
                                ),),),),
                        ],),
                      SizedBox(height: 20.sp,),
                      Divider(height: 10.sp, color: Colors.black87, thickness: 7.sp),
                      SizedBox(height: 30.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                                _yPositions.length, (index) {
                              return GestureDetector(
                                onPanStart: (details) {
                                  // You can update the state here if needed.
                                },
                                onPanUpdate: (details) {
                                  double newY = _yPositions[index].sp +
                                      details.delta.dy.sp;
                                  if (newY >= maxAllowedY &&
                                      newY <= minAllowedY) {
                                    setState(() {
                                      _yPositions[index] = newY;
                                    });

                                    // Move the containers above the current one if index is greater than 0.
                                    for (int i = index - 1; i >= 0; i--) {
                                      if (_yPositions[i] > newY) {
                                        setState(() {
                                          _yPositions[i] = newY;
                                        });
                                      }
                                    }

                                    // Move the containers below the current one if index is less than the last index.
                                    for (int i = index + 1; i <
                                        _yPositions.length; i++) {
                                      if (_yPositions[i] < newY) {
                                        setState(() {
                                          _yPositions[i] = newY;
                                        });
                                      }
                                    }
                                  }
                                },
                                onPanEnd: (details) {

                                },
                                child: Transform.translate(
                                  offset: Offset(0.sp, _yPositions[index].sp),
                                  child: Container(
                                    width: 35.sp,
                                    height: 20.sp,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        border: Border.all(width: 1.sp),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25.sp))
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                          SizedBox(width: 20.sp,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                                _yPositions2.length, (index) {
                              return GestureDetector(
                                onPanStart: (details) {
                                  // You can update the state here if needed.
                                },
                                onPanUpdate: (details) {
                                  double newY = _yPositions2[index].sp +
                                      details.delta.dy.sp;
                                  if (newY >= maxAllowedY &&
                                      newY <= minAllowedY) {
                                    setState(() {
                                      _yPositions2[index] = newY;
                                    });

                                    // Move the containers above the current one if index is greater than 0.
                                    for (int i = index - 1; i >= 0; i--) {
                                      if (_yPositions2[i] > newY) {
                                        setState(() {
                                          _yPositions2[i] = newY;
                                        });
                                      }
                                    }

                                    // Move the containers below the current one if index is less than the last index.
                                    for (int i = index + 1; i <
                                        _yPositions2.length; i++) {
                                      if (_yPositions2[i] < newY) {
                                        setState(() {
                                          _yPositions2[i] = newY;
                                        });
                                      }
                                    }
                                  }
                                },
                                onPanEnd: (details) {

                                },
                                child: Transform.translate(
                                  offset: Offset(0.sp, _yPositions2[index].sp),
                                  child: Container(
                                    width: 35.sp,
                                    height: 20.sp,
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        border: Border.all(width: 1.sp),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25.sp))
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                          SizedBox(width: 20.sp,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                                _yPositions3.length, (index) {
                              return GestureDetector(
                                onPanStart: (details) {
                                  // You can update the state here if needed.
                                },
                                onPanUpdate: (details) {
                                  double newY = _yPositions3[index].sp +
                                      details.delta.dy.sp;
                                  if (newY >= maxAllowedY &&
                                      newY <= minAllowedY) {
                                    setState(() {
                                      _yPositions3[index] = newY;
                                    });

                                    // Move the containers above the current one if index is greater than 0.
                                    for (int i = index - 1; i >= 0; i--) {
                                      if (_yPositions3[i] > newY) {
                                        setState(() {
                                          _yPositions3[i] = newY;
                                        });
                                      }
                                    }

                                    // Move the containers below the current one if index is less than the last index.
                                    for (int i = index + 1; i <
                                        _yPositions3.length; i++) {
                                      if (_yPositions3[i] < newY) {
                                        setState(() {
                                          _yPositions3[i] = newY;
                                        });
                                      }
                                    }
                                  }
                                },
                                onPanEnd: (details) {

                                },
                                child: Transform.translate(
                                  offset: Offset(0.sp, _yPositions3[index].sp),
                                  child: Container(
                                    width: 35.sp,
                                    height: 20.sp,
                                    decoration: BoxDecoration(
                                        color: Colors.yellow,
                                        border: Border.all(width: 1.sp),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25.sp))
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                          SizedBox(width: 20.sp,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                                _yPositions4.length, (index) {
                              return GestureDetector(
                                onPanStart: (details) {
                                  // You can update the state here if needed.
                                },
                                onPanUpdate: (details) {
                                  double newY = _yPositions4[index].sp +
                                      details.delta.dy.sp;
                                  if (newY >= maxAllowedY &&
                                      newY <= minAllowedY) {
                                    setState(() {
                                      _yPositions4[index] = newY;
                                    });

                                    // Move the containers above the current one if index is greater than 0.
                                    for (int i = index - 1; i >= 0; i--) {
                                      if (_yPositions4[i] > newY) {
                                        setState(() {
                                          _yPositions4[i] = newY;
                                        });
                                      }
                                    }

                                    // Move the containers below the current one if index is less than the last index.
                                    for (int i = index + 1; i <
                                        _yPositions4.length; i++) {
                                      if (_yPositions4[i] < newY) {
                                        setState(() {
                                          _yPositions4[i] = newY;
                                        });
                                      }
                                    }
                                  }
                                },
                                onPanEnd: (details) {

                                },
                                child: Transform.translate(
                                  offset: Offset(0.sp, _yPositions4[index].sp),
                                  child: Container(
                                    width: 35.sp,
                                    height: 20.sp,
                                    decoration: BoxDecoration(
                                        color: Colors.deepPurpleAccent,
                                        border: Border.all(width: 1.sp),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25.sp))
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                          SizedBox(width: 20.sp,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                                _yPositions5.length, (index) {
                              return GestureDetector(
                                onPanStart: (details) {
                                  // You can update the state here if needed.
                                },
                                onPanUpdate: (details) {
                                  double newY = _yPositions5[index].sp +
                                      details.delta.dy.sp;
                                  if (newY >= maxAllowedY &&
                                      newY <= minAllowedY) {
                                    setState(() {
                                      _yPositions5[index] = newY;
                                    });

                                    // Move the containers above the current one if index is greater than 0.
                                    for (int i = index - 1; i >= 0; i--) {
                                      if (_yPositions5[i] > newY) {
                                        setState(() {
                                          _yPositions5[i] = newY;
                                        });
                                      }
                                    }

                                    // Move the containers below the current one if index is less than the last index.
                                    for (int i = index + 1; i <
                                        _yPositions5.length; i++) {
                                      if (_yPositions5[i] < newY) {
                                        setState(() {
                                          _yPositions5[i] = newY;
                                        });
                                      }
                                    }
                                  }
                                },
                                onPanEnd: (details) {

                                },
                                child: Transform.translate(
                                  offset: Offset(0.sp, _yPositions5[index].sp),
                                  child: Container(
                                    width: 35.sp,
                                    height: 20.sp,
                                    decoration: BoxDecoration(
                                        color: Colors.deepOrange,
                                        border: Border.all(width: 1.sp),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25.sp))
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                          SizedBox(width: 20.sp,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                                _yPositions6.length, (index) {
                              return GestureDetector(
                                onPanStart: (details) {
                                  // You can update the state here if needed.
                                },
                                onPanUpdate: (details) {
                                  double newY = _yPositions6[index].sp +
                                      details.delta.dy.sp;
                                  if (newY >= maxAllowedY &&
                                      newY <= minAllowedY) {
                                    setState(() {
                                      _yPositions6[index] = newY;
                                    });

                                    // Move the containers above the current one if index is greater than 0.
                                    for (int i = index - 1; i >= 0; i--) {
                                      if (_yPositions6[i] > newY) {
                                        setState(() {
                                          _yPositions6[i] = newY;
                                        });
                                      }
                                    }

                                    // Move the containers below the current one if index is less than the last index.
                                    for (int i = index + 1; i <
                                        _yPositions6.length; i++) {
                                      if (_yPositions6[i] < newY) {
                                        setState(() {
                                          _yPositions6[i] = newY;
                                        });
                                      }
                                    }
                                  }
                                },
                                onPanEnd: (details) {

                                },
                                child: Transform.translate(
                                  offset: Offset(0.sp, _yPositions6[index].sp),
                                  child: Container(
                                    width: 35.sp,
                                    height: 20.sp,
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        border: Border.all(width: 1.sp),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25.sp))
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}



