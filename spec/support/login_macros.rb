module LoginMacros

  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @account = create :account
      sign_in @account.user
    end
  end

  def login_tech
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @account = create :account
      @account.tech!
      sign_in @account.user
    end
  end

  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @account = create :account
      @account.admin!
      sign_in @account.user
    end
  end

  def login_super
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @account = create :account
      @account.super!
      sign_in @account.user
    end
  end

end