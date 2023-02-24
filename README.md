<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# Description

This is a simple ***TextFormField*** which shows suggestions to an api call as you type on the input field. It is inspired from ***TypeAhead*** which can be used in a similar way.

## Features

- auto query text form field

## Getting started

- start with adding ***simple_auto_query_field: ^latest*** to the pubspec.yaml

- or add from the command line

``` dart
flutter pub get simple_auto_query_field
```

## Usage

- Import

```dart
import 'package:simple_auto_query_field/simple_auto_query_field.dart';
```

- Use it as a ***TextFormField*** and supply querry callbacks, item builder, and suggestions builder, and get suggestions from your supplied api as you type

``` dart
AutoQueryTextFormField<String?>(
  autoFocus: true,
  getImmediateSuggestions: true,
  queryCallback: (query) async {
    // call api here and return list of objects
    return searchPackage(query);
  },
  itemBuilder: (BuildContext context, itemData) {
    return Padding(
      key: UniqueKey(),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListTile(
        title: Text(itemData ?? 'No Data'),
      ),
    );
  },
  onSuggestionSelected: (selected) {
    setState(() {
      selectedItem = selected;
    });
  },
),
```

- check ***examples*** for full code

## Additional information

This package was inspired from ***flutter_typeahead***, so shoutout to the developer. Contributions to the package are welcome and appriciated.
