class AuthController < ApplicationController
  before_action :authenticate!, only: [:destroy]

  def create
    validate_params
    user_data = social_user_data(auth_params)
    user = authenticate_user(user_data)

    render json: user

    rescue Exceptions::ValidationError => e
      render json: { errors: e.errors }, status: :unprocessable_entity
    rescue NameError, Koala::Facebook::AuthenticationError => e
      render json: { errors: [e.message] },
             status: :unprocessable_entity
  end

  def destroy
    if current_user.destroy_auth_token!
      render json: { success: true }
    else
      render json: { errors: I18n.t('cant_destroy_token') },
             status: :not_acceptable
    end
  end

private

  def authenticate_user(user_auth_params)
    User::Auth::AuthenticateService.new(user_auth_params).call
  end

  def social_user_data(social_params)
    user_data = Social::Api::Client.new(social_params).data

    Social::Transformers::Transformer.new({
      provider: social_params[:provider],
      data: user_data
    }).data
  end

  def auth_params
    params.permit(:provider, :token)
  end

  def validate_params
    errors = {}
    token = auth_params[:token]
    provider = auth_params[:provider]

    errors[:token] = ['Uid cant be blank'] if token.blank?
    errors[:provider] = ['Provider cant be blank'] if provider.blank?

    raise Exceptions::ValidationError.new(errors) if errors.any?
  end
end
