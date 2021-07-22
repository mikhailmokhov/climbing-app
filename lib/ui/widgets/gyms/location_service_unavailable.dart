//import 'package:app_settings/app_settings.dart';
import 'package:app_settings/app_settings.dart';
import 'package:climbing/generated/l10n.dart';
import 'package:climbing/models/app_state.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_permissions/location_permissions.dart';

const double _iconSize = 53;

class LocationServiceUnavailable extends StatelessWidget {
  const LocationServiceUnavailable({
    Key key,
    @required this.appState,
  }) : super(key: key);

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    final Color disabledColor = Theme.of(context).disabledColor;
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.location_off,
              color: disabledColor,
              size: _iconSize,
            ),
            Text(
              !appState.locationServiceEnabled
                  ? S.of(context).locationServiceIsDisabled
                  : S.of(context).locationServiceIsNotPermitted,
              style: TextStyle(color: disabledColor),
            ),
            Text(
                !appState.locationServiceEnabled
                    ? S.of(context).enableLocationService
                    : S.of(context).allowLocationService,
                style: TextStyle(color: disabledColor)),
            Padding(
              child: InkWell(
//              onTap: () {
//                OpenLocationSettingsDialog.openSettings(
//                    geolocationStatus, serviceStatus);
//              },
                  child: Text(
                S.of(context).openSettings,
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                ),
              )),
              padding: const EdgeInsets.only(top: 3),
            ),
          ]),
    );
  }
}

// class OpenLocationSettingsDialog {
//   static void openSettings(
//       GeolocationStatus status, ServiceStatus serviceStatus) {
//     if (serviceStatus == ServiceStatus.disabled) {
//       AppSettings.openLocationSettings();
//     } else {
//       LocationPermissions().openAppSettings();
//     }
//   }
//
//   static Future<void> show(BuildContext context, GeolocationStatus status,
//       ServiceStatus serviceStatus) {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: true,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Row(
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.only(right: 10),
//                 child: Icon(
//                   Icons.location_off,
//                   color: Theme.of(context).disabledColor,
//                   size: 32,
//                 ),
//               ),
//               Text(S.of(context).locationIsDisabled),
//             ],
//           ),
//           content: Text(S.of(context).turnOnLocation),
//           actions: <Widget>[
//             TextButton(
//               child: Text(S.of(context).cancel),
//               onPressed: () {
//                 Navigator.pop(context, false);
//               },
//             ),
//             ElevatedButton(
//               child: Text(S.of(context).openSettings),
//               onPressed: () {
//                 Navigator.pop(context, true);
//               },
//             )
//           ],
//         );
//       },
//     );
//   }
// }
