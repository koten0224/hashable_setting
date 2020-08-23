require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user){create(:user)}
  let(:reload_user){User.find(user.id)}
  let(:user_data){
    user_data = {
      data: {
        name: "Obama",
        gender: "male",
        age: 55,
        hobit: %w(guitar cat code coffee bear),
        balance: 11000000,
        status: "mad",
        address: {
          country: "Taiwan",
          city: "Taipei",
          region: "XinYi",
          Street: "DaAnRoad"
        },
        got_job?: true
      },
      family: {
        father: 'papa',
        mother: 'mama',
        status: 'rich'
      }
    }
  }
  let(:user_load_data){
    user.setting = user_data
    user.save
  }
  context 'model' do
    it 'should create a user.' do
      expect(user).to be_present
      expect(user).to be_is_a User
    end

    it { should have_many(:settings) }
  end
  context 'setting save and load' do
    it 'should save by hash and load success.' do
      user.setting = user_data
      expect(user.data.name).to eq('Obama')
      expect(user.family.father).to eq('papa')
      user.save
      p '='*300
      pp reload_user
      p '='*300
      expect(reload_user.data.name).to eq('Obama')
      expect(reload_user.family.father).to eq('papa')
      expect(reload_user.data.got_job?).to eq(true)
      expect(reload_user.data.hobit).to eq(%w(guitar cat code coffee bear))
    end

    it 'should save by open struct and load success.' do
      user.setting = open_struct_data
      expect(user.data.name).to eq('Obama')
      expect(user.family.father).to eq('papa')
      user.save
      expect(reload_user.data.name).to eq('Obama')
      expect(reload_user.family.father).to eq('papa')
      expect(reload_user.data.got_job?).to eq(true)
      expect(reload_user.data.hobit).to eq(%w(guitar cat code coffee bear))
    end

    it 'should assign a hash to update.' do
      user_load_data
      expect(user.data.name).to eq('Obama')
      expect(user.family.father).to eq('papa')
      user.setting = {
        data: {
          name: 'Olivia',
          gender: 'female',
          hobit: %w(coffee work)
        },
        family: {
          mother: 'mother'
        }
      }
      user.save
      expect(reload_user.data.name).to eq('Olivia')
      expect(reload_user.data.gender).to eq('female')
      expect(reload_user.data.hobit).to eq(%w(coffee work))
      expect(reload_user.family.mother).to eq('mother')
      expect(reload_user.family.father).to eq('papa')
    end
    
    it 'should assign an open struct to update.' do
      user_load_data
      expect(user.data.name).to eq('Obama')
      expect(user.family.father).to eq('papa')
      user.setting = OpenStruct.new(
        data: {
          name: 'Olivia',
          gender: 'female',
          hobit: %w(coffee work)
        },
        family: {
          mother: 'mother'
        }
      )
      user.save
      expect(reload_user.data.name).to eq('Olivia')
      expect(reload_user.data.gender).to eq('female')
      expect(reload_user.data.hobit).to eq(%w(coffee work))
      expect(reload_user.family.mother).to eq('mother')
      expect(reload_user.family.father).to eq('papa')
    end
    
    it 'should update success.' do
      user_load_data
      expect(user.data.name).to eq('Obama')
      expect(user.family.father).to eq('papa')
      user.data.name = 'Olivia'
      user.data.gender = 'female'
      user.family.mother = 'mother'
      user.save
      expect(reload_user.data.name).to eq('Olivia')
      expect(reload_user.data.gender).to eq('female')
      expect(reload_user.family.mother).to eq('mother')
      expect(reload_user.family.father).to eq('papa')
    end
  end
end
