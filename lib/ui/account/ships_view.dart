
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:showcase_front/data/repositories/backend_implements.dart';

import '../../constants/fonts.dart';
import '../../data/providers.dart';
import '../widgets/loading.dart';
import 'confirm_address_delete.dart';
import 'cabinet/new_address_add.dart';

class ShipsView extends ConsumerStatefulWidget {
  const ShipsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShipsViewState();
}

class _ShipsViewState extends ConsumerState<ShipsView> with SingleTickerProviderStateMixin {

  final BackendImplements backend = BackendImplements();
  /*
  late AnimationController _shipsController;
  late Animation<double> _shipsIconTurns;
  late Animation<double> _shipsHeightFactor;
  bool _shipsIsExpanded = false;
  */
  int selectedIndex = 0;
  TextEditingController newAddressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    /*
    _shipsController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _shipsIconTurns = Tween<double>(begin: 0.0, end: 0.5).animate(_shipsController);
    _shipsHeightFactor = _shipsController.drive(CurveTween(curve: Curves.easeInOut));
    */
  }


  @override
  void dispose() {
    /*
    _shipsController.dispose();
    */
    newAddressController.dispose();
    super.dispose();
  }

  /*
  void shipsHandleTap() {
    setState(() {
      _shipsIsExpanded = !_shipsIsExpanded;
      if (_shipsIsExpanded) {
        _shipsController.forward();
      } else {
        _shipsController.reverse();
      }
    });
  }
  */

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10,),
              header(),
              const SizedBox(height: 20,),
              addressView()
              /*
              InkWell(
                onTap: shipsHandleTap,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(5), 
                      bottomLeft: _shipsIsExpanded ? const Radius.circular(0) : const Radius.circular(5)
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Colors.green.withOpacity(0.5),
                        Colors.white
                      ]
                    )
                  ),
                  child: Row(
                    children: [
                      Icon(MdiIcons.mapMarker, size: 20, color: Colors.white,),
                      const SizedBox(width: 5,),
                      Text('мои адреса', style: white(20, FontWeight.w400),),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: RotationTransition(
                          turns: _shipsIconTurns,
                          child: const Icon(Icons.expand_more, size: 30,),
                        ),
                      )
                    ],
                  )
                ),
              ),
              AnimatedBuilder(
                animation: _shipsController, 
                builder: (BuildContext context, Widget? child) {
                  return ClipRect(
                    child: Align(
                      heightFactor: _shipsHeightFactor.value,
                      child: child,
                    ),
                  );
                },
                child: addressView()
              )
              */
            ],
          ),
        ),
      ),
    );
  }


  Widget header(){
    return Align(
      alignment: Alignment.centerLeft, 
      child: Row(
        children: [
          Expanded(child: Text('Адреса', style: darkCategory(30, FontWeight.bold), overflow: TextOverflow.clip,)),
          InkWell(
            onTap: () => newAddressAdd(context, newAddressController).then((_) async {
              newAddressController.text.isEmpty ? null :
              await backend.addClientAddress(newAddressController.text).then((update){
                ref.read(addressProvider.notifier).state = update.toList();
                newAddressController.clear();
              });
            }), 
            child: Icon(MdiIcons.plus, size: 30,),
          ),
          const SizedBox(width: 8,),
        ],
      )
    );
  }


  Widget addressView(){
    return Consumer(
      builder: (context, ref, child){
        return ref.watch(getAddressProvider).when(
          loading: () => const Loading(),
          error: (error, _) => Center(child: Text(error.toString())),
          data: (_){
            var allAddresses = ref.watch(addressProvider);
            return allAddresses.isEmpty ? SizedBox(height: 50, child: Center(child: Text('нет доступных адресов', style: darkCategory(14),)),) :
            ListView.builder(
              shrinkWrap: true,
              itemCount: allAddresses.length,
              itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    children: [
                      Checkbox(
                        value: selectedIndex == index,
                        onChanged: (bool? value) async {
                          await backend.patchClientAddress(allAddresses[index]['ship_to_id'], false, true).then((update){
                            ref.read(addressProvider.notifier).state = update.toList();
                          });
                        },
                        activeColor: Colors.green.withOpacity(0.5), // Цвет заливки, когда выбрано
                        checkColor: Colors.black, // Цвет галочки
                        side: WidgetStateBorderSide.resolveWith(
                          (state) {
                            if (state.contains(WidgetState.selected)) {
                              return const BorderSide(width: 1.0, color: Colors.transparent);
                            } else {
                              return const BorderSide(width: 2.0, color: Colors.grey);
                            }
                          }
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '${allAddresses[index]['address']}', 
                          style: allAddresses[index]['is_default'] ? darkCategory(16, FontWeight.w600) : darkCategory(16), 
                          overflow: TextOverflow.clip,
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: IconButton(
                          onPressed: () async {
                            bool? confirmDelete = await confirmAddressDelete(context, allAddresses[index]['address']);
                            !confirmDelete! ? null :
                            await backend.patchClientAddress(allAddresses[index]['ship_to_id'], true, false).then((update){
                              ref.read(addressProvider.notifier).state = update.toList();
                            });
                          },
                          icon: Icon(MdiIcons.minusCircle, color: Colors.red, size: 20,)
                        ),
                      )
                    ],
                  ),
                );
              }
            );
          }
        );
      }
    );
  }

}