part of 'pages.dart';

class Mahasiswapage extends StatefulWidget {
  const Mahasiswapage({Key? key}) : super(key: key);

  @override
  State<Mahasiswapage> createState() => _MahasiswapageState();
}

class _MahasiswapageState extends State<Mahasiswapage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Golang Gin-Gonic"),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    await MasterDataService.getMahasiswa();
                  },
                  child: const Text("Get Data Mahasiswa")
              ),
              ElevatedButton(
                  onPressed: () async {
                    await MasterDataService.addMahasiswa();
                  },
                  child: const Text("Add Data Mahasiswa")
              ),
              ElevatedButton(
                  onPressed: () async {
                    await MasterDataService.updateMahasiswa();
                  },
                  child: const Text("Update Data Mahasiswa")
              ),
            ],
          ),
        ),
      ),
    );
  }
}
