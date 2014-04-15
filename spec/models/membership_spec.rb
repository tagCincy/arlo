require 'spec_helper'

describe Membership do

  describe 'associations' do
    it { should belong_to :account }
    it { should belong_to :group }
  end
end
