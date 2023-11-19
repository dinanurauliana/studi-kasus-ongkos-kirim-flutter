import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';
import 'package:latihan_ongkos_kirim/app/data/models/city_model.dart';
import 'package:latihan_ongkos_kirim/app/data/models/province_model.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text(
          'ONGKOS KIRIM',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // PROVINCE
          DropdownSearch<Province>(
            popupProps: PopupProps.menu(
                showSearchBox: true,
                itemBuilder: (context, item, isSelected) => ListTile(
                      title: Text("${item.province}"),
                    )),
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                label: Text("Provinsi Asal"),
                border: OutlineInputBorder(),
              ),
            ),
            asyncItems: (text) async {
              var response = await http.get(
                  Uri.parse("https://api.rajaongkir.com/starter/province"),
                  headers: {"key": "c0da199848363eb45384a0d45fd536bf"});

              List body =
                  json.decode(response.body)["rajaongkir"]["results"] as List;

              var result = Province.fromJsonList(body);
              return result;
            },
            onChanged: (value) =>
                controller.provId.value = value!.provinceId ?? "0",
          ),
          const SizedBox(
            height: 20,
          ),
          DropdownSearch<City>(
            popupProps: PopupProps.menu(
                showSearchBox: true,
                itemBuilder: (context, item, isSelected) => ListTile(
                      title: Text("${item.type} ${item.cityName}"),
                    )),
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                label: Text("Kota/Kab Asal"),
                border: OutlineInputBorder(),
              ),
            ),
            asyncItems: (text) async {
              var response = await http.get(
                  Uri.parse(
                      "https://api.rajaongkir.com/starter/city?province=${controller.provId}"),
                  headers: {"key": "c0da199848363eb45384a0d45fd536bf"});

              List body =
                  json.decode(response.body)["rajaongkir"]["results"] as List;

              var result = City.fromJsonList(body);
              print(result);
              return result;
            },
            onChanged: (value) =>
                controller.cityId.value = value!.cityId ?? "0",
          ),
          const SizedBox(
            height: 20,
          ),
          DropdownSearch<Province>(
            popupProps: PopupProps.menu(
                showSearchBox: true,
                itemBuilder: (context, item, isSelected) => ListTile(
                      title: Text("${item.province}"),
                    )),
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                label: Text("Provinsi Tujuan"),
                border: OutlineInputBorder(),
              ),
            ),
            asyncItems: (text) async {
              var response = await http.get(
                  Uri.parse("https://api.rajaongkir.com/starter/province"),
                  headers: {"key": "c0da199848363eb45384a0d45fd536bf"});

              List body =
                  json.decode(response.body)["rajaongkir"]["results"] as List;

              var result = Province.fromJsonList(body);
              return result;
            },
            onChanged: (value) =>
                controller.provOriginId.value = value!.provinceId ?? "0",
          ),
          const SizedBox(
            height: 20,
          ),
          DropdownSearch<City>(
            popupProps: PopupProps.menu(
                showSearchBox: true,
                itemBuilder: (context, item, isSelected) => ListTile(
                      title: Text(" ${item.type} ${item.cityName}"),
                    )),
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                label: Text("Kota/Kab Asal"),
                border: OutlineInputBorder(),
              ),
            ),
            asyncItems: (text) async {
              var response = await http.get(
                  Uri.parse(
                      "https://api.rajaongkir.com/starter/city?province=${controller.provOriginId}"),
                  headers: {"key": "c0da199848363eb45384a0d45fd536bf"});

              List body =
                  json.decode(response.body)["rajaongkir"]["results"] as List;

              var result = City.fromJsonList(body);
              print(result);
              return result;
            },
            onChanged: (value) =>
                controller.cityOriginId.value = value!.cityId ?? "0",
          ),
          const SizedBox(
            height: 20,
          ),
          DropdownSearch<Map<String, dynamic>>(
            items: const [
              {
                "code": "jne",
                "name": "Jalur Nugraha Ekakurir (JNE)",
              },
              {
                "code": "pos",
                "name": "POS Indonesia",
              },
              {
                "code": "tiki",
                "name": "TIKI",
              },
            ],
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            popupProps: PopupProps.menu(
                showSearchBox: true,
                itemBuilder: (context, item, isSelected) => ListTile(
                      title: Text("${item['name']}"),
                    )),
            dropdownBuilder: (context, selectedItem) => Text(
              "${selectedItem?['name'] ?? 'Pilih Kurir'}",
              style: TextStyle(fontSize: 16),
            ),
            onChanged: (value) =>
                controller.courier.value = value?['code'] ?? '',
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: controller.weight,
            decoration: InputDecoration(
                labelText: "Berat(gram)", border: OutlineInputBorder()),
          ),

          const SizedBox(
            height: 20,
          ),

          Obx(() => ElevatedButton(
                onPressed: () {
                  if (controller.isLoading.isFalse) {
                    controller.onClick();
                  }
                },
                child: Text(
                  controller.isLoading.isFalse ? "CEK ONGKOS kIRIM" : 'Loading',
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.redAccent),
                ),
              ))
        ],
      ),
    );
  }
}
