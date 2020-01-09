//import 'package:app_settings/app_settings.dart';
import 'package:app_settings/app_settings.dart';
import 'package:climbing/generated/i18n.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_permissions/location_permissions.dart';

final double _iconSize = 53;

class LocationDisabled extends StatelessWidget {
  final GeolocationStatus geolocationStatus;
  final ServiceStatus serviceStatus;

  const LocationDisabled(
    this.geolocationStatus,
    this.serviceStatus, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final disabledColor = Theme.of(context).disabledColor;
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(
          Icons.location_off,
          color: disabledColor,
          size: _iconSize,
        ),
        Text(
          S.of(context).locationServiceIsDisabled,
          style: TextStyle(color: disabledColor),
        ),
        Text(S.of(context).enableLocationService,
            style: TextStyle(color: disabledColor)),
        InkWell(
            onTap: () {
              OpenLocationSettingsDialog.openSettings(
                  geolocationStatus, serviceStatus);
            },
            child: Text(
              S.of(context).openSettings,
              style: TextStyle(
                decoration: TextDecoration.underline,
              ),
            )),
      ]),
    );
  }
}

class OpenLocationSettingsDialog {
  static openSettings(GeolocationStatus status, ServiceStatus serviceStatus) {
    if (serviceStatus == ServiceStatus.disabled) {
      AppSettings.openLocationSettings();
    } else {
      LocationPermissions().openAppSettings();
    }
  }

  static show(BuildContext context, GeolocationStatus status,
      ServiceStatus serviceStatus) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: <Widget>[

              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.location_off,
                  color: Theme.of(context).disabledColor,
                  size: 32,
                ),
              ),
              Text(S.of(context).locationIsDisabled),
            ],
          ),
          content: Text(S.of(context).turnOnLocation),
          actions: <Widget>[
            FlatButton(
              child: Text(S.of(context).cancel),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            RaisedButton(
              child: Text(S.of(context).openSettings),
              onPressed: () {
                Navigator.pop(context, true);
              },
            )
          ],
        );
      },
    );
  }
}
