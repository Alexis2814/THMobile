import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Address App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.deepPurple,
          secondary: Colors.deepPurpleAccent,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Colors.deepPurple),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Colors.deepPurple),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
          ),
          contentPadding:
          const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.deepPurple,
            side: const BorderSide(color: Colors.deepPurple),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
      ),
      home: const AddressListScreen(),
    );
  }
}

// ================== MODEL ==================
class Address {
  String name;
  String phone;
  String province;
  String district;
  String ward;
  String detail;
  double? lat;
  double? lng;

  Address({
    required this.name,
    required this.phone,
    required this.province,
    required this.district,
    required this.ward,
    required this.detail,
    this.lat,
    this.lng,
  });
}

// ================== DANH SÁCH ĐỊA CHỈ ==================
class AddressListScreen extends StatefulWidget {
  const AddressListScreen({super.key});

  @override
  State<AddressListScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {final List<Address> _addresses = [];

void _addAddress(Address addr) {
  setState(() {
    _addresses.add(addr);
  });
}

void _editAddress(int index, Address addr) {
  setState(() {
    _addresses[index] = addr;
  });
}

void _deleteAddress(int index) {
  setState(() {
    _addresses.removeAt(index);
  });
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("My Addresses"),
      backgroundColor: Colors.deepPurple,
    ),
    body: _addresses.isEmpty
        ? const Center(child: Text("No addresses yet"))
        : ListView.builder(
      itemCount: _addresses.length,
      itemBuilder: (context, index) {
        final addr = _addresses[index];
        return Card(
          margin: const EdgeInsets.all(10),
          child: ListTile(
            title: Text("${addr.name} - ${addr.phone}"),
            subtitle: Text(
                "${addr.detail}, ${addr.ward}, ${addr.district}, ${addr.province}"
                    "${addr.lat != null ? "\n(${addr.lat}, ${addr.lng})" : ""}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () async {
                    final edited = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddAddressScreen(
                          editAddress: addr,
                        ),
                      ),
                    );
                    if (edited != null) _editAddress(index, edited);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteAddress(index),
                ),
              ],
            ),
          ),
        );
      },
    ),
    floatingActionButton: FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () async {
        final newAddr = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddAddressScreen()),
        );
        if (newAddr != null) _addAddress(newAddr);
      },
    ),
  );
}
}

// ================== FORM ADD ADDRESS ==================
class AddAddressScreen extends StatefulWidget {
  final Address? editAddress;
  const AddAddressScreen({super.key, this.editAddress});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _detailCtrl = TextEditingController();

  String? _province;
  String? _district;
  String? _ward;
  double? lat;
  double? lng;

  final provinces = ["Hà Nội", "Hồ Chí Minh"];
  final districts = {
    "Hà Nội": ["Ba Đình", "Hoàn Kiếm"],
    "Hồ Chí Minh": ["Quận 1", "Quận 2"],
  };
  final wards = {
    "Ba Đình": ["Phúc Xá", "Ngọc Hà"],
    "Hoàn Kiếm": ["Hàng Bạc", "Hàng Buồm"],
    "Quận 1": ["Bến Nghé", "Bến Thành"],
    "Quận 2": ["Thảo Điền", "An Phú"],
  };

  @override
  void initState() {
    super.initState();
    if (widget.editAddress != null) {
      final a = widget.editAddress!;
      _nameCtrl.text = a.name;
      _phoneCtrl.text = a.phone;
      _detailCtrl.text = a.detail;
      _province = a.province;
      _district = a.district;
      _ward = a.ward;
      lat = a.lat;
      lng = a.lng;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Dialog(
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Add New Address",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),
                    const Divider(),
                    _buildTextField("Recipient Name", _nameCtrl),
                    _buildTextField("Phone Number", _phoneCtrl,
                        keyboard: TextInputType.phone,
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Required";
                          if (!RegExp(r'^[0-9]{10}$').hasMatch(v)) {
                            return "Phone must be 10 digits";
                          }
                          return null;
                        }),
                    _buildDropdown("Province/City", provinces, _province,
                            (v) => setState(() {
                          _province = v;
                          _district = null;
                          _ward = null;
                        })),
                    if (_province != null)
                _buildDropdown("District", districts[_province]!, _district,
                    (v) => setState(() {
                  _district = v;
                  _ward = null;
                })),
            if (_district != null)
        _buildDropdown("Ward", wards[_district]!, _ward,
            (v) => setState(() => _ward = v)),
    _buildTextField("Address Details", _detailCtrl,
    maxLines: 3, validator: (v) {
          if (v == null || v.isEmpty) return "Required";
          return null;
        }),
                        const SizedBox(height: 10),
                        const Text("Location on Map"),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              icon: const Icon(Icons.map),
                              label: const Text("Select on Map"),
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        MapPickerScreen(lat: lat, lng: lng),
                                  ),
                                );
                                if (result != null) {
                                  setState(() {
                                    lat = result["lat"];
                                    lng = result["lng"];
                                  });
                                }
                              },
                            ),
                            const SizedBox(width: 10),
                            Text(lat != null ? "($lat, $lng)" : "No location selected"),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              child: const Text("Cancel"),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              child: const Text("Save Address"),
                              onPressed: () {
                                if (_formKey.currentState!.validate() &&
                                    _province != null &&
                                    _district != null &&
                                    _ward != null) {
                                  final addr = Address(
                                    name: _nameCtrl.text,
                                    phone: _phoneCtrl.text,
                                    province: _province!,
                                    district: _district!,
                                    ward: _ward!,
                                    detail: _detailCtrl.text,
                                    lat: lat,
                                    lng: lng,
                                  );
                                  Navigator.pop(context, addr);
                                }
                              },
                            )
                          ],
                        )
                      ],
                    ),
                ),
            ),
        ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1,
        TextInputType keyboard = TextInputType.text,
        String? Function(String?)? validator}) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: TextFormField(
            controller: controller,
            maxLines: maxLines,
          keyboardType: keyboard,
          decoration: InputDecoration(labelText: label),
          validator: validator ?? (v) => v!.isEmpty ? "Required" : null,
        ),
    );
  }

  Widget _buildDropdown(
      String label, List<String> items, String? value, Function(String?) onCh) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onCh,
        decoration: InputDecoration(labelText: label),
        validator: (v) => v == null ? "Required" : null,
      ),
    );
  }
}

// ================== MAP PICKER SCREEN ==================
class MapPickerScreen extends StatefulWidget {
  final double? lat;
  final double? lng;
  const MapPickerScreen({super.key, this.lat, this.lng});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  final _searchCtrl = TextEditingController();
  double? _lat;
  double? _lng;

  @override
  void initState() {
    super.initState();
    _lat = widget.lat ?? 21.0285;
    _lng = widget.lng ?? 105.8542;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Dialog(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Select Location on Map",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
              const Divider(),
              Expanded(
                child: Container(
                  color: Colors.grey[200],
                  alignment: Alignment.center,
                  child: const Text("Map would be displayed here"),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
              Expanded(
              child: TextField(
              controller: _searchCtrl,
                decoration: const InputDecoration(
                  hintText: "Search for a location...",
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              child: const Text("Search"),
              onPressed: () {
                setState(() {
                  _lat = 10.762622;
                  _lng = 106.660172;
                });
              },
            )
                ],
              ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        child: const Text("Cancel"),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        child: const Text("Confirm Location"),
                        onPressed: () {
                          Navigator.pop(context, {"lat": _lat, "lng": _lng});
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
        ),
    );
  }
}
