# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource

  def create
    # super
    user = User.new(session[:user])
    if user.save
      profile = user.build_profile(session[:profile])
      profile.save
      address = user.build_address(session[:address])
      address.save
      if Rails.env == 'development'
        Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
      else
        Payjp.api_key = Rails.application.credentials.payjp[:PAYJP_PRIVATE_KEY]
      end
      customer = Payjp::Customer.create(email: user.email, card: params['payjp-token'], metadata: {user_id: user.id})
      credit_card = user.build_credit_card(customer_id: customer.id, card_id: customer.default_card)

      if params['payjp-token'].blank?
        reset_session
        sign_in user
        redirect_to new_user_registration_path
      else
        customer = Payjp::Customer.create(
        email: user.email,
        card: params['payjp-token'],
        metadata: {user_id: user.id}
        )
        credit_card = user.build_credit_card(customer_id: customer.id, card_id: customer.default_card)
        credit_card.save
      end

      # セッションを削除
      reset_session

      sign_in user

      redirect_to done_users_path and return
    else
      reset_session
      redirect_to new_user_registration_path
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end


  protected
  # private

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  def credit_card_params
    date = params["expiration_date(2i)"]
    year = params["expiration_date(1i)"]
    params.permit(:card_number, :security_code).merge(expiration_date: date, expiration_year: year)
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
