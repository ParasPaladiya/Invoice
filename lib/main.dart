import 'package:flutter/material.dart';
import 'package:sticker_editor/product.dart';
import 'homepage.dart';

void main() {
  runApp(
    const HomePage(),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GetInvoice getInvoice = GetInvoice();
  TextStyle headStyle =
      const TextStyle(fontSize: 22, fontWeight: FontWeight.w500);
  List<Products> allProducts = [
    Products(productName: 'Laptop', productPrice: 75000),
    Products(productName: 'Tablet', productPrice: 7000),
    Products(productName: 'Jeans', productPrice: 1200),
    Products(productName: 'Headphone', productPrice: 1350),
    Products(productName: 'Bluetooth', productPrice: 700),
    Products(productName: 'Shoes', productPrice: 1800),
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Invoice Generator",
            style: TextStyle(fontSize: 26),
          ),
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
        ),
        backgroundColor: Colors.white10,
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                children: [
                  Text("Name", style: headStyle),
                  const Spacer(),
                  Text("Price", style: headStyle),
                  const Spacer(),
                  Text("Quantity", style: headStyle),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: allProducts.length,
                  itemBuilder: (context, i) {
                    final currentProduct = allProducts[i];
                    return Card(
                      color: Colors.grey,
                      child: Row(
                        children: [
                          const SizedBox(width: 4),
                          Text(
                            currentProduct.productName,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const Spacer(),
                          Text(
                            'Rs.${currentProduct.productPrice}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const Spacer(),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  if (currentProduct.productQuantity > 0) {
                                    currentProduct.productQuantity--;
                                  }
                                });
                              },
                              icon: const Icon(Icons.remove)),
                          Text(
                            '${currentProduct.productQuantity}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                currentProduct.productQuantity++;
                              });
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total:-', style: headStyle),
                      Text('Rs.${getTotal()}', style: headStyle),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final invoice = await getInvoice.getInvoice(allProducts);
                      getInvoice.openPDF(invoice);
                    },
                    child: const Text('Invoice'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  getTotal() => allProducts
      .fold(
        0,
        (int prev, element) =>
            prev + (element.productPrice * element.productQuantity),
      )
      .toStringAsFixed(0);
}
