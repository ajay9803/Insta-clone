import 'package:flutter/material.dart';
import 'package:instaclone/presentation/pages/EditProfile/edit_profile_page.dart';
import 'package:instaclone/providers/profile_provider.dart';
import 'package:instaclone/utilities/snackbars.dart';
import 'package:provider/provider.dart';

class EditUsernamePage extends StatelessWidget {
  static const String routeName = '/edit-username';
  const EditUsernamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final textEditingController =
        TextEditingController(text: routeArgs['userName']);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.close,
            ),
          ),
          title: Text(
            'Username',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          actions: [
            IconButton(
              onPressed: () async {
                Navigator.of(context).popUntil(
                  ModalRoute.withName(
                    EditProfilePage.routename,
                  ),
                );
                await Provider.of<ProfileProvider>(context, listen: false)
                    .editUserName(
                  textEditingController.text.trim(),
                )
                    .then((value) {
                  Toasts.showNormalSnackbar(
                      ('Your username has been updated.'));
                }).catchError((e) {
                  Toasts.showErrorSnackBar((e.toString()));
                });
              },
              icon: const Icon(
                Icons.check,
                color: Colors.blueAccent,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Username',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextField(
                style: Theme.of(context).textTheme.bodyMedium,
                autofocus: true,
                decoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).errorColor),
                  ),
                ),
                controller: textEditingController,
                onChanged: (value) {
                  textEditingController.text = value;
                },
                onSubmitted: (value) {
                  textEditingController.text = value;
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
