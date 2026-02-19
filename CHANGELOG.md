## 0.0.6+0

* Updated logger internals for `talker` `5.1.13`.
* Added direct dependency on `talker_logger` `5.1.13`.
* Fixed `truncateMessage` propagation in `logMessage`.
* Reworked long message splitting logic to avoid deprecated `RegExp` usage.
* Updated test setup (`test/logger_test.dart`) to match Flutter test discovery.
* General lint and API compatibility cleanup.

### BREAKING CHANGE

* Version upgrade to `0.0.7+0` with migration to `talker` `5.x`.
  If your project was pinned to `talker` `4.x` behavior/APIs, update integration accordingly.

## 0.0.1

* Initial release.
