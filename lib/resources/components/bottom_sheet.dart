import 'package:committee_app/resources/components/pop_over_widget.dart';
import 'package:committee_app/resources/text_constants.dart';
import 'package:flutter/material.dart';

void settingModalBottomSheet(
    context, height, width, cameraOnPress, galleryOnPress) {
  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Popover(
          child: Container(
            height: height / 5,
            margin: EdgeInsets.symmetric(horizontal: width / 30),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: height / 40,
                ),
                ListTile(
                    leading: const Icon(
                      Icons.camera_alt_outlined,
                      color: Color(0xff767676),
                    ),
                    title: Text('Camera',
                        style: textTheme.titleSmall!
                            .copyWith(fontWeight: FontWeight.w100)),
                    onTap: cameraOnPress),
                ListTile(
                  leading: const Icon(
                    Icons.perm_media_outlined,
                    color: Color(0xff767676),
                  ),
                  title: Text('Gallery',
                      style: textTheme.titleSmall!
                          .copyWith(fontWeight: FontWeight.w100)),
                  onTap: galleryOnPress,
                ),
              ],
            ),
          ),
        );
      });
}
