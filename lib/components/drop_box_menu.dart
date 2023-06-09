import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DropBoxMenu extends StatelessWidget {
  final void Function(String?) onHotColdChanged;
  final String labelText;
  final String collectionName;

  const DropBoxMenu({
    required this.onHotColdChanged,
    required this.labelText,
    required this.collectionName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(collectionName).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          final items =
              snapshot.data!.docs.map((doc) => doc['name'] as String).toList();
          return DropdownButtonFormField<String>(
            onChanged: onHotColdChanged,
            decoration: InputDecoration(
              labelText: labelText,
              border: const OutlineInputBorder(),
            ),
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
