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
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: MyColors.primary,
          onRefresh: () => sopController.fetchDataListSop(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // ==========================================================
              // HEADER
              // ==========================================================

              SliverToBoxAdapter(child: _buildHeader()),

              // ==========================================================
              // CONTENT
              // ==========================================================
              SliverToBoxAdapter(
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

              const SliverToBoxAdapter(child: SizedBox(height: 30)),
            ],
          ),
        ),
      ),
    );
  }

  // ================================================================
  // HEADER
  // ================================================================

  Widget _buildHeader() {
    return Container(
      height: 235,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [MyColors.primary, MyColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Stack(
        children: [
          // ----------------------------------------------------------
          // Decorative circles
          // ----------------------------------------------------------

          Positioned(
            top: -100,
            left: -70,
            child: _circle(
              size: 210,
              color: Colors.white.withValues(alpha: 0.10),
            ),
          ),

          Positioned(
            top: -30,
            right: -50,
            child: _circle(
              size: 150,
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),

          Positioned(
            bottom: -80,
            right: 35,
            child: _circle(
              size: 160,
              color: Colors.white.withValues(alpha: 0.06),
            ),
          ),

          // ----------------------------------------------------------
          // Back button
          // ----------------------------------------------------------
          Positioned(
            top: 12,
            left: 12,
            child: Material(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: Get.back,
                child: const SizedBox(
                  width: 44,
                  height: 44,
                  child: Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
            ),
          ),

          // ----------------------------------------------------------
          // Header content
          // ----------------------------------------------------------
          Positioned(
            left: 24,
            right: 24,
            top: 78,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.20),
                    ),
                  ),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),

                const SizedBox(width: 16),

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SOP Documents',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Panduan kerja dan prosedur operasional',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ----------------------------------------------------------
          // Bottom information
          // ----------------------------------------------------------
          Positioned(
            left: 24,
            right: 24,
            bottom: 22,
            child: Obx(
              () => Row(
                children: [
                  _headerInfo(
                    Icons.folder_copy_outlined,
                    '${sopController.listSop.length}',
                    'Dokumen',
                  ),
                  const SizedBox(width: 12),
                  _headerInfo(Icons.touch_app_outlined, 'Tap', 'Untuk membuka'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // HEADER INFO
  // ================================================================

  Widget _headerInfo(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 9),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // CONTENT
  // ================================================================

  Widget _buildContent() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 18, 16, 0),
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ----------------------------------------------------------
          // Section title
          // ----------------------------------------------------------

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 22,
                  decoration: BoxDecoration(
                    color: MyColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kategori SOP',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Pilih kategori untuk melihat panduan',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.grid_view_rounded,
                  size: 21,
                  color: Colors.grey,
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // ----------------------------------------------------------
          // Grid
          // ----------------------------------------------------------
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
      ),
    );
  }

  // ================================================================
  // LOADING
  // ================================================================

  Widget _buildLoading() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 18, 16, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 22,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 130,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

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
      ),
    );
  }

  // ================================================================
  // LOADING CARD
  // ================================================================

  Widget _loadingCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: 80,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 7),
          Container(
            width: 55,
            height: 9,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
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
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 18, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: MyColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.menu_book_outlined,
              size: 42,
              color: MyColors.primary,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Belum Ada Dokumen SOP',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 8),

          Text(
            'Dokumen SOP akan muncul di sini '
            'setelah tersedia.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 20),

          OutlinedButton.icon(
            onPressed: () => sopController.fetchDataListSop(),
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Muat Ulang'),
            style: OutlinedButton.styleFrom(
              foregroundColor: MyColors.primary,
              side: BorderSide(color: MyColors.primary.withValues(alpha: 0.4)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // CIRCLE DECORATION
  // ================================================================

  Widget _circle({required double size, required Color color}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
