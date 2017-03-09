## 1.3.0

Features:
  - Improve affected user handling to let you specify all Raygun parameters, identifier, email, first name, full name and uuid. See [README.md](https://github.com/MindscapeHQ/raygun4ruby#affected-user-tracking) for details
  - Pass a user object as the third parameter to `Raygun.track_exception` to have affected user tracking for manually tracked exceptions, see the above link for more information on configuring this

## 1.2.1 (09/03/2017)

Bugfixes:
  - dup input hashes before applying whitelist filtering, previously this was modifying the contents of `action_dispatch.request.parameters`

## 1.2.0 (09/03/2017)

Features:
  - Added two new configuration options, `filter_payload_with_whitelist` and `whitelist_payload_shape`
    - See [README.md](https://github.com/MindscapeHQ/raygun4ruby#filtering-the-payload-by-whitelist) for an example of how to use them
  - When raygun4ruby encounters an exception trying to track an exception it will try once to send that exception to Raygun so you are notified

Bugfixes:
  - raygun4ruby will no longer crash and suppress app exceptions when the API key is not configured