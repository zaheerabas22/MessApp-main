import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InventoryItem {
  final String name;
  final int quantity;

  InventoryItem({required this.name, required this.quantity});
}

class InventoryManagementScreen extends StatefulWidget {
  const InventoryManagementScreen({Key? key}) : super(key: key);

  @override
  _InventoryManagementScreenState createState() =>
      _InventoryManagementScreenState();
}

class _InventoryManagementScreenState extends State<InventoryManagementScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  List<InventoryItem> inventoryItems = [];

  @override
  void initState() {
    super.initState();
    // Load inventory data from Firestore when the screen initializes
    _loadInventoryData();
  }

  // Function to load inventory data from Firestore
  Future<void> _loadInventoryData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final snapshot = await _firestore.collection('inventory').get();
      final items = snapshot.docs
          .map((doc) => InventoryItem(
                name: doc['name'] ?? '',
                quantity: doc['quantity'] ?? 0,
              ))
          .toList();
      setState(() {
        inventoryItems = items;
      });
    }
  }

  // Function to add an item to Firestore
  Future<void> _addItemToFirestore(InventoryItem item) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _firestore.collection('inventory').add({
        'name': item.name,
        'quantity': item.quantity,
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory Management'),
      ),
      body: FutureBuilder(
        // Replace with your logic to fetch data from Firestore
        future: _loadInventoryData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show a loading indicator
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            // Data loaded successfully, display it
            List<InventoryItem> inventoryItems =
                snapshot.data as List<InventoryItem>;

            return ListView.builder(
              itemCount: inventoryItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(inventoryItems[index].name),
                  subtitle: Text(
                      'Quantity: ${inventoryItems[index].quantity.toString()}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Open the edit screen for the selected item
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditInventoryItemScreen(
                                  item: inventoryItems[index]),
                            ),
                          ).then((updatedItem) {
                            if (updatedItem != null) {
                              // Update the item in the list
                              setState(() {
                                inventoryItems[index] = updatedItem;
                              });
                              // Update the item in Firestore
                              _updateItemInFirestore(updatedItem);
                            }
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          // Show a confirmation dialog before deleting
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Delete Item'),
                                content: Text(
                                    'Are you sure you want to delete this item?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      // Get the name of the item to delete
                                      String itemNameToDelete =
                                          inventoryItems[index].name;

                                      // Remove the item from the list
                                      setState(() {
                                        inventoryItems.removeAt(index);
                                      });

                                      // Delete the item from Firestore by matching the name
                                      QuerySnapshot snapshot = await _firestore
                                          .collection('inventory')
                                          .where('name',
                                              isEqualTo: itemNameToDelete)
                                          .get();

                                      // Assuming there's only one matching document, delete it
                                      snapshot.docs.forEach((doc) {
                                        doc.reference.delete();
                                      });

                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                    child: Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: Visibility(
        visible:
            FirebaseAuth.instance.currentUser != null, // Show only if logged in
        child: FloatingActionButton(
          onPressed: () {
            // Open a screen to add a new inventory item
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddInventoryItemScreen()),
            ).then((newItem) {
              if (newItem != null && newItem is InventoryItem) {
                // Modify the state inside this callback
                setState(() {
                  inventoryItems.add(newItem);
                });
                // Save the new item to Firestore
                _addItemToFirestore(newItem);
              }
            });
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> _updateItemInFirestore(InventoryItem updatedItem) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _firestore
          .collection('inventory')
          .where('name', isEqualTo: updatedItem.name)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.update({
            'name': updatedItem.name,
            'quantity': updatedItem.quantity,
          });
        });
      });
    }
  }
}

class EditInventoryItemScreen extends StatefulWidget {
  final InventoryItem item;

  EditInventoryItemScreen({required this.item});

  @override
  _EditInventoryItemScreenState createState() =>
      _EditInventoryItemScreenState();
}

class _EditInventoryItemScreenState extends State<EditInventoryItemScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.item.name;
    _quantityController.text = widget.item.quantity.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Inventory Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+$')),
              ],
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a quantity.';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Validate and save changes
                String name = _nameController.text.trim();
                int quantity = int.tryParse(_quantityController.text) ?? 0;

                if (name.isNotEmpty && quantity > 0) {
                  // Create the updated item and return it to the previous screen
                  InventoryItem updatedItem =
                      InventoryItem(name: name, quantity: quantity);
                  Navigator.pop(context, updatedItem);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter valid values.'),
                    ),
                  );
                }
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}

class AddInventoryItemScreen extends StatefulWidget {
  @override
  _AddInventoryItemScreenState createState() => _AddInventoryItemScreenState();
}

class _AddInventoryItemScreenState extends State<AddInventoryItemScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Inventory Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+$')),
              ],
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a quantity.';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Validate and add the new item to the list
                String name = _nameController.text.trim();
                int quantity = int.tryParse(_quantityController.text) ?? 0;

                if (name.isNotEmpty && quantity > 0) {
                  // Create the new item and return it to the previous screen
                  InventoryItem newItem =
                      InventoryItem(name: name, quantity: quantity);
                  Navigator.pop(context, newItem);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter valid values.'),
                    ),
                  );
                }
              },
              child: Text('Add Item'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: InventoryManagementScreen(),
  ));
}
