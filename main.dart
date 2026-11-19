import 'package:flutter/material.dart';

void main() {
  runApp(ShoppingHubApp());
}

List<Map<String, dynamic>> cartItems = []; // GLOBAL CART
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class ShoppingHubApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SHOPPING HUB',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldMessengerKey,
      theme: ThemeData(primaryColor: Colors.amber, appBarTheme: AppBarTheme(backgroundColor: Colors.amber, foregroundColor: Colors.black)),
      home: LoginScreen(),
    );
  }
}

// 1. LOGIN
class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SHOPPING HUB')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 80),
            Icon(Icons.shopping_cart, size: 70),
            SizedBox(height: 20),
            Text('SHOPPING HUB', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 30),
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
            SizedBox(height: 15),
            TextField(controller: passController, obscureText: true, decoration: InputDecoration(labelText: 'Password', border: OutlineInputBorder())),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen(index: 0)));
                },
                child: Text('LOGIN', style: TextStyle(fontSize: 16)),
              ),
            ),
            SizedBox(height: 10),
            // FORGOT PASSWORD - LOGIN KE NEECHE
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
                },
                child: Text('Forgot Password?', style: TextStyle(color: Colors.amber[800], fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 1.5 FORGOT PASSWORD SCREEN
class ForgotPasswordScreen extends StatefulWidget {
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  void _resetPassword() {
    if(emailController.text.isEmpty) {
      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(content: Text('Please enter your email'))
      );
      return;
    }
    setState(() => isLoading = true);
    Future.delayed(Duration(seconds: 2), () {
      setState(() => isLoading = false);
      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(content: Text('Password reset link sent to ${emailController.text}'))
      );
      Navigator.pop(context);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('FORGOT PASSWORD')),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            Center(child: Icon(Icons.lock_reset, size: 70, color: Colors.amber)),
            SizedBox(height: 20),
            Center(child: Text('Reset Your Password', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
            SizedBox(height: 10),
            Center(child: Text('Enter your email and we will send you a link', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[700]))),
            SizedBox(height: 30),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder(), prefixIcon: Icon(Icons.email)),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : _resetPassword,
                child: isLoading 
                  ? CircularProgressIndicator(color: Colors.white) 
                  : Text('SEND RESET LINK', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 2. MAIN SCREEN WITH BOTTOM NAV + DRAWER
class MainScreen extends StatefulWidget {
  final int index;
  MainScreen({this.index = 0});
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
  }

  Widget _getPage(int index) {
    if(index == 0) return HomeScreen();
    if(index == 1) return BasketScreen();
    if(index == 2) return PaymentScreen();
    return HomeScreen();
  }

  void _logout() {
    cartItems.clear();
    Navigator.pushAndRemoveUntil(
      context, 
      MaterialPageRoute(builder: (context) => LoginScreen()), 
      (route) => false
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SHOPPING HUB'),
        actions: [
          Stack(
            children: [
              IconButton(icon: Icon(Icons.shopping_cart, size: 26), onPressed: (){setState((){currentIndex=1;});}),
              if(cartItems.length > 0)
                Positioned(right: 6, top: 6, child: CircleAvatar(radius: 8, backgroundColor: Colors.red, child: Text('${cartItems.length}', style: TextStyle(fontSize: 10, color: Colors.white))))
            ],
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.amber),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.shopping_cart, size: 50, color: Colors.black),
                  SizedBox(height: 10),
                  Text('SHOPPING HUB', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                ],
              ),
            ),
            ListTile(leading: Icon(Icons.home), title: Text('Home'), onTap: () {Navigator.pop(context); setState(() => currentIndex = 0);}),
            ListTile(leading: Icon(Icons.shopping_basket), title: Text('Basket'), onTap: () {Navigator.pop(context); setState(() => currentIndex = 1);}),
            ListTile(leading: Icon(Icons.payment), title: Text('Payment'), onTap: () {Navigator.pop(context); setState(() => currentIndex = 2);}),
            Divider(),
            ListTile(leading: Icon(Icons.logout, color: Colors.red), title: Text('Logout', style: TextStyle(color: Colors.red)), onTap: _logout),
          ],
        ),
      ),
      body: _getPage(currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.amber,
        iconSize: 26,
        type: BottomNavigationBarType.fixed,
        onTap: (index) { setState(() { currentIndex = index; }); },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'menu'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_basket), label: 'Basket'),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Payment'),
        ],
      ),
    );
  }
}

