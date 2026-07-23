import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  home: HaritiiLoginScreen(),
  theme: ThemeData(primarySwatch: Colors.green),
  debugShowCheckedModeBanner: false,
));

// 1. የመግቢያ ገጽ
class HaritiiLoginScreen extends StatelessWidget {
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delivery_dining, size: 100, color: Colors.green[700]),
            SizedBox(height: 10),
            Text("Haritii Delivery", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green[700])),
            SizedBox(height: 30),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "ስልክ ቁጥርዎን ያስገቡ",
                prefixText: "+251 ",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HaritiiHomeScreen()));
                },
                child: Text("ቀጥል (Continue)", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 2. ዋናው ገጽ (4ቱ ምድቦች)
class HaritiiHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Haritii Delivery', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.red),
                  SizedBox(width: 5),
                  Text("አዳማ፣ ኢትዮጵያ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(color: Colors.green[100], borderRadius: BorderRadius.circular(15)),
                child: Center(child: Text("ሀሪቲ ኤክስፕረስ - በ30 ደቂቃ እጅዎ ይገባል!", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green[800]))),
              ),
              SizedBox(height: 25),
              Text("ምን ማዘዝ ይፈልጋሉ?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 15),
              GridView.count(
                crossAxisCount: 2, shrinkWrap: true, physics: NeverScrollableScrollPhysics(),
                crossAxisSpacing: 15, mainAxisSpacing: 15,
                children: [
                  _buildCard(context, "ሬስቶራንት", Icons.fastfood),
                  _buildCard(context, "ጫት ቤት", Icons.eco),
                  _buildCard(context, "ሱፐርማርኬት", Icons.shopping_cart),
                  _buildCard(context, "ግሮሰሪ", Icons.local_drink),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, IconData icon) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => HaritiiCheckoutScreen(category: title)));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.green, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.green[700]),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[700])),
          ],
        ),
      ),
    );
  }
}

// 3. የማዘዣ ገጽ (Checkout)
class HaritiiCheckoutScreen extends StatefulWidget {
  final String category;
  HaritiiCheckoutScreen({required this.category});

  @override
  _HaritiiCheckoutScreenState createState() => _HaritiiCheckoutScreenState();
}

class _HaritiiCheckoutScreenState extends State<HaritiiCheckoutScreen> {
  String _selectedSpeed = 'standard';
  String _selectedKhatType = 'በለጬ';
  bool _includeWater = false;
  double basePrice = 500.0;

  double get deliveryFee {
    if (_selectedSpeed == 'super_express') return 150.0;
    if (_selectedSpeed == 'scheduled') return 60.0;
    return 90.0;
  }

  double get finalPrice {
    double total = basePrice + deliveryFee;
    if (widget.category == "ጫት ቤት" && _includeWater) {
      total += 50.0;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.category} ማዘዣ'), backgroundColor: Colors.green[700]),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.category == "ጫት ቤት") ...[
              Text("የጫት አይነት ይምረጡ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedKhatType,
                decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                items: ['በለጬ', 'ቢስማር', 'ወንዶ', 'መጢቾ', 'ልዩ', 'ገለምሶ'].map((String type) {
                  return DropdownMenuItem<String>(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) {
                  setState(() { _selectedKhatType = value!; });
                },
              ),
              SizedBox(height: 15),
              CheckboxListTile(
                title: Text("ውሃ ይጨመርበት? (+50 ብር)"),
                value: _includeWater,
                activeColor: Colors.green[700],
                onChanged: (bool? value) {
                  setState(() { _includeWater = value!; });
                },
              ),
              Divider(thickness: 1),
            ],

            Text("የማድረሻ ፍጥነት ይምረጡ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            RadioListTile(
              title: Text("ሱፐር ኤክስፕረስ (ከ20-30 ደቂቃ)"), subtitle: Text("+150 ብር"),
              value: 'super_express', groupValue: _selectedSpeed,
              onChanged: (v) => setState(() => _selectedSpeed = v.toString()),
            ),
            RadioListTile(
              title: Text("መደበኛ ዴሊቨሪ (ከ45-60 ደቂቃ)"), subtitle: Text("+90 ብር"),
              value: 'standard', groupValue: _selectedSpeed,
              onChanged: (v) => setState(() => _selectedSpeed = v.toString()),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("አጠቃላይ ሂሳብ:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("$finalPrice ብር", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green[700])),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.phone, color: Colors.white),
                    label: Text("ለአሽከርካሪ ደውል", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[700]),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ወደ አሽከርካሪው በመደወል ላይ...')));
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
                    onPressed: () {
                      String msg = widget.category == "ጫት ቤት" 
                          ? "ትዕዛዝ ተልኳል! ($_selectedKhatType)" 
                          : "ትዕዛዝዎ ተልኳል!";
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                    },
                    child: Text("ትዕዛዝ አጠናቅ", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}