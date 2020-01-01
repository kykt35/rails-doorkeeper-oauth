# frozen_string_literal: true

class TokenController < Doorkeeper::TokensController
  def create
    refresh_token_expiration = 1.days

    if params[:grant_type] == 'refresh_token' && params[:refresh_token]
      access_token = Doorkeeper::AccessToken.by_refresh_token(params[:refresh_token])

      # refresh_tokenの有効確認
      if (access_token.created_at + refresh_token_expiration).to_i < Time.current.to_i # 期限切れ
        access_token.revoke
      end

    end
    super()
  end
end