// 3. HOME - CATEGORIES
class HomeScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Container(width: double.infinity, padding: EdgeInsets.all(10), decoration: BoxDecoration(border: Border.all()), child: Text('CATEGORIES', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
          SizedBox(height: 15),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.9,
              children: [
                categoryBox(context, 'KITCHEN', Icons.kitchen),
                categoryBox(context, 'CLEANING', Icons.cleaning_services),
                categoryBox(context, 'BOOKS', Icons.menu_book, true),
                categoryBox(context, 'GROCERY', Icons.local_grocery_store),
                categoryBox(context, 'DAIRY', Icons.egg),
                categoryBox(context, 'STATIONARY', Icons.book),
                categoryBox(context, 'SNACKS', Icons.fastfood),
                categoryBox(context, 'HOUSE', Icons.house),
                categoryBox(context, 'MORE', Icons.more_horiz),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget categoryBox(BuildContext context, String name, IconData icon, [bool isBooks = false]) {
    return InkWell(
      onTap: () {
        if(isBooks) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => BooksCategoryScreen()));
        }
      },
      child: Container(
        decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.all(8),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 40),
          SizedBox(height: 6),
          Text(name, textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }
}

// 4. BOOKS CATEGORY SCREEN
class BooksCategoryScreen extends StatefulWidget {
  State<BooksCategoryScreen> createState() => _BooksCategoryScreenState();
}

class _BooksCategoryScreenState extends State<BooksCategoryScreen> {
  int currentIndex = 0;
  final List<Map<String, dynamic>> bookCategories = [
    {'name': 'Fantasy', 'icon': Icons.auto_awesome},
    {'name': 'Science Fiction', 'icon': Icons.rocket},
    {'name': 'Mystery', 'icon': Icons.search},
    {'name': 'Horror', 'icon': Icons.nightlight},
    {'name': 'History', 'icon': Icons.history_edu},
  ];
  void _showSnack(String msg) {
    scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(content: Text(msg), duration: Duration(seconds: 1)));
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('BOOKS')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Container(width: double.infinity, padding: EdgeInsets.all(10), decoration: BoxDecoration(border: Border.all()), child: Text('BOOKS', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
            SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: bookCategories.length,
                itemBuilder: (context, index) {
                  final category = bookCategories[index];
                  return InkWell(
                    onTap: () {
                      if(category['name'] == 'Horror') {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HorrorBooksScreen()));
                      } else {
                        _showSnack('${category['name']} books coming soon');
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 12),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          Icon(category['icon'], size: 35),
                          SizedBox(width: 12),
                          Expanded(child: Text(category['name'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                          Icon(Icons.arrow_forward_ios, size: 20)
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.amber,
        iconSize: 26,
        type: BottomNavigationBarType.fixed,
        onTap: (index) { 
          if(index == 0) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen(index: 0)));
          if(index == 1) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen(index: 1)));
          if(index == 2) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen(index: 2)));
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'menu'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_basket), label: 'Basket'),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Payment'),
        ],
      ),
    );
  }
}

// 5. HORROR BOOKS LIST
class HorrorBooksScreen extends StatefulWidget {
  State<HorrorBooksScreen> createState() => _HorrorBooksScreenState();
}

