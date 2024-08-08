import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PanelistsPage extends StatelessWidget {
  const PanelistsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding : const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            const Text(
              "Panelists",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 5),
            const Divider(
              height: 2,
              color: Colors.blueGrey,
            ),
              const SizedBox(height: 30),
              SearchBar(hintText: "Search hear...!",
                leading: const Icon(Icons.search),
              ),
              const SizedBox(height: 30),
              Expanded(
              child: Wrap(
                spacing: 16.0, // Horizontal space between cards
                runSpacing: 16.0, // Vertical space between rows of cards
                children: List.generate(5, (index) => Container(
                  constraints: BoxConstraints(
                    maxWidth: 240, // Maximum width of the card
                  ),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10), // Add padding inside the card
                      child: Column( // Aligning content vertically
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Title Name $index",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width:10),
                                  // Edit and Delete buttons
                                  Row(
                                    children: [
                                      Icon(Icons.edit, size: 16,color: Colors.blue,),
                                      Icon(Icons.delete, size: 16,color: Colors.redAccent,),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(width: 4),
                            ],
                          ),
                          Text(
                            "Subtitle $index",
                            style: TextStyle(
                              fontSize:16,
                              color:Colors.blueGrey,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,

                          children: [
                            Column(
                              children: [
                                Icon(Icons.mail_outline_outlined, size: 16),
                                SizedBox(height: 4),
                              ],
                            ),
                            SizedBox(width:5,),
                            Column(
                              children: [
                                Text(
                                  "abc@gmail.com",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Column(
                                children: [
                                  Icon(Icons.phone, size: 16),
                                  SizedBox(height: 4),
                                ],
                              ),
                              SizedBox(width:5,),
                              Column(
                                children: [
                                  Text(
                                    "+123456789${index % 10}",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

