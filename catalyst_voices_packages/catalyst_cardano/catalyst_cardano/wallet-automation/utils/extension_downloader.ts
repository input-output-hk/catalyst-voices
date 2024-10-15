interface PlatformInfo {
  os: string;
  arch: string;
  nacl_arch: string;
}

class ExtensionDownloader {
  public getCrxUrl(extensionIDOrUrl: string | ExtensionID): string {
    let extensionID: string;

    if (typeof extensionIDOrUrl === 'string') {
      const idMatch = this.getExtensionID(extensionIDOrUrl);
      extensionID = idMatch ? idMatch : extensionIDOrUrl;
    } else {
      extensionID = extensionIDOrUrl;
    }

    if (!/^[a-z]{32}$/.test(extensionID)) {
      return extensionIDOrUrl;
    }

    const platformInfo = this.getPlatformInfo();
    const productId = this.isChromeNotChromium() ? 'chromecrx' : 'chromiumcrx';
    const productChannel = 'unknown';
    let productVersion = '9999.0.9999.0';

    const crVersion = /Chrome\/((\d+)\.0\.(\d+)\.\d+)/.exec(navigator.userAgent);
    if (crVersion && +crVersion[2] >= 31 && +crVersion[3] >= 1609) {
      productVersion = crVersion[1];
    }

    let url = 'https://clients2.google.com/service/update2/crx?response=redirect';
    url += '&os=' + platformInfo.os;
    url += '&arch=' + platformInfo.arch;
    url += '&os_arch=' + platformInfo.os_arch;
    url += '&nacl_arch=' + platformInfo.nacl_arch;
    url += '&prod=' + productId;
    url += '&prodchannel=' + productChannel;
    url += '&prodversion=' + productVersion;
    url += '&x=id%3D' + extensionID + '%26installsource%3Dondemand%26uc';
    return url;
  }

  private getExtensionID(url: string): string | null {
    const pattern = /chrome\.google\.com\/webstore\/detail\/[^\/]+\/([a-z]{32})/i;
    const match = pattern.exec(url);
    return match ? match[1] : null;
  }

  private isChromeNotChromium(): boolean {
    return (
      navigator.userAgent.includes('Chrome') &&
      !navigator.userAgent.includes('Chromium')
    );
  }

  private getPlatformInfo(): PlatformInfo & { os_arch: string } {
    const platform = navigator.platform.toLowerCase();
    let os = 'win';
    if (platform.startsWith('mac')) {
      os = 'mac';
    } else if (platform.startsWith('linux')) {
      os = 'linux';
    } else if (platform.startsWith('cros')) {
      os = 'cros';
    }

    const is64Bit = /x86_64|Win64|WOW64|AMD64/.test(navigator.userAgent);
    const arch = is64Bit ? 'x64' : 'x86';
    const os_arch = is64Bit ? 'x86_64' : 'x86';
    const naclArch = is64Bit ? 'x86-64' : 'x86-32';

    return { os, arch, os_arch, nacl_arch: naclArch };
  }
}
