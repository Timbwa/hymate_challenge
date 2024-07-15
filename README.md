# Hymate Challenge

Hymate Technical Challenge.

### Assumptions

- The chart widget will show data spanning across a single day
- The Production Type used to display the Total Power Data is `Renewable share of generation`
- For task 2, the `Favoriten` section was ignored and only the hierarchical widget is implemented
- When constructing the extra section of Plot json object, all the leaf `dataPoints` are considered. (This is not the
  case in the sample json provided)
- Colors for the `categories` and `dataPoints` are generated once randomly

### Task 1 Data

Fetches `total_price` and `total_power` while displaying the `production_type` of `Renewable share of generation`

### Json File

You can find the desired Json file under the assets folder. Feel free to change its content or alter the path
in `challenge.dart`, line 45:

```dart
Future<void> _parseDataPointsJson() async {
  await rootBundle.loadString('assets/data_points.json').then((dataPointsJsonString) {
    final categoriesJson = jsonDecode(dataPointsJsonString) as Map<String, dynamic>;
    // {..}
  });
}
  ```