class _HorrorBooksScreenState extends State<HorrorBooksScreen> {
  int currentIndex = 0;
  final List<Map<String, dynamic>> horrorBooks = [
    {'name': 'IT', 'price': 600, 'author': 'Stephen King'},
    {'name': 'The Shining', 'price': 550, 'author': 'Stephen King'},
    {'name': 'Dracula', 'price': 500, 'author': 'Bram Stoker'},
    {'name': 'The Haunting of Hill House', 'price': 650, 'author': 'Shirley Jackson'},
  ];
  void _addToCart(Map<String, dynamic> book) {
    setState(() {cartItems.add(book);});
    scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(content: Text('${book['name']} added to cart'), duration: Duration(seconds: 1)));
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('HORROR BOOKS')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Container(width: double.infinity, padding: EdgeInsets.all(10), decoration: BoxDecoration(border: Border.all()), child: Text('HORROR', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
            SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: horrorBooks.length,
                itemBuilder: (context, index) {
                  final book = horrorBooks[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        Icon(Icons.book, size: 35),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(book['name'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Text('By: ${book['author']}', style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                            Text('${book['price']} RS', style: TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold)),
                          ]),
                        ),
                        ElevatedButton(onPressed: () => _addToCart(book), child: Text('Add'), style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black))
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.amber,
        iconSize: 26,
        type: BottomNavigationBarType.fixed,
        onTap: (index) { 
          if(index == 0) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen(index: 0)));
          if(index == 1) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen(index: 1)));
          if(index == 2) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen(index: 2)));
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'menu'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_basket), label: 'Basket'),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Payment'),
        ],
      ),
    );
  }
}

// 6. BASKET
class BasketScreen extends StatefulWidget {
  State<BasketScreen> createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen> {
  int total() {
    int sum = 0;
    for(var item in cartItems) { sum += item['price'] as int; }
    return sum;
  }
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Text('CART', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 15),
          Expanded(
            child: cartItems.length == 0 
            ? Center(child: Text('Cart is Empty'))
            : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(icon: Icon(Icons.close, size: 24), onPressed: (){setState((){cartItems.removeAt(index);});}),
                      Expanded(child: Text(item['name'], style: TextStyle(fontSize: 15))),
                      Text('${item['price']} RS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              },
            ),
          ),
          Text('TOTAL: ${total()} RS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity, height: 50,
            child: ElevatedButton(
              onPressed: () {
                if(cartItems.length > 0) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen()));
                } else {
                  scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(content: Text('Cart is empty')));
                }
              },
              child: Text('PROCEED TO CHECK OUT', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

// 7. PAYMENT
class PaymentScreen extends StatefulWidget {
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String payment = 'Card';
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PAYMENT')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('ADDRESS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          TextField(decoration: InputDecoration(border: OutlineInputBorder())),
          SizedBox(height: 15),
          Text('PAYMENT METHOD', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          RadioListTile<String>(title: Text('Card'), value: 'Card', groupValue: payment, onChanged: (val) => setState(() => payment = val!)),
          RadioListTile<String>(title: Text('Cash on delivery'), value: 'COD', groupValue: payment, onChanged: (val) => setState(() => payment = val!)),
          TextField(decoration: InputDecoration(labelText: 'Phone', border: OutlineInputBorder())),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity, height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => OrderCompletedScreen()));
                cartItems.clear();
              },
              child: Text('PLACE ORDER', style: TextStyle(fontSize: 16)),
            ),
          ),
          SizedBox(height: 20),
        ]),
      ),
    );
  }
}

// 8. ORDER COMPLETED
class OrderCompletedScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SHOPPING HUB')),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.check_circle, size: 70, color: Colors.green),
          SizedBox(height: 15),
          Text('ORDER COMPLETED', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Container(padding: EdgeInsets.all(16), decoration: BoxDecoration(border: Border.all()), child: Text('YOUR ORDER WILL BE\nDELIVERED ON\n05-10-2026', textAlign: TextAlign.center, style: TextStyle(fontSize: 16))),
          SizedBox(height: 20),
          ElevatedButton(onPressed: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen(index: 0)));}, child: Text('Continue Shopping'))
        ]),
      ),
    );
  }
}