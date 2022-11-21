part of 'pages.dart';

class Ongkirpage extends StatefulWidget {
  const Ongkirpage({Key? key}) : super(key: key);

  @override
  State<Ongkirpage> createState() => _OngkirpageState();
}

class _OngkirpageState extends State<Ongkirpage> {
  String selectedKurir = 'jne';
  var kurir = ['jne', 'pos', 'tiki'];
  var isLoading = false;

  final ctrlBerat = TextEditingController();

  dynamic provIdOrigin;
  dynamic provIdDestination;
  dynamic provinceDataOrigin;
  dynamic provinceDataDestination;
  dynamic selectedProvOrigin;
  dynamic selectedProvDestination;

  Future<List<Province>> getProvinces() async {
    dynamic listProvince;
    await MasterDataService.getProvince().then((value) {
      setState(() {
        listProvince = value;
      });
    });

    return listProvince;
  }

  dynamic cityDataOrigin;
  dynamic cityDataDestination;
  dynamic selectedCityOrigin;
  dynamic selectedCityDestination;

  Future<List<City>> getCities(dynamic provId) async {
    dynamic listCity;
    await MasterDataService.getCity(provId).then((value) {
      setState(() {
        listCity = value;
      });
    });

    return listCity;
  }

  List<Costs> listCosts = [];
  Future<dynamic> getCostsData() async {
    await RajaOngkirService.getMyOngkir(selectedCityOrigin.cityId, selectedCityDestination.cityId, int.parse(ctrlBerat.text), selectedKurir).then((value) {
      setState(() {
        listCosts = value;
        isLoading = false;
      });
      print(listCosts.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    provinceDataOrigin = getProvinces();
    provinceDataDestination = getProvinces();
  }

  void handleButtonPress() {
    if (selectedCityDestination == null && selectedCityOrigin == null) {
      Fluttertoast.showToast(
          msg: "Origin dan destination city masih belum diset!",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.white,
          backgroundColor: Colors.red);
    } else if (selectedCityOrigin == null) {
      Fluttertoast.showToast(
          msg: "Origin city masih belum diset!",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.white,
          backgroundColor: Colors.red);
    } else if (selectedCityDestination == null) {
      Fluttertoast.showToast(
          msg: "Destination city masih belum diset!",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.white,
          backgroundColor: Colors.red);
    } else {
      Fluttertoast.showToast(
          msg:
              "Origin: ${selectedCityOrigin.cityName}, Destination: ${selectedCityDestination.cityName}",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.white,
          backgroundColor: Colors.green);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Raja Ongkir"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                Flexible(
                  flex: 3,
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DropdownButton(
                                  value: selectedKurir,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  items: kurir.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(items),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedKurir = newValue!;
                                    });
                                  }),
                              SizedBox(
                                width: 200,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: ctrlBerat,
                                  decoration: const InputDecoration(
                                      labelText: 'Berat (gr)'),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    return value == null || value == 0
                                        ? 'Berat harus diisi atau tidak boleh 0!'
                                        : null;
                                  },
                                ),
                              )
                            ],
                          )),
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Origin",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 1,
                              child: FutureBuilder<List<Province>>(
                                future: provinceDataOrigin,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.connectionState ==
                                          ConnectionState.done) {
                                    return DropdownButton(
                                        isExpanded: true,
                                        value: selectedProvOrigin,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        iconSize: 30,
                                        elevation: 16,
                                        style: const TextStyle(
                                            color: Colors.black),
                                        hint: selectedProvOrigin == null
                                            ? const Text('Pilih provinsi!')
                                            : Text(selectedProvOrigin.province),
                                        items: snapshot.data!
                                            .map<DropdownMenuItem<Province>>(
                                                (Province value) {
                                          return DropdownMenuItem(
                                              value: value,
                                              child: Text(
                                                  value.province.toString()));
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedProvOrigin = newValue;
                                            provIdOrigin =
                                                selectedProvOrigin.provinceId;
                                          });
                                          selectedCityOrigin = null;
                                          cityDataOrigin =
                                              getCities(provIdOrigin);
                                        });
                                  } else if (snapshot.hasError) {
                                    return const Text("Tidak ada data.");
                                  }
                                  return SizedBox(
                                      width: double.infinity,
                                      child: Uiloading.loadingDD());
                                },
                              ),
                            ),
                            const SizedBox(width: 20),
                            Flexible(
                              flex: 1,
                              child: FutureBuilder<List<City>>(
                                future: cityDataOrigin,
                                builder: (context, snapshot) {
                                  if (selectedProvOrigin != null) {
                                    if (snapshot.hasData &&
                                        snapshot.connectionState ==
                                            ConnectionState.done) {
                                      return DropdownButton(
                                          isExpanded: true,
                                          value: selectedCityOrigin,
                                          icon:
                                              const Icon(Icons.arrow_drop_down),
                                          iconSize: 30,
                                          elevation: 16,
                                          style: const TextStyle(
                                              color: Colors.black),
                                          hint: selectedCityOrigin == null
                                              ? const Text('Pilih kota!')
                                              : Text(
                                                  selectedCityOrigin.cityName),
                                          items: snapshot.data!
                                              .map<DropdownMenuItem<City>>(
                                                  (City value) {
                                            return DropdownMenuItem(
                                                value: value,
                                                child: Text(
                                                    value.cityName.toString()));
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              selectedCityOrigin = newValue;
                                            });
                                          });
                                    } else if (snapshot.hasError) {
                                      return const Text("Tidak ada data.");
                                    }
                                    return SizedBox(
                                        width: double.infinity,
                                        child: Uiloading.loadingDD());
                                  }
                                  return const SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        "Pilih provinsi dulu!",
                                        textAlign: TextAlign.center,
                                      ));
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Destination",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 1,
                              child: FutureBuilder<List<Province>>(
                                future: provinceDataDestination,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.connectionState ==
                                          ConnectionState.done) {
                                    return DropdownButton(
                                        isExpanded: true,
                                        value: selectedProvDestination,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        iconSize: 30,
                                        elevation: 16,
                                        style: const TextStyle(
                                            color: Colors.black),
                                        hint: selectedProvDestination == null
                                            ? const Text('Pilih provinsi!')
                                            : Text(selectedProvDestination
                                                .province),
                                        items: snapshot.data!
                                            .map<DropdownMenuItem<Province>>(
                                                (Province value) {
                                          return DropdownMenuItem(
                                              value: value,
                                              child: Text(
                                                  value.province.toString()));
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedProvDestination = newValue;
                                            provIdDestination =
                                                selectedProvDestination
                                                    .provinceId;
                                          });
                                          selectedCityDestination = null;
                                          cityDataDestination =
                                              getCities(provIdDestination);
                                        });
                                  } else if (snapshot.hasError) {
                                    return const Text("Tidak ada data.");
                                  }
                                  return SizedBox(
                                      width: double.infinity,
                                      child: Uiloading.loadingDD());
                                },
                              ),
                            ),
                            const SizedBox(width: 20),
                            Flexible(
                              flex: 1,
                              child: FutureBuilder<List<City>>(
                                future: cityDataDestination,
                                builder: (context, snapshot) {
                                  if (selectedProvDestination != null) {
                                    if (snapshot.hasData &&
                                        snapshot.connectionState ==
                                            ConnectionState.done) {
                                      return DropdownButton(
                                          isExpanded: true,
                                          value: selectedCityDestination,
                                          icon:
                                              const Icon(Icons.arrow_drop_down),
                                          iconSize: 30,
                                          elevation: 16,
                                          style: const TextStyle(
                                              color: Colors.black),
                                          hint: selectedCityDestination == null
                                              ? const Text('Pilih kota!')
                                              : Text(selectedCityDestination
                                                  .cityName),
                                          items: snapshot.data!
                                              .map<DropdownMenuItem<City>>(
                                                  (City value) {
                                            return DropdownMenuItem(
                                                value: value,
                                                child: Text(
                                                    value.cityName.toString()));
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              selectedCityDestination =
                                                  newValue;
                                            });
                                          });
                                    } else if (snapshot.hasError) {
                                      return const Text("Tidak ada data.");
                                    }
                                    return SizedBox(
                                        width: double.infinity,
                                        child: Uiloading.loadingDD());
                                  }
                                  return const SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        "Pilih provinsi dulu!",
                                        textAlign: TextAlign.center,
                                      ));
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // handleButtonPress();
                          // if (selectedCityOrigin == null || selectedCityDestination == null || selectedKurir.isEmpty || ctrlBerat.text.isEmpty) {
                          //   UiToast.toastErr('Semua field harus diisi');
                          // } else {
                          //   setState(() {
                          //     isLoading = true;
                          //   });
                          //   getCostsData();
                          // }
                          MasterDataService.getMahasiswa();
                        },
                        child: const Text(
                          'Hitung Estimasi Harga',
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: listCosts.isEmpty ?
                    const Align(alignment: Alignment.center, child: Text("Tidak ada data.")) :
                    ListView.builder(
                      itemCount: listCosts.length,
                      itemBuilder: (context, index) {
                        return LazyLoadingList(
                            loadMore: () {},
                            index: index,
                            hasMore: true,
                            child: CardOngkir(listCosts[index])
                        );
                      },
                    ),
                  )
                )
              ],
            ),
          ),
          isLoading == true ? Uiloading.loadingBlock() : Container(),
        ],
      ),
    );
  }
}
