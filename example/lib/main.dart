import 'package:flutter/material.dart';
import 'package:simple_auto_query_field/simple_auto_query_field.dart';


void main() {
  runApp(const MyApp());
}

const pubDevSearchApi = 'https://pub.dev/packages?q=';

List<String?> searchPackage(String? querry){
  try{

  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Auto Query Field Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SimpleAutoQueryPreview(),
    );
  }
}

class SimpleAutoQueryPreview extends StatelessWidget {
  const SimpleAutoQueryPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoQueryTextFormField<String>(
      autoFocus: true,
      getImmediateSuggestions: true,
      queryCallback: (query) async {
        // call api here and return list of objects
        return;
      },
      itemBuilder: (BuildContext context, itemData) {
        return Padding(
          key: UniqueKey(),
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListTile(
            title: Text(voucherMode.voucherName ?? ''),
          ),
        );
      },
      onSuggestionSelected: (selectedVM) {
        selectedVoucherModeNotifier.state = selectedVM;
        isVoucherSelectorNotifier.state = false;
        _getAbbreviatedInvoiceProducts(ref);
      },
    );
  }
}
