require 'spec_helper'

describe "Static pages" do

  subject { page }

  describe "Home page" do
    before { visit root_path }

    it { should have_content('Auction') }
    it { should have_title(full_title('Home')) }
  end
  
end
