import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';

class RatingWidget extends StatefulWidget {
  double rating = 0;

  @override
  State<StatefulWidget> createState() {
    return _RatingWidgetState();
  }
}

class _RatingWidgetState extends State<RatingWidget> {
  @override
  Widget build(BuildContext context) {
    return ratingView();
  }

  Widget ratingView() {
    return Positioned.fill(
      child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 460,
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 80),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                    child: Container(
                      height: 380,
                      color: Colors.orange,
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment.topCenter,
                    child: Column(children: [
                      Card(
                        shape: CircleBorder(),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage:
                              ExactAssetImage('assets/images/Sagnik.jpg'),
                          minRadius: 70,
                          maxRadius: 70,
                        ),
                        elevation: 30,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Sagnik Ghosh',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: StarRating(
                          size: 55.0,
                          rating: widget.rating,
                          color: Colors.white,
                          borderColor: Colors.white,
                          starCount: 5,
                          onRatingChanged: (rating) => setState(
                            () {
                              widget.rating = rating;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 50, right: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Pick up time",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            Text("10.00 PM")
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 50, right: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Delivery Time",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            Text("10.30 PM")
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 50, right: 50),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text("Total",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("\$30.00",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            new GestureDetector(
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(40, 5, 20, 5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.horizontal(
                                        left: Radius.circular(30))),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      "Submit",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800),
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Icon(Icons.arrow_forward)
                                  ],
                                ),
                              ),
                              onTap: () {},
                            )
                          ],
                        ),
                      ),
                    ])),
              ],
            ),
          )),
    );
  }
}
