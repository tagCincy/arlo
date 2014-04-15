require 'spec_helper'

describe Api::Service::V1::GroupsController do

  describe 'GET index' do

    context 'as authenticated user' do

      login_user

      before :each do
        5.times { create(:group, accounts: [@account]) }
        3.times { create(:group, accounts: 3.times.map { create :account }) }
      end

      it 'should have a valid response' do
        get :index, {format: 'json'}
        expect(response.status).to eq 200
      end

      it 'should show a list of user\'s groups' do
        groups = @account.groups
        get :index, {format: 'json'}
        expect(assigns :groups).to match_array groups
      end

    end

    context 'as unauthenticated user' do

      it 'should have an unauthorized response' do
        get :index, {format: 'json'}
        expect(response.status).to eq 401
      end

    end

  end

  describe 'GET show' do

    context 'as authenticated user' do

      context 'as member' do
        login_user

        before :each do
          @group = create(:group, accounts: [@account])
        end

        it 'should return a valid response' do
          get :show, {format: 'json', id: @group.to_param}
          expect(response.status).to eq 200
        end

        it 'should return the requested group' do
          get :show, {format: 'json', id: @group.to_param}
          expect(assigns :group).to eq @group
        end

      end

      context 'as non-member' do
        login_user

        it 'should return a forbidden response' do
          group = create(:group, accounts: [create(:account)])
          get :show, {format: 'json', id: group.to_param}
          expect(response.status).to eq 403
        end

      end

      context 'as super user' do
        login_super

        it 'should return a valid response' do
          group = create(:group, accounts: [create(:account)])
          get :show, {format: 'json', id: group.to_param}
          expect(response.status).to eq 200
        end
      end

    end

    context 'as unauthenticated user' do

      it 'should return an unauthorized response' do
        group = create(:group, accounts: [create(:account)])
        get :show, {format: 'json', id: group.to_param}
        expect(response.status).to eq 401
      end
    end

  end

  describe 'POST create' do
    let!(:params) { attributes_for :group }

    context 'as authenticated user' do

      context 'as tech user' do
        login_tech

        context 'with valid params' do

          it 'should return a valid response' do
            post :create, {format: 'json', group: params}
            expect(response.status).to eq 201
          end

          it 'should create a group' do
            expect {
              post :create, {format: 'json', group: params}
            }.to change(Group, :count).by 1
          end

          it 'should add the current user as a member' do
            expect {
              post :create, {format: 'json', group: params}
            }.to change(Membership, :count).by 1
          end

          it 'should update the users role to admin' do
            post :create, {format: 'json', group: params}
            account = Account.find(@account.id)
            expect(account.admin?).to be_true
          end

        end

        context 'with invalid params' do

          it 'should return a failure response' do
            group = create :group
            post :create, {format: 'json', group: params.merge(code: group.code)}
            expect(response.status).to eq 422
          end

        end

      end

      context 'as admin user' do
        login_admin

        it 'should return a valid response' do
          post :create, {format: 'json', group: params}
          expect(response.status).to eq 201
        end

      end

      context 'as normal user' do
        login_user

        it 'should return a forbidden response' do
          post :create, {format: 'json', group: params}
          expect(response.status).to eq 403
        end

      end

    end

    context 'as unauthenticated user' do

      it 'should return an unauthorized response' do
        post :create, {format: 'json', group: params}
        expect(response.status).to eq 401
      end

    end

  end

  describe 'PATCH update' do

    context 'as authenticated user' do

      context 'as tech user' do
        login_tech

        it 'should return a forbidden response' do
          group = create(:group, accounts: [@account])
          patch :update, {format: 'json', id: group.to_param, group: {name: 'foobar'}}
          expect(response.status).to eq 403
        end
      end

    end

    context 'as admin user' do
      login_admin

      before :each do
        @group = create(:group, accounts: [@account])
        @name = Faker::Lorem.word
      end

      context 'with valid params' do
        it 'should return a valid response' do
          patch :update, {format: 'json', id: @group.to_param, group: {name: @name}}
          expect(response.status).to eq 200
        end

        it 'should update the group name' do
          patch :update, {format: 'json', id: @group.to_param, group: {name: @name}}
          expect(assigns(:group).name).to eq @name
        end
      end

      context 'with invalid params' do

        it 'should return a failure response' do
          group = create :group
          patch :update, {format: 'json', id: @group.to_param, group: {name: group.name}}
          expect(response.status).to eq 422
        end

        it 'should not allow updating the code' do
          patch :update, {format: 'json', id: @group.to_param, group: {code: 'foobar'}}
          expect(response.status).to eq 422
        end
      end

    end

    context 'as normal user' do
      login_user

      it 'should return a forbidden response' do
        group = create(:group, accounts: [@account])
        patch :update, {format: 'json', id: group.to_param, group: {name: 'foobar'}}
        expect(response.status).to eq 403
      end

    end

    context 'as super user' do
      login_super

      it 'should return a valid response' do
        group = create :group
        patch :update, {format: 'json', id: group.to_param, group: {name: 'foobar'}}
        expect(response.status).to eq 200
      end

    end

    context 'as unauthenticated user' do

      it 'should return an unauthorized response' do
        group = create(:group)
        patch :update, {format: 'json', id: group.to_param, group: {name: 'foobar'}}
        expect(response.status).to eq 401
      end
    end

  end

  describe 'DELETE destroy' do

    context 'as authenticated user' do

      context 'as tech user' do
        login_tech

        it 'should return a forbidden response' do
          group = create(:group, accounts: [@account])
          delete :destroy, {format: 'json', id: group.to_param}
          expect(response.status).to eq 403
        end
      end

    end

    context 'as admin user' do
      login_admin

      context 'with valid params' do
        it 'should return a valid response' do
          group = create(:group, accounts: [@account])
          delete :destroy, {format: 'json', id: group.to_param}
          expect(response.status).to eq 200
        end

        it 'should update remove the group' do
          group = create(:group, accounts: [@account])
          expect {
            delete :destroy, {format: 'json', id: group.to_param}
          }.to change(Group, :count).by -1
        end

        it 'should update remove the membership' do
          group = create(:group, accounts: [@account])
          expect {
            delete :destroy, {format: 'json', id: group.to_param}
          }.to change(Membership, :count).by -1
        end
      end

    end

    context 'as normal user' do
      login_user

      it 'should return a forbidden response' do
        group = create(:group, accounts: [@account])
        delete :destroy, {format: 'json', id: group.to_param}
        expect(response.status).to eq 403
      end

    end

    context 'as super user' do
      login_super

      it 'should return a valid response' do
        group = create(:group)
        delete :destroy, {format: 'json', id: group.to_param}
        expect(response.status).to eq 200
      end

    end

    context 'as unauthenticated user' do

      it 'should return a valid response' do
        group = create(:group)
        delete :destroy, {format: 'json', id: group.to_param}
        expect(response.status).to eq 401
      end
    end

  end
end



