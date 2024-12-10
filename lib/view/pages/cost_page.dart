part of 'pages.dart';

class CostPage extends StatefulWidget {
  const CostPage({super.key});

  @override
  State<CostPage> createState() => _CostPageState();
}

class _CostPageState extends State<CostPage> {
  final HomeViewmodel homeViewmodel = HomeViewmodel();

  // Origin selection
  dynamic selectedOriginProvince;
  dynamic selectedOriginCity;

  // Destination selection
  dynamic selectedDestinationProvince;
  dynamic selectedDestinationCity;

  // Courier and weight controllers
  final List<String> courierOptions = ['jne', 'pos', 'tiki'];
  String? selectedCourier;
  final TextEditingController weightController = TextEditingController();

  @override
  void initState() {
    homeViewmodel.getProvinceList();
    super.initState();
  }

  @override
  void dispose() {
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Calculate Shipping Cost"),
        centerTitle: true,
      ),
      body: ChangeNotifierProvider<HomeViewmodel>.value(
        value: homeViewmodel,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Origin Province Dropdown
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Origin",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Consumer<HomeViewmodel>(
                          builder: (context, value, _) {
                            switch (value.provinceList.status) {
                              case Status.loading:
                                return CircularProgressIndicator();
                              case Status.error:
                                return Text(value.provinceList.message.toString());
                              case Status.completed:
                                return DropdownButton<Province>(
                                  isExpanded: true,
                                  value: selectedOriginProvince,
                                  hint: Text('Select Origin Province'),
                                  items: value.provinceList.data!
                                      .map<DropdownMenuItem<Province>>((Province province) {
                                    return DropdownMenuItem<Province>(
                                      value: province,
                                      child: Text(province.province.toString()),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedOriginProvince = newValue;
                                      selectedOriginCity = null;
                                      homeViewmodel.getCityList(selectedOriginProvince.provinceId);
                                    });
                                  },
                                );
                              default:
                                return Container();
                            }
                          },
                        ),
                        SizedBox(height: 10),
                        // Origin City Dropdown
                        Consumer<HomeViewmodel>(
                          builder: (context, value, _) {
                            switch (value.cityList.status) {
                              case Status.loading:
                                return Text("Select a province first");
                              case Status.error:
                                return Text(value.cityList.message.toString());
                              case Status.completed:
                                return DropdownButton<City>(
                                  isExpanded: true,
                                  value: selectedOriginCity,
                                  hint: Text('Select Origin City'),
                                  items: value.cityList.data!
                                      .map<DropdownMenuItem<City>>((City city) {
                                    return DropdownMenuItem<City>(
                                      value: city,
                                      child: Text(city.cityName.toString()),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedOriginCity = newValue;
                                    });
                                  },
                                );
                              default:
                                return Container();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Destination Province Dropdown
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Destination",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Consumer<HomeViewmodel>(
                          builder: (context, value, _) {
                            switch (value.provinceList.status) {
                              case Status.loading:
                                return CircularProgressIndicator();
                              case Status.error:
                                return Text(value.provinceList.message.toString());
                              case Status.completed:
                                return DropdownButton<Province>(
                                  isExpanded: true,
                                  value: selectedDestinationProvince,
                                  hint: Text('Select Destination Province'),
                                  items: value.provinceList.data!
                                      .map<DropdownMenuItem<Province>>((Province province) {
                                    return DropdownMenuItem<Province>(
                                      value: province,
                                      child: Text(province.province.toString()),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedDestinationProvince = newValue;
                                      selectedDestinationCity = null;
                                      homeViewmodel.getCityList(selectedDestinationProvince.provinceId);
                                    });
                                  },
                                );
                              default:
                                return Container();
                            }
                          },
                        ),
                        SizedBox(height: 10),
                        // Destination City Dropdown
                        Consumer<HomeViewmodel>(
                          builder: (context, value, _) {
                            switch (value.cityList.status) {
                              case Status.loading:
                                return Text("Select a province first");
                              case Status.error:
                                return Text(value.cityList.message.toString());
                              case Status.completed:
                                return DropdownButton<City>(
                                  isExpanded: true,
                                  value: selectedDestinationCity,
                                  hint: Text('Select Destination City'),
                                  items: value.cityList.data!
                                      .map<DropdownMenuItem<City>>((City city) {
                                    return DropdownMenuItem<City>(
                                      value: city,
                                      child: Text(city.cityName.toString()),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedDestinationCity = newValue;
                                    });
                                  },
                                );
                              default:
                                return Container();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Weight and Courier Selection
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Shipping Details",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: weightController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: InputDecoration(
                            labelText: 'Weight (gram)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 10),
                        DropdownButton<String>(
                          isExpanded: true,
                          value: selectedCourier,
                          hint: Text('Select Courier'),
                          items: courierOptions
                              .map<DropdownMenuItem<String>>((String courier) {
                            return DropdownMenuItem<String>(
                              value: courier,
                              child: Text(courier.toUpperCase()),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedCourier = newValue;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Calculate Button
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: _calculateShippingCost,
                    child: Text('Calculate Shipping Cost'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),

                // Shipping Cost Result
                Consumer<HomeViewmodel>(
                  builder: (context, value, _) {
                    if (value.shippingCost.status == Status.completed) {
                      return Card(
                        color: Colors.green[50],
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Shipping Cost Results',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: value.shippingCost.data?.length ?? 0,
                                itemBuilder: (context, index) {
                                  var cost = value.shippingCost.data![index];
                                  return ListTile(
                                    title: Text(
                                      '${cost.service} (${cost.description})',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      'Cost: Rp ${cost.cost[0].value.toString()}',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    trailing: Text(
                                      'Est. ${cost.cost[0].etd} days',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (value.shippingCost.status == Status.error) {
                      return Card(
                        color: Colors.red[50],
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Error: ${value.shippingCost.message}',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      );
                    } else if (value.shippingCost.status == Status.loading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _calculateShippingCost() {
    // Validate all inputs
    if (selectedOriginCity == null || 
        selectedDestinationCity == null || 
        weightController.text.isEmpty || 
        selectedCourier == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all shipping details'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Call the shipping cost calculation method
    homeViewmodel.calculateShippingCost(
      originCityId: selectedOriginCity.cityId.toString(),
      destinationCityId: selectedDestinationCity.cityId.toString(),
      weight: int.parse(weightController.text),
      courier: selectedCourier!,
    );
  }
}