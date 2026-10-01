import 'package:cashier/commons/colors.dart';
import 'package:cashier/controllers/kasir_controller.dart';
import 'package:cashier/controllers/product_controller.dart';
import 'package:cashier/widgets/sync_status_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductHeroHeader extends StatefulWidget {
  final VoidCallback onMenuTap;
  final Widget? trailing;

  const ProductHeroHeader({super.key, required this.onMenuTap, this.trailing});

  @override
  State<ProductHeroHeader> createState() => _ProductHeroHeaderState();
}

class _ProductHeroHeaderState extends State<ProductHeroHeader> {
  late final ProductController productController;
  late final KasirController kasirController;

  @override
  void initState() {
    super.initState();

    productController = Get.find<ProductController>();
    kasirController = Get.find<KasirController>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [MyColors.primary, MyColors.primaryDark],
        ),
        boxShadow: [
          BoxShadow(
            color: MyColors.shadow.withValues(alpha: .055),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [_buildHeader(), const SizedBox(height: 16), _buildSearch()],
      ),
    );
  }

  // ================================================================
  // HEADER
  // ================================================================

  Widget _buildHeader() {
    return Obx(() {
      final cabang = kasirController.namaCabang.value.trim();
      final namaKasir = kasirController.namaKasir.value.trim();

      return Row(
        children: [
          // ----------------------------------------------------------
          // MENU
          // ----------------------------------------------------------

          _HeaderButton(icon: Icons.menu_rounded, onTap: widget.onMenuTap),

          const SizedBox(width: 12),

          // ----------------------------------------------------------
          // OUTLET + KASIR
          // ----------------------------------------------------------
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cabang.isEmpty ? 'HIMALAYA' : cabang,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: MyColors.textOnPrimary,
                    letterSpacing: -.2,
                  ),
                ),

                const SizedBox(height: 3),

                Row(
                  children: [
                    Container(
                      width: 18,
                      height: 3,
                      decoration: BoxDecoration(
                        color: MyColors.accent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        namaKasir.isEmpty ? 'Kasir' : 'Kasir • $namaKasir',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: MyColors.textOnPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ----------------------------------------------------------
          // SYNC STATUS
          // ----------------------------------------------------------
          if (widget.trailing != null) ...[
            const SizedBox(width: 10),
            widget.trailing!,
          ] else ...[
            const SizedBox(width: 10),
            const SyncStatusIndicator(),
          ],
        ],
      );
    });
  }

  // ================================================================
  // SEARCH
  // ================================================================

  Widget _buildSearch() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: MyColors.surface.withValues(alpha: .96),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: MyColors.surface.withValues(alpha: .35)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),

          const Icon(
            Icons.search_rounded,
            size: 21,
            color: MyColors.textSecondary,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: TextField(
              controller: productController.searchTextFieldController,
              textInputAction: TextInputAction.search,
              onChanged: (value) {
                productController.isEmptyValue.value = value.trim().isEmpty;
              },
              onSubmitted: productController.searchProduct,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: MyColors.textPrimary,
              ),
              decoration: const InputDecoration(
                hintText: 'Cari STMJ, Jahe, Booster...',
                hintStyle: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: MyColors.textMuted,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),

          Obx(() {
            if (productController.isEmptyValue.value) {
              return const SizedBox.shrink();
            }

            return IconButton(
              splashRadius: 20,
              onPressed: productController.clearSearch,
              icon: const Icon(
                Icons.close_rounded,
                size: 19,
                color: MyColors.textSecondary,
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ==================================================================
// HEADER BUTTON
// ==================================================================

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MyColors.surface.withValues(alpha: .14),
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        splashColor: MyColors.surface.withValues(alpha: .10),
        highlightColor: MyColors.surface.withValues(alpha: .06),
        child: const SizedBox(
          width: 42,
          height: 42,
          child: Icon(
            Icons.menu_rounded,
            color: MyColors.textOnPrimary,
            size: 22,
          ),
        ),
      ),
    );
  }
}
