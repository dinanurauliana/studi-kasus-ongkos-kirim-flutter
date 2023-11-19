import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:latihan_ongkos_kirim/app/data/models/ongkir_model.dart';

class HomeController extends GetxController {
  TextEditingController weight = TextEditingController();
  RxString provId = "0".obs;
  RxString cityId = "0".obs;
  RxString provOriginId = "0".obs;
  RxString cityOriginId = "0".obs;
  RxString courier = "".obs;

  List<Ongkir> ongkir = [];

  RxBool isLoading = false.obs;

  void onClick() async {
    if (provId != "0" &&
        cityId != "0" &&
        provOriginId != "0" &&
        cityOriginId != "0") {
      try {
        isLoading.value = true;
        var response = await http.post(
            Uri.parse("https://api.rajaongkir.com/starter/cost"),
            headers: {
              "content-type": " application/x-www-form-urlencoded",
              "key": "c0da199848363eb45384a0d45fd536bf",
            },
            body: {
              "origin": provId.value,
              "destination": cityId.value,
              "weight": weight.text,
              "courier": courier.value
            });

        isLoading.value = false;
        List body = json.decode(response.body)["rajaongkir"]["results"][0]
            ["costs"] as List;

        ongkir = Ongkir.fromJsonList(body);
        Get.defaultDialog(
            titlePadding: EdgeInsets.all(20),
            title: "Cek Ongkos Kirim",
            content: Column(
              children: ongkir
                  .map((e) => ListTile(
                        title: Text("${e.service!.toUpperCase()}"),
                        subtitle: Text("${e.cost![0].value}"),
                      ))
                  .toList(),
            ));
      } catch (e) {
        print(e);
      }
    } else {
      Get.defaultDialog(
          titlePadding: EdgeInsets.all(16),
          title: "Terjadi Kesalahan",
          content: Text("Form tidak boleh Kosong"));
    }
  }
}
