require 'spec_helper'
require 'json'
describe 'A slightly less contrived example' do

  class Customer
    attr_accessor :first_name, :last_name, :birthday, :drivers_license, :home_address,:phone1,:phone2,:ssn

    def initialize
      yield self if block_given?
    end

    def created_at
      Time.now
    end

    def full_name
      "#{first_name} #{last_name}"
    end

    def to_xml
      xml = <<EOF
<Customer>
  <Firstname>#{first_name}</Firstname>
  <Lastname>#{last_name}</Lastname>
  <Birthday>#{birthday}</Birthday>
  <HomeAddress>
    <City>#{home_address.city}</City>
    <State>#{home_address.state}</State>
    <Zip>#{home_address.zip}</Zip>
  </HomeAddress>
  <DriversLicense>#{drivers_license}</DriversLicense>
  <SSN>#{ssn}</SSN>
  <Phone1>#{phone1}</Phone1>
  <Phone2>#{phone2}</Phone2>
</Customer>
EOF
    end

    def to_json
      JSON.generate({
        :first_name => first_name,
        :last_name => last_name,
        :birthday => birthday,
        :home_address => {
          :city => home_address.city,
          :state => home_address.state,
          :zip => home_address.zip
        },
        :drivers_license => drivers_license,
        :ssn => ssn,
        :phone1 => phone1,
        :phone2 => phone2,
        :created_at => created_at
      })
    end
  end

  class Address
    attr_accessor :city, :state, :zip

    def initialize
      yield self if block_given?
    end
  end

  subject do
    Customer.new do |c|
      c.first_name = 'Bart'
      c.last_name = 'Simpson'
      c.birthday = Date.new(1989,12,17)
      c.drivers_license = 'EatMyShorts'
      c.home_address = Address.new do |a|
        a.city = 'Springfield'
        a.state = 'XY'
        a.zip = '55555'
      end
      c.phone1 = '1112223333'
      c.phone2 = '9998887777'
      c.ssn = '123456780'
    end
  end

  it 'can check expected xml' do
    customer_xml =<<EOF
<Customer>
  <Firstname>Bart</Firstname>
  <Lastname>Simpson</Lastname>
  <Birthday>1989-12-17T00:00:00</Birthday>
  <HomeAddress>
    <City>Springfield</City>
    <State>XY</State>
    <Zip>55555</Zip>
  </HomeAddress>
  <DriversLicense>EatMyShorts</DriversLicense>
  <SSN>123456789</SSN>
  <Phone1>1112223333</Phone1>
  <Phone2>9998887777</Phone2>
</Customer>
EOF

    expect(subject.to_xml).to eq(customer_xml)
  end

  it 'can approve xml' do
    verify :format => :xml do
      subject.to_xml
    end
  end

  it 'can approve json' do
    verify :format => :json do
      subject.to_json
    end
  end
end
    # Approvals.configure do |c|
    #   c.excluded_json_keys = {:create_date => /^created_at$/}
    # end
