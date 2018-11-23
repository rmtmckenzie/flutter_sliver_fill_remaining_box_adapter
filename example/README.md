# Sliver Fill Remaining Box Adapter Example

The example code demonstrates how to use the sliver_fill_remaining_box_adapter plugin.

```dart

CustomScrollView(
  slivers: <Widget>[
    /*<other slivers>,*/
    SliverFillRemainingBoxAdapter(
      child: Container(
        color: Colors.black,
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 200,
          alignment: Alignment.center,
          child: Text(
            "This is filling the remaining or using\nits child's height if no remaining.",
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  ],
);
```