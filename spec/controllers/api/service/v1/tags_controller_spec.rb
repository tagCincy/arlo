require 'spec_helper'

describe Api::Service::V1::TagsController do

  describe "GET index" do
    context 'as authenticated user' do
      login_user

      context 'without query' do
        before :each do
          5.times { create :tag }
        end

        it 'should return a valid response' do
          get :index, {format: 'json'}
          expect(response.status).to eq 200
        end

        it 'should return all tags' do
          tags = Tag.all
          get :index, {format: 'json'}
          expect(assigns :tags).to match_array tags
        end
      end

      context 'with query' do
        before :each do
          @tags = []
          @tags << create(:tag, name: 'foo')
          @tags << create(:tag, name: 'bar')
        end

        it 'should only grab "foo" record' do
          get :index, {format: 'json', q: 'f'}
          expect(assigns(:tags).first.name).to eq 'foo'
        end
      end

    end

    context 'as unauthenticated user' do

      it 'should return a unauthorized response' do
        get :index, {format: 'json'}
        expect(response.status).to eq 401
      end

    end
  end

  describe 'POST create' do

  end

  describe "PATCH update" do

  end

  describe "DELETE destroy" do

  end


end
