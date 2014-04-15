require 'spec_helper'

describe Api::Service::V1::QuestionsController do

  describe 'GET index' do

    before :each do
      10.times { create :question }
    end

    context 'as authenticated user' do
      login_user

      it 'should have a valid response' do
        get :index, format: 'json'
        expect(response.status).to eq 200
      end

      it 'should return an array of the questions' do
        get :index, format: 'json'
        questions = Question.all
        expect(assigns :questions).to match_array questions.to_a
      end
    end

    context 'as unauthenticated user' do

      it 'should have a unauthorized response' do
        get :index, format: 'json'
        expect(response.status).to eq 200
      end
    end
  end

  describe 'GET show' do

    before :each do
      @question = create :question
    end

    context 'as authenticated user' do
      login_user

      it 'should have a valid response' do
        get :show, {format: 'json', id: @question.to_param}
        expect(response.status).to eq 200
      end

      it 'assigns the requested question as @question' do
        get :show, {format: 'json', id: @question.to_param}
        expect(assigns :question).to eq(@question)
      end

      context 'as non-group user' do

        it 'should forbid non-public questions' do
          @account.groups << create(:group)
          question = create(:question, group: create(:group), public: false)
          get :show, {format: 'json', id: question.to_param}
          expect(response.status).to eq 403

        end

      end

    end

    context 'as unauthenticated user' do

      it 'should have a unauthenticated response if question isn\'t public' do
        question = create(:question, group: create(:group), public: false)
        get :show, {format: 'json', id: question.to_param}
        expect(response.status).to eq 401
      end

      it 'should have a valid response if the question is public' do
        question = create(:question, group: create(:group), public: true)
        get :show, {format: 'json', id: question.to_param}
        expect(response.status).to eq 200
      end
    end
  end

  describe 'POST create' do

    let!(:params) { attributes_for(:question_params) }

    context 'as authenticated user' do
      login_user

      context 'with valid params' do

        it 'should return a valid response' do
          post :create, {format: 'json', question: params}
          expect(response.status).to eql 201
        end

        it 'should create an question record' do
          expect {
            post :create, {format: 'json', question: params}
          }.to change(Question, :count).by 1
        end

        it 'should render show after creation' do
          post :create, {format: 'json', question: params}
          expect(response).to render_template :show
        end
      end

      context 'with invalid params' do

        it 'should return a failure response without required question attributes' do
          post :create, {format: 'json', question: params.merge(content: '')}
          expect(response.status).to eql 422
        end

      end
    end

    context 'as unauthenticated user' do

      it 'should return a forbidden response' do
        post :create, {format: 'json', question: params}
        expect(response.status).to eql 401
      end

    end
  end

  describe 'PATCH update' do

    context 'as question owner' do
      login_user

      before :each do
        @question = create(:question, account_id: @account.id)
      end

      context 'with valid params' do

        before :each do
          @content = Faker::Lorem.paragraph
        end

        it 'should return a valid response' do
          patch :update, {format: :json, id: @question.to_param, question: {content: @content}}
          expect(response.status).to eq 200
        end

        it 'updates the requested question' do
          patch :update, {format: :json, id: @question.to_param, question: {content: @content}}
          expect(assigns(:question).content).to eq @content
        end

        it 'should return the requested question' do
          patch :update, {format: :json, id: @question.to_param, question: {content: @content}}
          expect(assigns(:question)).to eq @question
        end

        it 'should render the show template' do
          patch :update, {format: :json, id: @question.to_param, question: {content: @content}}
          expect { response }.to render_template :show
        end
      end

      context 'with invalid params' do

        it 'should return a failure response' do
          patch :update, {format: 'json', id: @question.to_param, question: {content: ''}}
          expect(response.status).to eq 422
        end
      end
    end

    context 'as non-owner account' do
      login_user

      context 'non-admin user' do
        login_user

        it 'should return an forbidden response' do
          question = create(:question)
          content = Faker::Lorem.paragraph
          patch :update, {format: :json, id: question.to_param, question: {content: content}}
          expect(response.status).to eq 403
        end
      end

      context 'admin user' do
        login_admin

        it 'should return a valid response' do
          group = create(:group)
          @account.groups << group
          question = create(:question, group: group)
          patch :update, {format: :json, id: question.to_param, question: {content: 'foobar'}}
          expect(response.status).to eq 200
        end
      end
    end

    context 'as super user' do
      login_super

      it 'should return a valid response' do
        question = create(:question)
        content = Faker::Lorem.paragraph
        patch :update, {format: :json, id: question.to_param, question: {content: content}}
        expect(response.status).to eq 200
      end
    end

    context 'as unauthenticated user' do

      it 'should return a forbidden response' do
        question = create(:question)
        content = Faker::Lorem.paragraph
        patch :update, {format: :json, id: question.to_param, question: {content: content}}
        expect(response.status).to eq 401
      end
    end
  end

  describe 'DELETE destroy' do

    context 'as authenticated user' do

      context 'as owner' do
        login_user

        before :each do
          @question = create(:question, account_id: @account.id)
        end

        it 'should return a valid response' do
          delete :destroy, {format: :json, id: @question.to_param}
          expect(response.status).to eq 200
        end

        it 'destroys the requested question' do
          expect {
            delete :destroy, {format: :json, id: @question.to_param}
          }.to change(Question, :count).by(-1)
        end
      end

      context 'as non-owner' do
        login_user

        before :each do
          @question = create(:question)
        end

        it 'should return a forbidden response' do
          delete :destroy, {format: :json, id: @question.to_param}
          expect(response.status).to eq 403
        end
      end

      context 'as super user' do
        login_super

        before :each do
          @question = create(:question)
        end

        it 'should return a valid response' do
          delete :destroy, {format: :json, id: @question.to_param}
          expect(response.status).to eq 200
        end
      end
    end

    context 'as unauthenticated user' do

      it 'should return an unathorized response' do
        @question = create :question
        delete :destroy, {format: :json, id: @question.to_param}
        expect(response.status).to eq 401
      end
    end
  end

end
