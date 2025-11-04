import 'package:cashier/commons/colors.dart';
import 'package:cashier/controllers/sop_controller.dart';
import 'package:cashier/pages/sop/card_categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

class SopPage extends StatefulWidget {
  const SopPage({super.key});

  @override
  State<SopPage> createState() => _SopPageState();
}

class _SopPageState extends State<SopPage> {
  final SopController sopController = Get.put(SopController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey.shade50, // Set your desired background color here
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView(
            children: [
              Stack(
                children: [
                  Container(
                    height: 300,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      gradient: LinearGradient(
                        colors: [MyColors.primary, MyColors.secondary],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomLeft,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -100,
                    left: -50,
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white.withAlpha((0.2 * 255).toInt()),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    right: -60,
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white.withAlpha((0.2 * 255).toInt()),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 70,
                    right: -40,
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: MyColors.primary,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    left: 20,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                  const Positioned(
                    top: 60,
                    left: 80,
                    right: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SOP Documents',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 120, 20, 0),
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Obx(
                      () =>
                          sopController.isLoading.value
                              ? Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                              : RefreshIndicator(
                                // onRefresh should return Future<void>. Implement `fetchDataListSop` in SopController to reload data.
                                onRefresh:
                                    () async =>
                                        sopController.fetchDataListSop(),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    20,
                                    10,
                                    20,
                                    10,
                                  ),
                                  child: AnimationLimiter(
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      itemCount: sopController.listSop.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 12,
                                            mainAxisSpacing: 12,
                                            childAspectRatio: 3 / 2,
                                          ),
                                      itemBuilder: (
                                        BuildContext context,
                                        int index,
                                      ) {
                                        return AnimationConfiguration.staggeredGrid(
                                          position: index,
                                          duration: const Duration(
                                            milliseconds: 375,
                                          ),
                                          columnCount: 2,
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
