import 'package:flutter/material.dart';

class ExpandedHomeCard extends StatelessWidget {
  final String title;
  final String description;
  final String trailImageUrl;
  final VoidCallback onTap;

  ExpandedHomeCard({
    @required this.title,
    @required this.description,
    @required this.trailImageUrl,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // child: Padding(
        // padding: const EdgeInsets.all(6.0),
        child: Container(
          padding: EdgeInsets.all(6.0),
          child: FittedBox(
            child: Material(
              color: Colors.white,
              elevation: 16.0,
              borderRadius: BorderRadius.circular(24.0),
              shadowColor: Colors.grey[900],
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                onTap: onTap,
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(8.0),
                      width: 200,
                      height: 290,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Container(
                                  child: Text(
                                this.title,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold),
                              )),
                            ),
                            Container(
                                child: Text(
                              this.description,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            )),
                          ],
                        ),
                    ),
                    Container(
                      width: 250,
                      height: 200,
//                      color: Colors.black,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.asset(this.trailImageUrl),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      // ),
    );
  }
}
