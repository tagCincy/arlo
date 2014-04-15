require 'spec_helper'

describe Api::Service::V1::AccountsController do

  describe 'GET index' do

    before :each do
      5.times { create :account }
    end

    context 'as authenticated user' do
      login_user

      it 'should have a valid response' do
        get :index, format: 'json'
        expect(response.status).to eql 200
      end

      it 'should return an array of the accounts' do
        get :index, format: 'json'
        accounts = Account.all
        expect(assigns :accounts).to match_array accounts.to_a
      end
    end

    context 'as unauthenticated user' do

      it 'should have a unauthorized response' do
        get :index, format: 'json'
        expect(response.status).not_to eql 200
      end
    end
  end

  describe 'GET show' do

    before :each do
      @new_account = create :account
    end

    context 'as authenticated user' do
      login_user

      it 'should have a valid response' do
        get :show, {format: 'json', id: @new_account.to_param}
        expect(response.status).to eq 200
      end

      it 'assigns the requested account as @account' do
        get :show, {format: 'json', id: @new_account.to_param}
        expect(assigns :account).to eq(@new_account)
      end
    end

    context 'as unauthenticated user' do

      it 'should have a valid response' do
        get :show, {format: 'json', id: @new_account.to_param}
        expect(response.status).not_to eql 200
      end
    end
  end

  describe 'POST create' do

    let!(:params) { attributes_for(:account_params) }

    context 'with valid params' do

      it 'should return a valid response' do
        post :create, {format: 'json', account: params}
        expect(response.status).to eql 201
      end

      it 'should create an account record' do
        expect {
          post :create, {format: 'json', account: params}
        }.to change(Account, :count).by 1
      end

      it 'should create a user record' do
        expect {
          post :create, {format: 'json', account: params}
        }.to change(User, :count).by 1
      end

      it 'should render show after creation' do
        post :create, {format: 'json', account: params}
        expect(response).to render_template :show
      end
    end

    context 'with invalid params' do

      it 'should return a failure response without required user attributes' do
        post :create, {format: 'json', account: params.merge(user_attributes: {email: ''})}
        expect(response.status).to eql 422
      end

      it 'should return a failure response without required account attributes' do
        post :create, {format: 'json', account: params.merge(username: '')}
        expect(response.status).to eql 422
      end
    end
  end

  describe 'PATCH update' do

    context 'as authenticated user' do

      context 'as account owner' do
        login_user

        context 'with valid params' do

          before :each do
            @bio = Faker::Lorem.paragraph
          end

          it 'should return a valid response' do
            patch :update, {format: :json, id: @account.to_param, account: {bio: @bio}}
            expect(response.status).to eq 200
          end

          it 'updates the requested account' do
            patch :update, {format: :json, id: @account.to_param, account: {bio: @bio}}
            expect(assigns(:account).bio).to eq @bio
          end

          it 'should return the requested account' do
            patch :update, {format: :json, id: @account.to_param, account: {bio: @bio}}
            expect(assigns(:account)).to eq @account
          end

          it 'should render the show template' do
            patch :update, {format: :json, id: @account.to_param, account: {bio: @bio}}
            expect { response }.to render_template :show
          end
        end

        context 'with invalid params' do

          before :each do
            @other_account = create :account
          end

          it 'should return a failure response' do
            patch :update, {format: 'json', id: @account.to_param, account: {username: @other_account.username}}
            expect(response.status).to eq 422
          end
        end
      end

        context 'as non-owner account' do
          login_user

          it 'should return an forbidden response' do
            @other_account = create :account
            @bio = Faker::Lorem.paragraph
            patch :update, {format: :json, id: @other_account.to_param, account: {bio: @bio}}
            expect(response.status).to eq 403
          end
        end

        context 'as super user' do
          login_super

          it 'should return a valid response' do
            @other_account = create :account
            @bio = Faker::Lorem.paragraph
            patch :update, {format: :json, id: @other_account.to_param, account: {bio: @bio}}
            expect(response.status).to eq 200
          end
        end
    end

    context 'as unauthenticated user' do

      it 'should return a forbidden response' do
        @account = create(:account)
        patch :update, {format: :json, id: @account.to_param, account: {username: @username}}
        expect(response.status).to eq 401
      end
    end
  end

  describe 'DELETE destroy' do

    context 'as authenticated user' do

      context 'as super user' do
        login_super

        before :each do
          @other_account = create :account
        end

        it 'should return a valid response' do
          delete :destroy, {format: :json, id: @other_account.to_param}
          expect(response.status).to eq 200
        end

        it 'destroys the requested account' do
          expect {
            delete :destroy, {format: :json, id: @other_account.to_param}
          }.to change(Account, :count).by(-1)
        end

        it 'destroys the requested accounts user' do
          expect {
            delete :destroy, {format: :json, id: @other_account.to_param}
          }.to change(User, :count).by(-1)
        end
      end

      context 'as regular user' do
        login_user

        it 'should return a forbidden response' do
          @other_account = create :account
          delete :destroy, {format: :json, id: @other_account.to_param}
          expect(response.status).to eq 403
        end
      end
    end

    context 'as unauthenticated user' do

      it 'should return an unathorized response' do
        @other_account = create :account
        delete :destroy, {format: :json, id: @other_account.to_param}
        expect(response.status).to eq 401
      end
    end
  end

  describe 'GET current' do

    context 'as authenticated user' do
      login_user

      it 'should return a valid response' do
        get :current, {format: 'json'}
        expect(response.status).to eql 200
      end

      it 'should return the logged in account' do
        get :current, {format: 'json'}
        expect(assigns :account).to eql @account
      end
    end

    context 'as unauthenticated user' do
       it 'should return an unauthorized response' do
         get :current, {format: 'json'}
         expect(response.status).to eql 401
       end
    end
  end

end
