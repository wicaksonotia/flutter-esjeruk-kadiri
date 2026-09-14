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
  late final SopController sopController;

  @override
  void initState() {
    super.initState();

    sopController =
        Get.isRegistered<SopController>()
            ? Get.find<SopController>()
            : Get.put(SopController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background,
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: RefreshIndicator(
          color: MyColors.primary,
          backgroundColor: MyColors.surface,
          onRefresh: () => sopController.fetchDataListSop(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              Stack(
                children: [
                  // =======================================================
                  // HEADER
                  // =======================================================

                  Container(
                    height: 300,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                      gradient: LinearGradient(
                        colors: [MyColors.primary, MyColors.primaryDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),

                  // =======================================================
                  // DECORATION
                  // =======================================================
                  Positioned(
                    top: -100,
                    left: -50,
                    child: _circle(
                      size: 200,
                      color: MyColors.textOnPrimary.withValues(alpha: .10),
                    ),
                  ),

                  Positioned(
                    top: 50,
                    right: -60,
                    child: _circle(
                      size: 120,
                      color: MyColors.textOnPrimary.withValues(alpha: .08),
                    ),
                  ),

                  Positioned(
                    top: 70,
                    right: -40,
                    child: _circle(
                      size: 80,
                      color: MyColors.textOnPrimary.withValues(alpha: .06),
                    ),
                  ),

                  // =======================================================
                  // BACK BUTTON
                  // =======================================================
                  Positioned(
                    top: 50,
                    left: 20,
                    child: Material(
                      color: MyColors.textOnPrimary.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: Get.back,
                        splashColor: MyColors.textOnPrimary.withValues(
                          alpha: .08,
                        ),
                        child: const SizedBox(
                          width: 44,
                          height: 44,
                          child: Icon(
                            Icons.arrow_back_rounded,
                            color: MyColors.textOnPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // =======================================================
                  // HEADER TITLE
                  // =======================================================
                  const Positioned(
                    top: 60,
                    left: 80,
                    right: 20,
                    child: Text(
                      'SOP Documents',
                      style: TextStyle(
                        fontSize: 20,
                        color: MyColors.textOnPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  // =======================================================
                  // CONTENT CARD
                  // =======================================================
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 120, 20, 24),
                    padding: const EdgeInsets.all(18),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: MyColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: MyColors.border),
                      boxShadow: const [
                        BoxShadow(
                          color: MyColors.shadow,
                          blurRadius: 18,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Obx(() {
                      if (sopController.isLoading.value) {
                        return _buildLoading();
                      }

                      if (sopController.listSop.isEmpty) {
                        return _buildEmpty();
                      }

                      return _buildContent();
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================================================================
  // CONTENT
  // ================================================================

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ==============================================================
        // TITLE
        // ==============================================================

        const Text(
          'Kategori SOP',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: MyColors.textPrimary,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Pilih kategori untuk melihat panduan kerja dan '
          'prosedur operasional.',
          style: TextStyle(
            fontSize: 14,
            color: MyColors.textSecondary,
            height: 1.4,
          ),
        ),

        const SizedBox(height: 24),

        // ==============================================================
        // INFO
        // ==============================================================
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: MyColors.primaryLight,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: MyColors.primary.withValues(alpha: .15)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.menu_book_outlined,
                size: 20,
                color: MyColors.primaryDark,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  '${sopController.listSop.length} kategori SOP tersedia',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: MyColors.primaryDark,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // ==============================================================
        // GRID
        // ==============================================================
        AnimationLimiter(
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sopController.listSop.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.18,
            ),
            itemBuilder: (BuildContext context, int index) {
              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 400),
                columnCount: 2,
                child: SlideAnimation(
                  verticalOffset: 35,
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
      ],
    );
  }

  // ================================================================
  // LOADING
  // ================================================================

  Widget _buildLoading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 130,
          height: 18,
          decoration: BoxDecoration(
            color: MyColors.surfaceSoft,
            borderRadius: BorderRadius.circular(8),
          ),
        ),

        const SizedBox(height: 10),

        Container(
          width: double.infinity,
          height: 14,
          decoration: BoxDecoration(
            color: MyColors.surfaceSoft,
            borderRadius: BorderRadius.circular(8),
          ),
        ),

        const SizedBox(height: 6),

        Container(
          width: 220,
          height: 14,
          decoration: BoxDecoration(
            color: MyColors.surfaceSoft,
            borderRadius: BorderRadius.circular(8),
          ),
        ),

        const SizedBox(height: 24),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 6,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.18,
          ),
          itemBuilder: (_, index) {
            return _loadingCard();
          },
        ),
      ],
    );
  }

  // ================================================================
  // LOADING CARD
  // ================================================================

  Widget _loadingCard() {
    return Container(
      decoration: BoxDecoration(
        color: MyColors.surfaceSoft,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: MyColors.border,
              borderRadius: BorderRadius.circular(14),
            ),
          ),

          const SizedBox(height: 12),

          Container(
            width: 80,
            height: 12,
            decoration: BoxDecoration(
              color: MyColors.border,
              borderRadius: BorderRadius.circular(8),
            ),
          ),

          const SizedBox(height: 7),

          Container(
            width: 55,
            height: 9,
            decoration: BoxDecoration(
              color: MyColors.border,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // EMPTY
  // ================================================================

  Widget _buildEmpty() {
    return Column(
      children: [
        const SizedBox(height: 20),

        Container(
          width: 90,
          height: 90,
          decoration: const BoxDecoration(
            color: MyColors.primaryLight,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.menu_book_outlined,
            size: 42,
            color: MyColors.primary,
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          'Belum Ada Dokumen SOP',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: MyColors.textPrimary,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Dokumen SOP akan muncul di sini '
          'setelah tersedia.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: MyColors.textSecondary,
            fontSize: 13,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 20),

        OutlinedButton.icon(
          onPressed: () => sopController.fetchDataListSop(),
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: const Text('Muat Ulang'),
          style: OutlinedButton.styleFrom(
            foregroundColor: MyColors.primaryDark,
            side: BorderSide(color: MyColors.primary.withValues(alpha: .40)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  // ================================================================
  // CIRCLE
  // ================================================================

  Widget _circle({required double size, required Color color}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
