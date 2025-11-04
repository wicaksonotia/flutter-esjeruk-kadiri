import 'package:cashier/commons/colors.dart';
import 'package:cashier/controllers/sop_controller.dart';
import 'package:cashier/pages/sop/card_categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:cashier/drawer/nav_drawer.dart' as custom_drawer;

class SopDocumentPage extends StatefulWidget {
  const SopDocumentPage({super.key});

  @override
  State<SopDocumentPage> createState() => _SopDocumentPageState();
}

class _SopDocumentPageState extends State<SopDocumentPage> {
  final SopController sopController = Get.put(SopController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const custom_drawer.NavigationDrawer(),
      backgroundColor: MyColors.notionBgGrey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          title: const Text(
            'SOP Documents',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: MyColors.primary,
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        ),
      ),
      body: Obx(
        () =>
            sopController.isLoading.value
                ? Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: const Center(child: CircularProgressIndicator()),
                )
                : RefreshIndicator(
                  // onRefresh should return Future<void>. Implement `refreshSop` in SopController to reload data.
                  onRefresh: () async => sopController.fetchDataListSop(),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: AnimationLimiter(
                      child: ListView.builder(
                        itemCount: sopController.listSop.length,
                        itemBuilder: (BuildContext context, int index) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: CardCategories(
                                  sopController: sopController,
                                  index: index,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
      ),
    );
  }
}
