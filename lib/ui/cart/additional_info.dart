
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:showcase_front/constants/fonts.dart';

import '../../data/providers.dart';
import '../../data/repositories/backend_implements.dart';
import '../account/cabinet/new_address_add.dart';
import '../widgets/scaffold_messenger.dart';




class AdditionalInfo extends ConsumerStatefulWidget {
  const AdditionalInfo({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AdditionalInfoState();
}

class _AdditionalInfoState extends ConsumerState<AdditionalInfo> {

  TextEditingController newAddressController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  final BackendImplements backend = BackendImplements();
  int shipsID = 0;

  @override
  void dispose(){
    commentController.dispose();
    newAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      barrierColor: Colors.white.withOpacity(0.7),
      padding: const EdgeInsets.all(20.0),
      child: Consumer(
        builder: (context, ref, child) {
          return ref.watch(getAddressProvider).when(
            loading: () => Container(),
            error: (error, _) => Center(child: Text(error.toString())),
            data: (_){
              final adresses = ref.watch(addressProvider);
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0)),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(height: 40,),
                      Align(
                        alignment: Alignment.centerLeft, 
                        child: Text('Почти готово!', style: black(18, FontWeight.bold),)
                      ),
                      const SizedBox(height: 5,),
                      Align(
                        alignment: Alignment.centerLeft, 
                        child: Text('Вы можете изменить адрес доставки, нажав на него, и оставить короткий комментарий к заказу, или оставить всё как есть.', style: black(16),)
                      ),
                      const SizedBox(height: 20,),
      
                      adresses.isEmpty ? createShip() :
                      DropdownButtonFormField<Map<String, dynamic>>(
                        dropdownColor: Colors.white,
                        decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 1.0),
                          ),
                        ),
                        isDense: false,
                        isExpanded: true,
                        value: adresses[0],
                        items: adresses.whereType<Map<String, dynamic>>().map((item) {
                          final mapItem = item;
                          return DropdownMenuItem<Map<String, dynamic>>(
                            value: mapItem,
                            child: Text(mapItem['address'], style: black(18), overflow: TextOverflow.clip,),
                          );
                        }).toList(),
                        onChanged: (Map<String, dynamic>? newValue) {
                          setState(() {
                            shipsID = newValue!['ship_to_id'];
                          });
                        },
                      ),
                      const SizedBox(height: 20,),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.transparent
                          ),
                          color: Colors.white,
                        ),
                        height: 45,
                        width: double.infinity,
                        child: TextField(
                          autofocus: false,
                          controller: commentController,
                          style: black(18),
                          minLines: 1,
                          maxLines: 2,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey, width: 1.0),
                            ),
                            hintStyle: grey(18),
                            hintText: 'комментарий к заказу',
                            prefixIcon: Icon(MdiIcons.pen, color: Colors.grey,),
                            isCollapsed: true
                          ),
                        ),
                      ),
                      const Expanded(child: SizedBox(height: 20,)), 
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async { 
                            final progress = ProgressHUD.of(context);
                            int shipID;
                            shipsID == 0 ? shipID = adresses[0]['ship_to_id'] : shipID = shipsID;
                            adresses.isEmpty ? 
                            GlobalScaffoldMessenger.instance.showSnackBar("Ошибка: Необходимо указать адрес доставки!", 'error') : 
                            {
                              progress?.showWithText('заказываем'),
                              await backend.newRequests(shipID, commentController.text, ref).then((_){
                                progress?.dismiss();
                                Navigator.pop(context);
                              })
                            };
                          }, 
                          child: Text('подтвердить и отправить', style: black(16),)
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: const SizedBox(height: 10),
                      ),
                    ],
                  ),
                ),
              );
            }
          );
        }
      ),
    );
  }

  Widget createShip(){
    return InkWell(
      onTap: () => newAddressAdd(context, newAddressController).then((_) async {
        newAddressController.text.isEmpty ? null :
        await backend.addClientAddress(newAddressController.text, ref).then((update){
          ref.read(addressProvider.notifier).state = update.toList();
          newAddressController.clear();
        });
      }), 
      child: SizedBox(
        child: Row(
          children: [
            const SizedBox(width: 6,),
            Icon(MdiIcons.plusCircle, color: Colors.red, size: 20,),
            const SizedBox(width: 5,),
            Expanded(child: Text('добавить адрес доставки', style: red(16),))
          ],
        ),
      ),
    );
  }

}






additionalInfo(BuildContext mainContext, TextEditingController controller, List ships){
  return showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    context: mainContext, 
    builder: (context){
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0)),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(height: 40,),
              Align(
                alignment: Alignment.centerLeft, 
                child: Text('Почти готово!', style: black(18, FontWeight.bold),)
              ),
              const SizedBox(height: 5,),
              Align(
                alignment: Alignment.centerLeft, 
                child: Text('Вы можете изменить адрес доставки, нажав на него, и оставить короткий комментарий к заказу, или оставить всё как есть.', style: black(16),)
              ),
              const SizedBox(height: 20,),
              
              DropdownButtonFormField<Map<String, dynamic>>(
                dropdownColor: Colors.white,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
                isDense: false,
                isExpanded: true,
                value: ships[0],
                items: ships.whereType<Map<String, dynamic>>().map((item) {
                  final mapItem = item;
                  return DropdownMenuItem<Map<String, dynamic>>(
                    value: mapItem,
                    child: Text(mapItem['address'], style: black(18), overflow: TextOverflow.clip,),
                  );
                }).toList(), // Преобразование итератора в список
                onChanged: (Map<String, dynamic>? newValue) {
                  // setState(() {
                  //   selectedValue = newValue;
                  // });
                },
              ),
              
              const SizedBox(height: 20,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Colors.transparent
                  ),
                  color: Colors.white,
                ),
                height: 45,
                width: double.infinity,
                child: TextField(
                  autofocus: false,
                  controller: controller,
                  style: black(18),
                  minLines: 1,
                  maxLines: 2,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    hintStyle: grey(18),
                    hintText: 'комментарий к заказу',
                    prefixIcon: Icon(MdiIcons.pen, color: Colors.grey,),
                    isCollapsed: true
                  ),
                ),
              ),
              const Expanded(child: SizedBox(height: 20,)),
              SizedBox(
                width: double.infinity,
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
                  child: Text('подтвердить и отправить', style: black(16),)
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: const SizedBox(height: 10),
              ),
            ],
          ),
        ),
      );
    }
  );
}



