import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamapp/screens/friends/list_search_friend.dart';
import 'package:teamapp/services/database/user_management.dart';

class SearchFriend extends StatefulWidget {
  State<StatefulWidget> createState() => _SearchFriendState();
}

class _SearchFriendState extends State<SearchFriend> {
  final TextEditingController _filter = new TextEditingController();
  //final dio = new Dio(); // for http requests
  String _searchText = "";
  List names = new List(); // names we get from API
  List filteredNames = new List(); // names filtered by search text
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Search Friend');

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: UserManagement().allUser,
      child: Scaffold(
        appBar: AppBar(
          title: _appBarTitle,
          centerTitle: true,
          leading: IconButton(
            icon: _searchIcon,
            color: Colors.white,
            onPressed: () {
              print("search clicked");
              _searchPressed();
            },
          ),
        ),
        drawer: ListSearchFriend(),
      ),
    );
  }

  @override
  void initState() {
    _getNames();
  }

  void _getNames() async {
    final response = UserManagement().allUser;
    List tempList = new List();
    response.forEach((element) {
      tempList.add(element);
    }) ;

    setState(() {
      names = tempList;
      filteredNames = names;
    });
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search), hintText: 'Search...'),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Search Friend');
        filteredNames = names;
        _filter.clear();
      }
    });
  }

  Widget _buildList() {
    if (!(_searchText.isEmpty)) {
      List tempList = new List();
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i]['name']
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(filteredNames[i]);
        }
      }
      filteredNames = tempList;
    }
    return ListView.builder(
      itemCount: names == null ? 0 : filteredNames.length,
      itemBuilder: (BuildContext context, int index) {
        return new ListTile(
          title: Text(filteredNames[index]['name']),
          onTap: () => print(filteredNames[index]['name']),
        );
      },
    );
  }
}
