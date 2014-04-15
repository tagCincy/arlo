require 'spec_helper'

describe Api::Service::V1::AnswersController do

  describe 'POST create' do
    let!(:params) { attributes_for :answer_params }

    before :each do
      @question = create :question
    end

    context 'as authenticated user' do

      context 'as tech user' do
        login_tech

        context 'with valid params' do

          it 'should return a valid response' do
            post :create, {format: 'json', question_id: @question.to_param, answer: params}
            expect(response.status).to eq 201
          end

          it 'should create a new answer' do
            expect {
              post :create, {format: 'json', question_id: @question.to_param, answer: params}
            }.to change(Answer, :count).by 1
          end

        end

        context 'with invalid params' do

          it 'should return a failure response' do
            post :create, {format: 'json', question_id: @question.to_param, answer: {content: ''}}
            expect(response.status).to eq 422
          end

        end
      end

      context 'as normal user' do
        login_user

        it 'should return a forbidden response' do
          post :create, {format: 'json', question_id: @question.to_param, answer: params}
          expect(response.status).to eq 403
        end

      end

      context 'as admin user' do
        login_admin

        it 'should return a valid response' do
          post :create, {format: 'json', question_id: @question.to_param, answer: params}
          expect(response.status).to eq 201
        end

      end

      context 'as super user' do
        login_super

        it 'should return a valid response' do
          post :create, {format: 'json', question_id: @question.to_param, answer: params}
          expect(response.status).to eq 201
        end

      end

    end

    context 'as unauthenticated user' do

      it 'should return an unauthorized response' do
        post :create, {format: 'json', question_id: @question.to_param, answer: params}
        expect(response.status).to eq 401
      end

    end
  end

  describe 'PATCH update' do

    context 'as authenticated user' do

      context 'as owner' do
        login_tech

        before :each do
          @answer = create(:answer, account_id: @account.id)
          @content = Faker::Lorem.paragraph
        end

        it 'should return a valid response' do
          patch :update, {format: 'json', id: @answer.to_param, answer: {content: @content}}
          expect(response.status).to eq 200
        end

        it 'should update the answer' do
          patch :update, {format: 'json', id: @answer.to_param, answer: {content: @content}}
          expect(assigns(:answer).content).to eq @content
        end

        it 'should fail without valid params' do
          patch :update, {format: 'json', id: @answer.to_param, answer: {content: ''}}
          expect(response.status).to eq 422
        end

      end

      context 'as non-owner' do
        login_tech

        it 'should return a forbidden response' do
          answer = create :answer
          content = Faker::Lorem.sentence
          patch :update, {format: 'json', id: answer.to_param, answer: {content: content}}
          expect(response.status).to eq 403
        end

      end

      context 'as super user' do
        login_super

        it 'should return a valid response' do
          answer = create :answer
          content = Faker::Lorem.sentence
          patch :update, {format: 'json', id: answer.to_param, answer: {content: content}}
          expect(response.status).to eq 200
        end
      end

    end

    context 'as unauthenticated user' do

      it 'should return a unauthorized response' do
        answer = create :answer
        content = Faker::Lorem.sentence
        patch :update, {format: 'json', id: answer.to_param, answer: {content: content}}
        expect(response.status).to eq 401
      end
    end

  end

  describe 'DELETE destroy' do

    context 'as authenticated user' do

      context 'as owner' do
        login_tech

        before :each do
          @answer = create(:answer, account_id: @account.id)
        end

        it 'should return a valid response' do
          delete :destroy, {format: 'json', id: @answer.to_param}
          expect(response.status).to eq 200
        end

        it 'should delete the answer' do
          expect {
            delete :destroy, {format: 'json', id: @answer.to_param}
          }.to change(Answer, :count).by -1
        end

      end

      context 'as non-owner' do
        login_user

        it 'should return a forbidden response' do
          answer = create :answer
          delete :destroy, {format: 'json', id: answer.to_param}
          expect(response.status).to eq 403
        end

      end

      context 'as super user' do
        login_super

        it 'should return a valid response' do
          answer = create :answer
          delete :destroy, {format: 'json', id: answer.to_param}
          expect(response.status).to eq 200
        end
      end

    end

    context 'as unauthenticated user' do

      it 'should return a unauthorized response' do
        answer = create :answer
        delete :destroy, {format: 'json', id: answer.to_param}
        expect(response.status).to eq 401
      end

    end

  end

end
