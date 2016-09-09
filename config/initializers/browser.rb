Rails.configuration.middleware.use Browser::Middleware do

  # TODO: Add developments#edit path to matchers.
  if request.env['PATH_INFO'] == '/developments'
    # The "modern" detection allows IE9, but we can't support IE9.
    # So, if the "modern" check passes, we also need to check
    # If the browser is not modern, or it's IE 9, redirect the user.
    redirect_to upgrade_path if !browser.modern? || browser.ie?(9)
  end
end
