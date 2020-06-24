# AutoCompleteWidget

Widget Demonstration

Parameters for Widget
- myList -> List which will be filtered and selected through auto complete
expecting a List of objects
- searchCategory-> Which field of the object will we be searching by? In the example we used name of person.
- multiSelect -> set automatically to false, which will then be a single select and will return one and only one object on click, otherwise multiSelect will 
be used on set true
```
const AutoCompleteWidget(this.myList,
this.searchCategory,
[this.multiSelect = false]);
```

MultiSelect also has a clear all functionality on the top right.


Some open issues are overwriting a previously fetched set from multiSelect.
If multiSelect is reused it will overwrite the old value that was previously there.

