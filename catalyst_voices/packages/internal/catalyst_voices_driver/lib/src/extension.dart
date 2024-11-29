import 'package:equatable/equatable.dart';

enum Browser {
  chrome,
  brave,
  firefox;

  String extensionStoreUrl(String extensionId) {
    switch (this) {
      case Browser.chrome:
        return 'https://clients2.google.com/service/update2/crx?response=redirect&os=win&arch=x64&os_arch=x86_64&nacl_arch=x86-64&prod=chromiumcrx&prodchannel=beta&prodversion=79.0.3945.53&lang=ru&acceptformat=crx3&x=id%3D$extensionId%26installsource%3Dondemand%26uc';
      case Browser.brave:
        return 'https://brave.com/extension/$extensionId'; // TODO(ryszard-schossler): add brave store url
      case Browser.firefox:
        return 'https://addons.mozilla.org/en-US/firefox/addon/$extensionId'; // TODO(ryszard-schossler): add firefox store url
    }
  }
}

class Extension extends Equatable {
  final String name;
  final String id;
  final Browser browser;
  final String? extensionPath;

  const Extension({
    required this.name,
    required this.id,
    required this.browser,
    required this.extensionPath,
  });

  @override
  List<Object?> get props => [name, id, browser, extensionPath];
}

/* cSpell:disable */
//For now use full path to extension
List<Extension> extensions = [
  const Extension(
    name: 'Eternl',
    id: 'kmhcihpebfmpgmihbkipmjlmmioameka',
    browser: Browser.chrome,
    extensionPath:
        '/Users/ryszardschossler/Developer/H2B/catalyst-voices/catalyst_voices/packages/internal/catalyst_voices_driver/lib/src/extensions/eternl',
  ),
  const Extension(
    name: 'Typhon',
    id: 'kfdniefadaanbjodldohaedphafoffoh',
    browser: Browser.chrome,
    extensionPath:
        '/Users/ryszardschossler/Developer/H2B/catalyst-voices/catalyst_voices/packages/internal/catalyst_voices_driver/lib/src/extensions/typhon',
  ),
];
/* cSpell:enable */
