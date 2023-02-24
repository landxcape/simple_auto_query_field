import 'dart:math';

import 'package:example/demo_package_list.dart';
import 'package:flutter/material.dart';
import 'package:simple_auto_query_field/simple_auto_query_field.dart';

void main() {
  runApp(const MyApp());
}

Future<List<String>> mockApi(String? query) {
  return Future.delayed(
    Duration(milliseconds: Random().nextInt(900) + 100),
    () {
      return demoPackageData.where(
        (item) {
          return item
              .contains(query == null || query == '' ? '' : RegExp('$query*'));
        },
      ).toList();
    },
  );
}

Future<List<String?>> searchPackage(String? query) async {
  return mockApi(query);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Auto Query Field Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SimpleAutoQueryPreview(),
    );
  }
}

class SimpleAutoQueryPreview extends StatefulWidget {
  const SimpleAutoQueryPreview({super.key});

  @override
  State<SimpleAutoQueryPreview> createState() => _SimpleAutoQueryPreviewState();
}

class _SimpleAutoQueryPreviewState extends State<SimpleAutoQueryPreview> {
  String? selectedItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(selectedItem ?? 'Not Selected'),
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}
