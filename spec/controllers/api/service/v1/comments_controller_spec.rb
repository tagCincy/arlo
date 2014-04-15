require 'spec_helper'

describe Api::Service::V1::CommentsController do


  describe 'POST create' do
    let!(:params) { attributes_for :comment_params }

    before :each do
      @question = create :question
    end

    context 'as authenticated user' do
      login_user

      context 'with valid params' do

        it 'should return a valid response' do
          post :create, {format: 'json', question_id: @question.to_param, comment: params}
          expect(response.status).to eq 201
        end

        it 'should create a new comment' do
          expect {
            post :create, {format: 'json', question_id: @question.to_param, comment: params}
          }.to change(Comment, :count).by 1
        end

      end

      context 'with invalid params' do

        it 'should return a failure response' do
          post :create, {format: 'json', question_id: @question.to_param, comment: {content: ''}}
          expect(response.status).to eq 422
        end

      end

    end

    context 'as unauthenticated user' do

      it 'should return an unauthorized response' do
        post :create, {format: 'json', question_id: @question.to_param, comment: params}
        expect(response.status).to eq 401
      end

    end
  end

  describe 'PATCH update' do

    context 'as authenticated user' do

      context 'as owner' do
        login_user

        before :each do
          @comment = create(:comment, account_id: @account.id)
          @content = Faker::Lorem.sentence
        end

        it 'should return a valid response' do
          patch :update, {format: 'json', id: @comment.to_param, comment: {content: @content}}
          expect(response.status).to eq 200
        end

        it 'should update the comment' do
          patch :update, {format: 'json', id: @comment.to_param, comment: {content: @content}}
          expect(assigns(:comment).content).to eq @content
        end

        it 'should fail without valid params' do
          patch :update, {format: 'json', id: @comment.to_param, comment: {content: ''}}
          expect(response.status).to eq 422
        end

      end

      context 'as non-owner' do
        login_user

        it 'should return a forbidden response' do
          comment = create :comment
          content = Faker::Lorem.sentence
          patch :update, {format: 'json', id: comment.to_param, comment: {content: content}}
          expect(response.status).to eq 403
        end

      end

      context 'as super user' do
        login_super

        it 'should return a valid response' do
          comment = create :comment
          content = Faker::Lorem.sentence
          patch :update, {format: 'json', id: comment.to_param, comment: {content: content}}
          expect(response.status).to eq 200
        end
      end

    end

    context 'as unauthenticated user' do

      it 'should return a unauthorized response' do
        comment = create :comment
        content = Faker::Lorem.sentence
        patch :update, {format: 'json', id: comment.to_param, comment: {content: content}}
        expect(response.status).to eq 401
      end
    end

  end

  describe 'DELETE destroy' do

    context 'as authenticated user' do

      context 'as owner' do
        login_user

        before :each do
          @comment = create(:comment, account_id: @account.id)
        end

        it 'should return a valid response' do
          delete :destroy, {format: 'json', id: @comment.to_param}
          expect(response.status).to eq 200
        end

        it 'should delete the comment' do
          expect {
            delete :destroy, {format: 'json', id: @comment.to_param}
          }.to change(Comment, :count).by -1
        end

      end

      context 'as non-owner' do
        login_user

        it 'should return a forbidden response' do
          comment = create :comment
          delete :destroy, {format: 'json', id: comment.to_param}
          expect(response.status).to eq 403
        end

      end

      context 'as super user' do
        login_super

        it 'should return a valid response' do
          comment = create :comment
          delete :destroy, {format: 'json', id: comment.to_param}
          expect(response.status).to eq 200
        end
      end

    end

    context 'as unauthenticated user' do

      it 'should return a unauthorized response' do
        comment = create :comment
        delete :destroy, {format: 'json', id: comment.to_param}
        expect(response.status).to eq 401
      end

    end

  end
end
