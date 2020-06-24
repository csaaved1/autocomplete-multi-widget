
import 'package:flutter/material.dart';


class AutoCompleteWidget extends StatefulWidget {
  final List<dynamic> myList;
  final String searchCategory;
  final bool multiSelect;

  const AutoCompleteWidget(this.myList,this.searchCategory,[this.multiSelect = false]);

  @override
  State<StatefulWidget> createState() {
    return _AutoCompleteWidgetState();
  }

}
class _AutoCompleteWidgetState extends State<AutoCompleteWidget> {
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  List names = new List();
  Map<int,Pair> mapNames = new Map<int,Pair>();
  List filteredNames = new List();
  List filteredItems = new List();
  Map<int,Pair> filterMap = new Map<int,Pair>();
  Icon _searchIcon = new Icon(Icons.search);
  Icon _assignmentIcon= new Icon(Icons.assignment_return);
  Icon _clearIcon= new Icon(Icons.layers_clear);
  Widget _appBarTitle = new Text( 'Search' );
  Map<int,Pair> masterMap = new Map<int,Pair>();
  List<int> orderList = new List();

  _AutoCompleteWidgetState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          if (widget.multiSelect == false) {
            // filteredNames = names;
            filteredItems = widget.myList;
          }
          else{
            filterMap = mapNames;
          }

        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  void initState() {
    if(widget.multiSelect == true) {
      setState(() {
        for (int i = 0; i < widget.myList.length; i++) {
          masterMap.putIfAbsent(i , () =>(new Pair(getDynamicField(widget.myList[i]),false, i)) );
        }
      });
    }
    this._getNames(widget.myList, widget.searchCategory);
    this._searchPressed();
    super.initState();
  }

  Widget build(BuildContext context) {

    return Scaffold(
      appBar: _buildBar(context),
      body: Container(
        child: this.widget.multiSelect == true ?
        _buildMultiList(widget.myList, widget.searchCategory) : _buildList(widget.myList, widget.searchCategory) ,
      ),
      resizeToAvoidBottomPadding: false,
      floatingActionButton: FloatingActionButton(child: Icon(Icons.close, size: 50, color: Theme.of(context).buttonColor,),
      onPressed: () => {
         Navigator.pop(context)

      }
      ),
    );


  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle,
      leading: new IconButton(
        icon: _searchIcon,
        onPressed: _searchPressed,
      ),
      actions: fetchAppBarActions(),
    );
  }

  List<Widget> fetchAppBarActions() {
    List<Widget> myWidgetList = new List<Widget>();

    if(widget.multiSelect == true)
    {
      myWidgetList.add(
        IconButton(
          icon: _assignmentIcon,
          onPressed: () {
            Navigator.pop(context, fetchSelected());
          },
        ),
      );
      myWidgetList.add(
        IconButton(
          icon: _clearIcon,
          onPressed: () {
            for(int i=0;i<masterMap.length;i++)
            {
              itemChange(false, i);
            }
          },
        ),
      );
      return myWidgetList;
    }

    return [];


  }


  Widget _buildList(List<dynamic> myList, String searchCategory) {
    if (_searchText != '') {
      List tempList = new List();


      // for (int i = 0; i < filteredNames.length; i++) {
      //   if ((filteredNames[i].trim().toLowerCase()).contains(_searchText.toLowerCase())) {
      //     tempList.add(filteredNames[i]);
      //   }
      // }
      // filteredNames = tempList;

      for (int i = 0; i < widget.myList.length; i++) {
        String itemName = "";
        if(widget.searchCategory == "name") {
          itemName = widget.myList[i].name;
        } else {
          itemName = widget.myList[i].title;
        }
        
        if ((itemName.trim().toLowerCase()).contains(_searchText.toLowerCase())) {
          tempList.add(widget.myList[i]);
        }
      }

      filteredItems = tempList;

    }
    return ListView.builder(
      // itemCount: names == null ? 0 : filteredNames.length,
      itemCount: filteredItems.length,
      itemBuilder: (BuildContext context, int index) {
        return new ListTile(
          onTap: () =>{
            print(filteredItems[index]),
            
            Navigator.pop(context, filteredItems[index])} ,
          // title: Text(filteredNames[index]),
          title:  
          Text(widget.searchCategory == "name" ? filteredItems[index].name : filteredItems[index].title),
        );
      },
    );
  }

  void itemChange(bool val,int index){
    setState(() {
      masterMap[index] = new Pair(masterMap[index].myStr,val,masterMap[index].id);

    });
  }

  String strCheck(String str1){
    return str1.toLowerCase().replaceAll(' ', '');
  }
  ListView _buildMultiList(List<dynamic> myList, String searchCategory) {
    if (_searchText!='') {
      print(filterMap);
      List<int> tempList = new List();
      Map<int,Pair> tempMap = new Map<int,Pair>();
      for (int i = 0; i < orderList.length; i++) {
        if (strCheck(filterMap[orderList[i]].myStr).contains(strCheck(_searchText))) {
          tempMap[i] = filterMap[orderList[i]];
          tempList.add(i);
        }
      }
      filterMap = tempMap;
      orderList = tempList;
    } else
    {
      orderList.clear();
      for(int i=0;i<filterMap.length;i++)
      {
        orderList.add(i);
      }
    }

    return  ListView.builder(
      itemCount: mapNames == null ? 0 : filterMap.length,
      itemBuilder: (context, index) => _listItemBuilder(context, index),
    );
  }
  Widget _listItemBuilder(BuildContext context, int index) {
    return new CheckboxListTile(value: masterMap[filterMap[orderList[index]].id].check,
      onChanged: (bool val){itemChange(val, filterMap[orderList[index]].id);},
      title: Text(filterMap[orderList[index]].myStr ),);
  }


  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          autofocus: true,
          controller: _filter,
          decoration: new InputDecoration(
              hintText: 'Search...'
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text( 'Search' );
        widget.multiSelect == false ? filteredNames = names : filterMap = mapNames;
        _filter.clear();
      }
    });
  }

  String getDynamicField(dynamic myObj)
  {
    switch(widget.searchCategory)
    {
      case 'title': return myObj.title;

      case 'name': return myObj.name;
    }

    return '';
  }


  void _getNames(List<dynamic> myList, String searchType) async {

    setState(() {
      if(widget.multiSelect == false){
        // names = (myList.map((e) => getDynamicField(e)).toList());
        // filteredNames = names;

        filteredItems = myList;


      }else {
        for(int i=0; i<myList.length;i++ )
        {

          mapNames[i] = Pair(getDynamicField(myList[i]),false,masterMap[i].id);
        }
        filterMap = mapNames;
        print(filterMap);
      }


    });
  }


  List<dynamic> fetchSelected() {
    List<dynamic> returningList = new List<dynamic>();

    for (int i = 0; i < masterMap.length; i++) {
      if (masterMap[i].check == true) {
        returningList.add(widget.myList[i]);
      }
    }
    return returningList;

  }

}



class Pair {
  final String myStr;
  final  bool check;
  final int id;

  const Pair(this.myStr, this.check, this.id);
}


