import 'package:flutter/material.dart';
import 'package:pantrypal/auth/login.dart';
import 'package:pantrypal/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pantrypal/screens/add_item_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = TextEditingController();
  
  // Sample data for the list
  final List<Map<String, dynamic>> _items = [
    {"id": "1", "name": "Milk", "expiryDate": "2023-07-15", "status": "active", "quantity": 1, "unit": "ltr"},
    {"id": "2", "name": "Bread", "expiryDate": "2023-07-10", "status": "soon", "quantity": 2, "unit": "pcs"},
    {"id": "3", "name": "Eggs", "expiryDate": "2023-07-30", "status": "active", "quantity": 12, "unit": "pcs"},
    {"id": "4", "name": "Yogurt", "expiryDate": "2023-07-05", "status": "expired", "quantity": 1, "unit": "kg"},
    {"id": "5", "name": "Cheese", "expiryDate": "2023-08-15", "status": "active", "quantity": 500, "unit": "g"},
  ];

  Future<void> _logout(BuildContext context) async {
    final api = ApiService();

    try {
      // Call logout endpoint
      await api.post('/api/auth/logout', {});

      // Clear session data
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('session_id');

      // Navigate to login screen and clear navigation stack
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Logout failed: $e')));
    }
  }
  
  // Get color based on item status
  Color _getStatusColor(String status) {
    switch(status) {
      case 'active': return Colors.green;
      case 'soon': return Colors.orange;
      case 'expired': return Colors.red;
      case 'consumed': return Colors.grey;
      default: return Colors.green;
    }
  }
  
  // Get text based on item status
  String _getStatusText(String status) {
    switch(status) {
      case 'active': return 'Active';
      case 'soon': return 'Expiring Soon';
      case 'expired': return 'Expired';
      case 'consumed': return 'Consumed';
      default: return 'Active';
    }
  }
  
  // Handle delete item
  void _deleteItem(String id) {
    // This would actually call the API in a real implementation
    setState(() {
      _items.removeWhere((item) => item["id"] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Item deleted'))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantry Pal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Add Row
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search an item",
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                        ),
                        borderSide: const BorderSide(color: Colors.green),
                      ),
                      suffixIcon: Container(
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.search, color: Colors.white),
                          onPressed: () {
                            print("Search: ${_searchController.text}");
                          },
                        ),
                      ),
                      suffixIconConstraints: const BoxConstraints.tightFor(
                        width: 48,
                        height: 48,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4),
                SizedBox(
                  height: 48,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(color: Colors.green.shade800, width: 1),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddItemScreen()),
                      );
                      
                      // If new item was added, refresh the list
                      if (result == true) {
                        // In a real implementation, you'd fetch items from API here
                        setState(() {
                          // Refresh items
                        });
                      }
                    },
                    child: const Text(
                      "Add",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // List header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Your Pantry Items',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800
                    ),
                  ),
                ),
                Text(
                  '${_items.length} items',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ],
            ),
          ),

          // List of pantry items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(
                      color: _getStatusColor(item["status"]).withOpacity(0.3),
                      width: 1
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    leading: Container(
                      width: 12,
                      decoration: BoxDecoration(
                        color: _getStatusColor(item["status"]),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    title: Text(
                      item["name"],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text(
                          '${item["quantity"]} ${item["unit"]} · Expires: ${item["expiryDate"]}',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 4),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getStatusColor(item["status"]).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _getStatusText(item["status"]),
                            style: TextStyle(
                              fontSize: 12,
                              color: _getStatusColor(item["status"]),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _deleteItem(item["id"]),
                    ),
                    onTap: () {
                      print("Tapped on ${item["name"]}");
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddItemScreen()),
          );
          
          // If new item was added, refresh the list
          if (result == true) {
            // In a real implementation, you'd fetch items from API here
            setState(() {
              // Refresh items
            });
          }
        },
      ),
    );
  }
}