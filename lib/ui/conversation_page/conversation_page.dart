import 'package:flutter/material.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({Key? key}) : super(key: key);

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: -5,
        title: Row(
          children: const [
            CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://fiverr-res.cloudinary.com/images/t_main1,q_auto,f_auto,q_auto,f_auto/gigs/128009228/original/8e8ad34b012b46ebd403bd4157f8fef6bb2c076b/design-minimalist-flat-cartoon-caricature-avatar-in-6-hours.jpg"),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text("data"),
            )
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                    "https://i.pinimg.com/originals/52/e5/6f/52e56fb927b170294ccc035f02c6477d.jpg"))),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) => ListTile(
                        title: Align(
                          alignment: index % 2 == 0
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: const BorderRadius.horizontal(
                                      left: Radius.circular(10),
                                      right: Radius.circular(10))),
                              child: const Text(
                                "Mesaj",
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                      )),
            ),
            Row(
              children: [
                Expanded(
                    child: Container(
                  margin: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(25),
                          right: Radius.circular(25))),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: TextFormField(
                            decoration: const InputDecoration(
                                hintText: "Type a message",
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                      const InkWell(
                        child: Icon(
                          Icons.attach_file,
                          color: Colors.grey,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: InkWell(
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    ],
                  ),
                )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
