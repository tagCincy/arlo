# require 'spec_helper'
#
# describe AccountPolicy do
#
#   subject {AccountPolicy.new(account, account)}
#   let(:account) { create :account }
#
#   describe 'account#update' do
#
#     it 'should allow the account.user' do
#       should permit_action(:update)
#     end
#
#     context 'non account user' do
#       let(:account) { create :account }
#
#       it 'should not permit a non account user' do
#         should_not permit_action(:update)
#       end
#
#       it 'should permit a super user' do
#         account.super!
#         should permit_action(:update)
#       end
#     end
#   end
#
#   describe 'account#destroy' do
#
#     it 'should not allow the account.user' do
#       should_not permit_action(:update)
#     end
#
#     context 'non account user' do
#       let(:account) { create :account }
#
#       it 'should not permit a non account user' do
#         should_not permit_action(:update)
#       end
#
#       it 'should permit a super user' do
#         account.super!
#         should permit_action(:update)
#       end
#     end
#   end
# end