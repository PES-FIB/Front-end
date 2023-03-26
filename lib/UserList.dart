import 'package:flutter/material.dart';

class UserList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Event $index'),
          subtitle: Text('event description'),
          leading:  Icon(Icons.calendar_month),
        );

      },
      itemCount: 100,
    );
  }
}