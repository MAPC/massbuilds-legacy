# Matches /developments, /developments/new, and /developments/:id/edit
EMBER_PATH_REGEX = /^\/developments\/?(new|\d+\/?edit|\/?$)/.freeze

Rails.configuration.middleware.use Browser::Middleware do
  # TODO: Add developments#edit and developments#new path to matchers.
  if request.env['PATH_INFO'].match(EMBER_PATH_REGEX)
    # The "modern" detection allows IE9, but we can't support IE9.
    # So, if the "modern" check passes, we also need to check
    # If the browser is not modern, or it's IE 9, redirect the user.
    redirect_to upgrade_path if !browser.modern? || browser.ie?(9)
  end
end
