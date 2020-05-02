import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[600],
      body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ExpandedHomeCard(
                title:"Search for team",
                description:"Search for a permanent team and make new friends! \n \n"
                    "with permanent team you can schedule repeating meetings." ,
                trailImageUrl:"assets/images/three_friends_play.png",
            ),

            ExpandedHomeCard(
              title:"Search for One-time meeting",
              description:"join a one-time event and try out! \n \n"
                  "you can't repeat a one time event" ,
              trailImageUrl:"assets/images/number_one.jpg",
            ),

            ExpandedHomeCard(
              title:"Search for team",
              description:"Search for a permanent team and make new friends! \n \n"
                  "with permanent team you can schedule repeating events." ,
              trailImageUrl:"assets/logos/teamapp.png",
            ),

          ],
        ),
    );
  }
}

class ExpandedHomeCard extends StatelessWidget {

  final String title;
  final String description;
  final String trailImageUrl;

  ExpandedHomeCard({this.title, this.description, this.trailImageUrl});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
            child: FittedBox(
              child: Material(
                color: Colors.white,
                elevation: 16.0,
                borderRadius: BorderRadius.circular(24.0),
                shadowColor: Colors.grey[900],
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  onTap: () {

                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 250,
                        height: 210,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Container(child: Text(this.title,
                                  style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 24.0,fontWeight: FontWeight.bold),)),
                              ),
                              Container(
                                  child: Text(this.description,
                                style: TextStyle(color: Colors.black, fontSize: 18.0,fontWeight: FontWeight.bold),)),
                            ],
                          ),
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
            )
        ),


      ),

    );
  }
}