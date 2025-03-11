import 'package:ai_text_extracter_app/constants/colors.dart';
import 'package:ai_text_extracter_app/models/conversion_model.dart';
import 'package:ai_text_extracter_app/services/store_conversions_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserHistory extends StatelessWidget {
  const UserHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "User History",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: StreamBuilder<List<ConversionModel>>(
        stream: StoreConversionsFirestore().getUserConversions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: const CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          final List<ConversionModel>? userConversion = snapshot.data;
          if (userConversion == null || userConversion.isEmpty) {
            return Center(
              child: Text("No Conversions"),
            );
          }
          return ListView.builder(
            itemCount: userConversion.length,
            itemBuilder: (context, index) {
              final ConversionModel conversion = userConversion[index];
              return Container(
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: mainColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          conversion.conversionData.length > 10
                              ? ".... ${conversion.conversionData.substring(0, 15)} ...."
                              : conversion.conversionData,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          conversion.conversionData.length > 200
                              ? "${conversion.conversionData.substring(0, 200)}........"
                              : conversion.conversionData,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            conversion.conversionDate
                                .toLocal()
                                .toString()
                                .split(' ')[0],
                          ),
                          IconButton(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(
                                    text: conversion.conversionData));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text("Conversion copied successfully"),
                                  ),
                                );
                              },
                              icon: Icon(Icons.copy))
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
