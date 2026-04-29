import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_fluorography/styles.dart';

import '../main.dart';

/// A beautiful and animated bottom navigation that paints a rounded shape
/// around its [items] to provide a wonderful look.
///
/// Update [selectedIndex] to change the selected item.
/// [selectedIndex] is required and must not be null.
class BottomNavyBar extends StatelessWidget {
  BottomNavyBar({
    Key? key,
    this.selectedIndex = 0,
    this.showElevation = true,
    this.iconSize = 24,
    this.backgroundColor,
    this.shadowColor = Colors.black12,
    this.itemCornerRadius = 50,
    this.itemBorderColor = Colors.white,
    this.containerHeight = 70,
    this.containerWidth = 120,
    this.margin = const EdgeInsets.all(0),
    this.blurRadius = 2,
    this.spreadRadius = 0,
    this.borderRadius,
    this.shadowOffset = Offset.zero,
    this.itemPadding = const EdgeInsets.symmetric(horizontal: 4),
    this.animationDuration = const Duration(milliseconds: 270),
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.showInactiveTitle = false,
    required this.items,
    required this.onItemSelected,
    this.curve = Curves.linear,
  }) : assert(items.length >= 2 && items.length <= 5),
       super(key: key);

  /// The selected item is index. Changing this property will change and animate
  /// the item being selected. Defaults to zero.
  final int selectedIndex;

  /// The icon size of all items. Defaults to 24.
  final double iconSize;

  /// The background color of the navigation bar. It defaults to
  /// [ThemeData.BottomAppBarTheme.color] if not provided.
  final Color? backgroundColor;

  /// Defines the shadow color of the navigation bar. Defaults to [Colors.black12].
  final Color shadowColor;

  /// Whether this navigation bar should show a elevation. Defaults to true.
  final bool showElevation;

  /// Use this to change the item's animation duration. Defaults to 270ms.
  final Duration animationDuration;

  /// Defines the appearance of the buttons that are displayed in the bottom
  /// navigation bar. This should have at least two items and five at most.
  final List<BottomNavyBarItem> items;

  /// A callback that will be called when a item is pressed.
  final ValueChanged<int> onItemSelected;

  /// Defines the alignment of the items.
  /// Defaults to [MainAxisAlignment.spaceBetween].
  final MainAxisAlignment mainAxisAlignment;

  /// The [items] corner radius, if not set, it defaults to 50.
  final double itemCornerRadius;
  final Color itemBorderColor;

  /// Defines the bottom navigation bar height. Defaults to 56.
  final double containerHeight;
  final double containerWidth;

  final EdgeInsets margin;

  /// Used to configure the blurRadius of the [BoxShadow]. Defaults to 2.
  final double blurRadius;

  /// Used to configure the spreadRadius of the [BoxShadow]. Defaults to 0.
  final double spreadRadius;

  /// Used to configure the offset of the [BoxShadow]. Defaults to null.
  final Offset shadowOffset;

  /// Used to configure the borderRadius of the [BottomNavyBar]. Defaults to null.
  final BorderRadiusGeometry? borderRadius;

  /// Used to configure the padding of the [BottomNavyBarItem] [items].
  /// Defaults to EdgeInsets.symmetric(horizontal: 4).
  final EdgeInsets itemPadding;

  /// Used to configure the animation curve. Defaults to [Curves.linear].
  final Curve curve;

  /// Whether this navigation bar should show a Inactive titles. Defaults to false.
  final bool showInactiveTitle;

