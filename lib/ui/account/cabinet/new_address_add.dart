


import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:showcase_front/constants/fonts.dart';

newAddressAdd(BuildContext mainContext, TextEditingController controller){
  return showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    context: mainContext, 
    builder: (context){
      return SizedBox(
        height: 280,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 220,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0)),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 40,),
                  Align(
                    alignment: Alignment.center, 
                    child: Text('введите новый адрес', style: darkCategory(18, FontWeight.bold),)
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 35, right: 35, top: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Colors.transparent
                        ),
                        color: Colors.white,
                      ),
                      height: 45,
                      width: 300,
                      child: TextField(
                        autofocus: true,
                        controller: controller,
                        style: black(20),
                        minLines: 1,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          focusedBorder:OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.green, width: 2.0),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          hintStyle: grey(18),
                          hintText: 'новый адрес',
                          prefixIcon: Icon(MdiIcons.map, color: Colors.grey,),
                          isCollapsed: true
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async { 
                        Navigator.pop(context);
                      }, 
                      child: Text('добавить', style: black(16),)
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: const SizedBox(height: 10),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Image.asset('lib/images/map.png', scale: 8,)
            ),
          ],
        ),
      );
    }
  );
}