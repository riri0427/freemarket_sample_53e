class UserSessionController < ApplicationController
  def create_user_session
    # 送られてきたユーザー情報の中に空の値がないか判定
    user_session_params.each do |key, value|
      if value == ""
        redirect_to new_user_registration_path
        return
      end
    end

    # 送られてきたプロフィール情報の中に空の値がないかを判定
    profile_session_params.each do |key, value|
      if value == ""
        redirect_to new_user_registration_path
        return
      end
    end

    # パスワードが英数字6文字以上かどうかを判定
    unless user_session_params[:password].match(/[a-zA-Z0-9]{6,}/)
      redirect_to new_user_registration_path
      return
    end

    # passwordとpassword_confirmationが一致しているかどうかを判定
    if user_session_params[:password] != user_session_params[:password_confirmation]
      redirect_to new_user_registration_path
      return
    end

    session[:nickname] = user_session_params[:nickname]
    session[:email] = user_session_params[:email]
    session[:password] = user_session_params[:password]
    session[:password_confirmation] = user_session_params[:password_confirmation]

    session[:family_name] = profile_session_params[:family_name]
    session[:first_name] = profile_session_params[:first_name]
    session[:family_name_kana] = profile_session_params[:family_name_kana]
    session[:first_name_kana] = profile_session_params[:family_name_kana]

    redirect_to controller: 'profiles', action: 'new_3'
  end

  def session_address
    # 送られてきた住所情報の中に空の値がないかを判定(building以外)
    address_session_params.each do |key, value|
      if key != 'building'
        if value == ""
          redirect_to '/profiles/new_4'
          return
        end
      end
    end

    session[:postal_code] = address_session_params[:postal_code]
    session[:prefecture] = address_session_params[:prefecture]
    session[:city] = address_session_params[:city]
    session[:block] = address_session_params[:block]
    session[:building] = address_session_params[:building]

    redirect_to controller: :profiles, action: :new_5
  end

  private

  def user_session_params
    params.require(:user).permit(:nickname, :email, :password, :password_confirmation)
  end

  def profile_session_params
    profile_param = params.require(:user)
    profile_param.require(:profile).permit(:family_name, :first_name, :family_name_kana, :first_name_kana)
  end

  def address_session_params
    params.permit(:postal_code, :prefecture, :city, :block, :building)
  end
end
