import 'package:appfres/widgets/default.colors.dart';
import 'package:appfres/widgets/mydrawer.dart';
import 'package:flutter/material.dart';

class RecherchePage extends StatefulWidget {
  const RecherchePage({super.key});

  @override
  State<RecherchePage> createState() => _RecherchePageState();
}

class _RecherchePageState extends State<RecherchePage> {
  TextEditingController searchController = TextEditingController();
  List<String> zrost_ddelControllerValue = ['client', 'contract'];
  TextEditingController contractController = TextEditingController();
  TextEditingController clientController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Defaults.blueAppBar,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recherche par '),
            // Text(
            //   '$_countCustomerPay/$_countCustomer',
            //   style: TextStyle(color: Colors.white),
            // )
          ],
        ),
        centerTitle: true,
      ),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    fillColor: Defaults.white,
                    filled: true,
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Defaults.white, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Defaults.white, width: 2),
                    ),
                  ),
                  value: contractController.text.isNotEmpty
                      ? contractController.text
                      : null,
                  hint: const Text('Select an option'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Select an option';
                    }
                    return null;
                  },
                  items: zrost_ddelControllerValue.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      contractController.text = newValue!;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Ajoutez les champs supplémentaires en fonction de la sélection
          if (contractController.text == 'client') ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: clientController,
                autocorrect: false,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Defaults.white,
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.search),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        width: 1, color: Defaults.white), //<-- SEE HERE
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 1, color: Defaults.white),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  hintText: 'Enter client number',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter client number';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.send),
                label: Text('Search'),
              ),
            ),
          ],
          if (contractController.text == 'contract') ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: clientController,
                autocorrect: false,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Defaults.white,
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.search),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        width: 1, color: Defaults.white), //<-- SEE HERE
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 1, color: Defaults.white),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  hintText: 'Enter contract number',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter contract number';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.send),
                label: Text('Search'),
              ),
            ),
            SafeArea(
                child: Column(
              children: [],
            ))
          ],
        ],
      ),
    );
  }
}
