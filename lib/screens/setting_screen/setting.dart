import 'package:flutter/material.dart';
import 'package:note_encryption/encryption/rsa/rsa.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

// kunci DES
String desKey;

/// p dan q
BigInt nilaiP = BigInt.from(11);
BigInt nilaiQ = BigInt.from(13);
// nilai n
BigInt nilaiN;
// tosien n
BigInt nilaiR;
// kunci publik
BigInt nilaiE;

// kunci private
BigInt nilaiD;

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController _controller = TextEditingController(text: desKey);
  TextEditingController _p = TextEditingController(text: nilaiP.toString());
  TextEditingController _q = TextEditingController(text: nilaiQ.toString());

  // RSAKey rsa = RSAKey();
  // RSACripto r = RSACripto();
  RSA realRSA = RSA();

  // Tess Big Integer
  BigInt valueN() {
    var n = realRSA.fn(nilaiP, nilaiQ);
    return nilaiN = n;
  }

  BigInt valueR() {
    var r = realRSA.fr(nilaiP, nilaiQ);
    return nilaiR = r;
  }

  BigInt valueD() {
    BigInt d = realRSA.multInv(nilaiE, nilaiR);
    return nilaiD = d;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey[800]),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: GestureDetector(
        onDoubleTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[300].withOpacity(.2)),
                      child: Column(
                        children: [
                          Text(
                            "Setting DES Encryption",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1),
                          ),
                          SizedBox(height: 20),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 25),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[300].withOpacity(.2),
                            ),
                            child: Center(
                              child: TextField(
                                maxLength: 8,
                                controller: _controller,
                                onChanged: (text) {
                                  desKey = text;
                                },
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  hintText: 'Panjang Key harus 8 karakter',
                                  icon: Icon(Icons.lock),
                                  hintStyle: TextStyle(
                                      fontSize: 14, color: Colors.white30),
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 40),
                          // ElevatedButton(
                          //   onPressed: () async {},
                          //   child: Text("Simpan Key"),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[300].withOpacity(.2)),
                  child: Column(
                    children: [
                      Text(
                        "Setting RSA Encryption",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          /// Check box Nilai P
                          Container(
                            height: 50,
                            width: 80,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[300].withOpacity(.2)),
                            child: Center(
                              child: TextField(
                                controller: _p,
                                keyboardType: TextInputType.number,
                                onChanged: (text) {
                                  nilaiP = BigInt.tryParse(text);
                                },
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  hintText: 'Nilai P',
                                  hintStyle: TextStyle(
                                      fontSize: 14, color: Colors.white30),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),

                          /// Check box Nilai Q
                          Container(
                            height: 50,
                            width: 80,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[300].withOpacity(.2)),
                            child: Center(
                              child: TextField(
                                controller: _q,
                                keyboardType: TextInputType.number,
                                onChanged: (text) {
                                  nilaiQ = BigInt.tryParse(text);
                                },
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  hintText: 'Nilai Q',
                                  hintStyle: TextStyle(
                                      fontSize: 14, color: Colors.white30),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      Text("Nilai N = ${nilaiN ?? ""}"),
                      SizedBox(height: 10),
                      Text("Nilai R = ${nilaiR ?? ""}"),
                      SizedBox(height: 10),
                      Text("Nilai E = ${nilaiE ?? ""}"),
                      SizedBox(height: 10),
                      ElevatedButton(
                          onPressed: () {
                            valueN();
                            valueR();
                            for (BigInt i = BigInt.one;
                                i < BigInt.from(100);
                                i += BigInt.one) {
                              if (realRSA.egcd(i, nilaiR) == BigInt.one) {
                                nilaiE = i;
                              }
                            }
                            valueD();
                            print("nilai R = $nilaiR");
                            print("nilai E = $nilaiE");
                            print("nilai D = $nilaiD");
                            print("DES-Key = $desKey");

                            // show snackbar
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Berhasil Update Kunci"),
                              ),
                            );
                            setState(() {});
                          },
                          child: Text("Buat Kunci")),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                                "PublicKey = (${nilaiE ?? "0"},${nilaiN ?? "0"})"),
                            Text(
                                "PrivateKey = (${nilaiD ?? "0"},${nilaiN ?? "0"})"),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
