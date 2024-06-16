OmniAuth.config.test_mode = true

def set_omniauth_mock_auth
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
    provider: 'google_oauth2',
    uid: '000000',
    info: {
      email: 'test@example.com',
      name: 'Test User'
    },
    credentials: {
      token: 'google_oauth2_test'
    }
  })

  OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
    provider: 'facebook',
    uid: '000001',
    info: {
      email: 'facebook_test@example.com',
      name: 'Facebook User'
    },
    credentials: {
      token: 'facebook_test'
    }
  })
end
