
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rustore_update/flutter_rustore_update.dart';
import 'package:showcase_front/constants/fonts.dart';


// https://www.rustore.ru/help/sdk/updates/flutter/6-0-0

class Rustore {

  Future rustoreInfo(BuildContext context) async {
    RustoreUpdateClient.info().then((info) {
        log('${info.updateAvailability}', name: "RuStore");
        // 
        switch (info.updateAvailability){
          case 1:
            log('обновление не требуется', name: 'RuStore Update');
          case 2:
            // return showProductCard(context);
            immediateUpdate();
        }
    }).catchError((err) {
      log(err.toString(), name: 'RuStore ERROR');
    });
  }


  Future immediateUpdate() async {
    return RustoreUpdateClient.immediate();
  }

}

void showProductCard(BuildContext mainContext) {
    showModalBottomSheet(
      isScrollControlled: false,
      backgroundColor: Colors.transparent,
      context: mainContext,
      builder: (context) {
        return Container(
          width: double.infinity,
          height: 300,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0)),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: Image.asset('lib/images/ru_store.png', scale: 10),
              ),
              const Divider(indent: 15, endIndent: 15, color: Colors.grey, height: 30,),
              SizedBox(
                width: double.infinity,
                child: Center(
                  child: Text(
                    '',
                    style: black(18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }