import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/screens/submitpetscreen.dart';
import '../models/user.dart';
import 'loginscreen.dart';
import '../models/pet.dart';
import '../myconfig.dart';
import '../shared/mydrawer.dart';

class MainScreen extends StatefulWidget {
  final User? user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String status = "Loading...";
  List<Pet> petList = [];
  late double screenHeight, screenWidth;
  int numofpage = 1;
  int curpage = 1;
  int numofresult = 0;

  @override
  void initState() {
    super.initState();
    loadPets('');
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      screenWidth = 600;
    } else {
      screenWidth = screenWidth;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('PawPal'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearchDialog();
            },
          ),
          IconButton(
            onPressed: () {
              loadPets('');
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: screenWidth,
          child: Column(
            children: [
              petList.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.find_in_page_outlined, size: 64),
                            SizedBox(height: 12),
                            Text(
                              status,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: petList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // IMAGE
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      width: screenWidth * 0.28,
                                      height: screenWidth * 0.22,
                                      color: Colors.grey[400],
                                      child: Image.network(
                                        '${MyConfig.baseUrl}/pawpal/api/${petList[index].imagePaths.toString().split(",")[0]}',
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return const Icon(
                                                Icons.broken_image,
                                                size: 60,
                                                color: Colors.grey,
                                              );
                                            },
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // pet name text
                                        Text(
                                          petList[index].petName.toString(),
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        // description text
                                        Text(
                                          petList[index].description.toString(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 6),
                                        // pet type and category chips
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              Chip(
                                                label: Text(
                                                  petList[index].petType
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                backgroundColor:
                                                    Colors.deepOrangeAccent,
                                                visualDensity:
                                                    VisualDensity.compact,
                                              ),
                                              const SizedBox(width: 6),
                                              Chip(
                                                label: Text(
                                                  petList[index].category
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                backgroundColor:
                                                    Colors.blueAccent,
                                                visualDensity:
                                                    VisualDensity.compact,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // TRAILING ARROW BUTTON
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text(
                                            petList[index].petName.toString(),
                                          ),
                                          content: Text(
                                            "Pet Type: ${petList[index].petType}\n"
                                            "Category: ${petList[index].category}\n"
                                            "Description: ${petList[index].description}\n"
                                            "Location: ${petList[index].lat}, ${petList[index].lng}\n"
                                            "Created at: ${petList[index].createdAt}",
                                          ), // Show full description here
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text("Close"),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              //pagination builder
              SizedBox(
                height: screenHeight * 0.05,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: numofpage,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    var color = (curpage - 1) == index
                        ? Colors.red
                        : Colors.black;
                    return TextButton(
                      onPressed: () {
                        curpage = index + 1;
                        loadPets('');
                      },
                      child: Text(
                        (index + 1).toString(),
                        style: TextStyle(color: color, fontSize: 18),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      //=========================================================FAB
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // button action
          if (widget.user?.userId == '0') {
            showLoginRequiredDialog();
          } else {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SubmitPetScreen(user: widget.user),
              ),
            );
            loadPets('');
          }
        },
        child: Icon(Icons.add),
      ),
      drawer: MyDrawer(user: widget.user),
    );
  }

  void showLoginRequiredDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Required'),
          content: Text('You need to be logged in to perform this action.'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Login'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void showSearchDialog() {
    TextEditingController searchController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Search'),
          content: TextField(
            controller: searchController,
            decoration: InputDecoration(hintText: 'Enter search query'),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Search'),
              onPressed: () {
                String search = searchController.text;
                if (search.isEmpty) {
                  loadPets('');
                } else {
                  loadPets(search);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void loadPets(String searchQuery) {
    // load pets from server
    petList.clear();
    setState(() {
      status = "Loading...";
    });
    http
        .get(
          Uri.parse(
            "${MyConfig.baseUrl}/pawpal/api/get_my_pets.php?user_id=${widget.user?.userId ?? '0'}&search=$searchQuery&curpage=$curpage",
          ),
        )
        .then((response) {
          if (response.statusCode == 200) {
            var jsonResponse = jsonDecode(response.body);
            if (jsonResponse['success'] == true &&
                jsonResponse['data'] != null &&
                jsonResponse['data'].isNotEmpty) {
              // has data → load to list
              petList.clear();
              for (var item in jsonResponse['data']) {
                petList.add(Pet.fromJson(item));
              }
              numofpage = int.parse(jsonResponse['numofpage'].toString());
              numofresult = int.parse(
                jsonResponse['numberofresult'].toString(),
              );
              setState(() {
                status = "";
              });
            } else {
              // success but no data available
              setState(() {
                petList.clear();
                status = "No submissions yet";
              });
            }
          } else {
            // request failed
            setState(() {
              petList.clear();
              status = "Failed to load pets";
            });
          }
        });
  }
}
