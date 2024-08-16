import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:day_frame/l10n/app_locale.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.settings.getString(context)),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(AppLocale.language.getString(context)),
            onTap: () => _showLanguageDialog(context),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: Text(AppLocale.appInfo.getString(context)),
            onTap: () {
              // アプリ情報を表示する処理
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: Text(AppLocale.termsOfService.getString(context)),
            onTap: () {
              // 利用規約を表示する処理
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: Text(AppLocale.privacyPolicy.getString(context)),
            onTap: () {
              // プライバシーポリシーを表示する処理
            },
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final FlutterLocalization localization = FlutterLocalization.instance;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocale.selectLanguage.getString(context)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('English'),
                onTap: () {
                  localization.translate('en');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('日本語'),
                onTap: () {
                  localization.translate('ja');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
