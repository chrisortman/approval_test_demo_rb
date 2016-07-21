require 'spec_helper'

describe 'Traditional specification test' do

  class Customer
    attr_accessor :first_name, :last_name

    def full_name
      "#{first_name} #{last_name}"
    end
  end

  subject {
    c = Customer.new
    c.first_name = 'Bart'
    c.last_name = 'Simpson'
    c
  }

  it 'can expect full name' do

    expect(subject.full_name).to eq("Bart Simpson")
  end

  it 'can approve full name' do
    verify do
      subject.full_name
    end
  end
end
