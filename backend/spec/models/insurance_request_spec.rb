require 'rails_helper'

RSpec.describe InsuranceRequest, type: :model do
  let(:user) { create(:user) }
  let(:vehicle) { create(:vehicle, user: user) }
  let(:insurance_request) { build(:insurance_request, user: user, vehicle: vehicle) }

  describe '#validate_user_age?' do
    it 'returns nil for valid age' do
      expect(insurance_request.validate_user_age?).to be_nil
    end

    it 'returns false for age under 20' do
      young_user = create(:user, :young)
      request = build(:insurance_request, user: young_user)
      expect(request.validate_user_age?).to be_falsey
    end

    it 'returns false for age over 80' do
      old_user = create(:user, :old)
      request = build(:insurance_request, user: old_user)
      expect(request.validate_user_age?).to be_falsey
    end

    it 'returns nil when user is not present' do
      request = build(:insurance_request, user: nil)
      expect(request.validate_user_age?).to be_nil
    end
  end

  describe '#validate_vehicle_year?' do
    it 'returns nil for year after 1980' do
      expect(insurance_request.validate_vehicle_year?).to be_nil
    end

    it 'returns false for year before 1980' do
      old_vehicle = create(:vehicle, :old_year, user: user)
      request = build(:insurance_request, vehicle: old_vehicle)
      expect(request.validate_vehicle_year?).to be_falsey
    end

    it 'returns nil when vehicle is not present' do
      request = build(:insurance_request, vehicle: nil)
      expect(request.validate_vehicle_year?).to be_nil
    end
  end

  describe '#validate_vehicle_price?' do
    it 'returns nil for price over 50000' do
      expect(insurance_request.validate_vehicle_price?).to be_nil
    end

    it 'returns false for price under 50000' do
      cheap_vehicle = create(:vehicle, :cheap, user: user)
      request = build(:insurance_request, vehicle: cheap_vehicle)
      expect(request.validate_vehicle_price?).to be_falsey
    end

    it 'returns nil when vehicle is not present' do
      request = build(:insurance_request, vehicle: nil)
      expect(request.validate_vehicle_price?).to be_nil
    end
  end

  describe '#validate_vehicle_owner?' do
    it 'returns nil when vehicle belongs to user' do
      expect(insurance_request.validate_vehicle_owner?).to be_nil
    end

    it 'returns false when vehicle does not belong to user' do
      other_user = create(:user, email: "other@test.com", national_id: "33333333-3")
      request = build(:insurance_request, user: other_user, vehicle: vehicle)
      expect(request.validate_vehicle_owner?).to be_falsey
    end

    it 'returns nil when user or vehicle is not present' do
      request = build(:insurance_request, user: nil, vehicle: nil)
      expect(request.validate_vehicle_owner?).to be_nil
    end
  end

  describe '#owner_risk' do
    it 'calculates risk correctly' do
      allow(ApiInfractionsService).to receive(:get_infractions).and_return(5)
      risk = insurance_request.owner_risk
      age = user.age
      expected = (1 + age / 200) * (5**2 / 2) * 20
      expect(risk).to be_within(0.01).of(expected)
    end

    it 'returns 0 when user has no infractions' do
      allow(ApiInfractionsService).to receive(:get_infractions).and_return(0)
      risk = insurance_request.owner_risk
      expect(risk).to eq(0)
    end
  end

  describe '#vehicle_factor' do
    it 'calculates factor correctly' do
      factor = insurance_request.vehicle_factor
      
      year = vehicle.year.year
      price = vehicle.price
      current_year = Date.today.year
      
      age_factor = (current_year - year) / 100.0
      part_a_numerator = 1 + age_factor
      part_a = (part_a_numerator / 5.0) ** 2
      part_b = 1 + (price / 100000.0)
      expected = part_a * part_b
      
      expect(factor).to be_within(0.01).of(expected)
    end

    it 'returns 0 when vehicle is not present' do
      request = build(:insurance_request, vehicle: nil)
      expect(request.vehicle_factor).to eq(0)
    end

    it 'returns 0 when vehicle year is not present' do
      vehicle_no_year = create(:vehicle, :no_year, user: user)
      request = build(:insurance_request, vehicle: vehicle_no_year)
      expect(request.vehicle_factor).to eq(0)
    end

    it 'returns 0 when vehicle price is not present' do
      vehicle_no_price = create(:vehicle, :no_price, user: user)
      request = build(:insurance_request, vehicle: vehicle_no_price)
      expect(request.vehicle_factor).to eq(0)
    end
  end

  describe '#vehicle_primary_factor' do
    before do
      allow(ApiInfractionsService).to receive(:get_infractions).and_return(3)
    end

    it 'calculates correctly with basic security' do
      factor = insurance_request.vehicle_primary_factor("basic")
      
      owner_risk = insurance_request.owner_risk
      vehicle_factor = insurance_request.vehicle_factor
      expected = (owner_risk * (1 + vehicle_factor)) + 200
      
      expect(factor).to be_within(0.01).of(expected)
    end

    it 'calculates correctly with medium security' do
      factor = insurance_request.vehicle_primary_factor("medium")
      
      owner_risk = insurance_request.owner_risk
      vehicle_factor = insurance_request.vehicle_factor
      expected = (owner_risk * (1 + vehicle_factor)) + 350
      
      expect(factor).to be_within(0.01).of(expected)
    end

    it 'calculates correctly with high security' do
      factor = insurance_request.vehicle_primary_factor("high")
      
      owner_risk = insurance_request.owner_risk
      vehicle_factor = insurance_request.vehicle_factor
      expected = (owner_risk * (1 + vehicle_factor)) + 500
      
      expect(factor).to be_within(0.01).of(expected)
    end
  end

  describe '#copy_user_and_vehicle_data' do
    it 'copies user data on save' do
      request = build(:insurance_request, user: user, vehicle: vehicle)
      request.save!
      
      expect(request.email).to eq(user.email)
      expect(request.national_id).to eq(user.national_id)
      expect(request.birth_date).to eq(user.birth_date)
      expect(request.full_name).to eq("#{user.name} #{user.last_name}")
    end

    it 'copies vehicle plate number on save' do
      request = build(:insurance_request, user: user, vehicle: vehicle)
      request.save!
      
      expect(request.vehicle_plate_number).to eq(vehicle.plate_number)
    end

    it 'does not overwrite existing data' do
      request = build(:insurance_request, :with_custom_data, user: user, vehicle: vehicle)
      request.save!
      
      expect(request.email).to eq("custom@test.com")
      expect(request.vehicle_plate_number).to eq("CUSTOM-123")
    end
  end
end

