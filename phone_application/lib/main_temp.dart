import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

void handleBackPress() {
  print("Назад!");
}

void main() {
  runApp(const SomeFunction());
}

class SomeFunction extends StatelessWidget{
  const SomeFunction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return MaterialApp( //materialapp всегда один
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const[
                      InkWell(onTap: handleBackPress, child: const Icon(Icons.arrow_back_ios)),
                      IconButton(onPressed: handleBackPress, icon: const Icon(Icons.search_rounded, size: 30,)),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  const Text('Флюорография', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                  const SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  [
                      Container(
                        width: 150,
                        height: 220,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Color(0xB9F8CBFF)
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.face_4_sharp, size: 100,),
                            Text('Ольга Петрова',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.star_purple500_sharp, color: Colors.yellow, size: 19,),
                                Icon(Icons.star_purple500_sharp, color: Colors.yellow, size: 19,),
                                Icon(Icons.star_purple500_sharp, color: Colors.yellow, size: 19,),
                                Icon(Icons.star_purple500_sharp, color: Colors.yellow, size: 19,),
                                Icon(Icons.star_purple500_sharp, color: Colors.yellow, size: 19,),
                              ],
                            ), //stars
                            const Text('45 лет опыта работы', style: TextStyle(fontSize: 10),),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(onPressed: handleBackPress, icon: Icon(Icons.phone, size: 20,)),
                                IconButton(onPressed: handleBackPress, icon: Icon(Icons.message_sharp, size: 20,)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 150,
                        height: 220,
                        color: Colors.green,
                      ),
                    ],
                  ),

                ],
              )
          ),
        ),
        backgroundColor: Color(0xB9AFFFFF),
      ),
    );
  }
}







