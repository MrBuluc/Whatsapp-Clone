import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/model/user.dart';
import 'package:whatsapp_clone/viewmodel/user_model.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: ContactSearchDelegate());
            },
          )
        ],
      ),
      body: const ContactsList(),
    );
  }
}

class ContactSearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) =>
      Theme.of(context).copyWith(primaryColor: const Color(0xff075E54));

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ContactsList(query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const ContactsList();
  }
}

class ContactsList extends StatelessWidget {
  final String? query;
  const ContactsList({Key? key, this.query}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<UserModel>(context, listen: false)
          .getFilteredUsers(query),
      builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView(
          children: snapshot.data!
              .map((user) => ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.getProfileImage()),
                    ),
                    title: Text(user.username),
                  ))
              .toList(),
        );
      },
    );
  }
}
