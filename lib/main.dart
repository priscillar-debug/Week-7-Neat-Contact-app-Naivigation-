import 'package:flutter/material.dart';

void main() {
  runApp(const ContactApp());
}

class ContactApp extends StatelessWidget {
  const ContactApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contact App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const ContactListPage(),
    );
  }
}

class ContactListPage extends StatefulWidget {
  const ContactListPage({super.key});

  @override
  State<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  final List<Map<String, String>> _contacts = [];

  void _addContact(String name, String phone) {
    setState(() {
      _contacts.add({"name": name, "phone": phone});
    });
  }

  void _navigateToAddContact() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddContactPage()),
    );

    if (result != null && result is Map<String, String>) {
      _addContact(result["name"]!, result["phone"]!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📒 My Contacts'), centerTitle: true),
      body: _contacts.isEmpty
          ? const Center(
              child: Text(
                "No contacts yet! ✨\nTap + to add one.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (context, index) {
                final contact = _contacts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.indigo,
                      child: Text(
                        contact["name"]![0].toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      contact["name"]!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(contact["phone"]!),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddContact,
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }
}

class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _saveContact() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        "name": _nameController.text.trim(),
        "phone": _phoneController.text.trim(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Contact")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter a name" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? "Enter a phone number"
                    : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _saveContact,
                icon: const Icon(Icons.save),
                label: const Text("Save Contact"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
