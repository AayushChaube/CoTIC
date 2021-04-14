import 'package:covidtracer/widgets/bottom_bar/bottom_bar_item.dart';
import 'package:flutter/material.dart';


class BottomBar extends StatelessWidget {
  const BottomBar({
    Key key,
    @required this.items,
    this.currentIndex = 0,
    this.onTap,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.margin = const EdgeInsets.all(8),
    this.itemPadding = const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeOutQuint,
  })  : assert(
  items != null || items.length < 2,
  "There should be atleast 2 Bottom Bar Items in Bottom Bar",
  ),
        super(key: key);

  /// A list of tabs to display, ie `Home`, `Likes`, etc
  final List<BottomBarItem> items;

  /// The tab to display.
  final int currentIndex;

  /// Returns the index of the tab that was tapped.
  final Function(int) onTap;

  /// The color of the icon and text when the item is selected.
  final Color selectedItemColor;

  /// The color of the icon and text when the item is not selected.
  final Color unselectedItemColor;

  /// A convenience field for the margin surrounding the entire widget.
  final EdgeInsets margin;

  /// The padding of each item.
  final EdgeInsets itemPadding;

  /// The transition duration
  final Duration duration;

  /// The transition curve
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (final item in items)
            TweenAnimationBuilder(
              tween: Tween(
                end: items.indexOf(item) == currentIndex ? 1.0 : 0.0,
              ),
              curve: curve,
              duration: duration,
              builder: (context, t, _) {
                final _selectedColor = item.selectedColor ??
                    selectedItemColor ??
                    theme.primaryColor;

                final _unselectedColor = item.unselectedColor ??
                    unselectedItemColor ??
                    theme.iconTheme.color;

                return Material(
                  color: Color.lerp(
                    _selectedColor.withOpacity(0.0),
                    _selectedColor.withOpacity(0.1),
                    t,
                  ),
                  shape: StadiumBorder(),
                  child: InkWell(
                    onTap: () => onTap?.call(
                      items.indexOf(item),
                    ),
                    customBorder: StadiumBorder(),
                    focusColor: _selectedColor.withOpacity(0.1),
                    highlightColor: _selectedColor.withOpacity(0.1),
                    splashColor: _selectedColor.withOpacity(0.1),
                    hoverColor: _selectedColor.withOpacity(0.1),
                    child: Padding(
                      padding: itemPadding -
                          EdgeInsets.only(
                            right: itemPadding.right * t,
                          ),
                      child: Row(
                        children: [
                          IconTheme(
                            data: IconThemeData(
                              color: Color.lerp(
                                  _unselectedColor, _selectedColor, t),
                              size: 24,
                            ),
                            child: item.icon ?? SizedBox.shrink(),
                          ),
                          ClipRect(
                            child: SizedBox(
                              /// TODO: Constrain item height without a fixed value
                              ///
                              /// The Align property appears to make these full height, would be
                              /// best to find a way to make it respond only to padding.
                              height: 20,
                              child: Align(
                                alignment: Alignment(-0.2, 0.0),
                                widthFactor: t,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: itemPadding.right / 2,
                                    right: itemPadding.right,
                                  ),
                                  child: DefaultTextStyle(
                                    style: TextStyle(
                                      color: Color.lerp(
                                          _selectedColor.withOpacity(0.0),
                                          _selectedColor,
                                          t),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    child: item.title ?? SizedBox.shrink(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
        ],
      ),
    );
  }
}