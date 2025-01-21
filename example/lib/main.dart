import "package:contacts_service_example/contacts_list_page.dart";
import "package:contacts_service_example/contacts_picker_page.dart";
import "package:flutter/material.dart";
import "package:permission_handler/permission_handler.dart";

void main() => runApp(const ContactsExampleApp());

// iOS only: Localized labels language setting is equal to CFBundleDevelopmentRegion value (Info.plist) of the iOS project
// Set iOSLocalizedLabels=false if you always want english labels whatever is the CFBundleDevelopmentRegion value.
const iOSLocalizedLabels = false;

class ContactsExampleApp extends StatelessWidget {
  const ContactsExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
      routes: <String, WidgetBuilder>{
        "/add": (BuildContext context) => const AddContactPage(),
        "/contactsList": (BuildContext context) => const ContactListPage(),
        "/nativeContactPicker": (BuildContext context) =>
            const ContactPickerPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _askPermissions("");
  }

  Future<void> _askPermissions(String routeName) async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      Navigator.of(context).pushNamed(routeName);
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      const snackBar = SnackBar(content: Text("Access to contact data denied"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      const snackBar =
          SnackBar(content: Text("Contact data not available on device"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contacts Plugin Example")),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElevatedButton(
              child: const Text("Contacts list"),
              onPressed: () => _askPermissions("/contactsList"),
            ),
            ElevatedButton(
              child: const Text("Native Contacts picker"),
              onPressed: () => _askPermissions("/nativeContactPicker"),
            ),
          ],
        ),
      ),
    );
  }
}
