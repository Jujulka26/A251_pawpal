import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/user.dart';
import 'package:pawpal/models/pet.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/shared/mydrawer.dart';
import 'package:pawpal/screens/petdetailsscreen.dart';

class PublicListingScreen extends StatefulWidget {
  final User? user;
  const PublicListingScreen({super.key, required this.user});

  @override
  State<PublicListingScreen> createState() => _PublicListingScreenState();
}

class _PublicListingScreenState extends State<PublicListingScreen> {
  TextEditingController searchController = TextEditingController();
  String status = "Loading...";
  List<Pet> petList = [];
  late double screenHeight, screenWidth;
  int numofpage = 1;
  int curpage = 1;
  int numofresult = 0;
  String? selectedType;
  List<String> petTypes = ["Cat", "Dog", "Other"];

  @override
  void initState() {
    super.initState();
    loadPublicPets('');
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
        title: const Text('Public Pet Listings'),
        actions: [
          IconButton(
            onPressed: () {
              loadPublicPets('');
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: screenWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                  height: 55,
                  child: Row(
                    children: [
                      //==============================================SEARCH BAR
                      Flexible(
                        flex: 13,
                        child: SearchBar(
                          controller: searchController,
                          leading: const Icon(
                            Icons.search,
                            color: Colors.deepOrange,
                          ),
                          hintText: 'Search pets by name',
                          autoFocus: false,
                          onSubmitted: (value) {
                            if (value.isEmpty) {
                              loadPublicPets('');
                            } else {
                              loadPublicPets(value);
                            }
                          },
                          trailing: [
                            if (searchController.text.isNotEmpty)
                              IconButton(
                                onPressed: () {
                                  searchController.clear();
                                  loadPublicPets('');
                                },
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.deepOrange,
                                ),
                              ),
                          ],
                          side: const WidgetStatePropertyAll(
                            BorderSide(color: Colors.deepOrange, width: 2),
                          ),
                          elevation: WidgetStateProperty.all(0),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          padding: const WidgetStatePropertyAll(
                            EdgeInsets.symmetric(horizontal: 10.0),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      //==============================================TYPE DROPDOWN
                      Flexible(
                        flex: 7,
                        child: DropdownButtonFormField<String>(
                          initialValue: selectedType,
                          decoration: InputDecoration(
                            suffixIcon:
                                selectedType != null && selectedType!.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.clear,
                                      color: Colors.deepOrange,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        selectedType = null;
                                        curpage = 1;
                                      });
                                      loadPublicPets(searchController.text);
                                      FocusScope.of(context).unfocus();
                                    },
                                  )
                                : const Icon(
                                    Icons.filter_list,
                                    color: Colors.deepOrange,
                                  ),
                            labelText: 'Type',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          items: petTypes.map((String type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedType = newValue;
                              curpage = 1;
                            });
                            loadPublicPets(searchController.text);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //====================================================PUBLIC PETS LIST VIEW
              petList.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.find_in_page_outlined, size: 64),
                            const SizedBox(height: 12),
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
                          return InkWell(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PetDetailsScreen(
                                    user: widget.user,
                                    pet: petList[index],
                                  ),
                                ),
                              );
                              loadPublicPets('');
                            },
                            child: Card(
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    //====================================PET IMAGE
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        width: screenWidth * 0.26,
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
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //=======================================PET NAME
                                          Text(
                                            petList[index].petName.toString(),
                                            style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          //====================================PET TYPE & AGE
                                          Row(
                                            children: [
                                              Text(
                                                '${petList[index].petType} • ${petList[index].petAge} yrs',
                                                style: TextStyle(
                                                  color: Colors.grey[800],
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                              top: 6,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  petList[index].category
                                                          .toString() ==
                                                      'Adoption'
                                                  ? Colors.deepOrange
                                                  : petList[index].category
                                                            .toString() ==
                                                        'Donation Request'
                                                  ? Colors.green
                                                  : Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              petList[index].category
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.pets,
                                      size: 28,
                                      color: Colors.deepOrangeAccent,
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                ),
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
                    bool isSelected = (curpage - 1) == index;
                    return TextButton(
                      onPressed: () {
                        curpage = index + 1;
                        loadPublicPets('');
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: isSelected
                            ? Colors.deepOrangeAccent
                            : Colors.white,
                        foregroundColor: isSelected
                            ? Colors.white
                            : Colors.black,
                        side: isSelected
                            ? BorderSide(color: Colors.deepOrange, width: 1.5)
                            : BorderSide(color: Colors.grey, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(30, 30),
                      ),
                      child: Text(
                        (index + 1).toString(),
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
      drawer: MyDrawer(user: widget.user),
    );
  }

  void loadPublicPets(String searchQuery) {
    petList.clear();
    setState(() {
      status = "Loading...";
    });

    String url =
        "${MyConfig.baseUrl}/pawpal/api/get_public_pets_listing.php"
        "?search=$searchQuery&curpage=$curpage";

    if (selectedType != null) {
      url += "&type=$selectedType";
    }

    http.get(Uri.parse(url)).then((response) {
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true &&
            jsonResponse['data'] != null &&
            jsonResponse['data'].isNotEmpty) {
          petList.clear();
          for (var item in jsonResponse['data']) {
            petList.add(Pet.fromJson(item));
          }
          numofpage = int.parse(jsonResponse['numofpage'].toString());
          numofresult = int.parse(jsonResponse['numberofresult'].toString());
          setState(() {
            status = "";
          });
        } else {
          setState(() {
            petList.clear();
            if (searchQuery.isEmpty) {
              status = "No pets available at the moment";
            } else {
              status = "No pets found matching your search";
            }
          });
        }
      } else {
        setState(() {
          petList.clear();
          status = "Failed to load pets";
        });
      }
    });
  }
}
