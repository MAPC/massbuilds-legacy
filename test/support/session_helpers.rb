module SessionHelpers

  def sign_up_with(email, password, options = {})
    visit  = options.fetch(:visit) { false }
    submit = options.fetch(:submit) { false }

    visit signup_path if visit

    fill_in 'Email',    with: email
    fill_in 'Password', with: password
    fill_in 'Password confirmation', with: password
    click_button 'Sign up' if submit
  end

  def sign_in(user, options = {})
    visit signin_path if options.fetch(:visit, false)
    fill_in 'Email',    with: options.fetch(:email)    { user.email }
    fill_in 'Password', with: options.fetch(:password) { user.password }
    check_remember_box(options)
    click_button 'Log in' if options.fetch(:submit, false)
  end

  def sign_out(*)
    # Might try `visit signout_path, method: :delete`
    click_link 'Log out'
  end

  def request_password_reset_for(user, options = {})
    visit new_password_reset_path
    fill_in 'Email', with: options.fetch(:email) { user.email }
    click_button 'Request password reset'
  end

  def set_password(options = {})
    password = options.fetch(:password)     { 'v4lidp4ssw0rd' }
    confirm  = options.fetch(:confirmation) { password }
    fill_in 'Password',              with: password
    fill_in 'Password confirmation', with: confirm
    click_button 'Update password'
  end

  private

  def check_remember_box(options = {})
    box = 'Remember me'
    checked = options.fetch(:remember) { true }
    checked ? check(box) : uncheck(box)
  end

end