  @override
  Widget build(BuildContext context) {
    final bgColor =
        backgroundColor ??
        (Theme.of(context).bottomAppBarTheme.color ?? Colors.white);

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          if (showElevation)
            BoxShadow(
              color: shadowColor,
              blurRadius: blurRadius,
              spreadRadius: spreadRadius,
              offset: shadowOffset,
            ),
        ],
        borderRadius: borderRadius,
        border: Border.all(
          color: AppStyle.blueColorBorder,
          width: 1,
        )
      ),
      child: SafeArea(
        child: SizedBox(
          height: containerHeight,
          child: Row(
            mainAxisAlignment: mainAxisAlignment,
            children: items.map((item) {
              var index = items.indexOf(item);
              return Expanded(
                child: GestureDetector(
                  onTap: () => onItemSelected(index),
                  child: _ItemWidget(
                    item: item,
                    iconSize: iconSize,
                    isSelected: index == selectedIndex,
                    backgroundColor: bgColor,
                    itemCornerRadius: itemCornerRadius,
                    animationDuration: animationDuration,
                    itemPadding: itemPadding,
                    curve: curve,
                    showInactiveTitle: showInactiveTitle,
                    itemBorderColor: itemBorderColor,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  final double iconSize;
  final bool isSelected;
  final BottomNavyBarItem item;
  final Color backgroundColor;
  final double itemCornerRadius;
  final Color itemBorderColor;
  final Duration animationDuration;
  final EdgeInsets itemPadding;
  final Curve curve;
  final bool showInactiveTitle;

  const _ItemWidget({
    Key? key,
    required this.iconSize,
    required this.isSelected,
    required this.item,
    required this.backgroundColor,
    required this.itemCornerRadius,
    required this.itemBorderColor,
    required this.animationDuration,
    required this.itemPadding,
    required this.showInactiveTitle,
    this.curve = Curves.linear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Semantics semantic = Semantics(
      container: true,
      selected: isSelected,
      child: AnimatedContainer(
        height: double.maxFinite,
        duration: animationDuration,
        curve: curve,
        decoration: BoxDecoration(
          color: isSelected
              ? (item.activeBackgroundColor ??
                    item.activeColor.withOpacity(0.2))
              : backgroundColor,
          borderRadius: BorderRadius.circular(itemCornerRadius),
          border: Border.all(
            color: itemBorderColor,
            width: 1
          )
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (item.icon != null)
              IconTheme(
                data: IconThemeData(
                  size: iconSize,
                  color: isSelected
                      ? item.activeColor.withOpacity(1)
                      : item.inactiveColor == null
                      ? item.activeColor
                      : item.inactiveColor,
                ),
                child: item.icon!,
              ),
            if (showInactiveTitle || isSelected)
              Flexible(
                child: Container(
                  padding: itemPadding,
                  child: DefaultTextStyle.merge(
                    style: TextStyle(
                      color: isSelected ? item.activeColor : (item.activeTextColor ?? item.activeColor),
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    textAlign: item.textAlign,
                    overflow: TextOverflow.ellipsis,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: item.title,
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
    return item.tooltipText == null
        ? semantic
        : Tooltip(message: item.tooltipText!, child: semantic);
  }
}

/// The [BottomNavyBar.items] definition.
class BottomNavyBarItem {
  BottomNavyBarItem({
    // required this.icon,
    this.icon,
    required this.title,
    this.activeColor = Colors.blue,
    this.textAlign,
    this.inactiveColor,
    this.activeTextColor,
    this.inactiveTextColor,
    this.activeBackgroundColor,
    this.inactiveBackgroundColor,
    this.tooltipText,
  });

  /// Defines this item's icon which is placed in the right side of the [title].
  final Widget? icon;

  /// Defines this item's title which placed in the left side of the [icon].
  final Widget title;

  /// The [icon] and [title] color defined when this item is selected. Defaults
  /// to [Colors.blue].
  final Color activeColor;

  /// The [icon] and [title] color defined when this item is not selected.
  final Color? inactiveColor;

  /// The alignment for the [title].
  ///
  /// This will take effect only if [title] it a [Text] widget.
  final TextAlign? textAlign;

  /// The [title] color with higher priority than [activeColor]
  ///
  /// Will fallback to [activeColor] when null
  final Color? activeTextColor;
  final Color? inactiveTextColor;

  /// The [BottomNavyBarItem] background color when active.
  ///
  /// Will fallback to [activeColor] with opacity 0.2 when null
  final Color? activeBackgroundColor;
  final Color? inactiveBackgroundColor;

  /// Will show a tooltip for the item if provided.
  final String? tooltipText;
}



class BottomNavBarFLura extends StatelessWidget{
  final int currentIndex;
  final Function(int) onItemSelected;
  final VoidCallback onLogoutPressed;
  final VoidCallback onNotificationPressed;

  const BottomNavBarFLura({
    Key? key,
    required this.currentIndex,
    required this.onItemSelected,
    required this.onLogoutPressed,
    required this.onNotificationPressed,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonHeight = screenWidth * 0.045;
    final iconSize = screenWidth * 0.04;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: onLogoutPressed,
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: EdgeInsets.all(buttonHeight),
                backgroundColor: AppStyle.blueColorAdditional4AABDB,
              ),
              child: SvgPicture.asset(
                'assets/icon/door_icon.svg',
                colorFilter: const ColorFilter.mode(
                  AppStyle.whiteColorMain,
                  BlendMode.srcIn,
                ),
                width: iconSize,
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: BottomNavyBar(
                containerHeight: screenHeight * 0.055,
                itemCornerRadius: 20,
                margin: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.01,
                  horizontal: 0,
                ),
                mainAxisAlignment: MainAxisAlignment.center,
                borderRadius: BorderRadius.circular(20),
                showInactiveTitle: screenWidth > 360,
                itemBorderColor: AppStyle.whiteColorMain,
                onItemSelected: onItemSelected,
                selectedIndex: currentIndex,
                items: [
                  BottomNavyBarItem(
                    title: const Text('Флюорография'),
                    activeBackgroundColor: AppStyle.blueColorAdditional4AABDB,
                    activeColor: AppStyle.whiteColorMain,
                    inactiveColor: AppStyle.blueColorAdditional4AABDB,
                    activeTextColor: AppStyle.blueColorAdditional4AABDB,
                    textAlign: TextAlign.center,
                  ),
                  BottomNavyBarItem(
                    title: const Text('Справки'),
                    activeBackgroundColor: AppStyle.blueColorAdditional4AABDB,
                    activeColor: AppStyle.whiteColorMain,
                    inactiveColor: AppStyle.blueColorAdditional4AABDB,
                    activeTextColor: AppStyle.blueColorAdditional4AABDB,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            ElevatedButton(
              onPressed: onNotificationPressed,
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: EdgeInsets.all(buttonHeight),
                backgroundColor: AppStyle.blueColorAdditional4AABDB,
              ),
              child: SvgPicture.asset(
                'assets/icon/notification_white_icon.svg',
                colorFilter: const ColorFilter.mode(
                  AppStyle.whiteColorMain,
                  BlendMode.srcIn,
                ),
                width: iconSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

