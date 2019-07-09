class ProfilesController < ApplicationController
  def new
    @minimum_password_length = 6

    if session[:user]
      @user = User.new(email: session[:user]["email"], nickname: session[:user]["nickname"])
    else
      @user = User.new
    end
    if session[:profile]
      @profile = Profile.new(session[:profile])
    else
      @profile = Profile.new
    end

  def edit_address_delivery
  end

  def edit_create_payment
  end

  def edit_create_payment_list
  end

  def edit_create_payment_show
  end
  
    # セッションを削除
    session[:user] = nil
    session[:profile] = nil
  end
end
