class RegistrationsController < ApplicationController
  def create
    user = User.create!(
      email: params['user']['email'],
      password: params['user']['password'],
      password_confirmation: params['user']['password_confirmation'],
      name: params['user']['name'],
      photo: params['user']['photo'],
      role: params['user']['role']
    )

    if user
      user.name=params['user']['name']
      user.photo=params['user']['photo']
      user.role=params['user']['role']
      user.save
      session[:user_id] = user.id
      render json: {
        status: :created,
        user: user
      }
    else
      render json: { status: 500 }
    end

  end

  protected


end
