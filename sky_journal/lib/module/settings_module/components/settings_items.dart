import 'package:flutter/material.dart';
import 'package:sky_journal/module/settings_module/components/icon_style.dart';

import 'screen_utils.dart';

class SettingsItem extends StatelessWidget {
  final IconData? icons; // Make icons parameter nullable
  final IconStyle? iconStyle; // Make iconStyle parameter nullable
  final String title; // Make title parameter required
  final TextStyle? titleStyle; // Make titleStyle parameter nullable
  final String? subtitle; // Make subtitle parameter nullable
  final TextStyle? subtitleStyle; // Make subtitleStyle parameter nullable
  final Widget? trailing; // Make trailing parameter nullable
  final VoidCallback? onTap; // Make onTap parameter nullable
  final Color? backgroundColor; // Make backgroundColor parameter nullable
  final int? titleMaxLine; // Make titleMaxLine parameter nullable
  final int? subtitleMaxLine; // Make subtitleMaxLine parameter nullable
  final TextOverflow? overflow; // Make overflow parameter nullable

  SettingsItem(
      {this.icons, // Make icons parameter nullable
      this.iconStyle,
      required this.title,
      this.titleStyle,
      this.subtitle,
      this.subtitleStyle,
      this.backgroundColor,
      this.trailing,
      this.onTap,
      this.titleMaxLine,
      this.subtitleMaxLine,
      this.overflow = TextOverflow.ellipsis});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: ListTile(
        onTap: onTap,
        leading: (icons != null) // Check if icons is not null
            ? (iconStyle != null && iconStyle!.withBackground!)
                ? Container(
                    decoration: BoxDecoration(
                      color: iconStyle!.backgroundColor,
                      borderRadius:
                          BorderRadius.circular(iconStyle!.borderRadius!),
                    ),
                    padding: EdgeInsets.all(5),
                    child: Icon(
                      icons,
                      size: SettingsScreenUtils.settingsGroupIconSize,
                      color: iconStyle!.iconsColor,
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.all(5),
                    child: Icon(
                      icons,
                      size: SettingsScreenUtils.settingsGroupIconSize,
                    ),
                  )
            : null, // If icons is null, don't include the icon
        title: Text(
          title,
          style: titleStyle ?? TextStyle(fontWeight: FontWeight.bold),
          maxLines: titleMaxLine,
          overflow: titleMaxLine != null ? overflow : null,
        ),
        subtitle: (subtitle != null)
            ? Text(
                subtitle!,
                style: subtitleStyle ?? Theme.of(context).textTheme.bodyMedium!,
                maxLines: subtitleMaxLine,
                overflow:
                    subtitleMaxLine != null ? TextOverflow.ellipsis : null,
              )
            : null,
        trailing: (trailing != null)
            ? trailing
            : Icon(
                Icons.navigate_next,
                color: Colors.grey[400],
              ),
      ),
    );
  }
}
