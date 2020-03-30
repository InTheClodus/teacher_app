import 'package:flutter/material.dart';

class DietCardItem extends StatelessWidget {
  final String Img;
  final String DietName;
  final String DietTitle;
  final int index;
  DietCardItem(this.Img, this.DietName, this.DietTitle,this.index);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
      child: Column(
        children: <Widget>[
          Container(
            width: 160,
            height: 180,
            child: Image.network(
              Img,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            height: 45,
            color: Colors.black12,
            child: Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      width: 120,
                      child: Text(
                        DietName,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      width: 120,
                      child: Text(
                        DietTitle,
                        // 显示不完，就在后面显示点点
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius:
                        BorderRadius.circular(
                            10.0), //邊框
                      ),
                      width: 40,
                      child:index==0?Text(
                        "默认",
                        style: TextStyle(fontSize: 15),
                        textAlign: TextAlign.center,
                      ):null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
