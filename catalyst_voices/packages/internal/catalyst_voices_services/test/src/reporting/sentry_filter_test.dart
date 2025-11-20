import 'package:catalyst_voices_services/src/reporting/sentry_reporting_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() {
  group(SentryReportingService, () {
    group('filterThirdPartyErrors', () {
      test('should keep events without exceptions', () {
        final event = SentryEvent();

        final result = SentryReportingService.filterThirdPartyErrors(
          event,
          Hint(),
        );

        expect(result, equals(event));
      });

      test('should keep events with empty exceptions list', () {
        final event = SentryEvent(exceptions: []);

        final result = SentryReportingService.filterThirdPartyErrors(
          event,
          Hint(),
        );

        expect(result, equals(event));
      });

      test('should keep regular app errors without extension frames', () {
        final event = SentryEvent(
          exceptions: [
            SentryException(
              type: 'StateError',
              value: 'Something went wrong',
              stackTrace: SentryStackTrace(
                frames: [
                  SentryStackFrame(
                    package: 'catalyst_voices',
                    fileName: 'wallet_link_cubit.dart',
                    function: 'selectWallet',
                  ),
                  SentryStackFrame(
                    package: 'flutter',
                    fileName: 'framework.dart',
                  ),
                ],
              ),
            ),
          ],
        );

        final result = SentryReportingService.filterThirdPartyErrors(
          event,
          Hint(),
        );

        expect(result, equals(event));
      });

      test('should filter Talisman extension error without app frames', () {
        final event = SentryEvent(
          exceptions: [
            SentryException(
              type: 'Error',
              value:
                  'Talisman extension has not been configured yet. Please continue with onboarding.',
              stackTrace: SentryStackTrace(
                frames: [
                  SentryStackFrame(
                    absPath:
                        'chrome-extension://fijngjgcjhjmmpcmkeiomlglpeiijkld/page.js', // cspell:disable-line
                    fileName: 'page.js',
                    function: 'handleResponse',
                  ),
                ],
              ),
            ),
          ],
        );

        final result = SentryReportingService.filterThirdPartyErrors(
          event,
          Hint(),
        );

        expect(result, isNull, reason: 'Should filter pure extension errors');
      });

      test('should filter MetaMask extension error without app frames', () {
        final event = SentryEvent(
          exceptions: [
            SentryException(
              type: 'Error',
              value: 'MetaMask is not installed',
              stackTrace: SentryStackTrace(
                frames: [
                  SentryStackFrame(
                    absPath:
                        'chrome-extension://nkbihfbeogaeaoehlefnkodbefgpgknn/inpage.js', // cspell:disable-line
                    fileName: 'inpage.js', // cspell:disable-line
                  ),
                ],
              ),
            ),
          ],
        );

        final result = SentryReportingService.filterThirdPartyErrors(
          event,
          Hint(),
        );

        expect(result, isNull);
      });

      test('should filter Firefox extension error without app frames', () {
        final event = SentryEvent(
          exceptions: [
            SentryException(
              type: 'Error',
              value: 'Extension error',
              stackTrace: SentryStackTrace(
                frames: [
                  SentryStackFrame(
                    absPath: 'moz-extension://abc123-def456/content.js',
                    fileName: 'content.js',
                  ),
                ],
              ),
            ),
          ],
        );

        final result = SentryReportingService.filterThirdPartyErrors(
          event,
          Hint(),
        );

        expect(result, isNull);
      });

      test('should filter Safari extension error without app frames', () {
        final event = SentryEvent(
          exceptions: [
            SentryException(
              type: 'Error',
              value: 'Extension error',
              stackTrace: SentryStackTrace(
                frames: [
                  SentryStackFrame(
                    absPath: 'safari-web-extension://ABC123/script.js',
                    fileName: 'script.js',
                  ),
                ],
              ),
            ),
          ],
        );

        final result = SentryReportingService.filterThirdPartyErrors(
          event,
          Hint(),
        );

        expect(result, isNull);
      });

      test('should keep wallet error with catalyst_cardano frames (real wallet interaction)', () {
        final event = SentryEvent(
          exceptions: [
            SentryException(
              type: 'WalletApiException',
              value: 'User declined connection',
              stackTrace: SentryStackTrace(
                frames: [
                  SentryStackFrame(
                    absPath: 'chrome-extension://eternl-extension-id/api.js',
                    fileName: 'api.js',
                    function: 'enable',
                  ),
                  SentryStackFrame(
                    package: 'catalyst_cardano',
                    fileName: 'wallet_proxy.dart',
                    function: 'enable',
                  ),
                  SentryStackFrame(
                    package: 'catalyst_voices',
                    fileName: 'wallet_link_cubit.dart',
                    function: 'selectWallet',
                  ),
                ],
              ),
            ),
          ],
        );

        final result = SentryReportingService.filterThirdPartyErrors(
          event,
          Hint(),
        );

        expect(
          result,
          equals(event),
          reason: 'Should keep errors involving app code',
        );
      });

      test('should keep error with catalyst package in absPath', () {
        final event = SentryEvent(
          exceptions: [
            SentryException(
              type: 'Error',
              value: 'Something failed',
              stackTrace: SentryStackTrace(
                frames: [
                  SentryStackFrame(
                    absPath: 'chrome-extension://eternl/api.js',
                    fileName: 'api.js',
                  ),
                  SentryStackFrame(
                    absPath: '/path/to/catalyst_voices/lib/main.dart',
                    fileName: 'main.dart',
                  ),
                ],
              ),
            ),
          ],
        );

        final result = SentryReportingService.filterThirdPartyErrors(
          event,
          Hint(),
        );

        expect(result, equals(event));
      });

      test('should handle case-insensitive matching', () {
        final event = SentryEvent(
          exceptions: [
            SentryException(
              type: 'Error',
              value: 'Test',
              stackTrace: SentryStackTrace(
                frames: [
                  SentryStackFrame(
                    absPath: 'CHROME-EXTENSION://ABC123/page.js',
                    fileName: 'page.js',
                  ),
                  SentryStackFrame(
                    package: 'CATALYST_VOICES',
                    fileName: 'test.dart',
                  ),
                ],
              ),
            ),
          ],
        );

        final result = SentryReportingService.filterThirdPartyErrors(
          event,
          Hint(),
        );

        expect(
          result,
          equals(event),
          reason: 'Should handle uppercase catalyst package names',
        );
      });

      test('should keep error with catalyst_cardano_web package', () {
        final event = SentryEvent(
          exceptions: [
            SentryException(
              type: 'Error',
              value: 'Web error',
              stackTrace: SentryStackTrace(
                frames: [
                  SentryStackFrame(
                    absPath: 'chrome-extension://wallet/api.js',
                    fileName: 'api.js',
                  ),
                  SentryStackFrame(
                    package: 'catalyst_cardano_web',
                    fileName: 'interop.dart',
                  ),
                ],
              ),
            ),
          ],
        );

        final result = SentryReportingService.filterThirdPartyErrors(
          event,
          Hint(),
        );

        expect(
          result,
          equals(event),
          reason: 'Should match all catalyst_* packages',
        );
      });

      test('should handle exception without stack trace', () {
        final event = SentryEvent(
          exceptions: [
            SentryException(
              type: 'Error',
              value: 'No stack trace',
            ),
          ],
        );

        final result = SentryReportingService.filterThirdPartyErrors(
          event,
          Hint(),
        );

        expect(
          result,
          equals(event),
          reason: 'Should keep events without stack traces',
        );
      });

      test('should handle multiple exceptions - filter if all are extensions', () {
        final event = SentryEvent(
          exceptions: [
            SentryException(
              type: 'Error',
              value: 'Extension error 1',
              stackTrace: SentryStackTrace(
                frames: [
                  SentryStackFrame(
                    absPath: 'chrome-extension://ext1/page.js',
                    fileName: 'page.js',
                  ),
                ],
              ),
            ),
            SentryException(
              type: 'Error',
              value: 'Extension error 2',
              stackTrace: SentryStackTrace(
                frames: [
                  SentryStackFrame(
                    absPath: 'chrome-extension://ext2/script.js',
                    fileName: 'script.js',
                  ),
                ],
              ),
            ),
          ],
        );

        final result = SentryReportingService.filterThirdPartyErrors(
          event,
          Hint(),
        );

        expect(
          result,
          isNull,
          reason: 'Should filter if all exceptions are from extensions',
        );
      });

      test('should keep if any exception has app frames', () {
        final event = SentryEvent(
          exceptions: [
            SentryException(
              type: 'Error',
              value: 'Extension error',
              stackTrace: SentryStackTrace(
                frames: [
                  SentryStackFrame(
                    absPath: 'chrome-extension://ext1/page.js',
                    fileName: 'page.js',
                  ),
                ],
              ),
            ),
            SentryException(
              type: 'AppError',
              value: 'App error',
              stackTrace: SentryStackTrace(
                frames: [
                  SentryStackFrame(
                    package: 'catalyst_voices',
                    fileName: 'app.dart',
                  ),
                ],
              ),
            ),
          ],
        );

        final result = SentryReportingService.filterThirdPartyErrors(
          event,
          Hint(),
        );

        expect(
          result,
          equals(event),
          reason: 'Should keep if any exception involves app code',
        );
      });

      test('should handle frames with null absPath and package', () {
        final event = SentryEvent(
          exceptions: [
            SentryException(
              type: 'Error',
              value: 'Test',
              stackTrace: SentryStackTrace(
                frames: [
                  SentryStackFrame(
                    fileName: 'unknown.js',
                  ),
                ],
              ),
            ),
          ],
        );

        final result = SentryReportingService.filterThirdPartyErrors(
          event,
          Hint(),
        );

        expect(
          result,
          equals(event),
          reason: 'Should handle null values gracefully',
        );
      });

      // Real-world extension errors found in Sentry
      group('real-world extension errors', () {
        test('should filter MetaMask connection error', () {
          final event = SentryEvent(
            exceptions: [
              SentryException(
                type: 'Error',
                value: 'Failed to connect to MetaMask',
                stackTrace: SentryStackTrace(
                  frames: [
                    SentryStackFrame(
                      absPath:
                          'chrome-extension://nkbihfbeogaeaoehlefnkodbefgpgknn/scripts/inpage.js', // cspell:disable-line
                      fileName: 'inpage.js', // cspell:disable-line
                      function: 'connect',
                    ),
                  ],
                ),
              ),
            ],
          );

          final result = SentryReportingService.filterThirdPartyErrors(
            event,
            Hint(),
          );

          expect(
            result,
            isNull,
            reason: 'Should filter MetaMask errors without app involvement',
          );
        });

        test('should filter Lace wallet RemoteApiShutdownError', () {
          final event = SentryEvent(
            exceptions: [
              SentryException(
                type: 'RemoteApiShutdownError',
                value: "Remote API with channel 'lace-features' was shutdown",
                stackTrace: SentryStackTrace(
                  frames: [
                    SentryStackFrame(
                      absPath:
                          'chrome-extension://gafhhkghbfjjkeiendhlofajokpaflmk/app/content.js', // cspell:disable-line
                      fileName: 'content.js',
                    ),
                  ],
                ),
              ),
            ],
          );

          final result = SentryReportingService.filterThirdPartyErrors(
            event,
            Hint(),
          );

          expect(
            result,
            isNull,
            reason: 'Should filter Lace wallet internal errors',
          );
        });

        test('should filter generic wallet extension TypeError', () {
          final event = SentryEvent(
            exceptions: [
              SentryException(
                type: 'TypeError',
                value: "Cannot read properties of undefined (reading 'removeListener')",
                stackTrace: SentryStackTrace(
                  frames: [
                    SentryStackFrame(
                      absPath:
                          'chrome-extension://opfgelmcmbiajamepnmloijbpoleiama/inpage.js', // cspell:disable-line
                      fileName: 'inpage.js', // cspell:disable-line
                    ),
                  ],
                ),
              ),
            ],
          );

          final result = SentryReportingService.filterThirdPartyErrors(
            event,
            Hint(),
          );

          expect(
            result,
            isNull,
            reason: 'Should filter wallet extension TypeErrors',
          );
        });

        test('should filter wallet ethereum injection error', () {
          final event = SentryEvent(
            exceptions: [
              SentryException(
                type: 'TypeError',
                value: 'Cannot set property ethereum of #<Window> which has only a getter',
                stackTrace: SentryStackTrace(
                  frames: [
                    SentryStackFrame(
                      absPath:
                          'chrome-extension://bopcbmipnjdcdfflfgjdgdjejmgpoaab/blankProvider.js', // cspell:disable-line
                      fileName: 'blankProvider.js',
                      lineNo: 432,
                    ),
                  ],
                ),
              ),
            ],
          );

          final result = SentryReportingService.filterThirdPartyErrors(
            event,
            Hint(),
          );

          expect(
            result,
            isNull,
            reason: 'Should filter ethereum provider injection errors',
          );
        });

        test('should keep Lace error if it occurs during catalyst wallet interaction', () {
          final event = SentryEvent(
            exceptions: [
              SentryException(
                type: 'RemoteApiShutdownError',
                value: 'Remote API was shutdown',
                stackTrace: SentryStackTrace(
                  frames: [
                    SentryStackFrame(
                      absPath:
                          'chrome-extension://gafhhkghbfjjkeiendhlofajokpaflmk/app/content.js', // cspell:disable-line
                      fileName: 'content.js',
                      function: 'AsyncScheduler.flush',
                    ),
                    SentryStackFrame(
                      absPath: 'https://voices.projectcatalyst.io/main.dart.js',
                      fileName: 'main.dart.js',
                      function: 'enable',
                    ),
                  ],
                ),
              ),
            ],
          );

          final result = SentryReportingService.filterThirdPartyErrors(
            event,
            Hint(),
          );

          expect(
            result,
            equals(event),
            reason: 'Should keep Lace errors that occur during app interaction',
          );
        });
      });
    });
  });
}
